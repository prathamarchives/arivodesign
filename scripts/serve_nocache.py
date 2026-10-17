#!/usr/bin/env python3
"""serve_nocache.py — the arivodesign preview server (INT-008 failure class: closed).

The plain http.server sent no cache headers; the owner's browser served stale
CSS and "nothing landed". This server ALWAYS sends:

    Cache-Control: no-store, must-revalidate

Serves design/ from the repo root. Usage:

    python3 scripts/serve_nocache.py [port]   # default 3000
"""
import http.server
import os
import sys
import socketserver

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "design")


class NoStoreHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        super().end_headers()

    def log_message(self, fmt, *args):
        sys.stderr.write("[preview] %s\n" % (fmt % args))


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


if __name__ == "__main__":
    with Server(("", PORT), NoStoreHandler) as httpd:
        print(f"arivo preview (no-store) -> http://localhost:{PORT}/  (design/index.html)")
        sys.stdout.flush()
        httpd.serve_forever()
