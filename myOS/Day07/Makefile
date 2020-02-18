# # #ファイル生成規則

# default:
# 	make img

# #--------------------
# #   hankaku char
# #--------------------
# convHankakuTxt : convHankakuTxt.c
# 	$(CC) $< -o $@

# hankaku.c : hankaku.txt convHankakuTxt Makefile
# 	./convHankakuTxt

# ipl10.bin : ipl10.asm Makefile
# 	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

# asmhead.bin : asmhead.asm Makefile
# 	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

# nasmfunc.o : nasmfunc.asm Makefile          # nasmfunc.asmのバイナリファイル作成
# 	nasm -g -f elf nasmfunc.asm -o nasmfunc.o

# bootpack.hrb : bootpack.c har.ld nasmfunc.o graphic.c dsctbl.c int.c hankaku.c mySprintf.c Makefile       # コンパイル/リンク
# 	gcc -march=i486 -m32 -fno-pic -nostdlib -T har.ld -g bootpack.c graphic.c dsctbl.c int.c mySprintf.c hankaku.c nasmfunc.o -o bootpack.hrb

# haribote.sys : asmhead.bin bootpack.hrb Makefile
# 	cat asmhead.bin bootpack.hrb > haribote.sys

# haribote.img : ipl10.bin haribote.sys Makefile
# 	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
# 	mcopy haribote.sys -i haribote.img ::

# asm :
# 	make -r ipl10.bin

# img :
# 	make -r haribote.img

# run :
# 	make img
# 	qemu-system-i386 -fda haribote.img  # "-fda" for floppy disk

# debug:
# 	make img
# 	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

OBJS_BOOTPACK = bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj \
		int.obj

TOOLPATH = ../../z_tools/
INCPATH  = ../../z_tools/haribote/

MAKE     = $(TOOLPATH)make -r
NASK     = $(TOOLPATH)nask
CC1      = $(TOOLPATH)gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK = $(TOOLPATH)gas2nask -a
OBJ2BIM  = $(TOOLPATH)obj2bim
MAKEFONT = $(TOOLPATH)makefont
BIN2OBJ  = $(TOOLPATH)bin2obj
BIM2HRB  = $(TOOLPATH)bim2hrb
RULEFILE = $(TOOLPATH)haribote/haribote.rul
EDIMG    = $(TOOLPATH)edimg
# IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = cp
DEL      = rm

# デフォルト動作

default :
	$(MAKE) img

# ファイル生成規則

ipl10.bin : ipl10.nas Makefile
	$(NASK) ipl10.nas ipl10.bin ipl10.lst

asmhead.bin : asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

hankaku.bin : hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim : $(OBJS_BOOTPACK) Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		$(OBJS_BOOTPACK)
# 3MB+64KB=3136KB

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	copy /B asmhead.bin+bootpack.hrb haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	$(EDIMG)   imgin:../z_tools/fdimg0at.tek \
		wbinimg src:ipl10.bin len:512 from:0 to:0 \
		copy from:haribote.sys to:@: \
		imgout:haribote.img

# 一般規則

%.gas : %.c bootpack.h Makefile
	$(CC1) -o $*.gas $*.c

%.nas : %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas

%.obj : %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

# コマンド

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	$(COPY) haribote.img ..\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ../z_tools/qemu

# install :
# 	$(MAKE) img
# 	$(IMGTOL) w a: haribote.img

clean :
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.obj
	-$(DEL) bootpack.map
	-$(DEL) bootpack.bim
	-$(DEL) bootpack.hrb
	-$(DEL) haribote.sys

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img
