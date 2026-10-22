# Ready to Code Gate

Before any non-trivial code change, answer eight questions in this conversation.
This forces explicit thinking before edits and prevents the "I'll figure it out
while coding" failure mode.

## Rule

Answer ALL eight questions BEFORE invoking Edit / Write / MultiEdit.
A test that reproduces the bug must exist BEFORE the fix is written.

### Resume-from-compaction gate (blocking)

If the session context was compacted or you are resuming from a prior session
summary, run these three checks **before** touching any file. A summary is a
lossy compression — do not trust it over the live tree:

```bash
git status --porcelain && git diff --stat   # real working-tree state
wc -l <file-you-intend-to-edit>             # confirm size vs your mental model
# Open and read the FULL extent of the block you plan to replace
# (the closing tag/brace, not just the opening one).
```

A 30-second state check prevents stale-render leakage (an edit that matches
only the opening of a block while the old body leaks through underneath).

## The eight questions

1. **Done state** — What is concretely true when this is finished? (Not "it
   works" — name the observable behaviour.)

2. **Verification gate** — What test, curl, or visual check proves it's done?
   Run it FIRST against current code to confirm the failing baseline.

3. **Blast radius** — What could break? Which files, services, or workflows
   does this touch? How many call-sites?

4. **Scope boundary** — What is explicitly OUT of scope? Drift here is the
   #1 cause of "small fix" turning into a 200-line PR.

5. **Rollback plan** — If this ships and breaks production, how do we revert?
   Single commit revert? Feature flag? Database migration roll-back?

6. **Borrow before reinvent** — Has this functionality / component already
   been built? Grep the repo for similar utilities, hooks, services, or UI
   primitives FIRST. If a near-match exists: reuse it (name it). If you build
   new despite a near-match, state explicitly *why* the existing one doesn't
   fit (different concern, lifecycle, etc.). Bias is reuse — inventing a
   fifth date-formatter or a fourth "Card" is the opposite of that and just
   creates drift. Suggested: `rg -l "<keyword>" --type-not lock`.

7. **Required reading** — Before editing under a tracked area, have you
   *opened and read in THIS session* the area's reference docs (project
   `CODING-GUIDELINES.md` plus any area-specific guide / design system /
   file-map the project defines)? Citing them from prior-session context
   does NOT satisfy this gate — docs drift; open them now. State which docs
   you read and the one rule from them that constrains this change. If the
   area genuinely has no required reading beyond `CLAUDE.md` (e.g. docs,
   config, CI), say so.

8. **Deploy reality** — If this change only reaches production through a
   migration or a multi-surface deploy (schema → remote DB, image rebuild,
   multiple services rolled in sequence), name the **prod-*applied* proof**
   — not "merged", not "redeployed", not "exit 0". State the exact check
   that shows it is *live in the running system*: the migration tool
   reports an applied change (not "already in sync" / "no changes" /
   "nothing to do"); the running artifact's digest == the new build's; the
   endpoint returns the new behaviour, not the old. **Treat any ambiguous
   tool output as "nothing changed until proven."** And because a
   downstream bug stays latent until the upstream one is fixed, after any
   single-layer fix re-verify the *next* seam — do not declare done at the
   layer you just touched. See `wiki/concepts/pipeline-and-deploy-reality.md`.
   Skip only for pure local / no-deploy changes (say so).

## Output format

Eight short answers. Bullet form OK. Skip a question only if it genuinely
doesn't apply (e.g. rollback for a docs-only change, or borrow-check for a
brand-new feature with no precedent), and say so explicitly. Question 7
cannot be skipped when editing under a tracked code area. Question 8 cannot
be skipped when the change involves a migration or a multi-surface deploy.

When spawning a sub-agent for code work, inline this gate into the agent
prompt and require the eight answers in its final output — the gate applies
to sub-agents too.

## Arguments

`$ARGUMENTS` = the task description (optional — if omitted, use the most
recent user message as the task).

## When to skip this gate

- Pure typo fixes (one-line readme/comment)
- Renaming a single private function with no call-sites elsewhere
- Reverting a recent commit

For everything else, run the gate. The two minutes it costs catch the
ten-minute (and the multi-roundtrip) mistakes.
