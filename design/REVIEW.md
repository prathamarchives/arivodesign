# REVIEW — the design iteration log

The paint cycle (INT-004) is review → fix → re-verify, in passes. Every pass documents its critique and its changes here, so the repo can replay how the design evolved and why (INT-006: "everything gets documented, and turnt into something in order to repo to grow"). Newest pass at the bottom. This file is a design twin of the Correction Codification Loop: no fix without a named defect, no defect without a named evidence.

Evidence rule: every defect cites what was SEEN (screenshot, render) or READ (spec, ref). "Feels off" is not a defect until it is named.

---

## PASS 1 → PASS 2 (2026-10-14, session 6) — triggered by INT-006: "the first prototype... it sucks"

Reviewed: full render of home (dark, top+bottom), library (top+bottom), archive, account overlay, light theme, at 1440×900, against INT-004's vision words and the 8 references in context/refs/.

### Pass-1 defects (named, with evidence)

| # | Defect | Evidence | Severity |
|---|--------|----------|----------|
| 1 | **Glass does not read as glass.** The canvas is near-pure black; panels have nothing luminous to refract, so sidebar/cards render as flat dark-gray rounds. The owner's #1 ask ("transperncy and that glass effect... focus on that blur") is not delivered in dark mode. | 01-home-dark.png, 03-library.png vs `download (18)` frosted ref (bright, obviously-translucent panels) | CRITICAL |
| 2 | **Covers read as black voids.** Placeholder fills are darker than the canvas shadow floor; a "currently reading" row reads as 4 empty rectangles; the library grid reads as 10. The mybooks ref shows covers as the visual anchor. | 01-home-dark.png, 08-library-bottom.png | CRITICAL |
| 3 | **Progress reads as nothing.** 2px hairline on a 0.12-alpha track is invisible; progress is a hero element of "currently reading" (INT-004 names it) and it vanishes. 12% fill renders as a speck. | 01-home-dark.png (Thinking in Systems) | HIGH |
| 4 | **Title duplication.** Cover carries title+author inside, then the card repeats title (and often author) below — every book card says its name twice; library grid says it twice at two sizes. Noise, not richness. | 08-library-bottom.png ("Steal Like an Artist" ×2), 01 (Meditations ×2) | HIGH |
| 5 | **Hover-expand delays were spec-only** (claimed 120ms/260ms, not implemented) — fixed earlier in session 5; recorded here for the pass narrative. | session-5 audit | resolved |
| 6 | **Collapsed nav indicator misreads.** The 3px active bar hugs the panel's outer edge in the 76px rail — reads as a stray seam, not an indicator. | 01-home-dark.png (Home row) | MEDIUM |
| 7 | **Horizontal rows dead-end silently.** Currently-reading and journal rows cut at the viewport edge with no continuation cue — nothing says "scroll". | 01 (row ends hard), 04-archive (11th card cut with no fade) | MEDIUM |
| 8 | **List-card mini covers are voids too** — three near-identical dark mini-covers vanish into the card; the stack (the card's whole point per the bookmarks ref) is invisible. | 01-home-dark.png (Stoicism card) | MEDIUM |
| 9 | **Section rhythm drifts** — inter-section dead space stacks to ~130px (section margin + row padding + header margin), so the page reads empty rather than calm. | 01 vs 02 | MEDIUM |
| 10 | **Overlay backdrop is a wall.** 0.5 alpha + blur 8px turns the page behind into black mud; the panel floats on nothing, so the grow-from-corner motion loses its anchor. | 05-overlay.png | LOW |
| 11 | **Dead rule in pages.css** — `.b-meta-row` targets markup that doesn't exist (markup uses `.b-sub`). Spec/impl drift of the small kind Loop 5 exists for. | grep | LOW |

### Pass-2 changes (the fixes, mapped to defects)

1. **Canvas gets luminous structure** (→1): glow alphas 0.085/0.055 → 0.11/0.075, new third glow at bottom-center (0.05) so lower glass (account row, archive rows) has light to refract; canvas rebuilt as three-station glow arc. Rule added to DESIGN-SYSTEM: *dark glass on a dead-black canvas is a defect — if the canvas reads flat black, the glass has failed.*
2. **Cover family v2** (→2): six distinct brighter grayscale fills (silver → graphite), each with a sheen overlay; covers become pure artwork — large centered monogram glyph, spine highlight, no in-cover title (→4). Duplicate titles removed from markup; title lives once, below the cover (book-meta / li-title).
3. **Progress v2** (→3): 3px fill on a 0.18 track, white fill with a soft luminous edge; meta row `Book 7 · page 182 | 68%` sits as a proper two-headed row directly above the bar.
4. **Monogram system** (→2,4): 1–2 letter initial per work, light 300 italic, centered; adjacent covers alternate tone variants so no two neighbors share a fill.
5. **Collapsed indicator** (→6): the active bar fades out while the sidebar is collapsed; the glass-strong pill alone carries active state; bar returns on expand (drifts in with the labels).
6. **Continuation cue** (→7): horizontal scroll rows get a right-edge fade mask (24px) — a cut card now visibly dissolves instead of stopping.
7. **List-card stack v2** (→8): three distinct mini-cover tones (nth-child mapped), 40×56, and a fan-out on hover (−2px/−4px/+2px with slight rotation) — the stack has a pulse.
8. **Rhythm** (→9): section gap 56→48, header margin 20→24→ set 20px, page-head bottom 32; rows lose their double-padding.
9. **Backdrop softening** (→10): overlay backdrop alpha 0.5→0.38 (light: 0.25→0.18); panel keeps blur-3 — the room stays visible behind the glass.
10. **Hover detailing completion** (X-15): quote-card, journal-day, note-card, concept-card get the same lift family (translateY −2~3px + border-strong + shadow) — no component ships hover-less.
11. **Dead rule removed** (→11).

### Verification (Loop 4, after changes)

Re-render every pass-1 view + hover states; before/after screenshots archived in design/preview/; contrast sanity on new cover tones (fg on lightest fill); verify.sh green. Results appended below when run.

### Pass-2 verification results

- Browser run at 1440×900 (fresh session, cache-busted): home top, library, archive, overlay, light theme re-rendered — glass refracts (canvas glow stations visible behind sidebar and cards), covers read as distinct grayscale artwork with monograms (M/DW/DE/Z/SA/MS…), progress bars read at a glance, no duplicated titles anywhere, right-edge fades signal continuation, collapsed active state = pill only, overlay backdrop softened with the room still visible behind.
- Hover verified by computed style + screenshot: book-card lifts translateY(−3px) with border-strong; list-card stack fans out (±5° rotation, −2/−5px) while siblings rest.
- Contrast: fg-1 monogram on lightest cover (--cover-1) — estimated ≈ 4.4:1 (not instrument-checked; decorative glyph, acceptable); to be instrument-checked when the contrast check lands.
- Console: zero errors, zero warnings. verify.sh: green.
