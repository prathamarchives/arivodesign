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

---

## PASS 2 → PASS 3 (2026-10-16, session 7) — triggered by INT-007: the owner's first visual correction (the sidebar)

Reviewed: the sidebar against owner turn-007 + six new references (`context/references/turn-007/`; ref-1 = the acceptance image). The reasoning protocol the owner ordered (perspectives → raw material → cross-field methods → external arbiters) is archived in `context/intake/INT-007-extraction.md`; the geometry below is DERIVED there, not eyeballed.

### Pass-2 defects (named, with evidence)

| # | Defect | Evidence | Severity |
|---|--------|----------|----------|
| 1 | **The rail is too wide and announces instead of blends.** 76px collapsed / 268px expanded with a wordmark row, a name row, a bold handle, a 3px active bar — none of it exists in ref-1, and the owner says "too wide" twice. | ref-1 (silent ~80px rail, avatar top, no text), ref-4 (64px rail, 40px cells); owner turn-007 verbatim | CRITICAL |
| 2 | **Account identity is at the wrong end and says the wrong thing.** PFP lives at the rail's foot with a bold "Pratham" + handle; the owner: pfp to the TOP, identity = `@prathamarchives` only. | ref-1/ref-4 (avatar anchors the top); owner turn-007 | CRITICAL |
| 3 | **Expansion reflows the page.** `.content` margin-left animates 52→212px — every frame re-lays-out every card, cover and bar. The owner: "only sidebar expands... the homepage just give a little bit motion... not slides all the way." | shell.css (old `.sidebar:hover ~ .content` margin rule); owner turn-007 | CRITICAL |
| 4 | **Motion latency past the instant window.** Attack 120ms + 480ms glide reads laggy ("can be alot smoother better latency"). | tokens.css old `--dur-panel: 480ms`; HCI ~100ms boundary (extraction §3) | HIGH |
| 5 | **Bold in the chrome.** `.a-name` 700, `.n-label` 500, overlay title/rows 500–700 — the references set every word in regular. | ref-4 (all labels regular); owner turn-007 "no bold fonts here" | HIGH |
| 6 | **THE GLASS SWALLOWED ITS OWN CHILDREN (found in pass-3 verification, not by the owner).** Moving the glass onto `.sidebar::before` (aperture refactor) made a positioned pseudo with z auto paint ABOVE non-positioned children: the avatar disc, the hairline and the pin icon rendered invisible under their own glass. Nav items survived only because they are `position: relative`. | `_rail-top.png` (empty rail top) vs getBoundingClientRect showing the avatar at 24,25 40×40 with a cover fill | CRITICAL (new failure class — ratcheted into verify.sh 5e-a) |
| 7 | **Account overlay origin stale.** The panel still grew from bottom-left after the account moved to the top — origin must follow its trigger. | shell.css old `bottom:` positioning | MEDIUM |

### Pass-3 changes (the fixes, mapped to defects)

1. **Re-derived geometry** (→1): cell 40 (avatar/nav/pin are ONE module) · rail 64 = 11+1+40+1+11 · expanded 224 = 3.5×64 (rational ratio) · rhythm 6px · rows 40px with pad 12 · icon→label gap 12 · radius r-sm cells / r-xl panel. Numbers live in tokens.css (`--sidebar-w`, `--sidebar-w-expanded`) — single source of values.
2. **Anatomy rebuild** (→2): `avatar TOP → hairline → nav → pin foot`. Wordmark deleted (HTML + CSS + token). Account head = avatar-lg + `@prathamarchives` (13/400/fg-2) + chevron. Pin demoted to a 32px utility at the foot — its `margin-left: 4px` centers it collapsed AND left-aligns it expanded (one number, two states). Hairline divider: 40px collapsed → full width expanded.
3. **Overlay expansion** (→3): the content margin rule is DELETED. The panel floats above the page (z-sidebar); the page answers with the breath — `translateX(6px) scale(0.996)`, origin left — transform-only, zero reflow. Verified: computed `.content` transition is `transform`; pinned breath matrix `matrix(0.996,0,0,0.996,6,0)`.
4. **The envelope** (→4): attack 80ms / glide 380ms / release 160ms; labels +120ms in, 60ms out; pinned 0ms. `--dur-panel: 480→380`, `--dur-drift: 280→240`. Verified by computed transition-delay in both destination states.
5. **One voice** (→5): every word in the rail and overlay is 13px/400 (labels fg-2, active fg-1, handle fg-2); overlay name/rows de-bolded to 400. The avatar monogram keeps 700 — artwork voice, documented as the single exception.
6. **Aperture glass + z -1** (→1,6): the blur layer is a constant 224px surface anchored left, clipped by the panel (blur region never re-rasterizes mid-animation — the compositor smoothness win), pinned at `z-index: -1` so children paint above it. Failure class ratcheted: verify.sh 5e-a greps for the load-bearing z.
7. **Overlay origin** (→7): account panel grows from TOP-left (top/left 24px, `transform-origin: top left`, initial `translateY(-8px)`).

### Verification (Loop 4 — verified by run, fresh browser session)

