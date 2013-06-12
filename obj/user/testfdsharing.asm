
obj/user/testfdsharing.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 eb 01 00 00       	call   80021c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  80004c:	e8 8b 1c 00 00       	call   801cdc <open>
  800051:	89 c3                	mov    %eax,%ebx
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("open motd: %e", fd);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 25 28 80 	movl   $0x802825,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  800072:	e8 11 02 00 00       	call   800288 <_panic>
	seek(fd, 0);
  800077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007e:	00 
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 52 19 00 00       	call   8019d9 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800087:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 20 42 80 	movl   $0x804220,0x4(%esp)
  800096:	00 
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 5f 18 00 00       	call   8018fe <readn>
  80009f:	89 c7                	mov    %eax,%edi
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	7f 20                	jg     8000c5 <umain+0x91>
		panic("readn: %e", n);
  8000a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a9:	c7 44 24 08 48 28 80 	movl   $0x802848,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b8:	00 
  8000b9:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  8000c0:	e8 c3 01 00 00       	call   800288 <_panic>

	if ((r = fork()) < 0)
  8000c5:	e8 99 11 00 00       	call   801263 <fork>
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	79 20                	jns    8000f0 <umain+0xbc>
		panic("fork: %e", r);
  8000d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d4:	c7 44 24 08 15 2e 80 	movl   $0x802e15,0x8(%esp)
  8000db:	00 
  8000dc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e3:	00 
  8000e4:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  8000eb:	e8 98 01 00 00       	call   800288 <_panic>
	if (r == 0) {
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 85 bd 00 00 00    	jne    8001b5 <umain+0x181>
		seek(fd, 0);
  8000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ff:	00 
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 d1 18 00 00       	call   8019d9 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800108:	c7 04 24 88 28 80 00 	movl   $0x802888,(%esp)
  80010f:	e8 6f 02 00 00       	call   800383 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800114:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011b:	00 
  80011c:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800123:	00 
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 d2 17 00 00       	call   8018fe <readn>
  80012c:	39 f8                	cmp    %edi,%eax
  80012e:	74 24                	je     800154 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  800130:	89 44 24 10          	mov    %eax,0x10(%esp)
  800134:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800138:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  80013f:	00 
  800140:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800147:	00 
  800148:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  80014f:	e8 34 01 00 00       	call   800288 <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800154:	89 44 24 08          	mov    %eax,0x8(%esp)
  800158:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 20 42 80 00 	movl   $0x804220,(%esp)
  800167:	e8 ba 0a 00 00       	call   800c26 <memcmp>
  80016c:	85 c0                	test   %eax,%eax
  80016e:	74 1c                	je     80018c <umain+0x158>
			panic("read in parent got different bytes from read in child");
  800170:	c7 44 24 08 f8 28 80 	movl   $0x8028f8,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  800187:	e8 fc 00 00 00       	call   800288 <_panic>
		cprintf("read in child succeeded\n");
  80018c:	c7 04 24 52 28 80 00 	movl   $0x802852,(%esp)
  800193:	e8 eb 01 00 00       	call   800383 <cprintf>
		seek(fd, 0);
  800198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019f:	00 
  8001a0:	89 1c 24             	mov    %ebx,(%esp)
  8001a3:	e8 31 18 00 00       	call   8019d9 <seek>
		close(fd);
  8001a8:	89 1c 24             	mov    %ebx,(%esp)
  8001ab:	e8 4d 15 00 00       	call   8016fd <close>
		exit();
  8001b0:	e8 b7 00 00 00       	call   80026c <exit>
	}
	wait(r);
  8001b5:	89 34 24             	mov    %esi,(%esp)
  8001b8:	e8 87 1f 00 00       	call   802144 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c4:	00 
  8001c5:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  8001cc:	00 
  8001cd:	89 1c 24             	mov    %ebx,(%esp)
  8001d0:	e8 29 17 00 00       	call   8018fe <readn>
  8001d5:	39 f8                	cmp    %edi,%eax
  8001d7:	74 24                	je     8001fd <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e1:	c7 44 24 08 30 29 80 	movl   $0x802930,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  8001f8:	e8 8b 00 00 00       	call   800288 <_panic>
	cprintf("read in parent succeeded\n");
  8001fd:	c7 04 24 6b 28 80 00 	movl   $0x80286b,(%esp)
  800204:	e8 7a 01 00 00       	call   800383 <cprintf>
	close(fd);
  800209:	89 1c 24             	mov    %ebx,(%esp)
  80020c:	e8 ec 14 00 00       	call   8016fd <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800211:	cc                   	int3   

	breakpoint();
}
  800212:	83 c4 2c             	add    $0x2c,%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
	...

0080021c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 18             	sub    $0x18,%esp
  800222:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800225:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800228:	8b 75 08             	mov    0x8(%ebp),%esi
  80022b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80022e:	e8 09 0c 00 00       	call   800e3c <sys_getenvid>
  800233:	25 ff 03 00 00       	and    $0x3ff,%eax
  800238:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80023b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800240:	a3 20 44 80 00       	mov    %eax,0x804420
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800245:	85 f6                	test   %esi,%esi
  800247:	7e 07                	jle    800250 <libmain+0x34>
		binaryname = argv[0];
  800249:	8b 03                	mov    (%ebx),%eax
  80024b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800254:	89 34 24             	mov    %esi,(%esp)
  800257:	e8 d8 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80025c:	e8 0b 00 00 00       	call   80026c <exit>
}
  800261:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800264:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800267:	89 ec                	mov    %ebp,%esp
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
	...

0080026c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800272:	e8 b7 14 00 00       	call   80172e <close_all>
	sys_env_destroy(0);
  800277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80027e:	e8 5c 0b 00 00       	call   800ddf <sys_env_destroy>
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    
  800285:	00 00                	add    %al,(%eax)
	...

00800288 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	56                   	push   %esi
  80028c:	53                   	push   %ebx
  80028d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800290:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800293:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800299:	e8 9e 0b 00 00       	call   800e3c <sys_getenvid>
  80029e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b4:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  8002bb:	e8 c3 00 00 00       	call   800383 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 53 00 00 00       	call   800322 <vcprintf>
	cprintf("\n");
  8002cf:	c7 04 24 69 28 80 00 	movl   $0x802869,(%esp)
  8002d6:	e8 a8 00 00 00       	call   800383 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002db:	cc                   	int3   
  8002dc:	eb fd                	jmp    8002db <_panic+0x53>
	...

008002e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 14             	sub    $0x14,%esp
  8002e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ea:	8b 03                	mov    (%ebx),%eax
  8002ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ef:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002f3:	83 c0 01             	add    $0x1,%eax
  8002f6:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fd:	75 19                	jne    800318 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ff:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800306:	00 
  800307:	8d 43 08             	lea    0x8(%ebx),%eax
  80030a:	89 04 24             	mov    %eax,(%esp)
  80030d:	e8 6e 0a 00 00       	call   800d80 <sys_cputs>
		b->idx = 0;
  800312:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800318:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031c:	83 c4 14             	add    $0x14,%esp
  80031f:	5b                   	pop    %ebx
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80032b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800332:	00 00 00 
	b.cnt = 0;
  800335:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800342:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800353:	89 44 24 04          	mov    %eax,0x4(%esp)
  800357:	c7 04 24 e0 02 80 00 	movl   $0x8002e0,(%esp)
  80035e:	e8 97 01 00 00       	call   8004fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800363:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800373:	89 04 24             	mov    %eax,(%esp)
  800376:	e8 05 0a 00 00       	call   800d80 <sys_cputs>

	return b.cnt;
}
  80037b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	89 04 24             	mov    %eax,(%esp)
  800396:	e8 87 ff ff ff       	call   800322 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    
  80039d:	00 00                	add    %al,(%eax)
	...

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003c8:	72 11                	jb     8003db <printnum+0x3b>
  8003ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003d0:	76 09                	jbe    8003db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	83 eb 01             	sub    $0x1,%ebx
  8003d5:	85 db                	test   %ebx,%ebx
  8003d7:	7f 51                	jg     80042a <printnum+0x8a>
  8003d9:	eb 5e                	jmp    800439 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8003df:	83 eb 01             	sub    $0x1,%ebx
  8003e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8003f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8003f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003fc:	00 
  8003fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800400:	89 04 24             	mov    %eax,(%esp)
  800403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	e8 51 21 00 00       	call   802560 <__udivdi3>
  80040f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800413:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800417:	89 04 24             	mov    %eax,(%esp)
  80041a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80041e:	89 fa                	mov    %edi,%edx
  800420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800423:	e8 78 ff ff ff       	call   8003a0 <printnum>
  800428:	eb 0f                	jmp    800439 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80042a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042e:	89 34 24             	mov    %esi,(%esp)
  800431:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800434:	83 eb 01             	sub    $0x1,%ebx
  800437:	75 f1                	jne    80042a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800439:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800441:	8b 45 10             	mov    0x10(%ebp),%eax
  800444:	89 44 24 08          	mov    %eax,0x8(%esp)
  800448:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80044f:	00 
  800450:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800453:	89 04 24             	mov    %eax,(%esp)
  800456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045d:	e8 2e 22 00 00       	call   802690 <__umoddi3>
  800462:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800466:	0f be 80 83 29 80 00 	movsbl 0x802983(%eax),%eax
  80046d:	89 04 24             	mov    %eax,(%esp)
  800470:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800473:	83 c4 3c             	add    $0x3c,%esp
  800476:	5b                   	pop    %ebx
  800477:	5e                   	pop    %esi
  800478:	5f                   	pop    %edi
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    

0080047b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047e:	83 fa 01             	cmp    $0x1,%edx
  800481:	7e 0e                	jle    800491 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800483:	8b 10                	mov    (%eax),%edx
  800485:	8d 4a 08             	lea    0x8(%edx),%ecx
  800488:	89 08                	mov    %ecx,(%eax)
  80048a:	8b 02                	mov    (%edx),%eax
  80048c:	8b 52 04             	mov    0x4(%edx),%edx
  80048f:	eb 22                	jmp    8004b3 <getuint+0x38>
	else if (lflag)
  800491:	85 d2                	test   %edx,%edx
  800493:	74 10                	je     8004a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800495:	8b 10                	mov    (%eax),%edx
  800497:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049a:	89 08                	mov    %ecx,(%eax)
  80049c:	8b 02                	mov    (%edx),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 0e                	jmp    8004b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 10                	mov    (%eax),%edx
  8004a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004aa:	89 08                	mov    %ecx,(%eax)
  8004ac:	8b 02                	mov    (%edx),%eax
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004bf:	8b 10                	mov    (%eax),%edx
  8004c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c4:	73 0a                	jae    8004d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c9:	88 0a                	mov    %cl,(%edx)
  8004cb:	83 c2 01             	add    $0x1,%edx
  8004ce:	89 10                	mov    %edx,(%eax)
}
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    

