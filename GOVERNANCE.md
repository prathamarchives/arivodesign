# GOVERNANCE — the harness (loops, verification, self-healing)

How work happens in this repo so agents don't drift and the system heals itself. The garden metaphor is operational here: the owner sets climate (intent, corrections); agents garden (work, prune, repair); loops are the gardening rounds; verify.sh is the soil test.

Everything in this file is binding procedure. Laws say WHAT is inviolable (LAWS.md); this file says HOW compliance is produced, verified, and repaired.

---

## The loops

Seven loops cover the entire life of any work in this repo. Each loop states its trigger, steps, and output. Loops are cheap by design — if a loop feels heavy, the failure is in sizing (L-18), so the loop gets simplified, never skipped.

### Loop 0 — Session gate (entry)
**Trigger:** an agent session begins (new session, new day, resumed chat).
1. Read AGENTS.md and follow the full read order (no skimming, no memory shortcuts — L-11).
2. Run `bash verify.sh`. Green → proceed. Red → fix before any new work (R-X10).
3. Read STATE.md "next action" and the WORKLOG tail; confirm the current stage and the owner's standing gates.
**Output:** an agent that knows the contract, the open questions, and the last thing that happened.

### Loop 1 — Intent intake (self-extraction)
**Trigger:** EVERY owner message, before anything else (L-06, R-D02).
1. Capture the turn verbatim → `context/raw/turn-NNN.txt` (typos preserved; redact credentials only, note the redaction).
2. Append the INT entry to INTENT-LEDGER.md: verbatim quote, grounds, labeled interpretations.
3. Cross-link: does this turn change behavior of existing rules/laws/contract? If yes, propose the promotion or supersession (append-only, cite the INT).
4. Commit + push the intake before substantive work begins.
**Output:** owner words on disk, indexed, before they can be lost. If a turn contains NO new intent, say so explicitly in the WORKLOG entry of that session (the scan happened; nothing found).

### Loop 2 — Correction codification (self-healing) — THE loop
**Trigger:** the owner corrects agent work — a mistake, a misread, a wrong direction, a broken artifact. Also triggered by fresh-context verification findings (Loop 4) and drift audits (Loop 5) when they reveal real defects.
**The seven steps, same session (L-09):**
1. **CAPTURE** — the correction, verbatim where possible, into raw (if it arrived as an owner turn, Loop 1 already did this) and into the WORKLOG entry.
2. **LEDGER** — INT entry (or explicit reference to the existing INT the correction amends).
3. **CODIFY** — promote the lesson to the right tier, citing the INT and the raw:
   - **LAW** — it protects something inviolable; violating it invalidates work.
   - **RULE** — it changes what an agent does/avoids operationally.
   - **CONTRACT invariant** — it changes what the experience must be.
   - **DECISION** — it changes a choice between options.
   - **PRINCIPLE** — it changes judgment in gray zones.
4. **CHECK** — grep the kernel for contradictions with the new entry; repair upstream docs (append-only — supersede by reference).
5. **REPAIR** — fix the artifact that triggered the correction.
6. **RATCHET** — if the failure is mechanically checkable, add its check to verify.sh so this exact failure can never pass again silently (failure → asset).
7. **PUSH** — commit (correction + codification + repair + ratchet together) and push.
**Output:** the mistake becomes structure. The next agent — any agent — inherits the lesson as law/rule/check, not as chat folklore.

### Loop 3 — Work iteration (small passes)
**Trigger:** any substantive work (layer reasoning, contract drafting, design painting).
1. State the pass's goal in one sentence and which INT/layer it serves.
2. Reason → update the repo → produce the artifact → self-review against the CONTRACT invariants and RULES.
3. Adjust within the pass; commit when the pass is coherent (L-10: small verified increments).
4. Design passes additionally follow the paint cycle: **replicate → refine → iterate → change → test** (P-12) — taste is verified against the contract, never asserted.
**Output:** a trail of coherent commits, each leaving the repo richer ("the repo should grow as we go", INT-003).

