# Third-Party Integration Patterns

Use: Stripe, SendGrid, Auth0, OAuth2, inbound webhooks.

## Exponential backoff retry

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  { maxAttempts = 5, baseDelayMs = 200, maxDelayMs = 10_000 } = {}
): Promise<T> {
  let attempt = 0;
  while (true) {
    try {
      return await fn();
    } catch (err) {
      attempt++;
      if (attempt >= maxAttempts || !isRetryable(err)) throw err;
      const delay = Math.min(baseDelayMs * 2 ** (attempt - 1), maxDelayMs);
      const jitter = Math.random() * delay * 0.2;
      await new Promise((r) => setTimeout(r, delay + jitter));
    }
  }
}

function isRetryable(err: any): boolean {
  // Network errors, 429, and 5xx are retryable. 4xx (except 429) are not.
  const status = err?.response?.status ?? err?.status;
  if (!status) return true; // network-level failure
  return status === 429 || status >= 500;
}
```

## Circuit breaker

```typescript
class CircuitBreaker {
  private failures = 0;
  private state: "closed" | "open" | "half-open" = "closed";
  private nextAttempt = 0;

  constructor(
    private threshold = 5,
    private cooldownMs = 30_000
  ) {}

  async exec<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === "open") {
      if (Date.now() < this.nextAttempt) {
        throw new Error("CIRCUIT_OPEN: dependency unavailable, not attempting call");
      }
      this.state = "half-open";
    }
    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (err) {
      this.onFailure();
      throw err;
    }
  }

  private onSuccess() {
    this.failures = 0;
    this.state = "closed";
  }

  private onFailure() {
    this.failures++;
    if (this.failures >= this.threshold) {
      this.state = "open";
      this.nextAttempt = Date.now() + this.cooldownMs;
    }
  }
}
```

`CircuitBreaker` wraps `withRetry`. `withRetry` handles transient blips. `CircuitBreaker` stops dependency hammering.

## Webhook signature verification

Verify before parsing. Reject 401/400 before business logic.

### Stripe
```typescript
import Stripe from "stripe";
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

app.post("/webhooks/stripe", express.raw({ type: "application/json" }), (req, res) => {
  const sig = req.headers["stripe-signature"] as string;
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET!);
  } catch (err) {
    return res.status(400).json({ error: { code: "INVALID_SIGNATURE", message: "Webhook signature verification failed" } });
  }
  // Only now is it safe to switch on event.type and process the payload.
  res.status(200).send();
});
```
Requires raw body. Avoid global `express.json()`.

### SendGrid
```typescript
import { EventWebhook } from "@sendgrid/eventwebhook";

const ew = new EventWebhook();
const publicKey = ew.convertPublicKeyToECDSA(process.env.SENDGRID_WEBHOOK_PUBLIC_KEY!);

app.post("/webhooks/sendgrid", express.raw({ type: "application/json" }), (req, res) => {
  const signature = req.headers["x-twilio-email-event-webhook-signature"] as string;
  const timestamp = req.headers["x-twilio-email-event-webhook-timestamp"] as string;
  const isValid = ew.verifySignature(publicKey, req.body, signature, timestamp);
  if (!isValid) {
    return res.status(401).json({ error: { code: "INVALID_SIGNATURE", message: "SendGrid signature verification failed" } });
  }
  res.status(200).send();
});
```

### Auth0
```typescript
import crypto from "crypto";

function verifyHmacSignature(rawBody: Buffer, signatureHeader: string, secret: string): boolean {
  const expected = crypto.createHmac("sha256", secret).update(rawBody).digest("hex");
  // Constant-time compare — never use === on secrets/signatures.
  return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(signatureHeader));
}
```
Use HMAC for generic OAuth2/custom webhooks.

## OAuth2 token handling
- No access/refresh token logging.
- Encrypt refresh tokens at rest.
- Proactively refresh access tokens.