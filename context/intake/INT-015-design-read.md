# INT-015 design read — pass 6 seen by the capable model (session 12, 2026-10-17)

> Status: AGENT OBSERVATIONS, pending owner ruling — NOT corrections, NOT law.
> These are candidates for the next iteration pass. The INT-013 replacement order
> ("replicate one on one") still governs: nothing below changes until the owner
> rules. Constitution filters applied (X-12 grayscale etc.) — suggestions that
> violate the constitution were dropped, not listed.
> Method: VLM (glm-5v-turbo) critiques of the p6 previews (home-dark, reader,
> library+journal), then constitution-filtered and deduped by the session agent.
> Evidence: design/preview/p6-*.png (the standing pass-6 evidence set).

## A. Named defects (candidates — grouped, constitution-safe)

### Typography
- **A1 — Grey-soup metadata.** Currently-reading meta (author · page · %) is nearly
  indistinguishable from titles at a glance; hierarchy leans on size, not value
  contrast. (home, currently-reading card)
- **A2 — Date labels not background-voiced.** "16 OCT 2026" class dates carry body
  weight; they want tabular figures / lighter label treatment. (home right rail)
- **A3 — Chapter title shouts.** Reader chapter heading is disproportionately large
  vs body — it sits OVER the text instead of WITH it. (reader)
- **A4 — Quote cards undifferentiated.** Recent-highlights quotes are plain sans
  blocks; the product has Lora in the font stack — quotes are the natural home for
  the serif voice. (home, recent highlights)

### Spacing & rhythm
- **B1 — Macro/micro spacing flat.** Section gaps ≈ intra-card gaps; the page reads
  as one undifferentiated list. (home, library)
- **B2 — Primary CTA kisses the edge.** "Continue reading" bottom padding too
  tight on the hero card. (home)
- **B3 — Top-heavy library.** Segmented control → Folders header gap compressed
  vs generous footer space. (library)

### Alignment & optical rhythm
- **C1 — Ragged text-vs-cover alignment.** Reading-list card text top-aligns with
  cover height, leaving an awkward bottom void. (home, reading lists)
- **C2 — Folder chevrons sit low.** Vertically centered to the card, not optically
  to the title's cap height. (library)
- **C3 — Row icons float.** Article/paper/post icons sit slightly above the text
  baseline. (library rows)

### Contrast & affordance (grayscale-safe)
- **D1 — Elevation too shy.** Card surfaces barely step off the canvas (dark-on-dark);
  the pass-5 panel-step law exists but the prototype's cards don't carry it.
  (home, library)
- **D2 — Ghost buttons read disabled.** Outline buttons' hairlines too faint for
  affordance. (home)
- **D3 — Progress reads stopped.** Grey fill says "neutral/paused"; a brighter
  white fill + luminous edge would say "alive" without breaking grayscale.
  (home, currently-reading)
- **D4 — Highlight smudge risk.** Reader highlight (#F3F3F3-class) vs page
  (#FAFAFA-class) is ~indistinguishable on many panels; needs a darker grey band
  to read as intentional. (reader)
- **D5 — Search input vanishes.** Faint border only; needs a surface step.
  (header, all pages)

### Depth & planes
- **E1 — Right rail on the same plane.** The "Today's page" companion column
  blends with primary content — needs a surface step or hairline divider. (home)
- **E2 — Cards painted, not lifted.** Shadows exist on covers but content cards
  don't carry the lift. (home, library)

### Reader-specific (the heart — X-01 "chrome recedes")
- **F1 — Measure too wide.** ~75–80 cpl observed; sustained-reading optimum is
  ~65 cpl. The journal's 620px measure is right; the reader's 640 is wide.
  (reader prose)
- **F2 — Leading loose.** ~1.55–1.6; 1.4–1.45 binds lines into a text block.
  (reader prose) — NOTE: the export's own Lora is 180–185% lh; this is the
  owner's own setting, ruled by the artifact, listed for completeness.
- **F3 — Selection toolbar occludes.** Floats over the line BELOW the highlighted
  passage; heavy solid white reads as system modal, not in-context tool. (reader)
- **F4 — Deep-note covers the reading.** ~35% of the right reading area; split
  attention vs the "book is the interface" law. (reader)

## B. What reads as strong (protect in iteration)

- **IA is sound** — active reading → collections → history/highlights → journal
  follows the owner's mental model (the golden path, CONTRACT Part 3).
- **Macro whitespace is confident** at 1440×900 — no clutter.
- **Editorial voice** — the copy ("A little further, a little clearer") gives it a
  soul. This is the owner's own voice from the Figma v1.
- **Journal source-preview card** — dark surface, attribution hierarchy, link cue:
  correctly signals "reference, not your writing". The strongest single component.
- **Journal measure** (~620px) is the reading-comfort gold standard in the build.

## C. Tension to name honestly

The prototype is the OWNER'S OWN EXPORT (INT-013, frozen artifact, verbatim CSS).
Every defect in A/D/E/F is either (a) the owner's own hand in Figma, or (b) the
reconstruction layer's judgment (shell.css / motion). The read therefore splits:

1. **Judgment-layer defects** (reconstruction choices — directly fixable without
   touching the frozen export): F1 (measure 640→620-class), F3 (toolbar weight/
   position), F4 (panel size/position), D5 (search surface), C1 (list-card
   alignment), E1 (right-rail step).
2. **Artifact-native values** (the owner's own Figma values — changeable only by
   the owner's ruling): A1–A4, B1–B3, C2–C3, D1–D4, E2, F2.

The iteration protocol: the owner rules per item (or says "fix all judgment-layer
ones"); each fix enters the paint cycle (replicate → refine → iterate → change →
test) with a REVIEW.md entry and re-verification.
