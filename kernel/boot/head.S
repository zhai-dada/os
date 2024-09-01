#include <linkage.h>

.section .text
ENTRY(_start)
	mov	%ss, %ax
	mov	%ax, %ds
	mov	%ax, %es
	mov	%ax, %fs
	mov	%ax, %ss
	mov	$0x7E00, %esp
	movq $0x101000, %rax
	movq %rax, %cr3