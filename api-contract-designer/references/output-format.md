# Output Format: Example
3 Deliverables:
1. Spec (OpenAPI)
2. Implementation (Express+Zod)
3. Client Types (TS)

## 1. Spec (OpenAPI)
```yaml
paths:
  /api/v1/orders/{orderId}/cancel:
    post:
      summary: Cancel order
      operationId: cancelOrder
      parameters:
        - name: orderId
          in: path
          required: true
          schema: {type: string}
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema: {type: object, properties: {data: {$ref: '#/components/schemas/Order'}}}
        '404': {$ref: '#/components/responses/NotFound'}
        '409':
          description: Conflict
          content:
            application/json:
              schema: {$ref: '#/components/schemas/Error'}
components:
  schemas:
    Order:
      type: object
      required: [id, status, total, createdAt]
      properties:
        id: {type: string}
        status: {type: string, enum: [pending, shipped, cancelled]}
        total: {type: number}
        createdAt: {type: string, format: date-time}
```

## 2. Implementation (Express+Zod)
```typescript
import { z } from "zod";
import { Router } from "express";
const router = Router();
const paramsSchema = z.object({ orderId: z.string().min(1) });
router.post("/api/v1/orders/:orderId/cancel", async (req, res) => {
  const parsed = paramsSchema.safeParse(req.params);
  if (!parsed.success) return res.status(400).json({
    error: { code: "VALIDATION_ERROR", message: "Invalid params", details: parsed.error.issues.map(i => ({ field: i.path.join("."), issue: i.message })) }
  });
  const { orderId } = parsed.data;
  const order = await ordersRepo.findById(orderId);
  if (!order) return res.status(404).json({ error: { code: "NOT_FOUND", message: `Order ${orderId} not found` } });
  if (order.status !== "pending") return res.status(409).json({ error: { code: "CONFLICT", message: `Order status: ${order.status}` } });
  const cancelled = await ordersRepo.cancel(orderId);
  return res.status(200).json({ data: cancelled });
});
export default router;
```

## 3. Client Types (TS)
```typescript
export type OrderStatus = "pending" | "shipped" | "cancelled";
export interface Order { id: string; status: OrderStatus; total: number; createdAt: string; }
export interface ApiErrorDetail { field: string; issue: string; }
export interface ApiError { error: { code: string; message: string; details?: ApiErrorDetail[]; }; }
export interface CancelOrderResponse { data: Order; }
export async function cancelOrder(orderId: string): Promise<Order> {
  const res = await fetch(`/api/v1/orders/${orderId}/cancel`, { method: "POST" });
  const body = await res.json();
  if (!res.ok) {
    const err = body as ApiError;
    throw new Error(`${err.error.code}: ${err.error.message}`);
  }
  return (body as CancelOrderResponse).data;
}
```

## Layout
If >1-2 endpoints, use files:
api/
  openapi.yaml
  handlers/
  types/
Place `api/` near docs.