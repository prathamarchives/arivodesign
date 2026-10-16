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

# ---------------------------------------------------------------- 5e. sidebar pass-3 regression guards (ratcheted 2026-10-16, INT-007)
# (a) paint-order trap: the aperture glass lives on .sidebar::before; a positioned
#     pseudo with z auto paints ABOVE non-positioned children — the avatar disc,
#     hairline and pin were swallowed by their own glass (found in pass-3 browser
#     verification). z -1 on that pseudo is load-bearing; it must never disappear.
if grep -A6 '\.sidebar::before' design/styles/shell.css | grep -q 'z-index: -1'; then
  ok "aperture glass stays behind rail content (::before z -1 present)"
else
  bad ".sidebar::before lost z-index: -1 — rail content paints under its own glass (pass-3 failure class)"
fi
# (b) chrome bold ban: owner turn-007 — no bold fonts in the sidebar chrome.
#     (The avatar monogram's 700 lives in components.css = artwork voice, out of scope.)
if grep -q 'font-weight: 700' design/styles/shell.css; then
  bad "font-weight: 700 found in shell.css — chrome text must stay <= 400 (INT-007)"
else
  ok "no bold in sidebar chrome (shell.css)"
fi
# (c) wordmark resurrection ban: owner turn-007 removed it; it must not creep back.
#     (Precise: the word may appear in comments DOCUMENTING the removal — the
#     class, the rule, or the token are the resurrection.)
if grep -qE 'class="wordmark"|\.wordmark|font-wordmark' design/index.html design/styles/*.css 2>/dev/null; then
  bad "wordmark resurrected (class/rule/token found) — owner removed it (INT-007)"
else
  ok "no wordmark in paint or tokens"
fi
# (d) content margin-slide ban: expansion is an OVERLAY; the page answers with a
#     transform breath, never a margin reflow (the old margin-slide is dead — INT-007).
if grep -q 'margin-left: calc(var(--sidebar-w' design/styles/shell.css; then
  bad "content margin-slide regression in shell.css — expansion must overlay, not reflow (INT-007)"
else
  ok "no content margin-slide (overlay expansion intact)"
fi
if grep -q 'transform-origin: left center' design/styles/shell.css; then
  ok "content breath present (transform-origin: left center)"
else
  bad "content breath missing — the page must react to expansion (INT-007)"
fi
# (e) geometry tokens: the derived numbers are the law — 44 rail (owner: cut 1/3
#     of 64), expanded 176 = 4 × 44 (rational). Supersedes INT-007's 64/224 (INT-009).
if grep -q -- '--sidebar-w: 44px' design/styles/tokens.css && \
   grep -q -- '--sidebar-w-expanded: 176px' design/styles/tokens.css; then
  ok "sidebar geometry tokens exact (44 / 176)"
else
  bad "sidebar geometry tokens missing or altered — 44 / 176 are derived law (INT-009)"
fi

# ---------------------------------------------------------------- 5f. pass-4 guards (ratcheted 2026-10-16, INT-008/009)
# (a) TOTAL product-surface purge: the owner removed every visible "arivo" (turn-008:
#     "remove the arivo text") — HTML must contain the string ZERO times. The old
#     sidebar-scoped wordmark ban let title/About/footer survive; this closes it.
if grep -qi 'arivo' design/index.html; then
  bad "'arivo' found in index.html — the product surface must be 100% purged (INT-008/009)"
else
  ok "no 'arivo' anywhere in the product surface (index.html)"
fi
# (b) identity exactness: the handle string is the identity, everywhere it appears.
if grep -q '@prathamarchives' design/index.html; then
  ok "handle identity @prathamarchives present"
else
  bad "handle @prathamarchives missing — identity must be the exact handle string (INT-009 C)"
fi
# (c) latency law: the spring render is 240ms; a regression past 280ms is the
#     "can be alot smoother, better latency" failure returning.
dur=$(grep -o -- '--dur-panel: [0-9]\+ms' design/styles/tokens.css | grep -o '[0-9]\+' | head -1)
if [ -n "$dur" ] && [ "$dur" -le 280 ]; then
  ok "panel latency within the spring render (${dur}ms <= 280ms)"
else
  bad "--dur-panel is ${dur:-unset}ms — exceeds the INT-009 latency law (<= 280ms)"
fi
# (d) tooltip component: dark bubble + directional pointer must exist (directive B),
#     and the rail must SPEAK through it (data-tip hooks present).
if grep -q 'data-tip=' design/index.html && \
   grep -q -- '--tip-bg' design/styles/tokens.css && \
   grep -q 'rotate(45deg)' design/styles/shell.css; then
  ok "tooltip system present (data-tip hooks + tokens + pointer)"
else
  bad "tooltip system missing (directive B: dark bubble, pointer, 12px pad, 13px text)"
fi
# (e) selection visibility: pass-3's active pill was white-on-white in light theme
#     (the owner saw it as broken). The tint family is the fix; it must stay wired.
if grep -q -- '--tint-selected' design/styles/tokens.css && \
   grep -q 'var(--tint-selected)' design/styles/shell.css; then
  ok "selection tint wired (visible in both themes)"
else
  bad "selection tint missing — light-theme active state was invisible (INT-008 failure class)"
fi
# (f) content reaction bound: the breath is 2–4px translate (directive D); a larger
#     lean means the old push is creeping back.
breath=$(grep -o 'translateX([0-9]\+px) scale' design/styles/shell.css | grep -o '[0-9]\+' | head -1)
if [ -n "$breath" ] && [ "$breath" -le 4 ]; then
  ok "content breath within 2–4px parallax band (${breath}px)"
else
  bad "content breath is ${breath:-unset}px — outside the directive's 2–4px band (INT-009 D)"
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
