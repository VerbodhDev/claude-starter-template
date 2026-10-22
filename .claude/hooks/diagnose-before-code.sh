#!/bin/bash
# PreToolUse:Edit/Write/MultiEdit hook — ADVISORY (never blocks).
#
# Why: the most expensive bug class is fixing a symptom at the wrong layer.
# Before writing code for a "X is broken / X shows nothing" report, the root
# cause should already be located by walking the pipeline seams and
# reproducing the failing baseline — not guessed from the symptom.
#
# Fires once per session (per-session dedup) when the first edit lands on a
# source-like file, so it nudges at the start of a coding session without
# spamming every edit. Pointer to the deeper discipline:
#   wiki/concepts/pipeline-and-deploy-reality.md
#
# Conventions (canonical for advisory hooks in this template):
#   - jq stdin parse for tool_input.file_path / session_id
#   - per-session dedup flag-file at /tmp/claude-diagnose-${session_id}
#   - warn to stderr, exit 0 (advisory — the tool proceeds)

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""' 2>/dev/null)
session_id=$(echo "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)

[ -z "$file_path" ] && exit 0

# Only source-like files (stack-agnostic — extend per project if needed).
case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.go|*.py|*.rs|*.java|*.rb|*.kt|*.swift|*.c|*.cc|*.cpp|*.cs|*.php|*.scala|*.ex|*.exs) : ;;
  *) exit 0 ;;
esac

flag="/tmp/claude-diagnose-${session_id}"
[ -f "$flag" ] && exit 0   # already nudged this session
touch "$flag" 2>/dev/null || true

cat >&2 <<'EOF'

┌─────────────────────────────────────────────────────────────────────────┐
│ 💡 [diagnose-before-code] ADVISORY — root cause before code?            │
│                                                                         │
│ Before writing the fix, confirm you have:                              │
│   ✓ Checked logs at EACH layer (producer → transport → store → API → UI)│
│   ✓ Reproduced the failing baseline (a real call / click / query)      │
│   ✓ Found the FIRST seam where the data/row count drops to zero         │
│   ✓ Separated symptom ("nothing on screen") from root cause            │
│                                                                         │
│ An empty/wrong UI is a symptom, never a diagnosis. Verify each seam,   │
│ not just the two ends. After fixing layer N, re-verify layer N+1 —     │
│ downstream bugs stay latent until the upstream one is fixed.            │
│                                                                         │
│ Discipline: wiki/concepts/pipeline-and-deploy-reality.md               │
└─────────────────────────────────────────────────────────────────────────┘
EOF

exit 0