008004d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	e8 02 00 00 00       	call   8004fa <vprintfmt>
	va_end(ap);
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
  800500:	83 ec 4c             	sub    $0x4c,%esp
  800503:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800506:	8b 75 10             	mov    0x10(%ebp),%esi
  800509:	eb 12                	jmp    80051d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80050b:	85 c0                	test   %eax,%eax
  80050d:	0f 84 a9 03 00 00    	je     8008bc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800513:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800517:	89 04 24             	mov    %eax,(%esp)
  80051a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051d:	0f b6 06             	movzbl (%esi),%eax
  800520:	83 c6 01             	add    $0x1,%esi
  800523:	83 f8 25             	cmp    $0x25,%eax
  800526:	75 e3                	jne    80050b <vprintfmt+0x11>
  800528:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80052c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800533:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800538:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80053f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800544:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800547:	eb 2b                	jmp    800574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800549:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80054c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800550:	eb 22                	jmp    800574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800555:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800559:	eb 19                	jmp    800574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80055e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800565:	eb 0d                	jmp    800574 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800574:	0f b6 06             	movzbl (%esi),%eax
  800577:	0f b6 d0             	movzbl %al,%edx
  80057a:	8d 7e 01             	lea    0x1(%esi),%edi
  80057d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800580:	83 e8 23             	sub    $0x23,%eax
  800583:	3c 55                	cmp    $0x55,%al
  800585:	0f 87 0b 03 00 00    	ja     800896 <vprintfmt+0x39c>
  80058b:	0f b6 c0             	movzbl %al,%eax
  80058e:	ff 24 85 c0 2a 80 00 	jmp    *0x802ac0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800595:	83 ea 30             	sub    $0x30,%edx
  800598:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80059b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80059f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8005a5:	83 fa 09             	cmp    $0x9,%edx
  8005a8:	77 4a                	ja     8005f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005b0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8005b3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8005b7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ba:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005bd:	83 fa 09             	cmp    $0x9,%edx
  8005c0:	76 eb                	jbe    8005ad <vprintfmt+0xb3>
  8005c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005c5:	eb 2d                	jmp    8005f4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005d8:	eb 1a                	jmp    8005f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8005dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e1:	79 91                	jns    800574 <vprintfmt+0x7a>
  8005e3:	e9 73 ff ff ff       	jmp    80055b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f2:	eb 80                	jmp    800574 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8005f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f8:	0f 89 76 ff ff ff    	jns    800574 <vprintfmt+0x7a>
  8005fe:	e9 64 ff ff ff       	jmp    800567 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800603:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800606:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800609:	e9 66 ff ff ff       	jmp    800574 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	89 55 14             	mov    %edx,0x14(%ebp)
  800617:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 04 24             	mov    %eax,(%esp)
  800620:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800623:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800626:	e9 f2 fe ff ff       	jmp    80051d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 50 04             	lea    0x4(%eax),%edx
  800631:	89 55 14             	mov    %edx,0x14(%ebp)
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 c2                	mov    %eax,%edx
  800638:	c1 fa 1f             	sar    $0x1f,%edx
  80063b:	31 d0                	xor    %edx,%eax
  80063d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063f:	83 f8 0f             	cmp    $0xf,%eax
  800642:	7f 0b                	jg     80064f <vprintfmt+0x155>
  800644:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  80064b:	85 d2                	test   %edx,%edx
  80064d:	75 23                	jne    800672 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80064f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800653:	c7 44 24 08 9b 29 80 	movl   $0x80299b,0x8(%esp)
  80065a:	00 
  80065b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80065f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800662:	89 3c 24             	mov    %edi,(%esp)
  800665:	e8 68 fe ff ff       	call   8004d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80066d:	e9 ab fe ff ff       	jmp    80051d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800672:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800676:	c7 44 24 08 f5 2e 80 	movl   $0x802ef5,0x8(%esp)
  80067d:	00 
  80067e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800682:	8b 7d 08             	mov    0x8(%ebp),%edi
  800685:	89 3c 24             	mov    %edi,(%esp)
  800688:	e8 45 fe ff ff       	call   8004d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800690:	e9 88 fe ff ff       	jmp    80051d <vprintfmt+0x23>
  800695:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8006a9:	85 f6                	test   %esi,%esi
  8006ab:	ba 94 29 80 00       	mov    $0x802994,%edx
  8006b0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8006b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b7:	7e 06                	jle    8006bf <vprintfmt+0x1c5>
  8006b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8006bd:	75 10                	jne    8006cf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bf:	0f be 06             	movsbl (%esi),%eax
  8006c2:	83 c6 01             	add    $0x1,%esi
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	0f 85 86 00 00 00    	jne    800753 <vprintfmt+0x259>
  8006cd:	eb 76                	jmp    800745 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d3:	89 34 24             	mov    %esi,(%esp)
  8006d6:	e8 90 02 00 00       	call   80096b <strnlen>
  8006db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006de:	29 c2                	sub    %eax,%edx
  8006e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e3:	85 d2                	test   %edx,%edx
  8006e5:	7e d8                	jle    8006bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006e7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8006ee:	89 d6                	mov    %edx,%esi
  8006f0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8006f3:	89 c7                	mov    %eax,%edi
  8006f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f9:	89 3c 24             	mov    %edi,(%esp)
  8006fc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ff:	83 ee 01             	sub    $0x1,%esi
  800702:	75 f1                	jne    8006f5 <vprintfmt+0x1fb>
  800704:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800707:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80070a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80070d:	eb b0                	jmp    8006bf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80070f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800713:	74 18                	je     80072d <vprintfmt+0x233>
  800715:	8d 50 e0             	lea    -0x20(%eax),%edx
  800718:	83 fa 5e             	cmp    $0x5e,%edx
  80071b:	76 10                	jbe    80072d <vprintfmt+0x233>
					putch('?', putdat);
  80071d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800721:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800728:	ff 55 08             	call   *0x8(%ebp)
  80072b:	eb 0a                	jmp    800737 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80072d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800731:	89 04 24             	mov    %eax,(%esp)
  800734:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800737:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80073b:	0f be 06             	movsbl (%esi),%eax
  80073e:	83 c6 01             	add    $0x1,%esi
  800741:	85 c0                	test   %eax,%eax
  800743:	75 0e                	jne    800753 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800745:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074c:	7f 16                	jg     800764 <vprintfmt+0x26a>
  80074e:	e9 ca fd ff ff       	jmp    80051d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800753:	85 ff                	test   %edi,%edi
  800755:	78 b8                	js     80070f <vprintfmt+0x215>
  800757:	83 ef 01             	sub    $0x1,%edi
  80075a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800760:	79 ad                	jns    80070f <vprintfmt+0x215>
  800762:	eb e1                	jmp    800745 <vprintfmt+0x24b>
  800764:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800767:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80076a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80076e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800775:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800777:	83 ee 01             	sub    $0x1,%esi
  80077a:	75 ee                	jne    80076a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80077f:	e9 99 fd ff ff       	jmp    80051d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800784:	83 f9 01             	cmp    $0x1,%ecx
  800787:	7e 10                	jle    800799 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 50 08             	lea    0x8(%eax),%edx
  80078f:	89 55 14             	mov    %edx,0x14(%ebp)
  800792:	8b 30                	mov    (%eax),%esi
  800794:	8b 78 04             	mov    0x4(%eax),%edi
  800797:	eb 26                	jmp    8007bf <vprintfmt+0x2c5>
	else if (lflag)
  800799:	85 c9                	test   %ecx,%ecx
  80079b:	74 12                	je     8007af <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 50 04             	lea    0x4(%eax),%edx
  8007a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a6:	8b 30                	mov    (%eax),%esi
  8007a8:	89 f7                	mov    %esi,%edi
  8007aa:	c1 ff 1f             	sar    $0x1f,%edi
  8007ad:	eb 10                	jmp    8007bf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8d 50 04             	lea    0x4(%eax),%edx
  8007b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b8:	8b 30                	mov    (%eax),%esi
  8007ba:	89 f7                	mov    %esi,%edi
  8007bc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007c4:	85 ff                	test   %edi,%edi
  8007c6:	0f 89 8c 00 00 00    	jns    800858 <vprintfmt+0x35e>
				putch('-', putdat);
  8007cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007d7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007da:	f7 de                	neg    %esi
  8007dc:	83 d7 00             	adc    $0x0,%edi
  8007df:	f7 df                	neg    %edi
			}
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e6:	eb 70                	jmp    800858 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e8:	89 ca                	mov    %ecx,%edx
  8007ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ed:	e8 89 fc ff ff       	call   80047b <getuint>
  8007f2:	89 c6                	mov    %eax,%esi
  8007f4:	89 d7                	mov    %edx,%edi
			base = 10;
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007fb:	eb 5b                	jmp    800858 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007fd:	89 ca                	mov    %ecx,%edx
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	e8 74 fc ff ff       	call   80047b <getuint>
  800807:	89 c6                	mov    %eax,%esi
  800809:	89 d7                	mov    %edx,%edi
			base = 8;
  80080b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800810:	eb 46                	jmp    800858 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800816:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80081d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800824:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80082b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800837:	8b 30                	mov    (%eax),%esi
  800839:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80083e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800843:	eb 13                	jmp    800858 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800845:	89 ca                	mov    %ecx,%edx
  800847:	8d 45 14             	lea    0x14(%ebp),%eax
  80084a:	e8 2c fc ff ff       	call   80047b <getuint>
  80084f:	89 c6                	mov    %eax,%esi
  800851:	89 d7                	mov    %edx,%edi
			base = 16;
  800853:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800858:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80085c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800863:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800867:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086b:	89 34 24             	mov    %esi,(%esp)
  80086e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800872:	89 da                	mov    %ebx,%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	e8 24 fb ff ff       	call   8003a0 <printnum>
			break;
  80087c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80087f:	e9 99 fc ff ff       	jmp    80051d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800884:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800888:	89 14 24             	mov    %edx,(%esp)
  80088b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800891:	e9 87 fc ff ff       	jmp    80051d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800896:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80089a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008a8:	0f 84 6f fc ff ff    	je     80051d <vprintfmt+0x23>
  8008ae:	83 ee 01             	sub    $0x1,%esi
  8008b1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008b5:	75 f7                	jne    8008ae <vprintfmt+0x3b4>
  8008b7:	e9 61 fc ff ff       	jmp    80051d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8008bc:	83 c4 4c             	add    $0x4c,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 28             	sub    $0x28,%esp
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	74 30                	je     800915 <vsnprintf+0x51>
  8008e5:	85 d2                	test   %edx,%edx
  8008e7:	7e 2c                	jle    800915 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fe:	c7 04 24 b5 04 80 00 	movl   $0x8004b5,(%esp)
  800905:	e8 f0 fb ff ff       	call   8004fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80090a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800913:	eb 05                	jmp    80091a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800922:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800929:	8b 45 10             	mov    0x10(%ebp),%eax
  80092c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	89 44 24 04          	mov    %eax,0x4(%esp)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 04 24             	mov    %eax,(%esp)
  80093d:	e8 82 ff ff ff       	call   8008c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    
	...

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	80 3a 00             	cmpb   $0x0,(%edx)
  80095e:	74 09                	je     800969 <strlen+0x19>
		n++;
  800960:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800967:	75 f7                	jne    800960 <strlen+0x10>
		n++;
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800975:	b8 00 00 00 00       	mov    $0x0,%eax
  80097a:	85 c9                	test   %ecx,%ecx
  80097c:	74 1a                	je     800998 <strnlen+0x2d>
  80097e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800981:	74 15                	je     800998 <strnlen+0x2d>
  800983:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800988:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098a:	39 ca                	cmp    %ecx,%edx
  80098c:	74 0a                	je     800998 <strnlen+0x2d>
  80098e:	83 c2 01             	add    $0x1,%edx
  800991:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800996:	75 f0                	jne    800988 <strnlen+0x1d>
		n++;
	return n;
}
  800998:	5b                   	pop    %ebx
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009aa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	84 c9                	test   %cl,%cl
  8009b6:	75 f2                	jne    8009aa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c5:	89 1c 24             	mov    %ebx,(%esp)
  8009c8:	e8 83 ff ff ff       	call   800950 <strlen>
	strcpy(dst + len, src);
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009d4:	01 d8                	add    %ebx,%eax
  8009d6:	89 04 24             	mov    %eax,(%esp)
  8009d9:	e8 bd ff ff ff       	call   80099b <strcpy>
	return dst;
}
  8009de:	89 d8                	mov    %ebx,%eax
  8009e0:	83 c4 08             	add    $0x8,%esp
  8009e3:	5b                   	pop    %ebx
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f4:	85 f6                	test   %esi,%esi
  8009f6:	74 18                	je     800a10 <strncpy+0x2a>
  8009f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009fd:	0f b6 1a             	movzbl (%edx),%ebx
  800a00:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a03:	80 3a 01             	cmpb   $0x1,(%edx)
  800a06:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a09:	83 c1 01             	add    $0x1,%ecx
  800a0c:	39 f1                	cmp    %esi,%ecx
  800a0e:	75 ed                	jne    8009fd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a20:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a23:	89 f8                	mov    %edi,%eax
  800a25:	85 f6                	test   %esi,%esi
  800a27:	74 2b                	je     800a54 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800a29:	83 fe 01             	cmp    $0x1,%esi
  800a2c:	74 23                	je     800a51 <strlcpy+0x3d>
  800a2e:	0f b6 0b             	movzbl (%ebx),%ecx
  800a31:	84 c9                	test   %cl,%cl
  800a33:	74 1c                	je     800a51 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800a35:	83 ee 02             	sub    $0x2,%esi
  800a38:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a3d:	88 08                	mov    %cl,(%eax)
  800a3f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a42:	39 f2                	cmp    %esi,%edx
  800a44:	74 0b                	je     800a51 <strlcpy+0x3d>
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a4d:	84 c9                	test   %cl,%cl
  800a4f:	75 ec                	jne    800a3d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800a51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a54:	29 f8                	sub    %edi,%eax
}
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5f                   	pop    %edi
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a64:	0f b6 01             	movzbl (%ecx),%eax
  800a67:	84 c0                	test   %al,%al
  800a69:	74 16                	je     800a81 <strcmp+0x26>
  800a6b:	3a 02                	cmp    (%edx),%al
  800a6d:	75 12                	jne    800a81 <strcmp+0x26>
		p++, q++;
  800a6f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a72:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800a76:	84 c0                	test   %al,%al
  800a78:	74 07                	je     800a81 <strcmp+0x26>
  800a7a:	83 c1 01             	add    $0x1,%ecx
  800a7d:	3a 02                	cmp    (%edx),%al
  800a7f:	74 ee                	je     800a6f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a81:	0f b6 c0             	movzbl %al,%eax
  800a84:	0f b6 12             	movzbl (%edx),%edx
  800a87:	29 d0                	sub    %edx,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	53                   	push   %ebx
  800a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a95:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a9d:	85 d2                	test   %edx,%edx
  800a9f:	74 28                	je     800ac9 <strncmp+0x3e>
  800aa1:	0f b6 01             	movzbl (%ecx),%eax
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 24                	je     800acc <strncmp+0x41>
  800aa8:	3a 03                	cmp    (%ebx),%al
  800aaa:	75 20                	jne    800acc <strncmp+0x41>
  800aac:	83 ea 01             	sub    $0x1,%edx
  800aaf:	74 13                	je     800ac4 <strncmp+0x39>
		n--, p++, q++;
  800ab1:	83 c1 01             	add    $0x1,%ecx
  800ab4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ab7:	0f b6 01             	movzbl (%ecx),%eax
  800aba:	84 c0                	test   %al,%al
  800abc:	74 0e                	je     800acc <strncmp+0x41>
  800abe:	3a 03                	cmp    (%ebx),%al
  800ac0:	74 ea                	je     800aac <strncmp+0x21>
  800ac2:	eb 08                	jmp    800acc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ac9:	5b                   	pop    %ebx
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acc:	0f b6 01             	movzbl (%ecx),%eax
  800acf:	0f b6 13             	movzbl (%ebx),%edx
  800ad2:	29 d0                	sub    %edx,%eax
  800ad4:	eb f3                	jmp    800ac9 <strncmp+0x3e>

