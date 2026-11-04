"""Self-contained framebuffer parser/validation regression suite."""
import sys
import unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from tools.qemu_visual import parse_ppm,assert_nonblank,assert_accent_rail,assert_content_area


class QemuVisual(unittest.TestCase):
    def frame(self):
        w,h=320,200
        pixels=bytearray(w*h*3)
        # Independently address the real 320x200 accent-rail sample.
        index=(100*w+318)*3
        pixels[index:index+3]=bytes((18,190,240))
        for y in range(40,120,4):
            for x in range(32,120,4):
                pos=(y*w+x)*3
                pixels[pos:pos+3]=bytes((240,240,240))
        return b"P6\n320 200\n255\n"+bytes(pixels)

    def test_rgb_ppm_and_accent(self):
        w,h,p=parse_ppm(self.frame())
        self.assertEqual((w,h),(320,200))
        assert_nonblank(p,w,h,"test")
        assert_accent_rail(p,w,h,"test")
        assert_content_area(p,w,h,"test",32,32,128,128,threshold=25)

    def test_rejects_invalid_or_truncated(self):
        for payload in (b"not ppm",b"P6\n320 200\n255\n",b"P6\n0 200\n255\n"):
            with self.subTest(payload=payload[:20]):
                with self.assertRaises(AssertionError):parse_ppm(payload)

    def test_rejects_firmware_corner_false_positive(self):
        w,h=800,600
        pixels=bytearray(w*h*3)
        pixels[:10]=b"\x0f"*10
        with self.assertRaises(AssertionError):
            assert_content_area(bytes(pixels),w,h,"uefi",32,32,600,300,threshold=50)


if __name__=="__main__":
    unittest.main()
