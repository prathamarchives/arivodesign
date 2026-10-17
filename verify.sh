#!/usr/bin/env bash
# verify.sh — arivodesign's ONE verify command (the mechanical half of Loop 4)
# Run from repo root:  bash verify.sh
#
# It grows ONLY via the ratchet (GOVERNANCE.md Loop 2, step 6): every mechanically-
# checkable failure class becomes a permanent check here. Never add speculative checks (R-X07).
#
# Exit 0 = green (safe to push). Exit 1 = red (fix first — R-X10).

set -u
fail=0
lines=()
ok()   { lines+=("  ok   $1"); }
bad()  { fail=1; lines+=("  FAIL $1"); }

# Location-robust: always operate from the repo root (the dir containing this script).
cd "$(dirname "$0")" || { echo "VERIFY: FAIL — cannot cd to repo root"; exit 1; }

# ---------------------------------------------------------------- 1. raw corpus alive
# Append-only sentinel: every known raw turn must still exist, non-empty (L-07).
for f in context/raw/turn-*.txt; do
  if [ -s "$f" ]; then ok "raw present: $f"; else bad "raw missing/empty: $f (L-07)"; fi
done
if ! compgen -G "context/raw/turn-*.txt" > /dev/null; then
  bad "no raw turns found — intent corpus missing (L-02)"
fi

# ---------------------------------------------------------------- 2. every raw turn is ledgered
for f in context/raw/turn-*.txt; do
  [ -e "$f" ] || continue              # no matches → guard, not a failure (check 1 handles emptiness)
  n="$(basename "$f" .txt)"            # turn-001
  num="${n#turn-}"
  case "$num" in ''|*[!0-9]*) bad "unparseable raw turn name: $f"; continue;; esac
  printf -v id 'INT-%03d' "$((10#$num))"   # INT-001 — zero-padded, matches ledger convention
  if grep -q "\*\*$id" INTENT-LEDGER.md 2>/dev/null; then
    ok "$id ledgered"
  else
    bad "raw turn $f has no $id entry in INTENT-LEDGER.md (L-02)"
  fi
done

# ---------------------------------------------------------------- 3. no secrets in tracked files (L-15)
if grep -rInE 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}' \
     --exclude-dir=.git . >/dev/null 2>&1; then
  bad "possible credential string in tracked files (L-15)"
else
  ok "no credential patterns in tracked files"
fi

# ---------------------------------------------------------------- 4. quarantine leak check (L-14)
# The old Arivo repo may be discussed in ledger/raw/laws/decisions (as grounds),
# but a DESIGN ARTIFACT must never reference it.
leak="$(grep -rIlE 'prathamarchives/Arivo' --include='*.html' --include='*.css' --include='*.js' . 2>/dev/null || true)"
if [ -n "$leak" ]; then
  bad "old-Arivo reference inside design artifact(s): $leak (L-14)"
else
  ok "no old-Arivo references in design artifacts"
fi

# ---------------------------------------------------------------- 5. kernel + harness present
for f in AGENTS.md LAWS.md RULES.md CONTRACT.md PRINCIPLES.md DECISIONS.md \
         INTENT-LEDGER.md GOVERNANCE.md STATE.md GLOSSARY.md verify.sh; do
  if [ -s "$f" ]; then ok "system file present: $f"; else bad "system file missing/empty: $f"; fi
done

# ---------------------------------------------------------------- 5b. paint artifacts belong to THIS repo
# (ratcheted 2026-10-14: a wrong-CWD git commit landed the paint in the host
# workspace repo instead of here — this check makes that failure impossible to miss)
if git rev-parse --is-inside-work-tree > /dev/null 2>&1 && \
   git ls-files --error-unmatch design/index.html > /dev/null 2>&1; then
  ok "paint artifacts committed to this repo"
else
  bad "design/ is NOT tracked by this repo — a commit landed in the wrong CWD or paint is uncommitted"
fi

# ---------------------------------------------------------------- 5c. CSS selector integrity
# (ratcheted 2026-10-14, Loop 5 audit: a corrupted selector `.overlay-rootidden]` — a
# missing `[` — silently disabled the overlay hide rule; the UI died after the first
# overlay close because the fixed overlay root kept covering the viewport. CSS never
# errors on unknown selectors, so the proxy check: any line in design/styles/ that
# contains `]` must also contain `[`.)
css_bad="$(grep -Hn ']' design/styles/*.css 2>/dev/null | grep -v '\[' || true)"
if [ -n "$css_bad" ]; then
  bad "corrupted CSS selector line(s) — ']' without '[' on the same line:"
  lines+=("$css_bad")
