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
