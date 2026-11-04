# Open-source launch checklist

This repository remains private during preparation. **Do not change repository
visibility, publish releases or automatically enable public distribution
without the maintainer's explicit approval.**

## Required before public launch

- [ ] Verify `README.md` represents the current experimental v1 state and
      separates active documentation from historical development notes
- [ ] Ensure license, font/third-party attribution and provenance are correct
- [ ] Scan full Git history, workflows, artifacts, test images and docs for
      credentials, tokens, private user data and undisclosed third-party code
- [ ] Make reproducible Linux/QEMU build + test instructions easy to follow
- [ ] Establish an unambiguous authoritative subsystem/source map
- [ ] Supply beginner examples for language, IDE, persistence and packages
- [ ] Check that all expected GitHub Actions suites pass at the proposed tag
- [ ] Capture current real emulator screens, disclose UI/hardware limitations
- [ ] Document threat model, responsible disclosure path and contribution rules
- [ ] Review repository history and stale branches before changing visibility
- [ ] Obtain explicit owner approval to make the repository public

## Version discipline

Never mutate `francos-v1.0-experimental`. New FrancUI work is post-v1
development and must receive its own immutable tested commit/tag. Keep package
hash checking separate from publisher-authenticated signing claims.

## Evidence and review

The `stage4/qemu_home.py` guest driver captures Home, Files, IDE and Packages
screens. FrancUI phase 1 additionally checks that rendered accent pixels are
visible in real QEMU screenshots. Visual design approval is distinct from
compile and runtime correctness; both must be reviewed.

## Automated checks now available

`python3 tools/release_audit.py` checks the tracked working tree for known
credential patterns, accidentally committed environment/key files and the
required project/license documentation. The normal hosted test workflow
also runs it. These checks are intentionally conservative and **do not**
constitute a full audit of Git history, author privacy, third-party
provenance, package security or future release artifacts.

The historical README is retained in
`docs/HISTORY_FROM_README_2026.md`; the root README now prioritizes the
current experimental release, verified user tasks and first-time QEMU use.
An authoritative source map and first migrated QEMU visual test helper are
documented in `docs/REPO_ARCHITECTURE.md`.

Human review and explicit owner approval are still required before changing
repository visibility. No automation in this branch makes the repository
public or moves the frozen v1 tag.
