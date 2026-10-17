#!/usr/bin/env python3
"""daemon_nocache.py — run the no-store preview server as a TRUE daemon.

Session-8 finding: setsid/nohup variants were reaped at the tool-call
boundary — only a real double-fork daemon survives. This script:

  1. forks (parent exits immediately — the tool call returns)
  2. child forks again (re-parented to init, own session, no tty)
  3. detached grandchild execs serve_nocache.py on the given port

Usage:  python3 scripts/daemon_nocache.py [port]    # default 3000
Kill:   pkill -f serve_nocache.py
"""
import os
import sys

PORT = str(int(sys.argv[1]) if len(sys.argv) > 1 else 3000)
HERE = os.path.dirname(os.path.abspath(__file__))
TARGET = os.path.join(HERE, "serve_nocache.py")
LOG = os.path.join(HERE, "daemon.log")


def main() -> None:
    # fork #1 — parent returns to the caller
    pid = os.fork()
    if pid > 0:
        print(f"daemon started (parent pid {pid} exited) -> port {PORT}")
        return
    os.setsid()

    # fork #2 — fully detached
    pid = os.fork()
    if pid > 0:
        os._exit(0)

    # redirect stdio to a log file, then exec the server
    sys.stdout.flush()
    sys.stderr.flush()
    fd = os.open(LOG, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o644)
    os.dup2(fd, 1)
    os.dup2(fd, 2)
    os.close(fd)

    os.execvp(sys.executable, [sys.executable, TARGET, PORT])


if __name__ == "__main__":
    main()
