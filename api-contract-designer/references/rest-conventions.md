# REST / OpenAPI Conventions

## URI conventions
- Collections plural: `/users`, `/orders`
- Nesting true ownership only: `/users/{userId}/orders`, max 2 levels deep
- Non-CRUD: sub-resources/verbs: `POST /orders/{id}/cancel`, not `PATCH` with status trick
- Query params filter/sort/page: `?status=active&sort=-createdAt&limit=20&cursor=...`

## Status codes
| Code | Use |
|---|---|
| 200 | GET/PATCH/PUT success with body |
| 201 | POST success, resource created (include `Location` header) |
| 204 | DELETE/action success, no body |
| 400 | Malformed request (bad JSON, wrong types) |
| 401 | Missing/invalid authentication |
| 403 | Authenticated, not authorized |
| 404 | Resource doesn't exist |
| 409 | Conflict (duplicate, version mismatch) |
| 422 | Semantically invalid (validation failed) |
| 500 | Unhandled server error |

## Standard response envelope

Success:
```json
{
  "data": { "id": "usr_123", "name": "Ada Lovelace" },
  "meta": { "requestId": "req_abc123" }
}
```

Collection, cursor pagination:
```json
{
  "data": [ { "id": "usr_123" }, { "id": "usr_124" } ],
  "meta": {
    "nextCursor": "eyJpZCI6InVzcl8xMjQifQ==",
    "hasMore": true
  }
}
```

Error (non-2xx shape):
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request failed validation",
    "details": [
      { "field": "email", "issue": "must be a valid email address" }
    ]
  }
}
```

## Pagination
- **Cursor-based default** (unbounded/changing feeds, logs, orders). Use opaque base64 cursor. No raw offsets.
- **Limit/offset** only for small/stable/rarely-changing collections (e.g. admin lookup tables).
- Include `limit` (default + max enforced server-side). Return `hasMore`.

## Rate limiting headers
Include on every response when rate limiting applies:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1712345678
```
429: same headers + `Retry-After` (seconds).

## Versioning
- Path-based (`/api/v1/...`) default recommendation: visible, cacheable, simple routing.
- Header-based (`Accept: application/vnd.company.v2+json`) if docs use pattern/ask.
- Breaking change = new major version. Additive changes (new optional field, new endpoint) no version bump.

## OpenAPI skeleton to build from

```yaml
openapi: 3.0.3
info:
  title: <Service Name> API
  version: 1.0.0
servers:
  - url: https://api.example.com/v1
paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      parameters:
        - name: limit
          in: query
          schema: { type: integer, default: 20, maximum: 100 }
        - name: cursor
          in: query
          schema: { type: string }
      responses:
        '200':
          description: A page of users
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items: { $ref: '#/components/schemas/User' }
                  meta:
                    type: object
                    properties:
                      nextCursor: { type: string, nullable: true }
                      hasMore: { type: boolean }
        '401':
          $ref: '#/components/responses/Unauthorized'
components:
  schemas:
    User:
      type: object
      required: [id, email, createdAt]
      properties:
        id: { type: string }
        email: { type: string, format: email }
        createdAt: { type: string, format: date-time }
    Error:
      type: object
      required: [error]
      properties:
        error:
          type: object
          required: [code, message]
          properties:
            code: { type: string }
            message: { type: string }
            details:
              type: array
              items:
                type: object
                properties:
                  field: { type: string }
                  issue: { type: string }
  responses:
    Unauthorized:
      description: Missing or invalid authentication
      content:
        application/json:
          schema: { $ref: '#/components/schemas/Error' }
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
security:
  - bearerAuth: []
```

See `output-format.md` for matching handler + client type output.