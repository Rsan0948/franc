"""Shared real-QEMU framebuffer validation, independent of guest firmware.

The host only decodes PPM evidence captured by QEMU. It does not render or
replace the native FrancOS display.
"""
import re


def parse_ppm(raw: bytes) -> tuple[int, int, bytes]:
    match = re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s", raw)
    if not match:
        raise AssertionError("Invalid QEMU RGB PPM header")
    width,height=map(int,match.groups())
    if width<1 or height<1 or width>8192 or height>8192:
        raise AssertionError(("Invalid QEMU screenshot dimensions",width,height))
    pixels=raw[match.end():]
    if len(pixels)!=width*height*3:
        raise AssertionError(("Truncated QEMU RGB screenshot",width,height,len(pixels)))
    return width,height,pixels


def assert_nonblank(pixels: bytes, width: int, height: int, label: str) -> None:
    if len(pixels)!=width*height*3:
        raise AssertionError(("Invalid pixel length",label))
    step=max(3,(len(pixels)//1100)//3*3)
    if len({pixels[i:i+3] for i in range(0,len(pixels),step)})<2:
        raise AssertionError(("Uniform or blank QEMU frame",label))


def assert_accent_rail(pixels: bytes, width: int, height: int, label: str) -> None:
    """The native BIOS FrancUI adapter must draw its actual cyan accent."""
    assert width in (320,640) and height==width*200//320,(width,height)
    scale=width//320
    x,y=318*scale,100*scale
    index=(y*width+x)*3
    r,g,b=pixels[index:index+3]
    assert g>r+70 and b>r+90, (
        f"{label}: guest accent missing at {x},{y}; RGB={(r,g,b)}")
    print(f"PASS: real guest FrancUI colored rail ({label}), RGB={(r,g,b)}",flush=True)


def assert_content_area(pixels: bytes, width: int, height: int, label: str,
                        left: int, top: int, right: int, bottom: int,
                        threshold: int=40) -> None:
    """Reject nonblank firmware corners while the intended OS area is black."""
    assert 0<=left<right<=width and 0<=top<bottom<=height
    hits=0
    for y in range(top,bottom,4):
        for x in range(left,right,4):
            pos=(y*width+x)*3
            if any(pixels[pos:pos+3]): hits+=1
    if hits<threshold:
        raise AssertionError((f"{label}: intended content region blank",hits))
