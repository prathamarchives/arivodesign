# AGENTS.md — arivodesign (v1.0 — kernel + harness standing)

You are an agent in this repository — a gardener in the owner's garden. **The kernel and harness are standing. The existing Stage 3 prototype scope is authorized by D-009. For INT-028, change only what `PHASE-1-EXECUTION.md` authorizes. Other experience layers remain owner-gated.**

## What this is
- **arivodesign** — the UI/UX/experience/frontend workstream of **Arivo**, the owner's reading/study/reflection environment. Owner: prathamarchives.
- The backend lives in **Arivoo** (`prathamarchives/Arivoo`) — governance-complete, no product code yet. It is the authority on product contracts. This repo designs and builds the experience that consumes them.
- The old `prathamarchives/Arivo` repo is **quarantined** (L-14/D-002): never open it, mine it, or reference it — its existence is a warning, not a reference.
- This repo is a **system for agents**: everything an agent needs lives on disk — contract, laws, loops, verify command. No chat-only knowledge (L-02, L-10).

## Read order (cold start — L-11, no skimming)
1. `/AGENTS.md` — this file.
2. `/LAWS.md` — hard constraints, ladder C0–C6. Violating a law invalidates the work.
3. `/RULES.md` — what-to-do / not-to-do. A skipped DO is a defect; a crossed DON'T invalidates.
4. `/CONTRACT.md` — the experience contract: 10 objects, 10 invariants, the golden path. Every painted artifact answers to it.
5. `/PRINCIPLES.md` — judgment for the gray zones.
6. `/DECISIONS.md` — D-001.. append-only choices (platform, build order, loops).
7. `/INTENT-LEDGER.md` — owner words verbatim, the ONLY intent authority.
8. `/STATE.md` — where things stand, the exact next action (navigation, not authority).
9. `/PHASE-1-EXECUTION.md` — read when the current task is INT-028 interaction stability. It fixes implementation scope, constants, and acceptance tests.
10. `/GOVERNANCE.md` — the loops you operate: intake, correction, iteration, verification, drift audit, exit.
11. `context/WORKLOG.md` (tail) — what just happened.
12. Latest `context/raw/turn-*.txt` — the owner's most recent words, verbatim.
13. Run `bash verify.sh` — must be green before you claim or change anything.

## The golden path (one session, compressed)
Enter (Loop 0) → owner turn? ingest first (Loop 1) → work in small passes (Loop 3) → verify (Loop 4: `bash verify.sh` + fresh-context at phase boundaries) → corrections codified same-session (Loop 2, seven steps) → exit gate: STATE + WORKLOG + push (Loop 6).

## Binding rules (the six that end careers)
1. Never edit `context/raw/` or rewrite governance history — supersede by reference. [L-07, L-08]
2. Owner intent enters ONLY verbatim + ledger, before dependent work. [L-02, L-06]
3. `bash verify.sh` green before every push; evidence labels on every claim. [L-13, L-16]
4. Owner corrections become law/rule/invariant in the same session, then the artifact gets repaired. [L-09]
5. Commit and push as work lands; unpushed work never happened. [L-10]
6. No secrets in tracked files, ever. [L-15]

## Anti-drift contract
Drift is prevented mechanically, not by vigilance: the read order above, the provenance rule (every artifact cites its INT), the verify gate before push, and the ratchet (every failure class becomes a verify.sh check). If you notice drift — yours or an inherited one — Loop 2 it. Do not quietly fix and move on.

## Language & style
English. Stable IDs (INT-###, L-##, R-D##/R-X##, X-##, P-##, D-###). One fact, one home. Prose last (P-09).
