---
name: secure-solution
description: Review and harden trust boundaries, authentication, authorization, tenant isolation, secrets, sensitive data, external input, dependencies, workflows, and runtime AI. Use when a change crosses trust levels, handles identity or private data, performs side effects, exposes an API, changes CI/deployment permissions, or needs a security review.
---

# Secure Solution

Apply security in proportion to consequence and make denial behavior explicit.

## Model the change

1. Identify actors, assets, entrypoints, trust boundaries, data sensitivity,
   side effects, and likely abuse.
2. Name the identity, data, platform, and incident owners.
3. Prioritize plausible high-impact threats over a generic checklist.
4. Define preventive control, detection, and recovery for each material threat.

## Baseline

- Treat clients, webhooks, files, URLs, workflow payloads, and model output as
  untrusted.
- Runtime-validate input and bound size, rate, duration, and resource use.
- Separate authentication from authorization; resolve actor and tenant from a
  trusted source and default to denial.
- Enforce private and paid access server-side.
- Keep secrets in platform stores, out of code, logs, exports, build output, and
  client bundles; support rotation.
- Minimize collected data, access, retention, and response fields.
- Redact credentials, tokens, personal data, and internal errors from logs.
- Use maintained platform cryptography and identity libraries; do not invent
  them.
- Restrict outbound requests and redirects when users influence URLs.
- Pin and review dependencies; scan manifests, images, workflows, and history
  according to risk.
- Give CI and runtime credentials least privilege. Pin third-party GitHub
  Actions to reviewed full commit SHAs and prefer short-lived OIDC credentials
  where supported.

For runtime AI, bound context and tools, validate structured output, keep
authorization and irreversible policy deterministic, require approval where
consequence demands it, and provide evaluation, audit, cost limit, and kill
switch.

## Verify

Test valid access, denial, tenant separation, malformed input, replay,
duplicates, secret absence, dependency failure, and recovery through the real
boundary. Do not label a solution “secure” from a dependency scan alone.

Use current [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
and [OWASP Cheat Sheets](https://owasp.org/www-project-cheat-sheets/) for
high-risk or unfamiliar controls instead of embedding a stale universal list.