00800ad6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae0:	0f b6 10             	movzbl (%eax),%edx
  800ae3:	84 d2                	test   %dl,%dl
  800ae5:	74 1c                	je     800b03 <strchr+0x2d>
		if (*s == c)
  800ae7:	38 ca                	cmp    %cl,%dl
  800ae9:	75 09                	jne    800af4 <strchr+0x1e>
  800aeb:	eb 1b                	jmp    800b08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aed:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800af0:	38 ca                	cmp    %cl,%dl
  800af2:	74 14                	je     800b08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800af8:	84 d2                	test   %dl,%dl
  800afa:	75 f1                	jne    800aed <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	eb 05                	jmp    800b08 <strchr+0x32>
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b14:	0f b6 10             	movzbl (%eax),%edx
  800b17:	84 d2                	test   %dl,%dl
  800b19:	74 14                	je     800b2f <strfind+0x25>
		if (*s == c)
  800b1b:	38 ca                	cmp    %cl,%dl
  800b1d:	75 06                	jne    800b25 <strfind+0x1b>
  800b1f:	eb 0e                	jmp    800b2f <strfind+0x25>
  800b21:	38 ca                	cmp    %cl,%dl
  800b23:	74 0a                	je     800b2f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b25:	83 c0 01             	add    $0x1,%eax
  800b28:	0f b6 10             	movzbl (%eax),%edx
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	75 f2                	jne    800b21 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 0c             	sub    $0xc,%esp
  800b37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b49:	85 c9                	test   %ecx,%ecx
  800b4b:	74 30                	je     800b7d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b4d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b53:	75 25                	jne    800b7a <memset+0x49>
  800b55:	f6 c1 03             	test   $0x3,%cl
  800b58:	75 20                	jne    800b7a <memset+0x49>
		c &= 0xFF;
  800b5a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b5d:	89 d3                	mov    %edx,%ebx
  800b5f:	c1 e3 08             	shl    $0x8,%ebx
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	c1 e6 18             	shl    $0x18,%esi
  800b67:	89 d0                	mov    %edx,%eax
  800b69:	c1 e0 10             	shl    $0x10,%eax
  800b6c:	09 f0                	or     %esi,%eax
  800b6e:	09 d0                	or     %edx,%eax
  800b70:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b72:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b75:	fc                   	cld    
  800b76:	f3 ab                	rep stos %eax,%es:(%edi)
  800b78:	eb 03                	jmp    800b7d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b7a:	fc                   	cld    
  800b7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b7d:	89 f8                	mov    %edi,%eax
  800b7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b88:	89 ec                	mov    %ebp,%esp
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba1:	39 c6                	cmp    %eax,%esi
  800ba3:	73 36                	jae    800bdb <memmove+0x4f>
  800ba5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba8:	39 d0                	cmp    %edx,%eax
  800baa:	73 2f                	jae    800bdb <memmove+0x4f>
		s += n;
		d += n;
  800bac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	f6 c2 03             	test   $0x3,%dl
  800bb2:	75 1b                	jne    800bcf <memmove+0x43>
  800bb4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bba:	75 13                	jne    800bcf <memmove+0x43>
  800bbc:	f6 c1 03             	test   $0x3,%cl
  800bbf:	75 0e                	jne    800bcf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bc1:	83 ef 04             	sub    $0x4,%edi
  800bc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bca:	fd                   	std    
  800bcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcd:	eb 09                	jmp    800bd8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bcf:	83 ef 01             	sub    $0x1,%edi
  800bd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bd5:	fd                   	std    
  800bd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd8:	fc                   	cld    
  800bd9:	eb 20                	jmp    800bfb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bdb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be1:	75 13                	jne    800bf6 <memmove+0x6a>
  800be3:	a8 03                	test   $0x3,%al
  800be5:	75 0f                	jne    800bf6 <memmove+0x6a>
  800be7:	f6 c1 03             	test   $0x3,%cl
  800bea:	75 0a                	jne    800bf6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bec:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bef:	89 c7                	mov    %eax,%edi
  800bf1:	fc                   	cld    
  800bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf4:	eb 05                	jmp    800bfb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bf6:	89 c7                	mov    %eax,%edi
  800bf8:	fc                   	cld    
  800bf9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c01:	89 ec                	mov    %ebp,%esp
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 04 24             	mov    %eax,(%esp)
  800c1f:	e8 68 ff ff ff       	call   800b8c <memmove>
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
  800c2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c32:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3a:	85 ff                	test   %edi,%edi
  800c3c:	74 37                	je     800c75 <memcmp+0x4f>
		if (*s1 != *s2)
  800c3e:	0f b6 03             	movzbl (%ebx),%eax
  800c41:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c44:	83 ef 01             	sub    $0x1,%edi
  800c47:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c4c:	38 c8                	cmp    %cl,%al
  800c4e:	74 1c                	je     800c6c <memcmp+0x46>
  800c50:	eb 10                	jmp    800c62 <memcmp+0x3c>
  800c52:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c57:	83 c2 01             	add    $0x1,%edx
  800c5a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c5e:	38 c8                	cmp    %cl,%al
  800c60:	74 0a                	je     800c6c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800c62:	0f b6 c0             	movzbl %al,%eax
  800c65:	0f b6 c9             	movzbl %cl,%ecx
  800c68:	29 c8                	sub    %ecx,%eax
  800c6a:	eb 09                	jmp    800c75 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6c:	39 fa                	cmp    %edi,%edx
  800c6e:	75 e2                	jne    800c52 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c80:	89 c2                	mov    %eax,%edx
  800c82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c85:	39 d0                	cmp    %edx,%eax
  800c87:	73 19                	jae    800ca2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c8d:	38 08                	cmp    %cl,(%eax)
  800c8f:	75 06                	jne    800c97 <memfind+0x1d>
  800c91:	eb 0f                	jmp    800ca2 <memfind+0x28>
  800c93:	38 08                	cmp    %cl,(%eax)
  800c95:	74 0b                	je     800ca2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c97:	83 c0 01             	add    $0x1,%eax
  800c9a:	39 d0                	cmp    %edx,%eax
  800c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ca0:	75 f1                	jne    800c93 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb0:	0f b6 02             	movzbl (%edx),%eax
  800cb3:	3c 20                	cmp    $0x20,%al
  800cb5:	74 04                	je     800cbb <strtol+0x17>
  800cb7:	3c 09                	cmp    $0x9,%al
  800cb9:	75 0e                	jne    800cc9 <strtol+0x25>
		s++;
  800cbb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbe:	0f b6 02             	movzbl (%edx),%eax
  800cc1:	3c 20                	cmp    $0x20,%al
  800cc3:	74 f6                	je     800cbb <strtol+0x17>
  800cc5:	3c 09                	cmp    $0x9,%al
  800cc7:	74 f2                	je     800cbb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc9:	3c 2b                	cmp    $0x2b,%al
  800ccb:	75 0a                	jne    800cd7 <strtol+0x33>
		s++;
  800ccd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800cd0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd5:	eb 10                	jmp    800ce7 <strtol+0x43>
  800cd7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cdc:	3c 2d                	cmp    $0x2d,%al
  800cde:	75 07                	jne    800ce7 <strtol+0x43>
		s++, neg = 1;
  800ce0:	83 c2 01             	add    $0x1,%edx
  800ce3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce7:	85 db                	test   %ebx,%ebx
  800ce9:	0f 94 c0             	sete   %al
  800cec:	74 05                	je     800cf3 <strtol+0x4f>
  800cee:	83 fb 10             	cmp    $0x10,%ebx
  800cf1:	75 15                	jne    800d08 <strtol+0x64>
  800cf3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cf6:	75 10                	jne    800d08 <strtol+0x64>
  800cf8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cfc:	75 0a                	jne    800d08 <strtol+0x64>
		s += 2, base = 16;
  800cfe:	83 c2 02             	add    $0x2,%edx
  800d01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d06:	eb 13                	jmp    800d1b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0f                	je     800d1b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d11:	80 3a 30             	cmpb   $0x30,(%edx)
  800d14:	75 05                	jne    800d1b <strtol+0x77>
		s++, base = 8;
  800d16:	83 c2 01             	add    $0x1,%edx
  800d19:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d20:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d22:	0f b6 0a             	movzbl (%edx),%ecx
  800d25:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d28:	80 fb 09             	cmp    $0x9,%bl
  800d2b:	77 08                	ja     800d35 <strtol+0x91>
			dig = *s - '0';
  800d2d:	0f be c9             	movsbl %cl,%ecx
  800d30:	83 e9 30             	sub    $0x30,%ecx
  800d33:	eb 1e                	jmp    800d53 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800d35:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800d38:	80 fb 19             	cmp    $0x19,%bl
  800d3b:	77 08                	ja     800d45 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800d3d:	0f be c9             	movsbl %cl,%ecx
  800d40:	83 e9 57             	sub    $0x57,%ecx
  800d43:	eb 0e                	jmp    800d53 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d45:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d48:	80 fb 19             	cmp    $0x19,%bl
  800d4b:	77 14                	ja     800d61 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d4d:	0f be c9             	movsbl %cl,%ecx
  800d50:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d53:	39 f1                	cmp    %esi,%ecx
  800d55:	7d 0e                	jge    800d65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d57:	83 c2 01             	add    $0x1,%edx
  800d5a:	0f af c6             	imul   %esi,%eax
  800d5d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800d5f:	eb c1                	jmp    800d22 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d61:	89 c1                	mov    %eax,%ecx
  800d63:	eb 02                	jmp    800d67 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d65:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6b:	74 05                	je     800d72 <strtol+0xce>
		*endptr = (char *) s;
  800d6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d70:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d72:	89 ca                	mov    %ecx,%edx
  800d74:	f7 da                	neg    %edx
  800d76:	85 ff                	test   %edi,%edi
  800d78:	0f 45 c2             	cmovne %edx,%eax
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	89 c3                	mov    %eax,%ebx
  800d9c:	89 c7                	mov    %eax,%edi
  800d9e:	89 c6                	mov    %eax,%esi
  800da0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dab:	89 ec                	mov    %ebp,%esp
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <sys_cgetc>:

