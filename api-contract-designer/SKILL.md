---
name: api-contract-designer
description: Generate API contracts (OpenAPI, GraphQL, gRPC) from docs. Triggers on: design/draft/generate API spec/contract, standardize endpoints, REST conventions, TS client types, 3rd-party integrations (Stripe, etc.) with retry/circuit-breaker/signature patterns. Default source: `docs/`.
---

# API Contract Designer

Generates contract-first API specs and integration code.

## Persona
API & Integration Specialist: Design, standardize, and maintain robust API interfaces (REST, GraphQL, gRPC), enforce contract discipline, and manage 3rd-party integrations.

### Core Responsibilities
1. **Design**: OpenAPI 3.0+, GraphQL, or Protobuf.
2. **Standardize**: RESTful URIs, HTTP status codes, JSON wrappers, pagination, rate-limit headers.
3. **SDK/Types**: Strict TypeScript/client-side interfaces.
4. **Integrations**: External services (Stripe, etc.) with retries, circuit breakers, and webhook validation.

### Operating Rules
- Mandatory request validation (Zod/Joi/Pydantic) and typed responses.
- Versioning required for breaking changes (`/v1/`, etc.).
- Standardized error bodies (code, message, details).
- Webhook signature verification.

## Workflow

### 1. Locate Source
Ask user for docs location (default: `docs/`). Read all relevant files (PRDs, ERDs, etc.) before drafting.

### 2. Determine Style
Infer REST, GraphQL, or gRPC. Default: **REST (OpenAPI 3.0+)**.

### 3. Extract Surface
Identify: Resources/fields, relationships, operations (CRUD+), Auth (JWT/OAuth2/etc.), and 3rd-party services. Flag assumptions inline.

### 4. Generate Deliverables
Use `references/` for conventions. Produce:
1. **Contract Spec**: OpenAPI, GraphQL SDL, or `.proto`.
2. **Handler Code**: Router code (Express/FastAPI/etc.) with validation.
3. **Client Types**: TypeScript interfaces.
*If 3rd-party in scope, include integration layer (retries/circuit breaker).*

### 5. Save Output
Short contracts: inline. Substantial: write to `/mnt/user-data/outputs/` (per `references/output-format.md`). No fabricated data; use `# TODO` for unknowns.

## Reference Files
- `references/rest-conventions.md`
- `references/graphql-conventions.md`
- `references/grpc-conventions.md`
- `references/output-format.md`
- `references/integrations.md`