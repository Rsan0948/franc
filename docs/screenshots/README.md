# FrancOS screenshots

These screenshots capture FrancOS running in QEMU. Each image links to its
full-resolution PNG, with capture sources and hashes recorded below.

Select a picture to open its full-resolution PNG:

## High-resolution UEFI display — post-v1 development

[![Updated FrancOS UEFI Home at 1024x768](home-uefi-1024x768.png)](home-uefi-1024x768.png)

*Updated Home screen, 1024×768, native FrancOS font rendering and workspace.*

[![Initial FrancOS UEFI boot screen at 1024x768](home-uefi-initial-1024x768.png)](home-uefi-initial-1024x768.png)

*Original 1024×768 UEFI display showing the initial startup text. Included
as a before/after development reference.*

## BIOS graphics — 320x200 guest framebuffer (captured as 640x400 by QEMU)

| Home | IDE |
| --- | --- |
| [![BIOS Home](home-bios-640x400.png)](home-bios-640x400.png) | [![BIOS IDE](ide-bios-640x400.png)](ide-bios-640x400.png) |

| Files | Packages |
| --- | --- |
| [![BIOS Files](files-bios-640x400.png)](files-bios-640x400.png) | [![BIOS Packages](packages-bios-640x400.png)](packages-bios-640x400.png) |

**What these show:** the UEFI screenshots show the newer high-resolution
framebuffer work; the BIOS screenshots show the smaller keyboard-driven
application interfaces. Captions identify the display used for each capture.

See [sources and verification](SOURCES.md), and the [FrancUI roadmap](../FRANCUI_DESIGN.md).

The gallery records the UEFI display work from the v1.1 development period.
The earlier `francos-v1.0-experimental` tag preserves its BIOS-era source
and release evidence.
