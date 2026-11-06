# FrancUI design and development

## Current experience

FrancUI gives the keyboard-driven apps a shared palette, accent rail,
headers, status messages, and editor separators. Home launches the calculator,
Notes, mathematical tools, graphics demos, and IDE. Applications share keyboard navigation and visible file, selection, and
status information.

The shared Franc layer in `lib/ui.frac` uses native palette and drawing
primitives. BIOS renders to the 320×200 VGA framebuffer; UEFI supplies a
higher-resolution GOP workspace with scaled glyphs, a navy/cyan frame,
and a sidebar. Text and app behavior come from Franc, with assembly handling
the GOP framebuffer backend. Serial output supports headless interaction.

Design changes are reviewed in the running guest: inspect the screen, use
the apps, and refine the experience from what people actually see.

## Interaction principles

- Make the current app, file, selection, and next action visible.
- Use familiar keyboard navigation and consistent save/back actions.
- Make the entry screen explain the app and the available actions.
- Keep results on screen long enough to read them.
- Preserve user text and show a recovery action when an operation fails.
- Verify changes through keyboard journeys and framebuffer captures.

## Display implementation

The UEFI adapter selects a validated 800×600 or 1024×768 32-bit linear
framebuffer. It allocates a temporary descriptor through Boot Services,
passes its pointer in `r15` and a marker in `r14`, then enters the kernel.
After clearing BSS, the kernel copies that descriptor into its own storage.
The assembly backend uses the copied address, dimensions, pitch, and pixel
format to render glyphs and graphics.

The Home selection arrow drives the GOP focus bar, keeping the displayed
selection tied to Franc's menu state. The app renderer also retains its
VGA backing store for pixel readback and the BIOS display path.

QEMU checks glyph pixels, selection colors, app output, and image dimensions.
The app suites also cover editing, save/reopen, and return navigation. Capture
sources are recorded in the [screenshot gallery](screenshots/README.md).

## Next design work

Build on the existing shared primitives with resolution-aware layouts,
consistent clipping and wrapping, incremental redraws, and reusable lists,
menus, and dialogs. These changes should help Home, IDE, Files, Packages,
and the smaller apps make better use of the available display area.

Each increment should preserve ordered source manifests, reserved memory,
serial diagnostics, persistent files, and reproducible builds. Kernel or
display-ABI changes regenerate the native seed and Franctxt lock together.
See the [build guide](BUILD_AND_TEST.md) for the corresponding checks.
