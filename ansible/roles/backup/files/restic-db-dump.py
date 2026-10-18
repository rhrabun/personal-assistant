#!/usr/bin/env python3
"""Write consistent SQLite copies for restic to pick up.

A file-level backup copies live databases torn: restic reads bytes off disk
with no transaction, and in WAL mode committed data spans the .db and the
-wal, so a snapshot can capture a pair that does not replay. restic therefore
excludes *.db, *.db-wal and *.db-shm, and backs up the dumps this writes
instead.

Usage: restic-db-dump.py <data-root> <out-dir>
"""

import os
import sqlite3
import sys

SKIP_DIRS = {
    ".cache",
    ".config",
    ".cua-driver",
    ".dbsnap",
    ".local",
    ".npm",
    ".pki",
    "bin",
    "cache",
    "code",
    "installs",
    "lazy-packages",
    "logs",
    "lsp",
    "node_modules",
    "tools",
}


def dump(src, dst):
    """VACUUM INTO dst, which folds the WAL in and writes one consistent file."""
    con = sqlite3.connect(f"file:{src}?mode=ro", uri=True, timeout=30)
    try:
        con.execute("VACUUM INTO ?", (dst,))
    finally:
        con.close()


def main(argv):
    if len(argv) != 3:
        print("usage: restic-db-dump.py <data-root> <out-dir>", file=sys.stderr)
        return 2

    root, out = os.path.abspath(argv[1]), os.path.abspath(argv[2])
    if not os.path.isdir(root):
        print(f"error: no such data root: {root}", file=sys.stderr)
        return 2

    failed = 0
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in sorted(filenames):
            if not name.endswith(".db"):
                continue

            src = os.path.join(dirpath, name)
            rel = os.path.relpath(src, root)
            # .sqlite, not .db: restic excludes *.db and would skip the dump
            dst = os.path.join(out, os.path.splitext(rel)[0] + ".sqlite")
            os.makedirs(os.path.dirname(dst), exist_ok=True)

            try:
                dump(src, dst)
            except Exception as exc:  # one unreadable db must not stop the rest
                failed += 1
                print(f"warn: could not dump {rel}: {exc}", file=sys.stderr)
                if os.path.exists(dst):
                    os.remove(dst)
            else:
                print(f"dumped {rel}")

    if failed:
        print(f"warn: {failed} database(s) not dumped, absent from this snapshot",
              file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
