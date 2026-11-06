# Native integration fixes and validation

Changes are based on main `bca0500f83701b747d11c1acd5ba7025cd04cacd`.
Native behavior uses the existing Franc/assembly architecture. The hosted
interpreter retains its existing C implementation and now exposes checked
save status to the shared Notes source. No project dependencies were added.

## Corrected paths

- PS/2 Esc and Ctrl decoding, matching the serial control-character contract.
- Shared app text/number output through the existing Franc console in BIOS
  and UEFI; numeric capture uses the existing IDE page's spare final KiB.
- Native pixel, clear and VGA DAC palette operations reach the GOP viewport,
  retaining VGA pixel readback. The viewport is bounds checked at 2x scale.
- Native JIT string push sets denominator 1 explicitly; drawing may freely
  change caller-saved RSI without corrupting the following string literal.
- Native line raster chooses the larger axis span, including horizontal and
  vertical lines; crosshair now renders full lines rather than two dots.
- Graphics launch entries wait for a key before Home clears the frame.
- Calculator history always terminates a recalled shorter expression.
- Checked native load/launch refuse missing, malformed and main-less source.
- Notes reports failed saves and retains its edit buffer for recovery.
- App loading announces its synchronous work before compiling libraries.
- GNU Make manifest parsing retains application and seed prerequisites.
- Canonical UEFI build, explicit acceptance image paths and an additional CI
  canonical-build gate coexist with the consistent historical build path.
- `tools/run_francos.sh` launches canonical BIOS or UEFI artifacts with the
  required disks and displays the keyboard interaction contract.

## Reproductions and checks

Existing host tests cover the shared app sources, keyboard decoder and
math/compiler behavior. Added regressions cover short history, checked
launches, full-directory Notes failure and native line midpoints/endpoints.

`tests/qemu_native_integration.py IMAGE [ESP CODE VARS]` runs real PS/2
selection, Notes save/reopen/Esc, calculator Up history, a persistent crosshair
frame and physical Ctrl-R IDE build/run in each firmware mode. Frame checks
inspect actual QEMU PPM pixels, including the crosshair center in the active
framebuffer; screenshots remain under `build/out/integration-captures`.

The focused BIOS and UEFI journeys pass with reviewed real crosshair/IDE
frames. The existing BIOS Home/files/Packages/cold-reboot acceptance also
passes, as does the existing UEFI Home/focus/Packages/IDE acceptance.

`tests/qemu_native_failures.py IMAGE` verifies failed launches and full-directory
Notes failure in a disposable native guest, including retention of edited text.

The updated seed was emitted by the existing Franc guest compiler, then
compared with a second guest generation. The independent historical compiler
route also regenerated the same assembly seed. After the runtime string ABI
fix, final native generation 2/3 kernels match the rebuilt kernel exactly:

    b3a7e6b1c733f2cc148c1294c159fc15652ed7406ee32a9a61b2a3c9d38864ea

Franctxt preflight, image identity verification and architecture alias checks
pass. App/image metadata is generated from the working tree; the recorded Git
revision identifies the base checkout while changes are uncommitted.

The existing seven-stage V1 persistent-disk journey passes, including
package update/rollback/uninstall, isolated native execution/fault containment,
interrupted-upgrade recovery, DNS failure UI and independently inspected
real e1000/UDP/DNS packets. Captures are under `build/out/full-journey`.

## Host execution limitation

The full hosted test aggregate intermittently exits with SIGSEGV under this
Apple Silicon Linux x86-64 emulation setup. A comparison run also reproduced
a SIGSEGV using the unmodified base interpreter (`if0` in Stage 2), so a clean
aggregate result is not claimed. Focused shared-source regressions passed,
and subsequent individual math/compiler/graphics/persistence suites passed.
This intermittent hosted failure is separate from the native guest acceptance
results and remains an open issue for investigation in an x86-64 Linux host.

## Familiar app flows

Notes now opens to a saved-note list, with New note selected first. Native
acceptance in BIOS and UEFI passed creation of two named notes, read/edit
views, duplicate-name prevention, discard confirmation and cold reopening.
Demo/Math retain labelled results; Math consumes its results and restores
precision. Calculator Up/Down history preserves the typed draft. The IDE
opens to a labelled command screen with the active file and a runnable example.

The updated registry/source seed was emitted by the native guest and reproduced
by the following generation. Current kernel identity:

    2d117eb92ded273f5c50eb694db396dd1ffb3dca312b50c36dceccc5d2611ba4

`tests/test_launcher_persistence.py` passed code refresh/user-slot retention,
fresh system metadata, session locking and refusal to replace a truncated disk.
Interactive launch now uses `~/.local/share/francos/disk.img` by default.
QOL framebuffer evidence is under `build/out/qol-captures`; the visible driven
walkthrough is captured separately under `build/out/final-visual-review`.

## IDE output and navigation

Ctrl-R captures build/run output below the source and retains the editing
cursor. Ctrl-T opens a one-command Franc prompt and Ctrl-L clears output.
Capture uses 639 bytes plus a terminator within the existing 4KiB IDE page;
numeric formatting bypasses its nested capture while the outer capture runs.
Notes retains its full-height editor. Runs are synchronous trusted execution.

Esc now redraws the IDE command menu, and another Esc returns Home. Previously
that menu recognized only Q, leaving Escape ineffective after leaving editing.
`tests/qemu_ide_output.py IMAGE [ESP CODE VARS]` checks source/cursor retention,
shell arithmetic, editing and rerunning, compile failure without stale execution,
bounded long output and both Escape transitions. Its framebuffer captures and
serial evidence are stored in `build/out/ide-output-captures`.
The complete journey passed in both BIOS and UEFI/GOP. The UEFI Notes/app
journey also passed after these changes. A separate visible UEFI preview was
reviewed with source and run output together, without touching the user's disk.
