# Open-source launch checklist

Franc and FrancOS were built entirely by AI, with Rubén Sánchez providing
design direction and taste oversight. Public-facing material should make
that authorship clear and describe the capabilities readers can try.

The maintainer authorized the open-source launch on November 3, 2026.
The release workflow builds and validates artifacts; the repository owner
controls public visibility through GitHub's repository settings.

## Prepare the public repository

- [ ] Review the README, app guide, and build instructions against current behavior.
- [ ] Confirm the MIT license, upstream font attribution, and code provenance.
- [ ] Review full Git history, artifacts, logs, and screenshots for credentials
      and private data, including author identity details.
- [ ] Run the required GitHub Actions suites on the proposed release commit.
- [ ] Capture guest screens and verify their source runs and image hashes.
- [ ] Review the security policy and private vulnerability-reporting path.
- [ ] Confirm that the release tag identifies the exact passing commit.
- [ ] Have an authorized repository owner change visibility to public.
- [ ] Verify anonymous access to the README, images, source, and downloads.

## Build and release evidence

The [v1.1 release workflow](../.github/workflows/francos-v1-1-release.yml)
checks source identity, history, native self-hosting, the integrated QEMU
journey, UEFI graphics, and networking before publishing from `main`.
Published tags preserve their original tested commits; new features receive
new release identities.

`python3 tools/release_audit.py` scans tracked files for known credential
patterns, environment/key files, and required project documentation. Combine
its output with the history, privacy, and provenance review above.

The guest drivers capture Home, Files, IDE, Packages, and app journeys.
Review both runtime behavior and the resulting screens. The
[screenshot gallery](screenshots/README.md) records capture sources and hashes;
the [release-media draft](RELEASE_MEDIA.md) provides announcement material.
Pin release images and download links to the tested tag when publishing.

## Launch preparation record

- [x] Merge the post-v1 FrancUI, GOP, and open-source documentation changes.
- [x] Commit six QEMU screenshots with SHA-256 verification and a README gallery.
- [x] Preserve the `francos-v1.0-experimental` release tag.

Release completion, full-history review, and public visibility are verified
at publication using the checklist above.
