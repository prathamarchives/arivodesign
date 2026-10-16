# STATE — arivodesign (current-state index)

> STATUS: navigation snapshot — NOT authority (L-17). Canonical documents win on conflict.

## Where things stand

- **Position:** STAGE 3 PASS 4 PAINTED — THE COMPACTED RAIL (INT-008 → INT-009). The owner's visibility verdict ("nothing landed") was diagnosed and its failure class KILLED: pass 3 was never pushed AND the preview server sent no cache headers (stale CSS). Pass 4 executes the owner's numeric directive: rail 64 → **44px** ("cut 1/3"), expanded 224 → **176 = 4×44**, avatar 28 anchoring the top axis (x=22), cell 32 (icon 20 + 6 enclosure), icon→label gap 8px, R12 selection tint (light theme was white-on-white INVISIBLE — the "messed up" look), dark tooltip system with directional pointer, dark CTA elevation (--shadow-cta, Y6/blur14/18%), spring-rendered motion (k300/c30/m0.8 → 240ms glide, attack 50ms), content breath 3px/0.998 (inside the directive's 2–4px band), and the product surface 100% purged of "arivo" — identity is exactly `@prathamarchives` everywhere (title, greeting, overlay, footer, favicon).
- **Work (session 8):** turns 8+9 ingested verbatim (INT-008, INT-009); ALL 15 references converted and VIEWED for the first time (the turn-8 process failure — references never opened — is logged and closed); extraction + 4-part reasoning archived at `context/intake/INT-009-extraction.md`; palette cross-checked against the constitution (directive values token-mapped, zero raw hex in components); preview server replaced with a no-store server (scripts/serve_nocache.py) + cache-busted asset links (?v=4); verify.sh re-ratcheted to 44/176 and extended with 5f a–f (total arivo purge, handle exactness, latency law ≤280ms, tooltip presence, tint wiring, breath band) — 35 checks.
- **Dependencies (owner-gated):** the owner reviews PASS 4 live (port 81 gateway → 3000, now cache-proof); remaining surfaces await their correction turns. Layers still closed until reasoned: in-reader capture flows, the reading surface itself, concepts deep-dive, compounding digest. Open checks: instrument contrast check, reduced-motion emulation check.
- **Evidence:**
  - verified by run — pass 4 measured mechanically in a fresh browser session (see REVIEW.md pass-4 entry): rail 44.0 / expanded 176.0, one axis (avatar.cx = icon.cx = 22), pitch 40, tooltips in both themes, no bold in chrome, zero 'arivo' in served HTML, no-store header confirmed. verify.sh green (35 checks).
  - not checked — real-hardware motion feel (needs the owner's hand); prefers-reduced-motion not emulated in-browser (tokens collapse durations by construction); contrast not instrument-measured.
- **Coordination (snapshot at last update):** Arivoo main @ `e34dcb3` (PRs #18–#23, D-034 execution). arivodesign main: intake → paint → ratchet commits; 0 open PRs.

## Preview (the dev server)

`bash serve.sh` from repo root → http://localhost:3000 (the in-chat preview gateway proxies port 3000). Persistent run in this sandbox: double-fork via `python3 scripts/daemon-serve.py` — as of INT-008 the server is `scripts/serve_nocache.py` (sends `Cache-Control: no-store`; the plain http.server served stale CSS and the owner saw nothing — failure class closed) and asset links carry `?v=` cache-busters.

## Next action (exact)

Owner reviews pass 4 (the compacted 44px rail) and reacts. Every reaction = Loop 1/Loop 2 intake; visual corrections refine `design/`; new references extend the ref library. The moment the owner says the visuals are locked: stage 3 closes for this scope and the next layer (reading surface + capture, or whatever the owner picks) is reasoned through per D-007.

## How to use this file

Read it 8th, per AGENTS.md read order. Follow "Next action". If it conflicts with LAWS/RULES/CONTRACT/ledger — they win.
