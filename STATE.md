# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 11 — "THE MOTION SYSTEM, REBUILT FROM ZERO" (INT-020, session 17). The owner's pass-10 verdict was double-forensic: the labels could not render at all (`.nav-label max-height: 0` never reset — the "texts?" bug), and the width transition was dead after entrance (the ready-rule's own transition list shadowed it — the rail SNAPPED, then the blur keyframe + stagger popped over the snap: "no expand animation… it just bounces on screen… hurts my eyes"). LANDED: motion.css rewritten from zero under five laws (expand-never-bounce; motion-blur on TEXT only; zero-layout label overlays; one clock, no stagger; one transition stack per element), account block to the rail's bottom slot, "All changes saved" + pin + rail data-tips deleted from all 6 pages, entrance collapsed to 2-3 soft block rises, hover family converted to scale-growth (hops/press/spins/wiggle retired), v11 cache-bust. Labels now fade in WITH MOTION BLUR (blur 5px→0 + slide 12px, 200ms @90ms) exactly as ordered; the icon axis holds 44 through the whole animation.
- **Prior state:** PASS 10 (INT-019) slim + motion-blur attempt — superseded by the rebuild. prototype.css byte-verbatim frozen throughout.
- **Work (session 17):** turn-020 ingested; INT-020 ledgered; motion.css full rewrite; motion.js rewrite (block-rise entrance, 140ms grace); shell.css surgery (absolute label overlay + bottom account slot); 6-page HTML surgery (save-state/pin/data-tips removed, alts named, v11) — one mid-pass defect caught and ratcheted (orphan `</div>` cascade; verify 5j(f) div-balance now guards it); verify.sh re-ratcheted (5f(b), 5g(a/e), 5i text-only blur, NEW 5j a-f).
- **Dependencies (owner-gated):** the owner reviews PASS 11 live (gateway → 3000, `?v=11`, no-store — hover the rail: it OPENS, text smears in). Open carried calls (REVIEW pass 11): text-blur strength, expand timing, account-block keep-or-kill. PUSH BLOCKED (L-10 class): container reset wiped gh CLI + PAT again — pass 11 + any prior unpushed commits wait for a fresh inline PAT. Then the queued content-area composition port (segmented control + card rhythm — measured in `context/intake/INT-016-ref-spec.md`). Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast, reduced-motion emulation. PAT rotation still advised.
- **Evidence:**
  - verified by run — session 17: verify.sh green after re-ratchet; browser-DOM rAF trajectories at 1440×900: OPEN w 64→96→149→161→166→167→168 (~300ms, no snap) with label opacity 0→0.33→0.77→0.95→1 and blur 5→3.3→1.2→0.26→0px, icon axis 44 every frame; CLOSE labels ≤0.01 at w 71 (no clip); 6 pages console-clean at v11; page-tree structure verified; VLM audit 6/6 pass (icons-only collapsed, sharp labels expanded, clean bottom account, no save-state remnants, ink pill, zero defects). Evidence: `design/preview/p11-01..02-*.png` + REVIEW.md pass-11 entry.
  - not checked — real-hardware motion feel (the owner's hand); prefers-reduced-motion not emulated; contrast not instrument-measured; content-area components unported.

## Coordination (snapshot at last update)

Arivoo main @ `e96ee99` (Phase 2 harness LANDED, Phase 3 owner-gated). arivodesign main: pass 10 pushed (846291f); pass 11 committed locally, PUSH BLOCKED (L-10 — fresh PAT needed); 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: `python3 scripts/daemon_nocache.py 3000` (true double-fork daemon → `scripts/serve_nocache.py`, `Cache-Control: no-store` — the plain http.server served stale CSS once; that class is closed, INT-008). Asset links carry `?v=` cache-busters (current: **v11**). Both scripts are TRACKED (INT-014) — a sandbox reset loses nothing; rerun the daemon one-liner and the preview is live again. NOTE (session-15/17 lesson): container resets wipe gh CLI + PAT credential store (outside /home/z/my-project) — push auth needs a fresh PAT each reset.

## Next action (exact)

Owner reviews PASS 11 live (gateway → 3000, `?v=11`) — hover the rail: a real expand now (300ms soft S-curve), the text smears in and settles sharp, nothing bounces, "All changes saved" is gone. Corrections arrive as turns (Loop 1/2: intake → ledger → repair → ratchet). The live menu: (1) text-blur strength / expand timing / account-block keep-or-kill (carried), (2) a fresh inline PAT to push the block, then (3) the content composition port (segmented control, card rhythm — measured). The moment the sidebar locks: content composition iteration opens per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
