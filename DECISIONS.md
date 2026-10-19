# DECISIONS — arivodesign

Append-only decision record. One entry per decision, newest at the bottom. Each entry: the decision, its grounds (INT / law / Arivoo source), its status (`active` / `superseded by D-xxx`), and date. Decisions never get rewritten — a changed mind is a new entry that supersedes the old.

---

**D-001 — Desktop-first is the working platform decision — active** · 2026-10-14
The client experience is designed desktop-first; smaller screens adapt downstream. Held as a WORKING decision: the owner's words are a leaning ("dekstop-first i guesss", INT-002), and the owner may revisit at any layer boundary without ceremony.
*Grounds: INT-002; L-05; P-05.*

**D-002 — The old Arivo repo is quarantined as a source — active** · 2026-10-14
No code, design, pattern, or interaction idea is inherited from `prathamarchives/Arivo`. It is not consulted at all — not even as a negative reference during design, to avoid anchoring.
*Grounds: INT-002; L-14; R-X02.*

**D-003 — Build order: kernel → harness → layers → paint — active** · 2026-10-14
The execution order of this repo is fixed: (1) kernel files (LAWS, RULES, CONTRACT, PRINCIPLES, DECISIONS); (2) harness (GOVERNANCE loops, verify.sh, AGENTS entry contract); (3) layer-by-layer experience reasoning WITH the owner, repo updated per layer; (4) HTML/CSS vision painting through replicate → refine → iterate → change → test. No stage is skipped, no stage starts before the prior one stands.
*Grounds: INT-002, INT-003; L-04.*

**D-004 — The Correction Codification Loop is the self-healing mechanism — active** · 2026-10-14
Owner corrections of agent work are codified in the same session through Loop 2 (capture → ledger → promote to law/rule/contract-invariant → repair → regression check → push). The failure→asset ratchet additionally converts mechanically-checkable failures into permanent verify.sh checks.
*Grounds: INT-003; L-09; R-D03, R-D08.*

**D-005 — verify.sh is the ONE verify command — active** · 2026-10-14
A single mechanical gate (`bash verify.sh`) guards the repo before every push; it grows only via the ratchet (real failures, never speculation). Fresh-context review supplements it for experiential claims, which machines cannot judge.
*Grounds: INT-003; L-13, L-16; ENGINEERING "protect the verifier", one-verify-command doctrine.*

**D-006 — Fresh-context verification for experience work — active** · 2026-10-14
At every phase boundary (each layer reasoned, each painted artifact iterated), a fresh-context agent reads ONLY the repo and audits: contract adherence, provenance, ambiguity in rules, missing intent. Its findings enter Loop 2 as candidate corrections. Machine checks alone cannot judge experience; fresh eyes without chat contamination can.
*Grounds: INT-003 (verification loop); L-16; Arivoo falsification-loop pattern (VER), adapted and right-sized.*

**D-007 — Layer reasoning is owner-gated, one layer at a time — active** · 2026-10-14
The experience is reasoned through in layers with the owner present (plan mode); the repo is updated after EACH layer; the next layer starts only after the prior one is ledgered and committed. The agent proposes; the owner disposes.
*Grounds: INT-002 ("we'll reason through layers and update the repo each time"); R-D09.*

