# External backend profile

Choose this profile when the product requires Python or FastAPI, specialist
compute, an existing database, a separately operated data platform, or an
independently deployed service.

## Minimum capabilities

- TypeScript frontend using stable contracts
- explicit HTTP API between frontend and backend
- GitHub Actions CI for the frontend
- backend-owned deployment and operational documentation

## Expected frontend scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "typecheck": "tsc -b",
    "test": "vitest run",
    "build": "vite build"
  }
}
```

The profile copies CI but no generic deployment workflow. A pretend universal
workflow would hide real choices about containers, regions, migrations,
credentials, callbacks, and rollback.

## Boundaries

- shared DTOs and schemas define the frontend/backend contract
- API clients live in feature hooks or HTTP adapters
- the backend owns persistence, background work, and specialist runtime details
- external inputs are validated independently on both sides of the boundary
- contract, integration, and end-to-end tests cover compatibility
- deployment ownership, monitoring, and rollback are explicit

Do not duplicate backend domain types directly into presentational components.