int
sys_cgetc(void)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc8:	89 d1                	mov    %edx,%ecx
  800dca:	89 d3                	mov    %edx,%ebx
  800dcc:	89 d7                	mov    %edx,%edi
  800dce:	89 d6                	mov    %edx,%esi
  800dd0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ddb:	89 ec                	mov    %ebp,%esp
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 38             	sub    $0x38,%esp
  800de5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800deb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df3:	b8 03 00 00 00       	mov    $0x3,%eax
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	89 cb                	mov    %ecx,%ebx
  800dfd:	89 cf                	mov    %ecx,%edi
  800dff:	89 ce                	mov    %ecx,%esi
  800e01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7e 28                	jle    800e2f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e12:	00 
  800e13:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800e1a:	00 
  800e1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e22:	00 
  800e23:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800e2a:	e8 59 f4 ff ff       	call   800288 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e38:	89 ec                	mov    %ebp,%esp
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e50:	b8 02 00 00 00       	mov    $0x2,%eax
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	89 d3                	mov    %edx,%ebx
  800e59:	89 d7                	mov    %edx,%edi
  800e5b:	89 d6                	mov    %edx,%esi
  800e5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e68:	89 ec                	mov    %ebp,%esp
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <sys_yield>:

void
sys_yield(void)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e80:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e85:	89 d1                	mov    %edx,%ecx
  800e87:	89 d3                	mov    %edx,%ebx
  800e89:	89 d7                	mov    %edx,%edi
  800e8b:	89 d6                	mov    %edx,%esi
  800e8d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e98:	89 ec                	mov    %ebp,%esp
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 38             	sub    $0x38,%esp
  800ea2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eab:	be 00 00 00 00       	mov    $0x0,%esi
  800eb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	89 f7                	mov    %esi,%edi
  800ec0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7e 28                	jle    800eee <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eca:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800ed9:	00 
  800eda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee1:	00 
  800ee2:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800ee9:	e8 9a f3 ff ff       	call   800288 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef7:	89 ec                	mov    %ebp,%esp
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 38             	sub    $0x38,%esp
  800f01:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f04:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f07:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f0f:	8b 75 18             	mov    0x18(%ebp),%esi
  800f12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7e 28                	jle    800f4c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f24:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f28:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f2f:	00 
  800f30:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f37:	00 
  800f38:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3f:	00 
  800f40:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800f47:	e8 3c f3 ff ff       	call   800288 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f4c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f52:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f55:	89 ec                	mov    %ebp,%esp
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 38             	sub    $0x38,%esp
  800f5f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f65:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	89 df                	mov    %ebx,%edi
  800f7a:	89 de                	mov    %ebx,%esi
  800f7c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	7e 28                	jle    800faa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f86:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f8d:	00 
  800f8e:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f95:	00 
  800f96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9d:	00 
  800f9e:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800fa5:	e8 de f2 ff ff       	call   800288 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800faa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb3:	89 ec                	mov    %ebp,%esp
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 38             	sub    $0x38,%esp
  800fbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801003:	e8 80 f2 ff ff       	call   800288 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801008:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801011:	89 ec                	mov    %ebp,%esp
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 38             	sub    $0x38,%esp
  80101b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801021:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	b8 09 00 00 00       	mov    $0x9,%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7e 28                	jle    801066 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801042:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801049:	00 
  80104a:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801061:	e8 22 f2 ff ff       	call   800288 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801066:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801069:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106f:	89 ec                	mov    %ebp,%esp
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 38             	sub    $0x38,%esp
  801079:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80107f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	bb 00 00 00 00       	mov    $0x0,%ebx
  801087:	b8 0a 00 00 00       	mov    $0xa,%eax
  80108c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108f:	8b 55 08             	mov    0x8(%ebp),%edx
  801092:	89 df                	mov    %ebx,%edi
  801094:	89 de                	mov    %ebx,%esi
  801096:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801098:	85 c0                	test   %eax,%eax
  80109a:	7e 28                	jle    8010c4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010a7:	00 
  8010a8:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  8010af:	00 
  8010b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b7:	00 
  8010b8:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  8010bf:	e8 c4 f1 ff ff       	call   800288 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010cd:	89 ec                	mov    %ebp,%esp
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 0c             	sub    $0xc,%esp
  8010d7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010da:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010dd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e0:	be 00 00 00 00       	mov    $0x0,%esi
  8010e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801101:	89 ec                	mov    %ebp,%esp
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 38             	sub    $0x38,%esp
  80110b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80110e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801111:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801114:	b9 00 00 00 00       	mov    $0x0,%ecx
  801119:	b8 0d 00 00 00       	mov    $0xd,%eax
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	89 cb                	mov    %ecx,%ebx
  801123:	89 cf                	mov    %ecx,%edi
  801125:	89 ce                	mov    %ecx,%esi
  801127:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801129:	85 c0                	test   %eax,%eax
  80112b:	7e 28                	jle    801155 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80112d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801131:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801138:	00 
  801139:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  801140:	00 
  801141:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801148:	00 
  801149:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801150:	e8 33 f1 ff ff       	call   800288 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801155:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801158:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80115b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80115e:	89 ec                	mov    %ebp,%esp
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    
	...

00801164 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	53                   	push   %ebx
  801168:	83 ec 24             	sub    $0x24,%esp
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80116e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801170:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801174:	74 21                	je     801197 <pgfault+0x33>
  801176:	89 d8                	mov    %ebx,%eax
  801178:	c1 e8 16             	shr    $0x16,%eax
  80117b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801182:	a8 01                	test   $0x1,%al
  801184:	74 11                	je     801197 <pgfault+0x33>
  801186:	89 d8                	mov    %ebx,%eax
  801188:	c1 e8 0c             	shr    $0xc,%eax
  80118b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801192:	f6 c4 08             	test   $0x8,%ah
  801195:	75 1c                	jne    8011b3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801197:	c7 44 24 08 ac 2c 80 	movl   $0x802cac,0x8(%esp)
  80119e:	00 
  80119f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8011a6:	00 
  8011a7:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8011ae:	e8 d5 f0 ff ff       	call   800288 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8011b3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011ba:	00 
  8011bb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011c2:	00 
  8011c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011ca:	e8 cd fc ff ff       	call   800e9c <sys_page_alloc>
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	79 20                	jns    8011f3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8011d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011d7:	c7 44 24 08 e8 2c 80 	movl   $0x802ce8,0x8(%esp)
  8011de:	00 
  8011df:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8011e6:	00 
  8011e7:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8011ee:	e8 95 f0 ff ff       	call   800288 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  8011f3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  8011f9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801200:	00 
  801201:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801205:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80120c:	e8 7b f9 ff ff       	call   800b8c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801211:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801218:	00 
  801219:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80121d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801224:	00 
  801225:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80122c:	00 
  80122d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801234:	e8 c2 fc ff ff       	call   800efb <sys_page_map>
  801239:	85 c0                	test   %eax,%eax
  80123b:	79 20                	jns    80125d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80123d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801241:	c7 44 24 08 10 2d 80 	movl   $0x802d10,0x8(%esp)
  801248:	00 
  801249:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801250:	00 
  801251:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  801258:	e8 2b f0 ff ff       	call   800288 <_panic>
	//panic("pgfault not implemented");
}
  80125d:	83 c4 24             	add    $0x24,%esp
  801260:	5b                   	pop    %ebx
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	57                   	push   %edi
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80126c:	c7 04 24 64 11 80 00 	movl   $0x801164,(%esp)
  801273:	e8 e8 10 00 00       	call   802360 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801278:	ba 07 00 00 00       	mov    $0x7,%edx
  80127d:	89 d0                	mov    %edx,%eax
  80127f:	cd 30                	int    $0x30
  801281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801284:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801286:	85 c0                	test   %eax,%eax
  801288:	79 20                	jns    8012aa <fork+0x47>
		panic("sys_exofork: %e", envid);
  80128a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80128e:	c7 44 24 08 0e 2e 80 	movl   $0x802e0e,0x8(%esp)
  801295:	00 
  801296:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80129d:	00 
  80129e:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8012a5:	e8 de ef ff ff       	call   800288 <_panic>
	if (envid == 0) {
  8012aa:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	75 1c                	jne    8012d1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012b5:	e8 82 fb ff ff       	call   800e3c <sys_getenvid>
  8012ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c7:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8012cc:	e9 06 02 00 00       	jmp    8014d7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8012d1:	89 d8                	mov    %ebx,%eax
  8012d3:	c1 e8 16             	shr    $0x16,%eax
  8012d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012dd:	a8 01                	test   $0x1,%al
  8012df:	0f 84 57 01 00 00    	je     80143c <fork+0x1d9>
  8012e5:	89 de                	mov    %ebx,%esi
  8012e7:	c1 ee 0c             	shr    $0xc,%esi
  8012ea:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012f1:	a8 01                	test   $0x1,%al
  8012f3:	0f 84 43 01 00 00    	je     80143c <fork+0x1d9>
  8012f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801300:	a8 04                	test   $0x4,%al
  801302:	0f 84 34 01 00 00    	je     80143c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801308:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80130b:	89 f0                	mov    %esi,%eax
  80130d:	c1 e8 0c             	shr    $0xc,%eax
  801310:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801317:	f6 c4 04             	test   $0x4,%ah
  80131a:	74 45                	je     801361 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80131c:	25 07 0e 00 00       	and    $0xe07,%eax
  801321:	89 44 24 10          	mov    %eax,0x10(%esp)
  801325:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801329:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80132d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801338:	e8 be fb ff ff       	call   800efb <sys_page_map>
  80133d:	85 c0                	test   %eax,%eax
  80133f:	0f 89 f7 00 00 00    	jns    80143c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801345:	c7 44 24 08 1e 2e 80 	movl   $0x802e1e,0x8(%esp)
  80134c:	00 
  80134d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801354:	00 
  801355:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  80135c:	e8 27 ef ff ff       	call   800288 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801361:	a9 02 08 00 00       	test   $0x802,%eax
  801366:	0f 84 8c 00 00 00    	je     8013f8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80136c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801373:	00 
  801374:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801378:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80137c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801387:	e8 6f fb ff ff       	call   800efb <sys_page_map>
  80138c:	85 c0                	test   %eax,%eax
  80138e:	79 20                	jns    8013b0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801390:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801394:	c7 44 24 08 34 2d 80 	movl   $0x802d34,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8013a3:	00 
  8013a4:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8013ab:	e8 d8 ee ff ff       	call   800288 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8013b0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013b7:	00 
  8013b8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013c3:	00 
  8013c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cf:	e8 27 fb ff ff       	call   800efb <sys_page_map>
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	79 64                	jns    80143c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8013d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013dc:	c7 44 24 08 60 2d 80 	movl   $0x802d60,0x8(%esp)
  8013e3:	00 
  8013e4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8013eb:	00 
  8013ec:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8013f3:	e8 90 ee ff ff       	call   800288 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8013f8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8013ff:	00 
  801400:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801404:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801408:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801413:	e8 e3 fa ff ff       	call   800efb <sys_page_map>
  801418:	85 c0                	test   %eax,%eax
  80141a:	79 20                	jns    80143c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80141c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801420:	c7 44 24 08 8c 2d 80 	movl   $0x802d8c,0x8(%esp)
  801427:	00 
  801428:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80142f:	00 
  801430:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  801437:	e8 4c ee ff ff       	call   800288 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80143c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801442:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801448:	0f 85 83 fe ff ff    	jne    8012d1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80144e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801455:	00 
  801456:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80145d:	ee 
  80145e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801461:	89 04 24             	mov    %eax,(%esp)
  801464:	e8 33 fa ff ff       	call   800e9c <sys_page_alloc>
  801469:	85 c0                	test   %eax,%eax
  80146b:	79 20                	jns    80148d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80146d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801471:	c7 44 24 08 b8 2d 80 	movl   $0x802db8,0x8(%esp)
  801478:	00 
  801479:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801480:	00 
  801481:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  801488:	e8 fb ed ff ff       	call   800288 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80148d:	c7 44 24 04 d0 23 80 	movl   $0x8023d0,0x4(%esp)
  801494:	00 
  801495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801498:	89 04 24             	mov    %eax,(%esp)
  80149b:	e8 d3 fb ff ff       	call   801073 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014a0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014a7:	00 
  8014a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ab:	89 04 24             	mov    %eax,(%esp)
  8014ae:	e8 04 fb ff ff       	call   800fb7 <sys_env_set_status>
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	79 20                	jns    8014d7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8014b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014bb:	c7 44 24 08 dc 2d 80 	movl   $0x802ddc,0x8(%esp)
  8014c2:	00 
  8014c3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8014ca:	00 
  8014cb:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8014d2:	e8 b1 ed ff ff       	call   800288 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8014d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014da:	83 c4 3c             	add    $0x3c,%esp
  8014dd:	5b                   	pop    %ebx
  8014de:	5e                   	pop    %esi
  8014df:	5f                   	pop    %edi
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014e8:	c7 44 24 08 35 2e 80 	movl   $0x802e35,0x8(%esp)
  8014ef:	00 
  8014f0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8014f7:	00 
  8014f8:	c7 04 24 03 2e 80 00 	movl   $0x802e03,(%esp)
  8014ff:	e8 84 ed ff ff       	call   800288 <_panic>
	...

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 04 24             	mov    %eax,(%esp)
  80152c:	e8 df ff ff ff       	call   801510 <fd2num>
  801531:	05 20 00 0d 00       	add    $0xd0020,%eax
  801536:	c1 e0 0c             	shl    $0xc,%eax
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	53                   	push   %ebx
  80153f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801547:	a8 01                	test   $0x1,%al
  801549:	74 34                	je     80157f <fd_alloc+0x44>
  80154b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801550:	a8 01                	test   $0x1,%al
  801552:	74 32                	je     801586 <fd_alloc+0x4b>
  801554:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801559:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80155b:	89 c2                	mov    %eax,%edx
  80155d:	c1 ea 16             	shr    $0x16,%edx
  801560:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801567:	f6 c2 01             	test   $0x1,%dl
  80156a:	74 1f                	je     80158b <fd_alloc+0x50>
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	c1 ea 0c             	shr    $0xc,%edx
  801571:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801578:	f6 c2 01             	test   $0x1,%dl
  80157b:	75 17                	jne    801594 <fd_alloc+0x59>
  80157d:	eb 0c                	jmp    80158b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80157f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801584:	eb 05                	jmp    80158b <fd_alloc+0x50>
  801586:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80158b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
  801592:	eb 17                	jmp    8015ab <fd_alloc+0x70>
  801594:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801599:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80159e:	75 b9                	jne    801559 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8015a6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015ab:	5b                   	pop    %ebx
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015b9:	83 fa 1f             	cmp    $0x1f,%edx
  8015bc:	77 3f                	ja     8015fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015be:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8015c4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015c7:	89 d0                	mov    %edx,%eax
  8015c9:	c1 e8 16             	shr    $0x16,%eax
  8015cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015d8:	f6 c1 01             	test   $0x1,%cl
  8015db:	74 20                	je     8015fd <fd_lookup+0x4f>
  8015dd:	89 d0                	mov    %edx,%eax
  8015df:	c1 e8 0c             	shr    $0xc,%eax
  8015e2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015ee:	f6 c1 01             	test   $0x1,%cl
  8015f1:	74 0a                	je     8015fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	89 10                	mov    %edx,(%eax)
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	53                   	push   %ebx
  801603:	83 ec 14             	sub    $0x14,%esp
  801606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801611:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801617:	75 17                	jne    801630 <dev_lookup+0x31>
  801619:	eb 07                	jmp    801622 <dev_lookup+0x23>
  80161b:	39 0a                	cmp    %ecx,(%edx)
  80161d:	75 11                	jne    801630 <dev_lookup+0x31>
  80161f:	90                   	nop
  801620:	eb 05                	jmp    801627 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801622:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801627:	89 13                	mov    %edx,(%ebx)
			return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 35                	jmp    801665 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801630:	83 c0 01             	add    $0x1,%eax
  801633:	8b 14 85 cc 2e 80 00 	mov    0x802ecc(,%eax,4),%edx
  80163a:	85 d2                	test   %edx,%edx
  80163c:	75 dd                	jne    80161b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80163e:	a1 20 44 80 00       	mov    0x804420,%eax
  801643:	8b 40 48             	mov    0x48(%eax),%eax
  801646:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80164a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164e:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  801655:	e8 29 ed ff ff       	call   800383 <cprintf>
	*dev = 0;
  80165a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801660:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801665:	83 c4 14             	add    $0x14,%esp
  801668:	5b                   	pop    %ebx
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    

0080166b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 38             	sub    $0x38,%esp
  801671:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801674:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801677:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80167a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801681:	89 3c 24             	mov    %edi,(%esp)
  801684:	e8 87 fe ff ff       	call   801510 <fd2num>
  801689:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80168c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 16 ff ff ff       	call   8015ae <fd_lookup>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 05                	js     8016a3 <fd_close+0x38>
	    || fd != fd2)
  80169e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8016a1:	74 0e                	je     8016b1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016a3:	89 f0                	mov    %esi,%eax
  8016a5:	84 c0                	test   %al,%al
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	0f 44 d8             	cmove  %eax,%ebx
  8016af:	eb 3d                	jmp    8016ee <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b8:	8b 07                	mov    (%edi),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 3d ff ff ff       	call   8015ff <dev_lookup>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 16                	js     8016de <fd_close+0x73>
		if (dev->dev_close)
  8016c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 07                	je     8016de <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8016d7:	89 3c 24             	mov    %edi,(%esp)
  8016da:	ff d0                	call   *%eax
  8016dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e9:	e8 6b f8 ff ff       	call   800f59 <sys_page_unmap>
	return r;
}
  8016ee:	89 d8                	mov    %ebx,%eax
  8016f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016f9:	89 ec                	mov    %ebp,%esp
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    

