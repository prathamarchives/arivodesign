# the design surface — the owner's v1 prototype, replicated one-on-one (INT-013)

Static prototype. No framework, no build step. As of INT-013 the product surface is the
OWNER'S OWN Figma v1 prototype (uploaded as `figma-export.zip`, archived at
`context/references/figma-v1/`) — replicated one-on-one and brought alive with the
harness's motion vocabulary. Passes 1–5's derived design is superseded for every
surface the prototype depicts.

## Open it

From the repo root — `bash serve.sh` (the repo's preview capability, INT-005):

```bash
bash serve.sh            # → http://localhost:3000  (the chat preview gateway proxies 3000)
bash serve.sh 4173       # any port you like
```

Or open `design/index.html` directly in a browser (no build step, no dependency).

## What to try (the owner's checklist)

1. **Rail** — hover it: the 48px slot opens a 176px overlay panel (labels, account,
   "All changes saved" stagger in); the pin (bottom) holds it open — tilts when pinned.
   Archive ships pinned = its own frame state.
2. **Theme** — the sun/moon in the header toggles dark home ↔ light home.
3. **Home** — greeting, currently reading (illustrated covers + progress fill-in),
   reading lists (fanned cover stacks), recent highlights, journal + return-to-a-thought.
4. **Library** — segmented filters, folders, the book shelf with cover stages, the
   article/paper/post/writing rows.
5. **Archive** — journal week strip (Fri 16 active), today's entry, notes, knowledge
   base growing-entities with grounded sources.
6. **Journal** — the composing surface: authored day page with a breathing caret,
   format toolbar, the `@design` reference picker with keyboard hints, the dark
   source-preview card (with the owner's `arivo://` anchor URI).
7. **Reader** — the reading surface with the captured passage, selection toolbar
   (Highlight / Bookmark / Deep note), the floating deep-note panel with the
   conceptual diagram (Visible cue → Action → Feedback), Read/Listen page pill.
8. **Hover everything** — cards bloom, covers lift, pills press (.98), tooltips rise.

## Structure

```
index.html            dark home (landing)          ← the owner's home-dark frame
home-light.html       light home                   ← the owner's home frame
library.html          library                      ← the owner's library frame
archive.html          archive (pinned rail)        ← the owner's archive frame
journal.html          journal day composing        ← the owner's journal frame
reader.html           reader + deep note           ← the owner's reader frame
images/               the owner's SVG set (verbatim)
motion.js             entrance stagger + rail hover/pin
styles/tokens.css     every literal + @font-face (Inter 400/500, Lora) + page canvases
styles/prototype.css  the owner's export VERBATIM — frozen artifact, never edited
styles/shell.css      scaffold glue only (shell grid, rail slot/panel, cover dims,
                      track sizes, pill backgrounds, one axis, pinned claim, breath)
styles/motion.css     the motion layer (rise, bloom, press, fill-in, tooltips)
assets/fonts/         Inter 400/500 + Lora 400 (self-hosted; zero CDN)
preview/              pass-6 evidence (p6-*.png)
```

Rebuild pipeline (idempotent): `scripts/scaffold_design.sh` (wipe + install + glue) →
`scripts/transform_pages.py` (links, titles, nav anchors, rail panel, labels, tooltips,
fills) → `scripts/shoot_p6.py` (evidence). Glue masters live in `scripts/design-glue/`.

The canonical spec is `../DESIGN-SYSTEM.md` (amended INT-013). If code and spec
disagree, that's a defect (Loop 2).

## Font note

The prototype speaks Inter (400/500) + Lora (reader prose) — the owner's own choice in
Figma, self-hosted here. The earlier Helvetica faces are retired from the surface
(retained in git history).
