#!/usr/bin/env python3
import sys, json, re

try:
    d = json.load(sys.stdin)
except Exception:
    print('{"decision":"approve"}')
    sys.exit(0)

tool_name = d.get("tool_name", "")

if tool_name == "Grep":
    print('{"decision":"block","reason":"Grep tool blocked. Use rg (ripgrep) or ast-grep via Bash instead."}')
    sys.exit(0)

if tool_name == "Bash":
    cmd = d.get("tool_input", {}).get("command", "")
    if re.search(r'(?:^|[|;&\s])grep\s', cmd):
        print('{"decision":"block","reason":"grep blocked. Use rg (ripgrep) or ast-grep instead."}')
        sys.exit(0)

print('{"decision":"approve"}')
