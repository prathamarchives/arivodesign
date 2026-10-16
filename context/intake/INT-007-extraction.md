# INT-007 — VISUAL EXTRACTION: THE SIDEBAR (pass 3)

> Owner protocol (turn-007): reason before executing — (1) perspectives of top professionals across fields, including what they'd do that the owner is NOT asking for; (2) the rawest material to start from; (3) cross-field methods and techniques; (4) what beyond owner and agent proves the result right.
> This document is that reasoning, archived so the protocol compounds. It runs BEFORE the code changes and again (shorter) after verification.

---

## 0. What the references actually say (measured, re-read three times)

**ref-1 (Skroll — the acceptance image).** The rail is *silent*: no wordmark, no labels, no name. The avatar sits at the very top, aligned with the page header row — it is the anchor the rest of the column hangs from. Icons are thin-stroke (~1.5px) line glyphs on ONE centerline, evenly rhythmed. The active item is a soft rounded-square fill behind the icon — not a bar, not a color, just a quiet grey. The rail shares the page's background; a hairline is the only separation. Nothing is bold. The overall read: a strip of breathing room that happens to contain five glyphs.

**ref-4 (Prismo — collapsed vs expanded anatomy).** Same module everywhere: avatar ≈ 36–40, icon buttons ≈ 40, rows ≈ 40. Expanded adds a left-aligned identity head (avatar + name + badge), a hairline divider, then icon+label rows — labels regular weight, active row a grey fill with a chevron. The expanded panel reads as its own object with its own left edge — not as "the page got narrower".

**ref-5 (command panel) + ref-6 (menu mastery).** The expansion is a LAYER: a floating, rounded, softly-shadowed card that hovers OVER the page. The page beneath does not re-layout; at most it recedes. ref-6 additionally shows the active item as a filled pill inside the rail and section grouping inside the expanded card.

**ref-2 (states) + ref-3 (glass chips).** Fill vocabulary: quiet grey for hover, near-black pill for primary actions, soft outer shadows, generous radii, everything on a light neutral field. Depth comes from shadow + blur, never from borders getting louder.

Measured positions (approximate, from the images): ref-1 rail ≈ 80px logical with ≈24px icons (rail ≈ 3.3× icon); ref-4 rail ≈ 64px with 40px module rhythm and ≈205px expanded. Our current build: rail 76px, expanded 268px, rows 44px, labels at weight 500, name at 700, a left indicator bar, a wordmark, a name row. **Every one of those values contradicts the references.** The rebuild is not styling — it is re-derivation.

---

## 1. The perspectives — what each discipline would do that the owner is not asking for

