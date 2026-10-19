# RULES — arivodesign (what-to-do / not-to-do)

The operational layer between laws and work. Laws say WHAT is inviolable (LAWS.md); rules say what an agent actually DOES and DOES NOT DO, session by session, artifact by artifact. Every rule cites its law. Rules are append-only like laws (supersede by reference).

Enforcement note: a DO-rule skipped is a defect even if the output looks fine; a DON'T-rule crossed makes the work invalid regardless of quality.

---

## DO — what to do, always

- **R-D01 · Enter through the gate.** Start every session at AGENTS.md, follow the read order completely, then run `bash verify.sh` before your first claim about repo state. [L-11, L-13]
- **R-D02 · Scan every owner turn for intent FIRST.** Before acting on any owner message: capture verbatim → ledger (INT) → cross-link into rules/contract if it changes behavior. Nothing else happens before this. [L-06, L-02]
- **R-D03 · Codify corrections fully.** Run the Correction Codification Loop (GOVERNANCE.md Loop 2) — all seven steps, same session. [L-09]
- **R-D04 · Work in small passes.** One pass = reason → repo update → artifact → self-review → adjust → commit. Never batch unverified work into one giant change. [L-10, L-13]
- **R-D05 · Cite provenance in every artifact.** Header of every file and every design artifact states which INT ids (and Arivoo sources, where inherited) it serves. [L-12]
- **R-D06 · Label evidence.** Every completion claim gets "verified by run" or "not checked". Never leave a claim unlabeled. [L-16]
- **R-D07 · Push before leaving.** Session ends only after: STATE updated, WORKLOG entry appended, `verify.sh` green, committed, pushed. [L-10, L-11, L-13]
- **R-D08 · Ratchet failures.** When any mechanically-checkable failure occurs (yours, a prior agent's, or a prior session's), add its check to verify.sh in the same session. [L-09]
- **R-D09 · Keep the layers in order.** Reason one layer at a time WITH the owner, update the repo after each layer, and only then move to the next. [L-04; INT-002]

## DON'T — never do these

- **R-X01 · Don't paint before the walls stand.** No HTML/CSS/component/layout/color work while L-04 is unsatisfied. [L-04]
- **R-X02 · Don't touch the old Arivo repo.** Don't open it, mine it, reference it, or let its patterns leak in by memory. Its existence is a warning, not a reference. [L-14]
- **R-X03 · Don't paraphrase in place of capture.** No intent enters any file except via verbatim raw + ledger entry. [L-02]
- **R-X04 · Don't edit the past.** Never edit or delete `context/raw/`, never rewrite ledger/law/rule entries to change meaning — supersede by reference. [L-07, L-08]
- **R-X05 · Don't write secrets.** No tokens, credentials, or personal paths in tracked files, ever — including inside raw captures (redact there). [L-15]
- **R-X06 · Don't claim without running.** No "done", no "works", no "verified" without the run that proves it. [L-16]
- **R-X07 · Don't grow governance speculatively.** No new files, rules, or checks without a triggering failure, correction, or owner directive. [L-18]
- **R-X08 · Don't leave knowledge in chat.** If it shaped the work and is not in the repo, capture it before proceeding — otherwise it does not exist. [L-02, L-10]
- **R-X09 · Don't violate the reading experience.** No admin chrome, no governance views, no settings inside the reading flow. [L-01]
- **R-X10 · Don't work past a red verify.** `verify.sh` failing = fix first, then continue. No pushing, no new work on top. [L-13]
- **R-X11 · Don't decide owner-gated questions alone.** Platform lock (desktop-first is a working decision), layer content, reader technology, and any experience-direction fork are reasoned WITH the owner, then ledgered. [L-05; INT-002]


---

## DO — Phase 1 continuity requirements

- **R-D10 · Preserve route state.** Implement the exact route, theme, URL/history, and storage behavior in `PHASE-1-EXECUTION.md`. Direct URLs remain valid. [L-19, D-011, INT-028]
- **R-D11 · Keep the transition bounded.** Use the one duration and easing specified in `PHASE-1-EXECUTION.md`. Fetch the target before starting. Do not show a blank frame. [L-20, X-11, INT-028]
- **R-D12 · Test the whole route/theme matrix.** Test all six pages in both themes at the specified viewport sizes. Record browser, viewport, exact steps, screenshots, console result, and outcome. [L-13, L-16, L-21, INT-028]
- **R-D13 · Re-init without duplication.** After a route change, reset selected navigation state and run motion setup once. Repeated route changes must not add listeners or timers. [L-19, D-011]

- **R-D14 · Keep evidence runnable and reachable.** Commit each new verifier/test script and rendered review artifact before using it as evidence. Record the exact command and file path. If no artifact can be run or viewed, mark the result not checked. [L-13, L-16, L-22; INT-028]
- **R-D15 · Honor the rail pin state.** Add the small owner-requested top-left pin toggle. When pinned, keep the rail expanded and exclude it from idle hiding. When unpinned, restore the defined hover/focus/idle behavior. [L-23, D-014, INT-004, INT-028]

## DON'T — Phase 1 prohibitions

- **R-X12 · Do not freeze an untested visual claim.** Do not state that a transition, route, theme, or layout is fixed unless the rendered behavior was tested and evidence is recorded. [L-13, L-16, INT-028]
- **R-X13 · Do not widen the change.** Do not change page content, component sizes, type, icon art, cover art, backend behavior, or the frozen `design/styles/prototype.css`. Do not add dependencies or use broad color filters. [L-18, D-008, D-010, INT-028]
- **R-X14 · Do not create fake outcomes.** Do not add success messages or imply that an unimplemented product action succeeded. Record undefined controls as unresolved instead. [L-16, X-03, INT-028]

- **R-X15 · Do not cite missing tooling.** Never document a runner or screenshot as the basis for a pass unless the referenced file exists at the stated path and can be opened or executed. Repair stale runbook references when discovered. [L-22; INT-028]
