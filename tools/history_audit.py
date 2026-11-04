#!/usr/bin/env python3
"""Conservative non-destructive Git history audit before open-source launch.

Scans *all reachable Git blobs*, not just the current working tree. The tool
does not report secret values. A successful scan is not a complete privacy,
legal, or third-party licensing review.
"""
import re
import subprocess
import sys

PATTERNS = {
    "private-key": re.compile(rb"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"),
    "github-token": re.compile(rb"gh(?:p|o|u|s|r)_[A-Za-z0-9]{30,}"),
    "github-fine-grained-token": re.compile(rb"github_pat_[A-Za-z0-9_]{50,}"),
    "aws-access-key": re.compile(rb"AKIA[0-9A-Z]{16}"),
    "openai-api-key": re.compile(rb"sk-(?:proj-)?[A-Za-z0-9_-]{24,}"),
}
BAD_FILENAMES = re.compile(
    r"(?:^|/)(?:\.env(?:\.[^/]*)?|id_rsa|id_ed25519|\.npmrc|credentials\.json)"
    r"$|\.(?:pem|p12|pfx)$", re.I
)

def git(*args, input=None):
    return subprocess.run(["git", *args], input=input, stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE, check=True).stdout

def main():
    lines = git("rev-list", "--objects", "--all").splitlines()
    filenames = {}
    objects = []
    for line in lines:
        sha, _, path = line.partition(b" ")
        if len(sha) not in (40,64):
            raise ValueError("Unrecognized Git object id")
        objects.append(sha)
        if path:
            name = path.decode("utf-8", "replace")
            filenames.setdefault(sha.decode("ascii"), set()).add(name)
    if not objects:
        print("REVIEW REQUIRED: no history to check", file=sys.stderr)
        return 1
    report = set()
    blobs_checked = 0
    # A single batch avoids a costly Git subprocess per historical object.
    response = git("cat-file", "--batch", input=b"\n".join(objects)+b"\n")
    offset = 0
    for expected in objects:
        nl = response.find(b"\n", offset)
        if nl < 0:
            raise ValueError("Truncated git cat-file response")
        header = response[offset:nl].split()
        if len(header) != 3 or header[0] != expected:
            raise ValueError("Unexpected git cat-file header")
        size = int(header[2])
        data_start = nl + 1
        payload = response[data_start:data_start + size]
        offset = data_start + size + 1
        if len(payload) != size:
            raise ValueError("Truncated git object")
        if header[1] != b"blob":
            continue
        blobs_checked += 1
        for label, pattern in PATTERNS.items():
            if pattern.search(payload):
                report.add((expected.decode("ascii")[:12], label))
        for name in filenames.get(expected.decode("ascii"), ()):
            if BAD_FILENAMES.search(name):
                report.add((expected.decode("ascii")[:12],
                            "sensitive filename: " + name))
    if report:
        for commit, issue in sorted(report):
            print(f"HISTORY REVIEW REQUIRED: blob {commit}: {issue}", file=sys.stderr)
        return 1
    print(f"PASS: {blobs_checked} reachable historical blobs scanned for "
          "known credential patterns and sensitive filenames")
    print("LIMIT: this is not an independent privacy, third-party IP or "
          "security audit; check commit metadata and external references manually.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