- The ruler: rail 64.0 collapsed / 224.0 pinned; avatar 40.0; nav rows 40.0; pin 32.0; stack rhythm 25→77→90→136 (12/12/6 gaps) — exact.
- The compositor: `.content` transition = transform; `::before` width constant 224px across states; attack/release delays 0.08s/0.16s measured in both destination states.
- The voice: zero `font-weight > 400` in the sidebar subtree except the avatar monogram (artwork); wordmark absent from DOM; handle text exactly `@prathamarchives`.
- The eyes: collapsed rail (dark+light) reads as the ref-1 column — face top, hairline, three glyphs, quiet pin; expanded reads as ref-4/ref-5 — a floating layer over an unreflowed page. Screenshots: `sidebar-rail-dark/expanded-dark/hover-dark/rail-light/expanded-light/account-overlay-top.png` (+ crops).
- Behavior: real-mouse hover expands; pin toggles; overlay opens from beneath the avatar; Escape closes; theme swap clean in both themes; console clean.
- not checked — true 60fps feel on real hardware (needs the owner's hand); prefers-reduced-motion not emulated in-browser (the tokens collapse durations to 1ms by construction; function survives as fades); hover attack "feel" judged only by the envelope numbers.

---

## PASS 4 — the compacted rail + tactile system (INT-008 → INT-009, 2026-10-16)

**Intake:** the owner saw NOTHING change (turn 8) — diagnosed: pass 3 was unpushed AND the preview server sent no cache headers, so the browser served stale CSS; the served HTML still carried "arivo" ×3 (title/About/footer — pass 3's purge was sidebar-scoped). Then the numeric directive arrived (turn 9). References: ALL 15 viewed for the first time this pass (the turn-8 process failure — references never opened — closed).

**Named defects → fixes:**
1. **Invisible work** (landing failure) → no-store preview server (`scripts/serve_nocache.py` via true double-fork `scripts/daemon_nocache.py`) + `?v=4` cache-busted asset links. Verified: `Cache-Control: no-store` on every response; daemon survives tool-call boundaries (the setsid/nohup variants were reaped — logged).
2. **Rail too wide** (64) → derived grid: rail **44** = 1(border)+5+32+5+1; expanded **176** = 4×44. Verified: getBoundingClientRect 44.0 / 176.0 (hover AND pinned).
3. **Two-axis drift** (avatar center 33 vs icon center 35 — found by measurement, not by eye) → avatar inset (32−28)/2 = 2px releasing to 0 on expand; `--sb-inset` 6px enclosure split from `--sb-pad` 5px rail edge (conflating them put icons 1px off-axis); pin `flex: none` (it shrank to 30 inside the 30px content box). Verified: worst axis diff **0.0px** across avatar/3 icons/pin; pitch exactly **40** (32+8).
4. **White-on-white selection in light theme** (the "messed up" look) → `--tint-hover`/`--tint-selected` family (ink 4.5%/7.5% light; white-glass 7.5%/13% dark). Verified: active pill rgba(15,15,18,0.075) in light, visible in screenshot.
5. **"arivo" survivors** (title, About row, footer, favicon monogram) → total purge; identity exactly `@prathamarchives` (title, greeting, overlay title, favicon → neutral book glyph). Verified: body innerText arivo count **0**; served HTML grep 0; overlay title reads `@prathamarchives` at weight 400.
6. **Handle truncated** in the 176 panel (chevron stole 22px) → chevron deleted (the mathias ref head is avatar + handle, nothing else). Verified: truncated **false**.
7. **Dead tooltip wiring** (self-caught): rail tooltips could never display — hovering the rail IS the expansion, so `.sidebar:hover` always suppressed them. → Tooltips re-homed where directive B places them: over TEXT CONTENT (`.content [data-tip]`), dark bubble, bottom pointer. Verified: opacity 1 after 260ms delay, `rgb(13,13,14)` = #0D0D0E exact in light, 12px horizontal padding, 8px rotated-square pointer present.
8. **Motion latency** (380ms read sluggish) → spring solve k=300/c=30/m=0.8 → ζ=0.968, settle ≈213ms → **240ms** glide; attack 50ms/release 100ms/pinned 0; drift 200ms. Content breath **translateX(3px) scale(0.998)** — inside the directive's 2–4px band, transform-only. Verified: computed matrix(0.998,0,0,0.998,3,0) on hover AND pin.

**The eyes:** collapsed dark = the G5Ka column (face top, hairline, three fine-line glyphs, quiet pin) at 44px; expanded light = the mathias panel (avatar+handle head, tinted active row, icon-left-edge alignment) floating over an unreflowed page. Screenshots: `p4-rail-dark.png`, `p4-expanded-dark.png`, `p4-rail-light.png`, `p4-expanded-light.png`, `p4-tooltip-dark.png`, `p4-account-overlay.png`.

**Behavior:** real-mouse hover expands (176); pin holds expansion with breath; tooltip appears over content button; overlay opens top-left, Escape closes; theme swap clean both ways; console + page errors clean.

**not checked** — true 60/120Hz feel on real hardware (needs the owner's hand); reduced-motion not emulated in-browser (tokens collapse by construction); paint-storm instrumentation (structure prevents it: only rail width interpolates, content is transform-only, aperture glass constant-size).
