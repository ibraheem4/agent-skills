---
name: api-and-interface-design
description: Use when designing APIs, module interfaces, or public contracts. Define the interface before the implementation.
---

# API and Interface Design

## Overview

Design the interface first — function signatures, request/response shapes, error codes — before writing any implementation. Good interfaces are small, consistent, and hard to misuse.

Follows Stripe's API design principles: consistent resource structure, predictable error responses with `type`/`code`/`message`/`param`, idempotency keys on mutating operations, and cursor-based pagination. Stripe's API is the industry gold standard because every endpoint behaves the same way.

## When to Use

- Creating a new API endpoint or service
- Designing a module's public interface
- Building a library or SDK

## Core Process

### 1. Define the Consumer

Who calls this? What do they need? Write example usage before the implementation:

```typescript
// How a consumer SHOULD use this:
const user = await userService.getById("user-123");
const tasks = await taskService.listByUser(user.id, { status: "active" });
```

### 2. Design the Contract

Define inputs, outputs, and errors:

```typescript
interface TaskService {
  create(input: CreateTaskInput): Promise<Task>;
  getById(id: string): Promise<Task>;           // throws NotFoundError
  listByUser(userId: string, filter?: TaskFilter): Promise<Task[]>;
  update(id: string, patch: Partial<Task>): Promise<Task>;
  delete(id: string): Promise<void>;
}
```

### 3. Apply Design Principles

- **Consistent naming** — Same patterns everywhere (get/list/create/update/delete)
- **Minimal surface** — Expose only what consumers need
- **Hard to misuse** — Required params are required, not optional with runtime checks
- **Predictable errors** — Documented error types, not generic throws

### 4. Review Before Implementing

Share the interface with a consumer (or review as one). Is it intuitive? Are edge cases handled?

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I'll refine the API as I build" | Consumers depend on your interface. Changes break them |
| "It's internal, nobody else uses it" | Internal APIs become external APIs. Future you is a consumer |
| "I need to see the implementation first" | If you can't define the interface without the implementation, the abstraction is wrong |

## Verification

- [ ] Interface designed before implementation started
- [ ] Consumer usage examples exist
- [ ] Error cases are documented
- [ ] Naming is consistent across all methods
- [ ] No unnecessary parameters or return fields
