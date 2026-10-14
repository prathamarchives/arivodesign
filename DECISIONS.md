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