else
  ok "css selector brackets balanced per line"
fi

# ---------------------------------------------------------------- 5d. git fileMode off (ratcheted 2026-10-14, session 6)
# (the sandbox chmods files to 755 behind the agent's back; with core.fileMode on,
# every commit silently sweeps 25+ unrelated "mode change" entries — real content
# gets buried in mode churn. Modes carry no meaning in this repo: docs + web assets.)
if [ "$(git config core.fileMode || echo on)" = "false" ]; then
  ok "core.fileMode=false (mode churn cannot pollute commits)"
else
  bad "core.fileMode is not false — run: git config core.fileMode false (mode-churn guard)"
fi

# ---------------------------------------------------------------- 5e. prototype rail guards (re-ratcheted 2026-10-17, INT-019)
# INT-016 rebuilt the sidebar to the owner's reference; INT-017
# recalibrated it to desktop scale; INT-018 MATERIALIZES it as floating
# glass with hover expansion + ink selection; INT-019 slims the
# component set (owner: "much smaller… remove the bold and thickness"):
# rail 64, items 40x34, icons 18 (thinner strokes), avatar 24, softer
# shadows, expansion 64 -> 168 with motion-blur treatment.
# (a) the floating glass rail present in the scaffold, at INT-019 scale
if grep -q 'ref-rail-w: 64px' design/styles/tokens.css && \
   grep -q 'ref-rail-avatar: 24px' design/styles/tokens.css && \
   grep -q 'ref-rail-icon: 18px' design/styles/tokens.css && \
   grep -q 'ref-rail-radius: 16px' design/styles/tokens.css && \
   grep -q 'backdrop-filter: blur(var(--ref-glass-blur))' design/styles/shell.css && \
   grep -q 'border-radius: var(--ref-rail-radius)' design/styles/shell.css && \
   grep -q '\.rail-panel \[class\^="navigation-item-"\]\.selected' design/styles/shell.css; then
  ok "floating glass rail present (64/24/18 literals, R16, frosted, ink pill)"
else
  bad "glass rail missing/mis-built — floating frosted R16 column + ink pill required (INT-016/017/018/019)"
fi
if grep -q 'margin-left: calc(var(--sidebar-w' design/styles/shell.css; then
  bad "content margin-slide regression in shell.css — hover expansion must overlay (INT-007/013)"
else
  ok "no content margin-slide (static rail, nothing to slide)"
fi
# (b) chrome weight discipline: the prototype speaks normal + 500 — no 700 in paint or glue
if grep -q 'font-weight: 700\|font-weight:700' design/styles/shell.css design/styles/motion.css design/styles/tokens.css context/references/figma-v1/styles.css 2>/dev/null; then
  bad "font-weight 700 found — prototype voice is 400/500 only (INT-013)"
else
  ok "no bold in paint or glue (400/500 voice)"
fi
# (c) full-page app guard: the artifact framing is dead (INT-016 "make it full
#     page. like actual ui") — the app fills the viewport, no canvas card.
if grep -q 'height: 100dvh' design/styles/shell.css && \
   ! grep -q 'border-radius: 24px' design/styles/shell.css; then
  ok "full-page app frame (100dvh, no artifact card framing)"
else
  bad "artifact framing regression — full-bleed app required (INT-016)"
fi
# (d) identity: the handle string on every page, avatar monogram pa in every rail
pages_ok=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q '@prathamarchives' "$pg" && pages_ok=$((pages_ok+1))
done
if [ "$pages_ok" -eq 6 ]; then
  ok "identity @prathamarchives on all 6 pages"
else
  bad "identity missing on $((6-pages_ok))/6 pages (INT-013)"
