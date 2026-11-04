# Screenshot provenance and integrity

These PNGs are **lossless conversions of real QEMU screendump PPMs**
captured during GitHub Actions acceptance tests. The import script
[`tools/import_guest_screenshots.py`](../../tools/import_guest_screenshots.py)
requires exact source PPM SHA-256 digests before conversion and records
the resulting PNG hashes in [SHA256SUMS](SHA256SUMS).

| Screenshot | Original GitHub Actions run | Original PPM SHA-256 |
| --- | --- | --- |
| [Updated UEFI Home, 1024×768](home-uefi-1024x768.png) | [UEFI GOP run 41754798736](https://github.com/Rsan0948/franc/actions/runs/41754798736) | `dc55260d9a80ac50ede046b3595b4042548bc3ac4732e1033d7c57e0b44fbbe5` |
| [Initial UEFI Home, 1024×768](home-uefi-initial-1024x768.png) | [UEFI GOP run 41752456833](https://github.com/Rsan0948/franc/actions/runs/41752456833) | `fc2e9681bbe74578abe2a2f4266d9e882cbceee0b132a1c647dc0f428e898f25` |
| [BIOS Home, captured 640×400](home-bios-640x400.png) | [Wave 4 UI run 41747370509](https://github.com/Rsan0948/franc/actions/runs/41747370509) | `3f26bdc5adcc613fa36b7516427bb4959ebfd27a73fd003c85065c3ae2c2801a` |
| [BIOS IDE, captured 640×400](ide-bios-640x400.png) | Same Wave 4 UI run | `41f3caa1aa957df68e49840a30f1692d4301fc65ad3fcda685b867162b857e93` |
| [BIOS Files, captured 640×400](files-bios-640x400.png) | Same Wave 4 UI run | `34ab955d6e7684e94b9ed0330a26a3acf79b5b4518e87cc672f68794b1c085f1` |
| [BIOS Packages, captured 640×400](packages-bios-640x400.png) | Same Wave 4 UI run | `61a0e0fb0b02a5b00c3e23159c7b03b917f814d065ceb8d928a1aee8b177c4f4` |

**Scope:** These are QEMU/OVMF screenshots. A 640×400 QEMU screenshot
represents a 320×200 BIOS VGA guest framebuffer upscaled by QEMU. The UEFI
screen is a distinct post-v1 development path. All six sources are explicitly
identified so future contributors can distinguish historical vs new UI.

**Verification:** From the repository root,
`(cd docs/screenshots && sha256sum -c SHA256SUMS)`.

**Publication:** The assets may be shipped with the next approved
open-source release. Committing them does **not** publish a GitHub Release,
change repository visibility, or modify the frozen v1 tag.
