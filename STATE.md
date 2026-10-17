# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 12 — "THE PFP LOCKS, THE UNAUTHORIZED SLOT DIES, THE ICONS GO THIN" (INT-021, session 18). The pass-11 motion system was ACCEPTED ("betterrr"); what was not: two UNORDERED composition moves — the account block's trip to the rail bottom (an INT-020 judgment call, now reversed by owner order) and the avatar's expansion drift (latent export defect: prototype `.identity-5 { width: 100% }` rides the nav wrapper, which grows with the items 40→144, so the panel's centering slid the avatar 44→96 mid-flight). LANDED: the identity is a FIXED 40px component slot at the wrapper's left edge — avatar on the icon axis (page x 44, rAF-proven at every frame of the 64→168 expansion), exactly above the nav items, with the handle **@prathamarchives** as its label (the shared nav-label overlay at x 76, motion-blur reveal, on the pfp line) — "just in front of it @prathamarchives and nothing"; "Personal space" + the bottom account slot deleted from all 6 pages and the CSS; all 18 rail icons stroke 1.5 → 1.1 (render ink −26%, PIL-measured); rail icon srcs ?v=12-busted (stale-SVG render class, INT-008 extended to changed assets); archive.html's rail labels converted (the INT-020 conversion had missed that page). Standing law from this turn: no composition/layout/text move without an owner order.
- **Prior state:** PASS 11 (INT-020) motion-system rebuild — superseded only in the identity/account surfaces; the five motion laws and all timing stand. prototype.css byte-verbatim frozen throughout.
- **Work (session 18):** turn-021 ingested; INT-021 ledgered; 6-page surgery (account slot deleted, handle label added, v12 + icon src busts, archive label defect); shell.css identity lock (fixed-width slot — the first margin-based attempt broke the icon axis to 38 and was caught + fixed within the pass); motion.css account-details selectors removed; 18 SVGs thinned; verify.sh re-ratcheted (5g(e) v12, NEW 5k a-e).
- **Dependencies (owner-gated):** the owner reviews PASS 12 live (gateway → 3000, `?v=12`, no-store — hover the rail: the pfp does NOT move; @prathamarchives smears in on the pfp's line; no bottom text; thin icons). Open carried calls (REVIEW pass 12): icon weight 1.1 (next step 0.9), handle voice (label treatment vs muted). PUSH BLOCKED (L-10 class, gh + PAT wiped again): pass 11 + 12 wait for a fresh inline PAT. Then the queued content-area composition port (segmented control + card rhythm — measured in `context/intake/INT-016-ref-spec.md`). Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast, reduced-motion emulation. PAT rotation still advised.
- **Evidence:**
  - verified by run — session 18: verify.sh green after re-ratchet; browser-DOM 6/6 pages avatarX = iconX = 44 (collapsed); index expanded — nav wrapper 144 @ x24, icon img 44, avatar 44, handle + labels at 76, handle cy 45 (pfp line); rAF trajectory: avX 44 EVERY frame while railW 64→168, handle opacity 0→1 with blur 5px→0; icon ink PIL-measured 84→62px (−26% = the 1.5→1.1 ratio); 6 pages console-clean at v12; VLM audits (dark + light ×2) clean — avatar in the icon column, handle beside it, no bottom text, zero defects. Evidence: `design/preview/p12-01..04-*.png` + REVIEW.md pass-12 entry.
  - not checked — real-hardware motion feel (the owner's hand); prefers-reduced-motion not emulated; contrast not instrument-measured; content-area components unported.

## Coordination (snapshot at last update)

Arivoo main @ `e96ee99` (Phase 2 harness LANDED, Phase 3 owner-gated). arivodesign main: pass 10 pushed (846291f); pass 11 (6721fc5) + pass 12 committed locally, PUSH BLOCKED (L-10 — fresh PAT needed); 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: `python3 scripts/daemon_nocache.py 3000` (true double-fork daemon → `scripts/serve_nocache.py`, `Cache-Control: no-store` — the plain http.server served stale CSS once; that class is closed, INT-008). Asset links carry `?=` cache-busters (current: **v12** — now on CSS/JS AND the changed rail icon srcs). Both scripts are TRACKED (INT-014) — a sandbox reset loses nothing; rerun the daemon one-liner and the preview is live again. NOTE (session-15/17/18 lesson): container resets wipe gh CLI + PAT credential store (outside /home/z/my-project) — push auth needs a fresh PAT each reset.

## Next action (exact)

Owner reviews PASS 12 live (gateway → 3000, `?v=12`) — hover the rail: the pfp stays LOCKED at the icon axis (it never slides with the opening), @prathamarchives fades in with motion blur exactly in front of it, "Personal space" and the bottom text are gone, the icons are thin. Corrections arrive as turns (Loop 1/2: intake → ledger → repair → ratchet). The live menu: (1) icon weight / handle voice (carried), (2) a fresh inline PAT to push the block (pass 11 + 12), then (3) the content composition port (segmented control, card rhythm — measured). The moment the sidebar locks: content composition iteration opens per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
