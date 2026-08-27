function equalJson(left, right) {
  return JSON.stringify(left) === JSON.stringify(right);
}

function matchesType(value, type) {
  if (type === "array") return Array.isArray(value);
  if (type === "object") return value !== null && typeof value === "object" && !Array.isArray(value);
  return typeof value === type;
}

const supportedKeywords = new Set([
  "$schema", "$id", "title", "type", "additionalProperties", "required", "properties",
  "const", "enum", "pattern", "minLength", "maxLength", "minItems", "maxItems", "items"
]);

export function unsupportedSchemaKeywords(schema, path = "$") {
  const errors = Object.keys(schema)
    .filter((keyword) => !supportedKeywords.has(keyword))
    .map((keyword) => `${path}: unsupported keyword ${keyword}`);
  for (const [key, propertySchema] of Object.entries(schema.properties ?? {})) {
    errors.push(...unsupportedSchemaKeywords(propertySchema, `${path}.properties.${key}`));
  }
  if (schema.items) errors.push(...unsupportedSchemaKeywords(schema.items, `${path}.items`));
  return errors;
}

// This evaluator intentionally implements only the JSON Schema keywords used
// by this fixture. Keeping it test-local makes the checked-in schemas
// executable without adding a generated Project dependency.
export function validateJsonSchema(schema, value, path = "$") {
  const errors = [];
  const add = (message) => errors.push(`${path}: ${message}`);

  if (schema.type && !matchesType(value, schema.type)) {
    add(`must be ${schema.type}`);
    return { valid: false, errors };
  }
  if (Object.hasOwn(schema, "const") && !equalJson(value, schema.const)) add("must equal const");
  if (schema.enum && !schema.enum.some((option) => equalJson(value, option))) add("must match enum");
  if (typeof value === "string") {
    if (schema.minLength !== undefined && value.length < schema.minLength) add("is shorter than minLength");
    if (schema.maxLength !== undefined && value.length > schema.maxLength) add("is longer than maxLength");
    if (schema.pattern && !new RegExp(schema.pattern).test(value)) add("does not match pattern");
  }
  if (Array.isArray(value)) {
    if (schema.minItems !== undefined && value.length < schema.minItems) add("has fewer than minItems");
    if (schema.maxItems !== undefined && value.length > schema.maxItems) add("has more than maxItems");
    if (schema.items) {
      value.forEach((item, index) => {
        const nested = validateJsonSchema(schema.items, item, `${path}[${index}]`);
        errors.push(...nested.errors);
      });
    }
  }
  if (matchesType(value, "object")) {
    const properties = schema.properties ?? {};
    for (const required of schema.required ?? []) {
      if (!Object.hasOwn(value, required)) add(`is missing ${required}`);
    }
    if (schema.additionalProperties === false) {
      for (const key of Object.keys(value)) {
        if (!Object.hasOwn(properties, key)) add(`does not allow ${key}`);
      }
    }
    for (const [key, propertySchema] of Object.entries(properties)) {
      if (Object.hasOwn(value, key)) {
        const nested = validateJsonSchema(propertySchema, value[key], `${path}.${key}`);
        errors.push(...nested.errors);
      }
    }
  }
  return { valid: errors.length === 0, errors };
}
