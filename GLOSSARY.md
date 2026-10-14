# GLOSSARY — arivodesign

Shared vocabulary. One fact, one home — terms are defined here once and referenced everywhere else. Append-only.

- **Kernel** — the constitution of this repo: LAWS.md + RULES.md + CONTRACT.md + PRINCIPLES.md + DECISIONS.md. Says what is inviolable and what the experience must be. [INT-003 "own rules and own lawsn and own constriants"]
- **Walls** — the kernel + harness seen from the outside: the thing that stands BEFORE any design/paint work exists. "Walls before paint" is L-04. [INT-002]
- **Harness** — the operating system of loops: GOVERNANCE.md (loops 0–6) + verify.sh + AGENTS.md entry contract. Says how compliance is produced and repaired. [INT-003 "iteration/verification and feedback loops"]
- **Garden / gardener** — the operating metaphor for this repo: grown loop by loop, pruned by verification, never pre-built into bureaucracy. Agents are gardeners; the owner is the climate. [INT-002 "a system for agents a garden"; Arivoo ENGINEERING]
- **Paint / paint phase** — stage 3: producing HTML/CSS vision artifacts through the cycle replicate → refine → iterate → change → test (P-12). Forbidden until stage 2 completes (L-04).
- **Layer** — one coherent slice of the experience reasoned through WITH the owner (stage 2): e.g. the reading surface, the capture system, the journal, the library. Each layer updates the repo before the next begins (D-007).
- **Golden path** — the end-to-end experience arc the design must keep walkable (CONTRACT.md Part 3); also the compressed session path in AGENTS.md (enter → work → verify → codify → exit).
- **Verify command** — `bash verify.sh`: the ONE mechanical gate (D-005). Grows only via the ratchet.
- **Ratchet / failure→asset** — the self-healing mechanism: every mechanically-checkable failure becomes a permanent verify.sh check, so the same failure cannot recur silently. [INT-003 "selfhealing"; Arivoo ENGINEERING failure-becomes-asset]
- **Loop 0..6** — session gate · intent intake · correction codification · work iteration · verification · drift audit · exit gate. Defined in GOVERNANCE.md.
- **CCL (Correction Codification Loop)** — Loop 2's seven steps: capture → ledger → codify → check → repair → ratchet → push. Same-session SLA (L-09). The answer to "agent did work, made mistake, i correct it".
- **Intent scan** — Loop 1's mandatory first action on every owner turn: verbatim capture → INT entry → cross-link. Answers "it writes its own intents when sees one in text" (L-06).
- **Provenance chain** — owner words → raw turn → INT entry → law/rule/invariant/decision → artifact. Every artifact must sit at the end of an unbroken chain (L-12).
- **Evidence labels** — exactly two: "verified by run" and "not checked" (L-16). Experience claims are never "verified" without a rendered artifact.
- **Drift** — slow divergence from owner intent or kernel without any single visible violation. Caught by Loop 5 (drift audit) and prevented by the anti-drift contract (AGENTS.md).
- **Fresh-context verify** — a subagent with no chat history auditing the repo alone at phase boundaries (Loop 4, D-006). Finds what proximity blinds us to.
- **Stage 0..5** — the allowed growth surface: seed ✅ → kernel+harness ✅ → layers → paint → harden → finalize (GOVERNANCE.md). Growth outside the map needs an INT first (L-18).
