# INT-009 EXTRACTION — Spatial UI Architecture & Micro-Motion (paint pass 4)

Executed 2026-10-16 · grounds: INT-007 → INT-008 → INT-009 (verbatim in `context/raw/`)
Reference corpus: 15 images viewed and catalogued (`context/references/converted/`).
Primary sidebar acceptance images: **G5Ka2M7a4AEtBOm (1).jfif** (owner-named, ×2 identical),
**Side Menu Mastery** (expanded/flyout grammar), **mathias coudert** (expanded-state mirror),
**Clean Design Layout** (tactile pill/elevation grammar), **download (25)** (popover/kbd grammar),
**download (18)** (glass taxonomy), **Panora** (dark glass tab bar), **download (20/23/24)**,
**Interface / Are_na** (reading-domain texture), **Styleguides** (icon ladder 16/20/24, stroke
ladder 1/1.5/2, shadow levels, focus always visible), **download (21)** (journal texture),
**Ali-en** (glass action chips over text).

---

## PART 1 — The lenses: what the professionals would do that you did NOT ask for

**The architect (modular scale, optical balance).** He would not "shrink the sidebar"; he would
re-derive the rail from one module so every number is a consequence, not a choice. He would also
catch what you didn't ask for: *optical* centering (a geometrically-centered 20px glyph in a cell
reads 0.5px low; icons get a −0.5px optical lift), *one* centerline for avatar/icons/pin so the
collapsed rail reads as a single drawn object, and hairlines that are module-width when collapsed
and full-width when expanded (the rail "unfolds" its own divisions). He would also refuse
sub-pixel widths: every edge lands on whole px so hairlines stay 1px crisp at 1×.

