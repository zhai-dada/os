#include <linkage.h>

.section .text

/**
 * uefi 启动之后，数据段索引无法确定，可以使用栈段充当临时的数据段（ss在uefi环境下正好可以改）
 */
ENTRY(_start)
	mov     %ss, %ax
	mov     %ax, %ds
	mov     %ax, %es
	mov     %ax, %fs
	mov     %ax, %ss
	mov     $0x7E00, %esp
	movq 	$0x101000, %rax
	movq 	%rax, %cr3