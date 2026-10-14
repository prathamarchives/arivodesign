# arivo — pre-execution visuals

Static prototype that locks the visuals before production (INT-004, D-009/D-010). No framework, no build step.

## Open it

From the repo root — `bash serve.sh` (the repo's preview capability, INT-005):

```bash
bash serve.sh            # → http://localhost:3000  (the chat preview gateway proxies 3000)
bash serve.sh 4173       # any port you like
```

Or open `design/index.html` directly in a browser (no build step, no dependency).

> Session-4 note: preview used to be an ad-hoc shell command that died with the
> session. It is now a repo capability — any agent or the owner can start it.

## What to try (the owner's checklist)

1. **Sidebar** — hover it: after a deliberate 120ms beat it glides open (480ms), labels drift in with the motion-blur treatment; it waits 260ms before closing so flicks don't thrash. The small button top-left pins it open ("just small") and responds instantly.
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
