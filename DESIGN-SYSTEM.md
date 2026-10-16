# DESIGN-SYSTEM — arivo visual language (v0.1)

The locked spec for what things look like and how they move. Written from the owner's vision words (INT-004) and the eight references in `context/refs/`. Every value here traces to an owner word or a reference — nothing invented without a label. Implementation lives in `design/` and must match this file; this file wins.

Methodology aligned with the design.how skills package (owner-provided): tokens named by PURPOSE never by value; every component ships its complete states; rules written as Don't/Do pairs; checks that catch drift. Extended to arivo's governance: every token family cites its grounding.

## What each reference locked

| Ref | What it contributes |
|---|---|
| `Interface _ Are_na` | Home anatomy: quote-first feed, book card (cover + meta + progress + primary pill), section headers with chevron |
| `Panora - Concept Design` | Floating glass tab bar with active pill; glass chips over media; huge typographic moments; dark canvas, big radii |
| `download (18)` — Frosted/Clear/Blur | THE glass recipe: three blur levels (clear / frosted / blur), hairline light border, ~28px radius on glass panels |
| `download (20)` — My books | Folder cards: covers peeking out of a glass folder, "Name · N books" caption, filter pills above, dark canvas |
| `download (23)` — Bookmarks | Collection cards with stacked covers + counts; filter pill row; search field with removable chips |
| `download (21)` — Journal scrapbook | Journal is a PAGE, personal and raw (taped photos, handwriting) — the archive surface must feel authored, not generated |
| `download (24)` — Decks | Softness: dot-grid texture, blob-like radii, gentle toggles, sticker-ish media |
| `Styleguides — Build patterns` | States discipline: Default/Hover/Pressed/Disabled per component; focus ring ALWAYS visible; border thickness 1/1.5/2; shadow levels; icon sizes 16/20/24 |

## Foundation

### Palette — grayscale discipline (INT-004: "grey and white thats it", dark mode)

Dark is the designed-first mode. Light is derived from the same roles — no hue in either. Tokens are named by role; components may only reference tokens.

| Role (dark value) | Token | Use |
|---|---|---|
| `#09090A` | `--bg-0` | canvas |
| `#101013` | `--bg-1` | page well / recessed areas |
| `rgba(255,255,255,.055)` | `--surface-glass` | glass panels (sidebar, cards, overlay) |
| `rgba(255,255,255,.09)` | `--surface-glass-strong` | glass on hover / active pill / panel header |
| `#17171B` | `--surface-solid` | covers, solid chips |
| `#1F1F24` | `--surface-raised` | hover-raised cards |
| `#F5F5F7` | `--fg-1` | primary text |
| `rgba(240,240,245,.62)` | `--fg-2` | secondary text |
| `rgba(240,240,245,.40)` | `--fg-3` | meta text |
| `rgba(240,240,245,.26)` | `--fg-4` | disabled / ghost |
| `rgba(255,255,255,.08)` | `--border-hair` | hairline borders (1px everywhere) |
| `rgba(255,255,255,.15)` | `--border-strong` | hover borders |
| `rgba(255,255,255,.5)` | `--border-focus` | focus ring (ALWAYS visible — Styleguides ref) |

Light theme swaps values, never roles (`[data-theme="light"]` in tokens.css).

### Typography — Helvetica (INT-004: "the font we'll be using is helvicta")

Single family. Faces shipped: Light 300, Regular 400 (+Italic), Bold 700, Rounded Bold (on disk, unassigned — the wordmark was removed, INT-007). Fallback: `"Helvetica Neue", Helvetica, Arial`.

| Preset | Spec | Use |
|---|---|---|
| display | 500 · 40/1.1 · -0.02em | page titles — INT-012 amendment: 300 was the thin techy voice; R7 speaks at medium |
| title | 700 · 22/1.25 · **chrome exception: overlay name = 400** | section titles |
| heading | 700 · 16/1.35 | card titles |
| body | 400 · 15/1.55 | main text, quotes |
| meta | 400 · 13/1.4 | secondary rows, sidebar labels, handle |
| micro | 500 · 11/1 · +0.08em · uppercase | eyebrows, captions |

