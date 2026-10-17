# INT-018 reference spec — the seven attachments, read and synthesized

Source: owner turn 18 attachments (preserved at `context/references/turn-018/`). Method: one focused VLM read per reference (placement / shape / glass / items / motion / detailing / palette / taste element), PIL bright-run + color sampling for the rail-native references, grid-annotated VLM crops (20px red-vertical / blue-horizontal gridlines with coordinate labels) for rail geometry. The set is concept-shot material — cross-image zooms differ — so values below are stated as RANGES with a single Arivo port decision per row.

## Per-reference reads (abridged)

| # | Reference | What it shows | Key numbers |
|---|---|---|---|
| 1 | download-26 | dark popover card (not a rail) | matte black #0A0A0A, 1px #1F1F1F edge, R16-18, deep diffuse shadow 30-40px, 1px #222-#333 separator |
| 2 | Explore\|Layers | horizontal glass toolbar | frosted white rgba(255,255,255,.85-.9) blur 20-24, R12-16, 1px light edge, black pill active (white glyphs), 16-18px icons |
| 3 | Side Menu Mastery | THE sidebar pattern: icon rail + expanded panel | rail 72-80 wide floating inset 24-32, R24-28; items 44-48 high, 8-12 gap, icons 20; active = BLACK pill, white text, full-round; expanded panel ~340-360 with icon+label rows |
| 4 | mathias coudert | floating icon rail, partial height, centered | rail ~88-112 wide, inset ~24 left, R24-28 (grid read R40-60 on w~120 — ratio 0.3-0.5); items 48×48, 12-16 spacing, icons 22-24; active = light gray pill R12-14, dark glyph; white/off-white surface, 1px rgba(0,0,0,.04) edge |
| 5 | download-25 | glass command palette | white ~0.85-0.9 blur 20-40, R24-28, 1px rgba(255,255,255,.4) edge, shadow 0 8px 32px rgba(0,0,0,.08); items 56-64 high, light gray pill R12-16 |
| 6 | Clean Design Layout - Copy | glass cards + floating ink elements | white 0.85-0.9 blur 20-40 (suggests blur(30)), R20-24, 1px rgba(255,255,255,.6) top/left edge shine, shadow 0 8px 32px rgba(0,0,0,.08); ACTIVE = solid dark shape #1A1A1A with its own shadow, floating ABOVE the glass — R12-16; motion taste: spring slide between positions |
| 7 | Ali-en on X | small glass context menu | rgba(255,255,255,.55-.6) blur 12-16, R12-14, 1px rgba(255,255,255,.4), items 40-44 high 4-6 gap, 13-14px/500 labels, micro-interactions 1.02x scale / 150ms |

## The synthesis (what the seven agree on)

1. **Floating, never attached.** Every panel floats inset from edges with visible gaps (12-32px in native-CSS reads).
2. **Glass is the material.** White translucent bg (0.55-0.9) + backdrop blur (12-24, heavy end for big surfaces) + 1px light edge (rgba(255,255,255,0.4-0.6) — "light catching the glass edge") + one soft diffuse shadow (0 8px 32px, ~8% black).
3. **The active state is INK.** Solid near-black pill (or tile R12-16) with inverted glyph, sitting with its own shadow — it reads as floating ON the glass (ref 3, 6, 2 carry this uniformly).
4. **Rail anatomy:** 72-80 wide icon rail; items 44-48 high; icons 20-24; expanded state = wider panel with icon+label rows.
5. **Motion taste:** ~150-220ms transitions, staggered reveals, hover tints (rgba(0,0,0,0.04-0.05)), no layout reflow — panels float over content.

## Arivo port decisions (INT-018)

| Property | Reference range | Arivo value (desktop port) |
|---|---|---|
| rail inset | 12-32 | **12px** all sides (full float) |
| rail corner radius | R24-60 (ratio 0.3-0.5 of width) | **R16** (ratio 0.22 — "reduce the radius" honored) |
| glass bg | white 0.55-0.9 + blur 12-24 | light **rgba(255,255,255,0.72) blur(20px)** · dark **rgba(23,23,23,0.72) blur(20px)** |
| glass edge | 1px rgba(255,255,255,.4-.6) | light **1px rgba(255,255,255,0.65)** · dark **1px rgba(238,238,234,0.10)** |
| rail shadow | 0 8px 32px ~8% | light **0 8px 32px rgba(0,0,0,0.08)** · dark **0 12px 32px rgba(0,0,0,0.45)** |
| active pill | black R12-16 / full-round, own shadow | light **#1E1E1E R6 + white glyph** · dark **#E4E4E0 R6 + #0A0A0A glyph** (icon via CSS filter), pill shadow 0 2px 8px |
| item radius | — | **R6** (reduced from R8 per owner) |
| expanded width | ~340 panels (nested lists) | **184px** (icon+label rows only; icons never move — collapsed center = expanded icon axis x=36) |
| expand timing | ~200ms, spring taste | **width 220ms, near-critical damping** (INT-009 law: ≤280ms, no bounce), labels 140ms fade-rise stagger 30ms from 60ms |
| item hover | rgba(0,0,0,0.04-0.05) | existing tint family stays (dark 0.07 white / light 0.05 black) |
| canvas under glass | gradient/illustrated canvases | body gains fixed glow washes behind the rail (dark rgba(238,238,234,~0.06), light neutral wash) — the pass-2 "glass needs luminosity" law |

Item geometry (49×41, 55 pitch, 30 avatar, 22 icons) and full-page frame unchanged — INT-017 stands; INT-018 adds material + motion + shape, not scale.
