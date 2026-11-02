#ifndef FRANC_GFX_H
#define FRANC_GFX_H
#include <stdint.h>
#define FRANC_FB_WIDTH 320
#define FRANC_FB_HEIGHT 200
void gfx_init(void);
void gfx_clear(uint8_t color);
void gfx_pixel(int x, int y, uint8_t color);
uint8_t gfx_get(int x, int y);
void gfx_line(int x0, int y0, int x1, int y1, uint8_t color);
void gfx_fillrect(int x, int y, int width, int height, uint8_t color);
void gfx_palette(uint8_t index, uint8_t r, uint8_t g, uint8_t b);
void gfx_glyph(uint8_t letter, int x, int y, uint8_t fg, uint8_t bg);
void gfx_scroll_up(int height, uint8_t bg);
#ifndef FRANC_BARE_METAL
int gfx_save_ppm(const char *path);
#endif
#endif
