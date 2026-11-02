/* Shared Mode 13h pixel backend: bare-metal VGA or hosted 320x200 emulation. */
#include "gfx.h"
#include "font8x8.h"
#ifdef FRANC_BARE_METAL
#define FRAMEBUFFER ((volatile uint8_t *)0xa0000)
static inline void dac_out(uint16_t port, uint8_t value) {
    __asm__ volatile("outb %0,%1" :: "a"(value), "Nd"(port));
}
#else
#include <stdio.h>
static uint8_t hosted_fb[FRANC_FB_WIDTH * FRANC_FB_HEIGHT];
#define FRAMEBUFFER hosted_fb
#endif
static uint8_t rgb[256][3];

void gfx_palette(uint8_t index, uint8_t r, uint8_t g, uint8_t b) {
    r &= 63; g &= 63; b &= 63;
    rgb[index][0] = r; rgb[index][1] = g; rgb[index][2] = b;
#ifdef FRANC_BARE_METAL
    dac_out(0x3c8, index);
    dac_out(0x3c9, r); dac_out(0x3c9, g); dac_out(0x3c9, b);
#endif
}
void gfx_init(void) {
    static const uint8_t ansi[16][3] = {
        {0,0,0},{42,0,0},{0,42,0},{42,21,0},{0,0,42},{42,0,42},{0,42,42},{42,42,42},
        {21,21,21},{63,21,21},{21,63,21},{63,63,21},{21,21,63},{63,21,63},{21,63,63},{63,63,63}
    };
    for (int i=0; i<16; i++) gfx_palette((uint8_t)i, ansi[i][0],ansi[i][1],ansi[i][2]);
    for (int i=16; i<232; i++) {
        int n=i-16;
        gfx_palette((uint8_t)i,(uint8_t)((n/36)%6*12),
                                 (uint8_t)((n/6)%6*12),(uint8_t)((n%6)*12));
    }
    for (int i=232; i<256; i++) {
        uint8_t level=(uint8_t)((i-232)*63/23);
        gfx_palette((uint8_t)i,level,level,level);
    }
    gfx_clear(0);
}
void gfx_pixel(int x,int y,uint8_t color) {
    if ((unsigned)x<FRANC_FB_WIDTH && (unsigned)y<FRANC_FB_HEIGHT)
        FRAMEBUFFER[y*FRANC_FB_WIDTH+x]=color;
}
uint8_t gfx_get(int x,int y) {
    return (unsigned)x<FRANC_FB_WIDTH && (unsigned)y<FRANC_FB_HEIGHT ?
           FRAMEBUFFER[y*FRANC_FB_WIDTH+x] : 0;
}
void gfx_clear(uint8_t color) {
    for (int i=0;i<FRANC_FB_WIDTH*FRANC_FB_HEIGHT;i++) FRAMEBUFFER[i]=color;
}
void gfx_fillrect(int x,int y,int w,int h,uint8_t color) {
    if (w<=0 || h<=0) return;
    /* Use 64-bit for endpoint math, including extreme Frac integer inputs. */
    int64_t ex=(int64_t)x+w, ey=(int64_t)y+h;
    if (ex<=0 || ey<=0 || x>=FRANC_FB_WIDTH || y>=FRANC_FB_HEIGHT) return;
    int left=x<0?0:x, top=y<0?0:y;
    int right=ex>FRANC_FB_WIDTH?FRANC_FB_WIDTH:(int)ex;
    int bottom=ey>FRANC_FB_HEIGHT?FRANC_FB_HEIGHT:(int)ey;
    for(int yy=top;yy<bottom;yy++)for(int xx=left;xx<right;xx++)
        FRAMEBUFFER[yy*FRANC_FB_WIDTH+xx]=color;
}
void gfx_line(int x0,int y0,int x1,int y1,uint8_t color) {
    /* Avoid billion-iteration line loops with a rational parametric clipper. */
    int64_t dx=(int64_t)x1-x0,dy=(int64_t)y1-y0;
    if ((dx > 1000000 || dx < -1000000 || dy > 1000000 || dy < -1000000)) return;
    int64_t adx=dx<0?-dx:dx,ady=dy<0?-dy:dy;
    int64_t steps=adx>ady?adx:ady;
    if(!steps){gfx_pixel(x0,y0,color);return;}
    for (int64_t i=0;i<=steps;i++) {
        int x=(int)((int64_t)x0+dx*i/steps);
        int y=(int)((int64_t)y0+dy*i/steps);
        gfx_pixel(x,y,color);
    }
}
void gfx_glyph(uint8_t ch,int x,int y,uint8_t fg,uint8_t bg) {
    if(ch>127)ch='?';
    for(int yy=0;yy<8;yy++) {
        uint8_t bits=franc_font8x8[ch][yy];
        for(int xx=0;xx<8;xx++)
            gfx_pixel(x+xx,y+yy,(bits & (1u<<xx))?fg:bg);
    }
}
void gfx_scroll_up(int rows,uint8_t bg) {
    if (rows<=0) return;
    if(rows>=FRANC_FB_HEIGHT){gfx_clear(bg);return;}
    for (int i=0;i<FRANC_FB_WIDTH*(FRANC_FB_HEIGHT-rows);i++)
        FRAMEBUFFER[i]=FRAMEBUFFER[i+FRANC_FB_WIDTH*rows];
    gfx_fillrect(0,FRANC_FB_HEIGHT-rows,FRANC_FB_WIDTH,rows,bg);
}
#ifndef FRANC_BARE_METAL
int gfx_save_ppm(const char *path) {
    FILE* f=fopen(path,"wb");if(!f)return 0;
    if (fprintf(f,"P6\n%d %d\n255\n",FRANC_FB_WIDTH,FRANC_FB_HEIGHT)<0) {fclose(f);return 0;}
    for (int i=0;i<FRANC_FB_WIDTH*FRANC_FB_HEIGHT;i++) {
        uint8_t* col=rgb[FRAMEBUFFER[i]];
        uint8_t triplet[3]={(uint8_t)(col[0]*255/63),(uint8_t)(col[1]*255/63),(uint8_t)(col[2]*255/63)};
        if(fwrite(triplet,1,3,f)!=3){fclose(f);return 0;}
    }
    return fclose(f)==0;
}
#endif
