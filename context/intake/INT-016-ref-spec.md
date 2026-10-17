# INT-016 reference spec — the attached screenshot, measured

Source: owner turn 16 attachment `G5Ka2M7a4AEtBOm.jfif` (4096×4096, preserved at intake time; copy kept in the session sandbox upload dir). A light-theme app ("Skroll" — an AI generate/chat tool) shown in a portrait window on a light desk (#F5F5F5). This document records the forensic measurements that ground the sidebar rebuild + full-page conversion. Method: PIL pixel scans (region maps, run detection, edge detection) + grid-annotated VLM passes (red vertical / blue horizontal gridlines drawn onto crops so positions are read against labeled coordinates) + color sampling. Pixel measurements are authoritative; VLM supplied content reads (which icon, which text).

## Calibration

- Window frame in image: x 570→3118 (2548 px wide), y 679→4095 (cut off at image bottom).
- Read: the capture is ≈ **2.49×** a **1024-CSS-px-wide** portrait window (2548 / 2.49 = 1024.0 exactly; visible height 3416/2.49 ≈ 1372 ≈ the 1366-class portrait window). Touch-first sizing throughout is consistent with a tablet-class capture.
- **All CSS values below = image px ÷ 2.49, rounded to clean numbers.**

## Sidebar (the focus of INT-016)

| property | image px | CSS |
|---|---|---|
| width | 428 (x 574→1002) | **172** |
| background | #FFFFFF (same as content; separation only by hairline) | — |
| divider to content | #EAEAEA, ~1px, full height | 1px #EAEAEA |
| rail corner radius / border / shadow | none — flush to window edges, full height | none |
| avatar | circle, ~180 px, centered (center x 786 ≈ rail center 788) | **72px, centered** |
| avatar top inset | 150 (frame top 679 → avatar top 829) | **60** |
| nav items | 8, icon-only, centered; NO labels, NO dividers, NO badges | icon-only |
| icon glyph size | 124–144 (bbox incl. multi-part glyphs) | **~52** |
| icon color | #8A8A8A — IDENTICAL selected vs unselected | #8A8A8A |
| item pitch (center→center) | 328, perfectly uniform | **132** |
| first item center below avatar center | 446 | 179 |
| selected pill | x 640→932 (292), y 1900→2144 (245) | **117 × 98** |
| pill inset from rail edges | 66 left / 70 right | ~26–28 |
| pill corner radius | corner fills within ~20 px (antialiased) | **12** |
| pill color | #F7F7F9 on #FFFFFF (no border, no shadow, no icon change) | #F7F7F9 |
| bottom of rail | cut off in the reference (8th icon last visible) | Arivo keeps its tools centered at bottom |

## Content area composition (for the full-page conversion + later iterations)

- Content bg #FFFFFF; content side margins ~80 px → **32px** both sides.
- Header: top inset 137 → **55px**; breadcrumb title (dark "Skroll" + gray "/ Home", cap ~70 px → ~28px font) with a **dark pill CTA 68px tall** (image 169; #2E2E2E, white label, fully-rounded) inline 53px after the title. No right-aligned tools in the reference.
- 85px gap → full-width **segmented control** (y 1198→1495 → **119px tall**, track #F4F4F4, white active segment + shadow, pill ends, "Generate" dark active / "Chat" gray inactive).
- 31px gap → **content card**: x 1084→3042, radius ~24–28, hairline border #E8E8E8; contains the isometric map image, description text, and a button row (**68px-tall** dark pill + white pill w/ border, left-aligned).
- Instructional text line below; then a thin full-width gray rounded bar (~30px tall) near the fold cut.
- Rhythm: big touch-scale elements, generous uniform gaps, near-monochrome surface (white / #F4–F7 grays / #2E dark pills / #8A gray icons+text).

## Arivo port decisions (interpretation, per INT-016 ledger)

1. **Static rail** — the reference has no expand/collapse; the INT-009 48→176 overlay machinery is superseded for this scope. Tooltips remain the label channel (icon-only nav needs them).
2. **Fixed 172px** (the reference's native component size) rather than viewport-ratio scaling — "components size" ported literally; ratio scaling is an owner-callable iteration.
3. **Dark mapping** (index.html): same geometry; rail bg = page bg #171717; divider = Arivo hairline #484846→#3A3A38; icons #9C9C9A; pill #232327. **Light mapping** (5 light pages): reference literals.
4. Arivo has 3 destinations (Home/Library/Archive) vs the reference's 8 items — same composition, fewer items (top-aligned at the reference's pitch, not stretched).
5. Segment control + card anatomy are recorded but NOT ported this pass — the owner's ordered scope is full-page + sidebar; content-area composition follows in the iteration loop.
