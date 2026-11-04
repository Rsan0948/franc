# Open-source launch checklist

The maintainer explicitly authorized merging and launching the open-source
repository on November 3, 2026. The launch workflow can publish a new GitHub
Release with verified binaries and screenshots while the repository is private.
**Repository visibility is a separate administrative setting and is not
automatically changed by this workflow.**

After the exact-main release gate passes and the history audit is reviewed,
the owner can change visibility from private to public in GitHub's repository
Settings → General → Danger Zone → Change repository visibility. Do not expose
sensitive history or assume publishing a GitHub Release changes visibility.

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

## Screenshot and release-media bundle

- [ ] Confirm six lossless images in [`docs/screenshots/`](screenshots/README.md)
      were imported from the pinned real-QEMU runs and passed SHA-256 checks.
- [ ] Review updated Home, initial GOP, and BIOS IDE/Files/Packages images
      for accurate captions, visual quality and sensitive information.
- [ ] Make the new README gallery visible to first-time visitors.
- [ ] Use [release-media draft](RELEASE_MEDIA.md) **only after** the next
      graphics release tag has passed its full QEMU gate. Pin image links to
      that tag rather than a moving `main`.
- [ ] Attach final PNGs to the future GitHub Release alongside the tested
      binary and source artifacts after the maintainer approves publication.
- [ ] Do not move/rewrite the v1 experimental tag or claim its 320×200
      BIOS build already had the post-v1 1024×768 GOP interface.

## Live-release integration (November 2026)

- [x] Merge the post-v1 FrancUI, GOP and open-source documentation changes
- [x] Commit all six real-QEMU, SHA-256 checked screenshots and README gallery
- [x] Preserve the immutable `francos-v1.0-experimental` tag
- [ ] Run the `francos-v1.1.0-experimental` exact-main release workflow to
      completion and inspect all attached native BIOS/UEFI artifacts
- [ ] Inspect the full-history credential scan and complete human privacy,
      author/identity, and third-party license review
- [ ] Verify the newest released tag points to the exact passing main commit
- [ ] Change GitHub repository visibility to public via an authorized owner or
      repository administrator and verify anonymous access
- [ ] Verify public README images and release downloads are actually accessible

The new launch workflow is
[`.github/workflows/francos-v1-1-release.yml`](../.github/workflows/francos-v1-1-release.yml).
Its publication step executes only for `main` and only after independent
source, history, native kernel, full QEMU journey, UEFI GOP and network tests.
It publishes an experimental **pre-release**, not a stable security-supported
general-use operating system.
