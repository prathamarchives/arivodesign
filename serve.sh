#!/usr/bin/env bash
# ============================================================
# arivo design preview — THE dev server (INT-005)
# Serves the pre-execution visuals (design/) over HTTP.
#
# Usage:   bash serve.sh [port]
# Default: port 3000 — the chat preview gateway proxies 3000,
#          so `bash serve.sh` makes the paint previewable in-chat.
#
# Loop 5 audit note: session 4's server was an ad-hoc shell
# command (lost on session end). Preview is a repo capability,
# not shell history — any agent or the owner can start it.
# ============================================================
set -euo pipefail
cd "$(dirname "$0")/design"
PORT="${1:-3000}"
echo "arivo preview → http://localhost:${PORT}/  (design/index.html)  — ctrl-c to stop"
exec python3 -m http.server "${PORT}"
