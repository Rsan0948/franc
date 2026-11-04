# FrancUI — graphical experience development

## Current status

The v1 experimental release remains frozen. Phase 1 is an incremental Franc-native
visual layer, loaded from the ordered disk app bundle (`lib/ui.frac`). It keeps the
original BIOS VGA 320x200 display and serial fallback while adding a consistent
color palette, accent rail, header/footer chrome and a shared IDE editing separator.

The JIT-loaded UI calls Franc-native `palette` and `fillrect` hardware primitives,
not a Python-rendered screenshot or an external HTML interface. The Packages screen
calls `ui-frame`; the IDE calls `ui-chrome` and `ui-editor-rule`. The original Home
screen remains kernel-linked and is not yet themed.

`stage4/qemu_home.py` captures the guest through QEMU HMP and asserts that the
IDE and Packages screenshot rail pixels are actually cyan, not merely nonblank.
All guest interactions and native applications remain operational.

## Design direction: one FrancUI API, multiple display backends

Applications should request a surface, text, focus, button, list and status.
The future renderer draws primitives into a bounded framebuffer independent of
the startup firmware, with a serial text fallback. No separate FrancLite-style
UI translator is required for the foundation; a declarative adapter can be added
later as a frontend to the same FrancUI primitives.

Planned phases (not yet implemented):
1. **Display adapters:** BIOS VBE linear framebuffer with mode discovery,
   validation and correct pixel pitch/format; UEFI GOP mode handoff, with valid
   memory-map ownership. Keep legacy VGA/serial as fallback.
2. **Renderer:** configurable resolution, font/glyph color and background,
   clipping, dirty rectangles, dimensions, text wrapping and keyboard focus.
3. **Widgets:** panels, lists, navigation, menus, dialogs, editor text viewport.
4. **Integration:** kernel Home, calculator, IDE, Files, Packages and demos use
   common primitives, without changing privilege or source trust boundaries.
5. **Testing:** deterministic keyboard journeys, readable framebuffer image
   captures, expected pixel/layout assertions and cold-reboot regression.

Do not advertise VBE/GOP, window management, mouse input or general hardware
support until the corresponding real-QEMU execution and capture tests pass.

## Constraints

- Do not change pinned AOT kernel source or `stage4/bootstrap_seed.S` and
  `franctxt/seed.lock.franctxt` independently. Kernel/display-ABI changes must
  regenerate and verify the seed and lock in the same acceptance cycle.
- Existing 40x25 text draws opaque 8x8 glyph cells; UI chrome stays outside
  the glyph region until the renderer can handle transparent text correctly.
- Maintain exact application source ordering, reserved RAM regions, pixel
  coordinate bounds, serial diagnostics and persistent release reproducibility.
- Preserve actual QEMU VGA captures and guest test logs in CI artifacts.
