/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.text;				\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps;	\
	.data; \
	.long name

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.text;			\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps;		\
	.data; \
	.long name

.data
.global vectors  /*entry functions*/
vectors:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(routine_divide, T_DIVIDE);  //0
	TRAPHANDLER_NOEC(routine_debug, T_DEBUG);
	TRAPHANDLER_NOEC(routine_nmi, T_NMI);
	TRAPHANDLER_NOEC(routine_brkpt, T_BRKPT);
	TRAPHANDLER_NOEC(routine_oflow, T_OFLOW);
	TRAPHANDLER_NOEC(routine_bound, T_BOUND);
	TRAPHANDLER_NOEC(routine_illop, T_ILLOP);
	TRAPHANDLER_NOEC(routine_device, T_DEVICE);
	TRAPHANDLER(routine_dblflt, T_DBLFLT); //#define T_DBLFLT 8
	TRAPHANDLER(routine_no9, T_DIVIDE);  //add this for cleaness
	TRAPHANDLER(routine_tss, T_TSS); //#define T_TSS 10
	TRAPHANDLER(routine_segnp, T_SEGNP); 
	TRAPHANDLER(routine_stack, T_STACK); 
	TRAPHANDLER(routine_gpflt, T_GPFLT);
	TRAPHANDLER(routine_pgflt, T_PGFLT); //14
	TRAPHANDLER(routine_no15, T_DIVIDE); //add this for cleaness
	TRAPHANDLER_NOEC(routine_fperr, T_FPERR);
	TRAPHANDLER(routine_align, T_ALIGN);
	TRAPHANDLER_NOEC(routine_mchk, T_MCHK);
	TRAPHANDLER_NOEC(routine_simderr, T_SIMDERR);
	
	
	TRAPHANDLER_NOEC(routine_syscall, T_SYSCALL);

	#for IRQ HANDLER
	TRAPHANDLER_NOEC(routine_irq0, IRQ_OFFSET + 0);
	TRAPHANDLER_NOEC(routine_irq1, IRQ_OFFSET + 1);
	TRAPHANDLER_NOEC(routine_irq2, IRQ_OFFSET + 2);
	TRAPHANDLER_NOEC(routine_irq3, IRQ_OFFSET + 3);
	TRAPHANDLER_NOEC(routine_irq4, IRQ_OFFSET + 4);
	TRAPHANDLER_NOEC(routine_irq5, IRQ_OFFSET + 5);
	TRAPHANDLER_NOEC(routine_irq6, IRQ_OFFSET + 6);
	TRAPHANDLER_NOEC(routine_irq7, IRQ_OFFSET + 7);
	TRAPHANDLER_NOEC(routine_irq8, IRQ_OFFSET + 8);
	TRAPHANDLER_NOEC(routine_irq9, IRQ_OFFSET + 9);
	TRAPHANDLER_NOEC(routine_irq10, IRQ_OFFSET + 10);
	TRAPHANDLER_NOEC(routine_irq11, IRQ_OFFSET + 11);
	TRAPHANDLER_NOEC(routine_irq12, IRQ_OFFSET + 12);
	TRAPHANDLER_NOEC(routine_irq13, IRQ_OFFSET + 13);
	TRAPHANDLER_NOEC(routine_irq14, IRQ_OFFSET + 14);
	TRAPHANDLER_NOEC(routine_irq15, IRQ_OFFSET + 15);
	
	
	
	

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	
	pushw 	$0x0
	pushw	%ds
	pushw	$0x0
	pushw	%es
	pushal
	
	movl	$GD_KD, %eax
	movw	%ax, %ds
	movw	%ax, %es
	pushl	%esp
	
	call	trap
