
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 00 12 f0       	mov    $0xf0120000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 f0 00 00 00       	call   f010012e <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	83 ec 10             	sub    $0x10,%esp
f0100048:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004b:	83 3d 80 5e 20 f0 00 	cmpl   $0x0,0xf0205e80
f0100052:	75 46                	jne    f010009a <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f0100054:	89 35 80 5e 20 f0    	mov    %esi,0xf0205e80

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010005a:	fa                   	cli    
f010005b:	fc                   	cld    

	va_start(ap, fmt);
f010005c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010005f:	e8 dc 66 00 00       	call   f0106740 <cpunum>
f0100064:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100067:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010006b:	8b 55 08             	mov    0x8(%ebp),%edx
f010006e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100072:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100076:	c7 04 24 80 6e 10 f0 	movl   $0xf0106e80,(%esp)
f010007d:	e8 68 42 00 00       	call   f01042ea <cprintf>
	vcprintf(fmt, ap);
f0100082:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100086:	89 34 24             	mov    %esi,(%esp)
f0100089:	e8 29 42 00 00       	call   f01042b7 <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 be 81 10 f0 	movl   $0xf01081be,(%esp)
f0100095:	e8 50 42 00 00       	call   f01042ea <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010009a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000a1:	e8 21 0c 00 00       	call   f0100cc7 <monitor>
f01000a6:	eb f2                	jmp    f010009a <_panic+0x5a>

f01000a8 <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f01000a8:	55                   	push   %ebp
f01000a9:	89 e5                	mov    %esp,%ebp
f01000ab:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f01000ae:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01000b3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01000b8:	77 20                	ja     f01000da <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01000be:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f01000c5:	f0 
f01000c6:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
f01000cd:	00 
f01000ce:	c7 04 24 eb 6e 10 f0 	movl   $0xf0106eeb,(%esp)
f01000d5:	e8 66 ff ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01000da:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01000df:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01000e2:	e8 59 66 00 00       	call   f0106740 <cpunum>
f01000e7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000eb:	c7 04 24 f7 6e 10 f0 	movl   $0xf0106ef7,(%esp)
f01000f2:	e8 f3 41 00 00       	call   f01042ea <cprintf>

	lapic_init();
f01000f7:	e8 5e 66 00 00       	call   f010675a <lapic_init>
	env_init_percpu();
f01000fc:	e8 98 39 00 00       	call   f0103a99 <env_init_percpu>
	trap_init_percpu();
f0100101:	e8 0a 42 00 00       	call   f0104310 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100106:	e8 35 66 00 00       	call   f0106740 <cpunum>
f010010b:	6b d0 74             	imul   $0x74,%eax,%edx
f010010e:	81 c2 20 60 20 f0    	add    $0xf0206020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0100114:	b8 01 00 00 00       	mov    $0x1,%eax
f0100119:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010011d:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f0100124:	e8 c7 68 00 00       	call   f01069f0 <spin_lock>
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
	sched_yield();
f0100129:	e8 ee 4b 00 00       	call   f0104d1c <sched_yield>

f010012e <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f010012e:	55                   	push   %ebp
f010012f:	89 e5                	mov    %esp,%ebp
f0100131:	53                   	push   %ebx
f0100132:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100135:	b8 08 70 24 f0       	mov    $0xf0247008,%eax
f010013a:	2d 59 4b 20 f0       	sub    $0xf0204b59,%eax
f010013f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010014a:	00 
f010014b:	c7 04 24 59 4b 20 f0 	movl   $0xf0204b59,(%esp)
f0100152:	e8 5a 5f 00 00       	call   f01060b1 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100157:	e8 50 05 00 00       	call   f01006ac <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010015c:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f0100163:	00 
f0100164:	c7 04 24 0d 6f 10 f0 	movl   $0xf0106f0d,(%esp)
f010016b:	e8 7a 41 00 00       	call   f01042ea <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100170:	e8 d6 16 00 00       	call   f010184b <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f0100175:	e8 49 39 00 00       	call   f0103ac3 <env_init>
	trap_init();
f010017a:	e8 61 42 00 00       	call   f01043e0 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f010017f:	90                   	nop
f0100180:	e8 dc 62 00 00       	call   f0106461 <mp_init>
	lapic_init();
f0100185:	e8 d0 65 00 00       	call   f010675a <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f010018a:	e8 8a 40 00 00       	call   f0104219 <pic_init>
f010018f:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f0100196:	e8 55 68 00 00       	call   f01069f0 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010019b:	83 3d 88 5e 20 f0 07 	cmpl   $0x7,0xf0205e88
f01001a2:	77 24                	ja     f01001c8 <i386_init+0x9a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01001a4:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f01001ab:	00 
f01001ac:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01001b3:	f0 
f01001b4:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
f01001bb:	00 
f01001bc:	c7 04 24 eb 6e 10 f0 	movl   $0xf0106eeb,(%esp)
f01001c3:	e8 78 fe ff ff       	call   f0100040 <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001c8:	b8 7a 63 10 f0       	mov    $0xf010637a,%eax
f01001cd:	2d 00 63 10 f0       	sub    $0xf0106300,%eax
f01001d2:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001d6:	c7 44 24 04 00 63 10 	movl   $0xf0106300,0x4(%esp)
f01001dd:	f0 
f01001de:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f01001e5:	e8 22 5f 00 00       	call   f010610c <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001ea:	6b 05 c4 63 20 f0 74 	imul   $0x74,0xf02063c4,%eax
f01001f1:	05 20 60 20 f0       	add    $0xf0206020,%eax
f01001f6:	3d 20 60 20 f0       	cmp    $0xf0206020,%eax
f01001fb:	76 62                	jbe    f010025f <i386_init+0x131>
f01001fd:	bb 20 60 20 f0       	mov    $0xf0206020,%ebx
		if (c == cpus + cpunum())  // We've started already.
f0100202:	e8 39 65 00 00       	call   f0106740 <cpunum>
f0100207:	6b c0 74             	imul   $0x74,%eax,%eax
f010020a:	05 20 60 20 f0       	add    $0xf0206020,%eax
f010020f:	39 c3                	cmp    %eax,%ebx
f0100211:	74 39                	je     f010024c <i386_init+0x11e>

static void boot_aps(void);


void
i386_init(void)
f0100213:	89 d8                	mov    %ebx,%eax
f0100215:	2d 20 60 20 f0       	sub    $0xf0206020,%eax
	for (c = cpus; c < cpus + ncpu; c++) {
		if (c == cpus + cpunum())  // We've started already.
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010021a:	c1 f8 02             	sar    $0x2,%eax
f010021d:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100223:	c1 e0 0f             	shl    $0xf,%eax
f0100226:	8d 80 00 f0 20 f0    	lea    -0xfdf1000(%eax),%eax
f010022c:	a3 84 5e 20 f0       	mov    %eax,0xf0205e84
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f0100231:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f0100238:	00 
f0100239:	0f b6 03             	movzbl (%ebx),%eax
f010023c:	89 04 24             	mov    %eax,(%esp)
f010023f:	e8 64 66 00 00       	call   f01068a8 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f0100244:	8b 43 04             	mov    0x4(%ebx),%eax
f0100247:	83 f8 01             	cmp    $0x1,%eax
f010024a:	75 f8                	jne    f0100244 <i386_init+0x116>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f010024c:	83 c3 74             	add    $0x74,%ebx
f010024f:	6b 05 c4 63 20 f0 74 	imul   $0x74,0xf02063c4,%eax
f0100256:	05 20 60 20 f0       	add    $0xf0206020,%eax
f010025b:	39 c3                	cmp    %eax,%ebx
f010025d:	72 a3                	jb     f0100202 <i386_init+0xd4>
	lock_kernel();
	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010025f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0100266:	00 
f0100267:	c7 44 24 04 5b 53 01 	movl   $0x1535b,0x4(%esp)
f010026e:	00 
f010026f:	c7 04 24 b3 4e 1c f0 	movl   $0xf01c4eb3,(%esp)
f0100276:	e8 2b 3a 00 00       	call   f0103ca6 <env_create>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010027b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100282:	00 
f0100283:	c7 44 24 04 03 4f 00 	movl   $0x4f03,0x4(%esp)
f010028a:	00 
f010028b:	c7 04 24 0b 4e 1f f0 	movl   $0xf01f4e0b,(%esp)
f0100292:	e8 0f 3a 00 00       	call   f0103ca6 <env_create>
	ENV_CREATE(user_dumbfork, ENV_TYPE_USER);

#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f0100297:	e8 bb 03 00 00       	call   f0100657 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f010029c:	e8 7b 4a 00 00       	call   f0104d1c <sched_yield>

f01002a1 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002a1:	55                   	push   %ebp
f01002a2:	89 e5                	mov    %esp,%ebp
f01002a4:	53                   	push   %ebx
f01002a5:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f01002a8:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
f01002ae:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b2:	8b 45 08             	mov    0x8(%ebp),%eax
f01002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002b9:	c7 04 24 28 6f 10 f0 	movl   $0xf0106f28,(%esp)
f01002c0:	e8 25 40 00 00       	call   f01042ea <cprintf>
	vcprintf(fmt, ap);
f01002c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01002c9:	8b 45 10             	mov    0x10(%ebp),%eax
f01002cc:	89 04 24             	mov    %eax,(%esp)
f01002cf:	e8 e3 3f 00 00       	call   f01042b7 <vcprintf>
	cprintf("\n");
f01002d4:	c7 04 24 be 81 10 f0 	movl   $0xf01081be,(%esp)
f01002db:	e8 0a 40 00 00       	call   f01042ea <cprintf>
	va_end(ap);
}
f01002e0:	83 c4 14             	add    $0x14,%esp
f01002e3:	5b                   	pop    %ebx
f01002e4:	5d                   	pop    %ebp
f01002e5:	c3                   	ret    
	...

f01002f0 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01002f0:	55                   	push   %ebp
f01002f1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002f3:	ba 84 00 00 00       	mov    $0x84,%edx
f01002f8:	ec                   	in     (%dx),%al
f01002f9:	ec                   	in     (%dx),%al
f01002fa:	ec                   	in     (%dx),%al
f01002fb:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f01002fc:	5d                   	pop    %ebp
f01002fd:	c3                   	ret    

f01002fe <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01002fe:	55                   	push   %ebp
f01002ff:	89 e5                	mov    %esp,%ebp
f0100301:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100306:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100307:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010030c:	a8 01                	test   $0x1,%al
f010030e:	74 06                	je     f0100316 <serial_proc_data+0x18>
f0100310:	b2 f8                	mov    $0xf8,%dl
f0100312:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100313:	0f b6 c8             	movzbl %al,%ecx
}
f0100316:	89 c8                	mov    %ecx,%eax
f0100318:	5d                   	pop    %ebp
f0100319:	c3                   	ret    

f010031a <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010031a:	55                   	push   %ebp
f010031b:	89 e5                	mov    %esp,%ebp
f010031d:	53                   	push   %ebx
f010031e:	83 ec 04             	sub    $0x4,%esp
f0100321:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100323:	eb 25                	jmp    f010034a <cons_intr+0x30>
		if (c == 0)
f0100325:	85 c0                	test   %eax,%eax
f0100327:	74 21                	je     f010034a <cons_intr+0x30>
			continue;
		cons.buf[cons.wpos++] = c;
f0100329:	8b 15 24 52 20 f0    	mov    0xf0205224,%edx
f010032f:	88 82 20 50 20 f0    	mov    %al,-0xfdfafe0(%edx)
f0100335:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f0100338:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f010033d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100342:	0f 44 c2             	cmove  %edx,%eax
f0100345:	a3 24 52 20 f0       	mov    %eax,0xf0205224
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f010034a:	ff d3                	call   *%ebx
f010034c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010034f:	75 d4                	jne    f0100325 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f0100351:	83 c4 04             	add    $0x4,%esp
f0100354:	5b                   	pop    %ebx
f0100355:	5d                   	pop    %ebp
f0100356:	c3                   	ret    

f0100357 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100357:	55                   	push   %ebp
f0100358:	89 e5                	mov    %esp,%ebp
f010035a:	57                   	push   %edi
f010035b:	56                   	push   %esi
f010035c:	53                   	push   %ebx
f010035d:	83 ec 2c             	sub    $0x2c,%esp
f0100360:	89 c7                	mov    %eax,%edi
f0100362:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100367:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f0100368:	a8 20                	test   $0x20,%al
f010036a:	75 1b                	jne    f0100387 <cons_putc+0x30>
f010036c:	bb 00 32 00 00       	mov    $0x3200,%ebx
f0100371:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f0100376:	e8 75 ff ff ff       	call   f01002f0 <delay>
f010037b:	89 f2                	mov    %esi,%edx
f010037d:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010037e:	a8 20                	test   $0x20,%al
f0100380:	75 05                	jne    f0100387 <cons_putc+0x30>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100382:	83 eb 01             	sub    $0x1,%ebx
f0100385:	75 ef                	jne    f0100376 <cons_putc+0x1f>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100387:	89 fa                	mov    %edi,%edx
f0100389:	89 f8                	mov    %edi,%eax
f010038b:	88 55 e7             	mov    %dl,-0x19(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010038e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100393:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100394:	b2 79                	mov    $0x79,%dl
f0100396:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100397:	84 c0                	test   %al,%al
f0100399:	78 1b                	js     f01003b6 <cons_putc+0x5f>
f010039b:	bb 00 32 00 00       	mov    $0x3200,%ebx
f01003a0:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f01003a5:	e8 46 ff ff ff       	call   f01002f0 <delay>
f01003aa:	89 f2                	mov    %esi,%edx
f01003ac:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003ad:	84 c0                	test   %al,%al
f01003af:	78 05                	js     f01003b6 <cons_putc+0x5f>
f01003b1:	83 eb 01             	sub    $0x1,%ebx
f01003b4:	75 ef                	jne    f01003a5 <cons_putc+0x4e>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003b6:	ba 78 03 00 00       	mov    $0x378,%edx
f01003bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01003bf:	ee                   	out    %al,(%dx)
f01003c0:	b2 7a                	mov    $0x7a,%dl
f01003c2:	b8 0d 00 00 00       	mov    $0xd,%eax
f01003c7:	ee                   	out    %al,(%dx)
f01003c8:	b8 08 00 00 00       	mov    $0x8,%eax
f01003cd:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f01003ce:	89 fa                	mov    %edi,%edx
f01003d0:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01003d6:	89 f8                	mov    %edi,%eax
f01003d8:	80 cc 07             	or     $0x7,%ah
f01003db:	85 d2                	test   %edx,%edx
f01003dd:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f01003e0:	89 f8                	mov    %edi,%eax
f01003e2:	25 ff 00 00 00       	and    $0xff,%eax
f01003e7:	83 f8 09             	cmp    $0x9,%eax
f01003ea:	74 7c                	je     f0100468 <cons_putc+0x111>
f01003ec:	83 f8 09             	cmp    $0x9,%eax
f01003ef:	7f 0b                	jg     f01003fc <cons_putc+0xa5>
f01003f1:	83 f8 08             	cmp    $0x8,%eax
f01003f4:	0f 85 a2 00 00 00    	jne    f010049c <cons_putc+0x145>
f01003fa:	eb 16                	jmp    f0100412 <cons_putc+0xbb>
f01003fc:	83 f8 0a             	cmp    $0xa,%eax
f01003ff:	90                   	nop
f0100400:	74 40                	je     f0100442 <cons_putc+0xeb>
f0100402:	83 f8 0d             	cmp    $0xd,%eax
f0100405:	0f 85 91 00 00 00    	jne    f010049c <cons_putc+0x145>
f010040b:	90                   	nop
f010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100410:	eb 38                	jmp    f010044a <cons_putc+0xf3>
	case '\b':
		if (crt_pos > 0) {
f0100412:	0f b7 05 34 52 20 f0 	movzwl 0xf0205234,%eax
f0100419:	66 85 c0             	test   %ax,%ax
f010041c:	0f 84 e4 00 00 00    	je     f0100506 <cons_putc+0x1af>
			crt_pos--;
f0100422:	83 e8 01             	sub    $0x1,%eax
f0100425:	66 a3 34 52 20 f0    	mov    %ax,0xf0205234
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010042b:	0f b7 c0             	movzwl %ax,%eax
f010042e:	66 81 e7 00 ff       	and    $0xff00,%di
f0100433:	83 cf 20             	or     $0x20,%edi
f0100436:	8b 15 30 52 20 f0    	mov    0xf0205230,%edx
f010043c:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100440:	eb 77                	jmp    f01004b9 <cons_putc+0x162>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f0100442:	66 83 05 34 52 20 f0 	addw   $0x50,0xf0205234
f0100449:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f010044a:	0f b7 05 34 52 20 f0 	movzwl 0xf0205234,%eax
f0100451:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100457:	c1 e8 16             	shr    $0x16,%eax
f010045a:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010045d:	c1 e0 04             	shl    $0x4,%eax
f0100460:	66 a3 34 52 20 f0    	mov    %ax,0xf0205234
f0100466:	eb 51                	jmp    f01004b9 <cons_putc+0x162>
		break;
	case '\t':
		cons_putc(' ');
f0100468:	b8 20 00 00 00       	mov    $0x20,%eax
f010046d:	e8 e5 fe ff ff       	call   f0100357 <cons_putc>
		cons_putc(' ');
f0100472:	b8 20 00 00 00       	mov    $0x20,%eax
f0100477:	e8 db fe ff ff       	call   f0100357 <cons_putc>
		cons_putc(' ');
f010047c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100481:	e8 d1 fe ff ff       	call   f0100357 <cons_putc>
		cons_putc(' ');
f0100486:	b8 20 00 00 00       	mov    $0x20,%eax
f010048b:	e8 c7 fe ff ff       	call   f0100357 <cons_putc>
		cons_putc(' ');
f0100490:	b8 20 00 00 00       	mov    $0x20,%eax
f0100495:	e8 bd fe ff ff       	call   f0100357 <cons_putc>
f010049a:	eb 1d                	jmp    f01004b9 <cons_putc+0x162>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f010049c:	0f b7 05 34 52 20 f0 	movzwl 0xf0205234,%eax
f01004a3:	0f b7 c8             	movzwl %ax,%ecx
f01004a6:	8b 15 30 52 20 f0    	mov    0xf0205230,%edx
f01004ac:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01004b0:	83 c0 01             	add    $0x1,%eax
f01004b3:	66 a3 34 52 20 f0    	mov    %ax,0xf0205234
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01004b9:	66 81 3d 34 52 20 f0 	cmpw   $0x7cf,0xf0205234
f01004c0:	cf 07 
f01004c2:	76 42                	jbe    f0100506 <cons_putc+0x1af>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004c4:	a1 30 52 20 f0       	mov    0xf0205230,%eax
f01004c9:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f01004d0:	00 
f01004d1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d7:	89 54 24 04          	mov    %edx,0x4(%esp)
f01004db:	89 04 24             	mov    %eax,(%esp)
f01004de:	e8 29 5c 00 00       	call   f010610c <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01004e3:	8b 15 30 52 20 f0    	mov    0xf0205230,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004e9:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f01004ee:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004f4:	83 c0 01             	add    $0x1,%eax
f01004f7:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f01004fc:	75 f0                	jne    f01004ee <cons_putc+0x197>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f01004fe:	66 83 2d 34 52 20 f0 	subw   $0x50,0xf0205234
f0100505:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100506:	8b 0d 2c 52 20 f0    	mov    0xf020522c,%ecx
f010050c:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100511:	89 ca                	mov    %ecx,%edx
f0100513:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100514:	0f b7 35 34 52 20 f0 	movzwl 0xf0205234,%esi
f010051b:	8d 59 01             	lea    0x1(%ecx),%ebx
f010051e:	89 f0                	mov    %esi,%eax
f0100520:	66 c1 e8 08          	shr    $0x8,%ax
f0100524:	89 da                	mov    %ebx,%edx
f0100526:	ee                   	out    %al,(%dx)
f0100527:	b8 0f 00 00 00       	mov    $0xf,%eax
f010052c:	89 ca                	mov    %ecx,%edx
f010052e:	ee                   	out    %al,(%dx)
f010052f:	89 f0                	mov    %esi,%eax
f0100531:	89 da                	mov    %ebx,%edx
f0100533:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100534:	83 c4 2c             	add    $0x2c,%esp
f0100537:	5b                   	pop    %ebx
f0100538:	5e                   	pop    %esi
f0100539:	5f                   	pop    %edi
f010053a:	5d                   	pop    %ebp
f010053b:	c3                   	ret    

f010053c <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f010053c:	55                   	push   %ebp
f010053d:	89 e5                	mov    %esp,%ebp
f010053f:	53                   	push   %ebx
f0100540:	83 ec 14             	sub    $0x14,%esp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100543:	ba 64 00 00 00       	mov    $0x64,%edx
f0100548:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f0100549:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f010054e:	a8 01                	test   $0x1,%al
f0100550:	0f 84 de 00 00 00    	je     f0100634 <kbd_proc_data+0xf8>
f0100556:	b2 60                	mov    $0x60,%dl
f0100558:	ec                   	in     (%dx),%al
f0100559:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f010055b:	3c e0                	cmp    $0xe0,%al
f010055d:	75 11                	jne    f0100570 <kbd_proc_data+0x34>
		// E0 escape character
		shift |= E0ESC;
f010055f:	83 0d 28 52 20 f0 40 	orl    $0x40,0xf0205228
		return 0;
f0100566:	bb 00 00 00 00       	mov    $0x0,%ebx
f010056b:	e9 c4 00 00 00       	jmp    f0100634 <kbd_proc_data+0xf8>
	} else if (data & 0x80) {
f0100570:	84 c0                	test   %al,%al
f0100572:	79 37                	jns    f01005ab <kbd_proc_data+0x6f>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100574:	8b 0d 28 52 20 f0    	mov    0xf0205228,%ecx
f010057a:	89 cb                	mov    %ecx,%ebx
f010057c:	83 e3 40             	and    $0x40,%ebx
f010057f:	83 e0 7f             	and    $0x7f,%eax
f0100582:	85 db                	test   %ebx,%ebx
f0100584:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100587:	0f b6 d2             	movzbl %dl,%edx
f010058a:	0f b6 82 80 6f 10 f0 	movzbl -0xfef9080(%edx),%eax
f0100591:	83 c8 40             	or     $0x40,%eax
f0100594:	0f b6 c0             	movzbl %al,%eax
f0100597:	f7 d0                	not    %eax
f0100599:	21 c1                	and    %eax,%ecx
f010059b:	89 0d 28 52 20 f0    	mov    %ecx,0xf0205228
		return 0;
f01005a1:	bb 00 00 00 00       	mov    $0x0,%ebx
f01005a6:	e9 89 00 00 00       	jmp    f0100634 <kbd_proc_data+0xf8>
	} else if (shift & E0ESC) {
f01005ab:	8b 0d 28 52 20 f0    	mov    0xf0205228,%ecx
f01005b1:	f6 c1 40             	test   $0x40,%cl
f01005b4:	74 0e                	je     f01005c4 <kbd_proc_data+0x88>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01005b6:	89 c2                	mov    %eax,%edx
f01005b8:	83 ca 80             	or     $0xffffff80,%edx
		shift &= ~E0ESC;
f01005bb:	83 e1 bf             	and    $0xffffffbf,%ecx
f01005be:	89 0d 28 52 20 f0    	mov    %ecx,0xf0205228
	}

	shift |= shiftcode[data];
f01005c4:	0f b6 d2             	movzbl %dl,%edx
f01005c7:	0f b6 82 80 6f 10 f0 	movzbl -0xfef9080(%edx),%eax
f01005ce:	0b 05 28 52 20 f0    	or     0xf0205228,%eax
	shift ^= togglecode[data];
f01005d4:	0f b6 8a 80 70 10 f0 	movzbl -0xfef8f80(%edx),%ecx
f01005db:	31 c8                	xor    %ecx,%eax
f01005dd:	a3 28 52 20 f0       	mov    %eax,0xf0205228

	c = charcode[shift & (CTL | SHIFT)][data];
f01005e2:	89 c1                	mov    %eax,%ecx
f01005e4:	83 e1 03             	and    $0x3,%ecx
f01005e7:	8b 0c 8d 80 71 10 f0 	mov    -0xfef8e80(,%ecx,4),%ecx
f01005ee:	0f b6 1c 11          	movzbl (%ecx,%edx,1),%ebx
	if (shift & CAPSLOCK) {
f01005f2:	a8 08                	test   $0x8,%al
f01005f4:	74 19                	je     f010060f <kbd_proc_data+0xd3>
		if ('a' <= c && c <= 'z')
f01005f6:	8d 53 9f             	lea    -0x61(%ebx),%edx
f01005f9:	83 fa 19             	cmp    $0x19,%edx
f01005fc:	77 05                	ja     f0100603 <kbd_proc_data+0xc7>
			c += 'A' - 'a';
f01005fe:	83 eb 20             	sub    $0x20,%ebx
f0100601:	eb 0c                	jmp    f010060f <kbd_proc_data+0xd3>
		else if ('A' <= c && c <= 'Z')
f0100603:	8d 4b bf             	lea    -0x41(%ebx),%ecx
			c += 'a' - 'A';
f0100606:	8d 53 20             	lea    0x20(%ebx),%edx
f0100609:	83 f9 19             	cmp    $0x19,%ecx
f010060c:	0f 46 da             	cmovbe %edx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010060f:	f7 d0                	not    %eax
f0100611:	a8 06                	test   $0x6,%al
f0100613:	75 1f                	jne    f0100634 <kbd_proc_data+0xf8>
f0100615:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010061b:	75 17                	jne    f0100634 <kbd_proc_data+0xf8>
		cprintf("Rebooting!\n");
f010061d:	c7 04 24 42 6f 10 f0 	movl   $0xf0106f42,(%esp)
f0100624:	e8 c1 3c 00 00       	call   f01042ea <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100629:	ba 92 00 00 00       	mov    $0x92,%edx
f010062e:	b8 03 00 00 00       	mov    $0x3,%eax
f0100633:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100634:	89 d8                	mov    %ebx,%eax
f0100636:	83 c4 14             	add    $0x14,%esp
f0100639:	5b                   	pop    %ebx
f010063a:	5d                   	pop    %ebp
f010063b:	c3                   	ret    

f010063c <serial_intr>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f010063c:	55                   	push   %ebp
f010063d:	89 e5                	mov    %esp,%ebp
f010063f:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f0100642:	80 3d 00 50 20 f0 00 	cmpb   $0x0,0xf0205000
f0100649:	74 0a                	je     f0100655 <serial_intr+0x19>
		cons_intr(serial_proc_data);
f010064b:	b8 fe 02 10 f0       	mov    $0xf01002fe,%eax
f0100650:	e8 c5 fc ff ff       	call   f010031a <cons_intr>
}
f0100655:	c9                   	leave  
f0100656:	c3                   	ret    

f0100657 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100657:	55                   	push   %ebp
f0100658:	89 e5                	mov    %esp,%ebp
f010065a:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010065d:	b8 3c 05 10 f0       	mov    $0xf010053c,%eax
f0100662:	e8 b3 fc ff ff       	call   f010031a <cons_intr>
}
f0100667:	c9                   	leave  
f0100668:	c3                   	ret    

f0100669 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100669:	55                   	push   %ebp
f010066a:	89 e5                	mov    %esp,%ebp
f010066c:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f010066f:	e8 c8 ff ff ff       	call   f010063c <serial_intr>
	kbd_intr();
f0100674:	e8 de ff ff ff       	call   f0100657 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100679:	8b 15 20 52 20 f0    	mov    0xf0205220,%edx
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
f010067f:	b8 00 00 00 00       	mov    $0x0,%eax
	// (e.g., when called from the kernel monitor).
	serial_intr();
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100684:	3b 15 24 52 20 f0    	cmp    0xf0205224,%edx
f010068a:	74 1e                	je     f01006aa <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010068c:	0f b6 82 20 50 20 f0 	movzbl -0xfdfafe0(%edx),%eax
f0100693:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
f0100696:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010069c:	b9 00 00 00 00       	mov    $0x0,%ecx
f01006a1:	0f 44 d1             	cmove  %ecx,%edx
f01006a4:	89 15 20 52 20 f0    	mov    %edx,0xf0205220
		return c;
	}
	return 0;
}
f01006aa:	c9                   	leave  
f01006ab:	c3                   	ret    

f01006ac <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01006ac:	55                   	push   %ebp
f01006ad:	89 e5                	mov    %esp,%ebp
f01006af:	57                   	push   %edi
f01006b0:	56                   	push   %esi
f01006b1:	53                   	push   %ebx
f01006b2:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01006b5:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006bc:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006c3:	5a a5 
	if (*cp != 0xA55A) {
f01006c5:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006cc:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006d0:	74 11                	je     f01006e3 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01006d2:	c7 05 2c 52 20 f0 b4 	movl   $0x3b4,0xf020522c
f01006d9:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006dc:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01006e1:	eb 16                	jmp    f01006f9 <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f01006e3:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006ea:	c7 05 2c 52 20 f0 d4 	movl   $0x3d4,0xf020522c
f01006f1:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006f4:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f01006f9:	8b 0d 2c 52 20 f0    	mov    0xf020522c,%ecx
f01006ff:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100704:	89 ca                	mov    %ecx,%edx
f0100706:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100707:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010070a:	89 da                	mov    %ebx,%edx
f010070c:	ec                   	in     (%dx),%al
f010070d:	0f b6 f8             	movzbl %al,%edi
f0100710:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100713:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100718:	89 ca                	mov    %ecx,%edx
f010071a:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010071b:	89 da                	mov    %ebx,%edx
f010071d:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f010071e:	89 35 30 52 20 f0    	mov    %esi,0xf0205230

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f0100724:	0f b6 d8             	movzbl %al,%ebx
f0100727:	09 df                	or     %ebx,%edi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f0100729:	66 89 3d 34 52 20 f0 	mov    %di,0xf0205234

static void
kbd_init(void)
{
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f0100730:	e8 22 ff ff ff       	call   f0100657 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100735:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f010073c:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100741:	89 04 24             	mov    %eax,(%esp)
f0100744:	e8 5f 3a 00 00       	call   f01041a8 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100749:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f010074e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100753:	89 da                	mov    %ebx,%edx
f0100755:	ee                   	out    %al,(%dx)
f0100756:	b2 fb                	mov    $0xfb,%dl
f0100758:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010075d:	ee                   	out    %al,(%dx)
f010075e:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100763:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100768:	89 ca                	mov    %ecx,%edx
f010076a:	ee                   	out    %al,(%dx)
f010076b:	b2 f9                	mov    $0xf9,%dl
f010076d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100772:	ee                   	out    %al,(%dx)
f0100773:	b2 fb                	mov    $0xfb,%dl
f0100775:	b8 03 00 00 00       	mov    $0x3,%eax
f010077a:	ee                   	out    %al,(%dx)
f010077b:	b2 fc                	mov    $0xfc,%dl
f010077d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100782:	ee                   	out    %al,(%dx)
f0100783:	b2 f9                	mov    $0xf9,%dl
f0100785:	b8 01 00 00 00       	mov    $0x1,%eax
f010078a:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010078b:	b2 fd                	mov    $0xfd,%dl
f010078d:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010078e:	3c ff                	cmp    $0xff,%al
f0100790:	0f 95 c0             	setne  %al
f0100793:	89 c6                	mov    %eax,%esi
f0100795:	a2 00 50 20 f0       	mov    %al,0xf0205000
f010079a:	89 da                	mov    %ebx,%edx
f010079c:	ec                   	in     (%dx),%al
f010079d:	89 ca                	mov    %ecx,%edx
f010079f:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01007a0:	89 f0                	mov    %esi,%eax
f01007a2:	84 c0                	test   %al,%al
f01007a4:	74 1d                	je     f01007c3 <cons_init+0x117>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01007a6:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01007ad:	25 ef ff 00 00       	and    $0xffef,%eax
f01007b2:	89 04 24             	mov    %eax,(%esp)
f01007b5:	e8 ee 39 00 00       	call   f01041a8 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01007ba:	80 3d 00 50 20 f0 00 	cmpb   $0x0,0xf0205000
f01007c1:	75 0c                	jne    f01007cf <cons_init+0x123>
		cprintf("Serial port does not exist!\n");
f01007c3:	c7 04 24 4e 6f 10 f0 	movl   $0xf0106f4e,(%esp)
f01007ca:	e8 1b 3b 00 00       	call   f01042ea <cprintf>
}
f01007cf:	83 c4 1c             	add    $0x1c,%esp
f01007d2:	5b                   	pop    %ebx
f01007d3:	5e                   	pop    %esi
f01007d4:	5f                   	pop    %edi
f01007d5:	5d                   	pop    %ebp
f01007d6:	c3                   	ret    

f01007d7 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007d7:	55                   	push   %ebp
f01007d8:	89 e5                	mov    %esp,%ebp
f01007da:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01007e0:	e8 72 fb ff ff       	call   f0100357 <cons_putc>
}
f01007e5:	c9                   	leave  
f01007e6:	c3                   	ret    

f01007e7 <getchar>:

int
getchar(void)
{
f01007e7:	55                   	push   %ebp
f01007e8:	89 e5                	mov    %esp,%ebp
f01007ea:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007ed:	e8 77 fe ff ff       	call   f0100669 <cons_getc>
f01007f2:	85 c0                	test   %eax,%eax
f01007f4:	74 f7                	je     f01007ed <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007f6:	c9                   	leave  
f01007f7:	c3                   	ret    

f01007f8 <iscons>:

int
iscons(int fdnum)
{
f01007f8:	55                   	push   %ebp
f01007f9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007fb:	b8 01 00 00 00       	mov    $0x1,%eax
f0100800:	5d                   	pop    %ebp
f0100801:	c3                   	ret    
	...

f0100810 <mon_dump>:
	}
	return 0;
}

int
mon_dump(int argc, char **argv, struct Trapframe *tf){
f0100810:	55                   	push   %ebp
f0100811:	89 e5                	mov    %esp,%ebp

	return 0;
}
f0100813:	b8 00 00 00 00       	mov    $0x0,%eax
f0100818:	5d                   	pop    %ebp
f0100819:	c3                   	ret    

f010081a <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010081a:	55                   	push   %ebp
f010081b:	89 e5                	mov    %esp,%ebp
f010081d:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100820:	c7 04 24 90 71 10 f0 	movl   $0xf0107190,(%esp)
f0100827:	e8 be 3a 00 00       	call   f01042ea <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010082c:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f0100833:	00 
f0100834:	c7 04 24 ec 72 10 f0 	movl   $0xf01072ec,(%esp)
f010083b:	e8 aa 3a 00 00       	call   f01042ea <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100840:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f0100847:	00 
f0100848:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f010084f:	f0 
f0100850:	c7 04 24 14 73 10 f0 	movl   $0xf0107314,(%esp)
f0100857:	e8 8e 3a 00 00       	call   f01042ea <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010085c:	c7 44 24 08 75 6e 10 	movl   $0x106e75,0x8(%esp)
f0100863:	00 
f0100864:	c7 44 24 04 75 6e 10 	movl   $0xf0106e75,0x4(%esp)
f010086b:	f0 
f010086c:	c7 04 24 38 73 10 f0 	movl   $0xf0107338,(%esp)
f0100873:	e8 72 3a 00 00       	call   f01042ea <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100878:	c7 44 24 08 59 4b 20 	movl   $0x204b59,0x8(%esp)
f010087f:	00 
f0100880:	c7 44 24 04 59 4b 20 	movl   $0xf0204b59,0x4(%esp)
f0100887:	f0 
f0100888:	c7 04 24 5c 73 10 f0 	movl   $0xf010735c,(%esp)
f010088f:	e8 56 3a 00 00       	call   f01042ea <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100894:	c7 44 24 08 08 70 24 	movl   $0x247008,0x8(%esp)
f010089b:	00 
f010089c:	c7 44 24 04 08 70 24 	movl   $0xf0247008,0x4(%esp)
f01008a3:	f0 
f01008a4:	c7 04 24 80 73 10 f0 	movl   $0xf0107380,(%esp)
f01008ab:	e8 3a 3a 00 00       	call   f01042ea <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f01008b0:	b8 07 74 24 f0       	mov    $0xf0247407,%eax
f01008b5:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01008ba:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008bf:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f01008c5:	85 c0                	test   %eax,%eax
f01008c7:	0f 48 c2             	cmovs  %edx,%eax
f01008ca:	c1 f8 0a             	sar    $0xa,%eax
f01008cd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008d1:	c7 04 24 a4 73 10 f0 	movl   $0xf01073a4,(%esp)
f01008d8:	e8 0d 3a 00 00       	call   f01042ea <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f01008dd:	b8 00 00 00 00       	mov    $0x0,%eax
f01008e2:	c9                   	leave  
f01008e3:	c3                   	ret    

f01008e4 <mon_help>:



int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008e4:	55                   	push   %ebp
f01008e5:	89 e5                	mov    %esp,%ebp
f01008e7:	53                   	push   %ebx
f01008e8:	83 ec 14             	sub    $0x14,%esp
f01008eb:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008f0:	8b 83 e4 75 10 f0    	mov    -0xfef8a1c(%ebx),%eax
f01008f6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008fa:	8b 83 e0 75 10 f0    	mov    -0xfef8a20(%ebx),%eax
f0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100904:	c7 04 24 a9 71 10 f0 	movl   $0xf01071a9,(%esp)
f010090b:	e8 da 39 00 00       	call   f01042ea <cprintf>
f0100910:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f0100913:	83 fb 48             	cmp    $0x48,%ebx
f0100916:	75 d8                	jne    f01008f0 <mon_help+0xc>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f0100918:	b8 00 00 00 00       	mov    $0x0,%eax
f010091d:	83 c4 14             	add    $0x14,%esp
f0100920:	5b                   	pop    %ebx
f0100921:	5d                   	pop    %ebp
f0100922:	c3                   	ret    

f0100923 <mon_mappingtool>:
	
	
}

int
mon_mappingtool(int argc, char **argv, struct Trapframe *tf){
f0100923:	55                   	push   %ebp
f0100924:	89 e5                	mov    %esp,%ebp
f0100926:	83 ec 28             	sub    $0x28,%esp
f0100929:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f010092c:	89 75 fc             	mov    %esi,-0x4(%ebp)
f010092f:	8b 75 08             	mov    0x8(%ebp),%esi
f0100932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	CHECKPARA(argc < 3 || argc > 4);
f0100935:	8d 46 fd             	lea    -0x3(%esi),%eax
f0100938:	83 f8 01             	cmp    $0x1,%eax
f010093b:	76 11                	jbe    f010094e <mon_mappingtool+0x2b>
f010093d:	c7 04 24 b2 71 10 f0 	movl   $0xf01071b2,(%esp)
f0100944:	e8 a1 39 00 00       	call   f01042ea <cprintf>
f0100949:	e9 fb 00 00 00       	jmp    f0100a49 <mon_mappingtool+0x126>
	uintptr_t addr = strtol(argv[2], NULL, 0);
f010094e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100955:	00 
f0100956:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010095d:	00 
f010095e:	8b 43 08             	mov    0x8(%ebx),%eax
f0100961:	89 04 24             	mov    %eax,(%esp)
f0100964:	e8 bb 58 00 00       	call   f0106224 <strtol>
	addr = ROUNDDOWN(addr, PGSIZE);
	pte_t * pte_ptr;
	struct PageInfo * pp;
	pp = page_lookup(kern_pgdir, (void *)addr, &pte_ptr);
f0100969:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010096c:	89 54 24 08          	mov    %edx,0x8(%esp)

int
mon_mappingtool(int argc, char **argv, struct Trapframe *tf){
	CHECKPARA(argc < 3 || argc > 4);
	uintptr_t addr = strtol(argv[2], NULL, 0);
	addr = ROUNDDOWN(addr, PGSIZE);
f0100970:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	pte_t * pte_ptr;
	struct PageInfo * pp;
	pp = page_lookup(kern_pgdir, (void *)addr, &pte_ptr);
f0100975:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100979:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010097e:	89 04 24             	mov    %eax,(%esp)
f0100981:	e8 af 0c 00 00       	call   f0101635 <page_lookup>
	if (pp == NULL || *pte_ptr == 0){	
f0100986:	85 c0                	test   %eax,%eax
f0100988:	74 08                	je     f0100992 <mon_mappingtool+0x6f>
f010098a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010098d:	83 38 00             	cmpl   $0x0,(%eax)
f0100990:	75 11                	jne    f01009a3 <mon_mappingtool+0x80>
		cprintf("no mapping here\n");
f0100992:	c7 04 24 c2 71 10 f0 	movl   $0xf01071c2,(%esp)
f0100999:	e8 4c 39 00 00       	call   f01042ea <cprintf>
		return 0;
f010099e:	e9 a6 00 00 00       	jmp    f0100a49 <mon_mappingtool+0x126>
	}
	if(strcmp(argv[1],"set")==0 || strcmp(argv[1],"change")==0){
f01009a3:	c7 44 24 04 d3 71 10 	movl   $0xf01071d3,0x4(%esp)
f01009aa:	f0 
f01009ab:	8b 43 04             	mov    0x4(%ebx),%eax
f01009ae:	89 04 24             	mov    %eax,(%esp)
f01009b1:	e8 25 56 00 00       	call   f0105fdb <strcmp>
f01009b6:	85 c0                	test   %eax,%eax
f01009b8:	74 17                	je     f01009d1 <mon_mappingtool+0xae>
f01009ba:	c7 44 24 04 d7 71 10 	movl   $0xf01071d7,0x4(%esp)
f01009c1:	f0 
f01009c2:	8b 43 04             	mov    0x4(%ebx),%eax
f01009c5:	89 04 24             	mov    %eax,(%esp)
f01009c8:	e8 0e 56 00 00       	call   f0105fdb <strcmp>
f01009cd:	85 c0                	test   %eax,%eax
f01009cf:	75 3e                	jne    f0100a0f <mon_mappingtool+0xec>
		CHECKPARA(argc != 4);
f01009d1:	83 fe 04             	cmp    $0x4,%esi
f01009d4:	74 0e                	je     f01009e4 <mon_mappingtool+0xc1>
f01009d6:	c7 04 24 b2 71 10 f0 	movl   $0xf01071b2,(%esp)
f01009dd:	e8 08 39 00 00       	call   f01042ea <cprintf>
f01009e2:	eb 65                	jmp    f0100a49 <mon_mappingtool+0x126>
		int perm = strtol(argv[3],0,0);
f01009e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01009eb:	00 
f01009ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01009f3:	00 
f01009f4:	8b 43 0c             	mov    0xc(%ebx),%eax
f01009f7:	89 04 24             	mov    %eax,(%esp)
f01009fa:	e8 25 58 00 00       	call   f0106224 <strtol>
		*pte_ptr &=0xfffff000;
f01009ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100a02:	81 22 00 f0 ff ff    	andl   $0xfffff000,(%edx)
		*pte_ptr |=perm;
f0100a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100a0b:	09 02                	or     %eax,(%edx)
	pp = page_lookup(kern_pgdir, (void *)addr, &pte_ptr);
	if (pp == NULL || *pte_ptr == 0){	
		cprintf("no mapping here\n");
		return 0;
	}
	if(strcmp(argv[1],"set")==0 || strcmp(argv[1],"change")==0){
f0100a0d:	eb 3a                	jmp    f0100a49 <mon_mappingtool+0x126>
		CHECKPARA(argc != 4);
		int perm = strtol(argv[3],0,0);
		*pte_ptr &=0xfffff000;
		*pte_ptr |=perm;
	}
	else if(strcmp(argv[1],"clear")==0){
f0100a0f:	c7 44 24 04 de 71 10 	movl   $0xf01071de,0x4(%esp)
f0100a16:	f0 
f0100a17:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a1a:	89 04 24             	mov    %eax,(%esp)
f0100a1d:	e8 b9 55 00 00       	call   f0105fdb <strcmp>
f0100a22:	85 c0                	test   %eax,%eax
f0100a24:	75 0b                	jne    f0100a31 <mon_mappingtool+0x10e>
		*pte_ptr &=0xfffff000;
f0100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a29:	81 20 00 f0 ff ff    	andl   $0xfffff000,(%eax)
f0100a2f:	eb 18                	jmp    f0100a49 <mon_mappingtool+0x126>
	}
	else{
		cprintf("Can find this operator!\n");
f0100a31:	c7 04 24 e4 71 10 f0 	movl   $0xf01071e4,(%esp)
f0100a38:	e8 ad 38 00 00       	call   f01042ea <cprintf>
		cprintf("command can be : (1)set\n (2)change\n (3)clear\n");
f0100a3d:	c7 04 24 d0 73 10 f0 	movl   $0xf01073d0,(%esp)
f0100a44:	e8 a1 38 00 00       	call   f01042ea <cprintf>
	}
	return 0;
}
f0100a49:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a4e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100a51:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100a54:	89 ec                	mov    %ebp,%esp
f0100a56:	5d                   	pop    %ebp
f0100a57:	c3                   	ret    

f0100a58 <mon_showmapping>:
	return 0;

}
int
mon_showmapping(int argc, char **argv, struct Trapframe *tf)
{
f0100a58:	55                   	push   %ebp
f0100a59:	89 e5                	mov    %esp,%ebp
f0100a5b:	57                   	push   %edi
f0100a5c:	56                   	push   %esi
f0100a5d:	53                   	push   %ebx
f0100a5e:	83 ec 3c             	sub    $0x3c,%esp
f0100a61:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a64:	8b 75 0c             	mov    0xc(%ebp),%esi
	uint32_t va_begin = 0, va_end = 0;
	char *endptrb, *endptre;
	CHECKPARA(argc != 2 && argc != 3);
f0100a67:	8d 50 fe             	lea    -0x2(%eax),%edx
f0100a6a:	83 fa 01             	cmp    $0x1,%edx
f0100a6d:	76 11                	jbe    f0100a80 <mon_showmapping+0x28>
f0100a6f:	c7 04 24 b2 71 10 f0 	movl   $0xf01071b2,(%esp)
f0100a76:	e8 6f 38 00 00       	call   f01042ea <cprintf>
f0100a7b:	e9 63 01 00 00       	jmp    f0100be3 <mon_showmapping+0x18b>
	if (argc == 2) 
f0100a80:	83 f8 02             	cmp    $0x2,%eax
f0100a83:	75 41                	jne    f0100ac6 <mon_showmapping+0x6e>
	{	
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
f0100a85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100a8c:	00 
f0100a8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0100a90:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a94:	8b 46 04             	mov    0x4(%esi),%eax
f0100a97:	89 04 24             	mov    %eax,(%esp)
f0100a9a:	e8 85 57 00 00       	call   f0106224 <strtol>
f0100a9f:	89 c3                	mov    %eax,%ebx
f0100aa1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		va_end = va_begin;
f0100aa7:	89 df                	mov    %ebx,%edi
		CHECKPARA( *endptrb != '\0');
f0100aa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100aac:	80 38 00             	cmpb   $0x0,(%eax)
f0100aaf:	0f 84 3b 01 00 00    	je     f0100bf0 <mon_showmapping+0x198>
f0100ab5:	c7 04 24 b2 71 10 f0 	movl   $0xf01071b2,(%esp)
f0100abc:	e8 29 38 00 00       	call   f01042ea <cprintf>
f0100ac1:	e9 1d 01 00 00       	jmp    f0100be3 <mon_showmapping+0x18b>

}
int
mon_showmapping(int argc, char **argv, struct Trapframe *tf)
{
	uint32_t va_begin = 0, va_end = 0;
f0100ac6:	bf 00 00 00 00       	mov    $0x0,%edi
f0100acb:	bb 00 00 00 00       	mov    $0x0,%ebx
	{	
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
		va_end = va_begin;
		CHECKPARA( *endptrb != '\0');
	}
	else if (argc == 3) 
f0100ad0:	83 f8 03             	cmp    $0x3,%eax
f0100ad3:	0f 85 17 01 00 00    	jne    f0100bf0 <mon_showmapping+0x198>
	{
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
f0100ad9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100ae0:	00 
f0100ae1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0100ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ae8:	8b 46 04             	mov    0x4(%esi),%eax
f0100aeb:	89 04 24             	mov    %eax,(%esp)
f0100aee:	e8 31 57 00 00       	call   f0106224 <strtol>
f0100af3:	89 c3                	mov    %eax,%ebx
		va_end = ROUNDUP((uint32_t)strtol(argv[2], &endptre, 0),PGSIZE);
f0100af5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100afc:	00 
f0100afd:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100b00:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b04:	8b 46 08             	mov    0x8(%esi),%eax
f0100b07:	89 04 24             	mov    %eax,(%esp)
f0100b0a:	e8 15 57 00 00       	call   f0106224 <strtol>
		CHECKPARA(*endptrb != '\0' || *endptre != '\0');
f0100b0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100b12:	80 3a 00             	cmpb   $0x0,(%edx)
f0100b15:	75 08                	jne    f0100b1f <mon_showmapping+0xc7>
f0100b17:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100b1a:	80 3a 00             	cmpb   $0x0,(%edx)
f0100b1d:	74 11                	je     f0100b30 <mon_showmapping+0xd8>
f0100b1f:	c7 04 24 b2 71 10 f0 	movl   $0xf01071b2,(%esp)
f0100b26:	e8 bf 37 00 00       	call   f01042ea <cprintf>
f0100b2b:	e9 b3 00 00 00       	jmp    f0100be3 <mon_showmapping+0x18b>
		va_end = va_begin;
		CHECKPARA( *endptrb != '\0');
	}
	else if (argc == 3) 
	{
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
f0100b30:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		va_end = ROUNDUP((uint32_t)strtol(argv[2], &endptre, 0),PGSIZE);
f0100b36:	05 ff 0f 00 00       	add    $0xfff,%eax
f0100b3b:	89 c7                	mov    %eax,%edi
f0100b3d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		CHECKPARA(*endptrb != '\0' || *endptre != '\0');
	}
	cprintf("Virtual\tPhysical\tFlags\t\tRefer\n");
f0100b43:	c7 04 24 00 74 10 f0 	movl   $0xf0107400,(%esp)
f0100b4a:	e8 9b 37 00 00       	call   f01042ea <cprintf>
	while(va_begin <= va_end)
f0100b4f:	39 fb                	cmp    %edi,%ebx
f0100b51:	0f 87 8c 00 00 00    	ja     f0100be3 <mon_showmapping+0x18b>
	{
		struct PageInfo *pp;
		pte_t *pteptr;
		char buf[13];
		pp = page_lookup(kern_pgdir, (void *)va_begin, &pteptr);
f0100b57:	8d 75 dc             	lea    -0x24(%ebp),%esi
f0100b5a:	89 74 24 08          	mov    %esi,0x8(%esp)
f0100b5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b62:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0100b67:	89 04 24             	mov    %eax,(%esp)
f0100b6a:	e8 c6 0a 00 00       	call   f0101635 <page_lookup>
		if (pp == NULL || *pteptr ==0)
f0100b6f:	85 c0                	test   %eax,%eax
f0100b71:	74 08                	je     f0100b7b <mon_showmapping+0x123>
f0100b73:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100b76:	83 3a 00             	cmpl   $0x0,(%edx)
f0100b79:	75 2a                	jne    f0100ba5 <mon_showmapping+0x14d>
			cprintf("0x%08x\t%s\t\t%s\t\t%d\n", va_begin, "None", "None", 0);
f0100b7b:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
f0100b82:	00 
f0100b83:	c7 44 24 0c fd 71 10 	movl   $0xf01071fd,0xc(%esp)
f0100b8a:	f0 
f0100b8b:	c7 44 24 08 fd 71 10 	movl   $0xf01071fd,0x8(%esp)
f0100b92:	f0 
f0100b93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b97:	c7 04 24 02 72 10 f0 	movl   $0xf0107202,(%esp)
f0100b9e:	e8 47 37 00 00       	call   f01042ea <cprintf>
f0100ba3:	eb 30                	jmp    f0100bd5 <mon_showmapping+0x17d>
		else
			cprintf("0x%08x\t0x%08x\t%s\t%d\n", va_begin, page2pa(pp),"Flag2Str"/*flag2str(*pteptr, buf)*/, pp->pp_ref );
f0100ba5:	0f b7 50 04          	movzwl 0x4(%eax),%edx
f0100ba9:	89 54 24 10          	mov    %edx,0x10(%esp)
f0100bad:	c7 44 24 0c 15 72 10 	movl   $0xf0107215,0xc(%esp)
f0100bb4:	f0 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bb5:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0100bbb:	c1 f8 03             	sar    $0x3,%eax
f0100bbe:	c1 e0 0c             	shl    $0xc,%eax
f0100bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100bc9:	c7 04 24 1e 72 10 f0 	movl   $0xf010721e,(%esp)
f0100bd0:	e8 15 37 00 00       	call   f01042ea <cprintf>
		va_begin += PGSIZE;
f0100bd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
		va_end = ROUNDUP((uint32_t)strtol(argv[2], &endptre, 0),PGSIZE);
		CHECKPARA(*endptrb != '\0' || *endptre != '\0');
	}
	cprintf("Virtual\tPhysical\tFlags\t\tRefer\n");
	while(va_begin <= va_end)
f0100bdb:	39 df                	cmp    %ebx,%edi
f0100bdd:	0f 83 77 ff ff ff    	jae    f0100b5a <mon_showmapping+0x102>
	
	return 0;
	
	
	
}
f0100be3:	b8 00 00 00 00       	mov    $0x0,%eax
f0100be8:	83 c4 3c             	add    $0x3c,%esp
f0100beb:	5b                   	pop    %ebx
f0100bec:	5e                   	pop    %esi
f0100bed:	5f                   	pop    %edi
f0100bee:	5d                   	pop    %ebp
f0100bef:	c3                   	ret    
	{
		va_begin = ROUNDDOWN((uint32_t)strtol(argv[1], &endptrb, 0),PGSIZE);
		va_end = ROUNDUP((uint32_t)strtol(argv[2], &endptre, 0),PGSIZE);
		CHECKPARA(*endptrb != '\0' || *endptre != '\0');
	}
	cprintf("Virtual\tPhysical\tFlags\t\tRefer\n");
f0100bf0:	c7 04 24 00 74 10 f0 	movl   $0xf0107400,(%esp)
f0100bf7:	e8 ee 36 00 00       	call   f01042ea <cprintf>
f0100bfc:	e9 56 ff ff ff       	jmp    f0100b57 <mon_showmapping+0xff>

f0100c01 <mon_backtrace>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100c01:	55                   	push   %ebp
f0100c02:	89 e5                	mov    %esp,%ebp
f0100c04:	57                   	push   %edi
f0100c05:	56                   	push   %esi
f0100c06:	53                   	push   %ebx
f0100c07:	83 ec 6c             	sub    $0x6c,%esp

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f0100c0a:	89 eb                	mov    %ebp,%ebx
	// Your code here.
	uint32_t * ebp;
	ebp = (uint32_t *)read_ebp();
f0100c0c:	89 de                	mov    %ebx,%esi

	cprintf("Stack backtrace:\n");
f0100c0e:	c7 04 24 33 72 10 f0 	movl   $0xf0107233,(%esp)
f0100c15:	e8 d0 36 00 00       	call   f01042ea <cprintf>
	while(ebp != 0){
f0100c1a:	85 db                	test   %ebx,%ebx
f0100c1c:	0f 84 98 00 00 00    	je     f0100cba <mon_backtrace+0xb9>
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", 
			ebp, (uint32_t *)ebp[1], ebp[2], ebp[3], ebp[4] , ebp[5], ebp[6]);
		struct Eipdebuginfo  dinfo;
		debuginfo_eip((uintptr_t)(uint32_t *)ebp[1], &dinfo);
f0100c22:	8d 7d d0             	lea    -0x30(%ebp),%edi
		char tmpname[30];
		strcpy(tmpname, dinfo.eip_fn_name);
f0100c25:	8d 5d b2             	lea    -0x4e(%ebp),%ebx
	uint32_t * ebp;
	ebp = (uint32_t *)read_ebp();

	cprintf("Stack backtrace:\n");
	while(ebp != 0){
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", 
f0100c28:	8b 46 18             	mov    0x18(%esi),%eax
f0100c2b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100c2f:	8b 46 14             	mov    0x14(%esi),%eax
f0100c32:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100c36:	8b 46 10             	mov    0x10(%esi),%eax
f0100c39:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100c3d:	8b 46 0c             	mov    0xc(%esi),%eax
f0100c40:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100c44:	8b 46 08             	mov    0x8(%esi),%eax
f0100c47:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100c4b:	8b 46 04             	mov    0x4(%esi),%eax
f0100c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c52:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c56:	c7 04 24 20 74 10 f0 	movl   $0xf0107420,(%esp)
f0100c5d:	e8 88 36 00 00       	call   f01042ea <cprintf>
			ebp, (uint32_t *)ebp[1], ebp[2], ebp[3], ebp[4] , ebp[5], ebp[6]);
		struct Eipdebuginfo  dinfo;
		debuginfo_eip((uintptr_t)(uint32_t *)ebp[1], &dinfo);
f0100c62:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100c66:	8b 46 04             	mov    0x4(%esi),%eax
f0100c69:	89 04 24             	mov    %eax,(%esp)
f0100c6c:	e8 ed 48 00 00       	call   f010555e <debuginfo_eip>
		char tmpname[30];
		strcpy(tmpname, dinfo.eip_fn_name);
f0100c71:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100c74:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c78:	89 1c 24             	mov    %ebx,(%esp)
f0100c7b:	e8 9b 52 00 00       	call   f0105f1b <strcpy>
		tmpname[dinfo.eip_fn_namelen] = '\0';
f0100c80:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100c83:	c6 44 05 b2 00       	movb   $0x0,-0x4e(%ebp,%eax,1)
		cprintf("         %s:%d: %s+%u\n", dinfo.eip_file, dinfo.eip_line, tmpname, (uint32_t)ebp[1] - dinfo.eip_fn_addr);
f0100c88:	8b 46 04             	mov    0x4(%esi),%eax
f0100c8b:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c8e:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100c92:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100c96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100c99:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ca4:	c7 04 24 45 72 10 f0 	movl   $0xf0107245,(%esp)
f0100cab:	e8 3a 36 00 00       	call   f01042ea <cprintf>
		ebp = (uint32_t *)ebp[0];
f0100cb0:	8b 36                	mov    (%esi),%esi
	// Your code here.
	uint32_t * ebp;
	ebp = (uint32_t *)read_ebp();

	cprintf("Stack backtrace:\n");
	while(ebp != 0){
f0100cb2:	85 f6                	test   %esi,%esi
f0100cb4:	0f 85 6e ff ff ff    	jne    f0100c28 <mon_backtrace+0x27>
		ebp = (uint32_t *)ebp[0];
		
	}
	return 0;

}
f0100cba:	b8 00 00 00 00       	mov    $0x0,%eax
f0100cbf:	83 c4 6c             	add    $0x6c,%esp
f0100cc2:	5b                   	pop    %ebx
f0100cc3:	5e                   	pop    %esi
f0100cc4:	5f                   	pop    %edi
f0100cc5:	5d                   	pop    %ebp
f0100cc6:	c3                   	ret    

f0100cc7 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100cc7:	55                   	push   %ebp
f0100cc8:	89 e5                	mov    %esp,%ebp
f0100cca:	57                   	push   %edi
f0100ccb:	56                   	push   %esi
f0100ccc:	53                   	push   %ebx
f0100ccd:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100cd0:	c7 04 24 58 74 10 f0 	movl   $0xf0107458,(%esp)
f0100cd7:	e8 0e 36 00 00       	call   f01042ea <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100cdc:	c7 04 24 7c 74 10 f0 	movl   $0xf010747c,(%esp)
f0100ce3:	e8 02 36 00 00       	call   f01042ea <cprintf>

	if (tf != NULL)
f0100ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100cec:	74 0b                	je     f0100cf9 <monitor+0x32>
		print_trapframe(tf);
f0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
f0100cf1:	89 04 24             	mov    %eax,(%esp)
f0100cf4:	e8 62 38 00 00       	call   f010455b <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100cf9:	c7 04 24 5c 72 10 f0 	movl   $0xf010725c,(%esp)
f0100d00:	e8 eb 50 00 00       	call   f0105df0 <readline>
f0100d05:	89 c3                	mov    %eax,%ebx
		
		if (buf != NULL)
f0100d07:	85 c0                	test   %eax,%eax
f0100d09:	74 ee                	je     f0100cf9 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100d0b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100d12:	be 00 00 00 00       	mov    $0x0,%esi
f0100d17:	eb 06                	jmp    f0100d1f <monitor+0x58>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100d19:	c6 03 00             	movb   $0x0,(%ebx)
f0100d1c:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100d1f:	0f b6 03             	movzbl (%ebx),%eax
f0100d22:	84 c0                	test   %al,%al
f0100d24:	74 6a                	je     f0100d90 <monitor+0xc9>
f0100d26:	0f be c0             	movsbl %al,%eax
f0100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d2d:	c7 04 24 60 72 10 f0 	movl   $0xf0107260,(%esp)
f0100d34:	e8 1d 53 00 00       	call   f0106056 <strchr>
f0100d39:	85 c0                	test   %eax,%eax
f0100d3b:	75 dc                	jne    f0100d19 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100d3d:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d40:	74 4e                	je     f0100d90 <monitor+0xc9>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100d42:	83 fe 0f             	cmp    $0xf,%esi
f0100d45:	75 16                	jne    f0100d5d <monitor+0x96>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d47:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100d4e:	00 
f0100d4f:	c7 04 24 65 72 10 f0 	movl   $0xf0107265,(%esp)
f0100d56:	e8 8f 35 00 00       	call   f01042ea <cprintf>
f0100d5b:	eb 9c                	jmp    f0100cf9 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100d5d:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100d61:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d64:	0f b6 03             	movzbl (%ebx),%eax
f0100d67:	84 c0                	test   %al,%al
f0100d69:	75 0c                	jne    f0100d77 <monitor+0xb0>
f0100d6b:	eb b2                	jmp    f0100d1f <monitor+0x58>
			buf++;
f0100d6d:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d70:	0f b6 03             	movzbl (%ebx),%eax
f0100d73:	84 c0                	test   %al,%al
f0100d75:	74 a8                	je     f0100d1f <monitor+0x58>
f0100d77:	0f be c0             	movsbl %al,%eax
f0100d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d7e:	c7 04 24 60 72 10 f0 	movl   $0xf0107260,(%esp)
f0100d85:	e8 cc 52 00 00       	call   f0106056 <strchr>
f0100d8a:	85 c0                	test   %eax,%eax
f0100d8c:	74 df                	je     f0100d6d <monitor+0xa6>
f0100d8e:	eb 8f                	jmp    f0100d1f <monitor+0x58>
			buf++;
	}
	argv[argc] = 0;
f0100d90:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100d97:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100d98:	85 f6                	test   %esi,%esi
f0100d9a:	0f 84 59 ff ff ff    	je     f0100cf9 <monitor+0x32>
f0100da0:	bb e0 75 10 f0       	mov    $0xf01075e0,%ebx
f0100da5:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100daa:	8b 03                	mov    (%ebx),%eax
f0100dac:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100db0:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100db3:	89 04 24             	mov    %eax,(%esp)
f0100db6:	e8 20 52 00 00       	call   f0105fdb <strcmp>
f0100dbb:	85 c0                	test   %eax,%eax
f0100dbd:	75 24                	jne    f0100de3 <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f0100dbf:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100dc2:	8b 55 08             	mov    0x8(%ebp),%edx
f0100dc5:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100dc9:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100dcc:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100dd0:	89 34 24             	mov    %esi,(%esp)
f0100dd3:	ff 14 85 e8 75 10 f0 	call   *-0xfef8a18(,%eax,4)

	while (1) {
		buf = readline("K> ");
		
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100dda:	85 c0                	test   %eax,%eax
f0100ddc:	78 28                	js     f0100e06 <monitor+0x13f>
f0100dde:	e9 16 ff ff ff       	jmp    f0100cf9 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100de3:	83 c7 01             	add    $0x1,%edi
f0100de6:	83 c3 0c             	add    $0xc,%ebx
f0100de9:	83 ff 06             	cmp    $0x6,%edi
f0100dec:	75 bc                	jne    f0100daa <monitor+0xe3>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100dee:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100df1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100df5:	c7 04 24 82 72 10 f0 	movl   $0xf0107282,(%esp)
f0100dfc:	e8 e9 34 00 00       	call   f01042ea <cprintf>
f0100e01:	e9 f3 fe ff ff       	jmp    f0100cf9 <monitor+0x32>
		
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100e06:	83 c4 5c             	add    $0x5c,%esp
f0100e09:	5b                   	pop    %ebx
f0100e0a:	5e                   	pop    %esi
f0100e0b:	5f                   	pop    %edi
f0100e0c:	5d                   	pop    %ebp
f0100e0d:	c3                   	ret    
	...

f0100e10 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100e10:	55                   	push   %ebp
f0100e11:	89 e5                	mov    %esp,%ebp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100e13:	83 3d 3c 52 20 f0 00 	cmpl   $0x0,0xf020523c
f0100e1a:	75 11                	jne    f0100e2d <boot_alloc+0x1d>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e1c:	ba 07 80 24 f0       	mov    $0xf0248007,%edx
f0100e21:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e27:	89 15 3c 52 20 f0    	mov    %edx,0xf020523c
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = ROUNDUP(nextfree, PGSIZE);
f0100e2d:	8b 15 3c 52 20 f0    	mov    0xf020523c,%edx
f0100e33:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e39:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	nextfree = (char*) result + n;
f0100e3f:	01 d0                	add    %edx,%eax
f0100e41:	a3 3c 52 20 f0       	mov    %eax,0xf020523c
	boot_freemem = nextfree;
f0100e46:	a3 40 52 20 f0       	mov    %eax,0xf0205240
	
	

	return result;
}
f0100e4b:	89 d0                	mov    %edx,%eax
f0100e4d:	5d                   	pop    %ebp
f0100e4e:	c3                   	ret    

f0100e4f <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100e4f:	55                   	push   %ebp
f0100e50:	89 e5                	mov    %esp,%ebp
f0100e52:	83 ec 18             	sub    $0x18,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100e55:	89 d1                	mov    %edx,%ecx
f0100e57:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100e5a:	8b 0c 88             	mov    (%eax,%ecx,4),%ecx
		return ~0;
f0100e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f0100e62:	f6 c1 01             	test   $0x1,%cl
f0100e65:	74 57                	je     f0100ebe <check_va2pa+0x6f>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100e67:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100e6d:	89 c8                	mov    %ecx,%eax
f0100e6f:	c1 e8 0c             	shr    $0xc,%eax
f0100e72:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0100e78:	72 20                	jb     f0100e9a <check_va2pa+0x4b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e7a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0100e7e:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0100e85:	f0 
f0100e86:	c7 44 24 04 95 03 00 	movl   $0x395,0x4(%esp)
f0100e8d:	00 
f0100e8e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0100e95:	e8 a6 f1 ff ff       	call   f0100040 <_panic>
	if (!(p[PTX(va)] & PTE_P))
f0100e9a:	c1 ea 0c             	shr    $0xc,%edx
f0100e9d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ea3:	8b 84 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%eax
f0100eaa:	89 c2                	mov    %eax,%edx
f0100eac:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100eaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100eb4:	85 d2                	test   %edx,%edx
f0100eb6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100ebb:	0f 44 c2             	cmove  %edx,%eax
}
f0100ebe:	c9                   	leave  
f0100ebf:	c3                   	ret    

f0100ec0 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100ec0:	55                   	push   %ebp
f0100ec1:	89 e5                	mov    %esp,%ebp
f0100ec3:	83 ec 18             	sub    $0x18,%esp
f0100ec6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100ec9:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100ecc:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100ece:	89 04 24             	mov    %eax,(%esp)
f0100ed1:	e8 aa 32 00 00       	call   f0104180 <mc146818_read>
f0100ed6:	89 c6                	mov    %eax,%esi
f0100ed8:	83 c3 01             	add    $0x1,%ebx
f0100edb:	89 1c 24             	mov    %ebx,(%esp)
f0100ede:	e8 9d 32 00 00       	call   f0104180 <mc146818_read>
f0100ee3:	c1 e0 08             	shl    $0x8,%eax
f0100ee6:	09 f0                	or     %esi,%eax
}
f0100ee8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100eeb:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100eee:	89 ec                	mov    %ebp,%esp
f0100ef0:	5d                   	pop    %ebp
f0100ef1:	c3                   	ret    

f0100ef2 <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0100ef2:	55                   	push   %ebp
f0100ef3:	89 e5                	mov    %esp,%ebp
f0100ef5:	57                   	push   %edi
f0100ef6:	56                   	push   %esi
f0100ef7:	53                   	push   %ebx
f0100ef8:	83 ec 4c             	sub    $0x4c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100efb:	3c 01                	cmp    $0x1,%al
f0100efd:	19 f6                	sbb    %esi,%esi
f0100eff:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f0100f05:	83 c6 01             	add    $0x1,%esi
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0100f08:	8b 1d 44 52 20 f0    	mov    0xf0205244,%ebx
f0100f0e:	85 db                	test   %ebx,%ebx
f0100f10:	75 1c                	jne    f0100f2e <check_page_free_list+0x3c>
		panic("'page_free_list' is a null pointer!");
f0100f12:	c7 44 24 08 28 76 10 	movl   $0xf0107628,0x8(%esp)
f0100f19:	f0 
f0100f1a:	c7 44 24 04 ca 02 00 	movl   $0x2ca,0x4(%esp)
f0100f21:	00 
f0100f22:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0100f29:	e8 12 f1 ff ff       	call   f0100040 <_panic>

	if (only_low_memory) {
f0100f2e:	84 c0                	test   %al,%al
f0100f30:	74 50                	je     f0100f82 <check_page_free_list+0x90>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100f32:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100f35:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100f38:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0100f3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f3e:	89 d8                	mov    %ebx,%eax
f0100f40:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0100f46:	c1 e0 09             	shl    $0x9,%eax
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100f49:	c1 e8 16             	shr    $0x16,%eax
f0100f4c:	39 c6                	cmp    %eax,%esi
f0100f4e:	0f 96 c0             	setbe  %al
f0100f51:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f0100f54:	8b 54 85 d8          	mov    -0x28(%ebp,%eax,4),%edx
f0100f58:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f0100f5a:	89 5c 85 d8          	mov    %ebx,-0x28(%ebp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f5e:	8b 1b                	mov    (%ebx),%ebx
f0100f60:	85 db                	test   %ebx,%ebx
f0100f62:	75 da                	jne    f0100f3e <check_page_free_list+0x4c>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0100f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100f6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100f70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100f73:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100f75:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f78:	89 1d 44 52 20 f0    	mov    %ebx,0xf0205244
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100f7e:	85 db                	test   %ebx,%ebx
f0100f80:	74 67                	je     f0100fe9 <check_page_free_list+0xf7>
f0100f82:	89 d8                	mov    %ebx,%eax
f0100f84:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0100f8a:	c1 f8 03             	sar    $0x3,%eax
f0100f8d:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f90:	89 c2                	mov    %eax,%edx
f0100f92:	c1 ea 16             	shr    $0x16,%edx
f0100f95:	39 d6                	cmp    %edx,%esi
f0100f97:	76 4a                	jbe    f0100fe3 <check_page_free_list+0xf1>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100f99:	89 c2                	mov    %eax,%edx
f0100f9b:	c1 ea 0c             	shr    $0xc,%edx
f0100f9e:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0100fa4:	72 20                	jb     f0100fc6 <check_page_free_list+0xd4>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fa6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100faa:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0100fb1:	f0 
f0100fb2:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0100fb9:	00 
f0100fba:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0100fc1:	e8 7a f0 ff ff       	call   f0100040 <_panic>
			memset(page2kva(pp), 0x97, 128);
f0100fc6:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0100fcd:	00 
f0100fce:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0100fd5:	00 
	return (void *)(pa + KERNBASE);
f0100fd6:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100fdb:	89 04 24             	mov    %eax,(%esp)
f0100fde:	e8 ce 50 00 00       	call   f01060b1 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100fe3:	8b 1b                	mov    (%ebx),%ebx
f0100fe5:	85 db                	test   %ebx,%ebx
f0100fe7:	75 99                	jne    f0100f82 <check_page_free_list+0x90>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0100fe9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fee:	e8 1d fe ff ff       	call   f0100e10 <boot_alloc>
f0100ff3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ff6:	8b 15 44 52 20 f0    	mov    0xf0205244,%edx
f0100ffc:	85 d2                	test   %edx,%edx
f0100ffe:	0f 84 2f 02 00 00    	je     f0101233 <check_page_free_list+0x341>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101004:	8b 1d 90 5e 20 f0    	mov    0xf0205e90,%ebx
f010100a:	39 da                	cmp    %ebx,%edx
f010100c:	72 51                	jb     f010105f <check_page_free_list+0x16d>
		assert(pp < pages + npages);
f010100e:	a1 88 5e 20 f0       	mov    0xf0205e88,%eax
f0101013:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0101016:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
f0101019:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010101c:	39 c2                	cmp    %eax,%edx
f010101e:	73 68                	jae    f0101088 <check_page_free_list+0x196>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101020:	89 5d cc             	mov    %ebx,-0x34(%ebp)
f0101023:	89 d0                	mov    %edx,%eax
f0101025:	29 d8                	sub    %ebx,%eax
f0101027:	a8 07                	test   $0x7,%al
f0101029:	0f 85 86 00 00 00    	jne    f01010b5 <check_page_free_list+0x1c3>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010102f:	c1 f8 03             	sar    $0x3,%eax
f0101032:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101035:	85 c0                	test   %eax,%eax
f0101037:	0f 84 a6 00 00 00    	je     f01010e3 <check_page_free_list+0x1f1>
		assert(page2pa(pp) != IOPHYSMEM);
f010103d:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101042:	0f 84 c6 00 00 00    	je     f010110e <check_page_free_list+0x21c>
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0101048:	be 00 00 00 00       	mov    $0x0,%esi
f010104d:	bf 00 00 00 00       	mov    $0x0,%edi
f0101052:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f0101055:	e9 d8 00 00 00       	jmp    f0101132 <check_page_free_list+0x240>
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010105a:	3b 55 c0             	cmp    -0x40(%ebp),%edx
f010105d:	73 24                	jae    f0101083 <check_page_free_list+0x191>
f010105f:	c7 44 24 0c 07 7f 10 	movl   $0xf0107f07,0xc(%esp)
f0101066:	f0 
f0101067:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010106e:	f0 
f010106f:	c7 44 24 04 e4 02 00 	movl   $0x2e4,0x4(%esp)
f0101076:	00 
f0101077:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010107e:	e8 bd ef ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0101083:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0101086:	72 24                	jb     f01010ac <check_page_free_list+0x1ba>
f0101088:	c7 44 24 0c 28 7f 10 	movl   $0xf0107f28,0xc(%esp)
f010108f:	f0 
f0101090:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101097:	f0 
f0101098:	c7 44 24 04 e5 02 00 	movl   $0x2e5,0x4(%esp)
f010109f:	00 
f01010a0:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01010a7:	e8 94 ef ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01010ac:	89 d0                	mov    %edx,%eax
f01010ae:	2b 45 cc             	sub    -0x34(%ebp),%eax
f01010b1:	a8 07                	test   $0x7,%al
f01010b3:	74 24                	je     f01010d9 <check_page_free_list+0x1e7>
f01010b5:	c7 44 24 0c 4c 76 10 	movl   $0xf010764c,0xc(%esp)
f01010bc:	f0 
f01010bd:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01010c4:	f0 
f01010c5:	c7 44 24 04 e6 02 00 	movl   $0x2e6,0x4(%esp)
f01010cc:	00 
f01010cd:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01010d4:	e8 67 ef ff ff       	call   f0100040 <_panic>
f01010d9:	c1 f8 03             	sar    $0x3,%eax
f01010dc:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f01010df:	85 c0                	test   %eax,%eax
f01010e1:	75 24                	jne    f0101107 <check_page_free_list+0x215>
f01010e3:	c7 44 24 0c 3c 7f 10 	movl   $0xf0107f3c,0xc(%esp)
f01010ea:	f0 
f01010eb:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01010f2:	f0 
f01010f3:	c7 44 24 04 e9 02 00 	movl   $0x2e9,0x4(%esp)
f01010fa:	00 
f01010fb:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101102:	e8 39 ef ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101107:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f010110c:	75 24                	jne    f0101132 <check_page_free_list+0x240>
f010110e:	c7 44 24 0c 4d 7f 10 	movl   $0xf0107f4d,0xc(%esp)
f0101115:	f0 
f0101116:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010111d:	f0 
f010111e:	c7 44 24 04 ea 02 00 	movl   $0x2ea,0x4(%esp)
f0101125:	00 
f0101126:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010112d:	e8 0e ef ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101132:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0101137:	75 24                	jne    f010115d <check_page_free_list+0x26b>
f0101139:	c7 44 24 0c 80 76 10 	movl   $0xf0107680,0xc(%esp)
f0101140:	f0 
f0101141:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101148:	f0 
f0101149:	c7 44 24 04 eb 02 00 	movl   $0x2eb,0x4(%esp)
f0101150:	00 
f0101151:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101158:	e8 e3 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f010115d:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101162:	75 24                	jne    f0101188 <check_page_free_list+0x296>
f0101164:	c7 44 24 0c 66 7f 10 	movl   $0xf0107f66,0xc(%esp)
f010116b:	f0 
f010116c:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101173:	f0 
f0101174:	c7 44 24 04 ec 02 00 	movl   $0x2ec,0x4(%esp)
f010117b:	00 
f010117c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101183:	e8 b8 ee ff ff       	call   f0100040 <_panic>
f0101188:	89 c1                	mov    %eax,%ecx
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f010118a:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f010118f:	76 59                	jbe    f01011ea <check_page_free_list+0x2f8>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101191:	89 c3                	mov    %eax,%ebx
f0101193:	c1 eb 0c             	shr    $0xc,%ebx
f0101196:	39 5d c8             	cmp    %ebx,-0x38(%ebp)
f0101199:	77 20                	ja     f01011bb <check_page_free_list+0x2c9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010119b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010119f:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01011a6:	f0 
f01011a7:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01011ae:	00 
f01011af:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f01011b6:	e8 85 ee ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01011bb:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f01011c1:	39 5d c4             	cmp    %ebx,-0x3c(%ebp)
f01011c4:	76 24                	jbe    f01011ea <check_page_free_list+0x2f8>
f01011c6:	c7 44 24 0c a4 76 10 	movl   $0xf01076a4,0xc(%esp)
f01011cd:	f0 
f01011ce:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01011d5:	f0 
f01011d6:	c7 44 24 04 ed 02 00 	movl   $0x2ed,0x4(%esp)
f01011dd:	00 
f01011de:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01011e5:	e8 56 ee ff ff       	call   f0100040 <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f01011ea:	3d 00 70 00 00       	cmp    $0x7000,%eax
f01011ef:	75 24                	jne    f0101215 <check_page_free_list+0x323>
f01011f1:	c7 44 24 0c 80 7f 10 	movl   $0xf0107f80,0xc(%esp)
f01011f8:	f0 
f01011f9:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101200:	f0 
f0101201:	c7 44 24 04 ef 02 00 	movl   $0x2ef,0x4(%esp)
f0101208:	00 
f0101209:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101210:	e8 2b ee ff ff       	call   f0100040 <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
f0101215:	81 f9 ff ff 0f 00    	cmp    $0xfffff,%ecx
f010121b:	77 05                	ja     f0101222 <check_page_free_list+0x330>
			++nfree_basemem;
f010121d:	83 c7 01             	add    $0x1,%edi
f0101220:	eb 03                	jmp    f0101225 <check_page_free_list+0x333>
		else
			++nfree_extmem;
f0101222:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101225:	8b 12                	mov    (%edx),%edx
f0101227:	85 d2                	test   %edx,%edx
f0101229:	0f 85 2b fe ff ff    	jne    f010105a <check_page_free_list+0x168>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f010122f:	85 ff                	test   %edi,%edi
f0101231:	7f 24                	jg     f0101257 <check_page_free_list+0x365>
f0101233:	c7 44 24 0c 9d 7f 10 	movl   $0xf0107f9d,0xc(%esp)
f010123a:	f0 
f010123b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101242:	f0 
f0101243:	c7 44 24 04 f7 02 00 	movl   $0x2f7,0x4(%esp)
f010124a:	00 
f010124b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101252:	e8 e9 ed ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0101257:	85 f6                	test   %esi,%esi
f0101259:	7f 24                	jg     f010127f <check_page_free_list+0x38d>
f010125b:	c7 44 24 0c af 7f 10 	movl   $0xf0107faf,0xc(%esp)
f0101262:	f0 
f0101263:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010126a:	f0 
f010126b:	c7 44 24 04 f8 02 00 	movl   $0x2f8,0x4(%esp)
f0101272:	00 
f0101273:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010127a:	e8 c1 ed ff ff       	call   f0100040 <_panic>
}
f010127f:	83 c4 4c             	add    $0x4c,%esp
f0101282:	5b                   	pop    %ebx
f0101283:	5e                   	pop    %esi
f0101284:	5f                   	pop    %edi
f0101285:	5d                   	pop    %ebp
f0101286:	c3                   	ret    

f0101287 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0101287:	55                   	push   %ebp
f0101288:	89 e5                	mov    %esp,%ebp
f010128a:	56                   	push   %esi
f010128b:	53                   	push   %ebx
f010128c:	83 ec 10             	sub    $0x10,%esp
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	pages[0].pp_ref = 1;
f010128f:	a1 90 5e 20 f0       	mov    0xf0205e90,%eax
f0101294:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	for( i = 1; i < npages_basemem; i++){
f010129a:	8b 35 38 52 20 f0    	mov    0xf0205238,%esi
f01012a0:	83 fe 01             	cmp    $0x1,%esi
f01012a3:	76 4a                	jbe    f01012ef <page_init+0x68>
f01012a5:	8b 1d 44 52 20 f0    	mov    0xf0205244,%ebx
f01012ab:	b8 01 00 00 00       	mov    $0x1,%eax
		if(i == PGNUM(MPENTRY_PADDR))
f01012b0:	83 f8 07             	cmp    $0x7,%eax
f01012b3:	75 0e                	jne    f01012c3 <page_init+0x3c>
			pages[i].pp_ref = 1;
f01012b5:	8b 15 90 5e 20 f0    	mov    0xf0205e90,%edx
f01012bb:	66 c7 42 3c 01 00    	movw   $0x1,0x3c(%edx)
f01012c1:	eb 1f                	jmp    f01012e2 <page_init+0x5b>
		else{
			pages[i].pp_ref = 0;
f01012c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f01012ca:	8b 0d 90 5e 20 f0    	mov    0xf0205e90,%ecx
f01012d0:	66 c7 44 11 04 00 00 	movw   $0x0,0x4(%ecx,%edx,1)
			pages[i].pp_link = page_free_list;
f01012d7:	89 1c c1             	mov    %ebx,(%ecx,%eax,8)
			page_free_list = &pages[i];
f01012da:	89 d3                	mov    %edx,%ebx
f01012dc:	03 1d 90 5e 20 f0    	add    0xf0205e90,%ebx
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	pages[0].pp_ref = 1;
	for( i = 1; i < npages_basemem; i++){
f01012e2:	83 c0 01             	add    $0x1,%eax
f01012e5:	39 c6                	cmp    %eax,%esi
f01012e7:	77 c7                	ja     f01012b0 <page_init+0x29>
f01012e9:	89 1d 44 52 20 f0    	mov    %ebx,0xf0205244
			pages[i].pp_link = page_free_list;
			page_free_list = &pages[i];
		}
	}
	for( i = PGNUM(IOPHYSMEM); i < PGNUM(EXTPHYSMEM); i++){
		pages[i].pp_ref = 1;
f01012ef:	a1 90 5e 20 f0       	mov    0xf0205e90,%eax
f01012f4:	bb a0 00 00 00       	mov    $0xa0,%ebx
f01012f9:	66 c7 44 d8 04 01 00 	movw   $0x1,0x4(%eax,%ebx,8)
			pages[i].pp_ref = 0;
			pages[i].pp_link = page_free_list;
			page_free_list = &pages[i];
		}
	}
	for( i = PGNUM(IOPHYSMEM); i < PGNUM(EXTPHYSMEM); i++){
f0101300:	83 c3 01             	add    $0x1,%ebx
f0101303:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
f0101309:	75 ee                	jne    f01012f9 <page_init+0x72>
f010130b:	eb 0f                	jmp    f010131c <page_init+0x95>
		pages[i].pp_ref = 1;
	}
	for( i = PGNUM(EXTPHYSMEM); i < PGNUM(PADDR(boot_alloc(0))); i++){
		pages[i].pp_ref = 1;
f010130d:	a1 90 5e 20 f0       	mov    0xf0205e90,%eax
f0101312:	66 c7 44 d8 04 01 00 	movw   $0x1,0x4(%eax,%ebx,8)
		}
	}
	for( i = PGNUM(IOPHYSMEM); i < PGNUM(EXTPHYSMEM); i++){
		pages[i].pp_ref = 1;
	}
	for( i = PGNUM(EXTPHYSMEM); i < PGNUM(PADDR(boot_alloc(0))); i++){
f0101319:	83 c3 01             	add    $0x1,%ebx
f010131c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101321:	e8 ea fa ff ff       	call   f0100e10 <boot_alloc>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101326:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010132b:	77 20                	ja     f010134d <page_init+0xc6>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010132d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101331:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0101338:	f0 
f0101339:	c7 44 24 04 63 01 00 	movl   $0x163,0x4(%esp)
f0101340:	00 
f0101341:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101348:	e8 f3 ec ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010134d:	05 00 00 00 10       	add    $0x10000000,%eax
f0101352:	c1 e8 0c             	shr    $0xc,%eax
f0101355:	39 c3                	cmp    %eax,%ebx
f0101357:	72 b4                	jb     f010130d <page_init+0x86>
		pages[i].pp_ref = 1;
	}
	for( i = PGNUM(PADDR(boot_alloc(0))); i < npages; i++){
f0101359:	b8 00 00 00 00       	mov    $0x0,%eax
f010135e:	e8 ad fa ff ff       	call   f0100e10 <boot_alloc>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101363:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101368:	77 20                	ja     f010138a <page_init+0x103>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010136a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010136e:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0101375:	f0 
f0101376:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
f010137d:	00 
f010137e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101385:	e8 b6 ec ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010138a:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101390:	c1 ea 0c             	shr    $0xc,%edx
f0101393:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0101399:	73 39                	jae    f01013d4 <page_init+0x14d>
f010139b:	8b 1d 44 52 20 f0    	mov    0xf0205244,%ebx
f01013a1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
		pages[i].pp_ref = 0;
f01013a8:	89 c1                	mov    %eax,%ecx
f01013aa:	03 0d 90 5e 20 f0    	add    0xf0205e90,%ecx
f01013b0:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f01013b6:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f01013b8:	89 c3                	mov    %eax,%ebx
f01013ba:	03 1d 90 5e 20 f0    	add    0xf0205e90,%ebx
		pages[i].pp_ref = 1;
	}
	for( i = PGNUM(EXTPHYSMEM); i < PGNUM(PADDR(boot_alloc(0))); i++){
		pages[i].pp_ref = 1;
	}
	for( i = PGNUM(PADDR(boot_alloc(0))); i < npages; i++){
f01013c0:	83 c2 01             	add    $0x1,%edx
f01013c3:	83 c0 08             	add    $0x8,%eax
f01013c6:	39 15 88 5e 20 f0    	cmp    %edx,0xf0205e88
f01013cc:	77 da                	ja     f01013a8 <page_init+0x121>
f01013ce:	89 1d 44 52 20 f0    	mov    %ebx,0xf0205244
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
}
f01013d4:	83 c4 10             	add    $0x10,%esp
f01013d7:	5b                   	pop    %ebx
f01013d8:	5e                   	pop    %esi
f01013d9:	5d                   	pop    %ebp
f01013da:	c3                   	ret    

f01013db <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01013db:	55                   	push   %ebp
f01013dc:	89 e5                	mov    %esp,%ebp
f01013de:	53                   	push   %ebx
f01013df:	83 ec 14             	sub    $0x14,%esp
	// Fill this function in
	if(page_free_list != NULL){
f01013e2:	8b 1d 44 52 20 f0    	mov    0xf0205244,%ebx
f01013e8:	85 db                	test   %ebx,%ebx
f01013ea:	74 65                	je     f0101451 <page_alloc+0x76>
		struct PageInfo * re = page_free_list;
		page_free_list = page_free_list->pp_link;
f01013ec:	8b 03                	mov    (%ebx),%eax
f01013ee:	a3 44 52 20 f0       	mov    %eax,0xf0205244
		if(alloc_flags & ALLOC_ZERO){
f01013f3:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01013f7:	74 58                	je     f0101451 <page_alloc+0x76>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01013f9:	89 d8                	mov    %ebx,%eax
f01013fb:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0101401:	c1 f8 03             	sar    $0x3,%eax
f0101404:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101407:	89 c2                	mov    %eax,%edx
f0101409:	c1 ea 0c             	shr    $0xc,%edx
f010140c:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0101412:	72 20                	jb     f0101434 <page_alloc+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101414:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101418:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f010141f:	f0 
f0101420:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101427:	00 
f0101428:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f010142f:	e8 0c ec ff ff       	call   f0100040 <_panic>
			memset(page2kva(re),'\0',sizeof(char)*PGSIZE);
f0101434:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010143b:	00 
f010143c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101443:	00 
	return (void *)(pa + KERNBASE);
f0101444:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101449:	89 04 24             	mov    %eax,(%esp)
f010144c:	e8 60 4c 00 00       	call   f01060b1 <memset>
		}
		return re;
	}
	return NULL;
}
f0101451:	89 d8                	mov    %ebx,%eax
f0101453:	83 c4 14             	add    $0x14,%esp
f0101456:	5b                   	pop    %ebx
f0101457:	5d                   	pop    %ebp
f0101458:	c3                   	ret    

f0101459 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0101459:	55                   	push   %ebp
f010145a:	89 e5                	mov    %esp,%ebp
f010145c:	8b 45 08             	mov    0x8(%ebp),%eax
	pp->pp_link = page_free_list;
f010145f:	8b 15 44 52 20 f0    	mov    0xf0205244,%edx
f0101465:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101467:	a3 44 52 20 f0       	mov    %eax,0xf0205244
	// Fill this function in
}
f010146c:	5d                   	pop    %ebp
f010146d:	c3                   	ret    

f010146e <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f010146e:	55                   	push   %ebp
f010146f:	89 e5                	mov    %esp,%ebp
f0101471:	83 ec 04             	sub    $0x4,%esp
f0101474:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101477:	0f b7 50 04          	movzwl 0x4(%eax),%edx
f010147b:	83 ea 01             	sub    $0x1,%edx
f010147e:	66 89 50 04          	mov    %dx,0x4(%eax)
f0101482:	66 85 d2             	test   %dx,%dx
f0101485:	75 08                	jne    f010148f <page_decref+0x21>
		page_free(pp);
f0101487:	89 04 24             	mov    %eax,(%esp)
f010148a:	e8 ca ff ff ff       	call   f0101459 <page_free>
}
f010148f:	c9                   	leave  
f0101490:	c3                   	ret    

f0101491 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f0101491:	55                   	push   %ebp
f0101492:	89 e5                	mov    %esp,%ebp
f0101494:	56                   	push   %esi
f0101495:	53                   	push   %ebx
f0101496:	83 ec 10             	sub    $0x10,%esp
f0101499:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in
	pte_t * pt = pgdir + PDX(va);
f010149c:	89 f3                	mov    %esi,%ebx
f010149e:	c1 eb 16             	shr    $0x16,%ebx
f01014a1:	c1 e3 02             	shl    $0x2,%ebx
f01014a4:	03 5d 08             	add    0x8(%ebp),%ebx
	void * pt_kva;
	if(*pt & PTE_P){
f01014a7:	8b 03                	mov    (%ebx),%eax
f01014a9:	a8 01                	test   $0x1,%al
f01014ab:	74 47                	je     f01014f4 <pgdir_walk+0x63>
		pt_kva = (void *)KADDR(PTE_ADDR(*pt));
f01014ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01014b2:	89 c2                	mov    %eax,%edx
f01014b4:	c1 ea 0c             	shr    $0xc,%edx
f01014b7:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f01014bd:	72 20                	jb     f01014df <pgdir_walk+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01014c3:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01014ca:	f0 
f01014cb:	c7 44 24 04 b9 01 00 	movl   $0x1b9,0x4(%esp)
f01014d2:	00 
f01014d3:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01014da:	e8 61 eb ff ff       	call   f0100040 <_panic>
		return (pte_t *)pt_kva + PTX(va);
f01014df:	c1 ee 0a             	shr    $0xa,%esi
f01014e2:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01014e8:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01014ef:	e9 e0 00 00 00       	jmp    f01015d4 <pgdir_walk+0x143>
	}
	struct PageInfo * newpt;
	if(create == 1 && (newpt = page_alloc(ALLOC_ZERO))!=NULL){
f01014f4:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
f01014f8:	0f 85 ca 00 00 00    	jne    f01015c8 <pgdir_walk+0x137>
f01014fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101505:	e8 d1 fe ff ff       	call   f01013db <page_alloc>
f010150a:	85 c0                	test   %eax,%eax
f010150c:	0f 84 bd 00 00 00    	je     f01015cf <pgdir_walk+0x13e>
		newpt -> pp_ref = 1;
f0101512:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101518:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f010151e:	c1 f8 03             	sar    $0x3,%eax
f0101521:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101524:	89 c2                	mov    %eax,%edx
f0101526:	c1 ea 0c             	shr    $0xc,%edx
f0101529:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f010152f:	72 20                	jb     f0101551 <pgdir_walk+0xc0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101531:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101535:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f010153c:	f0 
f010153d:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101544:	00 
f0101545:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f010154c:	e8 ef ea ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0101551:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101557:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010155d:	77 20                	ja     f010157f <pgdir_walk+0xee>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010155f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101563:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f010156a:	f0 
f010156b:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
f0101572:	00 
f0101573:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010157a:	e8 c1 ea ff ff       	call   f0100040 <_panic>
		*pt = PADDR(page2kva(newpt)) | PTE_U | PTE_W | PTE_P;
f010157f:	83 c8 07             	or     $0x7,%eax
f0101582:	89 03                	mov    %eax,(%ebx)
		pt_kva = (void *)KADDR(PTE_ADDR(*pt));
f0101584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101589:	89 c2                	mov    %eax,%edx
f010158b:	c1 ea 0c             	shr    $0xc,%edx
f010158e:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0101594:	72 20                	jb     f01015b6 <pgdir_walk+0x125>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101596:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010159a:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01015a1:	f0 
f01015a2:	c7 44 24 04 c0 01 00 	movl   $0x1c0,0x4(%esp)
f01015a9:	00 
f01015aa:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01015b1:	e8 8a ea ff ff       	call   f0100040 <_panic>
		return (pte_t*)pt_kva + PTX(va);
f01015b6:	c1 ee 0a             	shr    $0xa,%esi
f01015b9:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01015bf:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01015c6:	eb 0c                	jmp    f01015d4 <pgdir_walk+0x143>
	}
	return NULL;
f01015c8:	b8 00 00 00 00       	mov    $0x0,%eax
f01015cd:	eb 05                	jmp    f01015d4 <pgdir_walk+0x143>
f01015cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01015d4:	83 c4 10             	add    $0x10,%esp
f01015d7:	5b                   	pop    %ebx
f01015d8:	5e                   	pop    %esi
f01015d9:	5d                   	pop    %ebp
f01015da:	c3                   	ret    

f01015db <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f01015db:	55                   	push   %ebp
f01015dc:	89 e5                	mov    %esp,%ebp
f01015de:	57                   	push   %edi
f01015df:	56                   	push   %esi
f01015e0:	53                   	push   %ebx
f01015e1:	83 ec 2c             	sub    $0x2c,%esp
f01015e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01015e7:	89 d7                	mov    %edx,%edi
f01015e9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	// Fill this function in
	int offset;
	pte_t * pte;
	for(offset = 0; offset < size; offset += PGSIZE){
f01015ec:	85 c9                	test   %ecx,%ecx
f01015ee:	74 3d                	je     f010162d <boot_map_region+0x52>
f01015f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		pte = pgdir_walk(pgdir, (void*)va, 1);
		*pte = pa | perm | PTE_P;
f01015f5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015f8:	83 c8 01             	or     $0x1,%eax
f01015fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
f01015fe:	8b 75 08             	mov    0x8(%ebp),%esi
f0101601:	01 de                	add    %ebx,%esi
{
	// Fill this function in
	int offset;
	pte_t * pte;
	for(offset = 0; offset < size; offset += PGSIZE){
		pte = pgdir_walk(pgdir, (void*)va, 1);
f0101603:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010160a:	00 
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
f010160b:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
{
	// Fill this function in
	int offset;
	pte_t * pte;
	for(offset = 0; offset < size; offset += PGSIZE){
		pte = pgdir_walk(pgdir, (void*)va, 1);
f010160e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101612:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101615:	89 04 24             	mov    %eax,(%esp)
f0101618:	e8 74 fe ff ff       	call   f0101491 <pgdir_walk>
		*pte = pa | perm | PTE_P;
f010161d:	0b 75 dc             	or     -0x24(%ebp),%esi
f0101620:	89 30                	mov    %esi,(%eax)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	// Fill this function in
	int offset;
	pte_t * pte;
	for(offset = 0; offset < size; offset += PGSIZE){
f0101622:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101628:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f010162b:	77 d1                	ja     f01015fe <boot_map_region+0x23>
		pte = pgdir_walk(pgdir, (void*)va, 1);
		*pte = pa | perm | PTE_P;
		va += PGSIZE;
		pa += PGSIZE;
	}
}
f010162d:	83 c4 2c             	add    $0x2c,%esp
f0101630:	5b                   	pop    %ebx
f0101631:	5e                   	pop    %esi
f0101632:	5f                   	pop    %edi
f0101633:	5d                   	pop    %ebp
f0101634:	c3                   	ret    

f0101635 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0101635:	55                   	push   %ebp
f0101636:	89 e5                	mov    %esp,%ebp
f0101638:	53                   	push   %ebx
f0101639:	83 ec 14             	sub    $0x14,%esp
f010163c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Fill this function in
	pte_t * pte = pgdir_walk(pgdir, va, 0);
f010163f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101646:	00 
f0101647:	8b 45 0c             	mov    0xc(%ebp),%eax
f010164a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010164e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101651:	89 04 24             	mov    %eax,(%esp)
f0101654:	e8 38 fe ff ff       	call   f0101491 <pgdir_walk>
	if(pte_store != 0){
f0101659:	85 db                	test   %ebx,%ebx
f010165b:	74 02                	je     f010165f <page_lookup+0x2a>
		*pte_store = pte;
f010165d:	89 03                	mov    %eax,(%ebx)
	}
	if(pte != NULL && (*pte & PTE_P)){
f010165f:	85 c0                	test   %eax,%eax
f0101661:	74 38                	je     f010169b <page_lookup+0x66>
f0101663:	8b 00                	mov    (%eax),%eax
f0101665:	a8 01                	test   $0x1,%al
f0101667:	74 39                	je     f01016a2 <page_lookup+0x6d>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101669:	c1 e8 0c             	shr    $0xc,%eax
f010166c:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0101672:	72 1c                	jb     f0101690 <page_lookup+0x5b>
		panic("pa2page called with invalid pa");
f0101674:	c7 44 24 08 ec 76 10 	movl   $0xf01076ec,0x8(%esp)
f010167b:	f0 
f010167c:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0101683:	00 
f0101684:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f010168b:	e8 b0 e9 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0101690:	c1 e0 03             	shl    $0x3,%eax
f0101693:	03 05 90 5e 20 f0    	add    0xf0205e90,%eax
		return pa2page (PTE_ADDR (*pte));
f0101699:	eb 0c                	jmp    f01016a7 <page_lookup+0x72>
	}
	return NULL;
f010169b:	b8 00 00 00 00       	mov    $0x0,%eax
f01016a0:	eb 05                	jmp    f01016a7 <page_lookup+0x72>
f01016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01016a7:	83 c4 14             	add    $0x14,%esp
f01016aa:	5b                   	pop    %ebx
f01016ab:	5d                   	pop    %ebp
f01016ac:	c3                   	ret    

f01016ad <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f01016ad:	55                   	push   %ebp
f01016ae:	89 e5                	mov    %esp,%ebp
f01016b0:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f01016b3:	e8 88 50 00 00       	call   f0106740 <cpunum>
f01016b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01016bb:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f01016c2:	74 16                	je     f01016da <tlb_invalidate+0x2d>
f01016c4:	e8 77 50 00 00       	call   f0106740 <cpunum>
f01016c9:	6b c0 74             	imul   $0x74,%eax,%eax
f01016cc:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01016d2:	8b 55 08             	mov    0x8(%ebp),%edx
f01016d5:	39 50 60             	cmp    %edx,0x60(%eax)
f01016d8:	75 06                	jne    f01016e0 <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01016da:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016dd:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f01016e0:	c9                   	leave  
f01016e1:	c3                   	ret    

f01016e2 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f01016e2:	55                   	push   %ebp
f01016e3:	89 e5                	mov    %esp,%ebp
f01016e5:	83 ec 28             	sub    $0x28,%esp
f01016e8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f01016eb:	89 75 fc             	mov    %esi,-0x4(%ebp)
f01016ee:	8b 75 08             	mov    0x8(%ebp),%esi
f01016f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Fill this function in
	pte_t * pte;
	struct PageInfo * physpage = page_lookup (pgdir, va, &pte);
f01016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01016f7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01016fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01016ff:	89 34 24             	mov    %esi,(%esp)
f0101702:	e8 2e ff ff ff       	call   f0101635 <page_lookup>
	if(physpage != NULL){
f0101707:	85 c0                	test   %eax,%eax
f0101709:	74 1d                	je     f0101728 <page_remove+0x46>
		page_decref(physpage);
f010170b:	89 04 24             	mov    %eax,(%esp)
f010170e:	e8 5b fd ff ff       	call   f010146e <page_decref>
		*pte = 0;
f0101713:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f010171c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101720:	89 34 24             	mov    %esi,(%esp)
f0101723:	e8 85 ff ff ff       	call   f01016ad <tlb_invalidate>
	}
}
f0101728:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f010172b:	8b 75 fc             	mov    -0x4(%ebp),%esi
f010172e:	89 ec                	mov    %ebp,%esp
f0101730:	5d                   	pop    %ebp
f0101731:	c3                   	ret    

f0101732 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0101732:	55                   	push   %ebp
f0101733:	89 e5                	mov    %esp,%ebp
f0101735:	83 ec 28             	sub    $0x28,%esp
f0101738:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010173b:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010173e:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0101741:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101744:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Fill this function in
	pte_t * pte = pgdir_walk(pgdir, va, 1);
f0101747:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010174e:	00 
f010174f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101753:	8b 45 08             	mov    0x8(%ebp),%eax
f0101756:	89 04 24             	mov    %eax,(%esp)
f0101759:	e8 33 fd ff ff       	call   f0101491 <pgdir_walk>
f010175e:	89 c3                	mov    %eax,%ebx
	if(pte == NULL){
f0101760:	85 c0                	test   %eax,%eax
f0101762:	74 66                	je     f01017ca <page_insert+0x98>
		return - E_NO_MEM;
	}
	if(*pte & PTE_P){
f0101764:	8b 00                	mov    (%eax),%eax
f0101766:	a8 01                	test   $0x1,%al
f0101768:	74 3c                	je     f01017a6 <page_insert+0x74>
		if(PTE_ADDR(*pte) == page2pa(pp)){
f010176a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010176f:	89 f2                	mov    %esi,%edx
f0101771:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0101777:	c1 fa 03             	sar    $0x3,%edx
f010177a:	c1 e2 0c             	shl    $0xc,%edx
f010177d:	39 d0                	cmp    %edx,%eax
f010177f:	75 16                	jne    f0101797 <page_insert+0x65>
			tlb_invalidate(pgdir, va);
f0101781:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101785:	8b 45 08             	mov    0x8(%ebp),%eax
f0101788:	89 04 24             	mov    %eax,(%esp)
f010178b:	e8 1d ff ff ff       	call   f01016ad <tlb_invalidate>
			pp -> pp_ref --;
f0101790:	66 83 6e 04 01       	subw   $0x1,0x4(%esi)
f0101795:	eb 0f                	jmp    f01017a6 <page_insert+0x74>
		}
		else{
			page_remove(pgdir,va);
f0101797:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010179b:	8b 45 08             	mov    0x8(%ebp),%eax
f010179e:	89 04 24             	mov    %eax,(%esp)
f01017a1:	e8 3c ff ff ff       	call   f01016e2 <page_remove>
		}
	}
	*pte = page2pa(pp) | perm | PTE_P;
f01017a6:	8b 45 14             	mov    0x14(%ebp),%eax
f01017a9:	83 c8 01             	or     $0x1,%eax
f01017ac:	89 f2                	mov    %esi,%edx
f01017ae:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f01017b4:	c1 fa 03             	sar    $0x3,%edx
f01017b7:	c1 e2 0c             	shl    $0xc,%edx
f01017ba:	09 d0                	or     %edx,%eax
f01017bc:	89 03                	mov    %eax,(%ebx)
	pp -> pp_ref ++;
f01017be:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	return 0;
f01017c3:	b8 00 00 00 00       	mov    $0x0,%eax
f01017c8:	eb 05                	jmp    f01017cf <page_insert+0x9d>
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	// Fill this function in
	pte_t * pte = pgdir_walk(pgdir, va, 1);
	if(pte == NULL){
		return - E_NO_MEM;
f01017ca:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
		}
	}
	*pte = page2pa(pp) | perm | PTE_P;
	pp -> pp_ref ++;
	return 0;
}
f01017cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01017d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01017d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01017d8:	89 ec                	mov    %ebp,%esp
f01017da:	5d                   	pop    %ebp
f01017db:	c3                   	ret    

f01017dc <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f01017dc:	55                   	push   %ebp
f01017dd:	89 e5                	mov    %esp,%ebp
f01017df:	53                   	push   %ebx
f01017e0:	83 ec 14             	sub    $0x14,%esp
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
	size_t round_size = ROUNDUP(size, PGSIZE);
f01017e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01017e6:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
f01017ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(base + round_size > MMIOLIM){
f01017f2:	8b 15 00 23 12 f0    	mov    0xf0122300,%edx
f01017f8:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f01017fb:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101800:	76 1c                	jbe    f010181e <mmio_map_region+0x42>
		panic("MMIOLIM exceeded!");
f0101802:	c7 44 24 08 c0 7f 10 	movl   $0xf0107fc0,0x8(%esp)
f0101809:	f0 
f010180a:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
f0101811:	00 
f0101812:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101819:	e8 22 e8 ff ff       	call   f0100040 <_panic>
	}
	boot_map_region(kern_pgdir, base, round_size, pa, PTE_PCD | PTE_PWT | PTE_W);
f010181e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
f0101825:	00 
f0101826:	8b 45 08             	mov    0x8(%ebp),%eax
f0101829:	89 04 24             	mov    %eax,(%esp)
f010182c:	89 d9                	mov    %ebx,%ecx
f010182e:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0101833:	e8 a3 fd ff ff       	call   f01015db <boot_map_region>
	unsigned old_base = (unsigned)base;
f0101838:	a1 00 23 12 f0       	mov    0xf0122300,%eax
	base = base + round_size;
f010183d:	01 c3                	add    %eax,%ebx
f010183f:	89 1d 00 23 12 f0    	mov    %ebx,0xf0122300
	return (void *) old_base;
	
	//panic("mmio_map_region not implemented");
}
f0101845:	83 c4 14             	add    $0x14,%esp
f0101848:	5b                   	pop    %ebx
f0101849:	5d                   	pop    %ebp
f010184a:	c3                   	ret    

f010184b <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f010184b:	55                   	push   %ebp
f010184c:	89 e5                	mov    %esp,%ebp
f010184e:	57                   	push   %edi
f010184f:	56                   	push   %esi
f0101850:	53                   	push   %ebx
f0101851:	83 ec 3c             	sub    $0x3c,%esp
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0101854:	b8 15 00 00 00       	mov    $0x15,%eax
f0101859:	e8 62 f6 ff ff       	call   f0100ec0 <nvram_read>
f010185e:	c1 e0 0a             	shl    $0xa,%eax
f0101861:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101867:	85 c0                	test   %eax,%eax
f0101869:	0f 48 c2             	cmovs  %edx,%eax
f010186c:	c1 f8 0c             	sar    $0xc,%eax
f010186f:	a3 38 52 20 f0       	mov    %eax,0xf0205238
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0101874:	b8 17 00 00 00       	mov    $0x17,%eax
f0101879:	e8 42 f6 ff ff       	call   f0100ec0 <nvram_read>
f010187e:	c1 e0 0a             	shl    $0xa,%eax
f0101881:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101887:	85 c0                	test   %eax,%eax
f0101889:	0f 48 c2             	cmovs  %edx,%eax
f010188c:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f010188f:	85 c0                	test   %eax,%eax
f0101891:	74 0e                	je     f01018a1 <mem_init+0x56>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0101893:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0101899:	89 15 88 5e 20 f0    	mov    %edx,0xf0205e88
f010189f:	eb 0c                	jmp    f01018ad <mem_init+0x62>
	else
		npages = npages_basemem;
f01018a1:	8b 15 38 52 20 f0    	mov    0xf0205238,%edx
f01018a7:	89 15 88 5e 20 f0    	mov    %edx,0xf0205e88

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f01018ad:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01018b0:	c1 e8 0a             	shr    $0xa,%eax
f01018b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f01018b7:	a1 38 52 20 f0       	mov    0xf0205238,%eax
f01018bc:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01018bf:	c1 e8 0a             	shr    $0xa,%eax
f01018c2:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f01018c6:	a1 88 5e 20 f0       	mov    0xf0205e88,%eax
f01018cb:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01018ce:	c1 e8 0a             	shr    $0xa,%eax
f01018d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01018d5:	c7 04 24 0c 77 10 f0 	movl   $0xf010770c,(%esp)
f01018dc:	e8 09 2a 00 00       	call   f01042ea <cprintf>
	// Remove this line when you're ready to test this function.
	//panic("mem_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01018e1:	b8 00 10 00 00       	mov    $0x1000,%eax
f01018e6:	e8 25 f5 ff ff       	call   f0100e10 <boot_alloc>
f01018eb:	a3 8c 5e 20 f0       	mov    %eax,0xf0205e8c
	memset(kern_pgdir, 0, PGSIZE);
f01018f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01018f7:	00 
f01018f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01018ff:	00 
f0101900:	89 04 24             	mov    %eax,(%esp)
f0101903:	e8 a9 47 00 00       	call   f01060b1 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101908:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010190d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101912:	77 20                	ja     f0101934 <mem_init+0xe9>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101914:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101918:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f010191f:	f0 
f0101920:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
f0101927:	00 
f0101928:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010192f:	e8 0c e7 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0101934:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010193a:	83 ca 05             	or     $0x5,%edx
f010193d:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.
	// Your code goes here:
	
	pages = boot_alloc (npages * sizeof(struct PageInfo));
f0101943:	a1 88 5e 20 f0       	mov    0xf0205e88,%eax
f0101948:	c1 e0 03             	shl    $0x3,%eax
f010194b:	e8 c0 f4 ff ff       	call   f0100e10 <boot_alloc>
f0101950:	a3 90 5e 20 f0       	mov    %eax,0xf0205e90

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	
	envs = boot_alloc (NENV * sizeof(struct Env));
f0101955:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f010195a:	e8 b1 f4 ff ff       	call   f0100e10 <boot_alloc>
f010195f:	a3 4c 52 20 f0       	mov    %eax,0xf020524c
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101964:	e8 1e f9 ff ff       	call   f0101287 <page_init>

	check_page_free_list(1);
f0101969:	b8 01 00 00 00       	mov    $0x1,%eax
f010196e:	e8 7f f5 ff ff       	call   f0100ef2 <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101973:	83 3d 90 5e 20 f0 00 	cmpl   $0x0,0xf0205e90
f010197a:	75 1c                	jne    f0101998 <mem_init+0x14d>
		panic("'pages' is a null pointer!");
f010197c:	c7 44 24 08 d2 7f 10 	movl   $0xf0107fd2,0x8(%esp)
f0101983:	f0 
f0101984:	c7 44 24 04 09 03 00 	movl   $0x309,0x4(%esp)
f010198b:	00 
f010198c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101993:	e8 a8 e6 ff ff       	call   f0100040 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101998:	a1 44 52 20 f0       	mov    0xf0205244,%eax
f010199d:	bb 00 00 00 00       	mov    $0x0,%ebx
f01019a2:	85 c0                	test   %eax,%eax
f01019a4:	74 09                	je     f01019af <mem_init+0x164>
		++nfree;
f01019a6:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01019a9:	8b 00                	mov    (%eax),%eax
f01019ab:	85 c0                	test   %eax,%eax
f01019ad:	75 f7                	jne    f01019a6 <mem_init+0x15b>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01019af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019b6:	e8 20 fa ff ff       	call   f01013db <page_alloc>
f01019bb:	89 c6                	mov    %eax,%esi
f01019bd:	85 c0                	test   %eax,%eax
f01019bf:	75 24                	jne    f01019e5 <mem_init+0x19a>
f01019c1:	c7 44 24 0c ed 7f 10 	movl   $0xf0107fed,0xc(%esp)
f01019c8:	f0 
f01019c9:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01019d0:	f0 
f01019d1:	c7 44 24 04 11 03 00 	movl   $0x311,0x4(%esp)
f01019d8:	00 
f01019d9:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01019e0:	e8 5b e6 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01019e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019ec:	e8 ea f9 ff ff       	call   f01013db <page_alloc>
f01019f1:	89 c7                	mov    %eax,%edi
f01019f3:	85 c0                	test   %eax,%eax
f01019f5:	75 24                	jne    f0101a1b <mem_init+0x1d0>
f01019f7:	c7 44 24 0c 03 80 10 	movl   $0xf0108003,0xc(%esp)
f01019fe:	f0 
f01019ff:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101a06:	f0 
f0101a07:	c7 44 24 04 12 03 00 	movl   $0x312,0x4(%esp)
f0101a0e:	00 
f0101a0f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101a16:	e8 25 e6 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101a1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a22:	e8 b4 f9 ff ff       	call   f01013db <page_alloc>
f0101a27:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101a2a:	85 c0                	test   %eax,%eax
f0101a2c:	75 24                	jne    f0101a52 <mem_init+0x207>
f0101a2e:	c7 44 24 0c 19 80 10 	movl   $0xf0108019,0xc(%esp)
f0101a35:	f0 
f0101a36:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101a3d:	f0 
f0101a3e:	c7 44 24 04 13 03 00 	movl   $0x313,0x4(%esp)
f0101a45:	00 
f0101a46:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101a4d:	e8 ee e5 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101a52:	39 fe                	cmp    %edi,%esi
f0101a54:	75 24                	jne    f0101a7a <mem_init+0x22f>
f0101a56:	c7 44 24 0c 2f 80 10 	movl   $0xf010802f,0xc(%esp)
f0101a5d:	f0 
f0101a5e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101a65:	f0 
f0101a66:	c7 44 24 04 16 03 00 	movl   $0x316,0x4(%esp)
f0101a6d:	00 
f0101a6e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101a75:	e8 c6 e5 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a7a:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f0101a7d:	74 05                	je     f0101a84 <mem_init+0x239>
f0101a7f:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
f0101a82:	75 24                	jne    f0101aa8 <mem_init+0x25d>
f0101a84:	c7 44 24 0c 48 77 10 	movl   $0xf0107748,0xc(%esp)
f0101a8b:	f0 
f0101a8c:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101a93:	f0 
f0101a94:	c7 44 24 04 17 03 00 	movl   $0x317,0x4(%esp)
f0101a9b:	00 
f0101a9c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101aa3:	e8 98 e5 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101aa8:	8b 15 90 5e 20 f0    	mov    0xf0205e90,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101aae:	a1 88 5e 20 f0       	mov    0xf0205e88,%eax
f0101ab3:	c1 e0 0c             	shl    $0xc,%eax
f0101ab6:	89 f1                	mov    %esi,%ecx
f0101ab8:	29 d1                	sub    %edx,%ecx
f0101aba:	c1 f9 03             	sar    $0x3,%ecx
f0101abd:	c1 e1 0c             	shl    $0xc,%ecx
f0101ac0:	39 c1                	cmp    %eax,%ecx
f0101ac2:	72 24                	jb     f0101ae8 <mem_init+0x29d>
f0101ac4:	c7 44 24 0c 41 80 10 	movl   $0xf0108041,0xc(%esp)
f0101acb:	f0 
f0101acc:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101ad3:	f0 
f0101ad4:	c7 44 24 04 18 03 00 	movl   $0x318,0x4(%esp)
f0101adb:	00 
f0101adc:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101ae3:	e8 58 e5 ff ff       	call   f0100040 <_panic>
f0101ae8:	89 f9                	mov    %edi,%ecx
f0101aea:	29 d1                	sub    %edx,%ecx
f0101aec:	c1 f9 03             	sar    $0x3,%ecx
f0101aef:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101af2:	39 c8                	cmp    %ecx,%eax
f0101af4:	77 24                	ja     f0101b1a <mem_init+0x2cf>
f0101af6:	c7 44 24 0c 5e 80 10 	movl   $0xf010805e,0xc(%esp)
f0101afd:	f0 
f0101afe:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101b05:	f0 
f0101b06:	c7 44 24 04 19 03 00 	movl   $0x319,0x4(%esp)
f0101b0d:	00 
f0101b0e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101b15:	e8 26 e5 ff ff       	call   f0100040 <_panic>
f0101b1a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101b1d:	29 d1                	sub    %edx,%ecx
f0101b1f:	89 ca                	mov    %ecx,%edx
f0101b21:	c1 fa 03             	sar    $0x3,%edx
f0101b24:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b27:	39 d0                	cmp    %edx,%eax
f0101b29:	77 24                	ja     f0101b4f <mem_init+0x304>
f0101b2b:	c7 44 24 0c 7b 80 10 	movl   $0xf010807b,0xc(%esp)
f0101b32:	f0 
f0101b33:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101b3a:	f0 
f0101b3b:	c7 44 24 04 1a 03 00 	movl   $0x31a,0x4(%esp)
f0101b42:	00 
f0101b43:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101b4a:	e8 f1 e4 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101b4f:	a1 44 52 20 f0       	mov    0xf0205244,%eax
f0101b54:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101b57:	c7 05 44 52 20 f0 00 	movl   $0x0,0xf0205244
f0101b5e:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101b61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b68:	e8 6e f8 ff ff       	call   f01013db <page_alloc>
f0101b6d:	85 c0                	test   %eax,%eax
f0101b6f:	74 24                	je     f0101b95 <mem_init+0x34a>
f0101b71:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f0101b78:	f0 
f0101b79:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101b80:	f0 
f0101b81:	c7 44 24 04 21 03 00 	movl   $0x321,0x4(%esp)
f0101b88:	00 
f0101b89:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101b90:	e8 ab e4 ff ff       	call   f0100040 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101b95:	89 34 24             	mov    %esi,(%esp)
f0101b98:	e8 bc f8 ff ff       	call   f0101459 <page_free>
	page_free(pp1);
f0101b9d:	89 3c 24             	mov    %edi,(%esp)
f0101ba0:	e8 b4 f8 ff ff       	call   f0101459 <page_free>
	page_free(pp2);
f0101ba5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ba8:	89 04 24             	mov    %eax,(%esp)
f0101bab:	e8 a9 f8 ff ff       	call   f0101459 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101bb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101bb7:	e8 1f f8 ff ff       	call   f01013db <page_alloc>
f0101bbc:	89 c6                	mov    %eax,%esi
f0101bbe:	85 c0                	test   %eax,%eax
f0101bc0:	75 24                	jne    f0101be6 <mem_init+0x39b>
f0101bc2:	c7 44 24 0c ed 7f 10 	movl   $0xf0107fed,0xc(%esp)
f0101bc9:	f0 
f0101bca:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101bd1:	f0 
f0101bd2:	c7 44 24 04 28 03 00 	movl   $0x328,0x4(%esp)
f0101bd9:	00 
f0101bda:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101be1:	e8 5a e4 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101be6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101bed:	e8 e9 f7 ff ff       	call   f01013db <page_alloc>
f0101bf2:	89 c7                	mov    %eax,%edi
f0101bf4:	85 c0                	test   %eax,%eax
f0101bf6:	75 24                	jne    f0101c1c <mem_init+0x3d1>
f0101bf8:	c7 44 24 0c 03 80 10 	movl   $0xf0108003,0xc(%esp)
f0101bff:	f0 
f0101c00:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101c07:	f0 
f0101c08:	c7 44 24 04 29 03 00 	movl   $0x329,0x4(%esp)
f0101c0f:	00 
f0101c10:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101c17:	e8 24 e4 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101c1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c23:	e8 b3 f7 ff ff       	call   f01013db <page_alloc>
f0101c28:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101c2b:	85 c0                	test   %eax,%eax
f0101c2d:	75 24                	jne    f0101c53 <mem_init+0x408>
f0101c2f:	c7 44 24 0c 19 80 10 	movl   $0xf0108019,0xc(%esp)
f0101c36:	f0 
f0101c37:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101c3e:	f0 
f0101c3f:	c7 44 24 04 2a 03 00 	movl   $0x32a,0x4(%esp)
f0101c46:	00 
f0101c47:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101c4e:	e8 ed e3 ff ff       	call   f0100040 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101c53:	39 fe                	cmp    %edi,%esi
f0101c55:	75 24                	jne    f0101c7b <mem_init+0x430>
f0101c57:	c7 44 24 0c 2f 80 10 	movl   $0xf010802f,0xc(%esp)
f0101c5e:	f0 
f0101c5f:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101c66:	f0 
f0101c67:	c7 44 24 04 2c 03 00 	movl   $0x32c,0x4(%esp)
f0101c6e:	00 
f0101c6f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101c76:	e8 c5 e3 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c7b:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f0101c7e:	74 05                	je     f0101c85 <mem_init+0x43a>
f0101c80:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
f0101c83:	75 24                	jne    f0101ca9 <mem_init+0x45e>
f0101c85:	c7 44 24 0c 48 77 10 	movl   $0xf0107748,0xc(%esp)
f0101c8c:	f0 
f0101c8d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101c94:	f0 
f0101c95:	c7 44 24 04 2d 03 00 	movl   $0x32d,0x4(%esp)
f0101c9c:	00 
f0101c9d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101ca4:	e8 97 e3 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101ca9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101cb0:	e8 26 f7 ff ff       	call   f01013db <page_alloc>
f0101cb5:	85 c0                	test   %eax,%eax
f0101cb7:	74 24                	je     f0101cdd <mem_init+0x492>
f0101cb9:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f0101cc0:	f0 
f0101cc1:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101cc8:	f0 
f0101cc9:	c7 44 24 04 2e 03 00 	movl   $0x32e,0x4(%esp)
f0101cd0:	00 
f0101cd1:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101cd8:	e8 63 e3 ff ff       	call   f0100040 <_panic>
f0101cdd:	89 f0                	mov    %esi,%eax
f0101cdf:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0101ce5:	c1 f8 03             	sar    $0x3,%eax
f0101ce8:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101ceb:	89 c2                	mov    %eax,%edx
f0101ced:	c1 ea 0c             	shr    $0xc,%edx
f0101cf0:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0101cf6:	72 20                	jb     f0101d18 <mem_init+0x4cd>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101cf8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101cfc:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0101d03:	f0 
f0101d04:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101d0b:	00 
f0101d0c:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0101d13:	e8 28 e3 ff ff       	call   f0100040 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101d18:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101d1f:	00 
f0101d20:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0101d27:	00 
	return (void *)(pa + KERNBASE);
f0101d28:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101d2d:	89 04 24             	mov    %eax,(%esp)
f0101d30:	e8 7c 43 00 00       	call   f01060b1 <memset>
	page_free(pp0);
f0101d35:	89 34 24             	mov    %esi,(%esp)
f0101d38:	e8 1c f7 ff ff       	call   f0101459 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101d3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101d44:	e8 92 f6 ff ff       	call   f01013db <page_alloc>
f0101d49:	85 c0                	test   %eax,%eax
f0101d4b:	75 24                	jne    f0101d71 <mem_init+0x526>
f0101d4d:	c7 44 24 0c a7 80 10 	movl   $0xf01080a7,0xc(%esp)
f0101d54:	f0 
f0101d55:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101d5c:	f0 
f0101d5d:	c7 44 24 04 33 03 00 	movl   $0x333,0x4(%esp)
f0101d64:	00 
f0101d65:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101d6c:	e8 cf e2 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101d71:	39 c6                	cmp    %eax,%esi
f0101d73:	74 24                	je     f0101d99 <mem_init+0x54e>
f0101d75:	c7 44 24 0c c5 80 10 	movl   $0xf01080c5,0xc(%esp)
f0101d7c:	f0 
f0101d7d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101d84:	f0 
f0101d85:	c7 44 24 04 34 03 00 	movl   $0x334,0x4(%esp)
f0101d8c:	00 
f0101d8d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101d94:	e8 a7 e2 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101d99:	89 f2                	mov    %esi,%edx
f0101d9b:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0101da1:	c1 fa 03             	sar    $0x3,%edx
f0101da4:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101da7:	89 d0                	mov    %edx,%eax
f0101da9:	c1 e8 0c             	shr    $0xc,%eax
f0101dac:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0101db2:	72 20                	jb     f0101dd4 <mem_init+0x589>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101db4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101db8:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0101dbf:	f0 
f0101dc0:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101dc7:	00 
f0101dc8:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0101dcf:	e8 6c e2 ff ff       	call   f0100040 <_panic>
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101dd4:	80 ba 00 00 00 f0 00 	cmpb   $0x0,-0x10000000(%edx)
f0101ddb:	75 11                	jne    f0101dee <mem_init+0x5a3>
f0101ddd:	8d 82 01 00 00 f0    	lea    -0xfffffff(%edx),%eax
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0101de3:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101de9:	80 38 00             	cmpb   $0x0,(%eax)
f0101dec:	74 24                	je     f0101e12 <mem_init+0x5c7>
f0101dee:	c7 44 24 0c d5 80 10 	movl   $0xf01080d5,0xc(%esp)
f0101df5:	f0 
f0101df6:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101dfd:	f0 
f0101dfe:	c7 44 24 04 37 03 00 	movl   $0x337,0x4(%esp)
f0101e05:	00 
f0101e06:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101e0d:	e8 2e e2 ff ff       	call   f0100040 <_panic>
f0101e12:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0101e15:	39 d0                	cmp    %edx,%eax
f0101e17:	75 d0                	jne    f0101de9 <mem_init+0x59e>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0101e19:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0101e1c:	89 15 44 52 20 f0    	mov    %edx,0xf0205244

	// free the pages we took
	page_free(pp0);
f0101e22:	89 34 24             	mov    %esi,(%esp)
f0101e25:	e8 2f f6 ff ff       	call   f0101459 <page_free>
	page_free(pp1);
f0101e2a:	89 3c 24             	mov    %edi,(%esp)
f0101e2d:	e8 27 f6 ff ff       	call   f0101459 <page_free>
	page_free(pp2);
f0101e32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e35:	89 04 24             	mov    %eax,(%esp)
f0101e38:	e8 1c f6 ff ff       	call   f0101459 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101e3d:	a1 44 52 20 f0       	mov    0xf0205244,%eax
f0101e42:	85 c0                	test   %eax,%eax
f0101e44:	74 09                	je     f0101e4f <mem_init+0x604>
		--nfree;
f0101e46:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101e49:	8b 00                	mov    (%eax),%eax
f0101e4b:	85 c0                	test   %eax,%eax
f0101e4d:	75 f7                	jne    f0101e46 <mem_init+0x5fb>
		--nfree;
	assert(nfree == 0);
f0101e4f:	85 db                	test   %ebx,%ebx
f0101e51:	74 24                	je     f0101e77 <mem_init+0x62c>
f0101e53:	c7 44 24 0c df 80 10 	movl   $0xf01080df,0xc(%esp)
f0101e5a:	f0 
f0101e5b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101e62:	f0 
f0101e63:	c7 44 24 04 44 03 00 	movl   $0x344,0x4(%esp)
f0101e6a:	00 
f0101e6b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101e72:	e8 c9 e1 ff ff       	call   f0100040 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101e77:	c7 04 24 68 77 10 f0 	movl   $0xf0107768,(%esp)
f0101e7e:	e8 67 24 00 00       	call   f01042ea <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101e83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e8a:	e8 4c f5 ff ff       	call   f01013db <page_alloc>
f0101e8f:	89 c6                	mov    %eax,%esi
f0101e91:	85 c0                	test   %eax,%eax
f0101e93:	75 24                	jne    f0101eb9 <mem_init+0x66e>
f0101e95:	c7 44 24 0c ed 7f 10 	movl   $0xf0107fed,0xc(%esp)
f0101e9c:	f0 
f0101e9d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101ea4:	f0 
f0101ea5:	c7 44 24 04 aa 03 00 	movl   $0x3aa,0x4(%esp)
f0101eac:	00 
f0101ead:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101eb4:	e8 87 e1 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101eb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ec0:	e8 16 f5 ff ff       	call   f01013db <page_alloc>
f0101ec5:	89 c7                	mov    %eax,%edi
f0101ec7:	85 c0                	test   %eax,%eax
f0101ec9:	75 24                	jne    f0101eef <mem_init+0x6a4>
f0101ecb:	c7 44 24 0c 03 80 10 	movl   $0xf0108003,0xc(%esp)
f0101ed2:	f0 
f0101ed3:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101eda:	f0 
f0101edb:	c7 44 24 04 ab 03 00 	movl   $0x3ab,0x4(%esp)
f0101ee2:	00 
f0101ee3:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101eea:	e8 51 e1 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ef6:	e8 e0 f4 ff ff       	call   f01013db <page_alloc>
f0101efb:	89 c3                	mov    %eax,%ebx
f0101efd:	85 c0                	test   %eax,%eax
f0101eff:	75 24                	jne    f0101f25 <mem_init+0x6da>
f0101f01:	c7 44 24 0c 19 80 10 	movl   $0xf0108019,0xc(%esp)
f0101f08:	f0 
f0101f09:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101f10:	f0 
f0101f11:	c7 44 24 04 ac 03 00 	movl   $0x3ac,0x4(%esp)
f0101f18:	00 
f0101f19:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101f20:	e8 1b e1 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101f25:	39 fe                	cmp    %edi,%esi
f0101f27:	75 24                	jne    f0101f4d <mem_init+0x702>
f0101f29:	c7 44 24 0c 2f 80 10 	movl   $0xf010802f,0xc(%esp)
f0101f30:	f0 
f0101f31:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101f38:	f0 
f0101f39:	c7 44 24 04 af 03 00 	movl   $0x3af,0x4(%esp)
f0101f40:	00 
f0101f41:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101f48:	e8 f3 e0 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101f4d:	39 c7                	cmp    %eax,%edi
f0101f4f:	74 04                	je     f0101f55 <mem_init+0x70a>
f0101f51:	39 c6                	cmp    %eax,%esi
f0101f53:	75 24                	jne    f0101f79 <mem_init+0x72e>
f0101f55:	c7 44 24 0c 48 77 10 	movl   $0xf0107748,0xc(%esp)
f0101f5c:	f0 
f0101f5d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101f64:	f0 
f0101f65:	c7 44 24 04 b0 03 00 	movl   $0x3b0,0x4(%esp)
f0101f6c:	00 
f0101f6d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101f74:	e8 c7 e0 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101f79:	8b 15 44 52 20 f0    	mov    0xf0205244,%edx
f0101f7f:	89 55 cc             	mov    %edx,-0x34(%ebp)
	page_free_list = 0;
f0101f82:	c7 05 44 52 20 f0 00 	movl   $0x0,0xf0205244
f0101f89:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101f8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f93:	e8 43 f4 ff ff       	call   f01013db <page_alloc>
f0101f98:	85 c0                	test   %eax,%eax
f0101f9a:	74 24                	je     f0101fc0 <mem_init+0x775>
f0101f9c:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f0101fa3:	f0 
f0101fa4:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101fab:	f0 
f0101fac:	c7 44 24 04 b7 03 00 	movl   $0x3b7,0x4(%esp)
f0101fb3:	00 
f0101fb4:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101fbb:	e8 80 e0 ff ff       	call   f0100040 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101fc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101fc3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101fc7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101fce:	00 
f0101fcf:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0101fd4:	89 04 24             	mov    %eax,(%esp)
f0101fd7:	e8 59 f6 ff ff       	call   f0101635 <page_lookup>
f0101fdc:	85 c0                	test   %eax,%eax
f0101fde:	74 24                	je     f0102004 <mem_init+0x7b9>
f0101fe0:	c7 44 24 0c 88 77 10 	movl   $0xf0107788,0xc(%esp)
f0101fe7:	f0 
f0101fe8:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0101fef:	f0 
f0101ff0:	c7 44 24 04 ba 03 00 	movl   $0x3ba,0x4(%esp)
f0101ff7:	00 
f0101ff8:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0101fff:	e8 3c e0 ff ff       	call   f0100040 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102004:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010200b:	00 
f010200c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102013:	00 
f0102014:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0102018:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010201d:	89 04 24             	mov    %eax,(%esp)
f0102020:	e8 0d f7 ff ff       	call   f0101732 <page_insert>
f0102025:	85 c0                	test   %eax,%eax
f0102027:	78 24                	js     f010204d <mem_init+0x802>
f0102029:	c7 44 24 0c c0 77 10 	movl   $0xf01077c0,0xc(%esp)
f0102030:	f0 
f0102031:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102038:	f0 
f0102039:	c7 44 24 04 bd 03 00 	movl   $0x3bd,0x4(%esp)
f0102040:	00 
f0102041:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102048:	e8 f3 df ff ff       	call   f0100040 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f010204d:	89 34 24             	mov    %esi,(%esp)
f0102050:	e8 04 f4 ff ff       	call   f0101459 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102055:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010205c:	00 
f010205d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102064:	00 
f0102065:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0102069:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010206e:	89 04 24             	mov    %eax,(%esp)
f0102071:	e8 bc f6 ff ff       	call   f0101732 <page_insert>
f0102076:	85 c0                	test   %eax,%eax
f0102078:	74 24                	je     f010209e <mem_init+0x853>
f010207a:	c7 44 24 0c f0 77 10 	movl   $0xf01077f0,0xc(%esp)
f0102081:	f0 
f0102082:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102089:	f0 
f010208a:	c7 44 24 04 c1 03 00 	movl   $0x3c1,0x4(%esp)
f0102091:	00 
f0102092:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102099:	e8 a2 df ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010209e:	8b 0d 8c 5e 20 f0    	mov    0xf0205e8c,%ecx
f01020a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01020a7:	a1 90 5e 20 f0       	mov    0xf0205e90,%eax
f01020ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01020af:	8b 11                	mov    (%ecx),%edx
f01020b1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01020b7:	89 f0                	mov    %esi,%eax
f01020b9:	2b 45 d0             	sub    -0x30(%ebp),%eax
f01020bc:	c1 f8 03             	sar    $0x3,%eax
f01020bf:	c1 e0 0c             	shl    $0xc,%eax
f01020c2:	39 c2                	cmp    %eax,%edx
f01020c4:	74 24                	je     f01020ea <mem_init+0x89f>
f01020c6:	c7 44 24 0c 20 78 10 	movl   $0xf0107820,0xc(%esp)
f01020cd:	f0 
f01020ce:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01020d5:	f0 
f01020d6:	c7 44 24 04 c2 03 00 	movl   $0x3c2,0x4(%esp)
f01020dd:	00 
f01020de:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01020e5:	e8 56 df ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01020ea:	ba 00 00 00 00       	mov    $0x0,%edx
f01020ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020f2:	e8 58 ed ff ff       	call   f0100e4f <check_va2pa>
f01020f7:	89 fa                	mov    %edi,%edx
f01020f9:	2b 55 d0             	sub    -0x30(%ebp),%edx
f01020fc:	c1 fa 03             	sar    $0x3,%edx
f01020ff:	c1 e2 0c             	shl    $0xc,%edx
f0102102:	39 d0                	cmp    %edx,%eax
f0102104:	74 24                	je     f010212a <mem_init+0x8df>
f0102106:	c7 44 24 0c 48 78 10 	movl   $0xf0107848,0xc(%esp)
f010210d:	f0 
f010210e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102115:	f0 
f0102116:	c7 44 24 04 c3 03 00 	movl   $0x3c3,0x4(%esp)
f010211d:	00 
f010211e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102125:	e8 16 df ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010212a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010212f:	74 24                	je     f0102155 <mem_init+0x90a>
f0102131:	c7 44 24 0c ea 80 10 	movl   $0xf01080ea,0xc(%esp)
f0102138:	f0 
f0102139:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102140:	f0 
f0102141:	c7 44 24 04 c4 03 00 	movl   $0x3c4,0x4(%esp)
f0102148:	00 
f0102149:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102150:	e8 eb de ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102155:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010215a:	74 24                	je     f0102180 <mem_init+0x935>
f010215c:	c7 44 24 0c fb 80 10 	movl   $0xf01080fb,0xc(%esp)
f0102163:	f0 
f0102164:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010216b:	f0 
f010216c:	c7 44 24 04 c5 03 00 	movl   $0x3c5,0x4(%esp)
f0102173:	00 
f0102174:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010217b:	e8 c0 de ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102180:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102187:	00 
f0102188:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010218f:	00 
f0102190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102194:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102197:	89 14 24             	mov    %edx,(%esp)
f010219a:	e8 93 f5 ff ff       	call   f0101732 <page_insert>
f010219f:	85 c0                	test   %eax,%eax
f01021a1:	74 24                	je     f01021c7 <mem_init+0x97c>
f01021a3:	c7 44 24 0c 78 78 10 	movl   $0xf0107878,0xc(%esp)
f01021aa:	f0 
f01021ab:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01021b2:	f0 
f01021b3:	c7 44 24 04 c8 03 00 	movl   $0x3c8,0x4(%esp)
f01021ba:	00 
f01021bb:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01021c2:	e8 79 de ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01021c7:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021cc:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01021d1:	e8 79 ec ff ff       	call   f0100e4f <check_va2pa>
f01021d6:	89 da                	mov    %ebx,%edx
f01021d8:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f01021de:	c1 fa 03             	sar    $0x3,%edx
f01021e1:	c1 e2 0c             	shl    $0xc,%edx
f01021e4:	39 d0                	cmp    %edx,%eax
f01021e6:	74 24                	je     f010220c <mem_init+0x9c1>
f01021e8:	c7 44 24 0c b4 78 10 	movl   $0xf01078b4,0xc(%esp)
f01021ef:	f0 
f01021f0:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01021f7:	f0 
f01021f8:	c7 44 24 04 c9 03 00 	movl   $0x3c9,0x4(%esp)
f01021ff:	00 
f0102200:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102207:	e8 34 de ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010220c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102211:	74 24                	je     f0102237 <mem_init+0x9ec>
f0102213:	c7 44 24 0c 0c 81 10 	movl   $0xf010810c,0xc(%esp)
f010221a:	f0 
f010221b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102222:	f0 
f0102223:	c7 44 24 04 ca 03 00 	movl   $0x3ca,0x4(%esp)
f010222a:	00 
f010222b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102232:	e8 09 de ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102237:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010223e:	e8 98 f1 ff ff       	call   f01013db <page_alloc>
f0102243:	85 c0                	test   %eax,%eax
f0102245:	74 24                	je     f010226b <mem_init+0xa20>
f0102247:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f010224e:	f0 
f010224f:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102256:	f0 
f0102257:	c7 44 24 04 cd 03 00 	movl   $0x3cd,0x4(%esp)
f010225e:	00 
f010225f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102266:	e8 d5 dd ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010226b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102272:	00 
f0102273:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010227a:	00 
f010227b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010227f:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102284:	89 04 24             	mov    %eax,(%esp)
f0102287:	e8 a6 f4 ff ff       	call   f0101732 <page_insert>
f010228c:	85 c0                	test   %eax,%eax
f010228e:	74 24                	je     f01022b4 <mem_init+0xa69>
f0102290:	c7 44 24 0c 78 78 10 	movl   $0xf0107878,0xc(%esp)
f0102297:	f0 
f0102298:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010229f:	f0 
f01022a0:	c7 44 24 04 d0 03 00 	movl   $0x3d0,0x4(%esp)
f01022a7:	00 
f01022a8:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01022af:	e8 8c dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01022b4:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022b9:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01022be:	e8 8c eb ff ff       	call   f0100e4f <check_va2pa>
f01022c3:	89 da                	mov    %ebx,%edx
f01022c5:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f01022cb:	c1 fa 03             	sar    $0x3,%edx
f01022ce:	c1 e2 0c             	shl    $0xc,%edx
f01022d1:	39 d0                	cmp    %edx,%eax
f01022d3:	74 24                	je     f01022f9 <mem_init+0xaae>
f01022d5:	c7 44 24 0c b4 78 10 	movl   $0xf01078b4,0xc(%esp)
f01022dc:	f0 
f01022dd:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01022e4:	f0 
f01022e5:	c7 44 24 04 d1 03 00 	movl   $0x3d1,0x4(%esp)
f01022ec:	00 
f01022ed:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01022f4:	e8 47 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01022f9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01022fe:	74 24                	je     f0102324 <mem_init+0xad9>
f0102300:	c7 44 24 0c 0c 81 10 	movl   $0xf010810c,0xc(%esp)
f0102307:	f0 
f0102308:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010230f:	f0 
f0102310:	c7 44 24 04 d2 03 00 	movl   $0x3d2,0x4(%esp)
f0102317:	00 
f0102318:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010231f:	e8 1c dd ff ff       	call   f0100040 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010232b:	e8 ab f0 ff ff       	call   f01013db <page_alloc>
f0102330:	85 c0                	test   %eax,%eax
f0102332:	74 24                	je     f0102358 <mem_init+0xb0d>
f0102334:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f010233b:	f0 
f010233c:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102343:	f0 
f0102344:	c7 44 24 04 d6 03 00 	movl   $0x3d6,0x4(%esp)
f010234b:	00 
f010234c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102353:	e8 e8 dc ff ff       	call   f0100040 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102358:	8b 15 8c 5e 20 f0    	mov    0xf0205e8c,%edx
f010235e:	8b 02                	mov    (%edx),%eax
f0102360:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102365:	89 c1                	mov    %eax,%ecx
f0102367:	c1 e9 0c             	shr    $0xc,%ecx
f010236a:	3b 0d 88 5e 20 f0    	cmp    0xf0205e88,%ecx
f0102370:	72 20                	jb     f0102392 <mem_init+0xb47>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102372:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102376:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f010237d:	f0 
f010237e:	c7 44 24 04 d9 03 00 	movl   $0x3d9,0x4(%esp)
f0102385:	00 
f0102386:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010238d:	e8 ae dc ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102392:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010239a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01023a1:	00 
f01023a2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01023a9:	00 
f01023aa:	89 14 24             	mov    %edx,(%esp)
f01023ad:	e8 df f0 ff ff       	call   f0101491 <pgdir_walk>
f01023b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01023b5:	83 c2 04             	add    $0x4,%edx
f01023b8:	39 d0                	cmp    %edx,%eax
f01023ba:	74 24                	je     f01023e0 <mem_init+0xb95>
f01023bc:	c7 44 24 0c e4 78 10 	movl   $0xf01078e4,0xc(%esp)
f01023c3:	f0 
f01023c4:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01023cb:	f0 
f01023cc:	c7 44 24 04 da 03 00 	movl   $0x3da,0x4(%esp)
f01023d3:	00 
f01023d4:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01023db:	e8 60 dc ff ff       	call   f0100040 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01023e0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f01023e7:	00 
f01023e8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01023ef:	00 
f01023f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01023f4:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01023f9:	89 04 24             	mov    %eax,(%esp)
f01023fc:	e8 31 f3 ff ff       	call   f0101732 <page_insert>
f0102401:	85 c0                	test   %eax,%eax
f0102403:	74 24                	je     f0102429 <mem_init+0xbde>
f0102405:	c7 44 24 0c 24 79 10 	movl   $0xf0107924,0xc(%esp)
f010240c:	f0 
f010240d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102414:	f0 
f0102415:	c7 44 24 04 dd 03 00 	movl   $0x3dd,0x4(%esp)
f010241c:	00 
f010241d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102424:	e8 17 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102429:	8b 0d 8c 5e 20 f0    	mov    0xf0205e8c,%ecx
f010242f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0102432:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102437:	89 c8                	mov    %ecx,%eax
f0102439:	e8 11 ea ff ff       	call   f0100e4f <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010243e:	89 da                	mov    %ebx,%edx
f0102440:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0102446:	c1 fa 03             	sar    $0x3,%edx
f0102449:	c1 e2 0c             	shl    $0xc,%edx
f010244c:	39 d0                	cmp    %edx,%eax
f010244e:	74 24                	je     f0102474 <mem_init+0xc29>
f0102450:	c7 44 24 0c b4 78 10 	movl   $0xf01078b4,0xc(%esp)
f0102457:	f0 
f0102458:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010245f:	f0 
f0102460:	c7 44 24 04 de 03 00 	movl   $0x3de,0x4(%esp)
f0102467:	00 
f0102468:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010246f:	e8 cc db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102474:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102479:	74 24                	je     f010249f <mem_init+0xc54>
f010247b:	c7 44 24 0c 0c 81 10 	movl   $0xf010810c,0xc(%esp)
f0102482:	f0 
f0102483:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010248a:	f0 
f010248b:	c7 44 24 04 df 03 00 	movl   $0x3df,0x4(%esp)
f0102492:	00 
f0102493:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010249a:	e8 a1 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010249f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01024a6:	00 
f01024a7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01024ae:	00 
f01024af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01024b2:	89 04 24             	mov    %eax,(%esp)
f01024b5:	e8 d7 ef ff ff       	call   f0101491 <pgdir_walk>
f01024ba:	f6 00 04             	testb  $0x4,(%eax)
f01024bd:	75 24                	jne    f01024e3 <mem_init+0xc98>
f01024bf:	c7 44 24 0c 64 79 10 	movl   $0xf0107964,0xc(%esp)
f01024c6:	f0 
f01024c7:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01024ce:	f0 
f01024cf:	c7 44 24 04 e0 03 00 	movl   $0x3e0,0x4(%esp)
f01024d6:	00 
f01024d7:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01024de:	e8 5d db ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01024e3:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01024e8:	f6 00 04             	testb  $0x4,(%eax)
f01024eb:	75 24                	jne    f0102511 <mem_init+0xcc6>
f01024ed:	c7 44 24 0c 1d 81 10 	movl   $0xf010811d,0xc(%esp)
f01024f4:	f0 
f01024f5:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01024fc:	f0 
f01024fd:	c7 44 24 04 e1 03 00 	movl   $0x3e1,0x4(%esp)
f0102504:	00 
f0102505:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010250c:	e8 2f db ff ff       	call   f0100040 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102511:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102518:	00 
f0102519:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102520:	00 
f0102521:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102525:	89 04 24             	mov    %eax,(%esp)
f0102528:	e8 05 f2 ff ff       	call   f0101732 <page_insert>
f010252d:	85 c0                	test   %eax,%eax
f010252f:	74 24                	je     f0102555 <mem_init+0xd0a>
f0102531:	c7 44 24 0c 78 78 10 	movl   $0xf0107878,0xc(%esp)
f0102538:	f0 
f0102539:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102540:	f0 
f0102541:	c7 44 24 04 e4 03 00 	movl   $0x3e4,0x4(%esp)
f0102548:	00 
f0102549:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102550:	e8 eb da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102555:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010255c:	00 
f010255d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102564:	00 
f0102565:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010256a:	89 04 24             	mov    %eax,(%esp)
f010256d:	e8 1f ef ff ff       	call   f0101491 <pgdir_walk>
f0102572:	f6 00 02             	testb  $0x2,(%eax)
f0102575:	75 24                	jne    f010259b <mem_init+0xd50>
f0102577:	c7 44 24 0c 98 79 10 	movl   $0xf0107998,0xc(%esp)
f010257e:	f0 
f010257f:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102586:	f0 
f0102587:	c7 44 24 04 e5 03 00 	movl   $0x3e5,0x4(%esp)
f010258e:	00 
f010258f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102596:	e8 a5 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010259b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01025a2:	00 
f01025a3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01025aa:	00 
f01025ab:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01025b0:	89 04 24             	mov    %eax,(%esp)
f01025b3:	e8 d9 ee ff ff       	call   f0101491 <pgdir_walk>
f01025b8:	f6 00 04             	testb  $0x4,(%eax)
f01025bb:	74 24                	je     f01025e1 <mem_init+0xd96>
f01025bd:	c7 44 24 0c cc 79 10 	movl   $0xf01079cc,0xc(%esp)
f01025c4:	f0 
f01025c5:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01025cc:	f0 
f01025cd:	c7 44 24 04 e6 03 00 	movl   $0x3e6,0x4(%esp)
f01025d4:	00 
f01025d5:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01025dc:	e8 5f da ff ff       	call   f0100040 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01025e1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01025e8:	00 
f01025e9:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f01025f0:	00 
f01025f1:	89 74 24 04          	mov    %esi,0x4(%esp)
f01025f5:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01025fa:	89 04 24             	mov    %eax,(%esp)
f01025fd:	e8 30 f1 ff ff       	call   f0101732 <page_insert>
f0102602:	85 c0                	test   %eax,%eax
f0102604:	78 24                	js     f010262a <mem_init+0xddf>
f0102606:	c7 44 24 0c 04 7a 10 	movl   $0xf0107a04,0xc(%esp)
f010260d:	f0 
f010260e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102615:	f0 
f0102616:	c7 44 24 04 e9 03 00 	movl   $0x3e9,0x4(%esp)
f010261d:	00 
f010261e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102625:	e8 16 da ff ff       	call   f0100040 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010262a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102631:	00 
f0102632:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102639:	00 
f010263a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010263e:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102643:	89 04 24             	mov    %eax,(%esp)
f0102646:	e8 e7 f0 ff ff       	call   f0101732 <page_insert>
f010264b:	85 c0                	test   %eax,%eax
f010264d:	74 24                	je     f0102673 <mem_init+0xe28>
f010264f:	c7 44 24 0c 3c 7a 10 	movl   $0xf0107a3c,0xc(%esp)
f0102656:	f0 
f0102657:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010265e:	f0 
f010265f:	c7 44 24 04 ec 03 00 	movl   $0x3ec,0x4(%esp)
f0102666:	00 
f0102667:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010266e:	e8 cd d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102673:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010267a:	00 
f010267b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102682:	00 
f0102683:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102688:	89 04 24             	mov    %eax,(%esp)
f010268b:	e8 01 ee ff ff       	call   f0101491 <pgdir_walk>
f0102690:	f6 00 04             	testb  $0x4,(%eax)
f0102693:	74 24                	je     f01026b9 <mem_init+0xe6e>
f0102695:	c7 44 24 0c cc 79 10 	movl   $0xf01079cc,0xc(%esp)
f010269c:	f0 
f010269d:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01026a4:	f0 
f01026a5:	c7 44 24 04 ed 03 00 	movl   $0x3ed,0x4(%esp)
f01026ac:	00 
f01026ad:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01026b4:	e8 87 d9 ff ff       	call   f0100040 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01026b9:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01026be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01026c1:	ba 00 00 00 00       	mov    $0x0,%edx
f01026c6:	e8 84 e7 ff ff       	call   f0100e4f <check_va2pa>
f01026cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01026ce:	89 f8                	mov    %edi,%eax
f01026d0:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f01026d6:	c1 f8 03             	sar    $0x3,%eax
f01026d9:	c1 e0 0c             	shl    $0xc,%eax
f01026dc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01026df:	74 24                	je     f0102705 <mem_init+0xeba>
f01026e1:	c7 44 24 0c 78 7a 10 	movl   $0xf0107a78,0xc(%esp)
f01026e8:	f0 
f01026e9:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01026f0:	f0 
f01026f1:	c7 44 24 04 f0 03 00 	movl   $0x3f0,0x4(%esp)
f01026f8:	00 
f01026f9:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102700:	e8 3b d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102705:	ba 00 10 00 00       	mov    $0x1000,%edx
f010270a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010270d:	e8 3d e7 ff ff       	call   f0100e4f <check_va2pa>
f0102712:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102715:	74 24                	je     f010273b <mem_init+0xef0>
f0102717:	c7 44 24 0c a4 7a 10 	movl   $0xf0107aa4,0xc(%esp)
f010271e:	f0 
f010271f:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102726:	f0 
f0102727:	c7 44 24 04 f1 03 00 	movl   $0x3f1,0x4(%esp)
f010272e:	00 
f010272f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102736:	e8 05 d9 ff ff       	call   f0100040 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f010273b:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0102740:	74 24                	je     f0102766 <mem_init+0xf1b>
f0102742:	c7 44 24 0c 33 81 10 	movl   $0xf0108133,0xc(%esp)
f0102749:	f0 
f010274a:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102751:	f0 
f0102752:	c7 44 24 04 f3 03 00 	movl   $0x3f3,0x4(%esp)
f0102759:	00 
f010275a:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102761:	e8 da d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102766:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010276b:	74 24                	je     f0102791 <mem_init+0xf46>
f010276d:	c7 44 24 0c 44 81 10 	movl   $0xf0108144,0xc(%esp)
f0102774:	f0 
f0102775:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010277c:	f0 
f010277d:	c7 44 24 04 f4 03 00 	movl   $0x3f4,0x4(%esp)
f0102784:	00 
f0102785:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010278c:	e8 af d8 ff ff       	call   f0100040 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102791:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102798:	e8 3e ec ff ff       	call   f01013db <page_alloc>
f010279d:	85 c0                	test   %eax,%eax
f010279f:	74 04                	je     f01027a5 <mem_init+0xf5a>
f01027a1:	39 c3                	cmp    %eax,%ebx
f01027a3:	74 24                	je     f01027c9 <mem_init+0xf7e>
f01027a5:	c7 44 24 0c d4 7a 10 	movl   $0xf0107ad4,0xc(%esp)
f01027ac:	f0 
f01027ad:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01027b4:	f0 
f01027b5:	c7 44 24 04 f7 03 00 	movl   $0x3f7,0x4(%esp)
f01027bc:	00 
f01027bd:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01027c4:	e8 77 d8 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01027c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01027d0:	00 
f01027d1:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01027d6:	89 04 24             	mov    %eax,(%esp)
f01027d9:	e8 04 ef ff ff       	call   f01016e2 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027de:	8b 15 8c 5e 20 f0    	mov    0xf0205e8c,%edx
f01027e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01027e7:	ba 00 00 00 00       	mov    $0x0,%edx
f01027ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01027ef:	e8 5b e6 ff ff       	call   f0100e4f <check_va2pa>
f01027f4:	83 f8 ff             	cmp    $0xffffffff,%eax
f01027f7:	74 24                	je     f010281d <mem_init+0xfd2>
f01027f9:	c7 44 24 0c f8 7a 10 	movl   $0xf0107af8,0xc(%esp)
f0102800:	f0 
f0102801:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102808:	f0 
f0102809:	c7 44 24 04 fb 03 00 	movl   $0x3fb,0x4(%esp)
f0102810:	00 
f0102811:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102818:	e8 23 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010281d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102825:	e8 25 e6 ff ff       	call   f0100e4f <check_va2pa>
f010282a:	89 fa                	mov    %edi,%edx
f010282c:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0102832:	c1 fa 03             	sar    $0x3,%edx
f0102835:	c1 e2 0c             	shl    $0xc,%edx
f0102838:	39 d0                	cmp    %edx,%eax
f010283a:	74 24                	je     f0102860 <mem_init+0x1015>
f010283c:	c7 44 24 0c a4 7a 10 	movl   $0xf0107aa4,0xc(%esp)
f0102843:	f0 
f0102844:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010284b:	f0 
f010284c:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0102853:	00 
f0102854:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010285b:	e8 e0 d7 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102860:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102865:	74 24                	je     f010288b <mem_init+0x1040>
f0102867:	c7 44 24 0c ea 80 10 	movl   $0xf01080ea,0xc(%esp)
f010286e:	f0 
f010286f:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102876:	f0 
f0102877:	c7 44 24 04 fd 03 00 	movl   $0x3fd,0x4(%esp)
f010287e:	00 
f010287f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102886:	e8 b5 d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010288b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102890:	74 24                	je     f01028b6 <mem_init+0x106b>
f0102892:	c7 44 24 0c 44 81 10 	movl   $0xf0108144,0xc(%esp)
f0102899:	f0 
f010289a:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01028a1:	f0 
f01028a2:	c7 44 24 04 fe 03 00 	movl   $0x3fe,0x4(%esp)
f01028a9:	00 
f01028aa:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01028b1:	e8 8a d7 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01028b6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01028bd:	00 
f01028be:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01028c1:	89 0c 24             	mov    %ecx,(%esp)
f01028c4:	e8 19 ee ff ff       	call   f01016e2 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01028c9:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01028ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01028d1:	ba 00 00 00 00       	mov    $0x0,%edx
f01028d6:	e8 74 e5 ff ff       	call   f0100e4f <check_va2pa>
f01028db:	83 f8 ff             	cmp    $0xffffffff,%eax
f01028de:	74 24                	je     f0102904 <mem_init+0x10b9>
f01028e0:	c7 44 24 0c f8 7a 10 	movl   $0xf0107af8,0xc(%esp)
f01028e7:	f0 
f01028e8:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01028ef:	f0 
f01028f0:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
f01028f7:	00 
f01028f8:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01028ff:	e8 3c d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102904:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010290c:	e8 3e e5 ff ff       	call   f0100e4f <check_va2pa>
f0102911:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102914:	74 24                	je     f010293a <mem_init+0x10ef>
f0102916:	c7 44 24 0c 1c 7b 10 	movl   $0xf0107b1c,0xc(%esp)
f010291d:	f0 
f010291e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102925:	f0 
f0102926:	c7 44 24 04 03 04 00 	movl   $0x403,0x4(%esp)
f010292d:	00 
f010292e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102935:	e8 06 d7 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f010293a:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010293f:	74 24                	je     f0102965 <mem_init+0x111a>
f0102941:	c7 44 24 0c 55 81 10 	movl   $0xf0108155,0xc(%esp)
f0102948:	f0 
f0102949:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102950:	f0 
f0102951:	c7 44 24 04 04 04 00 	movl   $0x404,0x4(%esp)
f0102958:	00 
f0102959:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102960:	e8 db d6 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102965:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010296a:	74 24                	je     f0102990 <mem_init+0x1145>
f010296c:	c7 44 24 0c 44 81 10 	movl   $0xf0108144,0xc(%esp)
f0102973:	f0 
f0102974:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010297b:	f0 
f010297c:	c7 44 24 04 05 04 00 	movl   $0x405,0x4(%esp)
f0102983:	00 
f0102984:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010298b:	e8 b0 d6 ff ff       	call   f0100040 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102990:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102997:	e8 3f ea ff ff       	call   f01013db <page_alloc>
f010299c:	85 c0                	test   %eax,%eax
f010299e:	74 04                	je     f01029a4 <mem_init+0x1159>
f01029a0:	39 c7                	cmp    %eax,%edi
f01029a2:	74 24                	je     f01029c8 <mem_init+0x117d>
f01029a4:	c7 44 24 0c 44 7b 10 	movl   $0xf0107b44,0xc(%esp)
f01029ab:	f0 
f01029ac:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01029b3:	f0 
f01029b4:	c7 44 24 04 08 04 00 	movl   $0x408,0x4(%esp)
f01029bb:	00 
f01029bc:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01029c3:	e8 78 d6 ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01029c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01029cf:	e8 07 ea ff ff       	call   f01013db <page_alloc>
f01029d4:	85 c0                	test   %eax,%eax
f01029d6:	74 24                	je     f01029fc <mem_init+0x11b1>
f01029d8:	c7 44 24 0c 98 80 10 	movl   $0xf0108098,0xc(%esp)
f01029df:	f0 
f01029e0:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01029e7:	f0 
f01029e8:	c7 44 24 04 0b 04 00 	movl   $0x40b,0x4(%esp)
f01029ef:	00 
f01029f0:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01029f7:	e8 44 d6 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01029fc:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102a01:	8b 08                	mov    (%eax),%ecx
f0102a03:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102a09:	89 f2                	mov    %esi,%edx
f0102a0b:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0102a11:	c1 fa 03             	sar    $0x3,%edx
f0102a14:	c1 e2 0c             	shl    $0xc,%edx
f0102a17:	39 d1                	cmp    %edx,%ecx
f0102a19:	74 24                	je     f0102a3f <mem_init+0x11f4>
f0102a1b:	c7 44 24 0c 20 78 10 	movl   $0xf0107820,0xc(%esp)
f0102a22:	f0 
f0102a23:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102a2a:	f0 
f0102a2b:	c7 44 24 04 0e 04 00 	movl   $0x40e,0x4(%esp)
f0102a32:	00 
f0102a33:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102a3a:	e8 01 d6 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f0102a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102a45:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102a4a:	74 24                	je     f0102a70 <mem_init+0x1225>
f0102a4c:	c7 44 24 0c fb 80 10 	movl   $0xf01080fb,0xc(%esp)
f0102a53:	f0 
f0102a54:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102a5b:	f0 
f0102a5c:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
f0102a63:	00 
f0102a64:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102a6b:	e8 d0 d5 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f0102a70:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102a76:	89 34 24             	mov    %esi,(%esp)
f0102a79:	e8 db e9 ff ff       	call   f0101459 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102a7e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102a85:	00 
f0102a86:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102a8d:	00 
f0102a8e:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102a93:	89 04 24             	mov    %eax,(%esp)
f0102a96:	e8 f6 e9 ff ff       	call   f0101491 <pgdir_walk>
f0102a9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102a9e:	8b 0d 8c 5e 20 f0    	mov    0xf0205e8c,%ecx
f0102aa4:	8b 51 04             	mov    0x4(%ecx),%edx
f0102aa7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102aad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102ab0:	8b 15 88 5e 20 f0    	mov    0xf0205e88,%edx
f0102ab6:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0102ab9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102abc:	c1 ea 0c             	shr    $0xc,%edx
f0102abf:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0102ac2:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0102ac5:	39 55 d0             	cmp    %edx,-0x30(%ebp)
f0102ac8:	72 23                	jb     f0102aed <mem_init+0x12a2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102aca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102acd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0102ad1:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0102ad8:	f0 
f0102ad9:	c7 44 24 04 17 04 00 	movl   $0x417,0x4(%esp)
f0102ae0:	00 
f0102ae1:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102ae8:	e8 53 d5 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102aed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102af0:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0102af6:	39 d0                	cmp    %edx,%eax
f0102af8:	74 24                	je     f0102b1e <mem_init+0x12d3>
f0102afa:	c7 44 24 0c 66 81 10 	movl   $0xf0108166,0xc(%esp)
f0102b01:	f0 
f0102b02:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102b09:	f0 
f0102b0a:	c7 44 24 04 18 04 00 	movl   $0x418,0x4(%esp)
f0102b11:	00 
f0102b12:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102b19:	e8 22 d5 ff ff       	call   f0100040 <_panic>
	kern_pgdir[PDX(va)] = 0;
f0102b1e:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0102b25:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102b2b:	89 f0                	mov    %esi,%eax
f0102b2d:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0102b33:	c1 f8 03             	sar    $0x3,%eax
f0102b36:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102b39:	89 c1                	mov    %eax,%ecx
f0102b3b:	c1 e9 0c             	shr    $0xc,%ecx
f0102b3e:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f0102b41:	77 20                	ja     f0102b63 <mem_init+0x1318>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102b43:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102b47:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0102b4e:	f0 
f0102b4f:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102b56:	00 
f0102b57:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0102b5e:	e8 dd d4 ff ff       	call   f0100040 <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102b63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102b6a:	00 
f0102b6b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102b72:	00 
	return (void *)(pa + KERNBASE);
f0102b73:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102b78:	89 04 24             	mov    %eax,(%esp)
f0102b7b:	e8 31 35 00 00       	call   f01060b1 <memset>
	page_free(pp0);
f0102b80:	89 34 24             	mov    %esi,(%esp)
f0102b83:	e8 d1 e8 ff ff       	call   f0101459 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102b88:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102b8f:	00 
f0102b90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102b97:	00 
f0102b98:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102b9d:	89 04 24             	mov    %eax,(%esp)
f0102ba0:	e8 ec e8 ff ff       	call   f0101491 <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102ba5:	89 f2                	mov    %esi,%edx
f0102ba7:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f0102bad:	c1 fa 03             	sar    $0x3,%edx
f0102bb0:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102bb3:	89 d0                	mov    %edx,%eax
f0102bb5:	c1 e8 0c             	shr    $0xc,%eax
f0102bb8:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0102bbe:	72 20                	jb     f0102be0 <mem_init+0x1395>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102bc0:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102bc4:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0102bcb:	f0 
f0102bcc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102bd3:	00 
f0102bd4:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0102bdb:	e8 60 d4 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102be0:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102be9:	f6 82 00 00 00 f0 01 	testb  $0x1,-0x10000000(%edx)
f0102bf0:	75 11                	jne    f0102c03 <mem_init+0x13b8>
f0102bf2:	8d 82 04 00 00 f0    	lea    -0xffffffc(%edx),%eax
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0102bf8:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102bfe:	f6 00 01             	testb  $0x1,(%eax)
f0102c01:	74 24                	je     f0102c27 <mem_init+0x13dc>
f0102c03:	c7 44 24 0c 7e 81 10 	movl   $0xf010817e,0xc(%esp)
f0102c0a:	f0 
f0102c0b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102c12:	f0 
f0102c13:	c7 44 24 04 22 04 00 	movl   $0x422,0x4(%esp)
f0102c1a:	00 
f0102c1b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102c22:	e8 19 d4 ff ff       	call   f0100040 <_panic>
f0102c27:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102c2a:	39 d0                	cmp    %edx,%eax
f0102c2c:	75 d0                	jne    f0102bfe <mem_init+0x13b3>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102c2e:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102c39:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// give free list back
	page_free_list = fl;
f0102c3f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102c42:	89 0d 44 52 20 f0    	mov    %ecx,0xf0205244

	// free the pages we took
	page_free(pp0);
f0102c48:	89 34 24             	mov    %esi,(%esp)
f0102c4b:	e8 09 e8 ff ff       	call   f0101459 <page_free>
	page_free(pp1);
f0102c50:	89 3c 24             	mov    %edi,(%esp)
f0102c53:	e8 01 e8 ff ff       	call   f0101459 <page_free>
	page_free(pp2);
f0102c58:	89 1c 24             	mov    %ebx,(%esp)
f0102c5b:	e8 f9 e7 ff ff       	call   f0101459 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102c60:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f0102c67:	00 
f0102c68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102c6f:	e8 68 eb ff ff       	call   f01017dc <mmio_map_region>
f0102c74:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102c76:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102c7d:	00 
f0102c7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102c85:	e8 52 eb ff ff       	call   f01017dc <mmio_map_region>
f0102c8a:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102c8c:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102c92:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102c98:	76 07                	jbe    f0102ca1 <mem_init+0x1456>
f0102c9a:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102c9f:	76 24                	jbe    f0102cc5 <mem_init+0x147a>
f0102ca1:	c7 44 24 0c 68 7b 10 	movl   $0xf0107b68,0xc(%esp)
f0102ca8:	f0 
f0102ca9:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102cb0:	f0 
f0102cb1:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f0102cb8:	00 
f0102cb9:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102cc0:	e8 7b d3 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102cc5:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102ccb:	76 0e                	jbe    f0102cdb <mem_init+0x1490>
f0102ccd:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f0102cd3:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102cd9:	76 24                	jbe    f0102cff <mem_init+0x14b4>
f0102cdb:	c7 44 24 0c 90 7b 10 	movl   $0xf0107b90,0xc(%esp)
f0102ce2:	f0 
f0102ce3:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102cea:	f0 
f0102ceb:	c7 44 24 04 33 04 00 	movl   $0x433,0x4(%esp)
f0102cf2:	00 
f0102cf3:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102cfa:	e8 41 d3 ff ff       	call   f0100040 <_panic>
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0102cff:	89 da                	mov    %ebx,%edx
f0102d01:	09 f2                	or     %esi,%edx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102d03:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102d09:	74 24                	je     f0102d2f <mem_init+0x14e4>
f0102d0b:	c7 44 24 0c b8 7b 10 	movl   $0xf0107bb8,0xc(%esp)
f0102d12:	f0 
f0102d13:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102d1a:	f0 
f0102d1b:	c7 44 24 04 35 04 00 	movl   $0x435,0x4(%esp)
f0102d22:	00 
f0102d23:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102d2a:	e8 11 d3 ff ff       	call   f0100040 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102d2f:	39 c6                	cmp    %eax,%esi
f0102d31:	73 24                	jae    f0102d57 <mem_init+0x150c>
f0102d33:	c7 44 24 0c 95 81 10 	movl   $0xf0108195,0xc(%esp)
f0102d3a:	f0 
f0102d3b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102d42:	f0 
f0102d43:	c7 44 24 04 37 04 00 	movl   $0x437,0x4(%esp)
f0102d4a:	00 
f0102d4b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102d52:	e8 e9 d2 ff ff       	call   f0100040 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102d57:	8b 3d 8c 5e 20 f0    	mov    0xf0205e8c,%edi
f0102d5d:	89 da                	mov    %ebx,%edx
f0102d5f:	89 f8                	mov    %edi,%eax
f0102d61:	e8 e9 e0 ff ff       	call   f0100e4f <check_va2pa>
f0102d66:	85 c0                	test   %eax,%eax
f0102d68:	74 24                	je     f0102d8e <mem_init+0x1543>
f0102d6a:	c7 44 24 0c e0 7b 10 	movl   $0xf0107be0,0xc(%esp)
f0102d71:	f0 
f0102d72:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102d79:	f0 
f0102d7a:	c7 44 24 04 39 04 00 	movl   $0x439,0x4(%esp)
f0102d81:	00 
f0102d82:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102d89:	e8 b2 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102d8e:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102d94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102d97:	89 c2                	mov    %eax,%edx
f0102d99:	89 f8                	mov    %edi,%eax
f0102d9b:	e8 af e0 ff ff       	call   f0100e4f <check_va2pa>
f0102da0:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102da5:	74 24                	je     f0102dcb <mem_init+0x1580>
f0102da7:	c7 44 24 0c 04 7c 10 	movl   $0xf0107c04,0xc(%esp)
f0102dae:	f0 
f0102daf:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102db6:	f0 
f0102db7:	c7 44 24 04 3a 04 00 	movl   $0x43a,0x4(%esp)
f0102dbe:	00 
f0102dbf:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102dc6:	e8 75 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102dcb:	89 f2                	mov    %esi,%edx
f0102dcd:	89 f8                	mov    %edi,%eax
f0102dcf:	e8 7b e0 ff ff       	call   f0100e4f <check_va2pa>
f0102dd4:	85 c0                	test   %eax,%eax
f0102dd6:	74 24                	je     f0102dfc <mem_init+0x15b1>
f0102dd8:	c7 44 24 0c 34 7c 10 	movl   $0xf0107c34,0xc(%esp)
f0102ddf:	f0 
f0102de0:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102de7:	f0 
f0102de8:	c7 44 24 04 3b 04 00 	movl   $0x43b,0x4(%esp)
f0102def:	00 
f0102df0:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102df7:	e8 44 d2 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102dfc:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102e02:	89 f8                	mov    %edi,%eax
f0102e04:	e8 46 e0 ff ff       	call   f0100e4f <check_va2pa>
f0102e09:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102e0c:	74 24                	je     f0102e32 <mem_init+0x15e7>
f0102e0e:	c7 44 24 0c 58 7c 10 	movl   $0xf0107c58,0xc(%esp)
f0102e15:	f0 
f0102e16:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102e1d:	f0 
f0102e1e:	c7 44 24 04 3c 04 00 	movl   $0x43c,0x4(%esp)
f0102e25:	00 
f0102e26:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102e2d:	e8 0e d2 ff ff       	call   f0100040 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102e32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102e39:	00 
f0102e3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102e3e:	89 3c 24             	mov    %edi,(%esp)
f0102e41:	e8 4b e6 ff ff       	call   f0101491 <pgdir_walk>
f0102e46:	f6 00 1a             	testb  $0x1a,(%eax)
f0102e49:	75 24                	jne    f0102e6f <mem_init+0x1624>
f0102e4b:	c7 44 24 0c 84 7c 10 	movl   $0xf0107c84,0xc(%esp)
f0102e52:	f0 
f0102e53:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102e5a:	f0 
f0102e5b:	c7 44 24 04 3e 04 00 	movl   $0x43e,0x4(%esp)
f0102e62:	00 
f0102e63:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102e6a:	e8 d1 d1 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102e6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102e76:	00 
f0102e77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102e7b:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102e80:	89 04 24             	mov    %eax,(%esp)
f0102e83:	e8 09 e6 ff ff       	call   f0101491 <pgdir_walk>
f0102e88:	f6 00 04             	testb  $0x4,(%eax)
f0102e8b:	74 24                	je     f0102eb1 <mem_init+0x1666>
f0102e8d:	c7 44 24 0c c8 7c 10 	movl   $0xf0107cc8,0xc(%esp)
f0102e94:	f0 
f0102e95:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0102e9c:	f0 
f0102e9d:	c7 44 24 04 3f 04 00 	movl   $0x43f,0x4(%esp)
f0102ea4:	00 
f0102ea5:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102eac:	e8 8f d1 ff ff       	call   f0100040 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102eb1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102eb8:	00 
f0102eb9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102ebd:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102ec2:	89 04 24             	mov    %eax,(%esp)
f0102ec5:	e8 c7 e5 ff ff       	call   f0101491 <pgdir_walk>
f0102eca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102ed0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102ed7:	00 
f0102ed8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102edb:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102edf:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102ee4:	89 04 24             	mov    %eax,(%esp)
f0102ee7:	e8 a5 e5 ff ff       	call   f0101491 <pgdir_walk>
f0102eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102ef2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102ef9:	00 
f0102efa:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102efe:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102f03:	89 04 24             	mov    %eax,(%esp)
f0102f06:	e8 86 e5 ff ff       	call   f0101491 <pgdir_walk>
f0102f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102f11:	c7 04 24 a7 81 10 f0 	movl   $0xf01081a7,(%esp)
f0102f18:	e8 cd 13 00 00       	call   f01042ea <cprintf>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(
f0102f1d:	a1 90 5e 20 f0       	mov    0xf0205e90,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102f22:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102f27:	77 20                	ja     f0102f49 <mem_init+0x16fe>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f29:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102f2d:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0102f34:	f0 
f0102f35:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
f0102f3c:	00 
f0102f3d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102f44:	e8 f7 d0 ff ff       	call   f0100040 <_panic>
		kern_pgdir,
		UPAGES,
		ROUNDUP(npages * sizeof(struct PageInfo),PGSIZE),
f0102f49:	8b 15 88 5e 20 f0    	mov    0xf0205e88,%edx
f0102f4f:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0102f56:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(
f0102f5c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f0102f63:	00 
	return (physaddr_t)kva - KERNBASE;
f0102f64:	05 00 00 00 10       	add    $0x10000000,%eax
f0102f69:	89 04 24             	mov    %eax,(%esp)
f0102f6c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102f71:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102f76:	e8 60 e6 ff ff       	call   f01015db <boot_map_region>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(
f0102f7b:	a1 4c 52 20 f0       	mov    0xf020524c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102f80:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102f85:	77 20                	ja     f0102fa7 <mem_init+0x175c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f87:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102f8b:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0102f92:	f0 
f0102f93:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
f0102f9a:	00 
f0102f9b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102fa2:	e8 99 d0 ff ff       	call   f0100040 <_panic>
f0102fa7:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
f0102fae:	00 
	return (physaddr_t)kva - KERNBASE;
f0102faf:	05 00 00 00 10       	add    $0x10000000,%eax
f0102fb4:	89 04 24             	mov    %eax,(%esp)
f0102fb7:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102fbc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102fc1:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0102fc6:	e8 10 e6 ff ff       	call   f01015db <boot_map_region>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102fcb:	b8 00 80 11 f0       	mov    $0xf0118000,%eax
f0102fd0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102fd5:	77 20                	ja     f0102ff7 <mem_init+0x17ac>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102fd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102fdb:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0102fe2:	f0 
f0102fe3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
f0102fea:	00 
f0102feb:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0102ff2:	e8 49 d0 ff ff       	call   f0100040 <_panic>
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(
f0102ff7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0102ffe:	00 
f0102fff:	c7 04 24 00 80 11 00 	movl   $0x118000,(%esp)
f0103006:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010300b:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103010:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0103015:	e8 c1 e5 ff ff       	call   f01015db <boot_map_region>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010301a:	b8 00 70 20 f0       	mov    $0xf0207000,%eax
f010301f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103024:	0f 87 f6 07 00 00    	ja     f0103820 <mem_init+0x1fd5>
f010302a:	eb 0c                	jmp    f0103038 <mem_init+0x17ed>
	//
	// LAB 4: Your code here:	
	unsigned i;
	for ( i = 0; i < NCPU; i++){
		unsigned kstacktop_i = KSTACKTOP - i * (KSTKSIZE+ KSTKGAP);
		boot_map_region(kern_pgdir, 
f010302c:	89 d8                	mov    %ebx,%eax
f010302e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103034:	77 27                	ja     f010305d <mem_init+0x1812>
f0103036:	eb 05                	jmp    f010303d <mem_init+0x17f2>
f0103038:	b8 00 70 20 f0       	mov    $0xf0207000,%eax
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010303d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103041:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103048:	f0 
f0103049:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
f0103050:	00 
f0103051:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103058:	e8 e3 cf ff ff       	call   f0100040 <_panic>
f010305d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103064:	00 
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0103065:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
	//
	// LAB 4: Your code here:	
	unsigned i;
	for ( i = 0; i < NCPU; i++){
		unsigned kstacktop_i = KSTACKTOP - i * (KSTKSIZE+ KSTKGAP);
		boot_map_region(kern_pgdir, 
f010306b:	89 04 24             	mov    %eax,(%esp)
f010306e:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103073:	89 f2                	mov    %esi,%edx
f0103075:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010307a:	e8 5c e5 ff ff       	call   f01015db <boot_map_region>
f010307f:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0103085:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	//             Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:	
	unsigned i;
	for ( i = 0; i < NCPU; i++){
f010308b:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0103091:	75 99                	jne    f010302c <mem_init+0x17e1>


	// Initialize the SMP-related parts of the memory map
	mem_init_mp();

	boot_map_region(
f0103093:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010309a:	00 
f010309b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01030a2:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01030a7:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01030ac:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01030b1:	e8 25 e5 ff ff       	call   f01015db <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f01030b6:	8b 1d 8c 5e 20 f0    	mov    0xf0205e8c,%ebx

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01030bc:	8b 0d 88 5e 20 f0    	mov    0xf0205e88,%ecx
f01030c2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f01030c5:	8d 3c cd ff 0f 00 00 	lea    0xfff(,%ecx,8),%edi
	for (i = 0; i < n; i += PGSIZE)
f01030cc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f01030d2:	0f 84 80 00 00 00    	je     f0103158 <mem_init+0x190d>
f01030d8:	be 00 00 00 00       	mov    $0x0,%esi
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f01030dd:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01030e3:	89 d8                	mov    %ebx,%eax
f01030e5:	e8 65 dd ff ff       	call   f0100e4f <check_va2pa>
f01030ea:	8b 15 90 5e 20 f0    	mov    0xf0205e90,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01030f0:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01030f6:	77 20                	ja     f0103118 <mem_init+0x18cd>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01030fc:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103103:	f0 
f0103104:	c7 44 24 04 5c 03 00 	movl   $0x35c,0x4(%esp)
f010310b:	00 
f010310c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103113:	e8 28 cf ff ff       	call   f0100040 <_panic>
f0103118:	8d 94 32 00 00 00 10 	lea    0x10000000(%edx,%esi,1),%edx
f010311f:	39 d0                	cmp    %edx,%eax
f0103121:	74 24                	je     f0103147 <mem_init+0x18fc>
f0103123:	c7 44 24 0c fc 7c 10 	movl   $0xf0107cfc,0xc(%esp)
f010312a:	f0 
f010312b:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103132:	f0 
f0103133:	c7 44 24 04 5c 03 00 	movl   $0x35c,0x4(%esp)
f010313a:	00 
f010313b:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103142:	e8 f9 ce ff ff       	call   f0100040 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103147:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010314d:	39 f7                	cmp    %esi,%edi
f010314f:	77 8c                	ja     f01030dd <mem_init+0x1892>
f0103151:	be 00 00 00 00       	mov    $0x0,%esi
f0103156:	eb 05                	jmp    f010315d <mem_init+0x1912>
f0103158:	be 00 00 00 00       	mov    $0x0,%esi
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f010315d:	8d 96 00 00 c0 ee    	lea    -0x11400000(%esi),%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103163:	89 d8                	mov    %ebx,%eax
f0103165:	e8 e5 dc ff ff       	call   f0100e4f <check_va2pa>
f010316a:	8b 15 4c 52 20 f0    	mov    0xf020524c,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103170:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103176:	77 20                	ja     f0103198 <mem_init+0x194d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103178:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010317c:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103183:	f0 
f0103184:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
f010318b:	00 
f010318c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103193:	e8 a8 ce ff ff       	call   f0100040 <_panic>
f0103198:	8d 94 32 00 00 00 10 	lea    0x10000000(%edx,%esi,1),%edx
f010319f:	39 d0                	cmp    %edx,%eax
f01031a1:	74 24                	je     f01031c7 <mem_init+0x197c>
f01031a3:	c7 44 24 0c 30 7d 10 	movl   $0xf0107d30,0xc(%esp)
f01031aa:	f0 
f01031ab:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01031b2:	f0 
f01031b3:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
f01031ba:	00 
f01031bb:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01031c2:	e8 79 ce ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01031c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01031cd:	81 fe 00 f0 01 00    	cmp    $0x1f000,%esi
f01031d3:	75 88                	jne    f010315d <mem_init+0x1912>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01031d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01031d8:	c1 e7 0c             	shl    $0xc,%edi
f01031db:	85 ff                	test   %edi,%edi
f01031dd:	74 44                	je     f0103223 <mem_init+0x19d8>
f01031df:	be 00 00 00 00       	mov    $0x0,%esi
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f01031e4:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01031ea:	89 d8                	mov    %ebx,%eax
f01031ec:	e8 5e dc ff ff       	call   f0100e4f <check_va2pa>
f01031f1:	39 c6                	cmp    %eax,%esi
f01031f3:	74 24                	je     f0103219 <mem_init+0x19ce>
f01031f5:	c7 44 24 0c 64 7d 10 	movl   $0xf0107d64,0xc(%esp)
f01031fc:	f0 
f01031fd:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103204:	f0 
f0103205:	c7 44 24 04 65 03 00 	movl   $0x365,0x4(%esp)
f010320c:	00 
f010320d:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103214:	e8 27 ce ff ff       	call   f0100040 <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103219:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010321f:	39 fe                	cmp    %edi,%esi
f0103221:	72 c1                	jb     f01031e4 <mem_init+0x1999>
f0103223:	c7 45 cc 00 70 20 f0 	movl   $0xf0207000,-0x34(%ebp)
f010322a:	c7 45 d0 00 00 ff ef 	movl   $0xefff0000,-0x30(%ebp)
f0103231:	89 df                	mov    %ebx,%edi
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103233:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103236:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103239:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f010323c:	81 c3 00 80 00 00    	add    $0x8000,%ebx
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0103242:	89 c6                	mov    %eax,%esi
f0103244:	81 c6 00 00 00 10    	add    $0x10000000,%esi
f010324a:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010324d:	81 c2 00 00 01 00    	add    $0x10000,%edx
f0103253:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103256:	89 da                	mov    %ebx,%edx
f0103258:	89 f8                	mov    %edi,%eax
f010325a:	e8 f0 db ff ff       	call   f0100e4f <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010325f:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0103266:	77 23                	ja     f010328b <mem_init+0x1a40>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103268:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010326b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010326f:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103276:	f0 
f0103277:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f010327e:	00 
f010327f:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103286:	e8 b5 cd ff ff       	call   f0100040 <_panic>
f010328b:	39 f0                	cmp    %esi,%eax
f010328d:	74 24                	je     f01032b3 <mem_init+0x1a68>
f010328f:	c7 44 24 0c 8c 7d 10 	movl   $0xf0107d8c,0xc(%esp)
f0103296:	f0 
f0103297:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010329e:	f0 
f010329f:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f01032a6:	00 
f01032a7:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01032ae:	e8 8d cd ff ff       	call   f0100040 <_panic>
f01032b3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01032b9:	81 c6 00 10 00 00    	add    $0x1000,%esi

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01032bf:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f01032c2:	0f 85 8a 05 00 00    	jne    f0103852 <mem_init+0x2007>
f01032c8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01032cd:	8b 75 d0             	mov    -0x30(%ebp),%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f01032d0:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f01032d3:	89 f8                	mov    %edi,%eax
f01032d5:	e8 75 db ff ff       	call   f0100e4f <check_va2pa>
f01032da:	83 f8 ff             	cmp    $0xffffffff,%eax
f01032dd:	74 24                	je     f0103303 <mem_init+0x1ab8>
f01032df:	c7 44 24 0c d4 7d 10 	movl   $0xf0107dd4,0xc(%esp)
f01032e6:	f0 
f01032e7:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01032ee:	f0 
f01032ef:	c7 44 24 04 6f 03 00 	movl   $0x36f,0x4(%esp)
f01032f6:	00 
f01032f7:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01032fe:	e8 3d cd ff ff       	call   f0100040 <_panic>
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103303:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103309:	81 fb 00 80 00 00    	cmp    $0x8000,%ebx
f010330f:	75 bf                	jne    f01032d0 <mem_init+0x1a85>
f0103311:	81 6d d0 00 00 01 00 	subl   $0x10000,-0x30(%ebp)
f0103318:	81 45 cc 00 80 00 00 	addl   $0x8000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f010331f:	81 7d d0 00 00 f7 ef 	cmpl   $0xeff70000,-0x30(%ebp)
f0103326:	0f 85 07 ff ff ff    	jne    f0103233 <mem_init+0x19e8>
f010332c:	89 fb                	mov    %edi,%ebx
f010332e:	b8 00 00 00 00       	mov    $0x0,%eax
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0103333:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0103339:	83 fa 04             	cmp    $0x4,%edx
f010333c:	77 2e                	ja     f010336c <mem_init+0x1b21>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f010333e:	f6 04 83 01          	testb  $0x1,(%ebx,%eax,4)
f0103342:	0f 85 aa 00 00 00    	jne    f01033f2 <mem_init+0x1ba7>
f0103348:	c7 44 24 0c c0 81 10 	movl   $0xf01081c0,0xc(%esp)
f010334f:	f0 
f0103350:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103357:	f0 
f0103358:	c7 44 24 04 7a 03 00 	movl   $0x37a,0x4(%esp)
f010335f:	00 
f0103360:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103367:	e8 d4 cc ff ff       	call   f0100040 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f010336c:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0103371:	76 55                	jbe    f01033c8 <mem_init+0x1b7d>
				assert(pgdir[i] & PTE_P);
f0103373:	8b 14 83             	mov    (%ebx,%eax,4),%edx
f0103376:	f6 c2 01             	test   $0x1,%dl
f0103379:	75 24                	jne    f010339f <mem_init+0x1b54>
f010337b:	c7 44 24 0c c0 81 10 	movl   $0xf01081c0,0xc(%esp)
f0103382:	f0 
f0103383:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010338a:	f0 
f010338b:	c7 44 24 04 7e 03 00 	movl   $0x37e,0x4(%esp)
f0103392:	00 
f0103393:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010339a:	e8 a1 cc ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f010339f:	f6 c2 02             	test   $0x2,%dl
f01033a2:	75 4e                	jne    f01033f2 <mem_init+0x1ba7>
f01033a4:	c7 44 24 0c d1 81 10 	movl   $0xf01081d1,0xc(%esp)
f01033ab:	f0 
f01033ac:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01033b3:	f0 
f01033b4:	c7 44 24 04 7f 03 00 	movl   $0x37f,0x4(%esp)
f01033bb:	00 
f01033bc:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01033c3:	e8 78 cc ff ff       	call   f0100040 <_panic>
			} else
				assert(pgdir[i] == 0);
f01033c8:	83 3c 83 00          	cmpl   $0x0,(%ebx,%eax,4)
f01033cc:	74 24                	je     f01033f2 <mem_init+0x1ba7>
f01033ce:	c7 44 24 0c e2 81 10 	movl   $0xf01081e2,0xc(%esp)
f01033d5:	f0 
f01033d6:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01033dd:	f0 
f01033de:	c7 44 24 04 81 03 00 	movl   $0x381,0x4(%esp)
f01033e5:	00 
f01033e6:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01033ed:	e8 4e cc ff ff       	call   f0100040 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f01033f2:	83 c0 01             	add    $0x1,%eax
f01033f5:	3d 00 04 00 00       	cmp    $0x400,%eax
f01033fa:	0f 85 33 ff ff ff    	jne    f0103333 <mem_init+0x1ae8>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f0103400:	c7 04 24 f8 7d 10 f0 	movl   $0xf0107df8,(%esp)
f0103407:	e8 de 0e 00 00       	call   f01042ea <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f010340c:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103411:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103416:	77 20                	ja     f0103438 <mem_init+0x1bed>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103418:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010341c:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103423:	f0 
f0103424:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
f010342b:	00 
f010342c:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103433:	e8 08 cc ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103438:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010343d:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f0103440:	b8 00 00 00 00       	mov    $0x0,%eax
f0103445:	e8 a8 da ff ff       	call   f0100ef2 <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f010344a:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f010344d:	0d 23 00 05 80       	or     $0x80050023,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103452:	83 e0 f3             	and    $0xfffffff3,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103455:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010345f:	e8 77 df ff ff       	call   f01013db <page_alloc>
f0103464:	89 c6                	mov    %eax,%esi
f0103466:	85 c0                	test   %eax,%eax
f0103468:	75 24                	jne    f010348e <mem_init+0x1c43>
f010346a:	c7 44 24 0c ed 7f 10 	movl   $0xf0107fed,0xc(%esp)
f0103471:	f0 
f0103472:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103479:	f0 
f010347a:	c7 44 24 04 54 04 00 	movl   $0x454,0x4(%esp)
f0103481:	00 
f0103482:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103489:	e8 b2 cb ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010348e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103495:	e8 41 df ff ff       	call   f01013db <page_alloc>
f010349a:	89 c7                	mov    %eax,%edi
f010349c:	85 c0                	test   %eax,%eax
f010349e:	75 24                	jne    f01034c4 <mem_init+0x1c79>
f01034a0:	c7 44 24 0c 03 80 10 	movl   $0xf0108003,0xc(%esp)
f01034a7:	f0 
f01034a8:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01034af:	f0 
f01034b0:	c7 44 24 04 55 04 00 	movl   $0x455,0x4(%esp)
f01034b7:	00 
f01034b8:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01034bf:	e8 7c cb ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01034c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01034cb:	e8 0b df ff ff       	call   f01013db <page_alloc>
f01034d0:	89 c3                	mov    %eax,%ebx
f01034d2:	85 c0                	test   %eax,%eax
f01034d4:	75 24                	jne    f01034fa <mem_init+0x1caf>
f01034d6:	c7 44 24 0c 19 80 10 	movl   $0xf0108019,0xc(%esp)
f01034dd:	f0 
f01034de:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01034e5:	f0 
f01034e6:	c7 44 24 04 56 04 00 	movl   $0x456,0x4(%esp)
f01034ed:	00 
f01034ee:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01034f5:	e8 46 cb ff ff       	call   f0100040 <_panic>
	page_free(pp0);
f01034fa:	89 34 24             	mov    %esi,(%esp)
f01034fd:	e8 57 df ff ff       	call   f0101459 <page_free>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103502:	89 f8                	mov    %edi,%eax
f0103504:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f010350a:	c1 f8 03             	sar    $0x3,%eax
f010350d:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103510:	89 c2                	mov    %eax,%edx
f0103512:	c1 ea 0c             	shr    $0xc,%edx
f0103515:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f010351b:	72 20                	jb     f010353d <mem_init+0x1cf2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010351d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103521:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0103528:	f0 
f0103529:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103530:	00 
f0103531:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103538:	e8 03 cb ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp1), 1, PGSIZE);
f010353d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103544:	00 
f0103545:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f010354c:	00 
	return (void *)(pa + KERNBASE);
f010354d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103552:	89 04 24             	mov    %eax,(%esp)
f0103555:	e8 57 2b 00 00       	call   f01060b1 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010355a:	89 d8                	mov    %ebx,%eax
f010355c:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0103562:	c1 f8 03             	sar    $0x3,%eax
f0103565:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103568:	89 c2                	mov    %eax,%edx
f010356a:	c1 ea 0c             	shr    $0xc,%edx
f010356d:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0103573:	72 20                	jb     f0103595 <mem_init+0x1d4a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103575:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103579:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0103580:	f0 
f0103581:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103588:	00 
f0103589:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103590:	e8 ab ca ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp2), 2, PGSIZE);
f0103595:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010359c:	00 
f010359d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f01035a4:	00 
	return (void *)(pa + KERNBASE);
f01035a5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01035aa:	89 04 24             	mov    %eax,(%esp)
f01035ad:	e8 ff 2a 00 00       	call   f01060b1 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f01035b2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01035b9:	00 
f01035ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01035c1:	00 
f01035c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01035c6:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f01035cb:	89 04 24             	mov    %eax,(%esp)
f01035ce:	e8 5f e1 ff ff       	call   f0101732 <page_insert>
	assert(pp1->pp_ref == 1);
f01035d3:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01035d8:	74 24                	je     f01035fe <mem_init+0x1db3>
f01035da:	c7 44 24 0c ea 80 10 	movl   $0xf01080ea,0xc(%esp)
f01035e1:	f0 
f01035e2:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01035e9:	f0 
f01035ea:	c7 44 24 04 5b 04 00 	movl   $0x45b,0x4(%esp)
f01035f1:	00 
f01035f2:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01035f9:	e8 42 ca ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01035fe:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0103605:	01 01 01 
f0103608:	74 24                	je     f010362e <mem_init+0x1de3>
f010360a:	c7 44 24 0c 18 7e 10 	movl   $0xf0107e18,0xc(%esp)
f0103611:	f0 
f0103612:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103619:	f0 
f010361a:	c7 44 24 04 5c 04 00 	movl   $0x45c,0x4(%esp)
f0103621:	00 
f0103622:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103629:	e8 12 ca ff ff       	call   f0100040 <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f010362e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0103635:	00 
f0103636:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010363d:	00 
f010363e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103642:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0103647:	89 04 24             	mov    %eax,(%esp)
f010364a:	e8 e3 e0 ff ff       	call   f0101732 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f010364f:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103656:	02 02 02 
f0103659:	74 24                	je     f010367f <mem_init+0x1e34>
f010365b:	c7 44 24 0c 3c 7e 10 	movl   $0xf0107e3c,0xc(%esp)
f0103662:	f0 
f0103663:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010366a:	f0 
f010366b:	c7 44 24 04 5e 04 00 	movl   $0x45e,0x4(%esp)
f0103672:	00 
f0103673:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f010367a:	e8 c1 c9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010367f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103684:	74 24                	je     f01036aa <mem_init+0x1e5f>
f0103686:	c7 44 24 0c 0c 81 10 	movl   $0xf010810c,0xc(%esp)
f010368d:	f0 
f010368e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103695:	f0 
f0103696:	c7 44 24 04 5f 04 00 	movl   $0x45f,0x4(%esp)
f010369d:	00 
f010369e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01036a5:	e8 96 c9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01036aa:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01036af:	74 24                	je     f01036d5 <mem_init+0x1e8a>
f01036b1:	c7 44 24 0c 55 81 10 	movl   $0xf0108155,0xc(%esp)
f01036b8:	f0 
f01036b9:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01036c0:	f0 
f01036c1:	c7 44 24 04 60 04 00 	movl   $0x460,0x4(%esp)
f01036c8:	00 
f01036c9:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01036d0:	e8 6b c9 ff ff       	call   f0100040 <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f01036d5:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f01036dc:	03 03 03 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01036df:	89 d8                	mov    %ebx,%eax
f01036e1:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f01036e7:	c1 f8 03             	sar    $0x3,%eax
f01036ea:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01036ed:	89 c2                	mov    %eax,%edx
f01036ef:	c1 ea 0c             	shr    $0xc,%edx
f01036f2:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f01036f8:	72 20                	jb     f010371a <mem_init+0x1ecf>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01036fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01036fe:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0103705:	f0 
f0103706:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f010370d:	00 
f010370e:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103715:	e8 26 c9 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010371a:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103721:	03 03 03 
f0103724:	74 24                	je     f010374a <mem_init+0x1eff>
f0103726:	c7 44 24 0c 60 7e 10 	movl   $0xf0107e60,0xc(%esp)
f010372d:	f0 
f010372e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103735:	f0 
f0103736:	c7 44 24 04 62 04 00 	movl   $0x462,0x4(%esp)
f010373d:	00 
f010373e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103745:	e8 f6 c8 ff ff       	call   f0100040 <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f010374a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103751:	00 
f0103752:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f0103757:	89 04 24             	mov    %eax,(%esp)
f010375a:	e8 83 df ff ff       	call   f01016e2 <page_remove>
	assert(pp2->pp_ref == 0);
f010375f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103764:	74 24                	je     f010378a <mem_init+0x1f3f>
f0103766:	c7 44 24 0c 44 81 10 	movl   $0xf0108144,0xc(%esp)
f010376d:	f0 
f010376e:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f0103775:	f0 
f0103776:	c7 44 24 04 64 04 00 	movl   $0x464,0x4(%esp)
f010377d:	00 
f010377e:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f0103785:	e8 b6 c8 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010378a:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010378f:	8b 08                	mov    (%eax),%ecx
f0103791:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103797:	89 f2                	mov    %esi,%edx
f0103799:	2b 15 90 5e 20 f0    	sub    0xf0205e90,%edx
f010379f:	c1 fa 03             	sar    $0x3,%edx
f01037a2:	c1 e2 0c             	shl    $0xc,%edx
f01037a5:	39 d1                	cmp    %edx,%ecx
f01037a7:	74 24                	je     f01037cd <mem_init+0x1f82>
f01037a9:	c7 44 24 0c 20 78 10 	movl   $0xf0107820,0xc(%esp)
f01037b0:	f0 
f01037b1:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01037b8:	f0 
f01037b9:	c7 44 24 04 67 04 00 	movl   $0x467,0x4(%esp)
f01037c0:	00 
f01037c1:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01037c8:	e8 73 c8 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f01037cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f01037d3:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01037d8:	74 24                	je     f01037fe <mem_init+0x1fb3>
f01037da:	c7 44 24 0c fb 80 10 	movl   $0xf01080fb,0xc(%esp)
f01037e1:	f0 
f01037e2:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01037e9:	f0 
f01037ea:	c7 44 24 04 69 04 00 	movl   $0x469,0x4(%esp)
f01037f1:	00 
f01037f2:	c7 04 24 ed 7e 10 f0 	movl   $0xf0107eed,(%esp)
f01037f9:	e8 42 c8 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f01037fe:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0103804:	89 34 24             	mov    %esi,(%esp)
f0103807:	e8 4d dc ff ff       	call   f0101459 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f010380c:	c7 04 24 8c 7e 10 f0 	movl   $0xf0107e8c,(%esp)
f0103813:	e8 d2 0a 00 00       	call   f01042ea <cprintf>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f0103818:	83 c4 3c             	add    $0x3c,%esp
f010381b:	5b                   	pop    %ebx
f010381c:	5e                   	pop    %esi
f010381d:	5f                   	pop    %edi
f010381e:	5d                   	pop    %ebp
f010381f:	c3                   	ret    
	//
	// LAB 4: Your code here:	
	unsigned i;
	for ( i = 0; i < NCPU; i++){
		unsigned kstacktop_i = KSTACKTOP - i * (KSTKSIZE+ KSTKGAP);
		boot_map_region(kern_pgdir, 
f0103820:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103827:	00 
f0103828:	c7 04 24 00 70 20 00 	movl   $0x207000,(%esp)
f010382f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103834:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103839:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
f010383e:	e8 98 dd ff ff       	call   f01015db <boot_map_region>
f0103843:	bb 00 f0 20 f0       	mov    $0xf020f000,%ebx
f0103848:	be 00 80 fe ef       	mov    $0xeffe8000,%esi
f010384d:	e9 da f7 ff ff       	jmp    f010302c <mem_init+0x17e1>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103852:	89 da                	mov    %ebx,%edx
f0103854:	89 f8                	mov    %edi,%eax
f0103856:	e8 f4 d5 ff ff       	call   f0100e4f <check_va2pa>
f010385b:	e9 2b fa ff ff       	jmp    f010328b <mem_init+0x1a40>

f0103860 <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0103860:	55                   	push   %ebp
f0103861:	89 e5                	mov    %esp,%ebp
f0103863:	57                   	push   %edi
f0103864:	56                   	push   %esi
f0103865:	53                   	push   %ebx
f0103866:	83 ec 2c             	sub    $0x2c,%esp
f0103869:	8b 75 08             	mov    0x8(%ebp),%esi
f010386c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.
	uintptr_t lva = (uintptr_t) va;
	uintptr_t rva = (uintptr_t) va + len - 1;
f010386f:	89 d8                	mov    %ebx,%eax
f0103871:	03 45 10             	add    0x10(%ebp),%eax
f0103874:	83 e8 01             	sub    $0x1,%eax
f0103877:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	perm = perm|PTE_U|PTE_P;
f010387a:	8b 7d 14             	mov    0x14(%ebp),%edi
f010387d:	83 cf 05             	or     $0x5,%edi
			user_mem_check_addr = idx_va;
			return -E_FAULT;
		}
		idx_va = ROUNDDOWN (idx_va, PGSIZE);
	}
	return 0;
f0103880:	b8 00 00 00 00       	mov    $0x0,%eax

	perm = perm|PTE_U|PTE_P;
	pte_t *pte;
	uintptr_t idx_va;

	for (idx_va = lva; idx_va <= rva; idx_va += PGSIZE) {
f0103885:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103888:	77 65                	ja     f01038ef <user_mem_check+0x8f>
		if (idx_va >= ULIM) {
f010388a:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0103890:	76 17                	jbe    f01038a9 <user_mem_check+0x49>
f0103892:	eb 08                	jmp    f010389c <user_mem_check+0x3c>
f0103894:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010389a:	76 0d                	jbe    f01038a9 <user_mem_check+0x49>
			user_mem_check_addr = idx_va;
f010389c:	89 1d 48 52 20 f0    	mov    %ebx,0xf0205248
			return -E_FAULT;
f01038a2:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01038a7:	eb 46                	jmp    f01038ef <user_mem_check+0x8f>
		}
		pte = pgdir_walk (env->env_pgdir, (void*)idx_va, 0);
f01038a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01038b0:	00 
f01038b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01038b5:	8b 46 60             	mov    0x60(%esi),%eax
f01038b8:	89 04 24             	mov    %eax,(%esp)
f01038bb:	e8 d1 db ff ff       	call   f0101491 <pgdir_walk>
		if (pte == NULL || (*pte & perm) != perm) {
f01038c0:	85 c0                	test   %eax,%eax
f01038c2:	74 08                	je     f01038cc <user_mem_check+0x6c>
f01038c4:	8b 00                	mov    (%eax),%eax
f01038c6:	21 f8                	and    %edi,%eax
f01038c8:	39 c7                	cmp    %eax,%edi
f01038ca:	74 0d                	je     f01038d9 <user_mem_check+0x79>
			user_mem_check_addr = idx_va;
f01038cc:	89 1d 48 52 20 f0    	mov    %ebx,0xf0205248
			return -E_FAULT;
f01038d2:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01038d7:	eb 16                	jmp    f01038ef <user_mem_check+0x8f>
		}
		idx_va = ROUNDDOWN (idx_va, PGSIZE);
f01038d9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	perm = perm|PTE_U|PTE_P;
	pte_t *pte;
	uintptr_t idx_va;

	for (idx_va = lva; idx_va <= rva; idx_va += PGSIZE) {
f01038df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01038e5:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f01038e8:	73 aa                	jae    f0103894 <user_mem_check+0x34>
			user_mem_check_addr = idx_va;
			return -E_FAULT;
		}
		idx_va = ROUNDDOWN (idx_va, PGSIZE);
	}
	return 0;
f01038ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01038ef:	83 c4 2c             	add    $0x2c,%esp
f01038f2:	5b                   	pop    %ebx
f01038f3:	5e                   	pop    %esi
f01038f4:	5f                   	pop    %edi
f01038f5:	5d                   	pop    %ebp
f01038f6:	c3                   	ret    

f01038f7 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f01038f7:	55                   	push   %ebp
f01038f8:	89 e5                	mov    %esp,%ebp
f01038fa:	53                   	push   %ebx
f01038fb:	83 ec 14             	sub    $0x14,%esp
f01038fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103901:	8b 45 14             	mov    0x14(%ebp),%eax
f0103904:	83 c8 04             	or     $0x4,%eax
f0103907:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010390b:	8b 45 10             	mov    0x10(%ebp),%eax
f010390e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103912:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103915:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103919:	89 1c 24             	mov    %ebx,(%esp)
f010391c:	e8 3f ff ff ff       	call   f0103860 <user_mem_check>
f0103921:	85 c0                	test   %eax,%eax
f0103923:	79 24                	jns    f0103949 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f0103925:	a1 48 52 20 f0       	mov    0xf0205248,%eax
f010392a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010392e:	8b 43 48             	mov    0x48(%ebx),%eax
f0103931:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103935:	c7 04 24 b8 7e 10 f0 	movl   $0xf0107eb8,(%esp)
f010393c:	e8 a9 09 00 00       	call   f01042ea <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0103941:	89 1c 24             	mov    %ebx,(%esp)
f0103944:	e8 a3 06 00 00       	call   f0103fec <env_destroy>
	}
}
f0103949:	83 c4 14             	add    $0x14,%esp
f010394c:	5b                   	pop    %ebx
f010394d:	5d                   	pop    %ebp
f010394e:	c3                   	ret    
	...

f0103950 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103950:	55                   	push   %ebp
f0103951:	89 e5                	mov    %esp,%ebp
f0103953:	57                   	push   %edi
f0103954:	56                   	push   %esi
f0103955:	53                   	push   %ebx
f0103956:	83 ec 1c             	sub    $0x1c,%esp
f0103959:	89 c6                	mov    %eax,%esi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	struct PageInfo *p;
	uint32_t i = (uint32_t)ROUNDDOWN(va, PGSIZE);
f010395b:	89 d3                	mov    %edx,%ebx
f010395d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t l = (uint32_t)ROUNDUP(i + len, PGSIZE);
f0103963:	8d bc 0b ff 0f 00 00 	lea    0xfff(%ebx,%ecx,1),%edi
f010396a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	int r;
	for (; i < l; i+=PGSIZE)
f0103970:	39 fb                	cmp    %edi,%ebx
f0103972:	73 75                	jae    f01039e9 <region_alloc+0x99>
	{
		p = page_alloc(0);
f0103974:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010397b:	e8 5b da ff ff       	call   f01013db <page_alloc>
		if (p == NULL)
f0103980:	85 c0                	test   %eax,%eax
f0103982:	75 1c                	jne    f01039a0 <region_alloc+0x50>
		{
			panic("region_alloc: out of memory\n");
f0103984:	c7 44 24 08 f0 81 10 	movl   $0xf01081f0,0x8(%esp)
f010398b:	f0 
f010398c:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
f0103993:	00 
f0103994:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f010399b:	e8 a0 c6 ff ff       	call   f0100040 <_panic>
		}
		r = page_insert(e->env_pgdir, p, (void *)i, PTE_U | PTE_W);
f01039a0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f01039a7:	00 
f01039a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01039ac:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039b0:	8b 46 60             	mov    0x60(%esi),%eax
f01039b3:	89 04 24             	mov    %eax,(%esp)
f01039b6:	e8 77 dd ff ff       	call   f0101732 <page_insert>
		if (r < 0)
f01039bb:	85 c0                	test   %eax,%eax
f01039bd:	79 20                	jns    f01039df <region_alloc+0x8f>
		{
			panic("region_alloc: %e\n", r);
f01039bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01039c3:	c7 44 24 08 18 82 10 	movl   $0xf0108218,0x8(%esp)
f01039ca:	f0 
f01039cb:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
f01039d2:	00 
f01039d3:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f01039da:	e8 61 c6 ff ff       	call   f0100040 <_panic>
	//   (Watch out for corner-cases!)
	struct PageInfo *p;
	uint32_t i = (uint32_t)ROUNDDOWN(va, PGSIZE);
	uint32_t l = (uint32_t)ROUNDUP(i + len, PGSIZE);
	int r;
	for (; i < l; i+=PGSIZE)
f01039df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01039e5:	39 df                	cmp    %ebx,%edi
f01039e7:	77 8b                	ja     f0103974 <region_alloc+0x24>
		if (r < 0)
		{
			panic("region_alloc: %e\n", r);
		}
	}
}
f01039e9:	83 c4 1c             	add    $0x1c,%esp
f01039ec:	5b                   	pop    %ebx
f01039ed:	5e                   	pop    %esi
f01039ee:	5f                   	pop    %edi
f01039ef:	5d                   	pop    %ebp
f01039f0:	c3                   	ret    

f01039f1 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01039f1:	55                   	push   %ebp
f01039f2:	89 e5                	mov    %esp,%ebp
f01039f4:	83 ec 18             	sub    $0x18,%esp
f01039f7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01039fa:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01039fd:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0103a00:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a03:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103a06:	0f b6 55 10          	movzbl 0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103a0a:	85 c0                	test   %eax,%eax
f0103a0c:	75 17                	jne    f0103a25 <envid2env+0x34>
		*env_store = curenv;
f0103a0e:	e8 2d 2d 00 00       	call   f0106740 <cpunum>
f0103a13:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a16:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0103a1c:	89 06                	mov    %eax,(%esi)
		return 0;
f0103a1e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103a23:	eb 67                	jmp    f0103a8c <envid2env+0x9b>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103a25:	89 c3                	mov    %eax,%ebx
f0103a27:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103a2d:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103a30:	03 1d 4c 52 20 f0    	add    0xf020524c,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103a36:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103a3a:	74 05                	je     f0103a41 <envid2env+0x50>
f0103a3c:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103a3f:	74 0d                	je     f0103a4e <envid2env+0x5d>
		*env_store = 0;
f0103a41:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_BAD_ENV;
f0103a47:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103a4c:	eb 3e                	jmp    f0103a8c <envid2env+0x9b>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103a4e:	84 d2                	test   %dl,%dl
f0103a50:	74 33                	je     f0103a85 <envid2env+0x94>
f0103a52:	e8 e9 2c 00 00       	call   f0106740 <cpunum>
f0103a57:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a5a:	39 98 28 60 20 f0    	cmp    %ebx,-0xfdf9fd8(%eax)
f0103a60:	74 23                	je     f0103a85 <envid2env+0x94>
f0103a62:	8b 7b 4c             	mov    0x4c(%ebx),%edi
f0103a65:	e8 d6 2c 00 00       	call   f0106740 <cpunum>
f0103a6a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a6d:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0103a73:	3b 78 48             	cmp    0x48(%eax),%edi
f0103a76:	74 0d                	je     f0103a85 <envid2env+0x94>
		*env_store = 0;
f0103a78:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_BAD_ENV;
f0103a7e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103a83:	eb 07                	jmp    f0103a8c <envid2env+0x9b>
	}

	*env_store = e;
f0103a85:	89 1e                	mov    %ebx,(%esi)
	return 0;
f0103a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103a8c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0103a8f:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0103a92:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0103a95:	89 ec                	mov    %ebp,%esp
f0103a97:	5d                   	pop    %ebp
f0103a98:	c3                   	ret    

f0103a99 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103a99:	55                   	push   %ebp
f0103a9a:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103a9c:	b8 20 23 12 f0       	mov    $0xf0122320,%eax
f0103aa1:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0103aa4:	b8 23 00 00 00       	mov    $0x23,%eax
f0103aa9:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103aab:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103aad:	b0 10                	mov    $0x10,%al
f0103aaf:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103ab1:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0103ab3:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f0103ab5:	ea bc 3a 10 f0 08 00 	ljmp   $0x8,$0xf0103abc
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103abc:	b0 00                	mov    $0x0,%al
f0103abe:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103ac1:	5d                   	pop    %ebp
f0103ac2:	c3                   	ret    

f0103ac3 <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103ac3:	55                   	push   %ebp
f0103ac4:	89 e5                	mov    %esp,%ebp
f0103ac6:	56                   	push   %esi
f0103ac7:	53                   	push   %ebx
	// Set up envs array
	// LAB 3: Your code here.
	int i;
	
	for( i = NENV - 1; i >= 0; i--){
		envs[i].env_id = 0;
f0103ac8:	8b 35 4c 52 20 f0    	mov    0xf020524c,%esi
f0103ace:	8b 0d 50 52 20 f0    	mov    0xf0205250,%ecx
// Make sure the environments are in the free list in the same order
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
f0103ad4:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
{
	// Set up envs array
	// LAB 3: Your code here.
	int i;
	
	for( i = NENV - 1; i >= 0; i--){
f0103ada:	ba ff 03 00 00       	mov    $0x3ff,%edx
f0103adf:	eb 02                	jmp    f0103ae3 <env_init+0x20>
		envs[i].env_id = 0;
		envs[i].env_status = ENV_FREE;
		envs[i].env_link = env_free_list;
		env_free_list = &envs[i];
f0103ae1:	89 d9                	mov    %ebx,%ecx
	// Set up envs array
	// LAB 3: Your code here.
	int i;
	
	for( i = NENV - 1; i >= 0; i--){
		envs[i].env_id = 0;
f0103ae3:	89 c3                	mov    %eax,%ebx
f0103ae5:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_status = ENV_FREE;
f0103aec:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[i].env_link = env_free_list;
f0103af3:	89 48 44             	mov    %ecx,0x44(%eax)
{
	// Set up envs array
	// LAB 3: Your code here.
	int i;
	
	for( i = NENV - 1; i >= 0; i--){
f0103af6:	83 ea 01             	sub    $0x1,%edx
f0103af9:	83 e8 7c             	sub    $0x7c,%eax
f0103afc:	83 fa ff             	cmp    $0xffffffff,%edx
f0103aff:	75 e0                	jne    f0103ae1 <env_init+0x1e>
f0103b01:	89 35 50 52 20 f0    	mov    %esi,0xf0205250
		envs[i].env_status = ENV_FREE;
		envs[i].env_link = env_free_list;
		env_free_list = &envs[i];
	}
	// Per-CPU part of the initialization
	env_init_percpu();
f0103b07:	e8 8d ff ff ff       	call   f0103a99 <env_init_percpu>
}
f0103b0c:	5b                   	pop    %ebx
f0103b0d:	5e                   	pop    %esi
f0103b0e:	5d                   	pop    %ebp
f0103b0f:	c3                   	ret    

f0103b10 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103b10:	55                   	push   %ebp
f0103b11:	89 e5                	mov    %esp,%ebp
f0103b13:	56                   	push   %esi
f0103b14:	53                   	push   %ebx
f0103b15:	83 ec 10             	sub    $0x10,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103b18:	8b 1d 50 52 20 f0    	mov    0xf0205250,%ebx
f0103b1e:	85 db                	test   %ebx,%ebx
f0103b20:	0f 84 6d 01 00 00    	je     f0103c93 <env_alloc+0x183>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103b2d:	e8 a9 d8 ff ff       	call   f01013db <page_alloc>
f0103b32:	89 c6                	mov    %eax,%esi
f0103b34:	85 c0                	test   %eax,%eax
f0103b36:	0f 84 5e 01 00 00    	je     f0103c9a <env_alloc+0x18a>
f0103b3c:	2b 05 90 5e 20 f0    	sub    0xf0205e90,%eax
f0103b42:	c1 f8 03             	sar    $0x3,%eax
f0103b45:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103b48:	89 c2                	mov    %eax,%edx
f0103b4a:	c1 ea 0c             	shr    $0xc,%edx
f0103b4d:	3b 15 88 5e 20 f0    	cmp    0xf0205e88,%edx
f0103b53:	72 20                	jb     f0103b75 <env_alloc+0x65>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103b55:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103b59:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0103b60:	f0 
f0103b61:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103b68:	00 
f0103b69:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103b70:	e8 cb c4 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0103b75:	2d 00 00 00 10       	sub    $0x10000000,%eax
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	e->env_pgdir = (pte_t * )page2kva(p);
f0103b7a:	89 43 60             	mov    %eax,0x60(%ebx)

	memcpy(e -> env_pgdir, kern_pgdir, PGSIZE);
f0103b7d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103b84:	00 
f0103b85:	8b 15 8c 5e 20 f0    	mov    0xf0205e8c,%edx
f0103b8b:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103b8f:	89 04 24             	mov    %eax,(%esp)
f0103b92:	e8 ee 25 00 00       	call   f0106185 <memcpy>
	memset(e->env_pgdir, 0, PDX(UTOP) * sizeof(pte_t));
f0103b97:	c7 44 24 08 ec 0e 00 	movl   $0xeec,0x8(%esp)
f0103b9e:	00 
f0103b9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103ba6:	00 
f0103ba7:	8b 43 60             	mov    0x60(%ebx),%eax
f0103baa:	89 04 24             	mov    %eax,(%esp)
f0103bad:	e8 ff 24 00 00       	call   f01060b1 <memset>
	p->pp_ref++;
f0103bb2:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103bb7:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103bba:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103bbf:	77 20                	ja     f0103be1 <env_alloc+0xd1>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103bc5:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103bcc:	f0 
f0103bcd:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
f0103bd4:	00 
f0103bd5:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103bdc:	e8 5f c4 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103be1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103be7:	83 ca 05             	or     $0x5,%edx
f0103bea:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103bf0:	8b 43 48             	mov    0x48(%ebx),%eax
f0103bf3:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103bf8:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103bfd:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103c02:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103c05:	89 da                	mov    %ebx,%edx
f0103c07:	2b 15 4c 52 20 f0    	sub    0xf020524c,%edx
f0103c0d:	c1 fa 02             	sar    $0x2,%edx
f0103c10:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103c16:	09 d0                	or     %edx,%eax
f0103c18:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c1e:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103c21:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103c28:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103c2f:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103c36:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103c3d:	00 
f0103c3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103c45:	00 
f0103c46:	89 1c 24             	mov    %ebx,(%esp)
f0103c49:	e8 63 24 00 00       	call   f01060b1 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103c4e:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103c54:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103c5a:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103c60:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103c67:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f0103c6d:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103c74:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103c7b:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103c7f:	8b 43 44             	mov    0x44(%ebx),%eax
f0103c82:	a3 50 52 20 f0       	mov    %eax,0xf0205250
	*newenv_store = e;
f0103c87:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c8a:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0103c8c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c91:	eb 0c                	jmp    f0103c9f <env_alloc+0x18f>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103c93:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103c98:	eb 05                	jmp    f0103c9f <env_alloc+0x18f>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f0103c9a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	env_free_list = e->env_link;
	*newenv_store = e;

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0103c9f:	83 c4 10             	add    $0x10,%esp
f0103ca2:	5b                   	pop    %ebx
f0103ca3:	5e                   	pop    %esi
f0103ca4:	5d                   	pop    %ebp
f0103ca5:	c3                   	ret    

f0103ca6 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size, enum EnvType type)
{
f0103ca6:	55                   	push   %ebp
f0103ca7:	89 e5                	mov    %esp,%ebp
f0103ca9:	57                   	push   %edi
f0103caa:	56                   	push   %esi
f0103cab:	53                   	push   %ebx
f0103cac:	83 ec 3c             	sub    $0x3c,%esp
f0103caf:	8b 7d 08             	mov    0x8(%ebp),%edi
	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.

	struct Env *e;
	int r;
	r = env_alloc(&e, 0);
f0103cb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103cb9:	00 
f0103cba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103cbd:	89 04 24             	mov    %eax,(%esp)
f0103cc0:	e8 4b fe ff ff       	call   f0103b10 <env_alloc>
	if(r < 0)
f0103cc5:	85 c0                	test   %eax,%eax
f0103cc7:	79 20                	jns    f0103ce9 <env_create+0x43>
		panic("env_create: %e", r);
f0103cc9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103ccd:	c7 44 24 08 2a 82 10 	movl   $0xf010822a,0x8(%esp)
f0103cd4:	f0 
f0103cd5:	c7 44 24 04 9c 01 00 	movl   $0x19c,0x4(%esp)
f0103cdc:	00 
f0103cdd:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103ce4:	e8 57 c3 ff ff       	call   f0100040 <_panic>
	e->env_type = type;
f0103ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103cec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103cef:	8b 45 10             	mov    0x10(%ebp),%eax
f0103cf2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103cf5:	89 42 50             	mov    %eax,0x50(%edx)
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
	struct Elf *ELFHDR = (struct Elf *) binary;
	struct Proghdr *ph, *eph;
	if(ELFHDR->e_magic != ELF_MAGIC)
f0103cf8:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103cfe:	74 1c                	je     f0103d1c <env_create+0x76>
		panic("load_inode: not a valied ELF");
f0103d00:	c7 44 24 08 39 82 10 	movl   $0xf0108239,0x8(%esp)
f0103d07:	f0 
f0103d08:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
f0103d0f:	00 
f0103d10:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103d17:	e8 24 c3 ff ff       	call   f0100040 <_panic>
	ph = (struct Proghdr *)((uint8_t*)ELFHDR + ELFHDR->e_phoff);
f0103d1c:	8b 5f 1c             	mov    0x1c(%edi),%ebx
	eph = ph + ELFHDR->e_phnum;
f0103d1f:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
	lcr3(PADDR(e->env_pgdir));
f0103d23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103d26:	8b 42 60             	mov    0x60(%edx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103d29:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d2e:	77 20                	ja     f0103d50 <env_create+0xaa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d30:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d34:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103d3b:	f0 
f0103d3c:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
f0103d43:	00 
f0103d44:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103d4b:	e8 f0 c2 ff ff       	call   f0100040 <_panic>
	// LAB 3: Your code here.
	struct Elf *ELFHDR = (struct Elf *) binary;
	struct Proghdr *ph, *eph;
	if(ELFHDR->e_magic != ELF_MAGIC)
		panic("load_inode: not a valied ELF");
	ph = (struct Proghdr *)((uint8_t*)ELFHDR + ELFHDR->e_phoff);
f0103d50:	01 fb                	add    %edi,%ebx
	eph = ph + ELFHDR->e_phnum;
f0103d52:	0f b7 f6             	movzwl %si,%esi
f0103d55:	c1 e6 05             	shl    $0x5,%esi
f0103d58:	01 de                	add    %ebx,%esi
	return (physaddr_t)kva - KERNBASE;
f0103d5a:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103d5f:	0f 22 d8             	mov    %eax,%cr3
	lcr3(PADDR(e->env_pgdir));
	while(ph < eph){
f0103d62:	39 f3                	cmp    %esi,%ebx
f0103d64:	73 4f                	jae    f0103db5 <env_create+0x10f>
		if(ph->p_type == ELF_PROG_LOAD){
f0103d66:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103d69:	75 43                	jne    f0103dae <env_create+0x108>
			region_alloc(e, (void*) ph->p_va, ph->p_memsz);
f0103d6b:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103d6e:	8b 53 08             	mov    0x8(%ebx),%edx
f0103d71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103d74:	e8 d7 fb ff ff       	call   f0103950 <region_alloc>
			memset((void *) ph->p_va, 0, ph->p_memsz);
f0103d79:	8b 43 14             	mov    0x14(%ebx),%eax
f0103d7c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103d80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103d87:	00 
f0103d88:	8b 43 08             	mov    0x8(%ebx),%eax
f0103d8b:	89 04 24             	mov    %eax,(%esp)
f0103d8e:	e8 1e 23 00 00       	call   f01060b1 <memset>
			memmove((void*) ph->p_va, binary + ph->p_offset, ph->p_filesz);
f0103d93:	8b 43 10             	mov    0x10(%ebx),%eax
f0103d96:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103d9a:	89 f8                	mov    %edi,%eax
f0103d9c:	03 43 04             	add    0x4(%ebx),%eax
f0103d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103da3:	8b 43 08             	mov    0x8(%ebx),%eax
f0103da6:	89 04 24             	mov    %eax,(%esp)
f0103da9:	e8 5e 23 00 00       	call   f010610c <memmove>
		}
		ph++;
f0103dae:	83 c3 20             	add    $0x20,%ebx
	if(ELFHDR->e_magic != ELF_MAGIC)
		panic("load_inode: not a valied ELF");
	ph = (struct Proghdr *)((uint8_t*)ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	lcr3(PADDR(e->env_pgdir));
	while(ph < eph){
f0103db1:	39 de                	cmp    %ebx,%esi
f0103db3:	77 b1                	ja     f0103d66 <env_create+0xc0>
			memset((void *) ph->p_va, 0, ph->p_memsz);
			memmove((void*) ph->p_va, binary + ph->p_offset, ph->p_filesz);
		}
		ph++;
	}
	lcr3(PADDR(kern_pgdir));
f0103db5:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103dba:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103dbf:	77 20                	ja     f0103de1 <env_create+0x13b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103dc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103dc5:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103dcc:	f0 
f0103dcd:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
f0103dd4:	00 
f0103dd5:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103ddc:	e8 5f c2 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103de1:	05 00 00 00 10       	add    $0x10000000,%eax
f0103de6:	0f 22 d8             	mov    %eax,%cr3
	e->env_tf.tf_eip = ELFHDR->e_entry;
f0103de9:	8b 47 18             	mov    0x18(%edi),%eax
f0103dec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103def:	89 42 30             	mov    %eax,0x30(%edx)
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f0103df2:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103df7:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103dff:	e8 4c fb ff ff       	call   f0103950 <region_alloc>
	if(r < 0)
		panic("env_create: %e", r);
	e->env_type = type;
	load_icode(e, binary, size);

	if(e->env_type == ENV_TYPE_FS)
f0103e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103e07:	83 78 50 01          	cmpl   $0x1,0x50(%eax)
f0103e0b:	75 07                	jne    f0103e14 <env_create+0x16e>
		e->env_tf.tf_eflags |= FL_IOPL_3;
f0103e0d:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f0103e14:	83 c4 3c             	add    $0x3c,%esp
f0103e17:	5b                   	pop    %ebx
f0103e18:	5e                   	pop    %esi
f0103e19:	5f                   	pop    %edi
f0103e1a:	5d                   	pop    %ebp
f0103e1b:	c3                   	ret    

f0103e1c <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103e1c:	55                   	push   %ebp
f0103e1d:	89 e5                	mov    %esp,%ebp
f0103e1f:	57                   	push   %edi
f0103e20:	56                   	push   %esi
f0103e21:	53                   	push   %ebx
f0103e22:	83 ec 2c             	sub    $0x2c,%esp
f0103e25:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103e28:	e8 13 29 00 00       	call   f0106740 <cpunum>
f0103e2d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103e37:	39 b8 28 60 20 f0    	cmp    %edi,-0xfdf9fd8(%eax)
f0103e3d:	75 3b                	jne    f0103e7a <env_free+0x5e>
		lcr3(PADDR(kern_pgdir));
f0103e3f:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103e44:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e49:	77 20                	ja     f0103e6b <env_free+0x4f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103e4f:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103e56:	f0 
f0103e57:	c7 44 24 04 b2 01 00 	movl   $0x1b2,0x4(%esp)
f0103e5e:	00 
f0103e5f:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103e66:	e8 d5 c1 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103e6b:	05 00 00 00 10       	add    $0x10000000,%eax
f0103e70:	0f 22 d8             	mov    %eax,%cr3
f0103e73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103e7d:	c1 e0 02             	shl    $0x2,%eax
f0103e80:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103e83:	8b 47 60             	mov    0x60(%edi),%eax
f0103e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103e89:	8b 34 90             	mov    (%eax,%edx,4),%esi
f0103e8c:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103e92:	0f 84 b8 00 00 00    	je     f0103f50 <env_free+0x134>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103e98:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103e9e:	89 f0                	mov    %esi,%eax
f0103ea0:	c1 e8 0c             	shr    $0xc,%eax
f0103ea3:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103ea6:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0103eac:	72 20                	jb     f0103ece <env_free+0xb2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103eae:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103eb2:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0103eb9:	f0 
f0103eba:	c7 44 24 04 c1 01 00 	movl   $0x1c1,0x4(%esp)
f0103ec1:	00 
f0103ec2:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103ec9:	e8 72 c1 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103ece:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103ed1:	c1 e2 16             	shl    $0x16,%edx
f0103ed4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103edc:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103ee3:	01 
f0103ee4:	74 17                	je     f0103efd <env_free+0xe1>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103ee6:	89 d8                	mov    %ebx,%eax
f0103ee8:	c1 e0 0c             	shl    $0xc,%eax
f0103eeb:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103eee:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103ef2:	8b 47 60             	mov    0x60(%edi),%eax
f0103ef5:	89 04 24             	mov    %eax,(%esp)
f0103ef8:	e8 e5 d7 ff ff       	call   f01016e2 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103efd:	83 c3 01             	add    $0x1,%ebx
f0103f00:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103f06:	75 d4                	jne    f0103edc <env_free+0xc0>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103f08:	8b 47 60             	mov    0x60(%edi),%eax
f0103f0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103f0e:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f18:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0103f1e:	72 1c                	jb     f0103f3c <env_free+0x120>
		panic("pa2page called with invalid pa");
f0103f20:	c7 44 24 08 ec 76 10 	movl   $0xf01076ec,0x8(%esp)
f0103f27:	f0 
f0103f28:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103f2f:	00 
f0103f30:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103f37:	e8 04 c1 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f3f:	c1 e0 03             	shl    $0x3,%eax
f0103f42:	03 05 90 5e 20 f0    	add    0xf0205e90,%eax
		page_decref(pa2page(pa));
f0103f48:	89 04 24             	mov    %eax,(%esp)
f0103f4b:	e8 1e d5 ff ff       	call   f010146e <page_decref>
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103f50:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103f54:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103f5b:	0f 85 19 ff ff ff    	jne    f0103e7a <env_free+0x5e>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103f61:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103f64:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f69:	77 20                	ja     f0103f8b <env_free+0x16f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103f6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103f6f:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0103f76:	f0 
f0103f77:	c7 44 24 04 cf 01 00 	movl   $0x1cf,0x4(%esp)
f0103f7e:	00 
f0103f7f:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0103f86:	e8 b5 c0 ff ff       	call   f0100040 <_panic>
	e->env_pgdir = 0;
f0103f8b:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103f92:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f97:	c1 e8 0c             	shr    $0xc,%eax
f0103f9a:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0103fa0:	72 1c                	jb     f0103fbe <env_free+0x1a2>
		panic("pa2page called with invalid pa");
f0103fa2:	c7 44 24 08 ec 76 10 	movl   $0xf01076ec,0x8(%esp)
f0103fa9:	f0 
f0103faa:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103fb1:	00 
f0103fb2:	c7 04 24 f9 7e 10 f0 	movl   $0xf0107ef9,(%esp)
f0103fb9:	e8 82 c0 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103fbe:	c1 e0 03             	shl    $0x3,%eax
f0103fc1:	03 05 90 5e 20 f0    	add    0xf0205e90,%eax
	page_decref(pa2page(pa));
f0103fc7:	89 04 24             	mov    %eax,(%esp)
f0103fca:	e8 9f d4 ff ff       	call   f010146e <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103fcf:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103fd6:	a1 50 52 20 f0       	mov    0xf0205250,%eax
f0103fdb:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103fde:	89 3d 50 52 20 f0    	mov    %edi,0xf0205250
}
f0103fe4:	83 c4 2c             	add    $0x2c,%esp
f0103fe7:	5b                   	pop    %ebx
f0103fe8:	5e                   	pop    %esi
f0103fe9:	5f                   	pop    %edi
f0103fea:	5d                   	pop    %ebp
f0103feb:	c3                   	ret    

f0103fec <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103fec:	55                   	push   %ebp
f0103fed:	89 e5                	mov    %esp,%ebp
f0103fef:	53                   	push   %ebx
f0103ff0:	83 ec 14             	sub    $0x14,%esp
f0103ff3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103ff6:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103ffa:	75 19                	jne    f0104015 <env_destroy+0x29>
f0103ffc:	e8 3f 27 00 00       	call   f0106740 <cpunum>
f0104001:	6b c0 74             	imul   $0x74,%eax,%eax
f0104004:	39 98 28 60 20 f0    	cmp    %ebx,-0xfdf9fd8(%eax)
f010400a:	74 09                	je     f0104015 <env_destroy+0x29>
		e->env_status = ENV_DYING;
f010400c:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0104013:	eb 2f                	jmp    f0104044 <env_destroy+0x58>
	}

	env_free(e);
f0104015:	89 1c 24             	mov    %ebx,(%esp)
f0104018:	e8 ff fd ff ff       	call   f0103e1c <env_free>

	if (curenv == e) {
f010401d:	e8 1e 27 00 00       	call   f0106740 <cpunum>
f0104022:	6b c0 74             	imul   $0x74,%eax,%eax
f0104025:	39 98 28 60 20 f0    	cmp    %ebx,-0xfdf9fd8(%eax)
f010402b:	75 17                	jne    f0104044 <env_destroy+0x58>
		curenv = NULL;
f010402d:	e8 0e 27 00 00       	call   f0106740 <cpunum>
f0104032:	6b c0 74             	imul   $0x74,%eax,%eax
f0104035:	c7 80 28 60 20 f0 00 	movl   $0x0,-0xfdf9fd8(%eax)
f010403c:	00 00 00 
		sched_yield();
f010403f:	e8 d8 0c 00 00       	call   f0104d1c <sched_yield>
	}
}
f0104044:	83 c4 14             	add    $0x14,%esp
f0104047:	5b                   	pop    %ebx
f0104048:	5d                   	pop    %ebp
f0104049:	c3                   	ret    

f010404a <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010404a:	55                   	push   %ebp
f010404b:	89 e5                	mov    %esp,%ebp
f010404d:	53                   	push   %ebx
f010404e:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0104051:	e8 ea 26 00 00       	call   f0106740 <cpunum>
f0104056:	6b c0 74             	imul   $0x74,%eax,%eax
f0104059:	8b 98 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%ebx
f010405f:	e8 dc 26 00 00       	call   f0106740 <cpunum>
f0104064:	89 43 5c             	mov    %eax,0x5c(%ebx)

	__asm __volatile("movl %0,%%esp\n"
f0104067:	8b 65 08             	mov    0x8(%ebp),%esp
f010406a:	61                   	popa   
f010406b:	07                   	pop    %es
f010406c:	1f                   	pop    %ds
f010406d:	83 c4 08             	add    $0x8,%esp
f0104070:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0104071:	c7 44 24 08 56 82 10 	movl   $0xf0108256,0x8(%esp)
f0104078:	f0 
f0104079:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
f0104080:	00 
f0104081:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f0104088:	e8 b3 bf ff ff       	call   f0100040 <_panic>

f010408d <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f010408d:	55                   	push   %ebp
f010408e:	89 e5                	mov    %esp,%ebp
f0104090:	53                   	push   %ebx
f0104091:	83 ec 14             	sub    $0x14,%esp
f0104094:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){
f0104097:	e8 a4 26 00 00       	call   f0106740 <cpunum>
f010409c:	6b c0 74             	imul   $0x74,%eax,%eax
f010409f:	39 98 28 60 20 f0    	cmp    %ebx,-0xfdf9fd8(%eax)
f01040a5:	0f 84 af 00 00 00    	je     f010415a <env_run+0xcd>
		if (curenv != NULL && curenv->env_status == ENV_RUNNING)
f01040ab:	e8 90 26 00 00       	call   f0106740 <cpunum>
f01040b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01040b3:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f01040ba:	74 29                	je     f01040e5 <env_run+0x58>
f01040bc:	e8 7f 26 00 00       	call   f0106740 <cpunum>
f01040c1:	6b c0 74             	imul   $0x74,%eax,%eax
f01040c4:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01040ca:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01040ce:	75 15                	jne    f01040e5 <env_run+0x58>
		{
			curenv->env_status = ENV_RUNNABLE;
f01040d0:	e8 6b 26 00 00       	call   f0106740 <cpunum>
f01040d5:	6b c0 74             	imul   $0x74,%eax,%eax
f01040d8:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01040de:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
		}
		curenv = e;
f01040e5:	e8 56 26 00 00       	call   f0106740 <cpunum>
f01040ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01040ed:	89 98 28 60 20 f0    	mov    %ebx,-0xfdf9fd8(%eax)
		curenv->env_status = ENV_RUNNING; 
f01040f3:	e8 48 26 00 00       	call   f0106740 <cpunum>
f01040f8:	6b c0 74             	imul   $0x74,%eax,%eax
f01040fb:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104101:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0104108:	e8 33 26 00 00       	call   f0106740 <cpunum>
f010410d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104110:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104116:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f010411a:	e8 21 26 00 00       	call   f0106740 <cpunum>
f010411f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104122:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104128:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010412b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104130:	77 20                	ja     f0104152 <env_run+0xc5>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104132:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104136:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f010413d:	f0 
f010413e:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
f0104145:	00 
f0104146:	c7 04 24 0d 82 10 f0 	movl   $0xf010820d,(%esp)
f010414d:	e8 ee be ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104152:	05 00 00 00 10       	add    $0x10000000,%eax
f0104157:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010415a:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f0104161:	e8 4d 29 00 00       	call   f0106ab3 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0104166:	f3 90                	pause  
	}
	unlock_kernel();
	env_pop_tf(&curenv->env_tf);
f0104168:	e8 d3 25 00 00       	call   f0106740 <cpunum>
f010416d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104170:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104176:	89 04 24             	mov    %eax,(%esp)
f0104179:	e8 cc fe ff ff       	call   f010404a <env_pop_tf>
	...

f0104180 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0104180:	55                   	push   %ebp
f0104181:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104183:	ba 70 00 00 00       	mov    $0x70,%edx
f0104188:	8b 45 08             	mov    0x8(%ebp),%eax
f010418b:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010418c:	b2 71                	mov    $0x71,%dl
f010418e:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010418f:	0f b6 c0             	movzbl %al,%eax
}
f0104192:	5d                   	pop    %ebp
f0104193:	c3                   	ret    

f0104194 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0104194:	55                   	push   %ebp
f0104195:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104197:	ba 70 00 00 00       	mov    $0x70,%edx
f010419c:	8b 45 08             	mov    0x8(%ebp),%eax
f010419f:	ee                   	out    %al,(%dx)
f01041a0:	b2 71                	mov    $0x71,%dl
f01041a2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041a5:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01041a6:	5d                   	pop    %ebp
f01041a7:	c3                   	ret    

f01041a8 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01041a8:	55                   	push   %ebp
f01041a9:	89 e5                	mov    %esp,%ebp
f01041ab:	56                   	push   %esi
f01041ac:	53                   	push   %ebx
f01041ad:	83 ec 10             	sub    $0x10,%esp
f01041b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01041b3:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f01041b5:	66 a3 a8 23 12 f0    	mov    %ax,0xf01223a8
	if (!didinit)
f01041bb:	80 3d 54 52 20 f0 00 	cmpb   $0x0,0xf0205254
f01041c2:	74 4e                	je     f0104212 <irq_setmask_8259A+0x6a>
f01041c4:	ba 21 00 00 00       	mov    $0x21,%edx
f01041c9:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f01041ca:	89 f0                	mov    %esi,%eax
f01041cc:	66 c1 e8 08          	shr    $0x8,%ax
f01041d0:	b2 a1                	mov    $0xa1,%dl
f01041d2:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01041d3:	c7 04 24 62 82 10 f0 	movl   $0xf0108262,(%esp)
f01041da:	e8 0b 01 00 00       	call   f01042ea <cprintf>
	for (i = 0; i < 16; i++)
f01041df:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01041e4:	0f b7 f6             	movzwl %si,%esi
f01041e7:	f7 d6                	not    %esi
f01041e9:	0f a3 de             	bt     %ebx,%esi
f01041ec:	73 10                	jae    f01041fe <irq_setmask_8259A+0x56>
			cprintf(" %d", i);
f01041ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01041f2:	c7 04 24 d3 87 10 f0 	movl   $0xf01087d3,(%esp)
f01041f9:	e8 ec 00 00 00       	call   f01042ea <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f01041fe:	83 c3 01             	add    $0x1,%ebx
f0104201:	83 fb 10             	cmp    $0x10,%ebx
f0104204:	75 e3                	jne    f01041e9 <irq_setmask_8259A+0x41>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0104206:	c7 04 24 be 81 10 f0 	movl   $0xf01081be,(%esp)
f010420d:	e8 d8 00 00 00       	call   f01042ea <cprintf>
}
f0104212:	83 c4 10             	add    $0x10,%esp
f0104215:	5b                   	pop    %ebx
f0104216:	5e                   	pop    %esi
f0104217:	5d                   	pop    %ebp
f0104218:	c3                   	ret    

f0104219 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0104219:	55                   	push   %ebp
f010421a:	89 e5                	mov    %esp,%ebp
f010421c:	83 ec 18             	sub    $0x18,%esp
	didinit = 1;
f010421f:	c6 05 54 52 20 f0 01 	movb   $0x1,0xf0205254
f0104226:	ba 21 00 00 00       	mov    $0x21,%edx
f010422b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104230:	ee                   	out    %al,(%dx)
f0104231:	b2 a1                	mov    $0xa1,%dl
f0104233:	ee                   	out    %al,(%dx)
f0104234:	b2 20                	mov    $0x20,%dl
f0104236:	b8 11 00 00 00       	mov    $0x11,%eax
f010423b:	ee                   	out    %al,(%dx)
f010423c:	b2 21                	mov    $0x21,%dl
f010423e:	b8 20 00 00 00       	mov    $0x20,%eax
f0104243:	ee                   	out    %al,(%dx)
f0104244:	b8 04 00 00 00       	mov    $0x4,%eax
f0104249:	ee                   	out    %al,(%dx)
f010424a:	b8 03 00 00 00       	mov    $0x3,%eax
f010424f:	ee                   	out    %al,(%dx)
f0104250:	b2 a0                	mov    $0xa0,%dl
f0104252:	b8 11 00 00 00       	mov    $0x11,%eax
f0104257:	ee                   	out    %al,(%dx)
f0104258:	b2 a1                	mov    $0xa1,%dl
f010425a:	b8 28 00 00 00       	mov    $0x28,%eax
f010425f:	ee                   	out    %al,(%dx)
f0104260:	b8 02 00 00 00       	mov    $0x2,%eax
f0104265:	ee                   	out    %al,(%dx)
f0104266:	b8 01 00 00 00       	mov    $0x1,%eax
f010426b:	ee                   	out    %al,(%dx)
f010426c:	b2 20                	mov    $0x20,%dl
f010426e:	b8 68 00 00 00       	mov    $0x68,%eax
f0104273:	ee                   	out    %al,(%dx)
f0104274:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104279:	ee                   	out    %al,(%dx)
f010427a:	b2 a0                	mov    $0xa0,%dl
f010427c:	b8 68 00 00 00       	mov    $0x68,%eax
f0104281:	ee                   	out    %al,(%dx)
f0104282:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104287:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0104288:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f010428f:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104293:	74 0b                	je     f01042a0 <pic_init+0x87>
		irq_setmask_8259A(irq_mask_8259A);
f0104295:	0f b7 c0             	movzwl %ax,%eax
f0104298:	89 04 24             	mov    %eax,(%esp)
f010429b:	e8 08 ff ff ff       	call   f01041a8 <irq_setmask_8259A>
}
f01042a0:	c9                   	leave  
f01042a1:	c3                   	ret    
	...

f01042a4 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01042a4:	55                   	push   %ebp
f01042a5:	89 e5                	mov    %esp,%ebp
f01042a7:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f01042aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01042ad:	89 04 24             	mov    %eax,(%esp)
f01042b0:	e8 22 c5 ff ff       	call   f01007d7 <cputchar>
	*cnt++;
}
f01042b5:	c9                   	leave  
f01042b6:	c3                   	ret    

f01042b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01042b7:	55                   	push   %ebp
f01042b8:	89 e5                	mov    %esp,%ebp
f01042ba:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f01042bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01042c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01042c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01042cb:	8b 45 08             	mov    0x8(%ebp),%eax
f01042ce:	89 44 24 08          	mov    %eax,0x8(%esp)
f01042d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01042d5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01042d9:	c7 04 24 a4 42 10 f0 	movl   $0xf01042a4,(%esp)
f01042e0:	e8 b5 16 00 00       	call   f010599a <vprintfmt>
	return cnt;
}
f01042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01042e8:	c9                   	leave  
f01042e9:	c3                   	ret    

f01042ea <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01042ea:	55                   	push   %ebp
f01042eb:	89 e5                	mov    %esp,%ebp
f01042ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01042f0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01042f3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01042f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01042fa:	89 04 24             	mov    %eax,(%esp)
f01042fd:	e8 b5 ff ff ff       	call   f01042b7 <vcprintf>
	va_end(ap);

	return cnt;
}
f0104302:	c9                   	leave  
f0104303:	c3                   	ret    
	...

f0104310 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0104310:	55                   	push   %ebp
f0104311:	89 e5                	mov    %esp,%ebp
f0104313:	57                   	push   %edi
f0104314:	56                   	push   %esi
f0104315:	53                   	push   %ebx
f0104316:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here:
	

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - cpunum() * (KSTKSIZE + KSTKGAP);
f0104319:	e8 22 24 00 00       	call   f0106740 <cpunum>
f010431e:	89 c3                	mov    %eax,%ebx
f0104320:	e8 1b 24 00 00       	call   f0106740 <cpunum>
f0104325:	6b db 74             	imul   $0x74,%ebx,%ebx
f0104328:	f7 d8                	neg    %eax
f010432a:	c1 e0 10             	shl    $0x10,%eax
f010432d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0104332:	89 83 30 60 20 f0    	mov    %eax,-0xfdf9fd0(%ebx)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104338:	e8 03 24 00 00       	call   f0106740 <cpunum>
f010433d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104340:	66 c7 80 34 60 20 f0 	movw   $0x10,-0xfdf9fcc(%eax)
f0104347:	10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + cpunum()] = SEG16(STS_T32A, (uint32_t) (& (thiscpu->cpu_ts)),
f0104349:	e8 f2 23 00 00       	call   f0106740 <cpunum>
f010434e:	8d 58 05             	lea    0x5(%eax),%ebx
f0104351:	e8 ea 23 00 00       	call   f0106740 <cpunum>
f0104356:	89 c6                	mov    %eax,%esi
f0104358:	e8 e3 23 00 00       	call   f0106740 <cpunum>
f010435d:	89 c7                	mov    %eax,%edi
f010435f:	e8 dc 23 00 00       	call   f0106740 <cpunum>
f0104364:	66 c7 04 dd 40 23 12 	movw   $0x68,-0xfeddcc0(,%ebx,8)
f010436b:	f0 68 00 
f010436e:	6b f6 74             	imul   $0x74,%esi,%esi
f0104371:	81 c6 2c 60 20 f0    	add    $0xf020602c,%esi
f0104377:	66 89 34 dd 42 23 12 	mov    %si,-0xfeddcbe(,%ebx,8)
f010437e:	f0 
f010437f:	6b d7 74             	imul   $0x74,%edi,%edx
f0104382:	81 c2 2c 60 20 f0    	add    $0xf020602c,%edx
f0104388:	c1 ea 10             	shr    $0x10,%edx
f010438b:	88 14 dd 44 23 12 f0 	mov    %dl,-0xfeddcbc(,%ebx,8)
f0104392:	c6 04 dd 45 23 12 f0 	movb   $0x99,-0xfeddcbb(,%ebx,8)
f0104399:	99 
f010439a:	c6 04 dd 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%ebx,8)
f01043a1:	40 
f01043a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a5:	05 2c 60 20 f0       	add    $0xf020602c,%eax
f01043aa:	c1 e8 18             	shr    $0x18,%eax
f01043ad:	88 04 dd 47 23 12 f0 	mov    %al,-0xfeddcb9(,%ebx,8)
					sizeof(struct Taskstate), 0);
	gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;
f01043b4:	e8 87 23 00 00       	call   f0106740 <cpunum>
f01043b9:	80 24 c5 6d 23 12 f0 	andb   $0xef,-0xfeddc93(,%eax,8)
f01043c0:	ef 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(((GD_TSS0 >> 3) + cpunum()) << 3);
f01043c1:	e8 7a 23 00 00       	call   f0106740 <cpunum>
f01043c6:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01043cd:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f01043d0:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f01043d5:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f01043d8:	83 c4 0c             	add    $0xc,%esp
f01043db:	5b                   	pop    %ebx
f01043dc:	5e                   	pop    %esi
f01043dd:	5f                   	pop    %edi
f01043de:	5d                   	pop    %ebp
f01043df:	c3                   	ret    

f01043e0 <trap_init>:
}


void
trap_init(void)
{
f01043e0:	55                   	push   %ebp
f01043e1:	89 e5                	mov    %esp,%ebp
f01043e3:	83 ec 08             	sub    $0x8,%esp
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
	extern int vectors[];
	int idx;
	for(idx = 0; idx < 19; idx ++){
f01043e6:	b8 00 00 00 00       	mov    $0x0,%eax
		int dpl = 0;
f01043eb:	ba 00 00 00 00       	mov    $0x0,%edx
f01043f0:	eb 0b                	jmp    f01043fd <trap_init+0x1d>
		if(idx == T_BRKPT || idx == T_OFLOW || idx == T_BOUND)dpl = 3;
f01043f2:	8d 50 fd             	lea    -0x3(%eax),%edx

	// LAB 3: Your code here.
	extern int vectors[];
	int idx;
	for(idx = 0; idx < 19; idx ++){
		int dpl = 0;
f01043f5:	83 fa 03             	cmp    $0x3,%edx
f01043f8:	19 d2                	sbb    %edx,%edx
f01043fa:	83 e2 03             	and    $0x3,%edx
		if(idx == T_BRKPT || idx == T_OFLOW || idx == T_BOUND)dpl = 3;
		SETGATE(idt[idx], 0, GD_KT, vectors[idx], dpl);
f01043fd:	8b 0c 85 b4 23 12 f0 	mov    -0xfeddc4c(,%eax,4),%ecx
f0104404:	66 89 0c c5 60 52 20 	mov    %cx,-0xfdfada0(,%eax,8)
f010440b:	f0 
f010440c:	66 c7 04 c5 62 52 20 	movw   $0x8,-0xfdfad9e(,%eax,8)
f0104413:	f0 08 00 
f0104416:	c6 04 c5 64 52 20 f0 	movb   $0x0,-0xfdfad9c(,%eax,8)
f010441d:	00 
f010441e:	83 e2 03             	and    $0x3,%edx
f0104421:	c1 e2 05             	shl    $0x5,%edx
f0104424:	83 ca 8e             	or     $0xffffff8e,%edx
f0104427:	88 14 c5 65 52 20 f0 	mov    %dl,-0xfdfad9b(,%eax,8)
f010442e:	c1 e9 10             	shr    $0x10,%ecx
f0104431:	66 89 0c c5 66 52 20 	mov    %cx,-0xfdfad9a(,%eax,8)
f0104438:	f0 
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
	extern int vectors[];
	int idx;
	for(idx = 0; idx < 19; idx ++){
f0104439:	83 c0 01             	add    $0x1,%eax
f010443c:	83 f8 13             	cmp    $0x13,%eax
f010443f:	75 b1                	jne    f01043f2 <trap_init+0x12>
		if(idx == T_BRKPT || idx == T_OFLOW || idx == T_BOUND)dpl = 3;
		SETGATE(idt[idx], 0, GD_KT, vectors[idx], dpl);
	}
	
	extern int routine_syscall;
	SETGATE(idt[T_SYSCALL], 0, GD_KT, &routine_syscall, 3);
f0104441:	b8 8e 4b 10 f0       	mov    $0xf0104b8e,%eax
f0104446:	66 a3 e0 53 20 f0    	mov    %ax,0xf02053e0
f010444c:	66 c7 05 e2 53 20 f0 	movw   $0x8,0xf02053e2
f0104453:	08 00 
f0104455:	c6 05 e4 53 20 f0 00 	movb   $0x0,0xf02053e4
f010445c:	c6 05 e5 53 20 f0 ee 	movb   $0xee,0xf02053e5
f0104463:	c1 e8 10             	shr    $0x10,%eax
f0104466:	66 a3 e6 53 20 f0    	mov    %ax,0xf02053e6
f010446c:	b8 20 00 00 00       	mov    $0x20,%eax
	
	for(idx = 0; idx < 16; idx ++){
		SETGATE(idt[IRQ_OFFSET + idx], 0, GD_KT, vectors[21 + idx], 0);
f0104471:	8b 14 85 88 23 12 f0 	mov    -0xfeddc78(,%eax,4),%edx
f0104478:	66 89 14 c5 60 52 20 	mov    %dx,-0xfdfada0(,%eax,8)
f010447f:	f0 
f0104480:	66 c7 04 c5 62 52 20 	movw   $0x8,-0xfdfad9e(,%eax,8)
f0104487:	f0 08 00 
f010448a:	c6 04 c5 64 52 20 f0 	movb   $0x0,-0xfdfad9c(,%eax,8)
f0104491:	00 
f0104492:	c6 04 c5 65 52 20 f0 	movb   $0x8e,-0xfdfad9b(,%eax,8)
f0104499:	8e 
f010449a:	c1 ea 10             	shr    $0x10,%edx
f010449d:	66 89 14 c5 66 52 20 	mov    %dx,-0xfdfad9a(,%eax,8)
f01044a4:	f0 
f01044a5:	83 c0 01             	add    $0x1,%eax
	}
	
	extern int routine_syscall;
	SETGATE(idt[T_SYSCALL], 0, GD_KT, &routine_syscall, 3);
	
	for(idx = 0; idx < 16; idx ++){
f01044a8:	83 f8 30             	cmp    $0x30,%eax
f01044ab:	75 c4                	jne    f0104471 <trap_init+0x91>
		SETGATE(idt[IRQ_OFFSET + idx], 0, GD_KT, vectors[21 + idx], 0);
	}
	
	
	trap_init_percpu();
f01044ad:	e8 5e fe ff ff       	call   f0104310 <trap_init_percpu>
}
f01044b2:	c9                   	leave  
f01044b3:	c3                   	ret    

f01044b4 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01044b4:	55                   	push   %ebp
f01044b5:	89 e5                	mov    %esp,%ebp
f01044b7:	53                   	push   %ebx
f01044b8:	83 ec 14             	sub    $0x14,%esp
f01044bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01044be:	8b 03                	mov    (%ebx),%eax
f01044c0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044c4:	c7 04 24 76 82 10 f0 	movl   $0xf0108276,(%esp)
f01044cb:	e8 1a fe ff ff       	call   f01042ea <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01044d0:	8b 43 04             	mov    0x4(%ebx),%eax
f01044d3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044d7:	c7 04 24 85 82 10 f0 	movl   $0xf0108285,(%esp)
f01044de:	e8 07 fe ff ff       	call   f01042ea <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01044e3:	8b 43 08             	mov    0x8(%ebx),%eax
f01044e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044ea:	c7 04 24 94 82 10 f0 	movl   $0xf0108294,(%esp)
f01044f1:	e8 f4 fd ff ff       	call   f01042ea <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01044f6:	8b 43 0c             	mov    0xc(%ebx),%eax
f01044f9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044fd:	c7 04 24 a3 82 10 f0 	movl   $0xf01082a3,(%esp)
f0104504:	e8 e1 fd ff ff       	call   f01042ea <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104509:	8b 43 10             	mov    0x10(%ebx),%eax
f010450c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104510:	c7 04 24 b2 82 10 f0 	movl   $0xf01082b2,(%esp)
f0104517:	e8 ce fd ff ff       	call   f01042ea <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010451c:	8b 43 14             	mov    0x14(%ebx),%eax
f010451f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104523:	c7 04 24 c1 82 10 f0 	movl   $0xf01082c1,(%esp)
f010452a:	e8 bb fd ff ff       	call   f01042ea <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010452f:	8b 43 18             	mov    0x18(%ebx),%eax
f0104532:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104536:	c7 04 24 d0 82 10 f0 	movl   $0xf01082d0,(%esp)
f010453d:	e8 a8 fd ff ff       	call   f01042ea <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104542:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0104545:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104549:	c7 04 24 df 82 10 f0 	movl   $0xf01082df,(%esp)
f0104550:	e8 95 fd ff ff       	call   f01042ea <cprintf>
}
f0104555:	83 c4 14             	add    $0x14,%esp
f0104558:	5b                   	pop    %ebx
f0104559:	5d                   	pop    %ebp
f010455a:	c3                   	ret    

f010455b <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f010455b:	55                   	push   %ebp
f010455c:	89 e5                	mov    %esp,%ebp
f010455e:	56                   	push   %esi
f010455f:	53                   	push   %ebx
f0104560:	83 ec 10             	sub    $0x10,%esp
f0104563:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104566:	e8 d5 21 00 00       	call   f0106740 <cpunum>
f010456b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010456f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104573:	c7 04 24 43 83 10 f0 	movl   $0xf0108343,(%esp)
f010457a:	e8 6b fd ff ff       	call   f01042ea <cprintf>
	print_regs(&tf->tf_regs);
f010457f:	89 1c 24             	mov    %ebx,(%esp)
f0104582:	e8 2d ff ff ff       	call   f01044b4 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104587:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f010458b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010458f:	c7 04 24 61 83 10 f0 	movl   $0xf0108361,(%esp)
f0104596:	e8 4f fd ff ff       	call   f01042ea <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010459b:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f010459f:	89 44 24 04          	mov    %eax,0x4(%esp)
f01045a3:	c7 04 24 74 83 10 f0 	movl   $0xf0108374,(%esp)
f01045aa:	e8 3b fd ff ff       	call   f01042ea <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01045af:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f01045b2:	83 f8 13             	cmp    $0x13,%eax
f01045b5:	77 09                	ja     f01045c0 <print_trapframe+0x65>
		return excnames[trapno];
f01045b7:	8b 14 85 00 86 10 f0 	mov    -0xfef7a00(,%eax,4),%edx
f01045be:	eb 1d                	jmp    f01045dd <print_trapframe+0x82>
	if (trapno == T_SYSCALL)
		return "System call";
f01045c0:	ba ee 82 10 f0       	mov    $0xf01082ee,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
f01045c5:	83 f8 30             	cmp    $0x30,%eax
f01045c8:	74 13                	je     f01045dd <print_trapframe+0x82>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01045ca:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01045cd:	83 fa 0f             	cmp    $0xf,%edx
f01045d0:	ba fa 82 10 f0       	mov    $0xf01082fa,%edx
f01045d5:	b9 0d 83 10 f0       	mov    $0xf010830d,%ecx
f01045da:	0f 47 d1             	cmova  %ecx,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01045dd:	89 54 24 08          	mov    %edx,0x8(%esp)
f01045e1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01045e5:	c7 04 24 87 83 10 f0 	movl   $0xf0108387,(%esp)
f01045ec:	e8 f9 fc ff ff       	call   f01042ea <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01045f1:	3b 1d 60 5a 20 f0    	cmp    0xf0205a60,%ebx
f01045f7:	75 19                	jne    f0104612 <print_trapframe+0xb7>
f01045f9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01045fd:	75 13                	jne    f0104612 <print_trapframe+0xb7>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f01045ff:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104602:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104606:	c7 04 24 99 83 10 f0 	movl   $0xf0108399,(%esp)
f010460d:	e8 d8 fc ff ff       	call   f01042ea <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0104612:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104615:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104619:	c7 04 24 a8 83 10 f0 	movl   $0xf01083a8,(%esp)
f0104620:	e8 c5 fc ff ff       	call   f01042ea <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104625:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104629:	75 51                	jne    f010467c <print_trapframe+0x121>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f010462b:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f010462e:	89 c2                	mov    %eax,%edx
f0104630:	83 e2 01             	and    $0x1,%edx
f0104633:	ba 1c 83 10 f0       	mov    $0xf010831c,%edx
f0104638:	b9 27 83 10 f0       	mov    $0xf0108327,%ecx
f010463d:	0f 45 ca             	cmovne %edx,%ecx
f0104640:	89 c2                	mov    %eax,%edx
f0104642:	83 e2 02             	and    $0x2,%edx
f0104645:	ba 33 83 10 f0       	mov    $0xf0108333,%edx
f010464a:	be 39 83 10 f0       	mov    $0xf0108339,%esi
f010464f:	0f 44 d6             	cmove  %esi,%edx
f0104652:	83 e0 04             	and    $0x4,%eax
f0104655:	b8 3e 83 10 f0       	mov    $0xf010833e,%eax
f010465a:	be 8b 84 10 f0       	mov    $0xf010848b,%esi
f010465f:	0f 44 c6             	cmove  %esi,%eax
f0104662:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104666:	89 54 24 08          	mov    %edx,0x8(%esp)
f010466a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010466e:	c7 04 24 b6 83 10 f0 	movl   $0xf01083b6,(%esp)
f0104675:	e8 70 fc ff ff       	call   f01042ea <cprintf>
f010467a:	eb 0c                	jmp    f0104688 <print_trapframe+0x12d>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f010467c:	c7 04 24 be 81 10 f0 	movl   $0xf01081be,(%esp)
f0104683:	e8 62 fc ff ff       	call   f01042ea <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104688:	8b 43 30             	mov    0x30(%ebx),%eax
f010468b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010468f:	c7 04 24 c5 83 10 f0 	movl   $0xf01083c5,(%esp)
f0104696:	e8 4f fc ff ff       	call   f01042ea <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010469b:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010469f:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046a3:	c7 04 24 d4 83 10 f0 	movl   $0xf01083d4,(%esp)
f01046aa:	e8 3b fc ff ff       	call   f01042ea <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01046af:	8b 43 38             	mov    0x38(%ebx),%eax
f01046b2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046b6:	c7 04 24 e7 83 10 f0 	movl   $0xf01083e7,(%esp)
f01046bd:	e8 28 fc ff ff       	call   f01042ea <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01046c2:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01046c6:	74 27                	je     f01046ef <print_trapframe+0x194>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01046c8:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01046cb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046cf:	c7 04 24 f6 83 10 f0 	movl   $0xf01083f6,(%esp)
f01046d6:	e8 0f fc ff ff       	call   f01042ea <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01046db:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01046df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046e3:	c7 04 24 05 84 10 f0 	movl   $0xf0108405,(%esp)
f01046ea:	e8 fb fb ff ff       	call   f01042ea <cprintf>
	}
}
f01046ef:	83 c4 10             	add    $0x10,%esp
f01046f2:	5b                   	pop    %ebx
f01046f3:	5e                   	pop    %esi
f01046f4:	5d                   	pop    %ebp
f01046f5:	c3                   	ret    

f01046f6 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01046f6:	55                   	push   %ebp
f01046f7:	89 e5                	mov    %esp,%ebp
f01046f9:	83 ec 38             	sub    $0x38,%esp
f01046fc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01046ff:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0104702:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104708:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs & 3) == 0)
f010470b:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010470f:	75 1c                	jne    f010472d <page_fault_handler+0x37>
		panic ("kernel-mode page faults");
f0104711:	c7 44 24 08 18 84 10 	movl   $0xf0108418,0x8(%esp)
f0104718:	f0 
f0104719:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
f0104720:	00 
f0104721:	c7 04 24 30 84 10 f0 	movl   $0xf0108430,(%esp)
f0104728:	e8 13 b9 ff ff       	call   f0100040 <_panic>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if(curenv->env_pgfault_upcall != NULL){
f010472d:	e8 0e 20 00 00       	call   f0106740 <cpunum>
f0104732:	6b c0 74             	imul   $0x74,%eax,%eax
f0104735:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010473b:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010473f:	0f 84 fd 00 00 00    	je     f0104842 <page_fault_handler+0x14c>
		struct UTrapframe *utf;
		if(UXSTACKTOP - PGSIZE <= tf->tf_esp && tf->tf_esp < UXSTACKTOP)
f0104745:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104748:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			//push a empty one 4
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(struct UTrapframe) - 4);
f010474e:	83 e8 38             	sub    $0x38,%eax
f0104751:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0104757:	ba cc ff bf ee       	mov    $0xeebfffcc,%edx
f010475c:	0f 46 d0             	cmovbe %eax,%edx
f010475f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		else utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_U | PTE_W);
f0104762:	e8 d9 1f 00 00       	call   f0106740 <cpunum>
f0104767:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f010476e:	00 
f010476f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0104776:	00 
f0104777:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010477a:	89 54 24 04          	mov    %edx,0x4(%esp)
f010477e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104781:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104787:	89 04 24             	mov    %eax,(%esp)
f010478a:	e8 68 f1 ff ff       	call   f01038f7 <user_mem_assert>
		utf->utf_eflags = tf->tf_eflags;
f010478f:	8b 43 38             	mov    0x38(%ebx),%eax
f0104792:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104795:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_eip = tf->tf_eip;
f0104798:	8b 43 30             	mov    0x30(%ebx),%eax
f010479b:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_err = tf->tf_err;
f010479e:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01047a1:	89 42 04             	mov    %eax,0x4(%edx)
		utf->utf_esp = tf->tf_esp;
f01047a4:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01047a7:	89 42 30             	mov    %eax,0x30(%edx)
		utf->utf_fault_va = fault_va;
f01047aa:	89 32                	mov    %esi,(%edx)
		utf->utf_regs = tf->tf_regs;
f01047ac:	89 d7                	mov    %edx,%edi
f01047ae:	83 c7 08             	add    $0x8,%edi
f01047b1:	89 de                	mov    %ebx,%esi
f01047b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01047b8:	f7 c7 01 00 00 00    	test   $0x1,%edi
f01047be:	74 03                	je     f01047c3 <page_fault_handler+0xcd>
f01047c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f01047c1:	b0 1f                	mov    $0x1f,%al
f01047c3:	f7 c7 02 00 00 00    	test   $0x2,%edi
f01047c9:	74 05                	je     f01047d0 <page_fault_handler+0xda>
f01047cb:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f01047cd:	83 e8 02             	sub    $0x2,%eax
f01047d0:	89 c1                	mov    %eax,%ecx
f01047d2:	c1 e9 02             	shr    $0x2,%ecx
f01047d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01047d7:	ba 00 00 00 00       	mov    $0x0,%edx
f01047dc:	a8 02                	test   $0x2,%al
f01047de:	74 0b                	je     f01047eb <page_fault_handler+0xf5>
f01047e0:	0f b7 16             	movzwl (%esi),%edx
f01047e3:	66 89 17             	mov    %dx,(%edi)
f01047e6:	ba 02 00 00 00       	mov    $0x2,%edx
f01047eb:	a8 01                	test   $0x1,%al
f01047ed:	74 07                	je     f01047f6 <page_fault_handler+0x100>
f01047ef:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
f01047f3:	88 04 17             	mov    %al,(%edi,%edx,1)
		curenv->env_tf.tf_eip = (uint32_t) curenv->env_pgfault_upcall;
f01047f6:	e8 45 1f 00 00       	call   f0106740 <cpunum>
f01047fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01047fe:	8b 98 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%ebx
f0104804:	e8 37 1f 00 00       	call   f0106740 <cpunum>
f0104809:	6b c0 74             	imul   $0x74,%eax,%eax
f010480c:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104812:	8b 40 64             	mov    0x64(%eax),%eax
f0104815:	89 43 30             	mov    %eax,0x30(%ebx)
		curenv->env_tf.tf_esp = (uint32_t) utf;
f0104818:	e8 23 1f 00 00       	call   f0106740 <cpunum>
f010481d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104820:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104826:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104829:	89 50 3c             	mov    %edx,0x3c(%eax)
		env_run(curenv);
f010482c:	e8 0f 1f 00 00       	call   f0106740 <cpunum>
f0104831:	6b c0 74             	imul   $0x74,%eax,%eax
f0104834:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010483a:	89 04 24             	mov    %eax,(%esp)
f010483d:	e8 4b f8 ff ff       	call   f010408d <env_run>
	}
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104842:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104845:	e8 f6 1e 00 00       	call   f0106740 <cpunum>
		curenv->env_tf.tf_eip = (uint32_t) curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uint32_t) utf;
		env_run(curenv);
	}
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010484a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010484e:	89 74 24 08          	mov    %esi,0x8(%esp)
		curenv->env_id, fault_va, tf->tf_eip);
f0104852:	6b c0 74             	imul   $0x74,%eax,%eax
f0104855:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
		curenv->env_tf.tf_eip = (uint32_t) curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uint32_t) utf;
		env_run(curenv);
	}
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010485b:	8b 40 48             	mov    0x48(%eax),%eax
f010485e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104862:	c7 04 24 d8 85 10 f0 	movl   $0xf01085d8,(%esp)
f0104869:	e8 7c fa ff ff       	call   f01042ea <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f010486e:	89 1c 24             	mov    %ebx,(%esp)
f0104871:	e8 e5 fc ff ff       	call   f010455b <print_trapframe>
	env_destroy(curenv);
f0104876:	e8 c5 1e 00 00       	call   f0106740 <cpunum>
f010487b:	6b c0 74             	imul   $0x74,%eax,%eax
f010487e:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104884:	89 04 24             	mov    %eax,(%esp)
f0104887:	e8 60 f7 ff ff       	call   f0103fec <env_destroy>
}
f010488c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010488f:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0104892:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0104895:	89 ec                	mov    %ebp,%esp
f0104897:	5d                   	pop    %ebp
f0104898:	c3                   	ret    

f0104899 <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0104899:	55                   	push   %ebp
f010489a:	89 e5                	mov    %esp,%ebp
f010489c:	57                   	push   %edi
f010489d:	56                   	push   %esi
f010489e:	83 ec 20             	sub    $0x20,%esp
f01048a1:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f01048a4:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f01048a5:	83 3d 80 5e 20 f0 00 	cmpl   $0x0,0xf0205e80
f01048ac:	74 01                	je     f01048af <trap+0x16>
		asm volatile("hlt");
f01048ae:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01048af:	e8 8c 1e 00 00       	call   f0106740 <cpunum>
f01048b4:	6b d0 74             	imul   $0x74,%eax,%edx
f01048b7:	81 c2 20 60 20 f0    	add    $0xf0206020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f01048bd:	b8 01 00 00 00       	mov    $0x1,%eax
f01048c2:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f01048c6:	83 f8 02             	cmp    $0x2,%eax
f01048c9:	75 0c                	jne    f01048d7 <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01048cb:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f01048d2:	e8 19 21 00 00       	call   f01069f0 <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f01048d7:	9c                   	pushf  
f01048d8:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f01048d9:	f6 c4 02             	test   $0x2,%ah
f01048dc:	74 24                	je     f0104902 <trap+0x69>
f01048de:	c7 44 24 0c 3c 84 10 	movl   $0xf010843c,0xc(%esp)
f01048e5:	f0 
f01048e6:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f01048ed:	f0 
f01048ee:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
f01048f5:	00 
f01048f6:	c7 04 24 30 84 10 f0 	movl   $0xf0108430,(%esp)
f01048fd:	e8 3e b7 ff ff       	call   f0100040 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0104902:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104906:	83 e0 03             	and    $0x3,%eax
f0104909:	83 f8 03             	cmp    $0x3,%eax
f010490c:	0f 85 a7 00 00 00    	jne    f01049b9 <trap+0x120>
f0104912:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f0104919:	e8 d2 20 00 00       	call   f01069f0 <spin_lock>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
		assert(curenv);
f010491e:	e8 1d 1e 00 00       	call   f0106740 <cpunum>
f0104923:	6b c0 74             	imul   $0x74,%eax,%eax
f0104926:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f010492d:	75 24                	jne    f0104953 <trap+0xba>
f010492f:	c7 44 24 0c 55 84 10 	movl   $0xf0108455,0xc(%esp)
f0104936:	f0 
f0104937:	c7 44 24 08 13 7f 10 	movl   $0xf0107f13,0x8(%esp)
f010493e:	f0 
f010493f:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
f0104946:	00 
f0104947:	c7 04 24 30 84 10 f0 	movl   $0xf0108430,(%esp)
f010494e:	e8 ed b6 ff ff       	call   f0100040 <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f0104953:	e8 e8 1d 00 00       	call   f0106740 <cpunum>
f0104958:	6b c0 74             	imul   $0x74,%eax,%eax
f010495b:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104961:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104965:	75 2d                	jne    f0104994 <trap+0xfb>
			env_free(curenv);
f0104967:	e8 d4 1d 00 00       	call   f0106740 <cpunum>
f010496c:	6b c0 74             	imul   $0x74,%eax,%eax
f010496f:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104975:	89 04 24             	mov    %eax,(%esp)
f0104978:	e8 9f f4 ff ff       	call   f0103e1c <env_free>
			curenv = NULL;
f010497d:	e8 be 1d 00 00       	call   f0106740 <cpunum>
f0104982:	6b c0 74             	imul   $0x74,%eax,%eax
f0104985:	c7 80 28 60 20 f0 00 	movl   $0x0,-0xfdf9fd8(%eax)
f010498c:	00 00 00 
			sched_yield();
f010498f:	e8 88 03 00 00       	call   f0104d1c <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f0104994:	e8 a7 1d 00 00       	call   f0106740 <cpunum>
f0104999:	6b c0 74             	imul   $0x74,%eax,%eax
f010499c:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01049a2:	b9 11 00 00 00       	mov    $0x11,%ecx
f01049a7:	89 c7                	mov    %eax,%edi
f01049a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f01049ab:	e8 90 1d 00 00       	call   f0106740 <cpunum>
f01049b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01049b3:	8b b0 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f01049b9:	89 35 60 5a 20 f0    	mov    %esi,0xf0205a60


	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01049bf:	8b 46 28             	mov    0x28(%esi),%eax
f01049c2:	83 f8 27             	cmp    $0x27,%eax
f01049c5:	75 19                	jne    f01049e0 <trap+0x147>
		cprintf("Spurious interrupt on irq 7\n");
f01049c7:	c7 04 24 5c 84 10 f0 	movl   $0xf010845c,(%esp)
f01049ce:	e8 17 f9 ff ff       	call   f01042ea <cprintf>
		print_trapframe(tf);
f01049d3:	89 34 24             	mov    %esi,(%esp)
f01049d6:	e8 80 fb ff ff       	call   f010455b <print_trapframe>
f01049db:	e9 b8 00 00 00       	jmp    f0104a98 <trap+0x1ff>
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER){
f01049e0:	83 f8 20             	cmp    $0x20,%eax
f01049e3:	75 0a                	jne    f01049ef <trap+0x156>
		//cprintf("NO: %d\n",tf->tf_trapno);
		lapic_eoi();
f01049e5:	e8 a1 1e 00 00       	call   f010688b <lapic_eoi>
		sched_yield();
f01049ea:	e8 2d 03 00 00       	call   f0104d1c <sched_yield>
	}

	if(tf->tf_trapno == T_PGFLT)
f01049ef:	83 f8 0e             	cmp    $0xe,%eax
f01049f2:	75 08                	jne    f01049fc <trap+0x163>
		page_fault_handler(tf);
f01049f4:	89 34 24             	mov    %esi,(%esp)
f01049f7:	e8 fa fc ff ff       	call   f01046f6 <page_fault_handler>
	if(tf->tf_trapno == T_BRKPT){
f01049fc:	83 7e 28 03          	cmpl   $0x3,0x28(%esi)
f0104a00:	75 08                	jne    f0104a0a <trap+0x171>
		monitor(tf);
f0104a02:	89 34 24             	mov    %esi,(%esp)
f0104a05:	e8 bd c2 ff ff       	call   f0100cc7 <monitor>
	}

	if(tf->tf_trapno == T_SYSCALL){
f0104a0a:	8b 46 28             	mov    0x28(%esi),%eax
f0104a0d:	83 f8 30             	cmp    $0x30,%eax
f0104a10:	75 32                	jne    f0104a44 <trap+0x1ab>
		int r;
		
		r = syscall(
f0104a12:	8b 46 04             	mov    0x4(%esi),%eax
f0104a15:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104a19:	8b 06                	mov    (%esi),%eax
f0104a1b:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104a1f:	8b 46 10             	mov    0x10(%esi),%eax
f0104a22:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104a26:	8b 46 18             	mov    0x18(%esi),%eax
f0104a29:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104a2d:	8b 46 14             	mov    0x14(%esi),%eax
f0104a30:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a34:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104a37:	89 04 24             	mov    %eax,(%esp)
f0104a3a:	e8 9a 03 00 00       	call   f0104dd9 <syscall>
/*		if(r < 0){
			cprintf("trap_number: %d\n", r);
			panic("trap_dispatch: The System Call number is invalid;");
		}
		
*/		tf->tf_regs.reg_eax = r;
f0104a3f:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104a42:	eb 54                	jmp    f0104a98 <trap+0x1ff>
	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.

	// Unexpected trap: The user process or the kernel has a bug.
	
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f0104a44:	83 f8 21             	cmp    $0x21,%eax
f0104a47:	75 0e                	jne    f0104a57 <trap+0x1be>
		lapic_eoi();
f0104a49:	e8 3d 1e 00 00       	call   f010688b <lapic_eoi>
		kbd_intr();
f0104a4e:	66 90                	xchg   %ax,%ax
f0104a50:	e8 02 bc ff ff       	call   f0100657 <kbd_intr>
f0104a55:	eb 41                	jmp    f0104a98 <trap+0x1ff>
		return;
	}
	print_trapframe(tf);
f0104a57:	89 34 24             	mov    %esi,(%esp)
f0104a5a:	e8 fc fa ff ff       	call   f010455b <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104a5f:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104a64:	75 1c                	jne    f0104a82 <trap+0x1e9>
		panic("unhandled trap in kernel");
f0104a66:	c7 44 24 08 79 84 10 	movl   $0xf0108479,0x8(%esp)
f0104a6d:	f0 
f0104a6e:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
f0104a75:	00 
f0104a76:	c7 04 24 30 84 10 f0 	movl   $0xf0108430,(%esp)
f0104a7d:	e8 be b5 ff ff       	call   f0100040 <_panic>
	else {
		env_destroy(curenv);
f0104a82:	e8 b9 1c 00 00       	call   f0106740 <cpunum>
f0104a87:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a8a:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104a90:	89 04 24             	mov    %eax,(%esp)
f0104a93:	e8 54 f5 ff ff       	call   f0103fec <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a98:	e8 a3 1c 00 00       	call   f0106740 <cpunum>
f0104a9d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104aa0:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f0104aa7:	74 2a                	je     f0104ad3 <trap+0x23a>
f0104aa9:	e8 92 1c 00 00       	call   f0106740 <cpunum>
f0104aae:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ab1:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104ab7:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104abb:	75 16                	jne    f0104ad3 <trap+0x23a>
		env_run(curenv);
f0104abd:	e8 7e 1c 00 00       	call   f0106740 <cpunum>
f0104ac2:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ac5:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104acb:	89 04 24             	mov    %eax,(%esp)
f0104ace:	e8 ba f5 ff ff       	call   f010408d <env_run>
	else
		sched_yield();
f0104ad3:	e8 44 02 00 00       	call   f0104d1c <sched_yield>

f0104ad8 <routine_divide>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(routine_divide, T_DIVIDE);  //0
f0104ad8:	6a 00                	push   $0x0
f0104ada:	6a 00                	push   $0x0
f0104adc:	e9 67 d9 01 00       	jmp    f0122448 <_alltraps>
f0104ae1:	90                   	nop

f0104ae2 <routine_debug>:
	TRAPHANDLER_NOEC(routine_debug, T_DEBUG);
f0104ae2:	6a 00                	push   $0x0
f0104ae4:	6a 01                	push   $0x1
f0104ae6:	e9 5d d9 01 00       	jmp    f0122448 <_alltraps>
f0104aeb:	90                   	nop

f0104aec <routine_nmi>:
	TRAPHANDLER_NOEC(routine_nmi, T_NMI);
f0104aec:	6a 00                	push   $0x0
f0104aee:	6a 02                	push   $0x2
f0104af0:	e9 53 d9 01 00       	jmp    f0122448 <_alltraps>
f0104af5:	90                   	nop

f0104af6 <routine_brkpt>:
	TRAPHANDLER_NOEC(routine_brkpt, T_BRKPT);
f0104af6:	6a 00                	push   $0x0
f0104af8:	6a 03                	push   $0x3
f0104afa:	e9 49 d9 01 00       	jmp    f0122448 <_alltraps>
f0104aff:	90                   	nop

f0104b00 <routine_oflow>:
	TRAPHANDLER_NOEC(routine_oflow, T_OFLOW);
f0104b00:	6a 00                	push   $0x0
f0104b02:	6a 04                	push   $0x4
f0104b04:	e9 3f d9 01 00       	jmp    f0122448 <_alltraps>
f0104b09:	90                   	nop

f0104b0a <routine_bound>:
	TRAPHANDLER_NOEC(routine_bound, T_BOUND);
f0104b0a:	6a 00                	push   $0x0
f0104b0c:	6a 05                	push   $0x5
f0104b0e:	e9 35 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b13:	90                   	nop

f0104b14 <routine_illop>:
	TRAPHANDLER_NOEC(routine_illop, T_ILLOP);
f0104b14:	6a 00                	push   $0x0
f0104b16:	6a 06                	push   $0x6
f0104b18:	e9 2b d9 01 00       	jmp    f0122448 <_alltraps>
f0104b1d:	90                   	nop

f0104b1e <routine_device>:
	TRAPHANDLER_NOEC(routine_device, T_DEVICE);
f0104b1e:	6a 00                	push   $0x0
f0104b20:	6a 07                	push   $0x7
f0104b22:	e9 21 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b27:	90                   	nop

f0104b28 <routine_dblflt>:
	TRAPHANDLER(routine_dblflt, T_DBLFLT); //#define T_DBLFLT 8
f0104b28:	6a 08                	push   $0x8
f0104b2a:	e9 19 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b2f:	90                   	nop

f0104b30 <routine_no9>:
	TRAPHANDLER(routine_no9, T_DIVIDE);  //add this for cleaness
f0104b30:	6a 00                	push   $0x0
f0104b32:	e9 11 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b37:	90                   	nop

f0104b38 <routine_tss>:
	TRAPHANDLER(routine_tss, T_TSS); //#define T_TSS 10
f0104b38:	6a 0a                	push   $0xa
f0104b3a:	e9 09 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b3f:	90                   	nop

f0104b40 <routine_segnp>:
	TRAPHANDLER(routine_segnp, T_SEGNP); 
f0104b40:	6a 0b                	push   $0xb
f0104b42:	e9 01 d9 01 00       	jmp    f0122448 <_alltraps>
f0104b47:	90                   	nop

f0104b48 <routine_stack>:
	TRAPHANDLER(routine_stack, T_STACK); 
f0104b48:	6a 0c                	push   $0xc
f0104b4a:	e9 f9 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b4f:	90                   	nop

f0104b50 <routine_gpflt>:
	TRAPHANDLER(routine_gpflt, T_GPFLT);
f0104b50:	6a 0d                	push   $0xd
f0104b52:	e9 f1 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b57:	90                   	nop

f0104b58 <routine_pgflt>:
	TRAPHANDLER(routine_pgflt, T_PGFLT); //14
f0104b58:	6a 0e                	push   $0xe
f0104b5a:	e9 e9 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b5f:	90                   	nop

f0104b60 <routine_no15>:
	TRAPHANDLER(routine_no15, T_DIVIDE); //add this for cleaness
f0104b60:	6a 00                	push   $0x0
f0104b62:	e9 e1 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b67:	90                   	nop

f0104b68 <routine_fperr>:
	TRAPHANDLER_NOEC(routine_fperr, T_FPERR);
f0104b68:	6a 00                	push   $0x0
f0104b6a:	6a 10                	push   $0x10
f0104b6c:	e9 d7 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b71:	90                   	nop

f0104b72 <routine_align>:
	TRAPHANDLER(routine_align, T_ALIGN);
f0104b72:	6a 11                	push   $0x11
f0104b74:	e9 cf d8 01 00       	jmp    f0122448 <_alltraps>
f0104b79:	90                   	nop

f0104b7a <routine_mchk>:
	TRAPHANDLER_NOEC(routine_mchk, T_MCHK);
f0104b7a:	6a 00                	push   $0x0
f0104b7c:	6a 12                	push   $0x12
f0104b7e:	e9 c5 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b83:	90                   	nop

f0104b84 <routine_simderr>:
	TRAPHANDLER_NOEC(routine_simderr, T_SIMDERR);
f0104b84:	6a 00                	push   $0x0
f0104b86:	6a 13                	push   $0x13
f0104b88:	e9 bb d8 01 00       	jmp    f0122448 <_alltraps>
f0104b8d:	90                   	nop

f0104b8e <routine_syscall>:
	
	
	TRAPHANDLER_NOEC(routine_syscall, T_SYSCALL);
f0104b8e:	6a 00                	push   $0x0
f0104b90:	6a 30                	push   $0x30
f0104b92:	e9 b1 d8 01 00       	jmp    f0122448 <_alltraps>
f0104b97:	90                   	nop

f0104b98 <routine_irq0>:

	#for IRQ HANDLER
	TRAPHANDLER_NOEC(routine_irq0, IRQ_OFFSET + 0);
f0104b98:	6a 00                	push   $0x0
f0104b9a:	6a 20                	push   $0x20
f0104b9c:	e9 a7 d8 01 00       	jmp    f0122448 <_alltraps>
f0104ba1:	90                   	nop

f0104ba2 <routine_irq1>:
	TRAPHANDLER_NOEC(routine_irq1, IRQ_OFFSET + 1);
f0104ba2:	6a 00                	push   $0x0
f0104ba4:	6a 21                	push   $0x21
f0104ba6:	e9 9d d8 01 00       	jmp    f0122448 <_alltraps>
f0104bab:	90                   	nop

f0104bac <routine_irq2>:
	TRAPHANDLER_NOEC(routine_irq2, IRQ_OFFSET + 2);
f0104bac:	6a 00                	push   $0x0
f0104bae:	6a 22                	push   $0x22
f0104bb0:	e9 93 d8 01 00       	jmp    f0122448 <_alltraps>
f0104bb5:	90                   	nop

f0104bb6 <routine_irq3>:
	TRAPHANDLER_NOEC(routine_irq3, IRQ_OFFSET + 3);
f0104bb6:	6a 00                	push   $0x0
f0104bb8:	6a 23                	push   $0x23
f0104bba:	e9 89 d8 01 00       	jmp    f0122448 <_alltraps>
f0104bbf:	90                   	nop

f0104bc0 <routine_irq4>:
	TRAPHANDLER_NOEC(routine_irq4, IRQ_OFFSET + 4);
f0104bc0:	6a 00                	push   $0x0
f0104bc2:	6a 24                	push   $0x24
f0104bc4:	e9 7f d8 01 00       	jmp    f0122448 <_alltraps>
f0104bc9:	90                   	nop

f0104bca <routine_irq5>:
	TRAPHANDLER_NOEC(routine_irq5, IRQ_OFFSET + 5);
f0104bca:	6a 00                	push   $0x0
f0104bcc:	6a 25                	push   $0x25
f0104bce:	e9 75 d8 01 00       	jmp    f0122448 <_alltraps>
f0104bd3:	90                   	nop

f0104bd4 <routine_irq6>:
	TRAPHANDLER_NOEC(routine_irq6, IRQ_OFFSET + 6);
f0104bd4:	6a 00                	push   $0x0
f0104bd6:	6a 26                	push   $0x26
f0104bd8:	e9 6b d8 01 00       	jmp    f0122448 <_alltraps>
f0104bdd:	90                   	nop

f0104bde <routine_irq7>:
	TRAPHANDLER_NOEC(routine_irq7, IRQ_OFFSET + 7);
f0104bde:	6a 00                	push   $0x0
f0104be0:	6a 27                	push   $0x27
f0104be2:	e9 61 d8 01 00       	jmp    f0122448 <_alltraps>
f0104be7:	90                   	nop

f0104be8 <routine_irq8>:
	TRAPHANDLER_NOEC(routine_irq8, IRQ_OFFSET + 8);
f0104be8:	6a 00                	push   $0x0
f0104bea:	6a 28                	push   $0x28
f0104bec:	e9 57 d8 01 00       	jmp    f0122448 <_alltraps>
f0104bf1:	90                   	nop

f0104bf2 <routine_irq9>:
	TRAPHANDLER_NOEC(routine_irq9, IRQ_OFFSET + 9);
f0104bf2:	6a 00                	push   $0x0
f0104bf4:	6a 29                	push   $0x29
f0104bf6:	e9 4d d8 01 00       	jmp    f0122448 <_alltraps>
f0104bfb:	90                   	nop

f0104bfc <routine_irq10>:
	TRAPHANDLER_NOEC(routine_irq10, IRQ_OFFSET + 10);
f0104bfc:	6a 00                	push   $0x0
f0104bfe:	6a 2a                	push   $0x2a
f0104c00:	e9 43 d8 01 00       	jmp    f0122448 <_alltraps>
f0104c05:	90                   	nop

f0104c06 <routine_irq11>:
	TRAPHANDLER_NOEC(routine_irq11, IRQ_OFFSET + 11);
f0104c06:	6a 00                	push   $0x0
f0104c08:	6a 2b                	push   $0x2b
f0104c0a:	e9 39 d8 01 00       	jmp    f0122448 <_alltraps>
f0104c0f:	90                   	nop

f0104c10 <routine_irq12>:
	TRAPHANDLER_NOEC(routine_irq12, IRQ_OFFSET + 12);
f0104c10:	6a 00                	push   $0x0
f0104c12:	6a 2c                	push   $0x2c
f0104c14:	e9 2f d8 01 00       	jmp    f0122448 <_alltraps>
f0104c19:	90                   	nop

f0104c1a <routine_irq13>:
	TRAPHANDLER_NOEC(routine_irq13, IRQ_OFFSET + 13);
f0104c1a:	6a 00                	push   $0x0
f0104c1c:	6a 2d                	push   $0x2d
f0104c1e:	e9 25 d8 01 00       	jmp    f0122448 <_alltraps>
f0104c23:	90                   	nop

f0104c24 <routine_irq14>:
	TRAPHANDLER_NOEC(routine_irq14, IRQ_OFFSET + 14);
f0104c24:	6a 00                	push   $0x0
f0104c26:	6a 2e                	push   $0x2e
f0104c28:	e9 1b d8 01 00       	jmp    f0122448 <_alltraps>
f0104c2d:	90                   	nop

f0104c2e <routine_irq15>:
	TRAPHANDLER_NOEC(routine_irq15, IRQ_OFFSET + 15);
f0104c2e:	6a 00                	push   $0x0
f0104c30:	6a 2f                	push   $0x2f
f0104c32:	e9 11 d8 01 00       	jmp    f0122448 <_alltraps>
	...

f0104c38 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104c38:	55                   	push   %ebp
f0104c39:	89 e5                	mov    %esp,%ebp
f0104c3b:	83 ec 18             	sub    $0x18,%esp
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c3e:	8b 15 4c 52 20 f0    	mov    0xf020524c,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104c44:	8b 42 54             	mov    0x54(%edx),%eax
f0104c47:	83 e8 01             	sub    $0x1,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c4a:	83 f8 02             	cmp    $0x2,%eax
f0104c4d:	76 45                	jbe    f0104c94 <sched_halt+0x5c>

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
f0104c4f:	81 c2 d0 00 00 00    	add    $0xd0,%edx
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104c55:	b8 01 00 00 00       	mov    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104c5a:	8b 0a                	mov    (%edx),%ecx
f0104c5c:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c5f:	83 f9 02             	cmp    $0x2,%ecx
f0104c62:	76 0f                	jbe    f0104c73 <sched_halt+0x3b>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104c64:	83 c0 01             	add    $0x1,%eax
f0104c67:	83 c2 7c             	add    $0x7c,%edx
f0104c6a:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104c6f:	75 e9                	jne    f0104c5a <sched_halt+0x22>
f0104c71:	eb 07                	jmp    f0104c7a <sched_halt+0x42>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f0104c73:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104c78:	75 1a                	jne    f0104c94 <sched_halt+0x5c>
		cprintf("No runnable environments in the system!\n");
f0104c7a:	c7 04 24 50 86 10 f0 	movl   $0xf0108650,(%esp)
f0104c81:	e8 64 f6 ff ff       	call   f01042ea <cprintf>
		while (1)
			monitor(NULL);
f0104c86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0104c8d:	e8 35 c0 ff ff       	call   f0100cc7 <monitor>
f0104c92:	eb f2                	jmp    f0104c86 <sched_halt+0x4e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104c94:	e8 a7 1a 00 00       	call   f0106740 <cpunum>
f0104c99:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c9c:	c7 80 28 60 20 f0 00 	movl   $0x0,-0xfdf9fd8(%eax)
f0104ca3:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104ca6:	a1 8c 5e 20 f0       	mov    0xf0205e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104cab:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104cb0:	77 20                	ja     f0104cd2 <sched_halt+0x9a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104cb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104cb6:	c7 44 24 08 a4 6e 10 	movl   $0xf0106ea4,0x8(%esp)
f0104cbd:	f0 
f0104cbe:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0104cc5:	00 
f0104cc6:	c7 04 24 79 86 10 f0 	movl   $0xf0108679,(%esp)
f0104ccd:	e8 6e b3 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104cd2:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0104cd7:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104cda:	e8 61 1a 00 00       	call   f0106740 <cpunum>
f0104cdf:	6b d0 74             	imul   $0x74,%eax,%edx
f0104ce2:	81 c2 20 60 20 f0    	add    $0xf0206020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104ce8:	b8 02 00 00 00       	mov    $0x2,%eax
f0104ced:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0104cf1:	c7 04 24 80 24 12 f0 	movl   $0xf0122480,(%esp)
f0104cf8:	e8 b6 1d 00 00       	call   f0106ab3 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0104cfd:	f3 90                	pause  
		"movl %0, %%esp\n"
		"pushl $0\n"
		"pushl $0\n"
		"sti\n"
		"hlt\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104cff:	e8 3c 1a 00 00       	call   f0106740 <cpunum>
f0104d04:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f0104d07:	8b 80 30 60 20 f0    	mov    -0xfdf9fd0(%eax),%eax
f0104d0d:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104d12:	89 c4                	mov    %eax,%esp
f0104d14:	6a 00                	push   $0x0
f0104d16:	6a 00                	push   $0x0
f0104d18:	fb                   	sti    
f0104d19:	f4                   	hlt    
		"pushl $0\n"
		"pushl $0\n"
		"sti\n"
		"hlt\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f0104d1a:	c9                   	leave  
f0104d1b:	c3                   	ret    

f0104d1c <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f0104d1c:	55                   	push   %ebp
f0104d1d:	89 e5                	mov    %esp,%ebp
f0104d1f:	53                   	push   %ebx
f0104d20:	83 ec 14             	sub    $0x14,%esp
	// below to halt the cpu.

	// LAB 4: Your code here.
	struct Env * curenvptr;
	//cprintf("yyCPUid: %d\n", thiscpu->cpu_id);
	if(curenv == NULL){
f0104d23:	e8 18 1a 00 00       	call   f0106740 <cpunum>
f0104d28:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d2b:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f0104d32:	75 07                	jne    f0104d3b <sched_yield+0x1f>
		//cprintf("NULL\n");
		curenvptr = envs;
f0104d34:	a1 4c 52 20 f0       	mov    0xf020524c,%eax
f0104d39:	eb 11                	jmp    f0104d4c <sched_yield+0x30>
	}
	else {
		//cprintf("not NULL\n");
		curenvptr = curenv + 1;
f0104d3b:	e8 00 1a 00 00       	call   f0106740 <cpunum>
f0104d40:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d43:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104d49:	83 c0 7c             	add    $0x7c,%eax
	}
	int round = 0;
	for(; round < NENV; curenvptr++, round++){
		if(curenvptr >= envs + NENV)
f0104d4c:	8b 0d 4c 52 20 f0    	mov    0xf020524c,%ecx
f0104d52:	8d 99 00 f0 01 00    	lea    0x1f000(%ecx),%ebx
f0104d58:	ba 00 04 00 00       	mov    $0x400,%edx
			curenvptr = envs;
f0104d5d:	39 c3                	cmp    %eax,%ebx
f0104d5f:	0f 46 c1             	cmovbe %ecx,%eax
		if(curenvptr->env_status == ENV_RUNNABLE)
f0104d62:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104d66:	75 08                	jne    f0104d70 <sched_yield+0x54>
			env_run(curenvptr);
f0104d68:	89 04 24             	mov    %eax,(%esp)
f0104d6b:	e8 1d f3 ff ff       	call   f010408d <env_run>
	else {
		//cprintf("not NULL\n");
		curenvptr = curenv + 1;
	}
	int round = 0;
	for(; round < NENV; curenvptr++, round++){
f0104d70:	83 c0 7c             	add    $0x7c,%eax
f0104d73:	83 ea 01             	sub    $0x1,%edx
f0104d76:	75 e5                	jne    f0104d5d <sched_yield+0x41>
			curenvptr = envs;
		if(curenvptr->env_status == ENV_RUNNABLE)
			env_run(curenvptr);
		
	}
	if(thiscpu->cpu_env != NULL && thiscpu->cpu_env->env_status == ENV_RUNNING){
f0104d78:	e8 c3 19 00 00       	call   f0106740 <cpunum>
f0104d7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d80:	83 b8 28 60 20 f0 00 	cmpl   $0x0,-0xfdf9fd8(%eax)
f0104d87:	74 2a                	je     f0104db3 <sched_yield+0x97>
f0104d89:	e8 b2 19 00 00       	call   f0106740 <cpunum>
f0104d8e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d91:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104d97:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104d9b:	75 16                	jne    f0104db3 <sched_yield+0x97>
		//cprintf("thiscpu\n");	
		env_run(thiscpu->cpu_env);
f0104d9d:	e8 9e 19 00 00       	call   f0106740 <cpunum>
f0104da2:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da5:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104dab:	89 04 24             	mov    %eax,(%esp)
f0104dae:	e8 da f2 ff ff       	call   f010408d <env_run>
			monitor(NULL);
		}
	}
*/	
	// sched_halt never returns
	sched_halt();
f0104db3:	e8 80 fe ff ff       	call   f0104c38 <sched_halt>
}
f0104db8:	83 c4 14             	add    $0x14,%esp
f0104dbb:	5b                   	pop    %ebx
f0104dbc:	5d                   	pop    %ebp
f0104dbd:	c3                   	ret    
	...

f0104dc0 <sys_getenvid>:
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f0104dc0:	55                   	push   %ebp
f0104dc1:	89 e5                	mov    %esp,%ebp
f0104dc3:	83 ec 08             	sub    $0x8,%esp
	return curenv->env_id;
f0104dc6:	e8 75 19 00 00       	call   f0106740 <cpunum>
f0104dcb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dce:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104dd4:	8b 40 48             	mov    0x48(%eax),%eax
}
f0104dd7:	c9                   	leave  
f0104dd8:	c3                   	ret    

f0104dd9 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104dd9:	55                   	push   %ebp
f0104dda:	89 e5                	mov    %esp,%ebp
f0104ddc:	83 ec 38             	sub    $0x38,%esp
f0104ddf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0104de2:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0104de5:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0104de8:	8b 45 08             	mov    0x8(%ebp),%eax
f0104deb:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104dee:	8b 7d 10             	mov    0x10(%ebp),%edi
			//cprintf("recv\n");
			r = sys_ipc_recv((void*)a1);break;
		case SYS_env_set_trapframe:
			r = sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);break;
		default:
		r = -E_INVAL;
f0104df1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	int r = 0;
	switch (syscallno) {
f0104df6:	83 f8 0d             	cmp    $0xd,%eax
f0104df9:	0f 87 18 06 00 00    	ja     f0105417 <syscall+0x63e>
f0104dff:	ff 24 85 74 87 10 f0 	jmp    *-0xfef788c(,%eax,4)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, s, len, PTE_U);
f0104e06:	e8 35 19 00 00       	call   f0106740 <cpunum>
f0104e0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0104e12:	00 
f0104e13:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0104e17:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104e1b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e1e:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0104e24:	89 04 24             	mov    %eax,(%esp)
f0104e27:	e8 cb ea ff ff       	call   f01038f7 <user_mem_assert>
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0104e2c:	89 74 24 08          	mov    %esi,0x8(%esp)
f0104e30:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104e34:	c7 04 24 86 86 10 f0 	movl   $0xf0108686,(%esp)
f0104e3b:	e8 aa f4 ff ff       	call   f01042ea <cprintf>
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	int r = 0;
f0104e40:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104e45:	e9 cd 05 00 00       	jmp    f0105417 <syscall+0x63e>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0104e4a:	e8 1a b8 ff ff       	call   f0100669 <cons_getc>
f0104e4f:	89 c3                	mov    %eax,%ebx
	int r = 0;
	switch (syscallno) {
		case SYS_cputs:
			sys_cputs ((const char*) a1, (size_t)a2); break;
		case SYS_cgetc:
			r = sys_cgetc (); break;
f0104e51:	e9 c1 05 00 00       	jmp    f0105417 <syscall+0x63e>
		case SYS_getenvid:
			r = sys_getenvid (); break;
f0104e56:	e8 65 ff ff ff       	call   f0104dc0 <sys_getenvid>
f0104e5b:	89 c3                	mov    %eax,%ebx
f0104e5d:	8d 76 00             	lea    0x0(%esi),%esi
f0104e60:	e9 b2 05 00 00       	jmp    f0105417 <syscall+0x63e>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104e65:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104e6c:	00 
f0104e6d:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104e70:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e74:	89 34 24             	mov    %esi,(%esp)
f0104e77:	e8 75 eb ff ff       	call   f01039f1 <envid2env>
f0104e7c:	89 c3                	mov    %eax,%ebx
f0104e7e:	85 c0                	test   %eax,%eax
f0104e80:	0f 88 91 05 00 00    	js     f0105417 <syscall+0x63e>
		return r;
	env_destroy(e);
f0104e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104e89:	89 04 24             	mov    %eax,(%esp)
f0104e8c:	e8 5b f1 ff ff       	call   f0103fec <env_destroy>
	return 0;
f0104e91:	bb 00 00 00 00       	mov    $0x0,%ebx
		case SYS_cgetc:
			r = sys_cgetc (); break;
		case SYS_getenvid:
			r = sys_getenvid (); break;
		case SYS_env_destroy:
			r = sys_env_destroy ((envid_t) a1); break;
f0104e96:	e9 7c 05 00 00       	jmp    f0105417 <syscall+0x63e>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0104e9b:	e8 7c fe ff ff       	call   f0104d1c <sched_yield>
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	struct Env *e;
	unsigned res = env_alloc(&e, sys_getenvid());
f0104ea0:	e8 1b ff ff ff       	call   f0104dc0 <sys_getenvid>
f0104ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ea9:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104eac:	89 04 24             	mov    %eax,(%esp)
f0104eaf:	e8 5c ec ff ff       	call   f0103b10 <env_alloc>
		if(res == -E_NO_MEM){
			cprintf("no free mem\n");
		}
		return res;		
	}
	e->env_status = ENV_NOT_RUNNABLE;
f0104eb4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104eb7:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
	e->env_type = ENV_TYPE_USER;
f0104ebe:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_tf = curenv->env_tf;
f0104ec5:	e8 76 18 00 00       	call   f0106740 <cpunum>
f0104eca:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ecd:	8b b0 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%esi
f0104ed3:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104ed8:	89 df                	mov    %ebx,%edi
f0104eda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f0104edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104edf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f0104ee6:	8b 58 48             	mov    0x48(%eax),%ebx
		case SYS_env_destroy:
			r = sys_env_destroy ((envid_t) a1); break;
		case SYS_yield:
			sys_yield(); return 0;
		case SYS_exofork:
			r = sys_exofork(); break;
f0104ee9:	e9 29 05 00 00       	jmp    f0105417 <syscall+0x63e>
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	struct Env *e;
	int res = envid2env(envid, &e, 1);
f0104eee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104ef5:	00 
f0104ef6:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104efd:	89 34 24             	mov    %esi,(%esp)
f0104f00:	e8 ec ea ff ff       	call   f01039f1 <envid2env>
f0104f05:	89 c3                	mov    %eax,%ebx
	if(res < 0)return res;
f0104f07:	85 c0                	test   %eax,%eax
f0104f09:	0f 88 08 05 00 00    	js     f0105417 <syscall+0x63e>
	if(status == ENV_FREE){
f0104f0f:	85 ff                	test   %edi,%edi
f0104f11:	75 16                	jne    f0104f29 <syscall+0x150>
		cprintf("ERROR: cannot find an env this way\n");
f0104f13:	c7 04 24 d8 86 10 f0 	movl   $0xf01086d8,(%esp)
f0104f1a:	e8 cb f3 ff ff       	call   f01042ea <cprintf>
		return -E_INVAL;
f0104f1f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104f24:	e9 ee 04 00 00       	jmp    f0105417 <syscall+0x63e>
	}

	if(e->env_type == ENV_TYPE_USER){
f0104f29:	8b 45 dc             	mov    -0x24(%ebp),%eax
			cprintf("unknown status %08x\n", status);
			return -E_INVAL;
		}
		
	}
	return -E_INVAL;
f0104f2c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	if(status == ENV_FREE){
		cprintf("ERROR: cannot find an env this way\n");
		return -E_INVAL;
	}

	if(e->env_type == ENV_TYPE_USER){
f0104f31:	83 78 50 00          	cmpl   $0x0,0x50(%eax)
f0104f35:	0f 85 dc 04 00 00    	jne    f0105417 <syscall+0x63e>
		if(status == ENV_DYING ||
			status == ENV_RUNNABLE ||
			status == ENV_RUNNING ||
f0104f3b:	8d 57 ff             	lea    -0x1(%edi),%edx
		cprintf("ERROR: cannot find an env this way\n");
		return -E_INVAL;
	}

	if(e->env_type == ENV_TYPE_USER){
		if(status == ENV_DYING ||
f0104f3e:	83 fa 03             	cmp    $0x3,%edx
f0104f41:	77 0d                	ja     f0104f50 <syscall+0x177>
			status == ENV_RUNNABLE ||
			status == ENV_RUNNING ||
			status == ENV_NOT_RUNNABLE){
			// the status is legal
			e->env_status = status;
f0104f43:	89 78 54             	mov    %edi,0x54(%eax)
			return 0;
f0104f46:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104f4b:	e9 c7 04 00 00       	jmp    f0105417 <syscall+0x63e>
		}
		else{
			cprintf("unknown status %08x\n", status);
f0104f50:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104f54:	c7 04 24 8b 86 10 f0 	movl   $0xf010868b,(%esp)
f0104f5b:	e8 8a f3 ff ff       	call   f01042ea <cprintf>
			return -E_INVAL;
f0104f60:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104f65:	e9 ad 04 00 00       	jmp    f0105417 <syscall+0x63e>
	//   allocated!

	// LAB 4: Your code here.
	struct Env * target;
	struct PageInfo * p;
	int res = envid2env(envid, &target, 1);
f0104f6a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104f71:	00 
f0104f72:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104f75:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f79:	89 34 24             	mov    %esi,(%esp)
f0104f7c:	e8 70 ea ff ff       	call   f01039f1 <envid2env>
f0104f81:	89 c3                	mov    %eax,%ebx
	if(res < 0) return res;
f0104f83:	85 c0                	test   %eax,%eax
f0104f85:	0f 88 8c 04 00 00    	js     f0105417 <syscall+0x63e>
	int perm_check = (perm ^ (PTE_AVAIL | PTE_W)) & ~(PTE_W | PTE_AVAIL | PTE_U | PTE_P);
	if(perm_check){
f0104f8b:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f0104f92:	74 16                	je     f0104faa <syscall+0x1d1>
		cprintf("ERROR: the permission bits are off\n");
f0104f94:	c7 04 24 fc 86 10 f0 	movl   $0xf01086fc,(%esp)
f0104f9b:	e8 4a f3 ff ff       	call   f01042ea <cprintf>
		return -E_INVAL;
f0104fa0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104fa5:	e9 6d 04 00 00       	jmp    f0105417 <syscall+0x63e>
	}
	if((unsigned)va % PGSIZE != 0){
f0104faa:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0104fb0:	74 16                	je     f0104fc8 <syscall+0x1ef>
		cprintf("Va not aligned\n");
f0104fb2:	c7 04 24 a0 86 10 f0 	movl   $0xf01086a0,(%esp)
f0104fb9:	e8 2c f3 ff ff       	call   f01042ea <cprintf>
		return -E_INVAL;
f0104fbe:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104fc3:	e9 4f 04 00 00       	jmp    f0105417 <syscall+0x63e>
	}
	if((p = page_alloc(ALLOC_ZERO))){
f0104fc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0104fcf:	e8 07 c4 ff ff       	call   f01013db <page_alloc>
f0104fd4:	89 c6                	mov    %eax,%esi
f0104fd6:	85 c0                	test   %eax,%eax
f0104fd8:	74 37                	je     f0105011 <syscall+0x238>
		 //return zero
		 int i = page_insert(target->env_pgdir ,p ,va , PTE_P | PTE_U | perm);
f0104fda:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fdd:	83 c8 05             	or     $0x5,%eax
f0104fe0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104fe4:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0104fe8:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104fec:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104fef:	8b 40 60             	mov    0x60(%eax),%eax
f0104ff2:	89 04 24             	mov    %eax,(%esp)
f0104ff5:	e8 38 c7 ff ff       	call   f0101732 <page_insert>
f0104ffa:	89 c3                	mov    %eax,%ebx
		 if(i == 0){
f0104ffc:	85 c0                	test   %eax,%eax
f0104ffe:	0f 84 13 04 00 00    	je     f0105417 <syscall+0x63e>
			return 0;
		 }
		 else{
			page_free(p);
f0105004:	89 34 24             	mov    %esi,(%esp)
f0105007:	e8 4d c4 ff ff       	call   f0101459 <page_free>
f010500c:	e9 06 04 00 00       	jmp    f0105417 <syscall+0x63e>
			return i;
		 }
		 
	}
	else{
		cprintf("ERROR: no free memory\n");
f0105011:	c7 04 24 b0 86 10 f0 	movl   $0xf01086b0,(%esp)
f0105018:	e8 cd f2 ff ff       	call   f01042ea <cprintf>
		return -E_NO_MEM;
f010501d:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
		case SYS_exofork:
			r = sys_exofork(); break;
		case SYS_env_set_status:
			r = sys_env_set_status((envid_t)a1, (int) a2); break;
		case SYS_page_alloc:
			r = sys_page_alloc((envid_t)a1, (void*)a2, (int) a3); break;
f0105022:	e9 f0 03 00 00       	jmp    f0105417 <syscall+0x63e>
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	int res;
	struct Env *src, * dst;
	res = envid2env(srcenvid, &src, 1);
f0105027:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010502e:	00 
f010502f:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105032:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105036:	89 34 24             	mov    %esi,(%esp)
f0105039:	e8 b3 e9 ff ff       	call   f01039f1 <envid2env>
f010503e:	89 c3                	mov    %eax,%ebx
	if(res) return res;
f0105040:	85 c0                	test   %eax,%eax
f0105042:	0f 85 cf 03 00 00    	jne    f0105417 <syscall+0x63e>
	res = envid2env(dstenvid, &dst, 1);
f0105048:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010504f:	00 
f0105050:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105053:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105057:	8b 45 14             	mov    0x14(%ebp),%eax
f010505a:	89 04 24             	mov    %eax,(%esp)
f010505d:	e8 8f e9 ff ff       	call   f01039f1 <envid2env>
f0105062:	89 c3                	mov    %eax,%ebx
	if(res) return res;
f0105064:	85 c0                	test   %eax,%eax
f0105066:	0f 85 ab 03 00 00    	jne    f0105417 <syscall+0x63e>

	if(((uint32_t)srcva >= UTOP || PGOFF(srcva)) ||
	   ((uint32_t)dstva >= UTOP || PGOFF(dstva))){
		return -E_INVAL;
f010506c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	res = envid2env(srcenvid, &src, 1);
	if(res) return res;
	res = envid2env(dstenvid, &dst, 1);
	if(res) return res;

	if(((uint32_t)srcva >= UTOP || PGOFF(srcva)) ||
f0105071:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f0105077:	0f 87 9a 03 00 00    	ja     f0105417 <syscall+0x63e>
f010507d:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0105083:	0f 85 8e 03 00 00    	jne    f0105417 <syscall+0x63e>
f0105089:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105090:	0f 87 81 03 00 00    	ja     f0105417 <syscall+0x63e>
	   ((uint32_t)dstva >= UTOP || PGOFF(dstva))){
f0105096:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f010509d:	0f 85 74 03 00 00    	jne    f0105417 <syscall+0x63e>
		return -E_INVAL;
	}
	int perm_check = (perm ^ (PTE_AVAIL | PTE_W)) & ~(PTE_W | PTE_AVAIL | PTE_U | PTE_P);
	if(perm_check){
f01050a3:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f01050aa:	0f 85 67 03 00 00    	jne    f0105417 <syscall+0x63e>
		return -E_INVAL;
	}
	pte_t * pte;
	struct PageInfo * page = page_lookup(src->env_pgdir, srcva, &pte);
f01050b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01050b3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01050b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01050bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01050be:	8b 40 60             	mov    0x60(%eax),%eax
f01050c1:	89 04 24             	mov    %eax,(%esp)
f01050c4:	e8 6c c5 ff ff       	call   f0101635 <page_lookup>
	if(!page){
f01050c9:	85 c0                	test   %eax,%eax
f01050cb:	74 2a                	je     f01050f7 <syscall+0x31e>
		return -E_INVAL;
	}
	return page_insert(dst->env_pgdir, page, dstva, PTE_U | PTE_P | perm);
f01050cd:	8b 55 1c             	mov    0x1c(%ebp),%edx
f01050d0:	83 ca 05             	or     $0x5,%edx
f01050d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01050d7:	8b 55 18             	mov    0x18(%ebp),%edx
f01050da:	89 54 24 08          	mov    %edx,0x8(%esp)
f01050de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01050e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01050e5:	8b 40 60             	mov    0x60(%eax),%eax
f01050e8:	89 04 24             	mov    %eax,(%esp)
f01050eb:	e8 42 c6 ff ff       	call   f0101732 <page_insert>
f01050f0:	89 c3                	mov    %eax,%ebx
f01050f2:	e9 20 03 00 00       	jmp    f0105417 <syscall+0x63e>
		return -E_INVAL;
	}
	pte_t * pte;
	struct PageInfo * page = page_lookup(src->env_pgdir, srcva, &pte);
	if(!page){
		return -E_INVAL;
f01050f7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		case SYS_env_set_status:
			r = sys_env_set_status((envid_t)a1, (int) a2); break;
		case SYS_page_alloc:
			r = sys_page_alloc((envid_t)a1, (void*)a2, (int) a3); break;
		case SYS_page_map:
			r = sys_page_map((envid_t)a1, (void*)a2, (envid_t)a3, (void*)a4, (int)a5); break;
f01050fc:	e9 16 03 00 00       	jmp    f0105417 <syscall+0x63e>
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env * env;
	int res;
	res = envid2env(envid, &env, 1);
f0105101:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105108:	00 
f0105109:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010510c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105110:	89 34 24             	mov    %esi,(%esp)
f0105113:	e8 d9 e8 ff ff       	call   f01039f1 <envid2env>
f0105118:	89 c3                	mov    %eax,%ebx
	if(res < 0) return res;
f010511a:	85 c0                	test   %eax,%eax
f010511c:	0f 88 f5 02 00 00    	js     f0105417 <syscall+0x63e>
	if((unsigned)va >= UTOP || PGOFF(va) ){
		return -E_INVAL;
f0105122:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	// LAB 4: Your code here.
	struct Env * env;
	int res;
	res = envid2env(envid, &env, 1);
	if(res < 0) return res;
	if((unsigned)va >= UTOP || PGOFF(va) ){
f0105127:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010512d:	0f 87 e4 02 00 00    	ja     f0105417 <syscall+0x63e>
f0105133:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0105139:	0f 85 d8 02 00 00    	jne    f0105417 <syscall+0x63e>
		return -E_INVAL;
	}
	page_remove(env->env_pgdir, va);
f010513f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105146:	8b 40 60             	mov    0x60(%eax),%eax
f0105149:	89 04 24             	mov    %eax,(%esp)
f010514c:	e8 91 c5 ff ff       	call   f01016e2 <page_remove>
	return 0;
f0105151:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105156:	e9 bc 02 00 00       	jmp    f0105417 <syscall+0x63e>
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env * e;
	int res = envid2env(envid, &e, 1);
f010515b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105162:	00 
f0105163:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105166:	89 44 24 04          	mov    %eax,0x4(%esp)
f010516a:	89 34 24             	mov    %esi,(%esp)
f010516d:	e8 7f e8 ff ff       	call   f01039f1 <envid2env>
f0105172:	89 c3                	mov    %eax,%ebx
	if(res < 0)return res;
f0105174:	85 c0                	test   %eax,%eax
f0105176:	0f 88 9b 02 00 00    	js     f0105417 <syscall+0x63e>
	user_mem_assert(curenv, func, PGSIZE, PTE_U | PTE_P);
f010517c:	e8 bf 15 00 00       	call   f0106740 <cpunum>
f0105181:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0105188:	00 
f0105189:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0105190:	00 
f0105191:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105195:	6b c0 74             	imul   $0x74,%eax,%eax
f0105198:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010519e:	89 04 24             	mov    %eax,(%esp)
f01051a1:	e8 51 e7 ff ff       	call   f01038f7 <user_mem_assert>
	e->env_pgfault_upcall = func;
f01051a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051a9:	89 78 64             	mov    %edi,0x64(%eax)
	return 0;
f01051ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		case SYS_page_map:
			r = sys_page_map((envid_t)a1, (void*)a2, (envid_t)a3, (void*)a4, (int)a5); break;
		case SYS_page_unmap:
			r = sys_page_unmap((envid_t)a1, (void*)a2); break;
		case SYS_env_set_pgfault_upcall:
			r = sys_env_set_pgfault_upcall((envid_t)a1, (void*)a2); break;
f01051b1:	e9 61 02 00 00       	jmp    f0105417 <syscall+0x63e>
    // LAB 4: Your code here.
    struct Env * env;
    struct PageInfo * page;
    pte_t * pte;

    if(envid2env(envid, &env, 0) < 0)
f01051b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01051bd:	00 
f01051be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01051c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051c5:	89 34 24             	mov    %esi,(%esp)
f01051c8:	e8 24 e8 ff ff       	call   f01039f1 <envid2env>
f01051cd:	85 c0                	test   %eax,%eax
f01051cf:	0f 88 2d 01 00 00    	js     f0105302 <syscall+0x529>
        return -E_BAD_ENV;

    if(env->env_ipc_recving == 0){
f01051d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051d8:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01051dc:	0f 84 2a 01 00 00    	je     f010530c <syscall+0x533>
		//cprintf("E_IPC_NOT_RECV\n");
		return -E_IPC_NOT_RECV;
    }
	
    if(srcva && (uintptr_t) srcva < UTOP){
f01051e2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
f01051e6:	0f 95 c2             	setne  %dl
f01051e9:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01051f0:	0f 96 c1             	setbe  %cl
f01051f3:	84 d2                	test   %dl,%dl
f01051f5:	74 2d                	je     f0105224 <syscall+0x44b>
f01051f7:	84 c9                	test   %cl,%cl
f01051f9:	74 29                	je     f0105224 <syscall+0x44b>
        if((uintptr_t) srcva % PGSIZE)
f01051fb:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0105202:	0f 85 0e 01 00 00    	jne    f0105316 <syscall+0x53d>
            return -E_INVAL;

        if(!(perm & PTE_P) || !(perm & PTE_U))
f0105208:	8b 5d 18             	mov    0x18(%ebp),%ebx
f010520b:	83 e3 05             	and    $0x5,%ebx
f010520e:	83 fb 05             	cmp    $0x5,%ebx
f0105211:	0f 85 09 01 00 00    	jne    f0105320 <syscall+0x547>
            return -E_INVAL;

        if((perm & 0xfff) & ~(PTE_AVAIL | PTE_P | PTE_W | PTE_U))
f0105217:	f7 45 18 f8 01 00 00 	testl  $0x1f8,0x18(%ebp)
f010521e:	0f 85 06 01 00 00    	jne    f010532a <syscall+0x551>
            return -E_INVAL;
    }

    if(srcva && env->env_ipc_dstva && ((uintptr_t) srcva < UTOP)){
f0105224:	84 d2                	test   %dl,%dl
f0105226:	0f 84 a2 00 00 00    	je     f01052ce <syscall+0x4f5>
f010522c:	84 c9                	test   %cl,%cl
f010522e:	0f 84 9a 00 00 00    	je     f01052ce <syscall+0x4f5>
f0105234:	83 78 6c 00          	cmpl   $0x0,0x6c(%eax)
f0105238:	0f 84 90 00 00 00    	je     f01052ce <syscall+0x4f5>
        if((page = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
f010523e:	66 90                	xchg   %ax,%ax
f0105240:	e8 fb 14 00 00       	call   f0106740 <cpunum>
f0105245:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0105248:	89 54 24 08          	mov    %edx,0x8(%esp)
f010524c:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010524f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105253:	6b c0 74             	imul   $0x74,%eax,%eax
f0105256:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010525c:	8b 40 60             	mov    0x60(%eax),%eax
f010525f:	89 04 24             	mov    %eax,(%esp)
f0105262:	e8 ce c3 ff ff       	call   f0101635 <page_lookup>
f0105267:	85 c0                	test   %eax,%eax
f0105269:	0f 84 c5 00 00 00    	je     f0105334 <syscall+0x55b>
            return -E_INVAL;

        if((perm & PTE_W) && !(*pte & PTE_W))
f010526f:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105273:	74 24                	je     f0105299 <syscall+0x4c0>
f0105275:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105278:	f6 02 02             	testb  $0x2,(%edx)
f010527b:	75 1c                	jne    f0105299 <syscall+0x4c0>
            panic("Are you sure you want to mapping a read-only page to a status that can be written?");
f010527d:	c7 44 24 08 20 87 10 	movl   $0xf0108720,0x8(%esp)
f0105284:	f0 
f0105285:	c7 44 24 04 92 01 00 	movl   $0x192,0x4(%esp)
f010528c:	00 
f010528d:	c7 04 24 c7 86 10 f0 	movl   $0xf01086c7,(%esp)
f0105294:	e8 a7 ad ff ff       	call   f0100040 <_panic>

        int result = page_insert(env->env_pgdir, page, env->env_ipc_dstva, perm);
f0105299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010529c:	8b 4d 18             	mov    0x18(%ebp),%ecx
f010529f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01052a3:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f01052a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01052aa:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052ae:	8b 42 60             	mov    0x60(%edx),%eax
f01052b1:	89 04 24             	mov    %eax,(%esp)
f01052b4:	e8 79 c4 ff ff       	call   f0101732 <page_insert>
f01052b9:	89 c3                	mov    %eax,%ebx
        if(result < 0)
f01052bb:	85 c0                	test   %eax,%eax
f01052bd:	0f 88 54 01 00 00    	js     f0105417 <syscall+0x63e>
            return result;

        env->env_ipc_perm = perm;
f01052c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052c6:	8b 55 18             	mov    0x18(%ebp),%edx
f01052c9:	89 50 78             	mov    %edx,0x78(%eax)
f01052cc:	eb 07                	jmp    f01052d5 <syscall+0x4fc>
    }
    else {
        env->env_ipc_perm = 0;
f01052ce:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
    }
	env->env_tf.tf_regs.reg_eax = 0;
f01052d5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01052d8:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    env->env_ipc_recving  = 0;
f01052df:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
    env->env_ipc_from     = sys_getenvid();
f01052e3:	e8 d8 fa ff ff       	call   f0104dc0 <sys_getenvid>
f01052e8:	89 43 74             	mov    %eax,0x74(%ebx)
    env->env_ipc_value    = value;
f01052eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052ee:	89 78 70             	mov    %edi,0x70(%eax)
    env->env_status       = ENV_RUNNABLE;
f01052f1:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)

   // KDEBUG("\e[0;31m%08x unblocked\e[0;00m\n", env->env_id);

    return 0;
f01052f8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01052fd:	e9 15 01 00 00       	jmp    f0105417 <syscall+0x63e>
    struct Env * env;
    struct PageInfo * page;
    pte_t * pte;

    if(envid2env(envid, &env, 0) < 0)
        return -E_BAD_ENV;
f0105302:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0105307:	e9 0b 01 00 00       	jmp    f0105417 <syscall+0x63e>

    if(env->env_ipc_recving == 0){
		//cprintf("E_IPC_NOT_RECV\n");
		return -E_IPC_NOT_RECV;
f010530c:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0105311:	e9 01 01 00 00       	jmp    f0105417 <syscall+0x63e>
    }
	
    if(srcva && (uintptr_t) srcva < UTOP){
        if((uintptr_t) srcva % PGSIZE)
            return -E_INVAL;
f0105316:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010531b:	e9 f7 00 00 00       	jmp    f0105417 <syscall+0x63e>

        if(!(perm & PTE_P) || !(perm & PTE_U))
            return -E_INVAL;
f0105320:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105325:	e9 ed 00 00 00       	jmp    f0105417 <syscall+0x63e>

        if((perm & 0xfff) & ~(PTE_AVAIL | PTE_P | PTE_W | PTE_U))
            return -E_INVAL;
f010532a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010532f:	e9 e3 00 00 00       	jmp    f0105417 <syscall+0x63e>
    }

    if(srcva && env->env_ipc_dstva && ((uintptr_t) srcva < UTOP)){
        if((page = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
            return -E_INVAL;
f0105334:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			r = sys_page_unmap((envid_t)a1, (void*)a2); break;
		case SYS_env_set_pgfault_upcall:
			r = sys_env_set_pgfault_upcall((envid_t)a1, (void*)a2); break;
		case SYS_ipc_try_send:
			//cprintf("send\n");
			r = sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void*)a3, (unsigned)a4);break;
f0105339:	e9 d9 00 00 00       	jmp    f0105417 <syscall+0x63e>
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
    if((uintptr_t) dstva < UTOP && ((uintptr_t) dstva % PGSIZE)) {
f010533e:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0105344:	77 0c                	ja     f0105352 <syscall+0x579>
f0105346:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f010534c:	0f 85 c0 00 00 00    	jne    f0105412 <syscall+0x639>
        return -E_INVAL;
    }

    curenv->env_ipc_value   = 0;
f0105352:	e8 e9 13 00 00       	call   f0106740 <cpunum>
f0105357:	6b c0 74             	imul   $0x74,%eax,%eax
f010535a:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0105360:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
    curenv->env_ipc_from    = 0;
f0105367:	e8 d4 13 00 00       	call   f0106740 <cpunum>
f010536c:	6b c0 74             	imul   $0x74,%eax,%eax
f010536f:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f0105375:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    curenv->env_ipc_perm    = 0;
f010537c:	e8 bf 13 00 00       	call   f0106740 <cpunum>
f0105381:	6b c0 74             	imul   $0x74,%eax,%eax
f0105384:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010538a:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
    curenv->env_ipc_recving = 1;
f0105391:	e8 aa 13 00 00       	call   f0106740 <cpunum>
f0105396:	6b c0 74             	imul   $0x74,%eax,%eax
f0105399:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010539f:	c6 40 68 01          	movb   $0x1,0x68(%eax)
    curenv->env_ipc_dstva   = dstva;
f01053a3:	e8 98 13 00 00       	call   f0106740 <cpunum>
f01053a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01053ab:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01053b1:	89 70 6c             	mov    %esi,0x6c(%eax)
    curenv->env_status      = ENV_NOT_RUNNABLE;
f01053b4:	e8 87 13 00 00       	call   f0106740 <cpunum>
f01053b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01053bc:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01053c2:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield ();
f01053c9:	e8 4e f9 ff ff       	call   f0104d1c <sched_yield>
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env * e;
	int res = envid2env(envid, &e, 1);
f01053ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053d5:	00 
f01053d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01053d9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053dd:	89 34 24             	mov    %esi,(%esp)
f01053e0:	e8 0c e6 ff ff       	call   f01039f1 <envid2env>
	//if(e->env_status == ENV_FREE);
//		return -E_BAD_ENV;
//	if((curenv->env_id != e->env_parent_id) && (curenv->env_id != e->env_id))
//		return -E_BAD_ENV;
	memcpy(&(e->env_tf), tf, sizeof(struct Trapframe));
f01053e5:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01053ec:	00 
f01053ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01053f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01053f4:	89 04 24             	mov    %eax,(%esp)
f01053f7:	e8 89 0d 00 00       	call   f0106185 <memcpy>
	e->env_tf.tf_cs |= 3;
f01053fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01053ff:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105404:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
			r = sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void*)a3, (unsigned)a4);break;
		case SYS_ipc_recv:
			//cprintf("recv\n");
			r = sys_ipc_recv((void*)a1);break;
		case SYS_env_set_trapframe:
			r = sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);break;
f010540b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105410:	eb 05                	jmp    f0105417 <syscall+0x63e>
		case SYS_ipc_try_send:
			//cprintf("send\n");
			r = sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void*)a3, (unsigned)a4);break;
		case SYS_ipc_recv:
			//cprintf("recv\n");
			r = sys_ipc_recv((void*)a1);break;
f0105412:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		r = -E_INVAL;
}
	return r;

	//panic("syscall not implemented");
}
f0105417:	89 d8                	mov    %ebx,%eax
f0105419:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010541c:	8b 75 f8             	mov    -0x8(%ebp),%esi
f010541f:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105422:	89 ec                	mov    %ebp,%esp
f0105424:	5d                   	pop    %ebp
f0105425:	c3                   	ret    
	...

f0105430 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105430:	55                   	push   %ebp
f0105431:	89 e5                	mov    %esp,%ebp
f0105433:	57                   	push   %edi
f0105434:	56                   	push   %esi
f0105435:	53                   	push   %ebx
f0105436:	83 ec 14             	sub    $0x14,%esp
f0105439:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010543c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f010543f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105442:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105445:	8b 1a                	mov    (%edx),%ebx
f0105447:	8b 01                	mov    (%ecx),%eax
f0105449:	89 45 ec             	mov    %eax,-0x14(%ebp)

	while (l <= r) {
f010544c:	39 c3                	cmp    %eax,%ebx
f010544e:	0f 8f 9c 00 00 00    	jg     f01054f0 <stab_binsearch+0xc0>
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
f0105454:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010545e:	01 d8                	add    %ebx,%eax
f0105460:	89 c7                	mov    %eax,%edi
f0105462:	c1 ef 1f             	shr    $0x1f,%edi
f0105465:	01 c7                	add    %eax,%edi
f0105467:	d1 ff                	sar    %edi

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105469:	39 df                	cmp    %ebx,%edi
f010546b:	7c 33                	jl     f01054a0 <stab_binsearch+0x70>
f010546d:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105470:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105473:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0105478:	39 f0                	cmp    %esi,%eax
f010547a:	0f 84 bc 00 00 00    	je     f010553c <stab_binsearch+0x10c>
f0105480:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
//		left = 0, right = 657;
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
f0105484:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f0105488:	89 f8                	mov    %edi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f010548a:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f010548d:	39 d8                	cmp    %ebx,%eax
f010548f:	7c 0f                	jl     f01054a0 <stab_binsearch+0x70>
f0105491:	0f b6 0a             	movzbl (%edx),%ecx
f0105494:	83 ea 0c             	sub    $0xc,%edx
f0105497:	39 f1                	cmp    %esi,%ecx
f0105499:	75 ef                	jne    f010548a <stab_binsearch+0x5a>
f010549b:	e9 9e 00 00 00       	jmp    f010553e <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01054a0:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01054a3:	eb 3c                	jmp    f01054e1 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f01054a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01054a8:	89 02                	mov    %eax,(%edx)
			l = true_m + 1;
f01054aa:	8d 5f 01             	lea    0x1(%edi),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01054ad:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f01054b4:	eb 2b                	jmp    f01054e1 <stab_binsearch+0xb1>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f01054b6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01054b9:	76 14                	jbe    f01054cf <stab_binsearch+0x9f>
			*region_right = m - 1;
f01054bb:	83 e8 01             	sub    $0x1,%eax
f01054be:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01054c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01054c4:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01054c6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f01054cd:	eb 12                	jmp    f01054e1 <stab_binsearch+0xb1>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01054cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01054d2:	89 02                	mov    %eax,(%edx)
			l = m;
			addr++;
f01054d4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01054d8:	89 c3                	mov    %eax,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01054da:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f01054e1:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f01054e4:	0f 8d 71 ff ff ff    	jge    f010545b <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f01054ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01054ee:	75 0f                	jne    f01054ff <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f01054f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01054f3:	8b 02                	mov    (%edx),%eax
f01054f5:	83 e8 01             	sub    $0x1,%eax
f01054f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01054fb:	89 01                	mov    %eax,(%ecx)
f01054fd:	eb 57                	jmp    f0105556 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01054ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105502:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105504:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105507:	8b 0a                	mov    (%edx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105509:	39 c1                	cmp    %eax,%ecx
f010550b:	7d 28                	jge    f0105535 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f010550d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105510:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0105513:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0105518:	39 f2                	cmp    %esi,%edx
f010551a:	74 19                	je     f0105535 <stab_binsearch+0x105>
f010551c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
//		left = 0, right = 657;
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
f0105520:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0105524:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105527:	39 c1                	cmp    %eax,%ecx
f0105529:	7d 0a                	jge    f0105535 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f010552b:	0f b6 1a             	movzbl (%edx),%ebx
f010552e:	83 ea 0c             	sub    $0xc,%edx
f0105531:	39 f3                	cmp    %esi,%ebx
f0105533:	75 ef                	jne    f0105524 <stab_binsearch+0xf4>
		     l--)
			/* do nothing */;
		*region_left = l;
f0105535:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105538:	89 02                	mov    %eax,(%edx)
f010553a:	eb 1a                	jmp    f0105556 <stab_binsearch+0x126>
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f010553c:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f010553e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105541:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0105544:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105548:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010554b:	0f 82 54 ff ff ff    	jb     f01054a5 <stab_binsearch+0x75>
f0105551:	e9 60 ff ff ff       	jmp    f01054b6 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105556:	83 c4 14             	add    $0x14,%esp
f0105559:	5b                   	pop    %ebx
f010555a:	5e                   	pop    %esi
f010555b:	5f                   	pop    %edi
f010555c:	5d                   	pop    %ebp
f010555d:	c3                   	ret    

f010555e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010555e:	55                   	push   %ebp
f010555f:	89 e5                	mov    %esp,%ebp
f0105561:	57                   	push   %edi
f0105562:	56                   	push   %esi
f0105563:	53                   	push   %ebx
f0105564:	83 ec 4c             	sub    $0x4c,%esp
f0105567:	8b 7d 08             	mov    0x8(%ebp),%edi
f010556a:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010556d:	c7 06 ac 87 10 f0    	movl   $0xf01087ac,(%esi)
	info->eip_line = 0;
f0105573:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f010557a:	c7 46 08 ac 87 10 f0 	movl   $0xf01087ac,0x8(%esi)
	info->eip_fn_namelen = 9;
f0105581:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0105588:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f010558b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105592:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105598:	0f 87 dd 00 00 00    	ja     f010567b <debuginfo_eip+0x11d>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check (curenv, usd, sizeof (struct UserStabData), PTE_U) < 0)
f010559e:	e8 9d 11 00 00       	call   f0106740 <cpunum>
f01055a3:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01055aa:	00 
f01055ab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f01055b2:	00 
f01055b3:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f01055ba:	00 
f01055bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01055be:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f01055c4:	89 04 24             	mov    %eax,(%esp)
f01055c7:	e8 94 e2 ff ff       	call   f0103860 <user_mem_check>
f01055cc:	89 c2                	mov    %eax,%edx
			return -1;
f01055ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check (curenv, usd, sizeof (struct UserStabData), PTE_U) < 0)
f01055d3:	85 d2                	test   %edx,%edx
f01055d5:	0f 88 51 02 00 00    	js     f010582c <debuginfo_eip+0x2ce>
			return -1;
		
		
		stabs = usd->stabs;
f01055db:	8b 1d 00 00 20 00    	mov    0x200000,%ebx
f01055e1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
		stab_end = usd->stab_end;
f01055e4:	8b 1d 04 00 20 00    	mov    0x200004,%ebx
		stabstr = usd->stabstr;
f01055ea:	a1 08 00 20 00       	mov    0x200008,%eax
f01055ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
		stabstr_end = usd->stabstr_end;
f01055f2:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f01055f8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check (curenv, stabs, stab_end - stabs, PTE_U) < 0
f01055fb:	e8 40 11 00 00       	call   f0106740 <cpunum>
f0105600:	89 c2                	mov    %eax,%edx
f0105602:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105609:	00 
f010560a:	89 d8                	mov    %ebx,%eax
f010560c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
f010560f:	c1 f8 02             	sar    $0x2,%eax
f0105612:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105618:	89 44 24 08          	mov    %eax,0x8(%esp)
f010561c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010561f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105623:	6b c2 74             	imul   $0x74,%edx,%eax
f0105626:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010562c:	89 04 24             	mov    %eax,(%esp)
f010562f:	e8 2c e2 ff ff       	call   f0103860 <user_mem_check>
f0105634:	89 c2                	mov    %eax,%edx
		|| user_mem_check (curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0)
			return -1;
f0105636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		stabstr = usd->stabstr;
		stabstr_end = usd->stabstr_end;

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check (curenv, stabs, stab_end - stabs, PTE_U) < 0
f010563b:	85 d2                	test   %edx,%edx
f010563d:	0f 88 e9 01 00 00    	js     f010582c <debuginfo_eip+0x2ce>
		|| user_mem_check (curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0)
f0105643:	e8 f8 10 00 00       	call   f0106740 <cpunum>
f0105648:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f010564f:	00 
f0105650:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105653:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0105656:	89 54 24 08          	mov    %edx,0x8(%esp)
f010565a:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010565d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105661:	6b c0 74             	imul   $0x74,%eax,%eax
f0105664:	8b 80 28 60 20 f0    	mov    -0xfdf9fd8(%eax),%eax
f010566a:	89 04 24             	mov    %eax,(%esp)
f010566d:	e8 ee e1 ff ff       	call   f0103860 <user_mem_check>
f0105672:	85 c0                	test   %eax,%eax
f0105674:	79 1f                	jns    f0105695 <debuginfo_eip+0x137>
f0105676:	e9 a5 01 00 00       	jmp    f0105820 <debuginfo_eip+0x2c2>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f010567b:	c7 45 d0 84 77 11 f0 	movl   $0xf0117784,-0x30(%ebp)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f0105682:	c7 45 cc 45 3e 11 f0 	movl   $0xf0113e45,-0x34(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f0105689:	bb 44 3e 11 f0       	mov    $0xf0113e44,%ebx
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f010568e:	c7 45 d4 50 8d 10 f0 	movl   $0xf0108d50,-0x2c(%ebp)
		
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
			return -1;
		
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f010569a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010569d:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
f01056a0:	0f 83 86 01 00 00    	jae    f010582c <debuginfo_eip+0x2ce>
f01056a6:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f01056aa:	0f 85 7c 01 00 00    	jne    f010582c <debuginfo_eip+0x2ce>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01056b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01056b7:	2b 5d d4             	sub    -0x2c(%ebp),%ebx
f01056ba:	c1 fb 02             	sar    $0x2,%ebx
f01056bd:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
f01056c3:	83 e8 01             	sub    $0x1,%eax
f01056c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01056c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01056cd:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f01056d4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01056d7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01056da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01056dd:	e8 4e fd ff ff       	call   f0105430 <stab_binsearch>
	if (lfile == 0)
f01056e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		return -1;
f01056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
f01056ea:	85 d2                	test   %edx,%edx
f01056ec:	0f 84 3a 01 00 00    	je     f010582c <debuginfo_eip+0x2ce>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01056f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	rfun = rfile;
f01056f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01056f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01056fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01056ff:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105706:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105709:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010570c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010570f:	e8 1c fd ff ff       	call   f0105430 <stab_binsearch>

	if (lfun <= rfun) {
f0105714:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0105717:	3b 5d d8             	cmp    -0x28(%ebp),%ebx
f010571a:	7f 23                	jg     f010573f <debuginfo_eip+0x1e1>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010571c:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010571f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105722:	8d 04 87             	lea    (%edi,%eax,4),%eax
f0105725:	8b 10                	mov    (%eax),%edx
f0105727:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010572a:	2b 4d cc             	sub    -0x34(%ebp),%ecx
f010572d:	39 ca                	cmp    %ecx,%edx
f010572f:	73 06                	jae    f0105737 <debuginfo_eip+0x1d9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105731:	03 55 cc             	add    -0x34(%ebp),%edx
f0105734:	89 56 08             	mov    %edx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105737:	8b 40 08             	mov    0x8(%eax),%eax
f010573a:	89 46 10             	mov    %eax,0x10(%esi)
f010573d:	eb 06                	jmp    f0105745 <debuginfo_eip+0x1e7>
		lline = lfun;
		rline = rfun;
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f010573f:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f0105742:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105745:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f010574c:	00 
f010574d:	8b 46 08             	mov    0x8(%esi),%eax
f0105750:	89 04 24             	mov    %eax,(%esp)
f0105753:	e8 32 09 00 00       	call   f010608a <strfind>
f0105758:	2b 46 08             	sub    0x8(%esi),%eax
f010575b:	89 46 0c             	mov    %eax,0xc(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010575e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105761:	39 fb                	cmp    %edi,%ebx
f0105763:	7c 65                	jl     f01057ca <debuginfo_eip+0x26c>
	       && stabs[lline].n_type != N_SOL
f0105765:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0105768:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010576b:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
f010576e:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
f0105772:	88 45 c7             	mov    %al,-0x39(%ebp)
f0105775:	3c 84                	cmp    $0x84,%al
f0105777:	74 39                	je     f01057b2 <debuginfo_eip+0x254>
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
f0105779:	8d 54 5b fd          	lea    -0x3(%ebx,%ebx,2),%edx
f010577d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105780:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0105783:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0105786:	0f b6 55 c7          	movzbl -0x39(%ebp),%edx
f010578a:	eb 15                	jmp    f01057a1 <debuginfo_eip+0x243>
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f010578c:	83 eb 01             	sub    $0x1,%ebx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010578f:	39 df                	cmp    %ebx,%edi
f0105791:	7f 37                	jg     f01057ca <debuginfo_eip+0x26c>
	       && stabs[lline].n_type != N_SOL
f0105793:	89 c1                	mov    %eax,%ecx
f0105795:	83 e8 0c             	sub    $0xc,%eax
f0105798:	0f b6 50 10          	movzbl 0x10(%eax),%edx
f010579c:	80 fa 84             	cmp    $0x84,%dl
f010579f:	74 11                	je     f01057b2 <debuginfo_eip+0x254>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01057a1:	80 fa 64             	cmp    $0x64,%dl
f01057a4:	75 e6                	jne    f010578c <debuginfo_eip+0x22e>
f01057a6:	83 79 08 00          	cmpl   $0x0,0x8(%ecx)
f01057aa:	74 e0                	je     f010578c <debuginfo_eip+0x22e>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01057ac:	39 fb                	cmp    %edi,%ebx
f01057ae:	66 90                	xchg   %ax,%ax
f01057b0:	7c 18                	jl     f01057ca <debuginfo_eip+0x26c>
f01057b2:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01057b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01057b8:	8b 04 83             	mov    (%ebx,%eax,4),%eax
f01057bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01057be:	2b 55 cc             	sub    -0x34(%ebp),%edx
f01057c1:	39 d0                	cmp    %edx,%eax
f01057c3:	73 05                	jae    f01057ca <debuginfo_eip+0x26c>
		info->eip_file = stabstr + stabs[lline].n_strx;
f01057c5:	03 45 cc             	add    -0x34(%ebp),%eax
f01057c8:	89 06                	mov    %eax,(%esi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01057ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01057cd:	8b 7d d8             	mov    -0x28(%ebp),%edi
f01057d0:	89 7d cc             	mov    %edi,-0x34(%ebp)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01057d3:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01057d8:	39 fb                	cmp    %edi,%ebx
f01057da:	7d 50                	jge    f010582c <debuginfo_eip+0x2ce>
		for (lline = lfun + 1;
f01057dc:	8d 53 01             	lea    0x1(%ebx),%edx
f01057df:	39 d7                	cmp    %edx,%edi
f01057e1:	7e 49                	jle    f010582c <debuginfo_eip+0x2ce>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01057e3:	8d 04 52             	lea    (%edx,%edx,2),%eax
f01057e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01057e9:	b8 00 00 00 00       	mov    $0x0,%eax

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01057ee:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f01057f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01057f4:	80 7c 8f 04 a0       	cmpb   $0xa0,0x4(%edi,%ecx,4)
f01057f9:	75 31                	jne    f010582c <debuginfo_eip+0x2ce>
f01057fb:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
f01057fe:	8d 44 87 1c          	lea    0x1c(%edi,%eax,4),%eax
f0105802:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0105805:	83 46 14 01          	addl   $0x1,0x14(%esi)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0105809:	83 c2 01             	add    $0x1,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f010580c:	39 d1                	cmp    %edx,%ecx
f010580e:	7e 17                	jle    f0105827 <debuginfo_eip+0x2c9>
f0105810:	83 c0 0c             	add    $0xc,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105813:	80 78 f4 a0          	cmpb   $0xa0,-0xc(%eax)
f0105817:	74 ec                	je     f0105805 <debuginfo_eip+0x2a7>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105819:	b8 00 00 00 00       	mov    $0x0,%eax
f010581e:	eb 0c                	jmp    f010582c <debuginfo_eip+0x2ce>

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check (curenv, stabs, stab_end - stabs, PTE_U) < 0
		|| user_mem_check (curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0)
			return -1;
f0105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105825:	eb 05                	jmp    f010582c <debuginfo_eip+0x2ce>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105827:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010582c:	83 c4 4c             	add    $0x4c,%esp
f010582f:	5b                   	pop    %ebx
f0105830:	5e                   	pop    %esi
f0105831:	5f                   	pop    %edi
f0105832:	5d                   	pop    %ebp
f0105833:	c3                   	ret    
	...

f0105840 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105840:	55                   	push   %ebp
f0105841:	89 e5                	mov    %esp,%ebp
f0105843:	57                   	push   %edi
f0105844:	56                   	push   %esi
f0105845:	53                   	push   %ebx
f0105846:	83 ec 3c             	sub    $0x3c,%esp
f0105849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010584c:	89 d7                	mov    %edx,%edi
f010584e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105851:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105854:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105857:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010585a:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010585d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105860:	b8 00 00 00 00       	mov    $0x0,%eax
f0105865:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0105868:	72 11                	jb     f010587b <printnum+0x3b>
f010586a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010586d:	39 45 10             	cmp    %eax,0x10(%ebp)
f0105870:	76 09                	jbe    f010587b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105872:	83 eb 01             	sub    $0x1,%ebx
f0105875:	85 db                	test   %ebx,%ebx
f0105877:	7f 51                	jg     f01058ca <printnum+0x8a>
f0105879:	eb 5e                	jmp    f01058d9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010587b:	89 74 24 10          	mov    %esi,0x10(%esp)
f010587f:	83 eb 01             	sub    $0x1,%ebx
f0105882:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105886:	8b 45 10             	mov    0x10(%ebp),%eax
f0105889:	89 44 24 08          	mov    %eax,0x8(%esp)
f010588d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
f0105891:	8b 74 24 0c          	mov    0xc(%esp),%esi
f0105895:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010589c:	00 
f010589d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01058a0:	89 04 24             	mov    %eax,(%esp)
f01058a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01058aa:	e8 21 13 00 00       	call   f0106bd0 <__udivdi3>
f01058af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01058b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01058b7:	89 04 24             	mov    %eax,(%esp)
f01058ba:	89 54 24 04          	mov    %edx,0x4(%esp)
f01058be:	89 fa                	mov    %edi,%edx
f01058c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058c3:	e8 78 ff ff ff       	call   f0105840 <printnum>
f01058c8:	eb 0f                	jmp    f01058d9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01058ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01058ce:	89 34 24             	mov    %esi,(%esp)
f01058d1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01058d4:	83 eb 01             	sub    $0x1,%ebx
f01058d7:	75 f1                	jne    f01058ca <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01058d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01058dd:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01058e1:	8b 45 10             	mov    0x10(%ebp),%eax
f01058e4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01058e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01058ef:	00 
f01058f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01058f3:	89 04 24             	mov    %eax,(%esp)
f01058f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058f9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01058fd:	e8 fe 13 00 00       	call   f0106d00 <__umoddi3>
f0105902:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105906:	0f be 80 b6 87 10 f0 	movsbl -0xfef784a(%eax),%eax
f010590d:	89 04 24             	mov    %eax,(%esp)
f0105910:	ff 55 e4             	call   *-0x1c(%ebp)
}
f0105913:	83 c4 3c             	add    $0x3c,%esp
f0105916:	5b                   	pop    %ebx
f0105917:	5e                   	pop    %esi
f0105918:	5f                   	pop    %edi
f0105919:	5d                   	pop    %ebp
f010591a:	c3                   	ret    

f010591b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f010591b:	55                   	push   %ebp
f010591c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f010591e:	83 fa 01             	cmp    $0x1,%edx
f0105921:	7e 0e                	jle    f0105931 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0105923:	8b 10                	mov    (%eax),%edx
f0105925:	8d 4a 08             	lea    0x8(%edx),%ecx
f0105928:	89 08                	mov    %ecx,(%eax)
f010592a:	8b 02                	mov    (%edx),%eax
f010592c:	8b 52 04             	mov    0x4(%edx),%edx
f010592f:	eb 22                	jmp    f0105953 <getuint+0x38>
	else if (lflag)
f0105931:	85 d2                	test   %edx,%edx
f0105933:	74 10                	je     f0105945 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0105935:	8b 10                	mov    (%eax),%edx
f0105937:	8d 4a 04             	lea    0x4(%edx),%ecx
f010593a:	89 08                	mov    %ecx,(%eax)
f010593c:	8b 02                	mov    (%edx),%eax
f010593e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105943:	eb 0e                	jmp    f0105953 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0105945:	8b 10                	mov    (%eax),%edx
f0105947:	8d 4a 04             	lea    0x4(%edx),%ecx
f010594a:	89 08                	mov    %ecx,(%eax)
f010594c:	8b 02                	mov    (%edx),%eax
f010594e:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105953:	5d                   	pop    %ebp
f0105954:	c3                   	ret    

f0105955 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105955:	55                   	push   %ebp
f0105956:	89 e5                	mov    %esp,%ebp
f0105958:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010595b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010595f:	8b 10                	mov    (%eax),%edx
f0105961:	3b 50 04             	cmp    0x4(%eax),%edx
f0105964:	73 0a                	jae    f0105970 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105966:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105969:	88 0a                	mov    %cl,(%edx)
f010596b:	83 c2 01             	add    $0x1,%edx
f010596e:	89 10                	mov    %edx,(%eax)
}
f0105970:	5d                   	pop    %ebp
f0105971:	c3                   	ret    

f0105972 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0105972:	55                   	push   %ebp
f0105973:	89 e5                	mov    %esp,%ebp
f0105975:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f0105978:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010597b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010597f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105982:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105986:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105989:	89 44 24 04          	mov    %eax,0x4(%esp)
f010598d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105990:	89 04 24             	mov    %eax,(%esp)
f0105993:	e8 02 00 00 00       	call   f010599a <vprintfmt>
	va_end(ap);
}
f0105998:	c9                   	leave  
f0105999:	c3                   	ret    

f010599a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f010599a:	55                   	push   %ebp
f010599b:	89 e5                	mov    %esp,%ebp
f010599d:	57                   	push   %edi
f010599e:	56                   	push   %esi
f010599f:	53                   	push   %ebx
f01059a0:	83 ec 4c             	sub    $0x4c,%esp
f01059a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01059a6:	8b 75 10             	mov    0x10(%ebp),%esi
f01059a9:	eb 12                	jmp    f01059bd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01059ab:	85 c0                	test   %eax,%eax
f01059ad:	0f 84 a9 03 00 00    	je     f0105d5c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
f01059b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01059b7:	89 04 24             	mov    %eax,(%esp)
f01059ba:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01059bd:	0f b6 06             	movzbl (%esi),%eax
f01059c0:	83 c6 01             	add    $0x1,%esi
f01059c3:	83 f8 25             	cmp    $0x25,%eax
f01059c6:	75 e3                	jne    f01059ab <vprintfmt+0x11>
f01059c8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
f01059cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01059d3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
f01059d8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01059df:	b9 00 00 00 00       	mov    $0x0,%ecx
f01059e4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01059e7:	eb 2b                	jmp    f0105a14 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01059e9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
f01059ec:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
f01059f0:	eb 22                	jmp    f0105a14 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01059f2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01059f5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
f01059f9:	eb 19                	jmp    f0105a14 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01059fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f01059fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0105a05:	eb 0d                	jmp    f0105a14 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f0105a07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105a0d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a14:	0f b6 06             	movzbl (%esi),%eax
f0105a17:	0f b6 d0             	movzbl %al,%edx
f0105a1a:	8d 7e 01             	lea    0x1(%esi),%edi
f0105a1d:	89 7d e0             	mov    %edi,-0x20(%ebp)
f0105a20:	83 e8 23             	sub    $0x23,%eax
f0105a23:	3c 55                	cmp    $0x55,%al
f0105a25:	0f 87 0b 03 00 00    	ja     f0105d36 <vprintfmt+0x39c>
f0105a2b:	0f b6 c0             	movzbl %al,%eax
f0105a2e:	ff 24 85 00 89 10 f0 	jmp    *-0xfef7700(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0105a35:	83 ea 30             	sub    $0x30,%edx
f0105a38:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
f0105a3b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
f0105a3f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a42:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
f0105a45:	83 fa 09             	cmp    $0x9,%edx
f0105a48:	77 4a                	ja     f0105a94 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a4a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0105a4d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
f0105a50:	8d 14 bf             	lea    (%edi,%edi,4),%edx
f0105a53:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
f0105a57:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
f0105a5a:	8d 50 d0             	lea    -0x30(%eax),%edx
f0105a5d:	83 fa 09             	cmp    $0x9,%edx
f0105a60:	76 eb                	jbe    f0105a4d <vprintfmt+0xb3>
f0105a62:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105a65:	eb 2d                	jmp    f0105a94 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0105a67:	8b 45 14             	mov    0x14(%ebp),%eax
f0105a6a:	8d 50 04             	lea    0x4(%eax),%edx
f0105a6d:	89 55 14             	mov    %edx,0x14(%ebp)
f0105a70:	8b 00                	mov    (%eax),%eax
f0105a72:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a75:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0105a78:	eb 1a                	jmp    f0105a94 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a7a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
f0105a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105a81:	79 91                	jns    f0105a14 <vprintfmt+0x7a>
f0105a83:	e9 73 ff ff ff       	jmp    f01059fb <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105a88:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0105a8b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
f0105a92:	eb 80                	jmp    f0105a14 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
f0105a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105a98:	0f 89 76 ff ff ff    	jns    f0105a14 <vprintfmt+0x7a>
f0105a9e:	e9 64 ff ff ff       	jmp    f0105a07 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0105aa3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105aa6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f0105aa9:	e9 66 ff ff ff       	jmp    f0105a14 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0105aae:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ab1:	8d 50 04             	lea    0x4(%eax),%edx
f0105ab4:	89 55 14             	mov    %edx,0x14(%ebp)
f0105ab7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105abb:	8b 00                	mov    (%eax),%eax
f0105abd:	89 04 24             	mov    %eax,(%esp)
f0105ac0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105ac3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
f0105ac6:	e9 f2 fe ff ff       	jmp    f01059bd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
f0105acb:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ace:	8d 50 04             	lea    0x4(%eax),%edx
f0105ad1:	89 55 14             	mov    %edx,0x14(%ebp)
f0105ad4:	8b 00                	mov    (%eax),%eax
f0105ad6:	89 c2                	mov    %eax,%edx
f0105ad8:	c1 fa 1f             	sar    $0x1f,%edx
f0105adb:	31 d0                	xor    %edx,%eax
f0105add:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105adf:	83 f8 0f             	cmp    $0xf,%eax
f0105ae2:	7f 0b                	jg     f0105aef <vprintfmt+0x155>
f0105ae4:	8b 14 85 60 8a 10 f0 	mov    -0xfef75a0(,%eax,4),%edx
f0105aeb:	85 d2                	test   %edx,%edx
f0105aed:	75 23                	jne    f0105b12 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
f0105aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105af3:	c7 44 24 08 ce 87 10 	movl   $0xf01087ce,0x8(%esp)
f0105afa:	f0 
f0105afb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105aff:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105b02:	89 3c 24             	mov    %edi,(%esp)
f0105b05:	e8 68 fe ff ff       	call   f0105972 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105b0a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f0105b0d:	e9 ab fe ff ff       	jmp    f01059bd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
f0105b12:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105b16:	c7 44 24 08 25 7f 10 	movl   $0xf0107f25,0x8(%esp)
f0105b1d:	f0 
f0105b1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105b22:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105b25:	89 3c 24             	mov    %edi,(%esp)
f0105b28:	e8 45 fe ff ff       	call   f0105972 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105b2d:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105b30:	e9 88 fe ff ff       	jmp    f01059bd <vprintfmt+0x23>
f0105b35:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0105b3e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b41:	8d 50 04             	lea    0x4(%eax),%edx
f0105b44:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b47:	8b 30                	mov    (%eax),%esi
				p = "(null)";
f0105b49:	85 f6                	test   %esi,%esi
f0105b4b:	ba c7 87 10 f0       	mov    $0xf01087c7,%edx
f0105b50:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
f0105b53:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105b57:	7e 06                	jle    f0105b5f <vprintfmt+0x1c5>
f0105b59:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
f0105b5d:	75 10                	jne    f0105b6f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105b5f:	0f be 06             	movsbl (%esi),%eax
f0105b62:	83 c6 01             	add    $0x1,%esi
f0105b65:	85 c0                	test   %eax,%eax
f0105b67:	0f 85 86 00 00 00    	jne    f0105bf3 <vprintfmt+0x259>
f0105b6d:	eb 76                	jmp    f0105be5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105b6f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105b73:	89 34 24             	mov    %esi,(%esp)
f0105b76:	e8 70 03 00 00       	call   f0105eeb <strnlen>
f0105b7b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105b7e:	29 c2                	sub    %eax,%edx
f0105b80:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105b83:	85 d2                	test   %edx,%edx
f0105b85:	7e d8                	jle    f0105b5f <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105b87:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
f0105b8b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f0105b8e:	89 d6                	mov    %edx,%esi
f0105b90:	89 7d d0             	mov    %edi,-0x30(%ebp)
f0105b93:	89 c7                	mov    %eax,%edi
f0105b95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105b99:	89 3c 24             	mov    %edi,(%esp)
f0105b9c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105b9f:	83 ee 01             	sub    $0x1,%esi
f0105ba2:	75 f1                	jne    f0105b95 <vprintfmt+0x1fb>
f0105ba4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0105ba7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0105baa:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0105bad:	eb b0                	jmp    f0105b5f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0105baf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105bb3:	74 18                	je     f0105bcd <vprintfmt+0x233>
f0105bb5:	8d 50 e0             	lea    -0x20(%eax),%edx
f0105bb8:	83 fa 5e             	cmp    $0x5e,%edx
f0105bbb:	76 10                	jbe    f0105bcd <vprintfmt+0x233>
					putch('?', putdat);
f0105bbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105bc1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0105bc8:	ff 55 08             	call   *0x8(%ebp)
f0105bcb:	eb 0a                	jmp    f0105bd7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
f0105bcd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105bd1:	89 04 24             	mov    %eax,(%esp)
f0105bd4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105bd7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0105bdb:	0f be 06             	movsbl (%esi),%eax
f0105bde:	83 c6 01             	add    $0x1,%esi
f0105be1:	85 c0                	test   %eax,%eax
f0105be3:	75 0e                	jne    f0105bf3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105be5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105bec:	7f 16                	jg     f0105c04 <vprintfmt+0x26a>
f0105bee:	e9 ca fd ff ff       	jmp    f01059bd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105bf3:	85 ff                	test   %edi,%edi
f0105bf5:	78 b8                	js     f0105baf <vprintfmt+0x215>
f0105bf7:	83 ef 01             	sub    $0x1,%edi
f0105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105c00:	79 ad                	jns    f0105baf <vprintfmt+0x215>
f0105c02:	eb e1                	jmp    f0105be5 <vprintfmt+0x24b>
f0105c04:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105c07:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0105c0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105c0e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0105c15:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105c17:	83 ee 01             	sub    $0x1,%esi
f0105c1a:	75 ee                	jne    f0105c0a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105c1c:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105c1f:	e9 99 fd ff ff       	jmp    f01059bd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0105c24:	83 f9 01             	cmp    $0x1,%ecx
f0105c27:	7e 10                	jle    f0105c39 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
f0105c29:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c2c:	8d 50 08             	lea    0x8(%eax),%edx
f0105c2f:	89 55 14             	mov    %edx,0x14(%ebp)
f0105c32:	8b 30                	mov    (%eax),%esi
f0105c34:	8b 78 04             	mov    0x4(%eax),%edi
f0105c37:	eb 26                	jmp    f0105c5f <vprintfmt+0x2c5>
	else if (lflag)
f0105c39:	85 c9                	test   %ecx,%ecx
f0105c3b:	74 12                	je     f0105c4f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
f0105c3d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c40:	8d 50 04             	lea    0x4(%eax),%edx
f0105c43:	89 55 14             	mov    %edx,0x14(%ebp)
f0105c46:	8b 30                	mov    (%eax),%esi
f0105c48:	89 f7                	mov    %esi,%edi
f0105c4a:	c1 ff 1f             	sar    $0x1f,%edi
f0105c4d:	eb 10                	jmp    f0105c5f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
f0105c4f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c52:	8d 50 04             	lea    0x4(%eax),%edx
f0105c55:	89 55 14             	mov    %edx,0x14(%ebp)
f0105c58:	8b 30                	mov    (%eax),%esi
f0105c5a:	89 f7                	mov    %esi,%edi
f0105c5c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f0105c5f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f0105c64:	85 ff                	test   %edi,%edi
f0105c66:	0f 89 8c 00 00 00    	jns    f0105cf8 <vprintfmt+0x35e>
				putch('-', putdat);
f0105c6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105c70:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0105c77:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0105c7a:	f7 de                	neg    %esi
f0105c7c:	83 d7 00             	adc    $0x0,%edi
f0105c7f:	f7 df                	neg    %edi
			}
			base = 10;
f0105c81:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105c86:	eb 70                	jmp    f0105cf8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0105c88:	89 ca                	mov    %ecx,%edx
f0105c8a:	8d 45 14             	lea    0x14(%ebp),%eax
f0105c8d:	e8 89 fc ff ff       	call   f010591b <getuint>
f0105c92:	89 c6                	mov    %eax,%esi
f0105c94:	89 d7                	mov    %edx,%edi
			base = 10;
f0105c96:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
f0105c9b:	eb 5b                	jmp    f0105cf8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
f0105c9d:	89 ca                	mov    %ecx,%edx
f0105c9f:	8d 45 14             	lea    0x14(%ebp),%eax
f0105ca2:	e8 74 fc ff ff       	call   f010591b <getuint>
f0105ca7:	89 c6                	mov    %eax,%esi
f0105ca9:	89 d7                	mov    %edx,%edi
			base = 8;
f0105cab:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
f0105cb0:	eb 46                	jmp    f0105cf8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
f0105cb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105cb6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0105cbd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0105cc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105cc4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0105ccb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0105cce:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cd1:	8d 50 04             	lea    0x4(%eax),%edx
f0105cd4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0105cd7:	8b 30                	mov    (%eax),%esi
f0105cd9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0105cde:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0105ce3:	eb 13                	jmp    f0105cf8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0105ce5:	89 ca                	mov    %ecx,%edx
f0105ce7:	8d 45 14             	lea    0x14(%ebp),%eax
f0105cea:	e8 2c fc ff ff       	call   f010591b <getuint>
f0105cef:	89 c6                	mov    %eax,%esi
f0105cf1:	89 d7                	mov    %edx,%edi
			base = 16;
f0105cf3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
f0105cf8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
f0105cfc:	89 54 24 10          	mov    %edx,0x10(%esp)
f0105d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105d03:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105d07:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105d0b:	89 34 24             	mov    %esi,(%esp)
f0105d0e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105d12:	89 da                	mov    %ebx,%edx
f0105d14:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d17:	e8 24 fb ff ff       	call   f0105840 <printnum>
			break;
f0105d1c:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105d1f:	e9 99 fc ff ff       	jmp    f01059bd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0105d24:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105d28:	89 14 24             	mov    %edx,(%esp)
f0105d2b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105d2e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
f0105d31:	e9 87 fc ff ff       	jmp    f01059bd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0105d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105d3a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0105d41:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105d44:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
f0105d48:	0f 84 6f fc ff ff    	je     f01059bd <vprintfmt+0x23>
f0105d4e:	83 ee 01             	sub    $0x1,%esi
f0105d51:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
f0105d55:	75 f7                	jne    f0105d4e <vprintfmt+0x3b4>
f0105d57:	e9 61 fc ff ff       	jmp    f01059bd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
f0105d5c:	83 c4 4c             	add    $0x4c,%esp
f0105d5f:	5b                   	pop    %ebx
f0105d60:	5e                   	pop    %esi
f0105d61:	5f                   	pop    %edi
f0105d62:	5d                   	pop    %ebp
f0105d63:	c3                   	ret    

f0105d64 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105d64:	55                   	push   %ebp
f0105d65:	89 e5                	mov    %esp,%ebp
f0105d67:	83 ec 28             	sub    $0x28,%esp
f0105d6a:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105d73:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105d77:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0105d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105d81:	85 c0                	test   %eax,%eax
f0105d83:	74 30                	je     f0105db5 <vsnprintf+0x51>
f0105d85:	85 d2                	test   %edx,%edx
f0105d87:	7e 2c                	jle    f0105db5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105d89:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105d90:	8b 45 10             	mov    0x10(%ebp),%eax
f0105d93:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105d97:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d9e:	c7 04 24 55 59 10 f0 	movl   $0xf0105955,(%esp)
f0105da5:	e8 f0 fb ff ff       	call   f010599a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105dad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105db3:	eb 05                	jmp    f0105dba <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0105db5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0105dba:	c9                   	leave  
f0105dbb:	c3                   	ret    

f0105dbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105dbc:	55                   	push   %ebp
f0105dbd:	89 e5                	mov    %esp,%ebp
f0105dbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105dc2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105dc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105dc9:	8b 45 10             	mov    0x10(%ebp),%eax
f0105dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105dd7:	8b 45 08             	mov    0x8(%ebp),%eax
f0105dda:	89 04 24             	mov    %eax,(%esp)
f0105ddd:	e8 82 ff ff ff       	call   f0105d64 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105de2:	c9                   	leave  
f0105de3:	c3                   	ret    
	...

f0105df0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105df0:	55                   	push   %ebp
f0105df1:	89 e5                	mov    %esp,%ebp
f0105df3:	57                   	push   %edi
f0105df4:	56                   	push   %esi
f0105df5:	53                   	push   %ebx
f0105df6:	83 ec 1c             	sub    $0x1c,%esp
f0105df9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105dfc:	85 c0                	test   %eax,%eax
f0105dfe:	74 10                	je     f0105e10 <readline+0x20>
		cprintf("%s", prompt);
f0105e00:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e04:	c7 04 24 25 7f 10 f0 	movl   $0xf0107f25,(%esp)
f0105e0b:	e8 da e4 ff ff       	call   f01042ea <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105e17:	e8 dc a9 ff ff       	call   f01007f8 <iscons>
f0105e1c:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0105e1e:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0105e23:	e8 bf a9 ff ff       	call   f01007e7 <getchar>
f0105e28:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105e2a:	85 c0                	test   %eax,%eax
f0105e2c:	79 25                	jns    f0105e53 <readline+0x63>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105e2e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0105e33:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105e36:	0f 84 89 00 00 00    	je     f0105ec5 <readline+0xd5>
				cprintf("read error: %e\n", c);
f0105e3c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105e40:	c7 04 24 bf 8a 10 f0 	movl   $0xf0108abf,(%esp)
f0105e47:	e8 9e e4 ff ff       	call   f01042ea <cprintf>
			return NULL;
f0105e4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e51:	eb 72                	jmp    f0105ec5 <readline+0xd5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105e53:	83 f8 08             	cmp    $0x8,%eax
f0105e56:	74 05                	je     f0105e5d <readline+0x6d>
f0105e58:	83 f8 7f             	cmp    $0x7f,%eax
f0105e5b:	75 1a                	jne    f0105e77 <readline+0x87>
f0105e5d:	85 f6                	test   %esi,%esi
f0105e5f:	90                   	nop
f0105e60:	7e 15                	jle    f0105e77 <readline+0x87>
			if (echoing)
f0105e62:	85 ff                	test   %edi,%edi
f0105e64:	74 0c                	je     f0105e72 <readline+0x82>
				cputchar('\b');
f0105e66:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0105e6d:	e8 65 a9 ff ff       	call   f01007d7 <cputchar>
			i--;
f0105e72:	83 ee 01             	sub    $0x1,%esi
f0105e75:	eb ac                	jmp    f0105e23 <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105e77:	83 fb 1f             	cmp    $0x1f,%ebx
f0105e7a:	7e 1f                	jle    f0105e9b <readline+0xab>
f0105e7c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105e82:	7f 17                	jg     f0105e9b <readline+0xab>
			if (echoing)
f0105e84:	85 ff                	test   %edi,%edi
f0105e86:	74 08                	je     f0105e90 <readline+0xa0>
				cputchar(c);
f0105e88:	89 1c 24             	mov    %ebx,(%esp)
f0105e8b:	e8 47 a9 ff ff       	call   f01007d7 <cputchar>
			buf[i++] = c;
f0105e90:	88 9e 80 5a 20 f0    	mov    %bl,-0xfdfa580(%esi)
f0105e96:	83 c6 01             	add    $0x1,%esi
f0105e99:	eb 88                	jmp    f0105e23 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0105e9b:	83 fb 0a             	cmp    $0xa,%ebx
f0105e9e:	74 09                	je     f0105ea9 <readline+0xb9>
f0105ea0:	83 fb 0d             	cmp    $0xd,%ebx
f0105ea3:	0f 85 7a ff ff ff    	jne    f0105e23 <readline+0x33>
			if (echoing)
f0105ea9:	85 ff                	test   %edi,%edi
f0105eab:	74 0c                	je     f0105eb9 <readline+0xc9>
				cputchar('\n');
f0105ead:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0105eb4:	e8 1e a9 ff ff       	call   f01007d7 <cputchar>
			buf[i] = 0;
f0105eb9:	c6 86 80 5a 20 f0 00 	movb   $0x0,-0xfdfa580(%esi)
			return buf;
f0105ec0:	b8 80 5a 20 f0       	mov    $0xf0205a80,%eax
		}
	}
}
f0105ec5:	83 c4 1c             	add    $0x1c,%esp
f0105ec8:	5b                   	pop    %ebx
f0105ec9:	5e                   	pop    %esi
f0105eca:	5f                   	pop    %edi
f0105ecb:	5d                   	pop    %ebp
f0105ecc:	c3                   	ret    
f0105ecd:	00 00                	add    %al,(%eax)
	...

f0105ed0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105ed0:	55                   	push   %ebp
f0105ed1:	89 e5                	mov    %esp,%ebp
f0105ed3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105ed6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105edb:	80 3a 00             	cmpb   $0x0,(%edx)
f0105ede:	74 09                	je     f0105ee9 <strlen+0x19>
		n++;
f0105ee0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0105ee3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105ee7:	75 f7                	jne    f0105ee0 <strlen+0x10>
		n++;
	return n;
}
f0105ee9:	5d                   	pop    %ebp
f0105eea:	c3                   	ret    

f0105eeb <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105eeb:	55                   	push   %ebp
f0105eec:	89 e5                	mov    %esp,%ebp
f0105eee:	53                   	push   %ebx
f0105eef:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105ef5:	b8 00 00 00 00       	mov    $0x0,%eax
f0105efa:	85 c9                	test   %ecx,%ecx
f0105efc:	74 1a                	je     f0105f18 <strnlen+0x2d>
f0105efe:	80 3b 00             	cmpb   $0x0,(%ebx)
f0105f01:	74 15                	je     f0105f18 <strnlen+0x2d>
f0105f03:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
f0105f08:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105f0a:	39 ca                	cmp    %ecx,%edx
f0105f0c:	74 0a                	je     f0105f18 <strnlen+0x2d>
f0105f0e:	83 c2 01             	add    $0x1,%edx
f0105f11:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
f0105f16:	75 f0                	jne    f0105f08 <strnlen+0x1d>
		n++;
	return n;
}
f0105f18:	5b                   	pop    %ebx
f0105f19:	5d                   	pop    %ebp
f0105f1a:	c3                   	ret    

f0105f1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105f1b:	55                   	push   %ebp
f0105f1c:	89 e5                	mov    %esp,%ebp
f0105f1e:	53                   	push   %ebx
f0105f1f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105f25:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f2a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0105f2e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0105f31:	83 c2 01             	add    $0x1,%edx
f0105f34:	84 c9                	test   %cl,%cl
f0105f36:	75 f2                	jne    f0105f2a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0105f38:	5b                   	pop    %ebx
f0105f39:	5d                   	pop    %ebp
f0105f3a:	c3                   	ret    

f0105f3b <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105f3b:	55                   	push   %ebp
f0105f3c:	89 e5                	mov    %esp,%ebp
f0105f3e:	53                   	push   %ebx
f0105f3f:	83 ec 08             	sub    $0x8,%esp
f0105f42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105f45:	89 1c 24             	mov    %ebx,(%esp)
f0105f48:	e8 83 ff ff ff       	call   f0105ed0 <strlen>
	strcpy(dst + len, src);
f0105f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f50:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105f54:	01 d8                	add    %ebx,%eax
f0105f56:	89 04 24             	mov    %eax,(%esp)
f0105f59:	e8 bd ff ff ff       	call   f0105f1b <strcpy>
	return dst;
}
f0105f5e:	89 d8                	mov    %ebx,%eax
f0105f60:	83 c4 08             	add    $0x8,%esp
f0105f63:	5b                   	pop    %ebx
f0105f64:	5d                   	pop    %ebp
f0105f65:	c3                   	ret    

f0105f66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105f66:	55                   	push   %ebp
f0105f67:	89 e5                	mov    %esp,%ebp
f0105f69:	56                   	push   %esi
f0105f6a:	53                   	push   %ebx
f0105f6b:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f71:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105f74:	85 f6                	test   %esi,%esi
f0105f76:	74 18                	je     f0105f90 <strncpy+0x2a>
f0105f78:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0105f7d:	0f b6 1a             	movzbl (%edx),%ebx
f0105f80:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105f83:	80 3a 01             	cmpb   $0x1,(%edx)
f0105f86:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105f89:	83 c1 01             	add    $0x1,%ecx
f0105f8c:	39 f1                	cmp    %esi,%ecx
f0105f8e:	75 ed                	jne    f0105f7d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0105f90:	5b                   	pop    %ebx
f0105f91:	5e                   	pop    %esi
f0105f92:	5d                   	pop    %ebp
f0105f93:	c3                   	ret    

f0105f94 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105f94:	55                   	push   %ebp
f0105f95:	89 e5                	mov    %esp,%ebp
f0105f97:	57                   	push   %edi
f0105f98:	56                   	push   %esi
f0105f99:	53                   	push   %ebx
f0105f9a:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105f9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105fa0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105fa3:	89 f8                	mov    %edi,%eax
f0105fa5:	85 f6                	test   %esi,%esi
f0105fa7:	74 2b                	je     f0105fd4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
f0105fa9:	83 fe 01             	cmp    $0x1,%esi
f0105fac:	74 23                	je     f0105fd1 <strlcpy+0x3d>
f0105fae:	0f b6 0b             	movzbl (%ebx),%ecx
f0105fb1:	84 c9                	test   %cl,%cl
f0105fb3:	74 1c                	je     f0105fd1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
f0105fb5:	83 ee 02             	sub    $0x2,%esi
f0105fb8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0105fbd:	88 08                	mov    %cl,(%eax)
f0105fbf:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0105fc2:	39 f2                	cmp    %esi,%edx
f0105fc4:	74 0b                	je     f0105fd1 <strlcpy+0x3d>
f0105fc6:	83 c2 01             	add    $0x1,%edx
f0105fc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0105fcd:	84 c9                	test   %cl,%cl
f0105fcf:	75 ec                	jne    f0105fbd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
f0105fd1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105fd4:	29 f8                	sub    %edi,%eax
}
f0105fd6:	5b                   	pop    %ebx
f0105fd7:	5e                   	pop    %esi
f0105fd8:	5f                   	pop    %edi
f0105fd9:	5d                   	pop    %ebp
f0105fda:	c3                   	ret    

f0105fdb <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105fdb:	55                   	push   %ebp
f0105fdc:	89 e5                	mov    %esp,%ebp
f0105fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105fe4:	0f b6 01             	movzbl (%ecx),%eax
f0105fe7:	84 c0                	test   %al,%al
f0105fe9:	74 16                	je     f0106001 <strcmp+0x26>
f0105feb:	3a 02                	cmp    (%edx),%al
f0105fed:	75 12                	jne    f0106001 <strcmp+0x26>
		p++, q++;
f0105fef:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0105ff2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
f0105ff6:	84 c0                	test   %al,%al
f0105ff8:	74 07                	je     f0106001 <strcmp+0x26>
f0105ffa:	83 c1 01             	add    $0x1,%ecx
f0105ffd:	3a 02                	cmp    (%edx),%al
f0105fff:	74 ee                	je     f0105fef <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106001:	0f b6 c0             	movzbl %al,%eax
f0106004:	0f b6 12             	movzbl (%edx),%edx
f0106007:	29 d0                	sub    %edx,%eax
}
f0106009:	5d                   	pop    %ebp
f010600a:	c3                   	ret    

f010600b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010600b:	55                   	push   %ebp
f010600c:	89 e5                	mov    %esp,%ebp
f010600e:	53                   	push   %ebx
f010600f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106012:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106015:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0106018:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f010601d:	85 d2                	test   %edx,%edx
f010601f:	74 28                	je     f0106049 <strncmp+0x3e>
f0106021:	0f b6 01             	movzbl (%ecx),%eax
f0106024:	84 c0                	test   %al,%al
f0106026:	74 24                	je     f010604c <strncmp+0x41>
f0106028:	3a 03                	cmp    (%ebx),%al
f010602a:	75 20                	jne    f010604c <strncmp+0x41>
f010602c:	83 ea 01             	sub    $0x1,%edx
f010602f:	74 13                	je     f0106044 <strncmp+0x39>
		n--, p++, q++;
f0106031:	83 c1 01             	add    $0x1,%ecx
f0106034:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0106037:	0f b6 01             	movzbl (%ecx),%eax
f010603a:	84 c0                	test   %al,%al
f010603c:	74 0e                	je     f010604c <strncmp+0x41>
f010603e:	3a 03                	cmp    (%ebx),%al
f0106040:	74 ea                	je     f010602c <strncmp+0x21>
f0106042:	eb 08                	jmp    f010604c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
f0106044:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0106049:	5b                   	pop    %ebx
f010604a:	5d                   	pop    %ebp
f010604b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010604c:	0f b6 01             	movzbl (%ecx),%eax
f010604f:	0f b6 13             	movzbl (%ebx),%edx
f0106052:	29 d0                	sub    %edx,%eax
f0106054:	eb f3                	jmp    f0106049 <strncmp+0x3e>

f0106056 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106056:	55                   	push   %ebp
f0106057:	89 e5                	mov    %esp,%ebp
f0106059:	8b 45 08             	mov    0x8(%ebp),%eax
f010605c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106060:	0f b6 10             	movzbl (%eax),%edx
f0106063:	84 d2                	test   %dl,%dl
f0106065:	74 1c                	je     f0106083 <strchr+0x2d>
		if (*s == c)
f0106067:	38 ca                	cmp    %cl,%dl
f0106069:	75 09                	jne    f0106074 <strchr+0x1e>
f010606b:	eb 1b                	jmp    f0106088 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010606d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
f0106070:	38 ca                	cmp    %cl,%dl
f0106072:	74 14                	je     f0106088 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0106074:	0f b6 50 01          	movzbl 0x1(%eax),%edx
f0106078:	84 d2                	test   %dl,%dl
f010607a:	75 f1                	jne    f010606d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
f010607c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106081:	eb 05                	jmp    f0106088 <strchr+0x32>
f0106083:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106088:	5d                   	pop    %ebp
f0106089:	c3                   	ret    

f010608a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010608a:	55                   	push   %ebp
f010608b:	89 e5                	mov    %esp,%ebp
f010608d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106090:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106094:	0f b6 10             	movzbl (%eax),%edx
f0106097:	84 d2                	test   %dl,%dl
f0106099:	74 14                	je     f01060af <strfind+0x25>
		if (*s == c)
f010609b:	38 ca                	cmp    %cl,%dl
f010609d:	75 06                	jne    f01060a5 <strfind+0x1b>
f010609f:	eb 0e                	jmp    f01060af <strfind+0x25>
f01060a1:	38 ca                	cmp    %cl,%dl
f01060a3:	74 0a                	je     f01060af <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01060a5:	83 c0 01             	add    $0x1,%eax
f01060a8:	0f b6 10             	movzbl (%eax),%edx
f01060ab:	84 d2                	test   %dl,%dl
f01060ad:	75 f2                	jne    f01060a1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f01060af:	5d                   	pop    %ebp
f01060b0:	c3                   	ret    

f01060b1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01060b1:	55                   	push   %ebp
f01060b2:	89 e5                	mov    %esp,%ebp
f01060b4:	83 ec 0c             	sub    $0xc,%esp
f01060b7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01060ba:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01060bd:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01060c0:	8b 7d 08             	mov    0x8(%ebp),%edi
f01060c3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01060c9:	85 c9                	test   %ecx,%ecx
f01060cb:	74 30                	je     f01060fd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01060cd:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01060d3:	75 25                	jne    f01060fa <memset+0x49>
f01060d5:	f6 c1 03             	test   $0x3,%cl
f01060d8:	75 20                	jne    f01060fa <memset+0x49>
		c &= 0xFF;
f01060da:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01060dd:	89 d3                	mov    %edx,%ebx
f01060df:	c1 e3 08             	shl    $0x8,%ebx
f01060e2:	89 d6                	mov    %edx,%esi
f01060e4:	c1 e6 18             	shl    $0x18,%esi
f01060e7:	89 d0                	mov    %edx,%eax
f01060e9:	c1 e0 10             	shl    $0x10,%eax
f01060ec:	09 f0                	or     %esi,%eax
f01060ee:	09 d0                	or     %edx,%eax
f01060f0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01060f2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f01060f5:	fc                   	cld    
f01060f6:	f3 ab                	rep stos %eax,%es:(%edi)
f01060f8:	eb 03                	jmp    f01060fd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01060fa:	fc                   	cld    
f01060fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01060fd:	89 f8                	mov    %edi,%eax
f01060ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0106102:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0106105:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0106108:	89 ec                	mov    %ebp,%esp
f010610a:	5d                   	pop    %ebp
f010610b:	c3                   	ret    

f010610c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010610c:	55                   	push   %ebp
f010610d:	89 e5                	mov    %esp,%ebp
f010610f:	83 ec 08             	sub    $0x8,%esp
f0106112:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0106115:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0106118:	8b 45 08             	mov    0x8(%ebp),%eax
f010611b:	8b 75 0c             	mov    0xc(%ebp),%esi
f010611e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106121:	39 c6                	cmp    %eax,%esi
f0106123:	73 36                	jae    f010615b <memmove+0x4f>
f0106125:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106128:	39 d0                	cmp    %edx,%eax
f010612a:	73 2f                	jae    f010615b <memmove+0x4f>
		s += n;
		d += n;
f010612c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010612f:	f6 c2 03             	test   $0x3,%dl
f0106132:	75 1b                	jne    f010614f <memmove+0x43>
f0106134:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010613a:	75 13                	jne    f010614f <memmove+0x43>
f010613c:	f6 c1 03             	test   $0x3,%cl
f010613f:	75 0e                	jne    f010614f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106141:	83 ef 04             	sub    $0x4,%edi
f0106144:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106147:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010614a:	fd                   	std    
f010614b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010614d:	eb 09                	jmp    f0106158 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010614f:	83 ef 01             	sub    $0x1,%edi
f0106152:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106155:	fd                   	std    
f0106156:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106158:	fc                   	cld    
f0106159:	eb 20                	jmp    f010617b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010615b:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106161:	75 13                	jne    f0106176 <memmove+0x6a>
f0106163:	a8 03                	test   $0x3,%al
f0106165:	75 0f                	jne    f0106176 <memmove+0x6a>
f0106167:	f6 c1 03             	test   $0x3,%cl
f010616a:	75 0a                	jne    f0106176 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010616c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f010616f:	89 c7                	mov    %eax,%edi
f0106171:	fc                   	cld    
f0106172:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106174:	eb 05                	jmp    f010617b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0106176:	89 c7                	mov    %eax,%edi
f0106178:	fc                   	cld    
f0106179:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010617b:	8b 75 f8             	mov    -0x8(%ebp),%esi
f010617e:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0106181:	89 ec                	mov    %ebp,%esp
f0106183:	5d                   	pop    %ebp
f0106184:	c3                   	ret    

f0106185 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106185:	55                   	push   %ebp
f0106186:	89 e5                	mov    %esp,%ebp
f0106188:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f010618b:	8b 45 10             	mov    0x10(%ebp),%eax
f010618e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106192:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106195:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106199:	8b 45 08             	mov    0x8(%ebp),%eax
f010619c:	89 04 24             	mov    %eax,(%esp)
f010619f:	e8 68 ff ff ff       	call   f010610c <memmove>
}
f01061a4:	c9                   	leave  
f01061a5:	c3                   	ret    

f01061a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01061a6:	55                   	push   %ebp
f01061a7:	89 e5                	mov    %esp,%ebp
f01061a9:	57                   	push   %edi
f01061aa:	56                   	push   %esi
f01061ab:	53                   	push   %ebx
f01061ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01061af:	8b 75 0c             	mov    0xc(%ebp),%esi
f01061b2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01061b5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01061ba:	85 ff                	test   %edi,%edi
f01061bc:	74 37                	je     f01061f5 <memcmp+0x4f>
		if (*s1 != *s2)
f01061be:	0f b6 03             	movzbl (%ebx),%eax
f01061c1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01061c4:	83 ef 01             	sub    $0x1,%edi
f01061c7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
f01061cc:	38 c8                	cmp    %cl,%al
f01061ce:	74 1c                	je     f01061ec <memcmp+0x46>
f01061d0:	eb 10                	jmp    f01061e2 <memcmp+0x3c>
f01061d2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f01061d7:	83 c2 01             	add    $0x1,%edx
f01061da:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
f01061de:	38 c8                	cmp    %cl,%al
f01061e0:	74 0a                	je     f01061ec <memcmp+0x46>
			return (int) *s1 - (int) *s2;
f01061e2:	0f b6 c0             	movzbl %al,%eax
f01061e5:	0f b6 c9             	movzbl %cl,%ecx
f01061e8:	29 c8                	sub    %ecx,%eax
f01061ea:	eb 09                	jmp    f01061f5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01061ec:	39 fa                	cmp    %edi,%edx
f01061ee:	75 e2                	jne    f01061d2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01061f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01061f5:	5b                   	pop    %ebx
f01061f6:	5e                   	pop    %esi
f01061f7:	5f                   	pop    %edi
f01061f8:	5d                   	pop    %ebp
f01061f9:	c3                   	ret    

f01061fa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01061fa:	55                   	push   %ebp
f01061fb:	89 e5                	mov    %esp,%ebp
f01061fd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f0106200:	89 c2                	mov    %eax,%edx
f0106202:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106205:	39 d0                	cmp    %edx,%eax
f0106207:	73 19                	jae    f0106222 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106209:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f010620d:	38 08                	cmp    %cl,(%eax)
f010620f:	75 06                	jne    f0106217 <memfind+0x1d>
f0106211:	eb 0f                	jmp    f0106222 <memfind+0x28>
f0106213:	38 08                	cmp    %cl,(%eax)
f0106215:	74 0b                	je     f0106222 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0106217:	83 c0 01             	add    $0x1,%eax
f010621a:	39 d0                	cmp    %edx,%eax
f010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106220:	75 f1                	jne    f0106213 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0106222:	5d                   	pop    %ebp
f0106223:	c3                   	ret    

f0106224 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106224:	55                   	push   %ebp
f0106225:	89 e5                	mov    %esp,%ebp
f0106227:	57                   	push   %edi
f0106228:	56                   	push   %esi
f0106229:	53                   	push   %ebx
f010622a:	8b 55 08             	mov    0x8(%ebp),%edx
f010622d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106230:	0f b6 02             	movzbl (%edx),%eax
f0106233:	3c 20                	cmp    $0x20,%al
f0106235:	74 04                	je     f010623b <strtol+0x17>
f0106237:	3c 09                	cmp    $0x9,%al
f0106239:	75 0e                	jne    f0106249 <strtol+0x25>
		s++;
f010623b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010623e:	0f b6 02             	movzbl (%edx),%eax
f0106241:	3c 20                	cmp    $0x20,%al
f0106243:	74 f6                	je     f010623b <strtol+0x17>
f0106245:	3c 09                	cmp    $0x9,%al
f0106247:	74 f2                	je     f010623b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106249:	3c 2b                	cmp    $0x2b,%al
f010624b:	75 0a                	jne    f0106257 <strtol+0x33>
		s++;
f010624d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0106250:	bf 00 00 00 00       	mov    $0x0,%edi
f0106255:	eb 10                	jmp    f0106267 <strtol+0x43>
f0106257:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010625c:	3c 2d                	cmp    $0x2d,%al
f010625e:	75 07                	jne    f0106267 <strtol+0x43>
		s++, neg = 1;
f0106260:	83 c2 01             	add    $0x1,%edx
f0106263:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106267:	85 db                	test   %ebx,%ebx
f0106269:	0f 94 c0             	sete   %al
f010626c:	74 05                	je     f0106273 <strtol+0x4f>
f010626e:	83 fb 10             	cmp    $0x10,%ebx
f0106271:	75 15                	jne    f0106288 <strtol+0x64>
f0106273:	80 3a 30             	cmpb   $0x30,(%edx)
f0106276:	75 10                	jne    f0106288 <strtol+0x64>
f0106278:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f010627c:	75 0a                	jne    f0106288 <strtol+0x64>
		s += 2, base = 16;
f010627e:	83 c2 02             	add    $0x2,%edx
f0106281:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106286:	eb 13                	jmp    f010629b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
f0106288:	84 c0                	test   %al,%al
f010628a:	74 0f                	je     f010629b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010628c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106291:	80 3a 30             	cmpb   $0x30,(%edx)
f0106294:	75 05                	jne    f010629b <strtol+0x77>
		s++, base = 8;
f0106296:	83 c2 01             	add    $0x1,%edx
f0106299:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
f010629b:	b8 00 00 00 00       	mov    $0x0,%eax
f01062a0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01062a2:	0f b6 0a             	movzbl (%edx),%ecx
f01062a5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f01062a8:	80 fb 09             	cmp    $0x9,%bl
f01062ab:	77 08                	ja     f01062b5 <strtol+0x91>
			dig = *s - '0';
f01062ad:	0f be c9             	movsbl %cl,%ecx
f01062b0:	83 e9 30             	sub    $0x30,%ecx
f01062b3:	eb 1e                	jmp    f01062d3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
f01062b5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
f01062b8:	80 fb 19             	cmp    $0x19,%bl
f01062bb:	77 08                	ja     f01062c5 <strtol+0xa1>
			dig = *s - 'a' + 10;
f01062bd:	0f be c9             	movsbl %cl,%ecx
f01062c0:	83 e9 57             	sub    $0x57,%ecx
f01062c3:	eb 0e                	jmp    f01062d3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
f01062c5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
f01062c8:	80 fb 19             	cmp    $0x19,%bl
f01062cb:	77 14                	ja     f01062e1 <strtol+0xbd>
			dig = *s - 'A' + 10;
f01062cd:	0f be c9             	movsbl %cl,%ecx
f01062d0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f01062d3:	39 f1                	cmp    %esi,%ecx
f01062d5:	7d 0e                	jge    f01062e5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f01062d7:	83 c2 01             	add    $0x1,%edx
f01062da:	0f af c6             	imul   %esi,%eax
f01062dd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
f01062df:	eb c1                	jmp    f01062a2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
f01062e1:	89 c1                	mov    %eax,%ecx
f01062e3:	eb 02                	jmp    f01062e7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f01062e5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f01062e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01062eb:	74 05                	je     f01062f2 <strtol+0xce>
		*endptr = (char *) s;
f01062ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01062f0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f01062f2:	89 ca                	mov    %ecx,%edx
f01062f4:	f7 da                	neg    %edx
f01062f6:	85 ff                	test   %edi,%edi
f01062f8:	0f 45 c2             	cmovne %edx,%eax
}
f01062fb:	5b                   	pop    %ebx
f01062fc:	5e                   	pop    %esi
f01062fd:	5f                   	pop    %edi
f01062fe:	5d                   	pop    %ebp
f01062ff:	c3                   	ret    

f0106300 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106300:	fa                   	cli    

	xorw    %ax, %ax
f0106301:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106303:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106305:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106307:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106309:	0f 01 16             	lgdtl  (%esi)
f010630c:	74 70                	je     f010637e <mpentry_end+0x4>
	movl    %cr0, %eax
f010630e:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106311:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106315:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106318:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010631e:	08 00                	or     %al,(%eax)

f0106320 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106320:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106324:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106326:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106328:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f010632a:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f010632e:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106330:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106332:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl    %eax, %cr3
f0106337:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f010633a:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f010633d:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106342:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106345:	8b 25 84 5e 20 f0    	mov    0xf0205e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f010634b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106350:	b8 a8 00 10 f0       	mov    $0xf01000a8,%eax
	call    *%eax
f0106355:	ff d0                	call   *%eax

f0106357 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106357:	eb fe                	jmp    f0106357 <spin>
f0106359:	8d 76 00             	lea    0x0(%esi),%esi

f010635c <gdt>:
	...
f0106364:	ff                   	(bad)  
f0106365:	ff 00                	incl   (%eax)
f0106367:	00 00                	add    %al,(%eax)
f0106369:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106370:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0106374 <gdtdesc>:
f0106374:	17                   	pop    %ss
f0106375:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f010637a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f010637a:	90                   	nop
f010637b:	00 00                	add    %al,(%eax)
f010637d:	00 00                	add    %al,(%eax)
	...

f0106380 <sum>:
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
f0106380:	55                   	push   %ebp
f0106381:	89 e5                	mov    %esp,%ebp
f0106383:	56                   	push   %esi
f0106384:	53                   	push   %ebx
	int i, sum;

	sum = 0;
f0106385:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++)
f010638a:	85 d2                	test   %edx,%edx
f010638c:	7e 12                	jle    f01063a0 <sum+0x20>
f010638e:	b9 00 00 00 00       	mov    $0x0,%ecx
		sum += ((uint8_t *)addr)[i];
f0106393:	0f b6 34 08          	movzbl (%eax,%ecx,1),%esi
f0106397:	01 f3                	add    %esi,%ebx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106399:	83 c1 01             	add    $0x1,%ecx
f010639c:	39 d1                	cmp    %edx,%ecx
f010639e:	75 f3                	jne    f0106393 <sum+0x13>
		sum += ((uint8_t *)addr)[i];
	return sum;
}
f01063a0:	89 d8                	mov    %ebx,%eax
f01063a2:	5b                   	pop    %ebx
f01063a3:	5e                   	pop    %esi
f01063a4:	5d                   	pop    %ebp
f01063a5:	c3                   	ret    

f01063a6 <mpsearch1>:

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f01063a6:	55                   	push   %ebp
f01063a7:	89 e5                	mov    %esp,%ebp
f01063a9:	56                   	push   %esi
f01063aa:	53                   	push   %ebx
f01063ab:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01063ae:	8b 0d 88 5e 20 f0    	mov    0xf0205e88,%ecx
f01063b4:	89 c3                	mov    %eax,%ebx
f01063b6:	c1 eb 0c             	shr    $0xc,%ebx
f01063b9:	39 cb                	cmp    %ecx,%ebx
f01063bb:	72 20                	jb     f01063dd <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01063bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01063c1:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01063c8:	f0 
f01063c9:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f01063d0:	00 
f01063d1:	c7 04 24 5d 8c 10 f0 	movl   $0xf0108c5d,(%esp)
f01063d8:	e8 63 9c ff ff       	call   f0100040 <_panic>
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f01063dd:	8d 34 02             	lea    (%edx,%eax,1),%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01063e0:	89 f2                	mov    %esi,%edx
f01063e2:	c1 ea 0c             	shr    $0xc,%edx
f01063e5:	39 d1                	cmp    %edx,%ecx
f01063e7:	77 20                	ja     f0106409 <mpsearch1+0x63>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01063e9:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01063ed:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01063f4:	f0 
f01063f5:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f01063fc:	00 
f01063fd:	c7 04 24 5d 8c 10 f0 	movl   $0xf0108c5d,(%esp)
f0106404:	e8 37 9c ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106409:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f010640f:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0106415:	39 f3                	cmp    %esi,%ebx
f0106417:	73 3a                	jae    f0106453 <mpsearch1+0xad>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106419:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106420:	00 
f0106421:	c7 44 24 04 6d 8c 10 	movl   $0xf0108c6d,0x4(%esp)
f0106428:	f0 
f0106429:	89 1c 24             	mov    %ebx,(%esp)
f010642c:	e8 75 fd ff ff       	call   f01061a6 <memcmp>
f0106431:	85 c0                	test   %eax,%eax
f0106433:	75 10                	jne    f0106445 <mpsearch1+0x9f>
		    sum(mp, sizeof(*mp)) == 0)
f0106435:	ba 10 00 00 00       	mov    $0x10,%edx
f010643a:	89 d8                	mov    %ebx,%eax
f010643c:	e8 3f ff ff ff       	call   f0106380 <sum>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106441:	84 c0                	test   %al,%al
f0106443:	74 13                	je     f0106458 <mpsearch1+0xb2>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106445:	83 c3 10             	add    $0x10,%ebx
f0106448:	39 f3                	cmp    %esi,%ebx
f010644a:	72 cd                	jb     f0106419 <mpsearch1+0x73>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f010644c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106451:	eb 05                	jmp    f0106458 <mpsearch1+0xb2>
f0106453:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106458:	89 d8                	mov    %ebx,%eax
f010645a:	83 c4 10             	add    $0x10,%esp
f010645d:	5b                   	pop    %ebx
f010645e:	5e                   	pop    %esi
f010645f:	5d                   	pop    %ebp
f0106460:	c3                   	ret    

f0106461 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106461:	55                   	push   %ebp
f0106462:	89 e5                	mov    %esp,%ebp
f0106464:	57                   	push   %edi
f0106465:	56                   	push   %esi
f0106466:	53                   	push   %ebx
f0106467:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f010646a:	c7 05 c0 63 20 f0 20 	movl   $0xf0206020,0xf02063c0
f0106471:	60 20 f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106474:	83 3d 88 5e 20 f0 00 	cmpl   $0x0,0xf0205e88
f010647b:	75 24                	jne    f01064a1 <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010647d:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f0106484:	00 
f0106485:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f010648c:	f0 
f010648d:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f0106494:	00 
f0106495:	c7 04 24 5d 8c 10 f0 	movl   $0xf0108c5d,(%esp)
f010649c:	e8 9f 9b ff ff       	call   f0100040 <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01064a1:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01064a8:	85 c0                	test   %eax,%eax
f01064aa:	74 16                	je     f01064c2 <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f01064ac:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01064af:	ba 00 04 00 00       	mov    $0x400,%edx
f01064b4:	e8 ed fe ff ff       	call   f01063a6 <mpsearch1>
f01064b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064bc:	85 c0                	test   %eax,%eax
f01064be:	75 3c                	jne    f01064fc <mp_init+0x9b>
f01064c0:	eb 20                	jmp    f01064e2 <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01064c2:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01064c9:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01064cc:	2d 00 04 00 00       	sub    $0x400,%eax
f01064d1:	ba 00 04 00 00       	mov    $0x400,%edx
f01064d6:	e8 cb fe ff ff       	call   f01063a6 <mpsearch1>
f01064db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064de:	85 c0                	test   %eax,%eax
f01064e0:	75 1a                	jne    f01064fc <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f01064e2:	ba 00 00 01 00       	mov    $0x10000,%edx
f01064e7:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01064ec:	e8 b5 fe ff ff       	call   f01063a6 <mpsearch1>
f01064f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f01064f4:	85 c0                	test   %eax,%eax
f01064f6:	0f 84 24 02 00 00    	je     f0106720 <mp_init+0x2bf>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f01064fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01064ff:	8b 78 04             	mov    0x4(%eax),%edi
f0106502:	85 ff                	test   %edi,%edi
f0106504:	74 06                	je     f010650c <mp_init+0xab>
f0106506:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f010650a:	74 11                	je     f010651d <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f010650c:	c7 04 24 d0 8a 10 f0 	movl   $0xf0108ad0,(%esp)
f0106513:	e8 d2 dd ff ff       	call   f01042ea <cprintf>
f0106518:	e9 03 02 00 00       	jmp    f0106720 <mp_init+0x2bf>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010651d:	89 f8                	mov    %edi,%eax
f010651f:	c1 e8 0c             	shr    $0xc,%eax
f0106522:	3b 05 88 5e 20 f0    	cmp    0xf0205e88,%eax
f0106528:	72 20                	jb     f010654a <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010652a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010652e:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f0106535:	f0 
f0106536:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f010653d:	00 
f010653e:	c7 04 24 5d 8c 10 f0 	movl   $0xf0108c5d,(%esp)
f0106545:	e8 f6 9a ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f010654a:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106550:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106557:	00 
f0106558:	c7 44 24 04 72 8c 10 	movl   $0xf0108c72,0x4(%esp)
f010655f:	f0 
f0106560:	89 3c 24             	mov    %edi,(%esp)
f0106563:	e8 3e fc ff ff       	call   f01061a6 <memcmp>
f0106568:	85 c0                	test   %eax,%eax
f010656a:	74 11                	je     f010657d <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f010656c:	c7 04 24 00 8b 10 f0 	movl   $0xf0108b00,(%esp)
f0106573:	e8 72 dd ff ff       	call   f01042ea <cprintf>
f0106578:	e9 a3 01 00 00       	jmp    f0106720 <mp_init+0x2bf>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f010657d:	0f b7 5f 04          	movzwl 0x4(%edi),%ebx
f0106581:	0f b7 d3             	movzwl %bx,%edx
f0106584:	89 f8                	mov    %edi,%eax
f0106586:	e8 f5 fd ff ff       	call   f0106380 <sum>
f010658b:	84 c0                	test   %al,%al
f010658d:	74 11                	je     f01065a0 <mp_init+0x13f>
		cprintf("SMP: Bad MP configuration checksum\n");
f010658f:	c7 04 24 34 8b 10 f0 	movl   $0xf0108b34,(%esp)
f0106596:	e8 4f dd ff ff       	call   f01042ea <cprintf>
f010659b:	e9 80 01 00 00       	jmp    f0106720 <mp_init+0x2bf>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f01065a0:	0f b6 47 06          	movzbl 0x6(%edi),%eax
f01065a4:	3c 01                	cmp    $0x1,%al
f01065a6:	74 1c                	je     f01065c4 <mp_init+0x163>
f01065a8:	3c 04                	cmp    $0x4,%al
f01065aa:	74 18                	je     f01065c4 <mp_init+0x163>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f01065ac:	0f b6 c0             	movzbl %al,%eax
f01065af:	89 44 24 04          	mov    %eax,0x4(%esp)
f01065b3:	c7 04 24 58 8b 10 f0 	movl   $0xf0108b58,(%esp)
f01065ba:	e8 2b dd ff ff       	call   f01042ea <cprintf>
f01065bf:	e9 5c 01 00 00       	jmp    f0106720 <mp_init+0x2bf>
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f01065c4:	0f b7 57 28          	movzwl 0x28(%edi),%edx
f01065c8:	0f b7 db             	movzwl %bx,%ebx
f01065cb:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f01065ce:	e8 ad fd ff ff       	call   f0106380 <sum>
f01065d3:	3a 47 2a             	cmp    0x2a(%edi),%al
f01065d6:	74 11                	je     f01065e9 <mp_init+0x188>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f01065d8:	c7 04 24 78 8b 10 f0 	movl   $0xf0108b78,(%esp)
f01065df:	e8 06 dd ff ff       	call   f01042ea <cprintf>
f01065e4:	e9 37 01 00 00       	jmp    f0106720 <mp_init+0x2bf>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f01065e9:	85 ff                	test   %edi,%edi
f01065eb:	0f 84 2f 01 00 00    	je     f0106720 <mp_init+0x2bf>
		return;
	ismp = 1;
f01065f1:	c7 05 00 60 20 f0 01 	movl   $0x1,0xf0206000
f01065f8:	00 00 00 
	lapicaddr = conf->lapicaddr;
f01065fb:	8b 47 24             	mov    0x24(%edi),%eax
f01065fe:	a3 00 70 24 f0       	mov    %eax,0xf0247000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106603:	66 83 7f 22 00       	cmpw   $0x0,0x22(%edi)
f0106608:	0f 84 97 00 00 00    	je     f01066a5 <mp_init+0x244>
f010660e:	8d 77 2c             	lea    0x2c(%edi),%esi
f0106611:	bb 00 00 00 00       	mov    $0x0,%ebx
		switch (*p) {
f0106616:	0f b6 06             	movzbl (%esi),%eax
f0106619:	84 c0                	test   %al,%al
f010661b:	74 06                	je     f0106623 <mp_init+0x1c2>
f010661d:	3c 04                	cmp    $0x4,%al
f010661f:	77 54                	ja     f0106675 <mp_init+0x214>
f0106621:	eb 4d                	jmp    f0106670 <mp_init+0x20f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106623:	f6 46 03 02          	testb  $0x2,0x3(%esi)
f0106627:	74 11                	je     f010663a <mp_init+0x1d9>
				bootcpu = &cpus[ncpu];
f0106629:	6b 05 c4 63 20 f0 74 	imul   $0x74,0xf02063c4,%eax
f0106630:	05 20 60 20 f0       	add    $0xf0206020,%eax
f0106635:	a3 c0 63 20 f0       	mov    %eax,0xf02063c0
			if (ncpu < NCPU) {
f010663a:	a1 c4 63 20 f0       	mov    0xf02063c4,%eax
f010663f:	83 f8 07             	cmp    $0x7,%eax
f0106642:	7f 13                	jg     f0106657 <mp_init+0x1f6>
				cpus[ncpu].cpu_id = ncpu;
f0106644:	6b d0 74             	imul   $0x74,%eax,%edx
f0106647:	88 82 20 60 20 f0    	mov    %al,-0xfdf9fe0(%edx)
				ncpu++;
f010664d:	83 c0 01             	add    $0x1,%eax
f0106650:	a3 c4 63 20 f0       	mov    %eax,0xf02063c4
f0106655:	eb 14                	jmp    f010666b <mp_init+0x20a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106657:	0f b6 46 01          	movzbl 0x1(%esi),%eax
f010665b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010665f:	c7 04 24 a8 8b 10 f0 	movl   $0xf0108ba8,(%esp)
f0106666:	e8 7f dc ff ff       	call   f01042ea <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f010666b:	83 c6 14             	add    $0x14,%esi
			continue;
f010666e:	eb 26                	jmp    f0106696 <mp_init+0x235>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106670:	83 c6 08             	add    $0x8,%esi
			continue;
f0106673:	eb 21                	jmp    f0106696 <mp_init+0x235>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106675:	0f b6 c0             	movzbl %al,%eax
f0106678:	89 44 24 04          	mov    %eax,0x4(%esp)
f010667c:	c7 04 24 d0 8b 10 f0 	movl   $0xf0108bd0,(%esp)
f0106683:	e8 62 dc ff ff       	call   f01042ea <cprintf>
			ismp = 0;
f0106688:	c7 05 00 60 20 f0 00 	movl   $0x0,0xf0206000
f010668f:	00 00 00 
			i = conf->entry;
f0106692:	0f b7 5f 22          	movzwl 0x22(%edi),%ebx
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106696:	83 c3 01             	add    $0x1,%ebx
f0106699:	0f b7 47 22          	movzwl 0x22(%edi),%eax
f010669d:	39 d8                	cmp    %ebx,%eax
f010669f:	0f 87 71 ff ff ff    	ja     f0106616 <mp_init+0x1b5>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f01066a5:	a1 c0 63 20 f0       	mov    0xf02063c0,%eax
f01066aa:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f01066b1:	83 3d 00 60 20 f0 00 	cmpl   $0x0,0xf0206000
f01066b8:	75 22                	jne    f01066dc <mp_init+0x27b>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f01066ba:	c7 05 c4 63 20 f0 01 	movl   $0x1,0xf02063c4
f01066c1:	00 00 00 
		lapicaddr = 0;
f01066c4:	c7 05 00 70 24 f0 00 	movl   $0x0,0xf0247000
f01066cb:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f01066ce:	c7 04 24 f0 8b 10 f0 	movl   $0xf0108bf0,(%esp)
f01066d5:	e8 10 dc ff ff       	call   f01042ea <cprintf>
		return;
f01066da:	eb 44                	jmp    f0106720 <mp_init+0x2bf>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f01066dc:	8b 15 c4 63 20 f0    	mov    0xf02063c4,%edx
f01066e2:	89 54 24 08          	mov    %edx,0x8(%esp)
f01066e6:	0f b6 00             	movzbl (%eax),%eax
f01066e9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01066ed:	c7 04 24 77 8c 10 f0 	movl   $0xf0108c77,(%esp)
f01066f4:	e8 f1 db ff ff       	call   f01042ea <cprintf>

	if (mp->imcrp) {
f01066f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01066fc:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106700:	74 1e                	je     f0106720 <mp_init+0x2bf>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106702:	c7 04 24 1c 8c 10 f0 	movl   $0xf0108c1c,(%esp)
f0106709:	e8 dc db ff ff       	call   f01042ea <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010670e:	ba 22 00 00 00       	mov    $0x22,%edx
f0106713:	b8 70 00 00 00       	mov    $0x70,%eax
f0106718:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106719:	b2 23                	mov    $0x23,%dl
f010671b:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f010671c:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010671f:	ee                   	out    %al,(%dx)
	}
}
f0106720:	83 c4 2c             	add    $0x2c,%esp
f0106723:	5b                   	pop    %ebx
f0106724:	5e                   	pop    %esi
f0106725:	5f                   	pop    %edi
f0106726:	5d                   	pop    %ebp
f0106727:	c3                   	ret    

f0106728 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0106728:	55                   	push   %ebp
f0106729:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f010672b:	c1 e0 02             	shl    $0x2,%eax
f010672e:	03 05 04 70 24 f0    	add    0xf0247004,%eax
f0106734:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106736:	a1 04 70 24 f0       	mov    0xf0247004,%eax
f010673b:	8b 40 20             	mov    0x20(%eax),%eax
}
f010673e:	5d                   	pop    %ebp
f010673f:	c3                   	ret    

f0106740 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106740:	55                   	push   %ebp
f0106741:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106743:	8b 15 04 70 24 f0    	mov    0xf0247004,%edx
		return lapic[ID] >> 24;
	return 0;
f0106749:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
cpunum(void)
{
	if (lapic)
f010674e:	85 d2                	test   %edx,%edx
f0106750:	74 06                	je     f0106758 <cpunum+0x18>
		return lapic[ID] >> 24;
f0106752:	8b 42 20             	mov    0x20(%edx),%eax
f0106755:	c1 e8 18             	shr    $0x18,%eax
	return 0;
}
f0106758:	5d                   	pop    %ebp
f0106759:	c3                   	ret    

f010675a <lapic_init>:
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f010675a:	55                   	push   %ebp
f010675b:	89 e5                	mov    %esp,%ebp
f010675d:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
f0106760:	a1 00 70 24 f0       	mov    0xf0247000,%eax
f0106765:	85 c0                	test   %eax,%eax
f0106767:	0f 84 1c 01 00 00    	je     f0106889 <lapic_init+0x12f>
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f010676d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0106774:	00 
f0106775:	89 04 24             	mov    %eax,(%esp)
f0106778:	e8 5f b0 ff ff       	call   f01017dc <mmio_map_region>
f010677d:	a3 04 70 24 f0       	mov    %eax,0xf0247004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106782:	ba 27 01 00 00       	mov    $0x127,%edx
f0106787:	b8 3c 00 00 00       	mov    $0x3c,%eax
f010678c:	e8 97 ff ff ff       	call   f0106728 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0106791:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106796:	b8 f8 00 00 00       	mov    $0xf8,%eax
f010679b:	e8 88 ff ff ff       	call   f0106728 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01067a0:	ba 20 00 02 00       	mov    $0x20020,%edx
f01067a5:	b8 c8 00 00 00       	mov    $0xc8,%eax
f01067aa:	e8 79 ff ff ff       	call   f0106728 <lapicw>
	lapicw(TICR, 10000000); 
f01067af:	ba 80 96 98 00       	mov    $0x989680,%edx
f01067b4:	b8 e0 00 00 00       	mov    $0xe0,%eax
f01067b9:	e8 6a ff ff ff       	call   f0106728 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f01067be:	e8 7d ff ff ff       	call   f0106740 <cpunum>
f01067c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01067c6:	05 20 60 20 f0       	add    $0xf0206020,%eax
f01067cb:	39 05 c0 63 20 f0    	cmp    %eax,0xf02063c0
f01067d1:	74 0f                	je     f01067e2 <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f01067d3:	ba 00 00 01 00       	mov    $0x10000,%edx
f01067d8:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01067dd:	e8 46 ff ff ff       	call   f0106728 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f01067e2:	ba 00 00 01 00       	mov    $0x10000,%edx
f01067e7:	b8 d8 00 00 00       	mov    $0xd8,%eax
f01067ec:	e8 37 ff ff ff       	call   f0106728 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f01067f1:	a1 04 70 24 f0       	mov    0xf0247004,%eax
f01067f6:	8b 40 30             	mov    0x30(%eax),%eax
f01067f9:	c1 e8 10             	shr    $0x10,%eax
f01067fc:	3c 03                	cmp    $0x3,%al
f01067fe:	76 0f                	jbe    f010680f <lapic_init+0xb5>
		lapicw(PCINT, MASKED);
f0106800:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106805:	b8 d0 00 00 00       	mov    $0xd0,%eax
f010680a:	e8 19 ff ff ff       	call   f0106728 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f010680f:	ba 33 00 00 00       	mov    $0x33,%edx
f0106814:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106819:	e8 0a ff ff ff       	call   f0106728 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f010681e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106823:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106828:	e8 fb fe ff ff       	call   f0106728 <lapicw>
	lapicw(ESR, 0);
f010682d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106832:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106837:	e8 ec fe ff ff       	call   f0106728 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f010683c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106841:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106846:	e8 dd fe ff ff       	call   f0106728 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f010684b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106850:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106855:	e8 ce fe ff ff       	call   f0106728 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f010685a:	ba 00 85 08 00       	mov    $0x88500,%edx
f010685f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106864:	e8 bf fe ff ff       	call   f0106728 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106869:	8b 15 04 70 24 f0    	mov    0xf0247004,%edx
f010686f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106875:	f6 c4 10             	test   $0x10,%ah
f0106878:	75 f5                	jne    f010686f <lapic_init+0x115>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f010687a:	ba 00 00 00 00       	mov    $0x0,%edx
f010687f:	b8 20 00 00 00       	mov    $0x20,%eax
f0106884:	e8 9f fe ff ff       	call   f0106728 <lapicw>
}
f0106889:	c9                   	leave  
f010688a:	c3                   	ret    

f010688b <lapic_eoi>:
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f010688b:	55                   	push   %ebp
f010688c:	89 e5                	mov    %esp,%ebp
	if (lapic)
f010688e:	83 3d 04 70 24 f0 00 	cmpl   $0x0,0xf0247004
f0106895:	74 0f                	je     f01068a6 <lapic_eoi+0x1b>
		lapicw(EOI, 0);
f0106897:	ba 00 00 00 00       	mov    $0x0,%edx
f010689c:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01068a1:	e8 82 fe ff ff       	call   f0106728 <lapicw>
}
f01068a6:	5d                   	pop    %ebp
f01068a7:	c3                   	ret    

f01068a8 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f01068a8:	55                   	push   %ebp
f01068a9:	89 e5                	mov    %esp,%ebp
f01068ab:	56                   	push   %esi
f01068ac:	53                   	push   %ebx
f01068ad:	83 ec 10             	sub    $0x10,%esp
f01068b0:	8b 75 0c             	mov    0xc(%ebp),%esi
f01068b3:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
f01068b7:	ba 70 00 00 00       	mov    $0x70,%edx
f01068bc:	b8 0f 00 00 00       	mov    $0xf,%eax
f01068c1:	ee                   	out    %al,(%dx)
f01068c2:	b2 71                	mov    $0x71,%dl
f01068c4:	b8 0a 00 00 00       	mov    $0xa,%eax
f01068c9:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01068ca:	83 3d 88 5e 20 f0 00 	cmpl   $0x0,0xf0205e88
f01068d1:	75 24                	jne    f01068f7 <lapic_startap+0x4f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01068d3:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f01068da:	00 
f01068db:	c7 44 24 08 c8 6e 10 	movl   $0xf0106ec8,0x8(%esp)
f01068e2:	f0 
f01068e3:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
f01068ea:	00 
f01068eb:	c7 04 24 94 8c 10 f0 	movl   $0xf0108c94,(%esp)
f01068f2:	e8 49 97 ff ff       	call   f0100040 <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f01068f7:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01068fe:	00 00 
	wrv[1] = addr >> 4;
f0106900:	89 f0                	mov    %esi,%eax
f0106902:	c1 e8 04             	shr    $0x4,%eax
f0106905:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f010690b:	c1 e3 18             	shl    $0x18,%ebx
f010690e:	89 da                	mov    %ebx,%edx
f0106910:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106915:	e8 0e fe ff ff       	call   f0106728 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010691a:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010691f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106924:	e8 ff fd ff ff       	call   f0106728 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106929:	ba 00 85 00 00       	mov    $0x8500,%edx
f010692e:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106933:	e8 f0 fd ff ff       	call   f0106728 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106938:	c1 ee 0c             	shr    $0xc,%esi
f010693b:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0106941:	89 da                	mov    %ebx,%edx
f0106943:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106948:	e8 db fd ff ff       	call   f0106728 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010694d:	89 f2                	mov    %esi,%edx
f010694f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106954:	e8 cf fd ff ff       	call   f0106728 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0106959:	89 da                	mov    %ebx,%edx
f010695b:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106960:	e8 c3 fd ff ff       	call   f0106728 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106965:	89 f2                	mov    %esi,%edx
f0106967:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010696c:	e8 b7 fd ff ff       	call   f0106728 <lapicw>
		microdelay(200);
	}
}
f0106971:	83 c4 10             	add    $0x10,%esp
f0106974:	5b                   	pop    %ebx
f0106975:	5e                   	pop    %esi
f0106976:	5d                   	pop    %ebp
f0106977:	c3                   	ret    

f0106978 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106978:	55                   	push   %ebp
f0106979:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f010697b:	8b 55 08             	mov    0x8(%ebp),%edx
f010697e:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106984:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106989:	e8 9a fd ff ff       	call   f0106728 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f010698e:	8b 15 04 70 24 f0    	mov    0xf0247004,%edx
f0106994:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010699a:	f6 c4 10             	test   $0x10,%ah
f010699d:	75 f5                	jne    f0106994 <lapic_ipi+0x1c>
		;
}
f010699f:	5d                   	pop    %ebp
f01069a0:	c3                   	ret    
f01069a1:	00 00                	add    %al,(%eax)
	...

f01069a4 <holding>:
}

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
f01069a4:	55                   	push   %ebp
f01069a5:	89 e5                	mov    %esp,%ebp
f01069a7:	53                   	push   %ebx
f01069a8:	83 ec 04             	sub    $0x4,%esp
	return lock->locked && lock->cpu == thiscpu;
f01069ab:	ba 00 00 00 00       	mov    $0x0,%edx
f01069b0:	83 38 00             	cmpl   $0x0,(%eax)
f01069b3:	74 18                	je     f01069cd <holding+0x29>
f01069b5:	8b 58 08             	mov    0x8(%eax),%ebx
f01069b8:	e8 83 fd ff ff       	call   f0106740 <cpunum>
f01069bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01069c0:	05 20 60 20 f0       	add    $0xf0206020,%eax
		pcs[i] = 0;
}

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
f01069c5:	39 c3                	cmp    %eax,%ebx
{
	return lock->locked && lock->cpu == thiscpu;
f01069c7:	0f 94 c2             	sete   %dl
f01069ca:	0f b6 d2             	movzbl %dl,%edx
}
f01069cd:	89 d0                	mov    %edx,%eax
f01069cf:	83 c4 04             	add    $0x4,%esp
f01069d2:	5b                   	pop    %ebx
f01069d3:	5d                   	pop    %ebp
f01069d4:	c3                   	ret    

f01069d5 <__spin_initlock>:
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01069d5:	55                   	push   %ebp
f01069d6:	89 e5                	mov    %esp,%ebp
f01069d8:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01069db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01069e1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01069e4:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01069e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f01069ee:	5d                   	pop    %ebp
f01069ef:	c3                   	ret    

f01069f0 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f01069f0:	55                   	push   %ebp
f01069f1:	89 e5                	mov    %esp,%ebp
f01069f3:	53                   	push   %ebx
f01069f4:	83 ec 24             	sub    $0x24,%esp
f01069f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01069fa:	89 d8                	mov    %ebx,%eax
f01069fc:	e8 a3 ff ff ff       	call   f01069a4 <holding>
f0106a01:	85 c0                	test   %eax,%eax
f0106a03:	75 12                	jne    f0106a17 <spin_lock+0x27>
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106a05:	89 da                	mov    %ebx,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0106a07:	b0 01                	mov    $0x1,%al
f0106a09:	f0 87 03             	lock xchg %eax,(%ebx)
f0106a0c:	b9 01 00 00 00       	mov    $0x1,%ecx
f0106a11:	85 c0                	test   %eax,%eax
f0106a13:	75 2e                	jne    f0106a43 <spin_lock+0x53>
f0106a15:	eb 37                	jmp    f0106a4e <spin_lock+0x5e>
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106a17:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106a1a:	e8 21 fd ff ff       	call   f0106740 <cpunum>
f0106a1f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f0106a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106a27:	c7 44 24 08 a4 8c 10 	movl   $0xf0108ca4,0x8(%esp)
f0106a2e:	f0 
f0106a2f:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f0106a36:	00 
f0106a37:	c7 04 24 08 8d 10 f0 	movl   $0xf0108d08,(%esp)
f0106a3e:	e8 fd 95 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106a43:	f3 90                	pause  
f0106a45:	89 c8                	mov    %ecx,%eax
f0106a47:	f0 87 02             	lock xchg %eax,(%edx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106a4a:	85 c0                	test   %eax,%eax
f0106a4c:	75 f5                	jne    f0106a43 <spin_lock+0x53>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106a4e:	e8 ed fc ff ff       	call   f0106740 <cpunum>
f0106a53:	6b c0 74             	imul   $0x74,%eax,%eax
f0106a56:	05 20 60 20 f0       	add    $0xf0206020,%eax
f0106a5b:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0106a5e:	8d 4b 0c             	lea    0xc(%ebx),%ecx

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f0106a61:	89 e8                	mov    %ebp,%eax
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106a63:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f0106a68:	77 34                	ja     f0106a9e <spin_lock+0xae>
f0106a6a:	eb 2b                	jmp    f0106a97 <spin_lock+0xa7>
f0106a6c:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106a72:	76 12                	jbe    f0106a86 <spin_lock+0x96>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106a74:	8b 5a 04             	mov    0x4(%edx),%ebx
f0106a77:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106a7a:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106a7c:	83 c0 01             	add    $0x1,%eax
f0106a7f:	83 f8 0a             	cmp    $0xa,%eax
f0106a82:	75 e8                	jne    f0106a6c <spin_lock+0x7c>
f0106a84:	eb 27                	jmp    f0106aad <spin_lock+0xbd>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0106a86:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0106a8d:	83 c0 01             	add    $0x1,%eax
f0106a90:	83 f8 09             	cmp    $0x9,%eax
f0106a93:	7e f1                	jle    f0106a86 <spin_lock+0x96>
f0106a95:	eb 16                	jmp    f0106aad <spin_lock+0xbd>
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106a97:	b8 00 00 00 00       	mov    $0x0,%eax
f0106a9c:	eb e8                	jmp    f0106a86 <spin_lock+0x96>
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106a9e:	8b 50 04             	mov    0x4(%eax),%edx
f0106aa1:	89 53 0c             	mov    %edx,0xc(%ebx)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106aa4:	8b 10                	mov    (%eax),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106aa6:	b8 01 00 00 00       	mov    $0x1,%eax
f0106aab:	eb bf                	jmp    f0106a6c <spin_lock+0x7c>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f0106aad:	83 c4 24             	add    $0x24,%esp
f0106ab0:	5b                   	pop    %ebx
f0106ab1:	5d                   	pop    %ebp
f0106ab2:	c3                   	ret    

f0106ab3 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106ab3:	55                   	push   %ebp
f0106ab4:	89 e5                	mov    %esp,%ebp
f0106ab6:	83 ec 78             	sub    $0x78,%esp
f0106ab9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0106abc:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0106abf:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0106ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0106ac5:	89 d8                	mov    %ebx,%eax
f0106ac7:	e8 d8 fe ff ff       	call   f01069a4 <holding>
f0106acc:	85 c0                	test   %eax,%eax
f0106ace:	0f 85 d4 00 00 00    	jne    f0106ba8 <spin_unlock+0xf5>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106ad4:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0106adb:	00 
f0106adc:	8d 43 0c             	lea    0xc(%ebx),%eax
f0106adf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106ae3:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0106ae6:	89 04 24             	mov    %eax,(%esp)
f0106ae9:	e8 1e f6 ff ff       	call   f010610c <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106aee:	8b 43 08             	mov    0x8(%ebx),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106af1:	0f b6 30             	movzbl (%eax),%esi
f0106af4:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106af7:	e8 44 fc ff ff       	call   f0106740 <cpunum>
f0106afc:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106b00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0106b04:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b08:	c7 04 24 d0 8c 10 f0 	movl   $0xf0108cd0,(%esp)
f0106b0f:	e8 d6 d7 ff ff       	call   f01042ea <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106b14:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0106b17:	85 c0                	test   %eax,%eax
f0106b19:	74 71                	je     f0106b8c <spin_unlock+0xd9>
f0106b1b:	8d 5d a8             	lea    -0x58(%ebp),%ebx
#endif
}

// Release the lock.
void
spin_unlock(struct spinlock *lk)
f0106b1e:	8d 7d cc             	lea    -0x34(%ebp),%edi
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106b21:	8d 75 d0             	lea    -0x30(%ebp),%esi
f0106b24:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106b28:	89 04 24             	mov    %eax,(%esp)
f0106b2b:	e8 2e ea ff ff       	call   f010555e <debuginfo_eip>
f0106b30:	85 c0                	test   %eax,%eax
f0106b32:	78 39                	js     f0106b6d <spin_unlock+0xba>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f0106b34:	8b 03                	mov    (%ebx),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106b36:	89 c2                	mov    %eax,%edx
f0106b38:	2b 55 e0             	sub    -0x20(%ebp),%edx
f0106b3b:	89 54 24 18          	mov    %edx,0x18(%esp)
f0106b3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106b42:	89 54 24 14          	mov    %edx,0x14(%esp)
f0106b46:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0106b49:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106b4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106b50:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106b54:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0106b57:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b5f:	c7 04 24 18 8d 10 f0 	movl   $0xf0108d18,(%esp)
f0106b66:	e8 7f d7 ff ff       	call   f01042ea <cprintf>
f0106b6b:	eb 12                	jmp    f0106b7f <spin_unlock+0xcc>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f0106b6d:	8b 03                	mov    (%ebx),%eax
f0106b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b73:	c7 04 24 2f 8d 10 f0 	movl   $0xf0108d2f,(%esp)
f0106b7a:	e8 6b d7 ff ff       	call   f01042ea <cprintf>
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106b7f:	39 fb                	cmp    %edi,%ebx
f0106b81:	74 09                	je     f0106b8c <spin_unlock+0xd9>
f0106b83:	83 c3 04             	add    $0x4,%ebx
f0106b86:	8b 03                	mov    (%ebx),%eax
f0106b88:	85 c0                	test   %eax,%eax
f0106b8a:	75 98                	jne    f0106b24 <spin_unlock+0x71>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0106b8c:	c7 44 24 08 37 8d 10 	movl   $0xf0108d37,0x8(%esp)
f0106b93:	f0 
f0106b94:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0106b9b:	00 
f0106b9c:	c7 04 24 08 8d 10 f0 	movl   $0xf0108d08,(%esp)
f0106ba3:	e8 98 94 ff ff       	call   f0100040 <_panic>
	}

	lk->pcs[0] = 0;
f0106ba8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu = 0;
f0106baf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0106bb6:	b8 00 00 00 00       	mov    $0x0,%eax
f0106bbb:	f0 87 03             	lock xchg %eax,(%ebx)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0106bbe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0106bc1:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0106bc4:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0106bc7:	89 ec                	mov    %ebp,%esp
f0106bc9:	5d                   	pop    %ebp
f0106bca:	c3                   	ret    
f0106bcb:	00 00                	add    %al,(%eax)
f0106bcd:	00 00                	add    %al,(%eax)
	...

f0106bd0 <__udivdi3>:
f0106bd0:	83 ec 1c             	sub    $0x1c,%esp
f0106bd3:	89 7c 24 14          	mov    %edi,0x14(%esp)
f0106bd7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
f0106bdb:	8b 44 24 20          	mov    0x20(%esp),%eax
f0106bdf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0106be3:	89 74 24 10          	mov    %esi,0x10(%esp)
f0106be7:	8b 74 24 24          	mov    0x24(%esp),%esi
f0106beb:	85 ff                	test   %edi,%edi
f0106bed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
f0106bf1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106bf5:	89 cd                	mov    %ecx,%ebp
f0106bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106bfb:	75 33                	jne    f0106c30 <__udivdi3+0x60>
f0106bfd:	39 f1                	cmp    %esi,%ecx
f0106bff:	77 57                	ja     f0106c58 <__udivdi3+0x88>
f0106c01:	85 c9                	test   %ecx,%ecx
f0106c03:	75 0b                	jne    f0106c10 <__udivdi3+0x40>
f0106c05:	b8 01 00 00 00       	mov    $0x1,%eax
f0106c0a:	31 d2                	xor    %edx,%edx
f0106c0c:	f7 f1                	div    %ecx
f0106c0e:	89 c1                	mov    %eax,%ecx
f0106c10:	89 f0                	mov    %esi,%eax
f0106c12:	31 d2                	xor    %edx,%edx
f0106c14:	f7 f1                	div    %ecx
f0106c16:	89 c6                	mov    %eax,%esi
f0106c18:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106c1c:	f7 f1                	div    %ecx
f0106c1e:	89 f2                	mov    %esi,%edx
f0106c20:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106c24:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106c28:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106c2c:	83 c4 1c             	add    $0x1c,%esp
f0106c2f:	c3                   	ret    
f0106c30:	31 d2                	xor    %edx,%edx
f0106c32:	31 c0                	xor    %eax,%eax
f0106c34:	39 f7                	cmp    %esi,%edi
f0106c36:	77 e8                	ja     f0106c20 <__udivdi3+0x50>
f0106c38:	0f bd cf             	bsr    %edi,%ecx
f0106c3b:	83 f1 1f             	xor    $0x1f,%ecx
f0106c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106c42:	75 2c                	jne    f0106c70 <__udivdi3+0xa0>
f0106c44:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
f0106c48:	76 04                	jbe    f0106c4e <__udivdi3+0x7e>
f0106c4a:	39 f7                	cmp    %esi,%edi
f0106c4c:	73 d2                	jae    f0106c20 <__udivdi3+0x50>
f0106c4e:	31 d2                	xor    %edx,%edx
f0106c50:	b8 01 00 00 00       	mov    $0x1,%eax
f0106c55:	eb c9                	jmp    f0106c20 <__udivdi3+0x50>
f0106c57:	90                   	nop
f0106c58:	89 f2                	mov    %esi,%edx
f0106c5a:	f7 f1                	div    %ecx
f0106c5c:	31 d2                	xor    %edx,%edx
f0106c5e:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106c62:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106c66:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106c6a:	83 c4 1c             	add    $0x1c,%esp
f0106c6d:	c3                   	ret    
f0106c6e:	66 90                	xchg   %ax,%ax
f0106c70:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106c75:	b8 20 00 00 00       	mov    $0x20,%eax
f0106c7a:	89 ea                	mov    %ebp,%edx
f0106c7c:	2b 44 24 04          	sub    0x4(%esp),%eax
f0106c80:	d3 e7                	shl    %cl,%edi
f0106c82:	89 c1                	mov    %eax,%ecx
f0106c84:	d3 ea                	shr    %cl,%edx
f0106c86:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106c8b:	09 fa                	or     %edi,%edx
f0106c8d:	89 f7                	mov    %esi,%edi
f0106c8f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106c93:	89 f2                	mov    %esi,%edx
f0106c95:	8b 74 24 08          	mov    0x8(%esp),%esi
f0106c99:	d3 e5                	shl    %cl,%ebp
f0106c9b:	89 c1                	mov    %eax,%ecx
f0106c9d:	d3 ef                	shr    %cl,%edi
f0106c9f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106ca4:	d3 e2                	shl    %cl,%edx
f0106ca6:	89 c1                	mov    %eax,%ecx
f0106ca8:	d3 ee                	shr    %cl,%esi
f0106caa:	09 d6                	or     %edx,%esi
f0106cac:	89 fa                	mov    %edi,%edx
f0106cae:	89 f0                	mov    %esi,%eax
f0106cb0:	f7 74 24 0c          	divl   0xc(%esp)
f0106cb4:	89 d7                	mov    %edx,%edi
f0106cb6:	89 c6                	mov    %eax,%esi
f0106cb8:	f7 e5                	mul    %ebp
f0106cba:	39 d7                	cmp    %edx,%edi
f0106cbc:	72 22                	jb     f0106ce0 <__udivdi3+0x110>
f0106cbe:	8b 6c 24 08          	mov    0x8(%esp),%ebp
f0106cc2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106cc7:	d3 e5                	shl    %cl,%ebp
f0106cc9:	39 c5                	cmp    %eax,%ebp
f0106ccb:	73 04                	jae    f0106cd1 <__udivdi3+0x101>
f0106ccd:	39 d7                	cmp    %edx,%edi
f0106ccf:	74 0f                	je     f0106ce0 <__udivdi3+0x110>
f0106cd1:	89 f0                	mov    %esi,%eax
f0106cd3:	31 d2                	xor    %edx,%edx
f0106cd5:	e9 46 ff ff ff       	jmp    f0106c20 <__udivdi3+0x50>
f0106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106ce0:	8d 46 ff             	lea    -0x1(%esi),%eax
f0106ce3:	31 d2                	xor    %edx,%edx
f0106ce5:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106ce9:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106ced:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106cf1:	83 c4 1c             	add    $0x1c,%esp
f0106cf4:	c3                   	ret    
	...

f0106d00 <__umoddi3>:
f0106d00:	83 ec 1c             	sub    $0x1c,%esp
f0106d03:	89 6c 24 18          	mov    %ebp,0x18(%esp)
f0106d07:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
f0106d0b:	8b 44 24 20          	mov    0x20(%esp),%eax
f0106d0f:	89 74 24 10          	mov    %esi,0x10(%esp)
f0106d13:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0106d17:	8b 74 24 24          	mov    0x24(%esp),%esi
f0106d1b:	85 ed                	test   %ebp,%ebp
f0106d1d:	89 7c 24 14          	mov    %edi,0x14(%esp)
f0106d21:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106d25:	89 cf                	mov    %ecx,%edi
f0106d27:	89 04 24             	mov    %eax,(%esp)
f0106d2a:	89 f2                	mov    %esi,%edx
f0106d2c:	75 1a                	jne    f0106d48 <__umoddi3+0x48>
f0106d2e:	39 f1                	cmp    %esi,%ecx
f0106d30:	76 4e                	jbe    f0106d80 <__umoddi3+0x80>
f0106d32:	f7 f1                	div    %ecx
f0106d34:	89 d0                	mov    %edx,%eax
f0106d36:	31 d2                	xor    %edx,%edx
f0106d38:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106d3c:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106d40:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106d44:	83 c4 1c             	add    $0x1c,%esp
f0106d47:	c3                   	ret    
f0106d48:	39 f5                	cmp    %esi,%ebp
f0106d4a:	77 54                	ja     f0106da0 <__umoddi3+0xa0>
f0106d4c:	0f bd c5             	bsr    %ebp,%eax
f0106d4f:	83 f0 1f             	xor    $0x1f,%eax
f0106d52:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d56:	75 60                	jne    f0106db8 <__umoddi3+0xb8>
f0106d58:	3b 0c 24             	cmp    (%esp),%ecx
f0106d5b:	0f 87 07 01 00 00    	ja     f0106e68 <__umoddi3+0x168>
f0106d61:	89 f2                	mov    %esi,%edx
f0106d63:	8b 34 24             	mov    (%esp),%esi
f0106d66:	29 ce                	sub    %ecx,%esi
f0106d68:	19 ea                	sbb    %ebp,%edx
f0106d6a:	89 34 24             	mov    %esi,(%esp)
f0106d6d:	8b 04 24             	mov    (%esp),%eax
f0106d70:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106d74:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106d78:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106d7c:	83 c4 1c             	add    $0x1c,%esp
f0106d7f:	c3                   	ret    
f0106d80:	85 c9                	test   %ecx,%ecx
f0106d82:	75 0b                	jne    f0106d8f <__umoddi3+0x8f>
f0106d84:	b8 01 00 00 00       	mov    $0x1,%eax
f0106d89:	31 d2                	xor    %edx,%edx
f0106d8b:	f7 f1                	div    %ecx
f0106d8d:	89 c1                	mov    %eax,%ecx
f0106d8f:	89 f0                	mov    %esi,%eax
f0106d91:	31 d2                	xor    %edx,%edx
f0106d93:	f7 f1                	div    %ecx
f0106d95:	8b 04 24             	mov    (%esp),%eax
f0106d98:	f7 f1                	div    %ecx
f0106d9a:	eb 98                	jmp    f0106d34 <__umoddi3+0x34>
f0106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106da0:	89 f2                	mov    %esi,%edx
f0106da2:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106da6:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106daa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106dae:	83 c4 1c             	add    $0x1c,%esp
f0106db1:	c3                   	ret    
f0106db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106db8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106dbd:	89 e8                	mov    %ebp,%eax
f0106dbf:	bd 20 00 00 00       	mov    $0x20,%ebp
f0106dc4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
f0106dc8:	89 fa                	mov    %edi,%edx
f0106dca:	d3 e0                	shl    %cl,%eax
f0106dcc:	89 e9                	mov    %ebp,%ecx
f0106dce:	d3 ea                	shr    %cl,%edx
f0106dd0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106dd5:	09 c2                	or     %eax,%edx
f0106dd7:	8b 44 24 08          	mov    0x8(%esp),%eax
f0106ddb:	89 14 24             	mov    %edx,(%esp)
f0106dde:	89 f2                	mov    %esi,%edx
f0106de0:	d3 e7                	shl    %cl,%edi
f0106de2:	89 e9                	mov    %ebp,%ecx
f0106de4:	d3 ea                	shr    %cl,%edx
f0106de6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106deb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106def:	d3 e6                	shl    %cl,%esi
f0106df1:	89 e9                	mov    %ebp,%ecx
f0106df3:	d3 e8                	shr    %cl,%eax
f0106df5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106dfa:	09 f0                	or     %esi,%eax
f0106dfc:	8b 74 24 08          	mov    0x8(%esp),%esi
f0106e00:	f7 34 24             	divl   (%esp)
f0106e03:	d3 e6                	shl    %cl,%esi
f0106e05:	89 74 24 08          	mov    %esi,0x8(%esp)
f0106e09:	89 d6                	mov    %edx,%esi
f0106e0b:	f7 e7                	mul    %edi
f0106e0d:	39 d6                	cmp    %edx,%esi
f0106e0f:	89 c1                	mov    %eax,%ecx
f0106e11:	89 d7                	mov    %edx,%edi
f0106e13:	72 3f                	jb     f0106e54 <__umoddi3+0x154>
f0106e15:	39 44 24 08          	cmp    %eax,0x8(%esp)
f0106e19:	72 35                	jb     f0106e50 <__umoddi3+0x150>
f0106e1b:	8b 44 24 08          	mov    0x8(%esp),%eax
f0106e1f:	29 c8                	sub    %ecx,%eax
f0106e21:	19 fe                	sbb    %edi,%esi
f0106e23:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106e28:	89 f2                	mov    %esi,%edx
f0106e2a:	d3 e8                	shr    %cl,%eax
f0106e2c:	89 e9                	mov    %ebp,%ecx
f0106e2e:	d3 e2                	shl    %cl,%edx
f0106e30:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106e35:	09 d0                	or     %edx,%eax
f0106e37:	89 f2                	mov    %esi,%edx
f0106e39:	d3 ea                	shr    %cl,%edx
f0106e3b:	8b 74 24 10          	mov    0x10(%esp),%esi
f0106e3f:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0106e43:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0106e47:	83 c4 1c             	add    $0x1c,%esp
f0106e4a:	c3                   	ret    
f0106e4b:	90                   	nop
f0106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106e50:	39 d6                	cmp    %edx,%esi
f0106e52:	75 c7                	jne    f0106e1b <__umoddi3+0x11b>
f0106e54:	89 d7                	mov    %edx,%edi
f0106e56:	89 c1                	mov    %eax,%ecx
f0106e58:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
f0106e5c:	1b 3c 24             	sbb    (%esp),%edi
f0106e5f:	eb ba                	jmp    f0106e1b <__umoddi3+0x11b>
f0106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106e68:	39 f5                	cmp    %esi,%ebp
f0106e6a:	0f 82 f1 fe ff ff    	jb     f0106d61 <__umoddi3+0x61>
f0106e70:	e9 f8 fe ff ff       	jmp    f0106d6d <__umoddi3+0x6d>
