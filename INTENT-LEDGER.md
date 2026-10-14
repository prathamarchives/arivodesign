# INTENT-LEDGER — arivodesign

Owner words, verbatim, statused. The ONLY intent authority in this repo. Pattern inherited from the Arivoo system (the owner's backend build): owner intent enters ONLY through ledger entries; interpretations are always labeled; append-only — supersede by reference, never rewrite; raw corpus (`context/raw/`) is the verbatim archive, never edited.

**Namespace note:** INT IDs in this repo are a SEPARATE namespace from the Arivoo backend repo's INT-001..118. Cross-references to backend intents are cited explicitly as "Arivoo INT-*".

---

## Numbering

- **INT-001..** — owner turns to this repo, in order. Each turn's full text is preserved verbatim in `context/raw/turn-NNN.txt` BEFORE the ledger entry (the Arivoo closed-class rule: the session record/raw archive is the cross-check for every quote).

---

**INT-001 — ARIVODESIGN IS THE UI/UX/EXPERIENCE/FRONTEND WORKSTREAM OF ARIVO — active**

> "we'll be working on arivodesign which is will be UI/UX/expericne/frontend part of the arivoo which is backend that is in progress that you can see yourself. so as you could see how im appraching the building and engineered the system to work on it (honestly just a lil bit over engineered but we'll do it the right way this time and build the system specifically for design) you should take the core rules tho like repo as an long term memory..... you shall start with the repo as we go so you don't lose the owners intent aka my words. we'll be in plan mode after this where we will reason through design/UI/UX and experince of arivo and document and engineer the repo before executing."

Source: owner turn 1, chat 2026-10-14 (`context/raw/turn-001.txt`). Grounds: this repo's identity; the plan-mode directive (the canonical layer of this repo is engineered through reasoning BEFORE execution, in the owner's presence); the memory directive (repo as long-term memory; owner intent is never lost).

Interpretations (labeled, not owner words):
- The backend (Arivoo) is the authority on product contracts (source/import, anchor, highlight, bookmark, note, journal block, @-reference, retrieval — Arivoo D-023). arivodesign designs and builds the experience that consumes those contracts. No UI work belongs in Arivoo (Arivoo P-01/NORTH-STAR non-goal: "No UI/UX design (owner's separate work; the backend serves it)" — this repo IS that separate workstream).
- "the right way this time... build the system specifically for design" — the owner assesses Arivoo's full governance weight as over-built for a design workstream; arivodesign adopts the CORE rules (repo as long-term memory, verbatim owner intent, append-only supersession, small verified increments, continuous commit) adapted for design artifacts, not the whole backend apparatus, unless the owner says otherwise in plan mode.

---

**INT-002 — OLD ARIVO IS ARCHIVED SLOP; DESKTOP-FIRST LEANING; RAW FIRST; WALLS/HARNESS/KERNEL BEFORE UI; THE GARDEN DIRECTIVE — active**

> "*old arivo is archived for a reason all code and design is slop and the shittiest please don't go on that path..... i mean both... dekstop-first i guesss.... go through the raw of arivoo and you will understnad what i want.. so first do that and then we'll reason through layers and update the repo each time. and we;ll not hop on the designing and building the frontend ui and ux but first the walls and harness and kernel aligned to our goal and make this repo a system for agents a garden so i would apprecite if you red the engineering and its upstream files in raw in arivoo. and then after evetyghin we will replicate, refine, iterate every phase and then paint our vision and everything on html/css refine, iterate, change, test before finalizing and executing"

Source: owner turn 2, chat 2026-10-14 (`context/raw/turn-002.txt`). Grounds: this repo's execution order; the anti-reference rule (old Arivo is NOT design or code heritage — "i mean both"); the platform lean (desktop-first, tentative — "i guesss"); the vision source (Arivoo's raw corpus is the intent source for what Arivo should be); the system-first doctrine (walls, harness, kernel aligned to the goal BEFORE any frontend design/build — the Arivoo P-14/P-17 pattern applied to arivodesign); the garden metaphor (repo as a system for agents — ENGINEERING doctrine); the final-artifact discipline (HTML/CSS vision work comes AFTER the system: replicate, refine, iterate every phase, then paint, refine, iterate, change, test — before finalizing and executing).

Interpretations (labeled, not owner words):
- Execution order for this repo: (1) absorb Arivoo raw corpus + ENGINEERING + upstream doctrine; (2) reason through layers with the owner, updating the repo each time; (3) build walls, harness, kernel (agent-system infrastructure) aligned to the goal; (4) only then design/build frontend UI/UX — with HTML/CSS vision painting as a refine-iterate-test loop before anything is finalized.
- "desktop-first i guesss" is a leaning, not a locked decision — tentative in the owner's own words; plan mode arbitrates.
- The old `prathamarchives/Arivo` repo (Electron app, v0.5.0) is explicitly quarantined: neither its code nor its design may be referenced as a starting point.

---

**INT-003 — TIGHTEN RULES AND LAWS (ANTI-DRIFT); REPO GROWS AS WE GO; ITERATION/VERIFICATION/FEEDBACK LOOPS; SELF-EXTRACTION OF INTENTS; CORRECTIONS AUTOMATICALLY BECOME RULES/LAWS; SELF-HEALING — active**

> "yea also rules and laws. tighethen it. so agent doesnt drift and before the the repo should grow as we go. set iteration/verification and feedback loops. like it writes its own intents when sees one in text onw rules and own lawsn and own constriants/nottodo/whatodo/ and everything. like suppose agent did work, made mistake, i correct it. now it should be a law/rule or something automatically by agent. so feedbakc/iteration loop + selfhealing"

Source: owner turn 3, chat 2026-10-14 (`context/raw/turn-003.txt`). Grounds: this repo's governance layer is now EXPLICITLY in scope and precedes all UI work (it merges with INT-002's walls/harness/kernel directive — tightened rules/laws/constraints ARE the kernel; the feedback/iteration/verification loops + self-healing ARE the harness); the anti-drift requirement ("so agent doesnt drift"); the growth protocol ("the repo should grow as we go"); the self-extraction mandate ("it writes its own intents when sees one in text"); the correction-codification mandate ("i correct it. now it should be a law/rule or something automatically by agent"); the constraint taxonomy ("own constriants/nottodo/whatodo").

Interpretations (labeled, not owner words):
- Anti-drift is first-class: read-order discipline, verify-before-push, and provenance chains (every artifact cites the owner intent that grounds it) are the three drift controls.
- "writes its own intents when sees one in text" — proactive intent extraction WITHOUT being asked, before anything else is done with an owner turn (promoted to law L-10; operated by Loop 1).
- "made mistake, i correct it. now it should be a law/rule or something automatically" — the Correction Codification Loop: same-session capture → ledger → promotion to the right tier (law/rule/contract invariant) → repair → regression check → push. An uncoded correction is a lost correction (promoted to law L-09; operated by Loop 2).
- Failure→asset: a mistake that is mechanically checkable additionally becomes a permanent check in `verify.sh`, so the same failure cannot recur silently (the Arivoo ENGINEERING failure-becomes-asset ratchet, adopted).
- "the repo should grow as we go" — the repo is the only long-term memory; every loop deposits into it; chat-only knowledge is void (L-02/L-11).
- Sizing note: "the right way this time" (INT-001) still holds — the governance layer stays lean; growth stages mean no speculative files, only failure- or owner-driven additions (L-15).