### Loop 4 — Verification (two levels)
**Trigger:** before every push (mechanical); at every phase boundary (fresh-context).
- **Mechanical (every session):** `bash verify.sh` — the ONE verify command (D-005). It guards raw/ledger integrity, secret hygiene, quarantine leaks, kernel presence, worklog/STATE freshness. Red verify = fix first (R-X10).
- **Fresh-context (phase boundaries — after each layer, after each major artifact):** a subagent with NO chat history reads ONLY the repo and answers:
  1. Is every claim supported by the repo (evidence labels honest)?
  2. Is any rule ambiguous or self-contradictory?
  3. Is any owner intent missing from the ledger or any artifact unanchored (L-12)?
  4. Do the CONTRACT invariants conflict with each other or with the laws?
  Findings enter Loop 2 as candidate corrections. Findings that are false alarms are recorded as such (with the reason) so the check sharpens over time.
**Output:** "verified by run" / "not checked" labels that mean something (L-16).

### Loop 5 — Drift audit (periodic)
**Trigger:** every ~3 sessions of work, or whenever the agent itself suspects drift.
1. Re-read LAWS + RULES fully (not from memory — from disk).
2. Re-read the WORKLOG tail (last ~3 entries) looking for slow violations: paraphrased intent, unprovenanced artifacts, governance grown without failure, design direction unmoored from the contract.
3. Findings → Loop 2. Clean audit → note it in the WORKLOG (audits that find nothing are evidence too).
**Output:** drift caught while small.

### Loop 6 — Exit gate
**Trigger:** session end (L-11, R-D07).
1. STATE.md updated (position, work, next action, evidence, coordination).
2. WORKLOG entry appended (task, work log, stage summary, unresolved questions).
3. `bash verify.sh` green → commit → push.
**Output:** the next agent — with zero chat context — can pick up exactly here.

---

## The self-healing ratchet (how mistakes become structure)

```
owner correction / verification finding
        │
        ▼
  Loop 2 (seven steps, same session)
        │
        ├──▶ raw + ledger (the memory)
        ├──▶ law / rule / invariant / decision / principle (the structure)
        ├──▶ repaired artifact (the product)
        └──▶ verify.sh check (the permanent guard)   ← failure → asset
```

After every correction, the repo is strictly harder to break the same way twice. That is the whole self-healing design: **corrections compound into structure; structure removes the need to remember.**

## Growth stages (how this repo is allowed to grow)

Right-sized from the ENGINEERING doctrine — start small, grow on observed failure (L-18, P-10):

- **Stage 0 — Seed** ✅ (sessions 1–2): intent captured, Arivoo absorbed, doctrine anchors logged.
- **Stage 1 — Kernel + harness** ✅ (this session): LAWS/RULES/CONTRACT/PRINCIPLES/DECISIONS + GOVERNANCE/verify.sh/AGENTS v1.0. **Walls are standing.**
- **Stage 2 — Layers**: the experience reasoned through WITH the owner, one layer at a time, repo updated per layer (D-007). Entry condition: kernel + harness green. Exit: every layer ledgered.
- **Stage 3 — Paint**: HTML/CSS vision painting of the reasoned layers, through replicate → refine → iterate → change → test (P-12). Entry: stage 2 exit + owner go.
- **Stage 4 — Harden**: fresh-context verification per artifact, contract-invariant checklists passing, drift audit. Exit: every artifact verified against the contract.
- **Stage 5 — Finalize**: the owner blesses the vision; execution follows (whatever "executing" means for the artifact — decided with the owner at that boundary, not assumed).

New stages/files/loops are added ONLY when a real failure or owner directive demands them (R-X07). This map is the allowed growth surface; anything outside it needs an INT first.

## What we deliberately do NOT do (anti-over-engineering)

- No review queues, no approval workflows inside the repo — the owner's gates are the loop triggers themselves (autonomy with gates; Arivoo P-06 pattern).
- No speculative governance files "for later" (L-18).
- No verification theater: every check must be runnable or it is prose (P-09).
- No governance weight that postpones the product: loops serve the paint, never the reverse (the owner builds a book, not a bureaucracy).