008016fd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	89 04 24             	mov    %eax,(%esp)
  801710:	e8 99 fe ff ff       	call   8015ae <fd_lookup>
  801715:	85 c0                	test   %eax,%eax
  801717:	78 13                	js     80172c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801719:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801720:	00 
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 3f ff ff ff       	call   80166b <fd_close>
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <close_all>:

void
close_all(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801735:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80173a:	89 1c 24             	mov    %ebx,(%esp)
  80173d:	e8 bb ff ff ff       	call   8016fd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801742:	83 c3 01             	add    $0x1,%ebx
  801745:	83 fb 20             	cmp    $0x20,%ebx
  801748:	75 f0                	jne    80173a <close_all+0xc>
		close(i);
}
  80174a:	83 c4 14             	add    $0x14,%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 58             	sub    $0x58,%esp
  801756:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801759:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80175c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80175f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801762:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801765:	89 44 24 04          	mov    %eax,0x4(%esp)
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	89 04 24             	mov    %eax,(%esp)
  80176f:	e8 3a fe ff ff       	call   8015ae <fd_lookup>
  801774:	89 c3                	mov    %eax,%ebx
  801776:	85 c0                	test   %eax,%eax
  801778:	0f 88 e1 00 00 00    	js     80185f <dup+0x10f>
		return r;
	close(newfdnum);
  80177e:	89 3c 24             	mov    %edi,(%esp)
  801781:	e8 77 ff ff ff       	call   8016fd <close>

	newfd = INDEX2FD(newfdnum);
  801786:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80178c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80178f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801792:	89 04 24             	mov    %eax,(%esp)
  801795:	e8 86 fd ff ff       	call   801520 <fd2data>
  80179a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80179c:	89 34 24             	mov    %esi,(%esp)
  80179f:	e8 7c fd ff ff       	call   801520 <fd2data>
  8017a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	c1 e8 16             	shr    $0x16,%eax
  8017ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017b3:	a8 01                	test   $0x1,%al
  8017b5:	74 46                	je     8017fd <dup+0xad>
  8017b7:	89 d8                	mov    %ebx,%eax
  8017b9:	c1 e8 0c             	shr    $0xc,%eax
  8017bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017c3:	f6 c2 01             	test   $0x1,%dl
  8017c6:	74 35                	je     8017fd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8017d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017e6:	00 
  8017e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f2:	e8 04 f7 ff ff       	call   800efb <sys_page_map>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 3b                	js     801838 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801800:	89 c2                	mov    %eax,%edx
  801802:	c1 ea 0c             	shr    $0xc,%edx
  801805:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80180c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801812:	89 54 24 10          	mov    %edx,0x10(%esp)
  801816:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80181a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801821:	00 
  801822:	89 44 24 04          	mov    %eax,0x4(%esp)
  801826:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80182d:	e8 c9 f6 ff ff       	call   800efb <sys_page_map>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	85 c0                	test   %eax,%eax
  801836:	79 25                	jns    80185d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801838:	89 74 24 04          	mov    %esi,0x4(%esp)
  80183c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801843:	e8 11 f7 ff ff       	call   800f59 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801856:	e8 fe f6 ff ff       	call   800f59 <sys_page_unmap>
	return r;
  80185b:	eb 02                	jmp    80185f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80185d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801864:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801867:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80186a:	89 ec                	mov    %ebp,%esp
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    

0080186e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
  801872:	83 ec 24             	sub    $0x24,%esp
  801875:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801878:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187f:	89 1c 24             	mov    %ebx,(%esp)
  801882:	e8 27 fd ff ff       	call   8015ae <fd_lookup>
  801887:	85 c0                	test   %eax,%eax
  801889:	78 6d                	js     8018f8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	e8 60 fd ff ff       	call   8015ff <dev_lookup>
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 55                	js     8018f8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	8b 50 08             	mov    0x8(%eax),%edx
  8018a9:	83 e2 03             	and    $0x3,%edx
  8018ac:	83 fa 01             	cmp    $0x1,%edx
  8018af:	75 23                	jne    8018d4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b1:	a1 20 44 80 00       	mov    0x804420,%eax
  8018b6:	8b 40 48             	mov    0x48(%eax),%eax
  8018b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c1:	c7 04 24 90 2e 80 00 	movl   $0x802e90,(%esp)
  8018c8:	e8 b6 ea ff ff       	call   800383 <cprintf>
		return -E_INVAL;
  8018cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d2:	eb 24                	jmp    8018f8 <read+0x8a>
	}
	if (!dev->dev_read)
  8018d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d7:	8b 52 08             	mov    0x8(%edx),%edx
  8018da:	85 d2                	test   %edx,%edx
  8018dc:	74 15                	je     8018f3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ec:	89 04 24             	mov    %eax,(%esp)
  8018ef:	ff d2                	call   *%edx
  8018f1:	eb 05                	jmp    8018f8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018f8:	83 c4 24             	add    $0x24,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	8b 7d 08             	mov    0x8(%ebp),%edi
  80190a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	85 f6                	test   %esi,%esi
  801914:	74 30                	je     801946 <readn+0x48>
  801916:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80191b:	89 f2                	mov    %esi,%edx
  80191d:	29 c2                	sub    %eax,%edx
  80191f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801923:	03 45 0c             	add    0xc(%ebp),%eax
  801926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192a:	89 3c 24             	mov    %edi,(%esp)
  80192d:	e8 3c ff ff ff       	call   80186e <read>
		if (m < 0)
  801932:	85 c0                	test   %eax,%eax
  801934:	78 10                	js     801946 <readn+0x48>
			return m;
		if (m == 0)
  801936:	85 c0                	test   %eax,%eax
  801938:	74 0a                	je     801944 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80193a:	01 c3                	add    %eax,%ebx
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	39 f3                	cmp    %esi,%ebx
  801940:	72 d9                	jb     80191b <readn+0x1d>
  801942:	eb 02                	jmp    801946 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801944:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	53                   	push   %ebx
  801952:	83 ec 24             	sub    $0x24,%esp
  801955:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801958:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	89 1c 24             	mov    %ebx,(%esp)
  801962:	e8 47 fc ff ff       	call   8015ae <fd_lookup>
  801967:	85 c0                	test   %eax,%eax
  801969:	78 68                	js     8019d3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	8b 00                	mov    (%eax),%eax
  801977:	89 04 24             	mov    %eax,(%esp)
  80197a:	e8 80 fc ff ff       	call   8015ff <dev_lookup>
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 50                	js     8019d3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198a:	75 23                	jne    8019af <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80198c:	a1 20 44 80 00       	mov    0x804420,%eax
  801991:	8b 40 48             	mov    0x48(%eax),%eax
  801994:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8019a3:	e8 db e9 ff ff       	call   800383 <cprintf>
		return -E_INVAL;
  8019a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ad:	eb 24                	jmp    8019d3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b5:	85 d2                	test   %edx,%edx
  8019b7:	74 15                	je     8019ce <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	ff d2                	call   *%edx
  8019cc:	eb 05                	jmp    8019d3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019d3:	83 c4 24             	add    $0x24,%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019df:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	89 04 24             	mov    %eax,(%esp)
  8019ec:	e8 bd fb ff ff       	call   8015ae <fd_lookup>
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 0e                	js     801a03 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	53                   	push   %ebx
  801a09:	83 ec 24             	sub    $0x24,%esp
  801a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	89 1c 24             	mov    %ebx,(%esp)
  801a19:	e8 90 fb ff ff       	call   8015ae <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 61                	js     801a83 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	89 04 24             	mov    %eax,(%esp)
  801a31:	e8 c9 fb ff ff       	call   8015ff <dev_lookup>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 49                	js     801a83 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a41:	75 23                	jne    801a66 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a43:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a48:	8b 40 48             	mov    0x48(%eax),%eax
  801a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a53:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  801a5a:	e8 24 e9 ff ff       	call   800383 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a64:	eb 1d                	jmp    801a83 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a69:	8b 52 18             	mov    0x18(%edx),%edx
  801a6c:	85 d2                	test   %edx,%edx
  801a6e:	74 0e                	je     801a7e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	ff d2                	call   *%edx
  801a7c:	eb 05                	jmp    801a83 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a83:	83 c4 24             	add    $0x24,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 24             	sub    $0x24,%esp
  801a90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a93:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	89 04 24             	mov    %eax,(%esp)
  801aa0:	e8 09 fb ff ff       	call   8015ae <fd_lookup>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 52                	js     801afb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	89 04 24             	mov    %eax,(%esp)
  801ab8:	e8 42 fb ff ff       	call   8015ff <dev_lookup>
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 3a                	js     801afb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ac8:	74 2c                	je     801af6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aca:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801acd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ad4:	00 00 00 
	stat->st_isdir = 0;
  801ad7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ade:	00 00 00 
	stat->st_dev = dev;
  801ae1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ae7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aee:	89 14 24             	mov    %edx,(%esp)
  801af1:	ff 50 14             	call   *0x14(%eax)
  801af4:	eb 05                	jmp    801afb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801af6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801afb:	83 c4 24             	add    $0x24,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
  801b07:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b0a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b14:	00 
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	e8 bc 01 00 00       	call   801cdc <open>
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 1b                	js     801b41 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2d:	89 1c 24             	mov    %ebx,(%esp)
  801b30:	e8 54 ff ff ff       	call   801a89 <fstat>
  801b35:	89 c6                	mov    %eax,%esi
	close(fd);
  801b37:	89 1c 24             	mov    %ebx,(%esp)
  801b3a:	e8 be fb ff ff       	call   8016fd <close>
	return r;
  801b3f:	89 f3                	mov    %esi,%ebx
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b46:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b49:	89 ec                	mov    %ebp,%esp
  801b4b:	5d                   	pop    %ebp
  801b4c:	c3                   	ret    
  801b4d:	00 00                	add    %al,(%eax)
	...

