It's OK if you don't know. Just say so rather than giving me answers you made up.

# Core Rules

## Anti-Over-Engineering

Only make changes directly requested. No cleanup, no extra configurability, no helpers for one-time ops, no hypothetical future-proofing. Minimum complexity for current task.

No speculative code: no error handling, fallbacks, or validation for impossible scenarios. Trust internal code and framework guarantees. Only validate at system boundaries.

## LSP

Before modifying any Go or TypeScript function/type/interface, use LSP to check references, definitions, and call hierarchy. Don't rely solely on grep or ripgrep.

## TypeScript

No unnecessary `try`/`catch`. No `any` casts.
