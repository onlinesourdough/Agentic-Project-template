const deliveryIdPattern = /^[a-z][a-z0-9-]{2,63}$/;
const itemIdPattern = /^[a-z][a-z0-9-]{0,31}$/;

function clone(value) {
  return JSON.parse(JSON.stringify(value));
}

function error(status, code, message, retryable = false) {
  return { ok: false, status, error: { code, message, retryable } };
}

function canonicalRequest(request) {
  return JSON.stringify({
    schemaVersion: request.schemaVersion,
    deliveryId: request.deliveryId,
    operation: request.operation,
    items: request.items.map(({ itemId, text, behavior }) => ({ itemId, text, behavior }))
  });
}

export function validateRequest(value) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return error(400, "INVALID_REQUEST", "request must be an object");
  }
  const keys = Object.keys(value).sort().join(",");
  if (keys !== "deliveryId,items,operation,schemaVersion") {
    return error(400, "INVALID_REQUEST", "request fields are not allowed");
  }
  if (value.schemaVersion !== "v1" || value.operation !== "normalize") {
    return error(400, "INVALID_REQUEST", "unsupported schema or operation");
  }
  if (typeof value.deliveryId !== "string" || !deliveryIdPattern.test(value.deliveryId)) {
    return error(400, "INVALID_REQUEST", "deliveryId is invalid");
  }
  if (!Array.isArray(value.items) || value.items.length < 1 || value.items.length > 4) {
    return error(400, "INVALID_REQUEST", "items must contain one to four entries");
  }
  for (const item of value.items) {
    if (!item || typeof item !== "object" || Array.isArray(item) ||
      Object.keys(item).sort().join(",") !== "behavior,itemId,text" ||
      typeof item.itemId !== "string" || !itemIdPattern.test(item.itemId) ||
      typeof item.text !== "string" || item.text.length < 1 || item.text.length > 80 ||
      !/\S/.test(item.text) ||
      !["ok", "reject"].includes(item.behavior)) {
      return error(400, "INVALID_REQUEST", "item is invalid");
    }
  }
  return { ok: true, value: clone(value) };
}

export function validateResult(value) {
  if (!value || typeof value !== "object" || Array.isArray(value) ||
    Object.keys(value).sort().join(",") !==
      "deduplicated,deliveryId,failures,outputs,schemaVersion,status" ||
    value.schemaVersion !== "v1" || !deliveryIdPattern.test(value.deliveryId) ||
    !["completed", "partial"].includes(value.status) ||
    typeof value.deduplicated !== "boolean" || !Array.isArray(value.outputs) ||
    !Array.isArray(value.failures)) {
    return false;
  }
  const validOutput = (output) => output && typeof output === "object" &&
    !Array.isArray(output) && Object.keys(output).sort().join(",") === "itemId,normalizedText" &&
    typeof output.itemId === "string" && itemIdPattern.test(output.itemId) &&
    typeof output.normalizedText === "string" && output.normalizedText.length > 0 &&
    output.normalizedText.length <= 80;
  const validFailure = (failure) => failure && typeof failure === "object" &&
    !Array.isArray(failure) && Object.keys(failure).sort().join(",") === "code,itemId" &&
    typeof failure.itemId === "string" && itemIdPattern.test(failure.itemId) &&
    failure.code === "ITEM_REJECTED";
  if (!value.outputs.every(validOutput) || !value.failures.every(validFailure)) return false;
  return value.status === "completed" ? value.failures.length === 0 : value.failures.length > 0;
}

export function createService({ timeoutMs = 10 } = {}) {
  const completed = new Map();

  function deliver(rawRequest, { simulatedWorkMs = 0 } = {}) {
    const checked = validateRequest(rawRequest);
    if (!checked.ok) return checked;

    const request = checked.value;
    const requestKey = canonicalRequest(request);
    const cached = completed.get(request.deliveryId);
    if (cached) {
      if (cached.requestKey !== requestKey) {
        return error(409, "DELIVERY_ID_CONFLICT", "deliveryId was already used with a different request");
      }
      return { ok: true, status: 200, result: { ...clone(cached.result), deduplicated: true } };
    }
    if (!Number.isFinite(simulatedWorkMs) || simulatedWorkMs < 0 || simulatedWorkMs > timeoutMs) {
      return error(504, "TIMEOUT", "service processing exceeded the bounded timeout", true);
    }

    const outputs = [];
    const failures = [];
    for (const item of request.items) {
      if (item.behavior === "reject") {
        failures.push({ itemId: item.itemId, code: "ITEM_REJECTED" });
      } else {
        outputs.push({ itemId: item.itemId, normalizedText: item.text.trim().toLowerCase() });
      }
    }
    const result = {
      schemaVersion: "v1",
      deliveryId: request.deliveryId,
      status: failures.length ? "partial" : "completed",
      deduplicated: false,
      outputs,
      failures
    };
    completed.set(request.deliveryId, { requestKey, result: clone(result) });
    return { ok: true, status: 200, result };
  }

  return { deliver };
}

export function runMockWorkflow(service, request, { attemptWorkMs = [], maxAttempts = 2 } = {}) {
  const boundedAttempts = Math.min(Math.max(1, maxAttempts), 2);
  const attempts = [];
  for (let attempt = 1; attempt <= boundedAttempts; attempt += 1) {
    const response = service.deliver(request, {
      simulatedWorkMs: attemptWorkMs[attempt - 1] ?? 0
    });
    attempts.push({ attempt, status: response.status, code: response.error?.code ?? null });
    if (!response.ok) {
      if (response.error.code === "TIMEOUT") {
        if (attempt < boundedAttempts) continue;
        return { route: "error", reason: "timeout", attempts, response };
      }
      return {
        route: "error",
        reason: response.error.code === "DELIVERY_ID_CONFLICT" ? "conflict" : "invalid-input",
        attempts,
        response
      };
    }
    if (response.result.status === "partial") {
      return { route: "error", reason: "partial-failure", attempts, response };
    }
    return { route: "approval", attempts, response };
  }
  return { route: "error", reason: "timeout", attempts };
}
