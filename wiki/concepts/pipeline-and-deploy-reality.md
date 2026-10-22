# Pipeline & Deploy Reality

A reusable diagnosis + verification discipline for any feature that crosses
more than one layer (producer → transport → store → API → UI) and reaches
production through a deploy or migration. Distilled from a real bring-up
that took several roundtrips because each layer hid the next and one
deploy step silently no-op'd.

Pair this with the `/ready-to-code` gate (Q8 "Deploy reality" points here).
Adapt the layer names to your stack; the **failure classes are universal**.

---

## 1. Mental model: a feature is a vertical slice through seams

```
 producer ──▶ transport ──▶ store ──▶ retrieval API ──▶ UI
   (job/      (HTTP/queue/  (DB /     (endpoint)        (page/
    agent)     event)        table)                      client)
```

Each arrow is a **contract** (a "seam"). A mismatch at any seam makes the
end (the UI) **silently empty or stale — not error**. So:

> **Golden rule:** an empty/wrong UI is a *symptom*, never a diagnosis.
> Walk the seams in order and find the first one where the data/row count
> drops to zero. Verify each seam, not just the two ends.

Diagnose before coding: check logs at *each* layer and reproduce the
failing baseline before writing a fix. Symptoms ("no data on screen") are
not root causes ("the store rejects every write").

---

## 2. "Merged ≠ live" — the deploy-reality rule

Code being **merged**, a build being **green**, or a command exiting **0**
does **not** mean the change is running in production. A change is live only
when you have observed the **applied proof** in the running system:

- A migration tool that says *"already in sync" / "no changes" / "nothing
  to do"* **changed nothing** — treat that as a failure to prove, not a
  success. An applied change says so explicitly ("applied", "altered",
  "done in Nms").
- The running artifact's identity (image digest / build hash / version
  endpoint) must equal the new build's. "I redeployed" is not proof; the
  digest match is.
- The endpoint / UI returns the *new* behaviour, not the old.

Treat every ambiguous tool output as **"nothing changed until proven."**

### The stale-source deploy-gate trap

If a deploy step bakes an artifact from your **working copy** (a migration
image, a bundled schema, a generated client), a stale checkout silently
ships the *old* content and the apply step no-ops. Before running any such
step: sync the working copy to the merged mainline and eyeball that the
change is actually present in the file the step will read.

---

## 3. The five failure classes (pre-flight checklist)

Each recurs for every cross-layer feature. Check all five before declaring
done.

| # | Class | Symptom | Root cause | Guard |
|---|---|---|---|---|
| F1 | **Wiring / dependency** | Service won't boot; container exits non-zero; old version keeps serving | A unit pulls a collaborator (guard, interceptor, provider, plugin) its container/module doesn't register/import | Mirror a known-good sibling's wiring; boot locally before shipping |
| F2 | **Third-party contract guess** | Every call to a lib/SDK/CLI/query fails the same way | API/flag/param/grammar guessed from memory, not verified | Verify exact names/params from official docs or source *in this session* before writing the call |
| F3 | **Producer ↔ store contract** | Every write 500s / is rejected at persistence | The ID/shape/type the producer emits ≠ the store's column type / constraint / key | Make the store match the producer's real contract (or vice-versa) — and assert it with one real round-trip |
| F4 | **Deploy-gate no-op** | Code+config correct, "redeployed", still broken; the apply step said "already in sync" | A required separate apply step (migration / image bake) ran from a stale source → silent no-op | Sync working copy → mainline before the apply; read the apply tool's stdout literally |
| F5 | **Latent-until-upstream** | Fixing layer N immediately reveals a brand-new bug in layer N+1 | Layer N+1's code never executed before because N always failed first | Expect it. After each layer fix, immediately re-verify the *next* seam — do not declare victory at the layer you just touched |

**F5 is the meta-lesson.** A multi-roundtrip bug is usually one F5 cascade
(F1→F2→F3→F4...) where each fix uncovered the next. Budget to walk the
*whole* pipeline after any single-layer fix.

---

## 4. Pre-flight checklist (copy into the shipping notes / PR)

```text
- [ ] F2: every third-party API/CLI/query verified vs docs in-session (no guesses)
- [ ] F1: each unit's collaborators are registered/imported by its container
- [ ] F3: producer ID/shape == store column/type/constraint (proved with 1 round-trip)
- [ ] Build/test/lint clean; failing baseline was reproduced first
- [ ] F4: working copy synced to mainline BEFORE any deploy/migration apply step
- [ ] F4: apply-step stdout read literally — says "applied/changed", not "in sync"
- [ ] running artifact digest/version == the new build's
- [ ] F5: re-verified seams end-to-end AFTER the last fix (not just the fixed layer)
- [ ] UI/endpoint returns the NEW behaviour against production
```

---

## 5. Why this exists

Written after a bring-up where four bugs stacked — a wiring crash, two
guessed third-party API calls, a producer/store type mismatch — and then a
deploy step that no-op'd from a stale checkout while being reported as
"deployed". Each was individually small; together they cost many roundtrips
because each was only visible once the previous was fixed (F5) and because
"merged + redeployed" was mistaken for "live". This page front-loads all of
it so the next cross-layer feature does not re-walk the same path.
