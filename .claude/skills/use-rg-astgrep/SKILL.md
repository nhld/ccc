---
name: use-rg-astgrep
description: >
  Governs all file and code search behavior. Use this skill whenever any
  search is involved: finding text in files, locating function definitions,
  tracing imports, searching for variable names, pattern matching across
  a codebase, or any task where grep would normally be reached for.
  grep and the Grep tool are blocked by a system hook — this skill provides
  the correct replacements. Trigger even when search is incidental to a
  larger task (e.g., "find and replace X" or "where is Y defined").
---

grep is blocked at the system level. Use `rg` (ripgrep) for text/regex searches, `ast-grep` for structural code searches.

## Which tool fits

**rg** — when you're matching text or regex patterns: strings, variable names, comments, config values, imports by module path.

**ast-grep** — when the *shape* of the code matters: finding a function call with specific arguments, declarations of a certain type, import patterns. Text search would produce false positives here because it doesn't understand syntax boundaries.

If unsure, start with `rg`. Switch to `ast-grep` if you're getting noise from comments, strings, or partial matches.

## rg

```bash
rg "pattern"                       # search entire repo
rg "pattern" src/                  # limit to directory
rg -t ts "pattern"                 # TypeScript files only (-t py, -t go, -t rust, etc.)
rg -l "pattern"                    # list matching filenames only
rg -i "pattern"                    # case-insensitive
rg -w "word"                       # whole-word match
rg -n "pattern"                    # show line numbers (on by default)
rg -A 3 -B 1 "pattern"             # 3 lines after, 1 before (context)
rg --no-heading -H "pattern"       # compact format, good for piping
rg "pattern" -g "*.json"           # glob filter
rg "pattern" --hidden              # include dotfiles
rg -e "foo" -e "bar"               # multiple patterns (OR)
```

## ast-grep

ast-grep understands syntax trees, so it matches code structure rather than raw text.

```bash
# Function calls
ast-grep --pattern 'console.log($A)' src/
ast-grep --pattern 'expect($A).toBe($B)' --lang ts

# Imports
ast-grep --pattern 'import $X from "$Y"' --lang ts
ast-grep --pattern 'from $MODULE import $NAME' --lang py

# Function/method definitions
ast-grep --pattern 'function $NAME($$$) { $$$ }' --lang js
ast-grep --pattern 'async $METHOD($$$) { $$$ }' --lang ts
ast-grep --pattern 'def $NAME($$$):' --lang py
ast-grep --pattern 'fn $NAME($$$) -> $T { $$$ }' --lang rust

# Variable declarations
ast-grep --pattern 'const $NAME = $VALUE' --lang ts
```

**Metavariables:**
- `$NAME` — any single node (identifier, expression, literal)
- `$$$` — zero or more nodes (use for argument lists, body blocks)
- `$_` — any single node, unnamed (wildcard)

## grep → rg

| grep | rg |
|---|---|
| `grep -r "foo" .` | `rg "foo"` |
| `grep -rl "foo" .` | `rg -l "foo"` |
| `grep -rn "foo" .` | `rg -n "foo"` |
| `grep -ri "foo" .` | `rg -i "foo"` |
| `grep -rw "foo" .` | `rg -w "foo"` |
| `grep -r --include="*.ts"` | `rg -t ts` or `rg -g "*.ts"` |
| `grep -E "a\|b"` | `rg "a\|b"` (ERE default) |
| structural pattern | `ast-grep --pattern '...' --lang X` |
