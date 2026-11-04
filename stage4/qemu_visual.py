"""Shared QEMU framebuffer assertions for FrancUI development.

The virtual machine produces PPM pixels through QEMU's HMP screendump;
none of these colors or screenshots are composited on the host.
"""
def assert_accent_rail(pixels: bytes, width: int, height: int, label: str) -> None:
    """A VGA palette adapter must actually color the right-side screen rail."""
    assert width in (320, 640) and height == width * 200 // 320, (width, height)
    scale = width // 320
    # Pixel index 1 uses VGA DAC 6-bit (6,45,54), visibly cyan.
    x, y = 318 * scale, 100 * scale
    offset = (y * width + x) * 3
    red, green, blue = pixels[offset:offset + 3]
    assert green > red + 70 and blue > red + 90, (
        f"{label}: FrancUI accent missing at framebuffer ({x},{y}): "
        f"rgb={(red,green,blue)}")
    print(f"PASS: real guest FrancUI colored rail ({label}) rgb={(red,green,blue)}", flush=True)
