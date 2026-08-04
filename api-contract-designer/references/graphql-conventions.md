# GraphQL Conventions

## Schema design
- Types: PascalCase singular (`User`, `Order`). Fields: camelCase.
- Mutations: Single `input` object (`<MutationName>Input`) + `<MutationName>Payload` return type. No bare scalars.
- Nullability: Non-nullable (`!`) by default. Nullable for genuine optionality.

## Error handling
Use typed error unions for expected failures (validation, not-found, conflict). Reserve thrown errors for exceptional/unauthenticated cases.

```graphql
type CreateOrderPayload {
  order: Order
  errors: [UserError!]!
}

type UserError {
  code: ErrorCode!
  message: String!
  field: String
}

enum ErrorCode {
  VALIDATION_ERROR
  NOT_FOUND
  CONFLICT
  FORBIDDEN
}
```
Client checks `errors` array; `order` is null if errors present.

## Pagination
Relay-style cursor connections for growing lists:

```graphql
type OrderConnection {
  edges: [OrderEdge!]!
  pageInfo: PageInfo!
}

type OrderEdge {
  node: Order!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type Query {
  orders(first: Int, after: String, last: Int, before: String): OrderConnection!
}
```

## Input validation
Validate semantic rules (format, length, business logic) in resolver (e.g., Zod/Joi/Yup). Return `UserError`s for expected failures.

## Versioning
Additive evolution. Use `@deprecated(reason: "...")` for removals. Never change field type or nullability without breaking changes.

## Example

```graphql
type User {
  id: ID!
  email: String!
  createdAt: String!
  orders(first: Int, after: String): OrderConnection!
}

input CreateUserInput {
  email: String!
  name: String!
}

type CreateUserPayload {
  user: User
  errors: [UserError!]!
}

type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
}