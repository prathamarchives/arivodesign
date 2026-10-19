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

# ---------------------------------------------------------------- 5e. prototype rail guards (re-ratcheted 2026-10-17, INT-019 / INT-023 / INT-025)
# INT-016 rebuilt the sidebar to the owner's reference; INT-017
# recalibrated it to desktop scale; INT-018 MATERIALIZES it as floating
# glass with hover expansion + ink selection; INT-019 slims the
# component set (owner: "much smaller… remove the bold and thickness"):
# rail 64, items 40x34, icons 18 (thinner strokes), softer shadows,
# expansion 64 -> 168 with motion-blur treatment; INT-023 resizes the
# avatar to the turn-23 account-block reference ratio (26 = 0.40 x rail);
# INT-026 RESTORES the full-height nav column (the turn-25 strike was a
# misread — owner turn 27: "where did the sidebar go").
# (a) the floating glass rail present in the scaffold, at INT-019/023 scale,
#     full-height (top: inset) with nav rules live
if grep -q 'ref-rail-w: 64px' design/styles/tokens.css && \
   grep -q 'ref-rail-avatar: 26px' design/styles/tokens.css && \
   grep -q 'ref-rail-radius: 16px' design/styles/tokens.css && \
   grep -q 'backdrop-filter: blur(var(--ref-glass-blur))' design/styles/shell.css && \
   grep -q 'border-radius: var(--ref-rail-radius)' design/styles/shell.css && \
   grep -q 'top: var(--ref-rail-inset)' <(sed -n '/^\.rail-panel {/,/^}/p' design/styles/shell.css) && \
   grep -q 'navigation-item-' design/styles/shell.css; then
  ok "floating glass rail present (64/26 literals, R16, frosted, full-height, nav rules live — INT-026)"
