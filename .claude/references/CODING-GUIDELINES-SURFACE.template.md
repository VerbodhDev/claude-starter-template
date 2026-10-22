# Coding Guidelines — `<SURFACE>` (`<surface-root-path>`)

> **TEMPLATE — one per scanned project / surface.**
> This is a *pattern file*, not a doc to read as-is. On init, for **each
> deployable surface** the repo scans (backend, frontend, infra/agent,
> mobile, worker, …) copy this to
> `.claude/references/CODING-GUIDELINES-<SURFACE>.md` (e.g. `-BE.md`,
> `-FE.md`, `-INFRA.md`), fill it, and add a Required-Reading row +
> File-Map/TECHSTACK section for that surface. A monorepo with N surfaces
> has N of these; a single-surface repo has one. Repo-wide rules that
> apply to *every* surface stay in `CODING-GUIDELINES.md` — only put
> surface-specific rules here.
>
> **Every rule must be grounded in actual code or infra state, not
> aspiration.** Delete a section rather than leave it speculative. The
> highest-value rules are written *after* an incident — cite it.

Surface-specific standards for `<SURFACE>` under `<surface-root-path>`.
Repo-wide rules: [`./CODING-GUIDELINES.md`](./CODING-GUIDELINES.md).
Sibling surfaces: `CODING-GUIDELINES-<other-surface>.md`.

---

## Structure & boundaries

_TODO: the top-level layout for THIS surface and the boundaries to
preserve (modules / packages / layers). Show the tree._

## External contracts (the seams this surface owns)

_TODO: every API / SDK / queue / library this surface calls or exposes.
Per the no-guess rule, exact names/params are verified from docs/source,
not memory. Cross-ref `wiki/concepts/pipeline-and-deploy-reality.md`
(F2 third-party-contract-guess)._

## Wiring / dependency rules

_TODO: how units register with their container/module here; the rule that
a unit's collaborators must be provided by its module (F1)._

## State & persistence _(if this surface owns any)_

_TODO: datastore, access layer, schema/migration model, and the rule that
schema changes only go live via `<the sanctioned apply path>` — not a
session command. A change isn't live until the apply step *reports it
applied* (F4)._

## Secrets

_TODO: where secrets come from at runtime; what must never be committed;
how `tools/guardrails/check-pii.sh` interacts with fixtures._

## Build / lint / test

```bash
# build:  <cmd>
# lint:   <cmd>   (clean before commit)
# test:   <cmd>
```

## Deploy contract

_TODO: which paths trigger which pipeline; build vs. deploy split; is
rollout automatic? The **applied-proof** check (artifact digest ==
running). Cross-ref `pipeline-and-deploy-reality.md`._

## Common patterns that cause issues (this surface)

_TODO: the recurring traps here, one line each with the incident/PR that
taught it. Map to F1–F5 in `pipeline-and-deploy-reality.md` where they fit._

## Summary checklist

```text
- [ ] External contracts verified vs docs (no guesses) — F2
- [ ] Units' collaborators provided by their container — F1
- [ ] Schema/state change: apply step reported "applied", not "in sync" — F4
- [ ] lint/build/test clean; failing baseline reproduced first
- [ ] running artifact digest == new build's
- [ ] re-verified the next seam after the last fix — F5
```

## See Also

- [`./CODING-GUIDELINES.md`](./CODING-GUIDELINES.md) (repo-wide)
- `wiki/concepts/pipeline-and-deploy-reality.md`
