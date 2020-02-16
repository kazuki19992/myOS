// bootpackメイン

#include<stdio.h>

// カラーパレットで設定した色を定数として宣言する
#define COL8_000000      0
#define COL8_FF0000      1
#define COL8_00FF00      2
#define COL8_FFFF00      3
#define COL8_0000FF      4
#define COL8_FF00FF      5
#define COL8_00FFFF      6
#define COL8_FFFFFF      7
#define COL8_C6C6C6      8
#define COL8_840000      9
#define COL8_008400     10
#define COL8_848400     11
#define COL8_000084     12
#define COL8_840084     13
#define COL8_008484     14
#define COL8_848484     15

extern void io_hlt(void);
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int io_load_eflags(void);
extern void io_store_eflags(int eflags);

// 以下、bootpack.c内関数のプロトタイプ宣言
void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void init_screen(char *vram, int xsize, int ysize);
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
void putfont8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);
void init_mouse_cursor8(char *mouse, char bc);
void putblock8_8 (char *vram, int vxsize, int pxsize,
    int pysize, int px0, int py0, char *buf, int bxsize);

// BOOTINFO構造体
struct BOOTINFO {
    char cyls, leds, vmode, reserve;
    short scrnx, scrny;
    char *vram;
};

struct SEGMENT_DESCRIPTOR {
    /* data */
    short limit_low, base_low;
    char base_mid, access_right;
    char limit_high, base_high;
};

struct GATE_DESCRIPTOR {
    /* data */
    short offset_low, selector;
    char dw_count, access_right;
    short offset_high;
};

void init_gdtidt(void);
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);
void set_gatedesc (struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);
extern void load_gdtr(int limit, int addr);
extern void load_idtr(int limit, int addr);

void HariMain(void) {
    struct BOOTINFO *binfo = (struct BOOTINFO *) 0x0ff0;
    extern char hankaku[4096];
    char s[40], mcursor[256];
    int mx, my;

    init_palette();     // パレットを設定
    init_screen(binfo -> vram, binfo -> scrnx, binfo -> scrny);
    putfont8_asc(binfo -> vram, binfo -> scrnx,  8,  8, COL8_FFFFFF, "ABC 123");
    mx = (binfo -> scrnx - 16) / 2;         // 画面中央になるように座標計算
    my = (binfo -> scrny - 28 - 16) / 2;
    init_mouse_cursor8(mcursor, COL8_008484);
    putblock8_8(binfo -> vram, binfo -> scrnx, 16, 16, mx, my, mcursor, 16);

    sprintf(s, "(%d, %d)", mx, my);
    putfont8_asc(binfo -> vram, binfo -> scrnx, 30, 30, COL8_FFFFFF, s);
    
    // for(;;)ってwhile(1)でよくね？？
    while (1) {
        io_hlt();
    }
}
