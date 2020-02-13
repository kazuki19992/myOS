#ファイル生成規則
default:
	make img

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o : nasmfunc.asm Makefile          # nasmfunc.asmのバイナリファイル作成
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o

bootpack.hrb : bootpack.c har.ld nasmfunc.o Makefile       # コンパイル/リンク
	gcc -march=i486 -m32 -fno-pic -nostdlib -T har.ld -g bootpack.c nasmfunc.o -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

asm :
	make -r ipl10.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img  # "-fda" for floppy disk

debug:
	make img
	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

clean :
	rm *.lst *.bin *.sys *.img *.hrb *.o

# all : haribote.img

# ipl10.bin : ipl10.nas
# 	nasm ipl10.nas -o ipl10.bin

# asmhead.bin : asmhead.nas
# 	nasm asmhead.nas -o asmhead.bin

# bootpack.hrb : bootpack.c
# 	gcc -march=i486 -m32 -nostdlib -T hrb.ld -o bootpack.hrb bootpack.c

# haribote.sys : asmhead.bin bootpack.hrb
# 	cat asmhead.bin bootpack.hrb > haribote.sys

# haribote.img : ipl10.bin haribote.sys
# 	cp ipl10.bin haribote.img
# 	./add_file.sh haribote.img haribote.sys

# clean:
# 	rm -f haribote.img haribote.sys bootpack.hrb asmhead.bin ipl10.bin

# run: haribote.img
# 	qemu-system-i386 -fda haribote.img -boot a