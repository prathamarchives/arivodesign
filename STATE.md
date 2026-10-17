# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 8 — "THE SCALE RECALIBRATION" (INT-017, session 14) — inside the ruthless-iteration loop the owner opened on turn 16. The owner's verdict on pass 7: "can you fix this, like does it make any sense. why so big? or is it a bug in preview?" — diagnosed with evidence (NOT a preview bug: DOM-measured render fidelity + screenshots at 1440 and preview-pane-class 900 + VLM audits; the channel is clean), root cause = INT-016's tablet-literal port (the reference is a ~2.49× touch-first tablet capture; its values as literal CSS clashed with the export's desktop-scale components) amplified by the pane's narrower viewport. FIX LANDED: the reference port is recalibrated ÷2.39 to desktop scale with every reference RATIO preserved — static 72px rail, 30px avatar @25 inset, icon-only items 49×41 R8 at 55 pitch, 22px icons, selection pill (no icon color change), 1px hairline; content rhythm 24 margins / 24 header inset / 15px breadcrumb / 20 gap. Geometry browser-measured exact; VLM verdict: rail reads desktop-class, harmonious with content.
- **Prior state:** PASS 7 (INT-016) — full-page conversion + reference sidebar at tablet-literal scale; pass 8 keeps its composition law (ratios) and moves only the unit scale. PASS 6 component paint (prototype.css, byte-verbatim frozen) untouched underneath.
- **Work (session 14):** turn-017 ingested verbatim (INT-017; ledgered with the diagnosis-before-repair protocol); tokens.css INT-017 block (72/30/25/49/41/8/55/40/22 + rhythm 24/24/22/20, INT-016 values kept as comment trail); shell.css rescale glue (avatar monogram 12px, header uses the gap token, breadcrumb 15px, top-anchored overlays re-anchored to the 66px header); v8 cache-bust on all pages; verify.sh 5e + 5g(e) re-ratcheted to the desktop-scale truth.
- **Dependencies (owner-gated):** the owner re-reviews PASS 8 live (gateway → 3000, `?v=8`, no-store). Open carried calls: rail width 72 (vs 64/80 — one token), pill R8 optical bump, rail bottom content, hover-label behavior vs tooltips, dark-theme deltas, and the CONTENT-area scale questions (the export's own hero type + cover sizes — frozen-artifact territory needing the owner's ruling). Then the queued content-area composition per the reference (segmented control + card rhythm, measured in `context/intake/INT-016-ref-spec.md`). Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast, reduced-motion emulation. PAT rotation advised.
- **Evidence:**
  - verified by run — session 14: verify.sh green after re-ratchet (5e desktop-rail literals 72/30/22, 5g(e) v8, all standing guards intact); browser-measured at 1440×900: rail 72×900 + 1px #2A2A28 hairline, avatar 30×30 @(20.5,25), items 49×41 @ x11 y 95/150/205 (pitch 55), icons 22×22, avatar-center→first-center 75.5, header 66px / crumb 15px, pill #1F1F1D dark / #EFEFEB light, tooltip opacity 1 on hover; 6 pages console-clean at v8; VLM fix-audit (1440+900): rail reads desktop-class and harmonious, no "too big" verdict. Evidence: `design/preview/p8-01..07-*.png` + REVIEW.md pass-8 entry.
  - not checked — real-hardware motion feel (needs the owner's hand); prefers-reduced-motion not emulated; contrast not instrument-measured; content-area components (segmented control, card anatomy) still unported.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: `python3 scripts/daemon_nocache.py 3000` (true double-fork daemon → `scripts/serve_nocache.py`, which sends `Cache-Control: no-store`; the plain http.server served stale CSS and the owner saw nothing — failure class closed, INT-008). Asset links carry `?v=` cache-busters (current: **v8**). Both scripts are TRACKED (INT-014) — a sandbox reset loses nothing; rerun the daemon one-liner and the preview is live again.

## Next action (exact)

Owner re-reviews PASS 8 live (gateway → 3000, `?v=8`) — the rail is now desktop-scale with the reference's ratios intact. Corrections arrive as turns (Loop 1/2: intake → ledger → repair → ratchet). The live menu: (1) rail width / pill radius fine-tuning (one-token changes), (2) rail bottom content, (3) hover-label behavior, (4) dark deltas, (5) the content-area scale questions (owner's frozen export values — needs explicit ruling to touch prototype-territory via glue overrides), then (6) the queued content composition port (segmented control, card rhythm, margins — already measured in the intake spec). The moment the sidebar locks: content composition iteration opens per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