**D-008 — The visual language is locked: grayscale glass, Helvetica, no sharp corners, blur-marked motion — active** · 2026-10-14
Palette is grayscale-only in both themes (dark designed first); typeface is Helvetica (Light/Regular/Italic/Bold + Rounded Bold for the wordmark only); radii on every surface; glass on elevated surfaces at three blur levels; one easing family with blur treatment marking all structural movement. The canonical spec is DESIGN-SYSTEM.md — implementation must match it; mismatches are defects (Loop 2).
*Grounds: INT-004 (owner's own words + the 8 references in context/refs/); DESIGN-SYSTEM.md.*

**D-009 — Paint stage opened for scope: shell + home + library + archive — active** · 2026-10-14
The owner set the vision for the app shell, home, library, and archive directly and authorized pre-execution HTML/CSS. Stage 3 (paint) is OPEN for exactly this scope; the remaining layers (in-reader capture flows, concepts deep-dive, compounding digest, reading surface itself) stay closed until reasoned with the owner. More references are expected ("ill add more refrences... ahead") — artifacts iterate under the paint cycle, nothing is final.
*Grounds: INT-004 ("start html/css or whatever it takes to prepare this pre-execution visuals"); D-003; P-12.*

**D-010 — Prototype medium: static HTML/CSS + minimal vanilla JS, no framework — active** · 2026-10-14
Pre-execution visuals are plain HTML/CSS with minimal vanilla JS for interaction fidelity (sidebar states, overlay, page switching, theme). No framework, no build step — the prototype exists to lock visuals, and the production framework decision is made later WITH the owner.
*Grounds: INT-004 ("we're just designing the HTML/CSS... use whatever tech you gotta use idc what framwork"); artifacts live in design/.*


---

**D-011 — Navigation and theme share one in-place runtime — active** · 2026-10-19

Within the six-page static prototype, section links use one client-side navigation runtime. The runtime fetches and validates the destination, updates the page root and document history in place, updates `data-page` and the selected nav item, and supports Back/Forward. The chosen `dark` or `light` theme persists under `localStorage["arivo.theme"]` and applies across every section. Direct URL loads remain valid. If an in-place request fails, keep the current page and show no false success state; use a clear failure behavior that does not blank the document.

*Grounds: INT-028; L-19; D-010.*

**D-012 — Phase 1 motion envelope is fixed — active** · 2026-10-19

Route motion: 300ms, `cubic-bezier(0.32, 0.72, 0, 1)`; old page +18px right, opacity 1→0, blur 0→4px; new page −18px left, opacity 0→1, blur 4→0px. Theme motion changes colors only. Idle chrome delay: 1800ms; hide motion: opacity + translateY(−8px), 220ms. Reduced motion: opacity-only, no longer than 120ms, with no blur. No bounce, scaling, rotation, cascade, or viewport-wide blur.

*Grounds: INT-028; L-20; L-21; X-11.*

**D-013 — Phase 1 may not redesign the Figma surface — active** · 2026-10-19

The first stabilization pass changes route state, theme state, navigation visibility, transition behavior, and test coverage only. Page content, exported artwork, type choices, component geometry, page structure, and the current grayscale design remain unchanged. `design/styles/prototype.css` remains frozen. The Helvetica vs Inter/Lora specification conflict is not resolved by this decision.

*Grounds: INT-013; D-008; D-010; INT-028.*


**D-014 — The rail pin toggle is the only Phase 1 control addition — active** · 2026-10-19

Add the owner's requested small manual pin toggle at the **top-left corner of the sidebar**. The control is absent from the current six page exports, but the owner's original shell vision requires it. A pinned rail stays expanded and visible; it is excluded from idle hide. Unpinning returns to the specified hover, focus, and idle behavior. Use a 24×24px hit area, a 12px grayscale line icon with a 1.5px stroke, and no text label. Keep its position fixed as the rail changes width. No settings row, status text, or other new control is authorized. D-013's no-redesign rule remains active except for this one owner-grounded control.

*Grounds: INT-004 (manual top-left sidebar control); INT-024 (Settings row removed); INT-028; L-21.*


**D-015 — Active-section indicator follows semantic destination — active** · 2026-10-19

Map top-level selection as follows: `index.html` and `home-light.html` select Home; `library.html` selects Library; `archive.html` and `journal.html` select Archive; `reader.html` has no top-level selection because Reader is a context, not a primary destination. Keep the top-level destinations limited to Home, Library, and Archive. Do not add a Journal or Reader nav item.

*Grounds: INT-004 (Home / Library / Archive); D-009 (Archive contains journal and notes); INT-028 (consistent section interaction).*
