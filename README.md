# arivodesign

The UI/UX/experience/frontend workstream of **Arivo** — the owner's reading/study/reflection environment ("imagine I open my laptop... I'm reading a book... It's organized... It's just like a book" — Arivoo NORTH-STAR, owner words).

- Backend: [Arivoo](https://github.com/prathamarchives/Arivoo) — the base, foundation, and mechanism (API contracts, no UI by design).
- This repo: the experience that serves it — reader, capture, notes, journal, library, the personal-wikipedia surface, and the agent-facing experience layer.

**Current work (INT-028):** the Phase 1 execution contract is in [`PHASE-1-EXECUTION.md`](PHASE-1-EXECUTION.md). It defines route and theme continuity, transitions, idle navigation, and the required usability audit. Read [`AGENTS.md`](AGENTS.md), [`STATE.md`](STATE.md), then the phase contract before changing the prototype.

**Verification status:** the contract and source-coverage check have been committed on `fix/interaction-continuity-int028`. The UI implementation has not started in this branch. `bash verify.sh` and browser-rendered tests are **not checked** in this environment. Do not treat this branch as a verified UI repair.

Run `bash verify.sh` from the repository root after checkout. Do not merge without owner review of the rendered result.