00801b50 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
  801b56:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b59:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b60:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b67:	75 11                	jne    801b7a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b70:	e8 61 09 00 00       	call   8024d6 <ipc_find_env>
  801b75:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b7a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b81:	00 
  801b82:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b89:	00 
  801b8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b8e:	a1 00 40 80 00       	mov    0x804000,%eax
  801b93:	89 04 24             	mov    %eax,(%esp)
  801b96:	e8 b7 08 00 00       	call   802452 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ba2:	00 
  801ba3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bae:	e8 4d 08 00 00       	call   802400 <ipc_recv>
}
  801bb3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bb6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bb9:	89 ec                	mov    %ebp,%esp
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 14             	sub    $0x14,%esp
  801bc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 05 00 00 00       	mov    $0x5,%eax
  801bdc:	e8 6f ff ff ff       	call   801b50 <fsipc>
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 2b                	js     801c10 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801be5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801bec:	00 
  801bed:	89 1c 24             	mov    %ebx,(%esp)
  801bf0:	e8 a6 ed ff ff       	call   80099b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf5:	a1 80 50 80 00       	mov    0x805080,%eax
  801bfa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c00:	a1 84 50 80 00       	mov    0x805084,%eax
  801c05:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	83 c4 14             	add    $0x14,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c22:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c27:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2c:	b8 06 00 00 00       	mov    $0x6,%eax
  801c31:	e8 1a ff ff ff       	call   801b50 <fsipc>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	83 ec 10             	sub    $0x10,%esp
  801c40:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8b 40 0c             	mov    0xc(%eax),%eax
  801c49:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c4e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c54:	ba 00 00 00 00       	mov    $0x0,%edx
  801c59:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5e:	e8 ed fe ff ff       	call   801b50 <fsipc>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 6a                	js     801cd3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c69:	39 c6                	cmp    %eax,%esi
  801c6b:	73 24                	jae    801c91 <devfile_read+0x59>
  801c6d:	c7 44 24 0c dc 2e 80 	movl   $0x802edc,0xc(%esp)
  801c74:	00 
  801c75:	c7 44 24 08 e3 2e 80 	movl   $0x802ee3,0x8(%esp)
  801c7c:	00 
  801c7d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c84:	00 
  801c85:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  801c8c:	e8 f7 e5 ff ff       	call   800288 <_panic>
	assert(r <= PGSIZE);
  801c91:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c96:	7e 24                	jle    801cbc <devfile_read+0x84>
  801c98:	c7 44 24 0c 03 2f 80 	movl   $0x802f03,0xc(%esp)
  801c9f:	00 
  801ca0:	c7 44 24 08 e3 2e 80 	movl   $0x802ee3,0x8(%esp)
  801ca7:	00 
  801ca8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801caf:	00 
  801cb0:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  801cb7:	e8 cc e5 ff ff       	call   800288 <_panic>
	memmove(buf, &fsipcbuf, r);
  801cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801cc7:	00 
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	89 04 24             	mov    %eax,(%esp)
  801cce:	e8 b9 ee ff ff       	call   800b8c <memmove>
	return r;
}
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    

00801cdc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 20             	sub    $0x20,%esp
  801ce4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ce7:	89 34 24             	mov    %esi,(%esp)
  801cea:	e8 61 ec ff ff       	call   800950 <strlen>
		return -E_BAD_PATH;
  801cef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cf4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf9:	7f 5e                	jg     801d59 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 35 f8 ff ff       	call   80153b <fd_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 4d                	js     801d59 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d10:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d17:	e8 7f ec ff ff       	call   80099b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2c:	e8 1f fe ff ff       	call   801b50 <fsipc>
  801d31:	89 c3                	mov    %eax,%ebx
  801d33:	85 c0                	test   %eax,%eax
  801d35:	79 15                	jns    801d4c <open+0x70>
		fd_close(fd, 0);
  801d37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3e:	00 
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 21 f9 ff ff       	call   80166b <fd_close>
		return r;
  801d4a:	eb 0d                	jmp    801d59 <open+0x7d>
	}

	return fd2num(fd);
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 b9 f7 ff ff       	call   801510 <fd2num>
  801d57:	89 c3                	mov    %eax,%ebx
}
  801d59:	89 d8                	mov    %ebx,%eax
  801d5b:	83 c4 20             	add    $0x20,%esp
  801d5e:	5b                   	pop    %ebx
  801d5f:	5e                   	pop    %esi
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    
	...

00801d70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
  801d76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d79:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 04 24             	mov    %eax,(%esp)
  801d85:	e8 96 f7 ff ff       	call   801520 <fd2data>
  801d8a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d8c:	c7 44 24 04 0f 2f 80 	movl   $0x802f0f,0x4(%esp)
  801d93:	00 
  801d94:	89 34 24             	mov    %esi,(%esp)
  801d97:	e8 ff eb ff ff       	call   80099b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d9f:	2b 03                	sub    (%ebx),%eax
  801da1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801da7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801dae:	00 00 00 
	stat->st_dev = &devpipe;
  801db1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801db8:	30 80 00 
	return 0;
}
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dc3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dc6:	89 ec                	mov    %ebp,%esp
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 14             	sub    $0x14,%esp
  801dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddf:	e8 75 f1 ff ff       	call   800f59 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801de4:	89 1c 24             	mov    %ebx,(%esp)
  801de7:	e8 34 f7 ff ff       	call   801520 <fd2data>
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df7:	e8 5d f1 ff ff       	call   800f59 <sys_page_unmap>
}
  801dfc:	83 c4 14             	add    $0x14,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 2c             	sub    $0x2c,%esp
  801e0b:	89 c7                	mov    %eax,%edi
  801e0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e10:	a1 20 44 80 00       	mov    0x804420,%eax
  801e15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e18:	89 3c 24             	mov    %edi,(%esp)
  801e1b:	e8 00 07 00 00       	call   802520 <pageref>
  801e20:	89 c6                	mov    %eax,%esi
  801e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 f3 06 00 00       	call   802520 <pageref>
  801e2d:	39 c6                	cmp    %eax,%esi
  801e2f:	0f 94 c0             	sete   %al
  801e32:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801e35:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801e3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e3e:	39 cb                	cmp    %ecx,%ebx
  801e40:	75 08                	jne    801e4a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e42:	83 c4 2c             	add    $0x2c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e4a:	83 f8 01             	cmp    $0x1,%eax
  801e4d:	75 c1                	jne    801e10 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e4f:	8b 52 58             	mov    0x58(%edx),%edx
  801e52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e5e:	c7 04 24 16 2f 80 00 	movl   $0x802f16,(%esp)
  801e65:	e8 19 e5 ff ff       	call   800383 <cprintf>
  801e6a:	eb a4                	jmp    801e10 <_pipeisclosed+0xe>

