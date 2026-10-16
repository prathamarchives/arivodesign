# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 2 PAINTED — ITERATION LOOP RUNNING (INT-006). The owner-directed drift audit (Loop 5) found one critical interaction bug, two spec-claims that were never implemented, one tokens-discipline leak, and a missing preview capability — all fixed same-session; the corrupted-selector failure class is ratcheted into verify.sh permanently. The paint now MATCHES its spec and the spec's claims are TRUE.
- **Work (session 6):** INT-006 ingested (verdict: pass 1 "it sucks") + pending push unblocked with fresh PAT (env-only); 11 defects named with evidence in the NEW `design/REVIEW.md` (the iteration log — critique→fix→verify per pass); pass 2 implemented: canvas glow stations (glass refracts now), cover family v2 (six tones + monograms + sheen, no in-cover titles — duplication killed), progress v2 (3px luminous), collapsed-indicator fix, row continuation fades, list-card hover fan-out, rhythm 48px, overlay backdrop softened, hover completed everywhere; DESIGN-SYSTEM.md updated in lockstep (Canvas law + 3 new Don't/Do); pass-2 previews archived. Session 5 (audit) behind: overlay [hidden] fix, hover delays, tokens discipline, serve.sh.
- **Dependencies (owner-gated):** the owner reviews PASS 2 live (preview gateway → port 3000) or via design/preview/*-pass2.png; corrections arrive → Loop 1/2 and land as REVIEW pass 3. More references promised (INT-004). Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast check.
- **Evidence:**
  - verified by run — pass 2 rendered in a fresh browser session (cache-stale lesson logged): zero console errors; covers/artwork/progress/duplication/continuation cues confirmed by screenshot; hover by computed style (lift −3px, border-strong) + fan-out screenshot; overlay cycle re-confirmed; both themes rendered. Previews: design/preview/*-pass2.png. verify.sh green.
  - not checked — true motion-blur fidelity (CSS approximation), hover-feel latency on real hardware (needs the owner's hand), cover-ink contrast not instrument-measured.
- **Coordination (snapshot at last update):** Arivoo main @ `e34dcb3` (PRs #18–#23, D-034 execution). arivodesign main: intake → spec → paint → audit commits; 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: double-fork via `python3 scripts/daemon-serve.py` (plain background jobs die with the tool call's process group — session-5 lesson, logged).

## Next action (exact)

Owner reviews pass 2 and reacts. Every reaction = Loop 1/Loop 2 intake; visual corrections refine `design/`; new references extend the ref library. The moment the owner says the visuals are locked: stage 3 closes for this scope and the next layer (reading surface + capture, or whatever the owner picks) is reasoned through per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
