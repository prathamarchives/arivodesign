# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 17 — "THE SIDEBAR RESTORED — THE TURN-25 NAV-STRIKE WAS A MISREAD; THE PUSH DISCIPLINE WRITTEN INTO LAW" (INT-026, session 24). Owner turn 27: "where the fuck sidebar dissaperddd fix that." The pass-16 chip-only rail was a wrong reading of the turn-25 wavy strike; it shipped to origin without owner validation — the breach is on the record (ledger INT-026): AMBIGUOUS MARKS THAT DELETE WHOLE COMPONENTS get live-owner confirmation BEFORE destructive execution and BEFORE push. Reverted (the rail half of pass 16): destinations (Home/Library/Archive) restored on all 6 pages from fd13038; the panel full-height again (`top: var(--ref-rail-inset)`); nav-item rules + ink-pill glyph inversion restored verbatim; the chip wrapper-pin reverted to flex-fill; 18 nav SVGs restored. KEPT from turn 25 (explicit orders, untouched): handle "prathamarchives" NO @ everywhere; no ⌘K; homepage corposlop stays removed; the 30px/16px rhythm; 60.256% card basis; edge-aligned sections. motion.css/motion.js/tokens.css byte-identical to pass 16 — the motion system rides the one clock (hover 64→168, labels + handle smear in, avatar axis x44 rAF drift 0.000).
- **Prior state:** PASS 16 (INT-025) — its HOMEPAGE half stands (corposlop removal + equal gaps + recomposition); its RAIL half is reverted by this pass. PASS 15's rail contract is restored (nav at top, divider, account at the end, pfp 26, 8px handle gap, 17px below the line).
- **Work (session 24):** turn-026/027 archived; INT-026 ledgered; surgery `scripts/int026-rail-restore.py` (destinations re-insertion from fd13038 with assertions, v16→v17 global busts, shell.css rail hunks reverted while the homepage rhythm block survived, SVGs git-checkout'd); verification `scripts/int026-verify.py` + `int026-shots.py` (4 rounds, ALL before the push); verify.sh re-ratcheted (5e(a)/5e(d)/5g(e)/5i/5k(d)(e)/5m(a)(d) → 122 ok) → GREEN; committed + pushed (remote defect replaced by the restore).
- **Dependencies (owner-gated):** the owner reviews PASS 17 live (gateway → 3000, `?v=17`, no-store — the sidebar is BACK: Home/Library/Archive at top, hover expands 64→168 with labels smearing in, divider, pfp + "prathamarchives" (no @) at the end; the homepage is the clean single column at the 30px rhythm). Open carried calls: below-fold closing-line removal stands DISCLOSED (one-line revert); pfp artwork keep-or-swap; reader.html URL-reachable only (pre-existing); home-light/journal/reader carry no ink pill (PASS 15 contract — no matching nav href). Layers still closed until reasoned: in-reader capture flows, the reading surface, concepts deep-dive, compounding digest.
- **Evidence:**
  - verified by run — session 24 (four rounds, all pre-push): (1) server — 6/6 pages 200 at ?v=17, 3 nav items each, 0 @ hits, 0 stale busts, 18 SVGs 200; (2) DOM ×2 states ×6 pages — 0 errors: panel 12→888, destinations top, identity bottom, avatar axis x44 both states, rAF drift 0.000, handle Inter 12/400 8px gap fully visible, pills correct, rhythm 30px, console clean ×6; (3) VLM on 4 screenshots (dark hover/collapsed, light, library) — "proper full-height sidebar column", labels correct, no @, no corposlop, pill right; (4) verify.sh — 122 ok, 0 fail. Screenshots: `upload/t27-*.png`.
  - not checked — real-hardware motion feel; prefers-reduced-motion not emulated; contrast not instrument-measured; the pfp artwork remains a placeholder judgment call.

## Coordination (snapshot at last update)

Arivoo main @ `e96ee99` (Phase 2 harness LANDED, Phase 3 owner-gated). arivodesign main: pushed through the INT-026 restore (pass 17) — the pass 11–16 backlog cleared with the turn-26 PAT, then pass 16's rail misread replaced on origin by the verified restore; 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: `python3 scripts/daemon_nocache.py 3000` (true double-fork daemon → `scripts/serve_nocache.py`, `Cache-Control: no-store`). Asset links carry `?=` cache-busters (current: **v17** — CSS/JS AND the pfp img). Both scripts are TRACKED (INT-014) — a sandbox reset loses nothing; rerun the daemon one-liner and the preview is live again. NOTE (session-15/17/18/19/21/23 lesson): container resets wipe the gh PAT credential store — push auth needs a fresh PAT each reset; since session 23 the gh BINARY persists at `/home/z/my-project/bin/gh` (symlink `~/.local/bin/gh`), so only re-auth (`echo <PAT> | gh auth login --with-token && gh auth setup-git`), not reinstall.

## Next action (exact)

Owner reviews PASS 17 live (gateway → 3000, `?v=17`) — the sidebar is RESTORED: Home/Library/Archive at top (ink pill on the current page), hover expands 64→168 with the labels smearing in, divider, pfp + "prathamarchives" (no @) at the rail's end; the homepage stays the clean single column (Import top-right → Currently reading 60/40 → Reading lists → Recent highlights) at the 30px rhythm. Corrections arrive as turns (Loop 1/2: intake → ledger → repair → ratchet). The live menu: (1) the closing-line removal call + pfp artwork keep-or-swap (carried), (2) whatever the owner strikes next. PUSH DISCIPLINE now governs: interpretive/destructive changes push only after owner sign-off on the dev server. The moment the sidebar + homepage lock: the content-area port per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