00801e6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 2c             	sub    $0x2c,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e78:	89 34 24             	mov    %esi,(%esp)
  801e7b:	e8 a0 f6 ff ff       	call   801520 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e82:	bf 00 00 00 00       	mov    $0x0,%edi
  801e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8b:	75 50                	jne    801edd <devpipe_write+0x71>
  801e8d:	eb 5c                	jmp    801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e8f:	89 da                	mov    %ebx,%edx
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	e8 6a ff ff ff       	call   801e02 <_pipeisclosed>
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	75 53                	jne    801eef <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e9c:	e8 cb ef ff ff       	call   800e6c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea4:	8b 13                	mov    (%ebx),%edx
  801ea6:	83 c2 20             	add    $0x20,%edx
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	73 e2                	jae    801e8f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801eb4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	c1 fa 1f             	sar    $0x1f,%edx
  801ebc:	c1 ea 1b             	shr    $0x1b,%edx
  801ebf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ec2:	83 e1 1f             	and    $0x1f,%ecx
  801ec5:	29 d1                	sub    %edx,%ecx
  801ec7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ecb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ecf:	83 c0 01             	add    $0x1,%eax
  801ed2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ed5:	83 c7 01             	add    $0x1,%edi
  801ed8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801edb:	74 0e                	je     801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801edd:	8b 43 04             	mov    0x4(%ebx),%eax
  801ee0:	8b 13                	mov    (%ebx),%edx
  801ee2:	83 c2 20             	add    $0x20,%edx
  801ee5:	39 d0                	cmp    %edx,%eax
  801ee7:	73 a6                	jae    801e8f <devpipe_write+0x23>
  801ee9:	eb c2                	jmp    801ead <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801eeb:	89 f8                	mov    %edi,%eax
  801eed:	eb 05                	jmp    801ef4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ef4:	83 c4 2c             	add    $0x2c,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 28             	sub    $0x28,%esp
  801f02:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f05:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f08:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f0b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f0e:	89 3c 24             	mov    %edi,(%esp)
  801f11:	e8 0a f6 ff ff       	call   801520 <fd2data>
  801f16:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f18:	be 00 00 00 00       	mov    $0x0,%esi
  801f1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f21:	75 47                	jne    801f6a <devpipe_read+0x6e>
  801f23:	eb 52                	jmp    801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	eb 5e                	jmp    801f87 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f29:	89 da                	mov    %ebx,%edx
  801f2b:	89 f8                	mov    %edi,%eax
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	e8 cd fe ff ff       	call   801e02 <_pipeisclosed>
  801f35:	85 c0                	test   %eax,%eax
  801f37:	75 49                	jne    801f82 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f39:	e8 2e ef ff ff       	call   800e6c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f3e:	8b 03                	mov    (%ebx),%eax
  801f40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f43:	74 e4                	je     801f29 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f45:	89 c2                	mov    %eax,%edx
  801f47:	c1 fa 1f             	sar    $0x1f,%edx
  801f4a:	c1 ea 1b             	shr    $0x1b,%edx
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	83 e0 1f             	and    $0x1f,%eax
  801f52:	29 d0                	sub    %edx,%eax
  801f54:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f5f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f62:	83 c6 01             	add    $0x1,%esi
  801f65:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f68:	74 0d                	je     801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801f6a:	8b 03                	mov    (%ebx),%eax
  801f6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6f:	75 d4                	jne    801f45 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f71:	85 f6                	test   %esi,%esi
  801f73:	75 b0                	jne    801f25 <devpipe_read+0x29>
  801f75:	eb b2                	jmp    801f29 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f77:	89 f0                	mov    %esi,%eax
  801f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f80:	eb 05                	jmp    801f87 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f87:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f8a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f8d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f90:	89 ec                	mov    %ebp,%esp
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 48             	sub    $0x48,%esp
  801f9a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f9d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fa0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fa3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fa6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fa9:	89 04 24             	mov    %eax,(%esp)
  801fac:	e8 8a f5 ff ff       	call   80153b <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 88 45 01 00 00    	js     802100 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc2:	00 
  801fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd1:	e8 c6 ee ff ff       	call   800e9c <sys_page_alloc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 20 01 00 00    	js     802100 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fe0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fe3:	89 04 24             	mov    %eax,(%esp)
  801fe6:	e8 50 f5 ff ff       	call   80153b <fd_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	85 c0                	test   %eax,%eax
  801fef:	0f 88 f8 00 00 00    	js     8020ed <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ffc:	00 
  801ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200b:	e8 8c ee ff ff       	call   800e9c <sys_page_alloc>
  802010:	89 c3                	mov    %eax,%ebx
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 d3 00 00 00    	js     8020ed <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80201a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80201d:	89 04 24             	mov    %eax,(%esp)
  802020:	e8 fb f4 ff ff       	call   801520 <fd2data>
  802025:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802027:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80202e:	00 
  80202f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802033:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203a:	e8 5d ee ff ff       	call   800e9c <sys_page_alloc>
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 91 00 00 00    	js     8020da <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 cc f4 ff ff       	call   801520 <fd2data>
  802054:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80205b:	00 
  80205c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802060:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802067:	00 
  802068:	89 74 24 04          	mov    %esi,0x4(%esp)
  80206c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802073:	e8 83 ee ff ff       	call   800efb <sys_page_map>
  802078:	89 c3                	mov    %eax,%ebx
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 4c                	js     8020ca <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80207e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802087:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802093:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80209e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 5d f4 ff ff       	call   801510 <fd2num>
  8020b3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8020b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 50 f4 ff ff       	call   801510 <fd2num>
  8020c0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8020c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020c8:	eb 36                	jmp    802100 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8020ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d5:	e8 7f ee ff ff       	call   800f59 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e8:	e8 6c ee ff ff       	call   800f59 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fb:	e8 59 ee ff ff       	call   800f59 <sys_page_unmap>
    err:
	return r;
}
  802100:	89 d8                	mov    %ebx,%eax
  802102:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802105:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802108:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80210b:	89 ec                	mov    %ebp,%esp
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 87 f4 ff ff       	call   8015ae <fd_lookup>
  802127:	85 c0                	test   %eax,%eax
  802129:	78 15                	js     802140 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	89 04 24             	mov    %eax,(%esp)
  802131:	e8 ea f3 ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  802136:	89 c2                	mov    %eax,%edx
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	e8 c2 fc ff ff       	call   801e02 <_pipeisclosed>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    
	...

00802144 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	83 ec 10             	sub    $0x10,%esp
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80214f:	85 c0                	test   %eax,%eax
  802151:	75 24                	jne    802177 <wait+0x33>
  802153:	c7 44 24 0c 2e 2f 80 	movl   $0x802f2e,0xc(%esp)
  80215a:	00 
  80215b:	c7 44 24 08 e3 2e 80 	movl   $0x802ee3,0x8(%esp)
  802162:	00 
  802163:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80216a:	00 
  80216b:	c7 04 24 39 2f 80 00 	movl   $0x802f39,(%esp)
  802172:	e8 11 e1 ff ff       	call   800288 <_panic>
	e = &envs[ENVX(envid)];
  802177:	89 c3                	mov    %eax,%ebx
  802179:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80217f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802182:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802188:	8b 73 48             	mov    0x48(%ebx),%esi
  80218b:	39 c6                	cmp    %eax,%esi
  80218d:	75 1a                	jne    8021a9 <wait+0x65>
  80218f:	8b 43 54             	mov    0x54(%ebx),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	74 13                	je     8021a9 <wait+0x65>
		sys_yield();
  802196:	e8 d1 ec ff ff       	call   800e6c <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80219b:	8b 43 48             	mov    0x48(%ebx),%eax
  80219e:	39 f0                	cmp    %esi,%eax
  8021a0:	75 07                	jne    8021a9 <wait+0x65>
  8021a2:	8b 43 54             	mov    0x54(%ebx),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 ed                	jne    802196 <wait+0x52>
		sys_yield();
}
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    

008021b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021c0:	c7 44 24 04 44 2f 80 	movl   $0x802f44,0x4(%esp)
  8021c7:	00 
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	89 04 24             	mov    %eax,(%esp)
  8021ce:	e8 c8 e7 ff ff       	call   80099b <strcpy>
	return 0;
}
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	57                   	push   %edi
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021e6:	be 00 00 00 00       	mov    $0x0,%esi
  8021eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ef:	74 43                	je     802234 <devcons_write+0x5a>
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ff:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802201:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802204:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802209:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80220c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802210:	03 45 0c             	add    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	89 3c 24             	mov    %edi,(%esp)
  80221a:	e8 6d e9 ff ff       	call   800b8c <memmove>
		sys_cputs(buf, m);
  80221f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802223:	89 3c 24             	mov    %edi,(%esp)
  802226:	e8 55 eb ff ff       	call   800d80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80222b:	01 de                	add    %ebx,%esi
  80222d:	89 f0                	mov    %esi,%eax
  80222f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802232:	72 c8                	jb     8021fc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802234:	89 f0                	mov    %esi,%eax
  802236:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80224c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802250:	75 07                	jne    802259 <devcons_read+0x18>
  802252:	eb 31                	jmp    802285 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802254:	e8 13 ec ff ff       	call   800e6c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	e8 4a eb ff ff       	call   800daf <sys_cgetc>
  802265:	85 c0                	test   %eax,%eax
  802267:	74 eb                	je     802254 <devcons_read+0x13>
  802269:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80226b:	85 c0                	test   %eax,%eax
  80226d:	78 16                	js     802285 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80226f:	83 f8 04             	cmp    $0x4,%eax
  802272:	74 0c                	je     802280 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802274:	8b 45 0c             	mov    0xc(%ebp),%eax
  802277:	88 10                	mov    %dl,(%eax)
	return 1;
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
  80227e:	eb 05                	jmp    802285 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802293:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80229a:	00 
  80229b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 da ea ff ff       	call   800d80 <sys_cputs>
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <getchar>:

int
getchar(void)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022b5:	00 
  8022b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c4:	e8 a5 f5 ff ff       	call   80186e <read>
	if (r < 0)
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 0f                	js     8022dc <getchar+0x34>
		return r;
	if (r < 1)
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	7e 06                	jle    8022d7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022d5:	eb 05                	jmp    8022dc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022d7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	e8 b8 f2 ff ff       	call   8015ae <fd_lookup>
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 11                	js     80230b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802303:	39 10                	cmp    %edx,(%eax)
  802305:	0f 94 c0             	sete   %al
  802308:	0f b6 c0             	movzbl %al,%eax
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <opencons>:

int
opencons(void)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 1d f2 ff ff       	call   80153b <fd_alloc>
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 3c                	js     80235e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802322:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802329:	00 
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802338:	e8 5f eb ff ff       	call   800e9c <sys_page_alloc>
  80233d:	85 c0                	test   %eax,%eax
  80233f:	78 1d                	js     80235e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802341:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802356:	89 04 24             	mov    %eax,(%esp)
  802359:	e8 b2 f1 ff ff       	call   801510 <fd2num>
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802366:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80236d:	75 54                	jne    8023c3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80236f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802376:	00 
  802377:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80237e:	ee 
  80237f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802386:	e8 11 eb ff ff       	call   800e9c <sys_page_alloc>
  80238b:	85 c0                	test   %eax,%eax
  80238d:	79 20                	jns    8023af <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  80238f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802393:	c7 44 24 08 50 2f 80 	movl   $0x802f50,0x8(%esp)
  80239a:	00 
  80239b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8023a2:	00 
  8023a3:	c7 04 24 68 2f 80 00 	movl   $0x802f68,(%esp)
  8023aa:	e8 d9 de ff ff       	call   800288 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023af:	c7 44 24 04 d0 23 80 	movl   $0x8023d0,0x4(%esp)
  8023b6:	00 
  8023b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023be:	e8 b0 ec ff ff       	call   801073 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
  8023cd:	00 00                	add    %al,(%eax)
	...

008023d0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023d0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023d1:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023d6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023d8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8023db:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8023df:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8023e2:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8023e6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8023ea:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8023ec:	83 c4 08             	add    $0x8,%esp
	popal
  8023ef:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8023f0:	83 c4 04             	add    $0x4,%esp
	popfl
  8023f3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023f4:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8023f5:	c3                   	ret    
	...

00802400 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	83 ec 10             	sub    $0x10,%esp
  802408:	8b 75 08             	mov    0x8(%ebp),%esi
  80240b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802411:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802413:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802418:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80241b:	89 04 24             	mov    %eax,(%esp)
  80241e:	e8 e2 ec ff ff       	call   801105 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802423:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802428:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80242d:	85 c0                	test   %eax,%eax
  80242f:	78 0e                	js     80243f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802431:	a1 20 44 80 00       	mov    0x804420,%eax
  802436:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802439:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80243c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80243f:	85 f6                	test   %esi,%esi
  802441:	74 02                	je     802445 <ipc_recv+0x45>
		*from_env_store = sender;
  802443:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802445:	85 db                	test   %ebx,%ebx
  802447:	74 02                	je     80244b <ipc_recv+0x4b>
		*perm_store = perm;
  802449:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80244b:	83 c4 10             	add    $0x10,%esp
  80244e:	5b                   	pop    %ebx
  80244f:	5e                   	pop    %esi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	57                   	push   %edi
  802456:	56                   	push   %esi
  802457:	53                   	push   %ebx
  802458:	83 ec 1c             	sub    $0x1c,%esp
  80245b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80245e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802461:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802464:	85 db                	test   %ebx,%ebx
  802466:	75 04                	jne    80246c <ipc_send+0x1a>
  802468:	85 f6                	test   %esi,%esi
  80246a:	75 15                	jne    802481 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80246c:	85 db                	test   %ebx,%ebx
  80246e:	74 16                	je     802486 <ipc_send+0x34>
  802470:	85 f6                	test   %esi,%esi
  802472:	0f 94 c0             	sete   %al
      pg = 0;
  802475:	84 c0                	test   %al,%al
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
  80247c:	0f 45 d8             	cmovne %eax,%ebx
  80247f:	eb 05                	jmp    802486 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802481:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802486:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80248a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80248e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	89 04 24             	mov    %eax,(%esp)
  802498:	e8 34 ec ff ff       	call   8010d1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80249d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024a0:	75 07                	jne    8024a9 <ipc_send+0x57>
           sys_yield();
  8024a2:	e8 c5 e9 ff ff       	call   800e6c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8024a7:	eb dd                	jmp    802486 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	90                   	nop
  8024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b0:	74 1c                	je     8024ce <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8024b2:	c7 44 24 08 76 2f 80 	movl   $0x802f76,0x8(%esp)
  8024b9:	00 
  8024ba:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8024c1:	00 
  8024c2:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  8024c9:	e8 ba dd ff ff       	call   800288 <_panic>
		}
    }
}
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8024dc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8024e1:	39 c8                	cmp    %ecx,%eax
  8024e3:	74 17                	je     8024fc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024e5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8024ea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024ed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024f3:	8b 52 50             	mov    0x50(%edx),%edx
  8024f6:	39 ca                	cmp    %ecx,%edx
  8024f8:	75 14                	jne    80250e <ipc_find_env+0x38>
  8024fa:	eb 05                	jmp    802501 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802501:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802504:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802509:	8b 40 40             	mov    0x40(%eax),%eax
  80250c:	eb 0e                	jmp    80251c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80250e:	83 c0 01             	add    $0x1,%eax
  802511:	3d 00 04 00 00       	cmp    $0x400,%eax
  802516:	75 d2                	jne    8024ea <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802518:	66 b8 00 00          	mov    $0x0,%ax
}
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    
	...

