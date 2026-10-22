#!/bin/bash
# PreToolUse:Bash hook — ADVISORY (never blocks).
#
# Why: "merged / green build / exit 0" is routinely mistaken for "live in
# production". The costliest real incident behind this template was a
# deploy/migration step that ran from a STALE working copy, no-op'd, and
# was reported as "deployed" — when the running system was unchanged.
#
# When a command looks like a deploy / migration / "apply" step, this hook
# injects the deploy-reality checklist BEFORE it runs, so the applied-proof
# question gets asked at the moment it matters.
#
# CUSTOMIZE: tune DEPLOY_PATTERNS to your stack's actual deploy/migrate
# commands. The defaults cover the common ones; add yours, remove noise.
#
# Conventions: jq stdin parse for tool_input.command / session_id;
# per-session+per-keyword dedup; warn to stderr; exit 0 (advisory).

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)
session_id=$(echo "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)

[ -z "$command" ] && exit 0

# Generic deploy / migration / apply signals. Tune per project.
DEPLOY_PATTERNS='migrate|db push|db_push|prisma deploy|alembic upgrade|flyway|liquibase|terraform apply|pulumi up|helm upgrade|kubectl apply|kubectl rollout|ecs update-service|deploy\.sh|deploy\.py|serverless deploy|sls deploy|fly deploy|wrangler deploy|cdk deploy'

echo "$command" | grep -qiE "$DEPLOY_PATTERNS" || exit 0

# Dedup: once per session per matched keyword (keeps a deploy loop quiet).
key=$(echo "$command" | grep -oiE "$DEPLOY_PATTERNS" | head -1 | tr -c 'a-zA-Z0-9' '_')
dir="/tmp/claude-predeploy-${session_id}"
mkdir -p "$dir" 2>/dev/null || true
[ -f "$dir/$key" ] && exit 0
touch "$dir/$key" 2>/dev/null || true

cat >&2 <<'EOF'

┌─────────────────────────────────────────────────────────────────────────┐
│ ⚠  [predeploy-reality] ADVISORY — merged ≠ live                        │
│                                                                         │
│ This looks like a deploy / migration / apply step. Before trusting it: │
│                                                                         │
│  1. STALE-SOURCE: if this bakes/applies from your working copy, is the  │
│     working copy synced to merged mainline? (git fetch; confirm the     │
│     change is actually in the file/commit this step reads.)             │
│                                                                         │
│  2. READ THE OUTPUT LITERALLY: "already in sync" / "no changes" /       │
│     "nothing to do" / exit 0  ==  NOTHING CHANGED. An applied change    │
│     says so explicitly ("applied", "altered", "done in Nms").           │
│                                                                         │
│  3. APPLIED PROOF: running artifact digest/version == the new build's;  │
│     the endpoint/UI returns the NEW behaviour — not "I redeployed".     │
│                                                                         │
│  4. NEXT SEAM: after this lands, re-verify the layer DOWNSTREAM of it   │
│     — its bug was latent until this one was fixed.                      │
│                                                                         │
│ Discipline: wiki/concepts/pipeline-and-deploy-reality.md  (F4 / F5)     │
└─────────────────────────────────────────────────────────────────────────┘
EOF

exit 0
