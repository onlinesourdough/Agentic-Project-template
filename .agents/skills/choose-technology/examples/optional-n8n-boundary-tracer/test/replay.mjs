import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { unsupportedSchemaKeywords, validateJsonSchema } from "./json-schema.mjs";
import { createService, runMockWorkflow, validateRequest, validateResult } from "../service/service.mjs";

const here = new URL("../", import.meta.url);
const replayRequest = JSON.parse(await readFile(new URL("fixtures/replay-request.json", here)));
const replayResult = JSON.parse(await readFile(new URL("fixtures/replay-result.json", here)));
const digest = await readFile(new URL("workflow/n8n-workflow.digest.json", here), "utf8");
const requestSchema = JSON.parse(await readFile(new URL("schemas/request.schema.json", here)));
const resultSchema = JSON.parse(await readFile(new URL("schemas/result.schema.json", here)));

assert.equal(requestSchema.$schema, "https://json-schema.org/draft/2020-12/schema", "request schema is versioned");
assert.equal(resultSchema.$schema, "https://json-schema.org/draft/2020-12/schema", "result schema is versioned");
assert.deepEqual(unsupportedSchemaKeywords(requestSchema), [], "request schema uses only executed vocabulary");
assert.deepEqual(unsupportedSchemaKeywords(resultSchema), [], "result schema uses only executed vocabulary");
const assertRequestAgreement = (value, expected, message) => {
  assert.equal(validateJsonSchema(requestSchema, value).valid, expected, `${message}: schema`);
  assert.equal(validateRequest(value).ok, expected, `${message}: runtime`);
};
const assertResultAgreement = (value, expected, message) => {
  assert.equal(validateJsonSchema(resultSchema, value).valid, expected, `${message}: schema`);
  assert.equal(validateResult(value), expected, `${message}: runtime`);
};

assertRequestAgreement(replayRequest, true, "request schema accepts replay input");
assertRequestAgreement({ schemaVersion: "v1" }, false, "invalid input is denied");
const whitespaceRequest = {
  ...replayRequest,
  deliveryId: "delivery-whitespace-001",
  items: [{ itemId: "item-a", text: "   ", behavior: "ok" }]
};
assertRequestAgreement(whitespaceRequest, false, "whitespace-only input is denied");
assert.doesNotMatch(digest, /"credentials"\s*:|https?:\/\/|privateEndpoint|instanceIdentifier/i,
  "workflow digest is sanitized");

const replayOne = runMockWorkflow(createService(), replayRequest);
const replayTwo = runMockWorkflow(createService(), replayRequest);
assert.deepEqual(replayTwo, replayOne, "local replay is deterministic");
assert.equal(replayOne.route, "approval", "completed result reaches approval");
assertResultAgreement(replayResult, true, "result schema accepts expected result fixture");
assert.deepEqual(replayOne.response.result, replayResult, "service result matches expected result fixture");
assertResultAgreement(replayOne.response.result, true, "completed result matches the checked-in contract");
assertResultAgreement({ ...replayOne.response.result, outputs: [{ itemId: "item-a", normalizedText: "" }] }, false,
  "empty normalized text is denied by schema and runtime");

const duplicateService = createService();
const first = duplicateService.deliver(replayRequest);
const duplicate = duplicateService.deliver(replayRequest);
assert.equal(first.result.deduplicated, false, "first delivery is processed");
assert.equal(duplicate.result.deduplicated, true, "duplicate delivery is idempotent");
const conflictingRequest = {
  ...replayRequest,
  items: [{ itemId: "item-a", text: "Changed flour", behavior: "ok" }]
};
const conflict = duplicateService.deliver(conflictingRequest);
assert.equal(conflict.status, 409, "conflicting delivery ID has a stable status");
assert.equal(conflict.error.code, "DELIVERY_ID_CONFLICT", "conflicting delivery ID has a stable code");
assert.equal(conflict.error.retryable, false, "conflicting delivery ID is not retried");
const conflictRoute = runMockWorkflow(duplicateService, conflictingRequest);
assert.equal(conflictRoute.route, "error", "conflicting delivery ID reaches error route");
assert.equal(conflictRoute.reason, "conflict", "conflicting delivery ID remains visible to orchestration");

const retryRequest = { ...replayRequest, deliveryId: "delivery-retry-001" };
const retryService = createService();
const retried = runMockWorkflow(retryService, retryRequest, { attemptWorkMs: [20, 0] });
assert.equal(retried.route, "approval", "retry can recover from a timeout");
assert.equal(retried.attempts.length, 2, "retry count is bounded and visible");
assert.equal(retryService.deliver(retryRequest).result.deduplicated, true,
  "recovered delivery retains the same idempotency key");

const timedOut = runMockWorkflow(createService(), { ...replayRequest, deliveryId: "delivery-timeout-001" }, {
  attemptWorkMs: [20, 20, 0],
  maxAttempts: 9
});
assert.equal(timedOut.route, "error", "exhausted timeout reaches error route");
assert.equal(timedOut.reason, "timeout", "timeout reason remains visible");
assert.equal(timedOut.attempts.length, 2, "retry is capped at two attempts");

const partial = runMockWorkflow(createService(), {
  ...replayRequest,
  deliveryId: "delivery-partial-001",
  items: [{ itemId: "item-a", text: "Flour", behavior: "reject" }]
});
assert.equal(partial.route, "error", "partial result reaches error route");
assert.equal(partial.reason, "partial-failure", "partial failure stays visible");
assertResultAgreement(partial.response.result, true, "partial result matches the checked-in contract");

console.log("optional orchestration tracer: PASS");