fi
pa=$(grep -l '>pa</span>' design/*.html | wc -l)
if [ "$pa" -eq 6 ]; then
  ok "avatar monogram pa in all 6 rails"
else
  bad "avatar monogram missing on $((6-pa))/6 pages"
fi

# ---------------------------------------------------------------- 5f. prototype surface guards (re-ratcheted 2026-10-16, INT-013)
# (a) 'arivo' surface law, amended by the owner's own hand: the prototype uses the
#     arivo:// URI scheme in the journal (the owner wrote it). The amendment:
#     pages must not contain 'arivo' EXCEPT the owner's arivo:// URI strings.
arivo_bad="$(grep -l 'arivo' design/index.html design/home-light.html design/library.html design/archive.html design/reader.html 2>/dev/null || true)"
arivo_journal_bad="$(grep 'arivo' design/journal.html 2>/dev/null | grep -v 'arivo://' || true)"
if [ -n "$arivo_bad" ] || [ -n "$arivo_journal_bad" ]; then
  bad "'arivo' outside the owner's arivo:// URIs — product surface stays identity-only (INT-008, amended INT-013)"
else
  ok "arivo absent except the owner's arivo:// URIs (journal)"
fi
# (b) latency law, INT-020 form: the rail EXPANDS on hover on the
#     shared settle curve — one clock, 300ms, no overshoot. (The
#     INT-009/019 ≤260ms form is superseded: that law was written
#     against bounce-era curves; the rebuilt system trades 40ms for
#     a true S-curve and ratchets no-bounce structurally in 5j.)
if grep -q 'width 0\.3[0-5]\?s' design/styles/motion.css; then
  ok "rail expansion present and smooth (width 0.3xs, settle curve, no bounce)"
else
  bad "rail width transition missing or mistimed — expansion needs width 0.3[0-5]s (INT-020)"
fi
# (c) tooltip system: data-tip hooks + ink-inverted chip in the motion layer
if grep -q 'data-tip=' design/index.html && grep -q 'data-tip\]::after' design/styles/motion.css; then
  ok "tooltip system present (data-tip hooks + motion chip)"
else
  bad "tooltip system missing (INT-009 B, INT-013 motion layer)"
fi
# (d) prototype.css frozen: the verbatim export header must be intact
if head -1 design/styles/prototype.css | grep -q 'VERBATIM Figma v1 export'; then
  ok "prototype.css verbatim header intact (frozen artifact)"
else
  bad "prototype.css was edited — it is a FROZEN artifact of the owner's export (INT-013)"
fi
# (e) fonts self-hosted: no Google CDN, local woff2 present
if grep -q 'fonts.googleapis' design/*.html 2>/dev/null; then
  bad "Google Fonts CDN link present — fonts must be self-hosted (INT-013)"
else
  ok "no font CDN in pages"
fi
for f in design/assets/fonts/inter-400.woff2 design/assets/fonts/inter-500.woff2 design/assets/fonts/lora-400.woff2; do
  if [ -s "$f" ]; then ok "font present: $(basename "$f")"; else bad "font missing: $f (INT-013)"; fi
done
# (f) page graph: 6 pages, nav anchors wired
nlinks=$(grep -o 'class="navigation-item-[0-9]*" href=' design/*.html | wc -l)
if [ "$nlinks" -ge 15 ] && [ -s design/library.html ] && [ -s design/archive.html ] && [ -s design/journal.html ] && [ -s design/reader.html ]; then
  ok "page graph wired (nav anchors: $nlinks, 6 pages)"
else
  bad "page graph incomplete (nav anchors: $nlinks/15+)"
fi

# ---------------------------------------------------------------- 5g. INT-013 motion + integrity guards (re-ratcheted 2026-10-16)
# (a) the motion layer exists: entrance rise, progress fill-in, hover
#     GROWTH (scale — the INT-020 expand-not-bounce law; the :active
#     press-scale is retired as bounce-family), reduced-motion gate
if grep -q '\.rise' design/styles/motion.css && grep -q 'fill-anim' design/styles/motion.css \
   && grep -q 'prefers-reduced-motion' design/styles/motion.css && grep -q 'scale(1.0' design/styles/motion.css; then
  ok "motion layer present (rise + fill + growth, reduced-motion gated)"
else
  bad "motion layer incomplete — 'with motion effects' is part of the directive (INT-013/020)"
fi
# (b) motion.js wired on every page
mjs=$(grep -l 'motion.js' design/*.html | wc -l)
if [ "$mjs" -eq 6 ]; then
  ok "motion.js wired on all 6 pages"
else
  bad "motion.js missing on $((6-mjs))/6 pages"
fi
# (c) cover anatomy restored: the export lost frame dims — glue must size them
if grep -q 'book-cover-39' design/styles/shell.css && grep -q '118px' design/styles/shell.css; then
  ok "cover dimensions restored in glue (large 118 / medium 72 / small 56)"
else
  bad "cover dims missing — the export's covers collapse without them (INT-013)"
fi
# (d) progress tracks visible: 4px track + fill heights
if grep -q 'progress-track-' design/styles/shell.css && grep -q 'height: 4px' design/styles/shell.css; then
  ok "progress track/fill sized (4px, visible tracks)"
else
  bad "progress tracks unsized — invisible progress was the G-class failure (INT-013)"
fi
# (e) cache-bust version bumped with the paint (?v=11) — the INT-008 landing-failure class
vb=$(grep -o 'tokens.css?v=[0-9]*' design/index.html | grep -o '[0-9]*$')
if [ "$vb" = "11" ]; then
  ok "asset links cache-busted at v11"
else
  bad "asset links not re-busted at v11 (found: ${vb:-none}) — owner may see stale CSS (INT-008 class)"
fi
# (f) no external resource references — everything local (the export's only CDN was fonts)
ext="$(grep -hEo 'src="http[^"]*"|href="http[^"]*"' design/*.html 2>/dev/null | grep -v '^$' || true)"
if [ -n "$ext" ]; then
  bad "external resource reference(s) in pages: $ext"
else
  ok "zero external resources (fully local prototype)"
fi

# ---------------------------------------------------------------- 5h. preview infrastructure is TRACKED (ratcheted 2026-10-17, INT-014)
# (session-10's untracked scripts/ died with the sandbox reset — L-10: unpushed work
# never happened. The preview server + daemon are repo capabilities now: on disk,
# in git, and the no-store header actually in the code.)
if git ls-files --error-unmatch scripts/serve_nocache.py >/dev/null 2>&1; then
  ok "no-store server tracked in git (survives sandbox resets)"
else
  bad "scripts/serve_nocache.py is not TRACKED — the INT-008 class regressed (L-10)"
fi
if git ls-files --error-unmatch scripts/daemon_nocache.py >/dev/null 2>&1; then
  ok "preview daemon tracked in git"
else
  bad "scripts/daemon_nocache.py is not TRACKED — plain nohup daemons die at tool-call boundaries"
fi
if grep -q 'no-store, must-revalidate' scripts/serve_nocache.py 2>/dev/null; then
  ok "no-store header present in server code (INT-008 class: closed)"
else
  bad "serve_nocache.py lost the Cache-Control no-store header"
fi

# ---------------------------------------------------------------- 5i. INT-018 glass + ink guards (ratcheted 2026-10-17)
# The owner's standing glass ask (INT-004) lands on the rail by INT-018:
# frosted translucency + luminous canvas (pass-2 law: glass on a dead
# canvas is a defect) + ink-inverted selection with glyph flip.
if grep -q 'rgba(23, 23, 23, 0.72)' design/styles/tokens.css && \
   grep -q 'rgba(255, 255, 255, 0.72)' design/styles/tokens.css; then
  ok "translucent rail surfaces in both themes (glass law)"
else
  bad "rail surface is opaque — frosted translucency required (INT-004/018)"
fi
if grep -q 'radial-gradient' design/styles/tokens.css; then
  ok "canvas glow washes present (glass needs luminosity)"
else
  bad "canvas glow missing — frosted glass on a flat canvas reads dead (pass-2 law)"
fi
if grep -q 'filter: brightness(0)' design/styles/shell.css && \
   grep -q 'filter: brightness(0) invert(1)' design/styles/shell.css; then
  ok "ink pill glyph inversion present (both themes)"
else
  bad "selected glyph inversion missing — the ink pill needs its inverted icon (INT-018)"
fi
if grep -q "rail.classList.add('expanded')" design/motion.js && \
   grep -q 'ref-rail-expanded' design/styles/motion.css; then
  ok "expansion interaction wired (motion.js + motion.css)"
else
  bad "rail expansion not wired — hover expand is the owner's INT-018 order"
fi
# INT-020: motion blur belongs to TEXT ONLY — the labels smear in
# (blur 5px -> 0 as they fade); a PANEL-wide blur keyframe is
# forbidden (owner verdict: "hurts my eyes").
if grep -q 'filter: blur(5px)' design/styles/motion.css && \
   ! grep -q 'rail-open-blur' design/styles/motion.css; then
  ok "motion-blur treatment on TEXT reveal only (no panel-wide blur)"
else
  bad "motion blur misplaced — text smear-in required, rail-open-blur forbidden (INT-020 order)"
fi

# ---------------------------------------------------------------- 5j. INT-020 motion-system guards (ratcheted 2026-10-17)
# The owner ordered the motion system rebuilt from scratch (expand
# not bounce / text fades with motion blur / no unnecessary texts).
# Every failure class found or killed this pass becomes a check.
# (a) no unnecessary chrome text: the save-state is dead everywhere
if grep -q 'All changes saved' design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html 2>/dev/null; then
  bad "save-state text present — 'never put the unnecessary texts anywhere' (INT-020)"
else
  ok "no save-state text on any page (INT-020)"
fi
# (b) zero-layout labels: the pass-10 layout-animation reveal clipped
#     the labels to zero height (the "messed up, texts" bug) — the
#     collapse-class animations must never come back
if grep -q 'max-height: 0\|max-width: 0' design/styles/motion.css; then
  bad "layout-collapsed reveal text in motion.css — labels must be zero-layout overlays (INT-020 law 3)"
else
  ok "no max-w/h collapse tricks on reveal text (labels render — the pass-10 text bug is dead)"
fi
if sed -n '/^\.rail-panel \.nav-label {/,/^}/p' design/styles/shell.css | grep -q 'position: absolute'; then
  ok "nav-label is an absolute overlay (zero-layout law held)"
else
  bad "nav-label lost its absolute overlay — layout jank returns (INT-020 law 3)"
fi
# (c) one transition stack: the pass-10 entrance rule re-declared
#     `transition` on .rail-panel, permanently shadowing the width
#     transition — the rail SNAPPED open (the "no expand animation"
#     bug). Entrance states may never own transitions.
if sed -n '/body\.js\.ready \.rail-panel {/,/^}/p' design/styles/motion.css | grep -q 'transition'; then
  bad "entrance ready-rule re-declares transition on .rail-panel — the one-stack law (INT-020 law 5, snap-bug class)"
else
  ok "one transition stack on .rail-panel (entrance owns no transitions)"
fi
# (d) no stagger: per-item transition-delay cascades are bounce
if grep -q ':nth-child' design/styles/motion.css; then
  bad "nth-child stagger in motion.css — stagger IS bounce (INT-020 law 4)"
else
  ok "no stagger cascade anywhere (one clock)"
fi
# (e) hover = growth, never a hop: no pixel-translateY hops in the
#     hover family; scale-up present. (translateY(-50%) is exempt —
#     it is the tooltip's static vertical centering, never animated)
if grep -q 'translateY(-[0-9.]*px' design/styles/motion.css; then
  bad "translateY hop in motion.css — hover grows (scale), it does not hop (INT-020 law 1)"
else
  ok "no hop family (hover = scale growth only)"
fi
# (f) HTML div balance: a surgery pass left an orphan </div> that
#     cascade-closed the rail early and re-parented the whole page
#     (session-17 forensic) — balanced markup, mechanically checked
bal_bad=""
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  o=$(grep -o '<div\b' "$pg" | wc -l); c=$(grep -o '</div>' "$pg" | wc -l)
  [ "$o" -eq "$c" ] || bal_bad="$bal_bad $pg(${o}/${c})"
done
if [ -n "$bal_bad" ]; then
  bad "div-unbalanced page(s) — orphan close cascades the tree apart:$bal_bad"
else
  ok "all 6 pages div-balanced (no orphan-close cascade class)"
fi

# ---------------------------------------------------------------- 6. worklog is alive for the latest turn
latest="$(ls context/raw/turn-*.txt 2>/dev/null | sort | tail -1)"
if [ -n "$latest" ]; then
  n="$(basename "$latest" .txt)"
  num="${n#turn-}"
  case "$num" in ''|*[!0-9]*) bad "unparseable latest turn name: $latest"; num="";; esac
  if [ -n "$num" ]; then
  printf -v id 'INT-%03d' "$((10#$num))"
  if grep -q "$id" context/WORKLOG.md 2>/dev/null; then
    ok "worklog mentions $id"
  else
    bad "worklog does not mention $id — latest turn has no session entry (R-D07)"
  fi
  # ---------------------------------------------------------------- 7. STATE freshness
  if grep -q "$id" STATE.md 2>/dev/null; then
    ok "STATE mentions $id"
  else
    bad "STATE.md does not mention $id — navigation stale (L-17)"
  fi
  fi
fi

# ---------------------------------------------------------------- report
printf '%s\n' "${lines[@]}"
echo
if [ "$fail" -eq 0 ]; then
  echo "VERIFY: PASS — safe to push"
else
  echo "VERIFY: FAIL — fix before push (R-X10). If this red is itself a new failure class, ratchet it into a check (R-D08)."
fi
exit "$fail"