**The geometry PhD (coordinate matrix, spring dynamics).** He would treat the expansion as a
1-D dynamical system and solve it: stiffness 300 / damping 30 / mass 0.8 gives ω₀ = √(k/m) =
√375 ≈ 19.36 rad/s, ζ = c/(2√(km)) = 30/30.98 ≈ **0.968** — near-critically damped, overshoot
e^(−ζω₀t) at peak ≈ 5·10⁻⁶ ≈ invisible, settling (2%) ≈ 4/(ζω₀) ≈ **213 ms**. Therefore: a
~240 ms ease with no elastic wobble is the *correct* CSS rendering of that spring — not a
bouncy curve (a bouncy curve would be ζ ≈ 0.6, not the directive's numbers). He would also
insist the expanded width be a **rational multiple of the rail** (4 × 44 = 176) so the grid
survives both states, and that the content reaction live on the compositor (transform only),
which is why the breath is translate+scale and never width/margin.

**The cultural tastemaker (restraint, contemporary taste).** She would remove more than she
adds: no visible container border around the whole rail in light theme if the reference reads
borderless-white-on-off-white; shadows reserved almost exclusively for dark pills (the ref's
tactical silence everywhere else); icon color at ~62% ink, never full black, so the rail whispers;
identity as plain text next to the avatar — no logo, no lockup. She would kill the greeting's
ornamental weight ("Good evening, @prathamarchives" stays regular), and keep EVERY string
sentence-case — the ref's voice is quiet, not shouty.

**The senior design engineer (isolation, latency, no paint storms).** He would (a) keep the
aperture-glass model (constant-size ::before revealed by a clipping window — blur never
re-rasterizes mid-animation), (b) move the content reaction fully onto transform with
`will-change` discipline, (c) shorten the envelope so hover feels instant: attack ≤ 60 ms
(under the ~100 ms "instant" perceptual floor), (d) never animate a property that triggers
layout on the page — only the rail's own width animates, in its own layer, and (e) add
`contain: layout paint` scoping where free. He would also demand the preview server send
`Cache-Control: no-store` and asset links carry a version query — because work the owner
cannot see does not exist (the INT-008 failure).

**What they would all flag that you didn't ask for:** the favicon still carried the old "a"
monogram; tooltips were missing entirely (the directive's dark-pointer tooltip is a *missing
component*, not a restyle); collapsed-rail labels had no accessible fallback (tooltips fix
that too); the expanded panel needs the icon→label gap ≤ 10px, not the old 12; and the
selected pill must be the *soft tint* container from your named reference (light grey, R12),
with dark pills reserved for primary actions in content — exactly the Clean-Design ref split.

## PART 2 — The rawest material (not pre-digested)

Not "a sidebar component": the raw material is **(a)** the reference pixels themselves —
measured, not remembered; **(b)** the unstyled DOM: `<aside>`, `<nav>`, `<button>` in
document order — head (identity) → rule → nav (3 destinations) → foot (pin); **(c)** raw
SVG paths at stroke 1.5 on a 24×24 grid, currentColor only; **(d)** an empty coordinate
matrix: one vertical axis x = rail/2, rows at pitch = cell + gap, z-layers
(page 0 · breath 1 · rail 40 · tooltip 90 · overlay 70).
Execution starts from these primitives — no inherited 40px cell, no inherited 64px rail.

## PART 3 — Methods & techniques (cross-field)

1. **Gestalt proximity/enclosure (psychology → UI):** icon and label bound as one perceptual
   unit — gap ≤ 10px (directive), while row pitch stays airy; the enclosure is the R12 tint
   container, which is why it must hug the icon (32px cell) rather than the row.
2. **Spring-mass-damper (control theory → CSS):** directive constants solved above →
   `--dur-panel: 240ms` on the glide family; envelope attack 50ms / release 100ms / pinned 0;
   drift in +80ms, out 60ms. Near-critical damping = smooth arrival, zero stiffness.
3. **Optical weight equilibrium (typography → layout):** regular 400 everywhere in chrome;
   handle at 13px/−0.01em; labels 13px; the avatar (28px) is the only heavy object on the
   axis — everything else is line-work, so the rail reads "anchored, not loaded".
4. **Aperture model (optics → blur):** constant-size glass sheet behind a clipping window —
   the blur region is identical in every frame; expansion is revelation, not re-render.
5. **Coordinate matrix (math → layout):** rail = 6 + 32 + 6 = **44px** (64 → 44 = −31.25%,
   your "cut 1/3"); cell 32 = icon 20 + 2×6 enclosure; icon 20 on the ladder (16/20/24);
   axis x = 22; expanded = 4 × 44 = **176px**; row gap 8 → pitch 40; avatar 28 = 1.4 × icon.
6. **Cache-busting / no-store headers (web engineering → delivery):** the preview server
   becomes a no-store server; CSS/JS links carry `?v=` so every change lands the moment it
   exists. (INT-008's failure is ratcheted into infrastructure, not memory.)

## PART 4 — External validators (what, beyond you and me, proves it right)

1. **The ruler:** browser-measured geometry — rail 44±0px, expanded 176±0px, one axis:
   |avatar.cx − icon.cx| = 0px for every icon, pitch 40±0px. Measured via
   getBoundingClientRect in the regression run, not eyeballed.
2. **The frame counter:** expansion under DevTools-free observation — width animates only on
   the rail; content transforms only; no layout thrash (paint storms would show as full-page
   repaints; the aperture + transform-only breath prevent them by construction).
3. **The reference diff:** side-by-side screenshots (collapsed + expanded) against
   `G5Ka2M7a4AEtBOm (1)` — silhouette test: icon-only rail, avatar top, no wordmark, soft
   R12 tint on selection, hairline separation, off-white field with white pills.
4. **The spec sheet:** every directive number checks green — stroke 1.5 ✓, R 12 ✓, labels
   13px ✓, gap 8px ✓, tooltip #0D0D0E/#FAFAFA + pointer ✓, dark pill shadows Y4–8/blur
   12–16/15–20% ✓, tracking −0.01em ✓, no bold in chrome ✓, handle exact ✓, zero "arivo"
   in the product surface ✓.
5. **verify.sh:** new ratchet guards (below) — mechanically green, negative-tested.

## Colour verification against the constitution (PRINCIPLES + DESIGN-SYSTEM)

| Directive value | Constitution mapping | Verdict |
|---|---|---|
| #FFFFFF white containers | `--surface-solid` (light) = #FFFFFF | ✅ exact |
| #F4F4F6–#FAFAFA off-white field | `--bg-0` #F2F2F4 / `--bg-1` #FAFAFB | ✅ within band |
| #18181B dark elevated | `--fg-1` #131315 (light) drives dark pills; dark theme uses near-black surfaces | ✅ same class, token-native |
| #0D0D0E tooltip bg / #FAFAFA fg | new `--tip-bg`/`--tip-fg` (light theme exact; dark theme inverts for contrast on dark canvas) | ✅ added as tokens |
| shadow Y4–8 · blur 12–16 · 15–20% | `--shadow-cta` token added (0 6px 14px rgba(0,0,0,.18) light / .45 dark) | ✅ tokenized |
| Inter/SF Pro/Geist | constitution law = Helvetica (self-hosted, INT-004); same grotesk class, owner's earlier explicit word | ✅ Helvetica stands |

Zero raw hex enters component CSS — the four new values live in tokens.css only (law: hex
outside tokens forbidden).

## THE GRID (derived, stated once, verified mechanically)

```
axis x = 22px (rail centerline)          rail = 6 + 32 + 6 = 44px   (was 64)
cell = 32 (icon 20 + 6 enclosure)        expanded = 4 × 44 = 176px  (was 224)
avatar = 28, centered on axis, top       pitch = 32 + 8 = 40px
labels 13px/400, ls −0.01em              icon→label gap = 8px (expanded rows)
selection: 32px R12 tint container       tooltips: dark, pointer-down, 12px pad, 13px
breath: translateX(3px) scale(0.998)     spring render: 240ms glide, attack 50ms
```
