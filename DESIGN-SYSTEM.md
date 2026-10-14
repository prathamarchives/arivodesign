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

Single family. Faces shipped: Light 300, Regular 400 (+Italic), Bold 700, Rounded Bold (wordmark ONLY). Fallback: `"Helvetica Neue", Helvetica, Arial`.

| Preset | Spec | Use |
|---|---|---|
| display | 300 · 40/1.1 · -0.02em | page titles |
| title | 700 · 22/1.25 | section titles, overlay name |
| heading | 700 · 16/1.35 | card titles |
| body | 400 · 15/1.55 | main text, quotes |
| meta | 400 · 13/1.4 | secondary rows |
| micro | 500 · 11/1 · +0.08em · uppercase | eyebrows, captions |
| wordmark | Rounded 700 · 15 · +0.02em | "arivo" wordmark only |

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

### Space, icons, texture

Spacing scale: 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56 · 72. Icon sizes: 16 / 20 / 24 only (Styleguides ref). Stroke 1.5, round caps. Canvas texture: two fixed radial glows (white @ 3–4% alpha) + SVG noise at ~3.5% opacity — glass needs something to refract.

## Motion — THE system (INT-004: "a bit motion blur and transition", "same animation/motion rules... consistency allover", "focus on that blur")

Three laws:

1. **One easing family.** Everything structural moves on `--ease-glide: cubic-bezier(.32,.72,0,1)`; micro-interactions on `--ease-out: cubic-bezier(.22,1,.36,1)`. No other curves, ever.
2. **Blur marks structural movement.** Any element appearing as a result of structural motion (sidebar labels, overlay, page entry) animates `opacity + filter: blur(8px→0) + translate(6px→0)`, staggered ~40ms per item. This is the motion-blur brand (CSS approximation, locked technique).
3. **Micro is fast, never bouncy.** Hover/press ≤ 200ms. Press = scale(.985). Lift = translateY(-2~3px) + border brighten + shadow-2. No bounce, no spring.

| Preset | Spec | Use |
|---|---|---|
| glide-panel | 480ms · glide | sidebar expand/collapse, account overlay grow |
| rise-page | 320ms · glide | page switch entry (blur+rise) |
| drift-in | 280ms · glide · +40ms stagger | labels/rows appearing inside structural motion |
| press-micro | 160ms · out | hover lifts, borders, chips |
| fade-soft | 200ms · out | tooltips, toggles, backdrop |

`prefers-reduced-motion`: movement collapses to opacity-only fades. Non-negotiable.

## Components — registry & states

Every component: Default / Hover / Pressed / Disabled / Focus (ring always visible). States live in components.css + shell.css. ⬜ = built this pass, ◻ = specced, built on its layer.

| Component | File | States | Notes |
|---|---|---|---|
| Sidebar (floating glass) | shell.css | collapsed / hover-expanded / pinned | 76px → 268px; hover delay 120ms in / 260ms out |
| Nav item | shell.css | rest / hover / active | active: 3px rounded indicator + glass-strong pill |
| Pin button | shell.css | rest / hover / pinned | 28px, top-left, "just small" |
| Account row → overlay | shell.css | rest / hover / open | overlay grows from bottom-left, same glide family |
| Overlay panel | shell.css | open / closing | blur level 3, --r-2xl |
| Button primary (pill) | components.css | all 5 | white bg, near-black fg |
| Button ghost / icon | components.css | all 5 | glass, hairline |
| Filter pill | components.css | rest / hover / active | active = glass-strong + fg-1 |
| Chip (classification word) | components.css | rest | outlined, free-text words (D-030) |
| Book card | components.css | rest / hover | cover 2:3, progress bar, meta, Read pill |
| Folder card | components.css | rest / hover | glass folder, covers peek, "Name · N" |
| Quote card | components.css | rest / hover | Are.na anatomy: glyph, quote, source, chips |
| Journal day card | components.css | rest / hover | big numeral, excerpt, entry count |
| Note card | components.css | rest / hover | raw text, diagram block variant |
| Concept card | components.css | rest / hover | name, def, linked count, growth bars |
| Progress bar | components.css | static / animated | 2px track, rounded fill |
| Avatar | components.css | sizes 24/32/40 | monogram grayscale |
| Toggle | components.css | on / off / focus | Decks-ref softness |

## Rules — Don't / Do

- **Don't:** introduce any hue, any sharp corner, a new easing curve, a raw hex/px inside a component, an icon outside 16/20/24, a state shipped incomplete, a movement without blur treatment. · **Do:** tokens only; states complete; focus always visible; one family of motion; blur on structural movement.
- **Don't:** invent content surfaces the owner didn't name. · **Do:** extend the named ones (Home/Library/Archive/Account) and ledger new intent first (L-06).
- **Don't:** let a component drift from this file. · **Do:** treat a mismatch as a defect — fix code or spec through Loop 2, never silently.

## Checks

- Repo-level: `bash verify.sh` (quarantine, secrets, integrity) before every push.
- Design-level: rendered browser screenshots at 1440×900 (Loop 4, "verified by run"); the state checklist above per component; contrast sanity on fg roles (fg-1 on bg-0, fg-2 ≥ readable for meta).
