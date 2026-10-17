# INT-023 — Reference Forensics: the account/pfp block (owner turn 23)

Source: `context/references/turn-023/ref-account-block.jfif` (680×680, saved from X —
filename "mathias coudert (@Mcoudert) | X"; the image itself is a two-state sidebar
design: collapsed icon rail LEFT, expanded panel RIGHT, identical vertical geometry).

## Measured palette (PIL raw pixel scans, 5 passes)
- page bg (230,231,235) · panel bg (246,247,249) · search bar white (255)
- divider line y=187 color (229,230,232) ≈ 7% on panel — full panel width
- selected-row fill (233,234,238)-ish, h=50, x[250..575] (inset 27/24 from panel)
- username ink darkest (dark); sub-text grey; inactive icons grey (109,110,112)

## The account block (both states share y; avatar = the unit, 44px)
| element | measured | ratio (÷44) | ported @ avatar 26 |
|---|---|---|---|
| rail width (collapsed) | 110 | 2.50 | 64 (owner-approved rail, kept) |
| avatar diameter | 44 | 1.00 | 26 (= 0.40 × rail 64; was 24 = 0.375) |
| avatar top inset (panel top → avatar) | 40 | 0.91 | n/a (Settings owns the top slot, INT-022 order) |
| username "Prismo" ink h | 15 (font ≈ 18.5, bold dark) | 0.34 | handle 12px/400 — width-capped (see below) |
| sub-text (grey) | ~12.5px | 0.28 | not ported — owner: "@prathamarchives and nothing" |
| avatar → text gap | 19 | 0.43 | 12 (shared label-gap token; 0.46 — harmonizes with nav labels) |
| text vertical | centered on avatar cy | — | flex center (already true) |
| avatar cx vs icon cx | 278.5 vs 280 (aligned) | — | x44 axis law (already true, rAF-proven) |
| avatar bottom → divider | 41 | 0.93 | 24 |
| divider → next element top | 29 | 0.66 | 17 |
| total acct-bottom → first nav top | 70 | 1.59 | 42 (= 24 + 1 + 17, exact) |

## Why the handle font is 12px (not the ref's 18.5)
The ref's name is 6 chars on a 377-wide panel; the owner's handle is 16 chars
("@prathamarchives" = 106.2px in Inter 12) on a 168-wide expanded rail (owner-
approved width, INT-019). Ref ink-ratio (0.42 × avatar) would demand ~11px; the
harmony floor is the nav labels at 12px (handle must not read smaller than the
nav it governs). 12px/400 it stays — the SIZING fix is the avatar (24 → 26),
the divider, and the rhythm, which is what reads "messed up".

## Ported deltas (INT-023 surgery)
1. tokens.css: --ref-rail-avatar 24 → 26 (ref rail ratio 0.40; identity slot height
   rides the token; avatar cx stays 44 — the axis lock is width-in-slot, not size)
2. shell.css: monogram 10 → 11px (proportional); NEW .rail-divider (1px hairline,
   full panel width, var(--ref-header-line)); destinations margin 32 → 17 (divider
   rhythm above); identity→divider margin 24
3. motion.css: divider width rides the one clock (64 → 168, same curve as the panel)
4. 6 pages: `<div class="rail-divider"></div>` between identity and destinations;
   v14 cache-bust

## Un-ported on purpose (standing orders supersede the reference)
- Settings row stays ON TOP of the identity (INT-022 explicit order; the ref shows
  no settings — moving/removing it without an order repeats the INT-021 class)
- Avatar artwork stays the owner's "pa" monogram (prototype content, not geometry)
- Nav labels stay 12px/400 at gap 12 (INT-019/020 approved; not the complaint)
- No bold anywhere in the rail (turn-019 "bold/thickness removed" standing law —
  the ref's bold name is NOT ported as weight)

## Verification contract (owner: "cant you verify multiple times")
1. DOM: collapsed + expanded — avatar 26, cx 44, handle x69/centered, divider
   geometry (x12 flush, 64→168), gaps 24/17, Home y-shift
2. rAF: avatar cx 44 EVERY frame of the 64→168 expansion (axis law)
3. VLM side-by-side vs the reference, dark + light, ≥2 rounds
4. 6 pages console-clean; handle clearance ≥ 4px from the panel edge
5. verify.sh re-ratchet: 5e avatar literal, NEW 5m divider guards