**Chrome weight law (INT-007):** sidebar + overlay text is weight 400, maximum. Hierarchy by value (fg-1/2/3), never by weight. The avatar monogram's 700 is artwork voice, not typography.

### Radius — no sharp corners (INT-004: "no sharp corners")

`--r-xs 8` (chips, small pills) · `--r-sm 12` (inputs, mini covers) · `--r-md 16` (cards, buttons-lg) · `--r-lg 20` (book/folder cards) · `--r-xl 24` (glass panels, sidebar) · `--r-2xl 28` (overlay) · `--r-pill 999` (pills, primary buttons). Even icons use round linecaps/linejoins.

### Elevation & glass — the Frosted ref (download 18)

Three blur levels, as tokens:

| Level | Recipe | Use |
|---|---|---|
| clear | `bg rgba(255,255,255,.05)` no blur, hairline border | chips over solid bg |
| frosted | `backdrop-filter: blur(24px) saturate(1.4)` + `--surface-glass` + hairline + inner top highlight | cards, sidebar, panels |
| blur | `backdrop-filter: blur(40px) saturate(1.6)` + `--surface-glass-strong` | overlay, overlay backdrop, active pill |

Shadows (grayscale only): `--shadow-1 0 2px 8px rgba(0,0,0,.25)` · `--shadow-2 0 12px 32px rgba(0,0,0,.35)` · `--shadow-3 0 24px 64px rgba(0,0,0,.45)`. Inner top highlight on glass: `inset 0 1px 0 rgba(255,255,255,.06)`.

**Canvas law (REVIEW pass 2):** glass panels are only as real as the light behind them — the canvas carries three luminous glow stations (top-left strong, top-right, bottom-center) + noise. If a screenshot reads flat black, the glass has failed: fix the canvas, not the panel alpha.

### Space, icons, texture

Spacing scale: 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56 · 72. Icon sizes: 16 / 20 / 24 only (Styleguides ref). Stroke 1.5, round caps. Canvas texture: three fixed radial glow stations (white @ 5–11% alpha) + SVG noise at ~3.5% opacity — glass needs something to refract.

## Motion — THE system (INT-004: "a bit motion blur and transition", "same animation/motion rules... consistency allover", "focus on that blur")

Three laws:

1. **One easing family.** Everything structural moves on `--ease-glide: cubic-bezier(.32,.72,0,1)`; micro-interactions on `--ease-out: cubic-bezier(.22,1,.36,1)`. No other curves, ever.
2. **Blur marks structural movement.** Any element appearing as a result of structural motion (sidebar labels, overlay, page entry) animates `opacity + filter: blur(8px→0) + translate(6px→0)`, staggered ~40ms per item. This is the motion-blur brand (CSS approximation, locked technique).
3. **Micro is fast, never bouncy.** Hover/press ≤ 200ms. Press = scale(.985). Lift = translateY(-2~3px) + border brighten + shadow-2. No bounce, no spring.

| Preset | Spec | Use |
|---|---|---|
| glide-panel | 380ms · glide | sidebar expand/collapse, account overlay grow |
| rise-page | 320ms · glide | page switch entry (blur+rise) |
| drift-in | 240ms · glide · +40ms stagger | labels/rows appearing inside structural motion |
| press-micro | 160ms · out | hover lifts, borders, chips |
| fade-soft | 200ms · out | tooltips, toggles, backdrop |

**The envelope (INT-007):** an interaction is an ADSR shape — attack 80ms delay (inside the ~100ms "instant" perception window), sustain = the glide, release 160ms delay (a flick-away must not thrash). Pinned state = instant (0ms). Labels ride late: +120ms in, 60ms out (they die into the slide).

`prefers-reduced-motion`: movement collapses to opacity-only fades. Non-negotiable.

## Components — registry & states

Every component: Default / Hover / Pressed / Disabled / Focus (ring always visible). States live in components.css + shell.css. ⬜ = built this pass, ◻ = specced, built on its layer.