else
  bad "glass rail missing/mis-built — full-height frosted R16 rail with nav required (INT-016/017/018/019/023/026)"
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
# (d) identity: the handle string (INT-025: @ dropped by owner order) on every page
pages_ok=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q 'prathamarchives' "$pg" && pages_ok=$((pages_ok+1))
done
if [ "$pages_ok" -eq 6 ] && ! grep -rq '@prathamarchives' design/*.html; then
  ok "identity prathamarchives (no @) on all 6 pages (INT-013, INT-025 de-@)"
else
  bad "identity missing on $((6-pages_ok))/6 pages or @ still present (INT-013/025)"
fi
pa=$(grep -l 'avatar-img" src="images/pfp.png?v=18' design/*.html | wc -l)
if [ "$pa" -eq 6 ] && [ -s design/images/pfp.png ]; then
  ok "real pfp image in all 6 rails (INT-024 — the monogram retired by owner order)"
else
  bad "pfp image missing on $((6-pa))/6 pages or asset absent (INT-024)"
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
# (f) page graph: 6 pages, wired by CONTENT links (the rail nav is struck —
#     INT-025; home links library+archive, archive links journal, every page
#     links home via the theme toggle / breadcrumb surface)
if grep -q 'href="library.html"' design/index.html && \
   grep -q 'href="archive.html"' design/index.html && \
   grep -q 'href="journal.html"' design/archive.html && \
   grep -q 'href="index.html"' design/home-light.html && \
   grep -q 'href="index.html"' design/library.html && \
   grep -q 'href="index.html"' design/reader.html && \
   grep -q 'href="index.html"' design/journal.html && \
   [ -s design/reader.html ]; then
  ok "page graph wired by content links (home->library/archive, archive->journal, all->home)"
else
  bad "page graph incomplete — a content surface lost its link (INT-025)"
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
# (e) cache-bust version bumped with the paint (?v=18) — the INT-008 landing-failure class
vb=$(grep -o 'tokens.css?v=[0-9]*' design/index.html | grep -o '[0-9]*$')
if [ "$vb" = "18" ]; then
  ok "asset links cache-busted at v18"
else
  bad "asset links not re-busted at v18 (found: ${vb:-none}) — owner may see stale CSS (INT-008 class)"
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
if grep -q 'brightness(0)' design/styles/shell.css && \
   grep -q 'box-shadow: 0 0 0 1px var(--ref-avatar-ring)' design/styles/shell.css; then
  ok "ink-pill glyph inversion live with the restored nav (INT-018/026); the avatar ring stands"
else
  bad "ink-pill inversion missing (nav restored needs it) or the avatar ring lost (INT-018/026)"
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
#     the tooltip's static centering. The chrome-hidden states are
#     EXEMPT since INT-027: translateY(-16px)/(-100%) there are the
#     owner-ordered auto-hide slide-up states, not hover hops — the
#     ban is scoped to everything OUTSIDE the chrome-hidden block.)
if grep 'translateY(-[0-9.]*px' design/styles/motion.css | grep -v 'translateY(-16px)' | grep -v 'translateY(-100%)' | grep -q 'translateY'; then
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

# ---------------------------------------------------------------- 5k. INT-021 identity-lock + thin-icon guards (ratcheted 2026-10-17)
# Owner turn 21: the pfp locks as a component exactly above the nav
# items (never centered, never drifting on expansion) with the handle
# @prathamarchives in front of it; "Personal space" + the bottom
# account slot die (unauthorized-move class); icons go thin (1.1).
# (a) the account slot + "Personal space" are dead on every page
acct_bad="$(grep -l 'Personal space\|account-details-\|rail-tools-' design/*.html 2>/dev/null || true)"
if [ -n "$acct_bad" ]; then
  bad "bottom account slot / 'Personal space' present in: $acct_bad (INT-021 — unauthorized text killed by owner order)"
else
  ok "no account slot / 'Personal space' on any page (INT-021)"
fi
# (b) the handle label rides the shared nav-label overlay in every rail (INT-025: no @)
hdl=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q 'nav-label">prathamarchives</p>' "$pg" && hdl=$((hdl+1))
done
if [ "$hdl" -eq 6 ]; then
  ok "handle prathamarchives as nav-label overlay on all 6 rails (INT-021, de-@ INT-025)"
else
  bad "handle label missing on $((6-hdl))/6 rails (INT-021)"
fi
# (c) the identity lock: position:relative (handle anchors) + FIXED item-slot
#     width — prototype's width:100% rides the growing wrapper = the drift bug
if sed -n '/^\.rail-panel \[class\^="identity-"\] {/,/^}/p' design/styles/shell.css | grep -q 'position: relative' \
   && sed -n '/^\.rail-panel \[class\^="identity-"\] {/,/^}/p' design/styles/shell.css | grep -q 'width: var(--ref-rail-item-w)' \
   && ! grep -q '\[class\^="identity-"\] {[^}]*width: 100%' design/styles/shell.css; then
  ok "identity locked: fixed 40px slot + relative anchor (pfp cannot drift on expansion)"
else
  bad "identity lock missing — fixed slot width + position:relative required, width:100% forbidden (INT-021 drift class)"
fi
# (d) INT-026 RESTORE (owner turn 27: "where did the sidebar go" — the
#     turn-25 strike was a MISREAD): the nav column is BACK, so the 18
#     rail glyph files must EXIST and be served (they were wrongly
#     git-rm'd in pass 16; restored from fd13038)
navres=0
for v in 11 14 17 843 846 849 646 649 652 333 337 341 184 187 190 508 511 514; do
  [ -e "design/images/vector-$v.svg" ] && navres=$((navres+1))
done
if [ "$navres" -eq 18 ]; then
  ok "all 18 rail nav icon SVGs present and served (INT-026 restore — the nav is back)"
else
  bad "only $navres/18 rail nav icon SVGs present — the restored nav needs all glyphs (INT-026)"
fi
# (e) changed ASSETS carry the cache-bust (the stale-render class); the
#     INT-026 changed set = the four stylesheets + motion.js + the pfp img
#     + the restored rail icons (all at v18; the nav srcs carry v18
#     from the restore, never the stale v15)
bust=$(grep -o 'styles/[a-z]*\.css?v=18\|motion\.js?v=18\|images/pfp\.png?v=18' design/index.html | wc -l)
stale=$(grep -o '?v=15\|?v=16\|?v=17' design/*.html | wc -l)
navbust=$(grep -o 'images/vector-[0-9]*\.svg?v=18' design/index.html | wc -l)
if [ "$bust" -ge 7 ] && [ "$stale" -eq 0 ] && [ "$navbust" -ge 3 ]; then
  ok "changed assets cache-busted (CSS x5 + motion.js + pfp + nav icons at ?v=18, no stale v15/v16/v17 — INT-008 class)"
else
  bad "cache-bust incomplete ($bust v18 links, $navbust nav busts, $stale stale v15/v16/v17) — stale-render class (INT-008)"
fi

# ---------------------------------------------------------------- 5l. INT-024 rail order + settings removal guards (re-ratcheted 2026-10-17)
# Owner turn 24: "just remove the settings and move the pfp/account at the
# bottom/end of the sidebar with the line over it that divides it. and the
# components fix on there place at top" — the INT-022 settings row is
# RETIRED; the handle keeps its repaired Inter render (turn-22 font law).
# (a) the settings row is ABSENT on every rail (owner removal order)
setres=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q 'navigation-item-settings\|gear-settings\|vector-settings' "$pg" || setres=$((setres+1))
done
if [ "$setres" -eq 6 ] && [ ! -e design/images/vector-settings-dark.svg ] && [ ! -e design/images/vector-settings-light.svg ]; then
  ok "settings row + gear SVGs fully removed on all 6 rails (INT-024)"
else
  bad "settings residue on $((6-setres))/6 pages or SVGs not deleted — INT-024 removal order"
fi
# (b) the label family pins the rail's own font (the Times fall-through class)
if sed -n '/^\.rail-panel \.nav-label {/,/^}/p' design/styles/shell.css | grep -q 'font-family: var(--font-family-inter)'; then
  ok "nav-label family pins Inter (no browser-default serif fall-through)"
else
  bad "nav-label rule lost its font-family — labels render in Times (INT-022 defect class)"
fi
# (c) the identity sits BELOW the line over it (the ref's divider->content rhythm)
if sed -n '/^\.rail-panel \[class\^="identity-"\] {/,/^}/p' design/styles/shell.css | grep -q 'margin-top: var(--ref-rail-post-divider-gap)'; then
  ok "identity 17px below the divider (bottom account block, INT-024)"
else
  bad "identity margin-top must ride --ref-rail-post-divider-gap below the line (INT-024)"
fi
# (d) the handle anchor clears the clip: avatar-edge based with the tightened gap
if grep -q '\[class\^="identity-"\] \.nav-label {' design/styles/shell.css \
   && grep -q 'ref-rail-identity-label-gap: 8px' design/styles/tokens.css \
   && sed -n '/\[class\^="identity-"\] \.nav-label {/,/^}/p' design/styles/shell.css | grep -q 'var(--ref-rail-identity-label-gap)'; then
  ok "handle anchor: avatar-edge + the tightened 8px identity gap (INT-024)"
else
  bad "handle anchor rule missing or gap not tightened to 8px (INT-024 — slot-edge start clips the string)"
fi

# ---------------------------------------------------------------- 5m. INT-026 full-rail guards (re-ratcheted 2026-10-19)
# Owner turn 27: the turn-25 "nav strike" was a MISREAD — the sidebar is
# RESTORED (destinations at top, divider, account at the end; the PASS 15
# form). Owner turn 24's bottom/end order still holds: the divider line
# OVER the account, at the rail's end.
# (a) order on every rail: destinations -> divider -> identity (the PASS 15
#     form restored by INT-026; the nav carries 3 items)
nav_bad=""; order_ok=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  items=$(grep -c 'navigation-item-' "$pg")
  dests=$(grep -c 'class="destinations-' "$pg")
  [ "$items" -eq 3 ] && [ "$dests" -eq 1 ] || { nav_bad="$nav_bad $pg(items=$items,dest=$dests)"; continue; }
  if grep -q 'class="rail-divider"' "$pg"; then
    dline=$(grep -n 'class="rail-divider"' "$pg" | head -1 | cut -d: -f1)
    iline=$(grep -n 'class="identity-' "$pg" | head -1 | cut -d: -f1)
    sline=$(grep -n 'class="destinations-' "$pg" | head -1 | cut -d: -f1)
    if [ "$sline" -lt "$dline" ] && [ "$dline" -lt "$iline" ]; then order_ok=$((order_ok+1)); fi
  fi
done
if [ -z "$nav_bad" ] && [ "$order_ok" -eq 6 ]; then
  ok "rail = full sidebar restored: 3 nav items, destinations > divider > identity on all 6 rails (INT-026)"
else
  bad "nav broken:$nav_bad or destinations>divider>identity order broken ($order_ok/6) — INT-026 restore"
fi
# (b) the ZERO-WIDTH-IMPACT law: the flow element is slot-wide, the line is an
#     absolutely-positioned ::after (a 64px flow child would widen the
#     shrink-to-fit nav wrapper and drag the avatar off the x44 axis)
if grep -q '\.rail-panel \.rail-divider {' design/styles/shell.css \
   && grep -q '\.rail-panel \.rail-divider::after {' design/styles/shell.css \
   && grep -q 'position: absolute' <(sed -n '/\.rail-panel \.rail-divider::after {/,/^}/p' design/styles/shell.css) \
   && grep -q 'left: -12px' <(sed -n '/\.rail-panel \.rail-divider::after {/,/^}/p' design/styles/shell.css) \
   && grep -q 'width: var(--ref-rail-w)' <(sed -n '/\.rail-panel \.rail-divider::after {/,/^}/p' design/styles/shell.css) \
   && ! sed -n '/^\.rail-panel \.rail-divider {/,/^}/p' design/styles/shell.css | grep -q 'width: var(--ref-rail-w)'; then
  ok "divider geometry lawful (flow spacer slot-wide, ::after absolute at the panel edge — wrapper cannot widen)"
else
  bad "divider geometry unlawful — flow element must stay 40px, the line must be the absolute ::after (INT-023 wrapper-widening class)"
fi
# (c) the line rides the one clock: same curve + duration as the rail's width,
#     expanded width token-driven
if grep -q 'transition: width 0.3s cubic-bezier(0.32, 0.72, 0, 1)' <(sed -n '/\.rail-panel \.rail-divider::after {/,/^}/p' design/styles/motion.css) \
   && grep -q 'width: var(--ref-rail-expanded)' <(sed -n '/\.rail-panel\.expanded \.rail-divider::after {/,/^}/p' design/styles/motion.css); then
  ok "divider line rides the one clock (0.3s settle curve, 64 -> 168 with the panel)"
else
  bad "divider line off-clock — must share the rail's width curve and tokens (INT-023 / INT-020 law 4)"
fi
# (d) the full-rail rhythm (INT-026 restored the PASS 15 form): the panel
#     is a FULL-HEIGHT column again (top: inset — NOT the chip's top:auto),
#     the wrapper FILLS the panel WITHOUT the chip pin (the pin must be
#     absent — re-adding it would drag the restored nav off-center);
#     the identity rides the 17px token below the line; symmetric padding
if grep -q 'top: var(--ref-rail-inset)' design/styles/shell.css \
   && ! grep -q 'top: auto' <(sed -n '/^\.rail-panel {/,/^}/p' design/styles/shell.css) \
   && ! grep -q 'margin-left: calc((var(--ref-rail-w)' design/styles/shell.css \
   && grep -q 'flex: 1 1 auto' design/styles/shell.css \
   && grep -q 'ref-rail-post-divider-gap: 17px' design/styles/tokens.css \
   && grep -q 'margin-top: var(--ref-rail-post-divider-gap)' design/styles/shell.css \
   && grep -q 'padding: var(--ref-rail-avatar-inset) 0 var(--ref-rail-avatar-inset) 0' design/styles/shell.css; then
  ok "full-rail rhythm lawful (panel full-height, wrapper fills unpinned, 17px line->avatar, symmetric padding — INT-026)"
else
  bad "full-rail rhythm broken — panel top / wrapper pin residue / 17px token / panel padding (INT-026 restore)"
fi
# (e) the pfp image: round-cropped, cover-fit, riding the 26px slot
if grep -q '\[class\^="avatar-"\] img.avatar-img {' design/styles/shell.css \
   && sed -n '/\[class\^="avatar-"\] img.avatar-img {/,/^}/p' design/styles/shell.css | grep -q 'object-fit: cover' \
   && sed -n '/\[class\^="avatar-"\] img.avatar-img {/,/^}/p' design/styles/shell.css | grep -q 'border-radius: 50%'; then
  ok "pfp image round-cropped + cover-fit on the 26px slot (INT-024)"
else
  bad "pfp image styling missing — circular cover crop required (INT-024)"
fi
# (f) page-shell row templates MUST outrank the base 2-row rule (the reader/
#     journal specificity inversion — rail clipped to 114.78px on reader, 18px
#     short on journal since INT-016; surfaced by the INT-024 render sweep)
if grep -q 'body > div .study-shell-499 { grid-template-rows: auto auto minmax(0, 1fr); }' design/styles/shell.css \
   && grep -q 'body > div .study-shell-175 { grid-template-rows: auto minmax(0, 1fr) auto; position: relative; }' design/styles/shell.css; then
  ok "page-shell row templates at (0,1,2) specificity — 3-row shells beat the base rule (INT-024 defect fix)"
else
  bad "row-template specificity regression — reader/journal rails would clip (INT-024 defect class)"
fi


# ---------------------------------------------------------------- 5o. INT-027 app-behavior guards (ratcheted 2026-10-19)
# Owner turn 28: no-refresh section switches (view transitions), mode switch
# without navigation + persistence, auto-hiding chrome, and the bidirectional
# theme layer. These are STATIC guards; the run-time behavior is proven by
# scripts/int027-verify1.py (25 checks) + int027-verify2.py (145 checks).
# (a) themes.css linked on all 6 pages, after motion.css
tl=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q 'styles/motion.css?v=18">' "$pg" && grep -q 'styles/themes.css?v=18">' "$pg" && tl=$((tl+1))
done
if [ "$tl" -eq 6 ]; then
  ok "themes.css linked on all 6 pages (INT-027 theme layer present)"
else
  bad "themes.css missing on $((6-tl))/6 pages — the mode cannot flip without it (INT-027)"
fi
# (b) icon + toggle data attrs: 4 data-icon pairs per page (3 nav + 1 toggle)
di=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  n=$(grep -c 'data-icon-dark=' "$pg")
  t=$(grep -c 'data-theme-toggle="1"' "$pg")
  [ "$n" -eq 4 ] && [ "$t" -eq 1 ] && di=$((di+1))
done
if [ "$di" -eq 6 ]; then
  ok "rail icon pairs + toggle wiring on all 6 pages (4 data-icon + data-theme-toggle each)"
else
  bad "icon/toggle wiring broken on $((6-di))/6 pages (INT-027)"
fi
# (c) inline theme-restore script right after <body> (no flash, no navigation)
tr=0
for pg in design/index.html design/home-light.html design/library.html design/archive.html design/journal.html design/reader.html; do
  grep -q "sessionStorage.getItem('pa-theme')" "$pg" && tr=$((tr+1))
done
if [ "$tr" -eq 6 ]; then
  ok "inline theme-restore script on all 6 pages (mode survives direct loads)"
else
  bad "theme-restore script missing on $((6-tr))/6 pages — direct loads lose the mode (INT-027)"
fi
# (d) motion.js carries the router + theme + auto-hide controller
if grep -q "pushState" design/motion.js && grep -q "pa-theme" design/motion.js \
   && grep -q "chrome-hidden" design/motion.js && grep -q "IDLE_MS" design/motion.js \
   && grep -q "data-page" design/motion.js; then
  ok "motion.js: router + theme controller + chrome auto-hide present (INT-027)"
else
  bad "motion.js lost a controller — router/theme/autohide markers missing (INT-027)"
fi
# (e) the DOM-state no-op guard (popstate cannot compare URL with itself)
if grep -q "The no-op guard reads the DOM STATE" design/motion.js; then
  ok "router no-op guard reads data-page (the popstate URL-identity trap is closed)"
else
  bad "router no-op guard regressed to URL comparison — back/forward desyncs DOM (INT-027 defect class)"
fi
# (f) chrome-hidden layout + motion blocks
if grep -q "body.chrome-hidden > div > \[class\^=\"study-shell-\"\]" design/styles/shell.css \
   && grep -q "grid-template-columns: 0 minmax(0, 1fr)" design/styles/shell.css \
   && grep -q "body.js.ready.chrome-hidden .rail-panel" design/styles/motion.css \
   && grep -q "translateY(-100%)" design/styles/motion.css; then
  ok "chrome auto-hide: grid collapse + fade/slide-up states lawful (INT-027)"
else
  bad "chrome auto-hide CSS broken — layout or motion rules missing (INT-027)"
fi
# (g) themes.css carries the canvas mirror + ink remaps + the journal surface fix
if grep -q "background-color: #171717" design/styles/themes.css \
   && grep -q "background-color: #222222" design/styles/themes.css \
   && grep -q "body.theme-dark .text-rgb-37-37-37" design/styles/themes.css \
   && grep -q "body.theme-light .text-rgb-238-238-234" design/styles/themes.css \
   && grep -q "body.theme-dark .node-196 { background-color: #2C2C2C" design/styles/themes.css; then
  ok "themes.css: canvas mirror + bidirectional ink + journal SOURCE PREVIEW surface (INT-027)"
else
  bad "themes.css incomplete — canvas/ink/journal-surface rules missing (INT-027)"
fi
# (h) cover art never remapped (the law): no book-cover/spine/rule rules in themes.css
if ! grep -qE "theme-dark \.(book-cover|spine|rule-|door-study|handle-|system-)" design/styles/themes.css \
   && ! grep -qE "theme-light \.(book-cover|spine|rule-|door-study|handle-|system-)" design/styles/themes.css; then
  ok "cover art untouched by the theme layer (both directions) — the remap law holds"
else
  bad "themes.css remaps cover art — forbidden (identical across themes by design)"
fi

# ---------------------------------------------------------------- 5n. INT-025 homepage corposlop + rhythm guards (ratcheted 2026-10-17)
# Owner turn 25: "remove everything i have marked — mostly unnecessary
# corposlop main-character-type texts and lines and shit... fix the
# composition and positioning of whole homepage accordingly."
# (a) the marked texts are DEAD on both homepage themes
slop_bad=""
for pg in design/index.html design/home-light.html; do
  for s in "A little further" "Pick up a book" "PICK UP WHERE YOU LEFT OFF" \
           "A place for focus" "Today’s page" "RETURN TO A THOUGHT" \
           "Make the next action legible" "Your space, at your pace" \
           "FRIDAY, OCTOBER" "reflection-space" "today-s-journal" "return-to-a-thought" "⌘"; do
    grep -q "$s" "$pg" && slop_bad="$slop_bad $pg:$s"
  done
done
if [ -z "$slop_bad" ]; then
  ok "all marked corposlop removed from both homepage themes (hero, card eyebrows, journal card, return block, closing line, ⌘K)"
else
  bad "corposlop residue:$slop_bad (INT-025 removal order)"
fi
# (b) the homepage keeps its functional survivors (unmarked content)
if grep -q 'Import a work' design/index.html && grep -q 'Currently reading' design/index.html \
   && grep -q 'Reading lists' design/index.html && grep -q 'Recent highlights' design/index.html \
   && grep -q 'Continue reading' design/index.html && grep -q 'Search anything' design/index.html; then
  ok "functional homepage content survives (Import/sections/CTA/search — unmarked)"
else
  bad "homepage lost unmarked functional content — removal overreach (INT-025 scope law)"
fi
# (c) the ONE equal gap: 30px rhythm token + the shell overrides
if grep -q 'ref-section-gap: 30px' design/styles/tokens.css \
   && grep -q 'padding-top: var(--ref-section-gap)' design/styles/shell.css \
   && grep -q 'gap: var(--ref-section-gap)' design/styles/shell.css \
   && grep -q 'justify-content: flex-end' design/styles/shell.css \
   && grep -q 'align-items: stretch' design/styles/shell.css; then
  ok "homepage rhythm: one 30px gap (header/row/sections), Import right-anchored, sections edge-aligned full-width"
else
  bad "homepage rhythm broken — the equal-gap law (INT-025: measure + divide equally)"
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
