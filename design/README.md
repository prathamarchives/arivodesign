# Design surface — arivodesign

**Sources:** INT-004, INT-013, INT-025, INT-026, INT-028; D-008..D-013.  
**Current UI baseline:** Pass 17.  
**Current task:** read [`PHASE-1-EXECUTION.md`](../PHASE-1-EXECUTION.md) before changing any UI runtime file.

## Status

The repository contains a static HTML/CSS/vanilla-JavaScript prototype. The current pages are:

- `index.html` — dark home export.
- `home-light.html` — light home export.
- `library.html` — library export.
- `archive.html` — archive export.
- `journal.html` — journal composing surface.
- `reader.html` — reader and passage interaction concept.

**Phase 1 is specified but not implemented.** Section links still use separate HTML documents. Theme classes are set per page. Do not claim navigation or theme continuity until the new behavior is implemented and tested in a browser.

## Run the prototype

From the repository root:

```sh
bash serve.sh
```

The local preview uses port 3000 by default. Directly open a page only when testing standalone-load behavior. For the shared interaction tests, use the route and theme matrix in the phase contract.

## Source-of-truth order

1. `../AGENTS.md` — session entry and read order.
2. `../LAWS.md`, `../RULES.md`, `../CONTRACT.md`, `../DECISIONS.md` — hard constraints and product decisions.
3. `../INTENT-LEDGER.md` — owner intent authority.
4. `../PHASE-1-EXECUTION.md` — exact current scope, constants, and acceptance matrix.
5. This prototype — existing HTML/CSS structure and owner-provided export.

If documentation and code conflict, do not guess. Follow the current decision record and phase contract. Record the conflict.

## Files

- `index.html`, `home-light.html`, `library.html`, `archive.html`, `journal.html`, `reader.html` — page exports.
- `styles/prototype.css` — owner-supplied Figma export. **Frozen. Do not edit.**
- `styles/tokens.css` — current font declarations, color variables, sizing tokens.
- `styles/shell.css` — shared page shell and sidebar geometry.
- `styles/motion.css` — sidebar, content hover, and entrance motion.
- `motion.js` — current page entrance, nav selection, and sidebar hover/focus behavior.
- `images/` — SVG artwork and profile image.
- `assets/fonts/` — self-hosted fonts.
- `preview/` — previous design-review screenshots.

The `scripts/` directory currently contains the no-cache development server helpers only. Older notes named `scripts/scaffold_design.sh`, `scripts/transform_pages.py`, `scripts/int026-verify.py`, and `scripts/int026-shots.py`; those files are **not present in the current repository tree**. Do not invoke them or claim that they can reproduce a test. Any new test runner must be committed before its results can support a verification claim.

## Locked UI constraints

- Sidebar: full-height floating glass rail; Home / Library / Archive at the top; account identity at the bottom. Add the owner-requested 24×24px pin toggle at the top-left. Pinned keeps the rail expanded and visible; unpinned restores idle behavior. This is the only Phase 1 component addition.
- Rail: 64px collapsed, 168px expanded; 26px avatar; fixed icon/avatar axis; text weight 400; handle is exactly `prathamarchives`, with no `@`.
- Home: keep the Import action, Currently reading, Reading lists, Recent highlights; 30px section gap and 16px intra-section gap; reading cards keep the 60.256% / remaining-width split.
- Keep the grayscale palette and existing artwork.
- Selected destination: Home for both home documents; Library for Library; Archive for Archive and Journal; no top-level selected item in Reader.
- Do not add “All changes saved”, “Personal Space”, `@prathamarchives`, `⌘K`, or other copy that the owner removed.
- Do not change typography in Phase 1. The historic Helvetica rule conflicts with the current Figma export's Inter/Lora. That decision remains open.
- No page-wide blur, screen-covering overlay, bounce, unapproved layout change, or fake success state. No settings row: the owner explicitly removed it.

## Current execution gate

The only active task is Phase 1 in `../PHASE-1-EXECUTION.md`: shared route and theme state first; then route motion and idle chrome; then an interaction audit. Test the current state before each pass, capture rendered evidence, update `REVIEW.md`, and do not merge without owner review.