**The design engineer (performance, correctness under motion).**
The owner asks for "smoother, better latency". The engineer knows *why* it isn't: the sidebar animates `width` while carrying `backdrop-filter: blur(40px)`. Every animation frame re-rasterizes a *different-sized* blur region — that is the jank. The fix the owner isn't asking for: **make the blurred surface constant-size and let the panel be a clipping window that reveals it** (the blur layer sits at expanded width, anchored left; the rail's `overflow: hidden` + radius clip it). The blur never re-renders its region during the animation; the glass *reveals* instead of *re-computing*. Second unasked fix: the old model animated the content's `margin-left`, which forces **layout** on the entire homepage every frame — every card, cover and progress bar re-wraps. Moving the reaction to `transform` makes it compositor-only: zero relayout, ever. Third: explicit `z-index` layering so the expanded panel floats above content by construction, not by paint-order accident.

**The typographer.**
"No bold fonts" is the visible ask. The deeper one: a rail label at 13px Helvetica 500 vs 400 is the difference between *labels* and *shouting*; the references set everything in regular. The unasked discipline: one text color hierarchy (fg-2 labels, fg-3 handle, fg-1 active), one size (13px) for all rail text, −0.01em tracking on small Helvetica, and optical alignment — the 20px icon box centers against the 13px x-height, not the em box, so the icon sits a hair above naive centering. The handle replaces the name entirely: identity lives in the avatar image; "@prathamarchives" is metadata, set quiet, never twice.

**The mathematician (geometry).**
The owner says "measure everything like a world-class architect". The derivation: **one module, 40px** — avatar, icon button, row: the same cell, because equal things must be equal (ref-1/ref-4 both do this). **One column, 64px** = 12 + 40 + 12 (the module plus its breathing margins — no other width is defensible). **Expanded = 3.5 × collapsed = 224px** — a rational multiple, so the expansion feels derived from the rail rather than chosen; 224 also exactly fits 12 + 40(avatar) + 10 + ~118(handle) + 8 + 16(chevron) + 12. **Rhythm: 6px** between 40px cells (46px centers) — tighter than the old 44px rows with 4px gaps and visually denser than it sounds because the fills are larger. Radius: 12px on a 40px cell (0.3 ratio, squircle-adjacent), 24px on the panel. One axis: collapsed, everything centers on the rail's centerline; expanded, everything left-aligns to 12px. Two states, two alignments, no in-between.

**The motion designer (Disney's 12 principles, ADSR envelopes).**
"Decent but smoother, better latency." The unasked framework: an interaction is an **envelope** — attack (time-to-first-motion), decay/sustain (the glide), release (the close). Current attack is 120ms delay + 480ms glide — past the ~100ms "instant" perception window, so it feels laggy. New envelope: **attack 80ms**, glide 380ms (same `--ease-glide` — the curve was right, the timing wasn't), **release 160ms** delay (a flick-away must not thrash, but must not linger). Labels ride the same envelope offset late (fade IN after the panel is moving; fade OUT immediately on leave — they die into the slide). Follow-through: the panel's shadow deepens as it expands (shadow-1 → shadow-3) so the lift is *caused*, not decorated. Anticipation: the content breath *begins with* the panel, same delay — the page leans 6px and shrinks 0.4% toward the panel, an acknowledgment, not a move.

**The product architect (meaning of positions).**
Moving the avatar to the top is not cosmetic — it redefines what the top of the sidebar IS. Top = identity (who you are), middle = navigation (where you go), bottom = utilities (pin). Consequence the owner isn't asking for: **the account overlay's origin must follow its trigger** — it grew from bottom-left when account lived at the bottom; now it must grow from top-left. Origin continuity is what makes UI feel physical. And the pin button, demoted from the header row (where it sat beside the wordmark), becomes a quiet utility at the rail's foot — ref-1's pattern (settings lives at the rail's bottom).

**The cultural reader (taste).**
The references share one cultural signal: *restraint as luxury*. Skroll, Prismo, the command panels — none of them announce. Our current rail announces: a wordmark, a name, a bold handle, an active bar, a 268px sprawl. The corrected rail should be describable in one sentence: **"a 64px column of five quiet glyphs, anchored by a face at the top."** If any element can be removed without losing function, it was decoration. The wordmark is the clearest casualty — the product's name does not need to follow you while you read; the favicon and the page itself carry identity.

---

## 2. The rawest material (what to actually start from)

Not "a sidebar component" — the digested form. The raw material is:

1. **The 40px cell.** A square module with a 12px radius, repeating on a 6px gap. Everything interactive in the rail is this cell (avatar, three nav buttons, pin). Before any styling, this grid *is* the design.
2. **The 64px column** and its rational expansion (×3.5 → 224). Two numbers, one ratio — the entire width story.
3. **One centerline** (collapsed) and **one left edge at 12px** (expanded). Alignment is the design; the elements merely occupy it.
4. **The stroke** — 1.5px round-cap line icons at 20px inside the 40px cell. The glyph weight IS the rail's voice.
5. **Two greys and a hairline** — hover fill, active fill, 1px divider. No color decisions to make; only calibrations.
6. **Helvetica 400 at 13px** — one voice for every word in the rail (handle, labels). Regular weight is the loudest the chrome ever gets.

Everything else — glass, blur, shadow, motion — is applied to this skeleton, never replaces it.

## 3. Methods and techniques, borrowed across fields

- **Architecture — the module (Palladio → Müller-Brockmann):** derive all sizes from one cell and its multiples; prohibit off-grid values. Concretely: 40 / 64 / 224 = cell / column / panel; 12 and 6 are the only margins.
- **Compositing / VFX — render layers & aperture:** separate the *surface* (constant-size blur layer, cached by the compositor) from the *window* (the clipping panel). The expansion becomes an aperture opening over a fixed glass, the single largest smoothness win available in CSS.
- **Optics / photography — depth of field:** the expanded panel floats (shadow-3, blur beneath it) while the content recedes a breath (translateX 6px + scale 0.996, origin left). Parallax of one layer over another is how flat screens say "these are different depths" — the reaction the owner asked for, justified by optics rather than taste.
- **Psychoacoustics / HCI — the 100ms boundary:** response initiation under ~100ms reads as *instant*; 120–200ms reads as *responsive*; beyond reads as *lag*. Attack = 80ms. Total travel 380ms lands inside the "smooth but obedient" band (Nielsen's 0.1s/1s limits; Disney's slow-in-out for the body).
- **Music — ADSR envelope:** attack 80ms, sustain = glide curve, release 160ms delay on close, labels offset ±60ms as grace notes. The rail should feel like an instrument with a fast transient and a damped tail — never a door slamming.
- **Geometry — rational ratios:** 3.5:1 expansion (224 = 3.5 × 64) instead of an arbitrary 268; radius:cell = 0.3; rhythm centers 46px. Numbers that relate to each other survive scrutiny; isolated numbers decay.
- **Editorial typography — the single voice:** one size (13px), one weight (400), three opacities. Hierarchy by value, never by weight, inside the chrome.

## 4. What, beyond owner and agent, proves the result right

1. **The ruler (mechanical):** `getBoundingClientRect` in a real browser — rail exactly 64.0px collapsed, 224.0px expanded, avatar/nav/pin cells exactly 40.0px, rows 40.0px, gaps 6.0px. Numbers or it didn't happen.
2. **The compositor (mechanical):** computed transition on `.content` is `transform` (not margin/width); the blur layer's width is constant across states (computed `::before` width identical collapsed vs expanded); transition-delay values match the envelope (80/160/labels).
3. **The voice (mechanical):** zero `font-weight` > 400 inside the sidebar subtree; zero instances of the wordmark class in the DOM; account head shows exactly one text node: `@prathamarchives`.
4. **The eyes (comparative):** screenshots collapsed/expanded in both themes, side-by-side against ref-1 and ref-4 — the rail must read as *quiet*; the expanded panel must read as a *layer over* the page, not a resize of it.
5. **The stranger (behavioral):** a first-time user should find the account in under two seconds (top-left face is a universal avatar convention) and should never see the homepage jump — the breath is subliminal, the panel is the only movement.
6. **The reduced-motion user (accessibility):** with `prefers-reduced-motion`, every state change still completes (fades), the breath and drift collapse to opacity — function intact, motion gone.
7. **The repo (institutional):** verify.sh gains permanent checks born from this pass's failure class (wordmark must not return; bold must not return in chrome; geometry tokens must exist) — the ratchet, so this correction can never silently regress.

---

## 5. The derived spec (what will be built)

| Thing | Value | Derivation |
|---|---|---|
| Rail collapsed width | 64px | 12 + 40 + 12 |
| Rail expanded width | 224px | 3.5 × 64; fits handle row |
| Cell (avatar/nav/pin) | 40px | the module |
| Icon inside cell | 20px, stroke 1.5 | ref-1/ref-4 voice |
| Cell gap | 6px | rhythm 46px centers |
| Row grid (expanded) | pad 12 · icon 20 · gap 12 · label | compact alignment |
| Divider | 1px hairline, 40px wide collapsed → full expanded | ref-4 anatomy |
| Label / handle | 13px · 400 · fg-2 (active fg-1) | one voice |
| Active state | glass fill pill on the cell, radius 12 | ref-1/ref-4; left bar deleted |
| Wordmark / name | deleted | owner + ref-1 |
| Pin | bottom utility, 32px, icon-only | ref-1 bottom pattern |
| Expansion | overlay: panel floats at z-sidebar, shadow-1 → shadow-3 | ref-5/ref-6 layer model |
| Content reaction | translateX(6px) scale(0.996), origin left, same envelope | "a little bit motion", no slide |
| Envelope | open: delay 80ms · dur 380ms · close: delay 160ms | ADSR / 100ms rule |
| Labels drift | in: +120ms · out: 60ms | die into the slide |
| Account overlay | grows from TOP-left (origin follows trigger) | avatar moved to top |
| Blur architecture | constant-size ::before glass, clipped reveal | compositor method |
| Bold in chrome | forbidden (400 max) | owner + refs |

The failure classes this pass must ratchet into verify.sh: wordmark resurrection, bold in chrome, geometry tokens missing, content margin-slide regression.
