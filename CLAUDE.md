# CLAUDE.md

Project memory for this repo. Keep this file thin (under 200 lines) — detail
lives in `.claude/references/`. This file is an INDEX.

---

## Pre-Code Checklist (blocking)

Copy this into your response before writing any code. **Do not edit a file
until every box is checked.**

```
- [ ] 0. Synced with remote: git fetch origin && git pull origin main
- [ ] 1. Read .claude/references/CODING-GUIDELINES.md
- [ ] 2. Feature branch created (NOT main): git checkout -b <type>/<short-name>
- [ ] 3. Task / issue ID assigned (e.g. ABC-123 or GH issue #N)
- [ ] 4. Done state written: what's true when this is finished?
- [ ] 5. Verification gate: what test/check proves it's done?
- [ ] 6. Blast radius: what could break? Which files / services?
```

Skip the gate at your own peril. The `.claude/hooks/precode-checklist.sh`
hook blocks Edit/Write on `main`/`master` so item 2 is enforced.

---

## Quick Reference Commands

Replace these placeholders with project-specific commands once you pick a stack:

```bash
# Build / dev server
# pnpm dev    OR    cargo run    OR    python -m app

# Lint (must be clean before commit)
# pnpm lint --max-warnings=0    OR    ruff check    OR    cargo clippy -- -D warnings

# Tests
# pnpm test    OR    pytest    OR    cargo test

# Deploy (per-environment)
# <fill in once deploy mechanism is decided>
```

---

## Required Reading (before any task)

| Doc | Path | Why |
|---|---|---|
| CODING-GUIDELINES.md | `.claude/references/CODING-GUIDELINES.md` | File-size limits, lint policy, async-button rule, mobile-first responsive rule |
| three-paths.md | `.claude/references/three-paths.md` | Decision-making framework for obstacles. When CI fails / a limit fires / something slows down, choose Path 2 (investigate then decide) — not Path 1 (band-aid the nearest config knob). |
| pipeline-and-deploy-reality.md | `wiki/concepts/pipeline-and-deploy-reality.md` | **Required before any cross-layer feature or deploy/migration.** The seam-by-seam diagnosis model, the "merged ≠ live" rule, and the F1–F5 failure-mode catalog (wiring · third-party-contract-guess · producer/store mismatch · deploy-gate no-op · latent-until-upstream). `/ready-to-code` Q8 points here. |
| File-Map.md | `.claude/references/File-Map.md` | **Template — fill on init.** Path→purpose lookup so agents find the right file fast instead of grepping blind. |
| TECHSTACK.md | `.claude/references/TECHSTACK.md` | **Template — fill on init.** What's actually used + running (versions, runtime model, deploy/apply gates) per surface. |
| CODING-GUIDELINES-`<SURFACE>`.md | `.claude/references/CODING-GUIDELINES-SURFACE.template.md` | **Pattern — one per scanned surface.** On init, copy the template to `CODING-GUIDELINES-<SURFACE>.md` for **each** deployable surface the repo has (`-BE`, `-FE`, `-INFRA`, …) and add a row here per surface. Surface-specific rules grounded in real code + incidents. |
| UI-DESIGN-SYSTEM.md | `.claude/references/UI-DESIGN-SYSTEM.md` | **Template — fill on init** (delete if no UI). Single source of truth for shipped UI tokens/primitives/responsive rules. |

## Project Initialization (do this once, before real feature work)

The reference docs above marked **Template** / **Pattern** ship as
fill-in-the-blank skeletons. Before the first non-trivial task on a new
project:

