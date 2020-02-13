/* https://vanya.jp.net/os/haribote.html#hrb */
/* https://qiita.com/pollenjp/items/8fcb9573cdf2dc6e2668 */
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS {
. = 0x7c00;
.text : { *(.text) }
}
