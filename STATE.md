# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 3 PAINTED — THE SIDEBAR CORRECTED (INT-007). The owner's first visual correction landed: the sidebar is re-derived, not restyled — 64px rail (cell 40, expanded 224 = 3.5×64), avatar anchoring the top, overlay expansion (the page breathes in transform, never reflows), wordmark/name/bold deleted, envelope 80ms/380ms/160ms. The owner's 4-step reasoning protocol (perspectives → raw material → cross-field methods → external arbiters) is now standing law for every correction pass.
- **Work (session 7):** INT-007 ingested (verbatim + 6 refs archived, ref-1 = acceptance image); extraction protocol archived at `context/intake/INT-007-extraction.md`; sidebar rebuilt in index.html/shell.css/tokens.css; the aperture-glass refactor introduced a NEW critical failure class caught by the loop's own verification — the positioned glass pseudo painted over its own children (avatar/hairline/pin invisible); fixed with load-bearing `z-index: -1` and ratcheted into verify.sh 5e (5 new permanent checks: z -1 guard, chrome bold ban, wordmark resurrection ban, margin-slide ban, geometry tokens). REVIEW.md pass-3 entry (7 defects w/ evidence); DESIGN-SYSTEM.md lockstep (chrome weight law, envelope law, registry rewrite); pass-3 previews archived (rail/expanded/hover/overlay, dark+light).
- **Dependencies (owner-gated):** the owner reviews PASS 3 live (preview gateway → port 3000) — the sidebar is the corrected surface; remaining surfaces (home cards, library, archive, account overlay interior) await their correction turns. Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast check, reduced-motion emulation check.
- **Evidence:**
  - verified by run — pass 3 measured mechanically in a fresh browser session: rail 64.0/224.0, cells 40.0, stack rhythm 25→77→90→136; content transition = transform (breath matrix 0.996/6px, zero reflow); ::before width constant 224 (aperture); envelope delays 0.08s/0.16s in both destination states; sidebar subtree weight ≤400 except avatar monogram (artwork, documented); wordmark absent; both themes + hover + pin + overlay + Escape exercised; console clean. Previews: design/preview/sidebar-*.png, account-overlay-top.png. verify.sh green (29 checks).
  - not checked — real-hardware motion feel (needs the owner's hand); prefers-reduced-motion not emulated in-browser (tokens collapse durations by construction); contrast not instrument-measured.
- **Coordination (snapshot at last update):** Arivoo main @ `e34dcb3` (PRs #18–#23, D-034 execution). arivodesign main: intake → spec → paint → audit commits; 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: double-fork via `python3 scripts/daemon-serve.py` (plain background jobs die with the tool call's process group — session-5 lesson, logged).

## Next action (exact)

Owner reviews pass 2 and reacts. Every reaction = Loop 1/Loop 2 intake; visual corrections refine `design/`; new references extend the ref library. The moment the owner says the visuals are locked: stage 3 closes for this scope and the next layer (reading surface + capture, or whatever the owner picks) is reasoned through per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
