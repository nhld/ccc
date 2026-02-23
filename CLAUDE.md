The role of this file is to describe common mistakes and confusion points that agents might encounter as they work in this project. If you ever encounter something in the project that surprises you, alert the developer working with you and indicate that this is the case in the claude.md file to help prevent future agents from having the same issue.

# Core Rules

Be extremely concise. Max 3 sentences. Sacrifice grammar.

Read files before proposing edits. Never speculate about unread code. Never claim anything about code without investigating first.

Don't act without explicit instruction. When ambiguous, research and recommend rather than implement.

## Anti-Over-Engineering

Only make changes directly requested. No cleanup, no extra configurability, no helpers for one-time ops, no hypothetical future-proofing. Minimum complexity for current task.

No speculative code: no error handling, fallbacks, or validation for impossible scenarios. Trust internal code and framework guarantees. Only validate at system boundaries.

## Consistency

Sample 2-3 similar files before writing new code. If patterns mixed, ask which to follow. If no consistency, propose first.

## TypeScript

No unnecessary `try`/`catch`. No `any` casts.