| Component | File | States | Notes |
|---|---|---|---|
| Sidebar (the 44px rail) | shell.css | collapsed / hover-expanded / pinned | **Geometry (derived, INT-009 — supersedes INT-007's 64/224):** cell 32 (icon 20 + 6 enclosure) · rail 44 = 6+32+6 (owner: "cut 1/3") · expanded 176 = 4×44 · axis x=22 (ONE centerline: avatar, icons, pin) · rhythm 8px · radius r-sm (=12, directive A) on cells, r-xl panel. Anatomy: avatar 28 TOP (identity anchor) → hairline → nav → pin foot (utility). Expansion = OVERLAY: the panel floats above the page (z-sidebar, shadow-1→shadow-3); the page answers with a breath — translateX(3px) scale(.998) (directive D: 2–4px band), transform only, zero reflow. Glass = constant-size ::before revealed by the clipping panel (aperture model — blur region never re-rasterizes mid-animation; `z-index: -1` on the pseudo is LOAD-BEARING: without it the glass paints over its own children). Spring render (k300/c30/m0.8 → ζ0.968, settle ≈213ms): 240ms glide · attack 50ms / release 100ms / pinned 0ms. Collapsed rail SPEAKS THROUGH dark tooltips (bubble + directional pointer); `will-change: width` isolates the interpolating layer. |
| Nav item | shell.css | rest / hover / active | 32px cell · icon 20 (stroke 1.5) · label 13/400 · icon→label gap 8px (directive C: ≤10); expanded: icon aligns to avatar's left edge; active = `--tint-selected` pill R12 (the pass-3 glass-strong fill was WHITE-ON-WHITE in light theme — invisible; the tint family is theme-correct in both); tooltips carry labels while collapsed |
| Pin button | shell.css | rest / hover / pinned | 32px = the cell itself, rail FOOT (utility lives at the bottom, G5Ka pattern); margin 0 — centered on the axis in both states |
| Account head → overlay | shell.css | rest / hover / open | avatar 28 (shell override of avatar-lg; 28 = 1.4 × icon) + `@prathamarchives` handle only (13/400, fg-2) — no name, no wordmark; overlay grows from TOP-left (origin follows the trigger); overlay title = the handle itself (INT-009 C supersedes pass-3's "display-name destination" decision) |
| Overlay panel | shell.css | open / closing | blur level 3, --r-2xl; backdrop alpha 0.38 dark / 0.18 light; name weight 400 |
| Button primary (pill) | components.css | all 5 | white bg, near-black fg |
| Button ghost / icon | components.css | all 5 | glass, hairline |
| Filter pill | components.css | rest / hover / active | active = glass-strong + fg-1 |
| Chip (classification word) | components.css | rest | outlined, free-text words (D-030) |
| Book card | components.css | rest / hover | cover 2:3 RICH (INT-012, supersedes pass-2 "title lives once": 58px upright letter LEFT + title/author INSIDE the cover — the cover's voice; title ALSO below at 600), meta row, progress 4px luminous fill, Read pill (ink-inverted) |
| Cover placeholder | components.css | artwork only | cv-a..f = six NEUTRAL warm-grey tones (v3, INT-012 — cool cast removed); monogram = ONE letter, upright, light-300; adjacent works never share a tone |
| Folder card | components.css | rest / hover | glass folder, covers peek (distinct tones), "Name · N" |
| Quote card | components.css | rest / hover | Are.na anatomy: glyph, quote, source, chips |
| Journal day card | components.css | rest / hover | big numeral, excerpt, entry count |
| Note card | components.css | rest / hover | raw text, diagram block variant |
| Concept card | components.css | rest / hover | name, def, linked count, growth bars |
| Progress bar | components.css | static / animated | 3px track (0.18 alpha), white fill + soft luminous edge |
| List card | components.css | rest / hover | mini-cover stack (3 distinct tones) that fans out on hover |
| Avatar | components.css | sizes 24/32/40 | monogram grayscale |
| Toggle | components.css | on / off / focus | Decks-ref softness |

## Rules — Don't / Do

- **Don't:** introduce any hue, any sharp corner, a new easing curve, a raw hex/px inside a component, an icon outside 16/20/24, a state shipped incomplete, a movement without blur treatment. · **Do:** tokens only; states complete; focus always visible; one family of motion; blur on structural movement.
- **Don't:** repeat content between a cover and its caption — the title lives ONCE. · **Do:** covers are pure artwork (fill + sheen + spine + monogram); text sits below.
- **Don't:** end a horizontal scroll row without a continuation cue (right-edge fade). · **Do:** a cut card must visibly dissolve.
- **Don't:** let a positioned decorative pseudo paint over content (::before with z auto covers non-positioned children — the rail swallowed its own avatar, pass 3). · **Do:** decorative layers behind content get `z-index: -1` inside a stacking-context parent, verified by screenshot.
- **Don't:** reflow the page to make room for a panel (margin/width shifts drag every card per frame). · **Do:** panels float OVER the page; the page reacts in `transform` only.
- **Don't:** ship dark glass on a dead-black canvas. · **Do:** keep the canvas glow stations alive (see Canvas law).
- **Don't:** invent content surfaces the owner didn't name. · **Do:** extend the named ones (Home/Library/Archive/Account) and ledger new intent first (L-06).
- **Don't:** let a component drift from this file. · **Do:** treat a mismatch as a defect — fix code or spec through Loop 2, never silently.

## Checks

- Repo-level: `bash verify.sh` (quarantine, secrets, integrity) before every push.
- Design-level: rendered browser screenshots at 1440×900 (Loop 4, "verified by run"); the state checklist above per component; contrast sanity on fg roles (fg-1 on bg-0, fg-2 ≥ readable for meta).
- Iteration log: `design/REVIEW.md` — every pass documents named defects (with evidence) → fixes → re-verification. A pass without a REVIEW entry didn't happen.

## Pass 4 — INT-008/009 compaction & tactile system (2026-10-16)

The owner's numeric directive (INT-009) supersedes the directional pass-3 values. **Derived grid (stated once, in `context/intake/INT-009-extraction.md`):** rail 44 = 6+32+6 · cell 32 (icon 20 + 6 enclosure) · expanded 176 = 4×44 · avatar 28 on axis x=22 · nav rhythm 8 · gap 8 · labels 13/400 · R12 selection.

New laws this pass (all ratcheted into verify.sh 5f):
1. **Total product-surface purge** — "arivo" appears ZERO times in `index.html` (title, greeting, About row, footer, favicon all carried it after pass 3's sidebar-scoped ban; the ban is now whole-file). Identity is exactly `@prathamarchives` everywhere it appears.
2. **Selection must be VISIBLE in both themes** — active/hover fills use the `--tint-*` family (ink-based in light, white-glass in dark). The pass-3 glass-strong active pill was white-on-white in light theme — the owner's "account/profile is messed up" class of defect.
3. **Dark tooltips with a directional pointer** (directive B exact: #0D0D0E/#FAFAFA light-theme, 12px horizontal padding, 13px text, rotated-square pointer) — the collapsed rail's voice. Suppressed while expanded.
4. **Latency law** — `--dur-panel ≤ 280ms`; the spring render is 240ms (k=300, c=30, m=0.8 → ζ=0.968 near-critical, settle ≈213ms; NO bouncy curve — that would be ζ≈0.6, which the directive's constants explicitly are not). Attack 50ms.
5. **Breath band** — content reaction stays within translateX 2–4px (+ ≤0.3% scale); a larger lean is the dead margin-push returning in disguise.
6. **Landing = visible** — the preview server sends `Cache-Control: no-store` and asset links carry `?v=`; unverifiable-by-owner work is not done (L-13).

Colour verification (directive ↔ constitution): #FFFFFF/#F4F4F6–#FAFAFA = `--surface-solid`/`--bg-0`/`--bg-1` exact; #18181B-class dark pills = `--fg-1`-driven + `--shadow-cta` (Y6/blur14/18% — inside the directive band); Inter/SF/Geist class = the constitution's self-hosted Helvetica (INT-004 law stands, same grotesk class). Zero raw hex entered component CSS.
