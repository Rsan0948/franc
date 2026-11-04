#!/usr/bin/env python3
"""Conservative pre-publication source review. Does not make repo public.

Checks tracked text for common credential shapes, unsafe tracked environment
files, required license materials and the canonical release documentation.
This is intentionally NOT proof of a complete Git-history or security audit.
"""
from pathlib import Path
import re
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
REQUIRED=("README.md","LICENSE","FONT-LICENSE.txt","SECURITY.md",
          "CONTRIBUTING.md","docs/FRANCOS_V1_RELEASE_CANDIDATE.md",
          "docs/REPO_ARCHITECTURE.md","docs/OPEN_SOURCE_LAUNCH.md")
PATTERNS={
    "private-key-pem":re.compile(rb"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "aws-access-key":re.compile(rb"AKIA[0-9A-Z]{16}"),
    "github-token":re.compile(rb"gh(?:p|o|u|s|r)_[A-Za-z0-9]{30,}"),
    "openai-token":re.compile(rb"sk-(?:proj-)?[A-Za-z0-9_-]{24,}"),
}
def main():
    errors=[]
    for path in REQUIRED:
        if not (ROOT/path).is_file():errors.append("Required file absent: "+path)
    tracked=subprocess.check_output(["git","ls-files","-z"],cwd=ROOT).split(b"\0")
    for raw in tracked:
        if not raw:continue
        path=raw.decode("utf-8","surrogateescape")
        low=path.lower()
        if low.endswith((".env",".pem",".p12",".key")) or "/.env" in low:
            errors.append("Review potentially sensitive tracked file: "+path)
        file=ROOT/path
        if not file.is_file():continue
        try: data=file.read_bytes()
        except OSError:continue
        if b"\0" in data[:1024]:continue
        for name,pattern in PATTERNS.items():
            if pattern.search(data):
                errors.append(f"Potential {name} in tracked source: {path}")
    # A separate historical review is mandatory; this tool never declares
    # the repository automatically safe for public release.
    if errors:
        for error in errors:print("REVIEW REQUIRED: "+error,file=sys.stderr)
        return 1
    print("PASS: required release docs present; no known token-pattern"
          " or tracked env/private-key filename found in current tree")
    print("NOTE: full history/third-party license/privacy review still required")
    return 0
if __name__=="__main__":
    raise SystemExit(main())
