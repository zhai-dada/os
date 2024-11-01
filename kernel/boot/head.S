#include <linkage.h>

.section .text

ENTRY(_start)
	mov %ss, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %ss
	mov $0x7e00, %rsp
	movq $0x101000, %rax
	movq %rax, %cr3

	lgdt gdt_table(%rip)
	lidt idt_table(%rip)

	mov $0x10, %ax
	mov %ax, %ds
	mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
	movq _stack_start_(%rip), %rsp

    movq $0x101000, %rax
    movq %rax, %cr3
    movq switch_seg(%rip), %rax
    pushq $0x08
    pushq %rax
    lretq
switch_seg:
    .quad entry64
entry64:
    movq $0x10, %rax
    movq %rax, %ds

.section .data

ENTRY(_stack_start_)
    .quad init_task_stack + 65536

.globl gdt_table
.align 8
gdt_table:
    .quad   0x0000000000000000                      /*0     NULL descriptor                         00*/
    .quad   0x0020980000000000                      /*1     KERNEL  Code    64-bit  Segment         08*/
    .quad   0x0000920000000000                      /*2     KERNEL  Data    64-bit  Segment         10*/
    .quad   0x0000000000000000                      /*3     USER    Code    32-bit  Segment         18*/
    .quad   0x0000000000000000                      /*4     USER    Data    32-bit  Segment         20*/
    .quad   0x0020f80000000000                      /*5     USER    Code    64-bit  Segment         28*/
    .quad   0x0000f20000000000                      /*6     USER    Data    64-bit  Segment         30*/
    .quad   0x00cf9a000000ffff                      /*7     KERNEL  Code    32-bit  Segment         38*/
    .quad   0x00cf92000000ffff                      /*8     KERNEL  Data    32-bit  Segment         40*/
    .quad   0x0000000000000000                      /*9 	NULL descriptor                         48*/
    .fill   100,8,0                                 /*x 	TSS (jmp one segment <9>)     			50*/
gdt_end:
gdt_pointer:
gdt_limit:	.word   gdt_end - gdt_table - 1
gdt_base:  	.quad   gdt_table

/*
* IDT TABLE 中断描述符表
*/
.globl idt_table
.align 8
idt_table:
    .fill  512,8,0
idt_end:
idt_pointer:
idt_limit:	.word   idt_end - idt_table - 1
idt_base:	.quad   idt_table