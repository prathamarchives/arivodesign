# arivo — pre-execution visuals

Static prototype that locks the visuals before production (INT-004, D-009/D-010). No framework, no build step.

## Open it

Open `index.html` directly in a browser, or serve it (nicer):

```bash
cd design && python3 -m http.server 4173
# → http://localhost:4173
```

## What to try (the owner's checklist)

1. **Sidebar** — hover it: it glides open (480ms), labels drift in with the motion-blur treatment. Move away: it settles back. The small button top-left pins it open ("just small").
2. **Account** — click the avatar row at the bottom: the overlay grows from bottom-left with the SAME motion family. Escape or the backdrop closes it. The Appearance toggle switches dark/light (grayscale both ways).
3. **Home** — currently reading (progress), lists, recent-highlights feed (Are.na anatomy, desktop translation).
4. **Library** — folders with covers peeking (mybooks ref), filter pills, all-works grid.
5. **Archive** — journal day cards, raw notes (one with a diagram block), knowledge-base concept cards with growth bars.
6. **Hover everything** — detailing on hover is a first-class state (X-15).

## Structure

```
index.html            the prototype (shell + home + library + archive + overlay)
styles/tokens.css     every visual value, purpose-named (dark + light themes)
styles/base.css       reset, type, canvas (glows + noise), scrollbars, focus
styles/components.css glass levels, buttons, pills, chips, cards, progress, toggle
styles/shell.css      sidebar + overlay + page transitions (the motion laws)
styles/pages.css      the three content surfaces
assets/fonts/         Helvetica (Light/Regular/Italic/Bold/Rounded Bold)
```

The canonical spec is `../DESIGN-SYSTEM.md`. If code and spec disagree, that's a defect (Loop 2).

## Font note

Helvetica faces were provided by the owner for this prototype. For production, Helvetica must be properly licensed (Monotype) or substituted with a licensed equivalent — noted here so it doesn't get lost.
