#!/usr/bin/env python3
"""Expose the exact Franc compiler source as a readable C string; no compiler logic is C."""
from pathlib import Path
import json
here=Path(__file__).resolve().parent
src=(here/'compiler.frac').read_text()
rows=['/* Generated from compiler.frac; never edit. */','static const char franc_stage2_self_source[] =']
rows += ['  '+json.dumps(line,ensure_ascii=True) for line in src.splitlines(keepends=True)]
rows+=['  "";', '']
shell=(here.parent/'stage3'/'shell.frac').read_text()
rows += ['/* Stage 3 shell source, recompilable by the Franc-authored compiler. */',
         'static const char franc_stage3_shell_source[] =']
rows += ['  '+json.dumps(line,ensure_ascii=True) for line in shell.splitlines(keepends=True)]
rows += ['  "";', '']
(here/'compiler_source.h').write_text('\n'.join(rows))