1. Fill `File-Map.md`, `TECHSTACK.md`, and (if there's a UI)
   `UI-DESIGN-SYSTEM.md`: replace every `<…>` / `_TODO_` / example row
   with real, code-grounded content; delete sections (and whole docs)
   that don't apply.
1a. **Per surface:** for each deployable surface the repo scans
   (backend, frontend, infra/agent, mobile, worker…) copy
   `CODING-GUIDELINES-SURFACE.template.md` →
   `CODING-GUIDELINES-<SURFACE>.md`, fill it, and add one Required-Reading
   row + matching `File-Map`/`TECHSTACK` section per surface. Keep
   repo-wide rules in `CODING-GUIDELINES.md`; only surface-specific rules
   go in the per-surface files. A single-surface repo has exactly one.
2. Update `CLAUDE.md` "Quick Reference Commands" with the real
   build/lint/test/deploy commands.
3. Tune the deploy/migration patterns in
   `.claude/hooks/predeploy-reality-check.sh` to this stack.
4. Replace `__PROJECT_ROOT__` in `.claude/settings.json` (or via the
   installer) and run `tools/guardrails/install-git-hooks.sh`.

A half-filled reference doc that confidently states something false is
worse than no doc — ground every line in actual code/infra, not aspiration.
Add further reference docs (FILE-MAP detail, CODEBASE-GAPS, etc.) as the
project grows.

---

## Slash Commands

| Command | Purpose |
|---|---|
| `/ready-to-code` | Eight-question gate before any non-trivial change (incl. borrow-before-reinvent, required-reading, deploy-reality, + a resume-from-compaction state check) |
| `/ship` | Lint → commit → merge → push → deploy in sequence |

Add more in `.claude/commands/` as workflows stabilise.

---

## Core Rules

The non-obvious rules. For incident history behind each, see linked docs.

1. **Branch before editing.** `precode-checklist.sh` enforces this.
2. **Mobile-first cascade.** Multi-column grids declare a mobile column count
   (`grid-cols-1 sm:grid-cols-3`, never bare `grid-cols-3`).
   `responsive-classcheck.sh` enforces this for `.tsx` / `.jsx`.
3. **No fixed pixel widths without responsive override.** `w-[260px]` →
   `w-full sm:max-w-[260px]`.
4. **Tables wrap in `overflow-x-auto`.** Even if they fit today.
5. **Lint must be clean.** `pnpm lint --max-warnings=0` (or stack-equivalent)
   passes BEFORE commit.
6. **Don't push partial work.** If parallel agents are still running, wait.
7. **Merged ≠ live.** "Merged / green build / exit 0 / redeployed" is NOT
   proof. A task is done only with the *applied proof*: running artifact
   digest == new build's, the endpoint returns the new behaviour, and any
   migration tool said "applied" — never "already in sync / no changes".
   Treat ambiguous tool output as "nothing changed until proven", and
   after fixing one layer re-verify the next (downstream bugs stay latent
   until upstream is fixed). `predeploy-reality-check.sh` nudges here; full
   discipline in `wiki/concepts/pipeline-and-deploy-reality.md`.
8. **Limits are detectors, not the disease.** When CI / runtime hits a
   ceiling (`timeout-minutes`, memory, retries), DO NOT bump the limit as
   the first move — investigate WHY first. The 5-step loop (see
   `.claude/references/three-paths.md`) takes ~3 min, same as the
   band-aid. The `limit-bump-investigate-first.sh` hook nudges you here.

Detail in `.claude/references/CODING-GUIDELINES.md`.

---

## Hooks (`.claude/hooks/`)

Configured in `.claude/settings.json`:

- `precode-checklist.sh` (PreToolUse:Edit / Write) — BLOCKS edits on main / master
- `responsive-classcheck.sh` (PreToolUse:Edit / Write) — BLOCKS bare
  `grid-cols-N` (N≥2) in `.tsx`/`.jsx` when the same class string lacks a
  mobile-first cascade
- `limit-bump-investigate-first.sh` (PreToolUse:Edit / Write / MultiEdit) —
  ADVISORY (non-blocking). Fires when about to touch a CI / IaC / deploy
  config (`.github/workflows/*.yml`, `Dockerfile*`, `*.tf`, etc.) in a way
  that involves a known limit identifier (`timeout-minutes`, `MemorySize`,
  `MaxRetries`, `cpu`, `ulimit`, etc.). Injects the three-paths 5-step
  framing question. See `.claude/references/three-paths.md`.
- `diagnose-before-code.sh` (PreToolUse:Edit / Write / MultiEdit) —
  ADVISORY. Fires once per session on the first edit to a source file:
  diagnose root cause across the pipeline seams and reproduce the failing
  baseline before writing the fix (symptom ≠ root cause).
- `predeploy-reality-check.sh` (PreToolUse:Bash) — ADVISORY. Fires when a
  command looks like a deploy / migration / apply step: injects the
  "merged ≠ live" checklist (stale-source, read output literally, applied
  proof, re-verify next seam). **Tune `DEPLOY_PATTERNS` per stack.**

Add more hooks as patterns are proven. Treat each new hook as an
investment — it must catch a recurring bug, not a one-off.

---

## Statusline (`tools/statusline/`)

A custom status line wired in via `.claude/settings.json` shows one line at the bottom of the chat window:

```
user │ …/dir │ branch +*?  │ vX.Y.Z │ HH:MM │ [Model] N% │ $cost │ 5h: N%
```

What it surfaces that the default doesn't:

- **Branch + dirty markers** (`+` staged, `*` modified, `?` untracked) — catches "wait, am I on `main`?" before an Edit fires.
- **Context window %** with color thresholds (green <70, yellow <90, red ≥90) — your cue to consolidate or `/clear`.
- **5-hour rate-limit %** — knowing you're at 80% before sending the next big message lets you defer instead of getting mid-task blocked.

Dependencies: `jq`, `git` (optional), 24-bit truecolor terminal. Restart Claude Code after the setup command rewrites `__PROJECT_ROOT__` so the statusline takes effect.

Customize the palette at lines 19-30 of the script. Full details: `tools/statusline/README.md`.

---

## Local guardrails (`.githooks/` + `tools/guardrails/`)

**Per-machine activation required** — run once after cloning:

```bash
bash tools/guardrails/install-git-hooks.sh
```

This sets `core.hooksPath = .githooks` so the local hooks fire on commit /
push. Without it, the guardrails are inert. Add a "First-time setup" line
to your project's README pointing at this command.

What ships:

- `.githooks/pre-commit` — runs `tools/guardrails/check-pii.sh --cached`
  on every commit. Blocks real UUIDs and personal-domain emails from
  reaching the remote.
- `.githooks/pre-push` — placeholder for project-specific gates (curl
  smoke tests, integration tests, etc.). No-op until you customize.

**Why local, not CI-only:** once data hits GitHub, even a green CI
guardrail can't unleak it. Pre-commit catches the leak before it leaves
the dev machine. CI-side guardrails are useful as a backstop (catching
`--no-verify` bypasses or contributors who skipped the installer), but
the primary defense is local.

Full rationale: see "Guardrails" section in the README.

---

## What goes in memory vs what goes here

- **CLAUDE.md (this file)** — pointers, hard rules, pre-code checklist.
- **`.claude/references/`** — full guidelines, file map, gaps, tech stack.
- **`.claude/ui-patterns/`** — canonical UI pattern docs.
- **Memory (`~/.claude/projects/<repo>/memory/`)** — operational facts that
  change with environment: deploy commands, AWS profiles, active sprint name.
  NOT patterns, NOT file paths.

When in doubt: if a fact would be useful to a brand-new contributor reading
the repo, it goes in `.claude/references/`. If it's only useful for an agent
running on YOUR machine, it goes in memory.
