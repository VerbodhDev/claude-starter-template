# UI-DESIGN-SYSTEM.md

> **TEMPLATE — fill this in when the project is initialized (skip/delete
> entirely if this repo has no UI).**
> Single source of truth for frontend UI implementation. It must describe
> **what is actually shipped in the codebase today** + the exact recipes
> that work — not aspiration. If a long-term design contract lives
> elsewhere (a wiki/spec/Figma), say which wins when they disagree.
> Re-verify tokens/recipes against the live code each time you touch it.

**Single source of truth for `<frontend-root>` UI implementation.**

Last updated: `<YYYY-MM-DD>` — `<what changed and why>`

---

## 1. Read order (analysis-first gate)

Before any UI edit, read in this order:
1. This file (tokens, primitives, known gaps).
2. `<the long-term design contract, if any>`.
3. `<reference frame / mockup for the surface being changed>`.
4. The live component you're editing — confirm the recipe still matches.

## 2. What's actually shipped right now (verify each session)

### 2.1 Token reference (from `<where tokens live — css :root / config>`)
| Token | Value | Use for |
|---|---|---|
| `<--token>` | `<value>` | _TODO_ |

### 2.2 Typography — what `<display font var>` actually resolves to today
_TODO: the real resolved font(s); call out any drift between intended and
actual (this is a classic silent gap)._

### 2.2.1 Typography legibility rule (binding)
_TODO: which font is "glance only" vs "body/read"; the minimum contrast
floor; the rule that long-form text never uses the display face._

### 2.3 Radius and shadow scales
_TODO._

## 3. Core primitives (recipes that actually shipped)

For each primitive: the exact class/markup recipe, not a description.
### 3.1 `<primitive — e.g. Card>`
### 3.2 `<primitive — e.g. Pill/Badge>`
### 3.3 `<primitive — e.g. Hero>`
### 3.x Translating external design references into live components
_TODO: the import checklist + preferred extraction path._

## 4. Color palette
_TODO: the canonical swatch legend (role → token), verbatim from source._

## 5. Responsive design — all screen sizes (non-negotiable)
### 5.1 Breakpoints in use
### 5.2 Mobile-first cascade (enforced by `responsive-classcheck.sh`)
_TODO: multi-column grids declare a mobile base (`grid-cols-1
sm:grid-cols-N`); no bare fixed pixel widths._
### 5.3 Layout patterns that survive mobile
### 5.4 Mobile overflow playbook
### 5.5 Page shell + header
### 5.6 Section dividers

## 6. Internationalization
### 6.1 Canonical locale-detection function
### 6.2 Timezone detection
### 6.3 Don't-do list
### 6.4 Where the choice is persisted

## 7. Implementation checklist (copy into every UI task response)
```text
- [ ] Read order (§1) followed THIS session
- [ ] Tokens/recipes used match §2/§3 (verified vs live code)
- [ ] Mobile-first cascade (§5.2) — no bare grid-cols-N / fixed px
- [ ] Typography legibility rule (§2.2.1) respected
- [ ] Matches the design reference for this surface
- [ ] No new one-off component when a primitive exists (gate Q6)
```

## 8. Ship workflow
_TODO: how UI changes are previewed/validated/deployed; lessons applied._

## 9. Known gaps and TODOs
_TODO: the honest list of where shipped reality ≠ the contract._

## 10. Don't-do list
_TODO: compressed corrections — the mistakes not to repeat._

## 11. Reference index
_TODO: links to the design contract, mockups, raw token source._
