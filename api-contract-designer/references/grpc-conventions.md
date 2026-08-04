# gRPC/Proto
- 1 service per .proto. PascalCase svc/msg. snake_case field.
- Req/Res distinct msg. No bare scalars.
- Field # perm. Use `reserve`.
- Status: Standard gRPC codes. Use `google.rpc.Status` for detail.
- Version: `package.v1`. Break -> `package.v2`. No in-place field/type change.
- Stream: Unary default. Stream for real stream.
- Ex:
```protobuf
syntax = "proto3";
package myservice.v1;
import "google/protobuf/timestamp.proto";
service UserService {
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}
message User { string id = 1; string email = 2; google.protobuf.Timestamp created_at = 3; }
message CreateUserRequest { string email = 1; string name = 2; }
message CreateUserResponse { User user = 1; }
message ListUsersRequest { int32 page_size = 1; string page_token = 2; }
message ListUsersResponse { repeated User users = 1; string next_page_token = 2; }
```
- Valid: Interceptors.