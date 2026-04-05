---
name: security-and-hardening
description: Use when reviewing code for security vulnerabilities. OWASP-aligned checklist for common attack vectors.
---

# Security and Hardening

## Overview

Check code for the most common security vulnerabilities. Follows the DevSecOps shift-left approach from [Microsoft's SDL](https://www.microsoft.com/en-us/securityengineering/sdl/) — integrate security checks into the development process, not after it. For architectural-level security analysis, use the [threat-modeling](../threat-modeling/) skill with STRIDE.

## When to Use

- Reviewing code that handles user input
- Working with authentication, authorization, or secrets
- Building API endpoints or form handlers
- Before shipping to production

## Core Process

### 1. Input Validation

Every external input must be validated before use:

| Vector | Check |
|--------|-------|
| SQL Injection | Parameterized queries only. Never string concatenation |
| XSS | Output encoding. No `dangerouslySetInnerHTML` or `innerHTML` without sanitization |
| Command Injection | No `exec()` or `spawn()` with user input. Use allowlists |
| Path Traversal | Normalize paths. Reject `..` sequences. Use allowlisted directories |
| SSRF | Validate URLs against allowlist. No user-controlled fetch targets |

### 2. Authentication & Authorization

- [ ] Auth checks on every protected route (not just the UI)
- [ ] Tokens have expiry and rotation
- [ ] Passwords hashed with bcrypt/scrypt/argon2 (never MD5/SHA)
- [ ] Session tokens are HttpOnly, Secure, SameSite
- [ ] Authorization checks use deny-by-default

### 3. Secrets Management

- [ ] No hardcoded secrets, API keys, or passwords in source
- [ ] Secrets loaded from environment variables or secret manager
- [ ] `.env` files in `.gitignore`
- [ ] No secrets logged or included in error responses
- [ ] No secrets in client-side bundles

### 4. Dependencies

- [ ] No known critical CVEs in dependencies
- [ ] Lock file committed and up to date
- [ ] No unnecessary dependencies (smaller surface area)

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "It's an internal tool" | Internal tools get exposed. Attackers exploit internal tools after initial access |
| "The framework handles it" | Frameworks provide tools, not guarantees. You must use them correctly |
| "We'll add security later" | Security debt compounds. A vulnerability shipped is a vulnerability exploited |
| "Nobody would do that" | Automated scanners try everything. "Nobody" includes bots |

## Red Flags

- Raw SQL string concatenation
- User input rendered without encoding
- Hardcoded credentials or API keys
- Missing auth middleware on API routes
- `eval()` or `Function()` with external input
- Overly permissive CORS (`*` origin in production)

## Verification

- [ ] All user inputs are validated and sanitized
- [ ] No secrets in source code, logs, or client bundles
- [ ] Auth checks exist on every protected endpoint
- [ ] Dependencies have no known critical vulnerabilities
- [ ] Error responses don't leak internal details or stack traces