00802520 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802526:	89 d0                	mov    %edx,%eax
  802528:	c1 e8 16             	shr    $0x16,%eax
  80252b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802537:	f6 c1 01             	test   $0x1,%cl
  80253a:	74 1d                	je     802559 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80253c:	c1 ea 0c             	shr    $0xc,%edx
  80253f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802546:	f6 c2 01             	test   $0x1,%dl
  802549:	74 0e                	je     802559 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80254b:	c1 ea 0c             	shr    $0xc,%edx
  80254e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802555:	ef 
  802556:	0f b7 c0             	movzwl %ax,%eax
}
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    
  80255b:	00 00                	add    %al,(%eax)
  80255d:	00 00                	add    %al,(%eax)
	...

00802560 <__udivdi3>:
  802560:	83 ec 1c             	sub    $0x1c,%esp
  802563:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802567:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80256b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80256f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802573:	89 74 24 10          	mov    %esi,0x10(%esp)
  802577:	8b 74 24 24          	mov    0x24(%esp),%esi
  80257b:	85 ff                	test   %edi,%edi
  80257d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802581:	89 44 24 08          	mov    %eax,0x8(%esp)
  802585:	89 cd                	mov    %ecx,%ebp
  802587:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258b:	75 33                	jne    8025c0 <__udivdi3+0x60>
  80258d:	39 f1                	cmp    %esi,%ecx
  80258f:	77 57                	ja     8025e8 <__udivdi3+0x88>
  802591:	85 c9                	test   %ecx,%ecx
  802593:	75 0b                	jne    8025a0 <__udivdi3+0x40>
  802595:	b8 01 00 00 00       	mov    $0x1,%eax
  80259a:	31 d2                	xor    %edx,%edx
  80259c:	f7 f1                	div    %ecx
  80259e:	89 c1                	mov    %eax,%ecx
  8025a0:	89 f0                	mov    %esi,%eax
  8025a2:	31 d2                	xor    %edx,%edx
  8025a4:	f7 f1                	div    %ecx
  8025a6:	89 c6                	mov    %eax,%esi
  8025a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025ac:	f7 f1                	div    %ecx
  8025ae:	89 f2                	mov    %esi,%edx
  8025b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025b8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	c3                   	ret    
  8025c0:	31 d2                	xor    %edx,%edx
  8025c2:	31 c0                	xor    %eax,%eax
  8025c4:	39 f7                	cmp    %esi,%edi
  8025c6:	77 e8                	ja     8025b0 <__udivdi3+0x50>
  8025c8:	0f bd cf             	bsr    %edi,%ecx
  8025cb:	83 f1 1f             	xor    $0x1f,%ecx
  8025ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025d2:	75 2c                	jne    802600 <__udivdi3+0xa0>
  8025d4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8025d8:	76 04                	jbe    8025de <__udivdi3+0x7e>
  8025da:	39 f7                	cmp    %esi,%edi
  8025dc:	73 d2                	jae    8025b0 <__udivdi3+0x50>
  8025de:	31 d2                	xor    %edx,%edx
  8025e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e5:	eb c9                	jmp    8025b0 <__udivdi3+0x50>
  8025e7:	90                   	nop
  8025e8:	89 f2                	mov    %esi,%edx
  8025ea:	f7 f1                	div    %ecx
  8025ec:	31 d2                	xor    %edx,%edx
  8025ee:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025f2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025f6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025fa:	83 c4 1c             	add    $0x1c,%esp
  8025fd:	c3                   	ret    
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802605:	b8 20 00 00 00       	mov    $0x20,%eax
  80260a:	89 ea                	mov    %ebp,%edx
  80260c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802610:	d3 e7                	shl    %cl,%edi
  802612:	89 c1                	mov    %eax,%ecx
  802614:	d3 ea                	shr    %cl,%edx
  802616:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261b:	09 fa                	or     %edi,%edx
  80261d:	89 f7                	mov    %esi,%edi
  80261f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802623:	89 f2                	mov    %esi,%edx
  802625:	8b 74 24 08          	mov    0x8(%esp),%esi
  802629:	d3 e5                	shl    %cl,%ebp
  80262b:	89 c1                	mov    %eax,%ecx
  80262d:	d3 ef                	shr    %cl,%edi
  80262f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802634:	d3 e2                	shl    %cl,%edx
  802636:	89 c1                	mov    %eax,%ecx
  802638:	d3 ee                	shr    %cl,%esi
  80263a:	09 d6                	or     %edx,%esi
  80263c:	89 fa                	mov    %edi,%edx
  80263e:	89 f0                	mov    %esi,%eax
  802640:	f7 74 24 0c          	divl   0xc(%esp)
  802644:	89 d7                	mov    %edx,%edi
  802646:	89 c6                	mov    %eax,%esi
  802648:	f7 e5                	mul    %ebp
  80264a:	39 d7                	cmp    %edx,%edi
  80264c:	72 22                	jb     802670 <__udivdi3+0x110>
  80264e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802652:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802657:	d3 e5                	shl    %cl,%ebp
  802659:	39 c5                	cmp    %eax,%ebp
  80265b:	73 04                	jae    802661 <__udivdi3+0x101>
  80265d:	39 d7                	cmp    %edx,%edi
  80265f:	74 0f                	je     802670 <__udivdi3+0x110>
  802661:	89 f0                	mov    %esi,%eax
  802663:	31 d2                	xor    %edx,%edx
  802665:	e9 46 ff ff ff       	jmp    8025b0 <__udivdi3+0x50>
  80266a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802670:	8d 46 ff             	lea    -0x1(%esi),%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	8b 74 24 10          	mov    0x10(%esp),%esi
  802679:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80267d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802681:	83 c4 1c             	add    $0x1c,%esp
  802684:	c3                   	ret    
	...

00802690 <__umoddi3>:
  802690:	83 ec 1c             	sub    $0x1c,%esp
  802693:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802697:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80269b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80269f:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026a3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026a7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026ab:	85 ed                	test   %ebp,%ebp
  8026ad:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8026b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b5:	89 cf                	mov    %ecx,%edi
  8026b7:	89 04 24             	mov    %eax,(%esp)
  8026ba:	89 f2                	mov    %esi,%edx
  8026bc:	75 1a                	jne    8026d8 <__umoddi3+0x48>
  8026be:	39 f1                	cmp    %esi,%ecx
  8026c0:	76 4e                	jbe    802710 <__umoddi3+0x80>
  8026c2:	f7 f1                	div    %ecx
  8026c4:	89 d0                	mov    %edx,%eax
  8026c6:	31 d2                	xor    %edx,%edx
  8026c8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026cc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026d0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026d4:	83 c4 1c             	add    $0x1c,%esp
  8026d7:	c3                   	ret    
  8026d8:	39 f5                	cmp    %esi,%ebp
  8026da:	77 54                	ja     802730 <__umoddi3+0xa0>
  8026dc:	0f bd c5             	bsr    %ebp,%eax
  8026df:	83 f0 1f             	xor    $0x1f,%eax
  8026e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e6:	75 60                	jne    802748 <__umoddi3+0xb8>
  8026e8:	3b 0c 24             	cmp    (%esp),%ecx
  8026eb:	0f 87 07 01 00 00    	ja     8027f8 <__umoddi3+0x168>
  8026f1:	89 f2                	mov    %esi,%edx
  8026f3:	8b 34 24             	mov    (%esp),%esi
  8026f6:	29 ce                	sub    %ecx,%esi
  8026f8:	19 ea                	sbb    %ebp,%edx
  8026fa:	89 34 24             	mov    %esi,(%esp)
  8026fd:	8b 04 24             	mov    (%esp),%eax
  802700:	8b 74 24 10          	mov    0x10(%esp),%esi
  802704:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802708:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80270c:	83 c4 1c             	add    $0x1c,%esp
  80270f:	c3                   	ret    
  802710:	85 c9                	test   %ecx,%ecx
  802712:	75 0b                	jne    80271f <__umoddi3+0x8f>
  802714:	b8 01 00 00 00       	mov    $0x1,%eax
  802719:	31 d2                	xor    %edx,%edx
  80271b:	f7 f1                	div    %ecx
  80271d:	89 c1                	mov    %eax,%ecx
  80271f:	89 f0                	mov    %esi,%eax
  802721:	31 d2                	xor    %edx,%edx
  802723:	f7 f1                	div    %ecx
  802725:	8b 04 24             	mov    (%esp),%eax
  802728:	f7 f1                	div    %ecx
  80272a:	eb 98                	jmp    8026c4 <__umoddi3+0x34>
  80272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 f2                	mov    %esi,%edx
  802732:	8b 74 24 10          	mov    0x10(%esp),%esi
  802736:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80273a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80273e:	83 c4 1c             	add    $0x1c,%esp
  802741:	c3                   	ret    
  802742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802748:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80274d:	89 e8                	mov    %ebp,%eax
  80274f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802754:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 e0                	shl    %cl,%eax
  80275c:	89 e9                	mov    %ebp,%ecx
  80275e:	d3 ea                	shr    %cl,%edx
  802760:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802765:	09 c2                	or     %eax,%edx
  802767:	8b 44 24 08          	mov    0x8(%esp),%eax
  80276b:	89 14 24             	mov    %edx,(%esp)
  80276e:	89 f2                	mov    %esi,%edx
  802770:	d3 e7                	shl    %cl,%edi
  802772:	89 e9                	mov    %ebp,%ecx
  802774:	d3 ea                	shr    %cl,%edx
  802776:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80277b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80277f:	d3 e6                	shl    %cl,%esi
  802781:	89 e9                	mov    %ebp,%ecx
  802783:	d3 e8                	shr    %cl,%eax
  802785:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80278a:	09 f0                	or     %esi,%eax
  80278c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802790:	f7 34 24             	divl   (%esp)
  802793:	d3 e6                	shl    %cl,%esi
  802795:	89 74 24 08          	mov    %esi,0x8(%esp)
  802799:	89 d6                	mov    %edx,%esi
  80279b:	f7 e7                	mul    %edi
  80279d:	39 d6                	cmp    %edx,%esi
  80279f:	89 c1                	mov    %eax,%ecx
  8027a1:	89 d7                	mov    %edx,%edi
  8027a3:	72 3f                	jb     8027e4 <__umoddi3+0x154>
  8027a5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8027a9:	72 35                	jb     8027e0 <__umoddi3+0x150>
  8027ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027af:	29 c8                	sub    %ecx,%eax
  8027b1:	19 fe                	sbb    %edi,%esi
  8027b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027b8:	89 f2                	mov    %esi,%edx
  8027ba:	d3 e8                	shr    %cl,%eax
  8027bc:	89 e9                	mov    %ebp,%ecx
  8027be:	d3 e2                	shl    %cl,%edx
  8027c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027c5:	09 d0                	or     %edx,%eax
  8027c7:	89 f2                	mov    %esi,%edx
  8027c9:	d3 ea                	shr    %cl,%edx
  8027cb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027cf:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027d3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027d7:	83 c4 1c             	add    $0x1c,%esp
  8027da:	c3                   	ret    
  8027db:	90                   	nop
  8027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e0:	39 d6                	cmp    %edx,%esi
  8027e2:	75 c7                	jne    8027ab <__umoddi3+0x11b>
  8027e4:	89 d7                	mov    %edx,%edi
  8027e6:	89 c1                	mov    %eax,%ecx
  8027e8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8027ec:	1b 3c 24             	sbb    (%esp),%edi
  8027ef:	eb ba                	jmp    8027ab <__umoddi3+0x11b>
  8027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	39 f5                	cmp    %esi,%ebp
  8027fa:	0f 82 f1 fe ff ff    	jb     8026f1 <__umoddi3+0x61>
  802800:	e9 f8 fe ff ff       	jmp    8026fd <__umoddi3+0x6d>
