
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800040:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800044:	c7 04 24 e0 22 80 00 	movl   $0x8022e0,(%esp)
  80004b:	e8 0f 02 00 00       	call   80025f <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  800050:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800057:	00 
  800058:	89 d8                	mov    %ebx,%eax
  80005a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800063:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80006a:	e8 0d 0d 00 00       	call   800d7c <sys_page_alloc>
  80006f:	85 c0                	test   %eax,%eax
  800071:	79 24                	jns    800097 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800073:	89 44 24 10          	mov    %eax,0x10(%esp)
  800077:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007b:	c7 44 24 08 00 23 80 	movl   $0x802300,0x8(%esp)
  800082:	00 
  800083:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80008a:	00 
  80008b:	c7 04 24 ea 22 80 00 	movl   $0x8022ea,(%esp)
  800092:	e8 cd 00 00 00       	call   800164 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800097:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009b:	c7 44 24 08 2c 23 80 	movl   $0x80232c,0x8(%esp)
  8000a2:	00 
  8000a3:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000aa:	00 
  8000ab:	89 1c 24             	mov    %ebx,(%esp)
  8000ae:	e8 49 07 00 00       	call   8007fc <snprintf>
}
  8000b3:	83 c4 24             	add    $0x24,%esp
  8000b6:	5b                   	pop    %ebx
  8000b7:	5d                   	pop    %ebp
  8000b8:	c3                   	ret    

008000b9 <umain>:

void
umain(int argc, char **argv)
{
  8000b9:	55                   	push   %ebp
  8000ba:	89 e5                	mov    %esp,%ebp
  8000bc:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000bf:	c7 04 24 34 00 80 00 	movl   $0x800034,(%esp)
  8000c6:	e8 79 0f 00 00       	call   801044 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000cb:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d2:	de 
  8000d3:	c7 04 24 fc 22 80 00 	movl   $0x8022fc,(%esp)
  8000da:	e8 80 01 00 00       	call   80025f <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000df:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e6:	ca 
  8000e7:	c7 04 24 fc 22 80 00 	movl   $0x8022fc,(%esp)
  8000ee:	e8 6c 01 00 00       	call   80025f <cprintf>
}
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    
  8000f5:	00 00                	add    %al,(%eax)
	...

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80010a:	e8 0d 0c 00 00       	call   800d1c <sys_getenvid>
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 81 ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014e:	e8 ab 11 00 00       	call   8012fe <close_all>
	sys_env_destroy(0);
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 60 0b 00 00       	call   800cbf <sys_env_destroy>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    
  800161:	00 00                	add    %al,(%eax)
	...

00800164 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80016c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800175:	e8 a2 0b 00 00       	call   800d1c <sys_getenvid>
  80017a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800181:	8b 55 08             	mov    0x8(%ebp),%edx
  800184:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800188:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800190:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  800197:	e8 c3 00 00 00       	call   80025f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80019c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a3:	89 04 24             	mov    %eax,(%esp)
  8001a6:	e8 53 00 00 00       	call   8001fe <vcprintf>
	cprintf("\n");
  8001ab:	c7 04 24 ab 27 80 00 	movl   $0x8027ab,(%esp)
  8001b2:	e8 a8 00 00 00       	call   80025f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b7:	cc                   	int3   
  8001b8:	eb fd                	jmp    8001b7 <_panic+0x53>
	...

008001bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	53                   	push   %ebx
  8001c0:	83 ec 14             	sub    $0x14,%esp
  8001c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c6:	8b 03                	mov    (%ebx),%eax
  8001c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cb:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001cf:	83 c0 01             	add    $0x1,%eax
  8001d2:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d9:	75 19                	jne    8001f4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001db:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001e2:	00 
  8001e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 72 0a 00 00       	call   800c60 <sys_cputs>
		b->idx = 0;
  8001ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	83 c4 14             	add    $0x14,%esp
  8001fb:	5b                   	pop    %ebx
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    

008001fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800207:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020e:	00 00 00 
	b.cnt = 0;
  800211:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800218:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	89 44 24 08          	mov    %eax,0x8(%esp)
  800229:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800233:	c7 04 24 bc 01 80 00 	movl   $0x8001bc,(%esp)
  80023a:	e8 9b 01 00 00       	call   8003da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80023f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80024f:	89 04 24             	mov    %eax,(%esp)
  800252:	e8 09 0a 00 00       	call   800c60 <sys_cputs>

	return b.cnt;
}
  800257:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800265:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	8b 45 08             	mov    0x8(%ebp),%eax
  80026f:	89 04 24             	mov    %eax,(%esp)
  800272:	e8 87 ff ff ff       	call   8001fe <vcprintf>
	va_end(ap);

	return cnt;
}
  800277:	c9                   	leave  
  800278:	c3                   	ret    
  800279:	00 00                	add    %al,(%eax)
  80027b:	00 00                	add    %al,(%eax)
  80027d:	00 00                	add    %al,(%eax)
	...

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80029a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80029d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a8:	72 11                	jb     8002bb <printnum+0x3b>
  8002aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ad:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b0:	76 09                	jbe    8002bb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7f 51                	jg     80030a <printnum+0x8a>
  8002b9:	eb 5e                	jmp    800319 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002bb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002bf:	83 eb 01             	sub    $0x1,%ebx
  8002c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8002d1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8002d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002dc:	00 
  8002dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e0:	89 04 24             	mov    %eax,(%esp)
  8002e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ea:	e8 41 1d 00 00       	call   802030 <__udivdi3>
  8002ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002f7:	89 04 24             	mov    %eax,(%esp)
  8002fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fe:	89 fa                	mov    %edi,%edx
  800300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800303:	e8 78 ff ff ff       	call   800280 <printnum>
  800308:	eb 0f                	jmp    800319 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030e:	89 34 24             	mov    %esi,(%esp)
  800311:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800314:	83 eb 01             	sub    $0x1,%ebx
  800317:	75 f1                	jne    80030a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800319:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800321:	8b 45 10             	mov    0x10(%ebp),%eax
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80032f:	00 
  800330:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800333:	89 04 24             	mov    %eax,(%esp)
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033d:	e8 1e 1e 00 00       	call   802160 <__umoddi3>
  800342:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800346:	0f be 80 7b 23 80 00 	movsbl 0x80237b(%eax),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800353:	83 c4 3c             	add    $0x3c,%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035e:	83 fa 01             	cmp    $0x1,%edx
  800361:	7e 0e                	jle    800371 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800363:	8b 10                	mov    (%eax),%edx
  800365:	8d 4a 08             	lea    0x8(%edx),%ecx
  800368:	89 08                	mov    %ecx,(%eax)
  80036a:	8b 02                	mov    (%edx),%eax
  80036c:	8b 52 04             	mov    0x4(%edx),%edx
  80036f:	eb 22                	jmp    800393 <getuint+0x38>
	else if (lflag)
  800371:	85 d2                	test   %edx,%edx
  800373:	74 10                	je     800385 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800375:	8b 10                	mov    (%eax),%edx
  800377:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 02                	mov    (%edx),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	eb 0e                	jmp    800393 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800385:	8b 10                	mov    (%eax),%edx
  800387:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038a:	89 08                	mov    %ecx,(%eax)
  80038c:	8b 02                	mov    (%edx),%eax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039f:	8b 10                	mov    (%eax),%edx
  8003a1:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a4:	73 0a                	jae    8003b0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a9:	88 0a                	mov    %cl,(%edx)
  8003ab:	83 c2 01             	add    $0x1,%edx
  8003ae:	89 10                	mov    %edx,(%eax)
}
  8003b0:	5d                   	pop    %ebp
  8003b1:	c3                   	ret    

008003b2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	89 04 24             	mov    %eax,(%esp)
  8003d3:	e8 02 00 00 00       	call   8003da <vprintfmt>
	va_end(ap);
}
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 4c             	sub    $0x4c,%esp
  8003e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e6:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e9:	eb 12                	jmp    8003fd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	0f 84 a9 03 00 00    	je     80079c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8003f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003f7:	89 04 24             	mov    %eax,(%esp)
  8003fa:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003fd:	0f b6 06             	movzbl (%esi),%eax
  800400:	83 c6 01             	add    $0x1,%esi
  800403:	83 f8 25             	cmp    $0x25,%eax
  800406:	75 e3                	jne    8003eb <vprintfmt+0x11>
  800408:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80040c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800413:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800418:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80041f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800424:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800427:	eb 2b                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800429:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80042c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800430:	eb 22                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800435:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800439:	eb 19                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80043e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800445:	eb 0d                	jmp    800454 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800447:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80044a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800454:	0f b6 06             	movzbl (%esi),%eax
  800457:	0f b6 d0             	movzbl %al,%edx
  80045a:	8d 7e 01             	lea    0x1(%esi),%edi
  80045d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800460:	83 e8 23             	sub    $0x23,%eax
  800463:	3c 55                	cmp    $0x55,%al
  800465:	0f 87 0b 03 00 00    	ja     800776 <vprintfmt+0x39c>
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800475:	83 ea 30             	sub    $0x30,%edx
  800478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80047b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80047f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800485:	83 fa 09             	cmp    $0x9,%edx
  800488:	77 4a                	ja     8004d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80048d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800490:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800493:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800497:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80049d:	83 fa 09             	cmp    $0x9,%edx
  8004a0:	76 eb                	jbe    80048d <vprintfmt+0xb3>
  8004a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a5:	eb 2d                	jmp    8004d4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 1a                	jmp    8004d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8004bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c1:	79 91                	jns    800454 <vprintfmt+0x7a>
  8004c3:	e9 73 ff ff ff       	jmp    80043b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004d2:	eb 80                	jmp    800454 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8004d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d8:	0f 89 76 ff ff ff    	jns    800454 <vprintfmt+0x7a>
  8004de:	e9 64 ff ff ff       	jmp    800447 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004e9:	e9 66 ff ff ff       	jmp    800454 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	8d 50 04             	lea    0x4(%eax),%edx
  8004f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800503:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800506:	e9 f2 fe ff ff       	jmp    8003fd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 c2                	mov    %eax,%edx
  800518:	c1 fa 1f             	sar    $0x1f,%edx
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 0f             	cmp    $0xf,%eax
  800522:	7f 0b                	jg     80052f <vprintfmt+0x155>
  800524:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  80052b:	85 d2                	test   %edx,%edx
  80052d:	75 23                	jne    800552 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80052f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800533:	c7 44 24 08 93 23 80 	movl   $0x802393,0x8(%esp)
  80053a:	00 
  80053b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80053f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800542:	89 3c 24             	mov    %edi,(%esp)
  800545:	e8 68 fe ff ff       	call   8003b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80054d:	e9 ab fe ff ff       	jmp    8003fd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800552:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800556:	c7 44 24 08 79 27 80 	movl   $0x802779,0x8(%esp)
  80055d:	00 
  80055e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800562:	8b 7d 08             	mov    0x8(%ebp),%edi
  800565:	89 3c 24             	mov    %edi,(%esp)
  800568:	e8 45 fe ff ff       	call   8003b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800570:	e9 88 fe ff ff       	jmp    8003fd <vprintfmt+0x23>
  800575:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80057b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8d 50 04             	lea    0x4(%eax),%edx
  800584:	89 55 14             	mov    %edx,0x14(%ebp)
  800587:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800589:	85 f6                	test   %esi,%esi
  80058b:	ba 8c 23 80 00       	mov    $0x80238c,%edx
  800590:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800593:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x1c5>
  800599:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80059d:	75 10                	jne    8005af <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059f:	0f be 06             	movsbl (%esi),%eax
  8005a2:	83 c6 01             	add    $0x1,%esi
  8005a5:	85 c0                	test   %eax,%eax
  8005a7:	0f 85 86 00 00 00    	jne    800633 <vprintfmt+0x259>
  8005ad:	eb 76                	jmp    800625 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005af:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b3:	89 34 24             	mov    %esi,(%esp)
  8005b6:	e8 90 02 00 00       	call   80084b <strnlen>
  8005bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c3:	85 d2                	test   %edx,%edx
  8005c5:	7e d8                	jle    80059f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005ce:	89 d6                	mov    %edx,%esi
  8005d0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8005d3:	89 c7                	mov    %eax,%edi
  8005d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d9:	89 3c 24             	mov    %edi,(%esp)
  8005dc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 ee 01             	sub    $0x1,%esi
  8005e2:	75 f1                	jne    8005d5 <vprintfmt+0x1fb>
  8005e4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005e7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8005ea:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8005ed:	eb b0                	jmp    80059f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	74 18                	je     80060d <vprintfmt+0x233>
  8005f5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005f8:	83 fa 5e             	cmp    $0x5e,%edx
  8005fb:	76 10                	jbe    80060d <vprintfmt+0x233>
					putch('?', putdat);
  8005fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800601:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800608:	ff 55 08             	call   *0x8(%ebp)
  80060b:	eb 0a                	jmp    800617 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80060d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800611:	89 04 24             	mov    %eax,(%esp)
  800614:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800617:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80061b:	0f be 06             	movsbl (%esi),%eax
  80061e:	83 c6 01             	add    $0x1,%esi
  800621:	85 c0                	test   %eax,%eax
  800623:	75 0e                	jne    800633 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800628:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062c:	7f 16                	jg     800644 <vprintfmt+0x26a>
  80062e:	e9 ca fd ff ff       	jmp    8003fd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800633:	85 ff                	test   %edi,%edi
  800635:	78 b8                	js     8005ef <vprintfmt+0x215>
  800637:	83 ef 01             	sub    $0x1,%edi
  80063a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800640:	79 ad                	jns    8005ef <vprintfmt+0x215>
  800642:	eb e1                	jmp    800625 <vprintfmt+0x24b>
  800644:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800647:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80064a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80064e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800655:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800657:	83 ee 01             	sub    $0x1,%esi
  80065a:	75 ee                	jne    80064a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80065f:	e9 99 fd ff ff       	jmp    8003fd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800664:	83 f9 01             	cmp    $0x1,%ecx
  800667:	7e 10                	jle    800679 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 50 08             	lea    0x8(%eax),%edx
  80066f:	89 55 14             	mov    %edx,0x14(%ebp)
  800672:	8b 30                	mov    (%eax),%esi
  800674:	8b 78 04             	mov    0x4(%eax),%edi
  800677:	eb 26                	jmp    80069f <vprintfmt+0x2c5>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	74 12                	je     80068f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)
  800686:	8b 30                	mov    (%eax),%esi
  800688:	89 f7                	mov    %esi,%edi
  80068a:	c1 ff 1f             	sar    $0x1f,%edi
  80068d:	eb 10                	jmp    80069f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 30                	mov    (%eax),%esi
  80069a:	89 f7                	mov    %esi,%edi
  80069c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006a4:	85 ff                	test   %edi,%edi
  8006a6:	0f 89 8c 00 00 00    	jns    800738 <vprintfmt+0x35e>
				putch('-', putdat);
  8006ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006b7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ba:	f7 de                	neg    %esi
  8006bc:	83 d7 00             	adc    $0x0,%edi
  8006bf:	f7 df                	neg    %edi
			}
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	eb 70                	jmp    800738 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006c8:	89 ca                	mov    %ecx,%edx
  8006ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8006cd:	e8 89 fc ff ff       	call   80035b <getuint>
  8006d2:	89 c6                	mov    %eax,%esi
  8006d4:	89 d7                	mov    %edx,%edi
			base = 10;
  8006d6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006db:	eb 5b                	jmp    800738 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006dd:	89 ca                	mov    %ecx,%edx
  8006df:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e2:	e8 74 fc ff ff       	call   80035b <getuint>
  8006e7:	89 c6                	mov    %eax,%esi
  8006e9:	89 d7                	mov    %edx,%edi
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006f0:	eb 46                	jmp    800738 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8006f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800700:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800704:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800717:	8b 30                	mov    (%eax),%esi
  800719:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80071e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800723:	eb 13                	jmp    800738 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800725:	89 ca                	mov    %ecx,%edx
  800727:	8d 45 14             	lea    0x14(%ebp),%eax
  80072a:	e8 2c fc ff ff       	call   80035b <getuint>
  80072f:	89 c6                	mov    %eax,%esi
  800731:	89 d7                	mov    %edx,%edi
			base = 16;
  800733:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800738:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80073c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800743:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800747:	89 44 24 08          	mov    %eax,0x8(%esp)
  80074b:	89 34 24             	mov    %esi,(%esp)
  80074e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800752:	89 da                	mov    %ebx,%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	e8 24 fb ff ff       	call   800280 <printnum>
			break;
  80075c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80075f:	e9 99 fc ff ff       	jmp    8003fd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800764:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800768:	89 14 24             	mov    %edx,(%esp)
  80076b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800771:	e9 87 fc ff ff       	jmp    8003fd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800776:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80077a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800781:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800784:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800788:	0f 84 6f fc ff ff    	je     8003fd <vprintfmt+0x23>
  80078e:	83 ee 01             	sub    $0x1,%esi
  800791:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800795:	75 f7                	jne    80078e <vprintfmt+0x3b4>
  800797:	e9 61 fc ff ff       	jmp    8003fd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80079c:	83 c4 4c             	add    $0x4c,%esp
  80079f:	5b                   	pop    %ebx
  8007a0:	5e                   	pop    %esi
  8007a1:	5f                   	pop    %edi
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 28             	sub    $0x28,%esp
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c1:	85 c0                	test   %eax,%eax
  8007c3:	74 30                	je     8007f5 <vsnprintf+0x51>
  8007c5:	85 d2                	test   %edx,%edx
  8007c7:	7e 2c                	jle    8007f5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007de:	c7 04 24 95 03 80 00 	movl   $0x800395,(%esp)
  8007e5:	e8 f0 fb ff ff       	call   8003da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f3:	eb 05                	jmp    8007fa <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800805:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
  80080c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800810:	8b 45 0c             	mov    0xc(%ebp),%eax
  800813:	89 44 24 04          	mov    %eax,0x4(%esp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	89 04 24             	mov    %eax,(%esp)
  80081d:	e8 82 ff ff ff       	call   8007a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800822:	c9                   	leave  
  800823:	c3                   	ret    
	...

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	80 3a 00             	cmpb   $0x0,(%edx)
  80083e:	74 09                	je     800849 <strlen+0x19>
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <strlen+0x10>
		n++;
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	85 c9                	test   %ecx,%ecx
  80085c:	74 1a                	je     800878 <strnlen+0x2d>
  80085e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800861:	74 15                	je     800878 <strnlen+0x2d>
  800863:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800868:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086a:	39 ca                	cmp    %ecx,%edx
  80086c:	74 0a                	je     800878 <strnlen+0x2d>
  80086e:	83 c2 01             	add    $0x1,%edx
  800871:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800876:	75 f0                	jne    800868 <strnlen+0x1d>
		n++;
	return n;
}
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800885:	ba 00 00 00 00       	mov    $0x0,%edx
  80088a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80088e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800891:	83 c2 01             	add    $0x1,%edx
  800894:	84 c9                	test   %cl,%cl
  800896:	75 f2                	jne    80088a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800898:	5b                   	pop    %ebx
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	53                   	push   %ebx
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a5:	89 1c 24             	mov    %ebx,(%esp)
  8008a8:	e8 83 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	89 04 24             	mov    %eax,(%esp)
  8008b9:	e8 bd ff ff ff       	call   80087b <strcpy>
	return dst;
}
  8008be:	89 d8                	mov    %ebx,%eax
  8008c0:	83 c4 08             	add    $0x8,%esp
  8008c3:	5b                   	pop    %ebx
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d4:	85 f6                	test   %esi,%esi
  8008d6:	74 18                	je     8008f0 <strncpy+0x2a>
  8008d8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008dd:	0f b6 1a             	movzbl (%edx),%ebx
  8008e0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e3:	80 3a 01             	cmpb   $0x1,(%edx)
  8008e6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	39 f1                	cmp    %esi,%ecx
  8008ee:	75 ed                	jne    8008dd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	57                   	push   %edi
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800900:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	89 f8                	mov    %edi,%eax
  800905:	85 f6                	test   %esi,%esi
  800907:	74 2b                	je     800934 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800909:	83 fe 01             	cmp    $0x1,%esi
  80090c:	74 23                	je     800931 <strlcpy+0x3d>
  80090e:	0f b6 0b             	movzbl (%ebx),%ecx
  800911:	84 c9                	test   %cl,%cl
  800913:	74 1c                	je     800931 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800915:	83 ee 02             	sub    $0x2,%esi
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80091d:	88 08                	mov    %cl,(%eax)
  80091f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800922:	39 f2                	cmp    %esi,%edx
  800924:	74 0b                	je     800931 <strlcpy+0x3d>
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80092d:	84 c9                	test   %cl,%cl
  80092f:	75 ec                	jne    80091d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800931:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800934:	29 f8                	sub    %edi,%eax
}
  800936:	5b                   	pop    %ebx
  800937:	5e                   	pop    %esi
  800938:	5f                   	pop    %edi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800944:	0f b6 01             	movzbl (%ecx),%eax
  800947:	84 c0                	test   %al,%al
  800949:	74 16                	je     800961 <strcmp+0x26>
  80094b:	3a 02                	cmp    (%edx),%al
  80094d:	75 12                	jne    800961 <strcmp+0x26>
		p++, q++;
  80094f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800952:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800956:	84 c0                	test   %al,%al
  800958:	74 07                	je     800961 <strcmp+0x26>
  80095a:	83 c1 01             	add    $0x1,%ecx
  80095d:	3a 02                	cmp    (%edx),%al
  80095f:	74 ee                	je     80094f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800961:	0f b6 c0             	movzbl %al,%eax
  800964:	0f b6 12             	movzbl (%edx),%edx
  800967:	29 d0                	sub    %edx,%eax
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800975:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80097d:	85 d2                	test   %edx,%edx
  80097f:	74 28                	je     8009a9 <strncmp+0x3e>
  800981:	0f b6 01             	movzbl (%ecx),%eax
  800984:	84 c0                	test   %al,%al
  800986:	74 24                	je     8009ac <strncmp+0x41>
  800988:	3a 03                	cmp    (%ebx),%al
  80098a:	75 20                	jne    8009ac <strncmp+0x41>
  80098c:	83 ea 01             	sub    $0x1,%edx
  80098f:	74 13                	je     8009a4 <strncmp+0x39>
		n--, p++, q++;
  800991:	83 c1 01             	add    $0x1,%ecx
  800994:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800997:	0f b6 01             	movzbl (%ecx),%eax
  80099a:	84 c0                	test   %al,%al
  80099c:	74 0e                	je     8009ac <strncmp+0x41>
  80099e:	3a 03                	cmp    (%ebx),%al
  8009a0:	74 ea                	je     80098c <strncmp+0x21>
  8009a2:	eb 08                	jmp    8009ac <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ac:	0f b6 01             	movzbl (%ecx),%eax
  8009af:	0f b6 13             	movzbl (%ebx),%edx
  8009b2:	29 d0                	sub    %edx,%eax
  8009b4:	eb f3                	jmp    8009a9 <strncmp+0x3e>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c0:	0f b6 10             	movzbl (%eax),%edx
  8009c3:	84 d2                	test   %dl,%dl
  8009c5:	74 1c                	je     8009e3 <strchr+0x2d>
		if (*s == c)
  8009c7:	38 ca                	cmp    %cl,%dl
  8009c9:	75 09                	jne    8009d4 <strchr+0x1e>
  8009cb:	eb 1b                	jmp    8009e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009cd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8009d0:	38 ca                	cmp    %cl,%dl
  8009d2:	74 14                	je     8009e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009d4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8009d8:	84 d2                	test   %dl,%dl
  8009da:	75 f1                	jne    8009cd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	eb 05                	jmp    8009e8 <strchr+0x32>
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	0f b6 10             	movzbl (%eax),%edx
  8009f7:	84 d2                	test   %dl,%dl
  8009f9:	74 14                	je     800a0f <strfind+0x25>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	75 06                	jne    800a05 <strfind+0x1b>
  8009ff:	eb 0e                	jmp    800a0f <strfind+0x25>
  800a01:	38 ca                	cmp    %cl,%dl
  800a03:	74 0a                	je     800a0f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	0f b6 10             	movzbl (%eax),%edx
  800a0b:	84 d2                	test   %dl,%dl
  800a0d:	75 f2                	jne    800a01 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 0c             	sub    $0xc,%esp
  800a17:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a1a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a1d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a20:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	74 30                	je     800a5d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a33:	75 25                	jne    800a5a <memset+0x49>
  800a35:	f6 c1 03             	test   $0x3,%cl
  800a38:	75 20                	jne    800a5a <memset+0x49>
		c &= 0xFF;
  800a3a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a3d:	89 d3                	mov    %edx,%ebx
  800a3f:	c1 e3 08             	shl    $0x8,%ebx
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	c1 e6 18             	shl    $0x18,%esi
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	c1 e0 10             	shl    $0x10,%eax
  800a4c:	09 f0                	or     %esi,%eax
  800a4e:	09 d0                	or     %edx,%eax
  800a50:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a52:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a55:	fc                   	cld    
  800a56:	f3 ab                	rep stos %eax,%es:(%edi)
  800a58:	eb 03                	jmp    800a5d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a68:	89 ec                	mov    %ebp,%esp
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a75:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a81:	39 c6                	cmp    %eax,%esi
  800a83:	73 36                	jae    800abb <memmove+0x4f>
  800a85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a88:	39 d0                	cmp    %edx,%eax
  800a8a:	73 2f                	jae    800abb <memmove+0x4f>
		s += n;
		d += n;
  800a8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f6 c2 03             	test   $0x3,%dl
  800a92:	75 1b                	jne    800aaf <memmove+0x43>
  800a94:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9a:	75 13                	jne    800aaf <memmove+0x43>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 20                	jmp    800adb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac1:	75 13                	jne    800ad6 <memmove+0x6a>
  800ac3:	a8 03                	test   $0x3,%al
  800ac5:	75 0f                	jne    800ad6 <memmove+0x6a>
  800ac7:	f6 c1 03             	test   $0x3,%cl
  800aca:	75 0a                	jne    800ad6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800acc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acf:	89 c7                	mov    %eax,%edi
  800ad1:	fc                   	cld    
  800ad2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad4:	eb 05                	jmp    800adb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad6:	89 c7                	mov    %eax,%edi
  800ad8:	fc                   	cld    
  800ad9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800adb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ade:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ae1:	89 ec                	mov    %ebp,%esp
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	89 04 24             	mov    %eax,(%esp)
  800aff:	e8 68 ff ff ff       	call   800a6c <memmove>
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b12:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1a:	85 ff                	test   %edi,%edi
  800b1c:	74 37                	je     800b55 <memcmp+0x4f>
		if (*s1 != *s2)
  800b1e:	0f b6 03             	movzbl (%ebx),%eax
  800b21:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b24:	83 ef 01             	sub    $0x1,%edi
  800b27:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b2c:	38 c8                	cmp    %cl,%al
  800b2e:	74 1c                	je     800b4c <memcmp+0x46>
  800b30:	eb 10                	jmp    800b42 <memcmp+0x3c>
  800b32:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b3e:	38 c8                	cmp    %cl,%al
  800b40:	74 0a                	je     800b4c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800b42:	0f b6 c0             	movzbl %al,%eax
  800b45:	0f b6 c9             	movzbl %cl,%ecx
  800b48:	29 c8                	sub    %ecx,%eax
  800b4a:	eb 09                	jmp    800b55 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4c:	39 fa                	cmp    %edi,%edx
  800b4e:	75 e2                	jne    800b32 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b65:	39 d0                	cmp    %edx,%eax
  800b67:	73 19                	jae    800b82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b6d:	38 08                	cmp    %cl,(%eax)
  800b6f:	75 06                	jne    800b77 <memfind+0x1d>
  800b71:	eb 0f                	jmp    800b82 <memfind+0x28>
  800b73:	38 08                	cmp    %cl,(%eax)
  800b75:	74 0b                	je     800b82 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b77:	83 c0 01             	add    $0x1,%eax
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b80:	75 f1                	jne    800b73 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b90:	0f b6 02             	movzbl (%edx),%eax
  800b93:	3c 20                	cmp    $0x20,%al
  800b95:	74 04                	je     800b9b <strtol+0x17>
  800b97:	3c 09                	cmp    $0x9,%al
  800b99:	75 0e                	jne    800ba9 <strtol+0x25>
		s++;
  800b9b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 02             	movzbl (%edx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0x17>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	75 0a                	jne    800bb7 <strtol+0x33>
		s++;
  800bad:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb5:	eb 10                	jmp    800bc7 <strtol+0x43>
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bbc:	3c 2d                	cmp    $0x2d,%al
  800bbe:	75 07                	jne    800bc7 <strtol+0x43>
		s++, neg = 1;
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	0f 94 c0             	sete   %al
  800bcc:	74 05                	je     800bd3 <strtol+0x4f>
  800bce:	83 fb 10             	cmp    $0x10,%ebx
  800bd1:	75 15                	jne    800be8 <strtol+0x64>
  800bd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd6:	75 10                	jne    800be8 <strtol+0x64>
  800bd8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bdc:	75 0a                	jne    800be8 <strtol+0x64>
		s += 2, base = 16;
  800bde:	83 c2 02             	add    $0x2,%edx
  800be1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be6:	eb 13                	jmp    800bfb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800be8:	84 c0                	test   %al,%al
  800bea:	74 0f                	je     800bfb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bec:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf1:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf4:	75 05                	jne    800bfb <strtol+0x77>
		s++, base = 8;
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c02:	0f b6 0a             	movzbl (%edx),%ecx
  800c05:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c08:	80 fb 09             	cmp    $0x9,%bl
  800c0b:	77 08                	ja     800c15 <strtol+0x91>
			dig = *s - '0';
  800c0d:	0f be c9             	movsbl %cl,%ecx
  800c10:	83 e9 30             	sub    $0x30,%ecx
  800c13:	eb 1e                	jmp    800c33 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c15:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 08                	ja     800c25 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c1d:	0f be c9             	movsbl %cl,%ecx
  800c20:	83 e9 57             	sub    $0x57,%ecx
  800c23:	eb 0e                	jmp    800c33 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c25:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c28:	80 fb 19             	cmp    $0x19,%bl
  800c2b:	77 14                	ja     800c41 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c2d:	0f be c9             	movsbl %cl,%ecx
  800c30:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c33:	39 f1                	cmp    %esi,%ecx
  800c35:	7d 0e                	jge    800c45 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c37:	83 c2 01             	add    $0x1,%edx
  800c3a:	0f af c6             	imul   %esi,%eax
  800c3d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c3f:	eb c1                	jmp    800c02 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c41:	89 c1                	mov    %eax,%ecx
  800c43:	eb 02                	jmp    800c47 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c45:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4b:	74 05                	je     800c52 <strtol+0xce>
		*endptr = (char *) s;
  800c4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c50:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c52:	89 ca                	mov    %ecx,%edx
  800c54:	f7 da                	neg    %edx
  800c56:	85 ff                	test   %edi,%edi
  800c58:	0f 45 c2             	cmovne %edx,%eax
}
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	89 c3                	mov    %eax,%ebx
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	89 c6                	mov    %eax,%esi
  800c80:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c8b:	89 ec                	mov    %ebp,%esp
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca8:	89 d1                	mov    %edx,%ecx
  800caa:	89 d3                	mov    %edx,%ebx
  800cac:	89 d7                	mov    %edx,%edi
  800cae:	89 d6                	mov    %edx,%esi
  800cb0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cbb:	89 ec                	mov    %ebp,%esp
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 38             	sub    $0x38,%esp
  800cc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ccb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	89 cb                	mov    %ecx,%ebx
  800cdd:	89 cf                	mov    %ecx,%edi
  800cdf:	89 ce                	mov    %ecx,%esi
  800ce1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7e 28                	jle    800d0f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ceb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800d0a:	e8 55 f4 ff ff       	call   800164 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d18:	89 ec                	mov    %ebp,%esp
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d48:	89 ec                	mov    %ebp,%esp
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_yield>:

void
sys_yield(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d78:	89 ec                	mov    %ebp,%esp
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 38             	sub    $0x38,%esp
  800d82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	be 00 00 00 00       	mov    $0x0,%esi
  800d90:	b8 04 00 00 00       	mov    $0x4,%eax
  800d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	89 f7                	mov    %esi,%edi
  800da0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800dc9:	e8 96 f3 ff ff       	call   800164 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd7:	89 ec                	mov    %ebp,%esp
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	83 ec 38             	sub    $0x38,%esp
  800de1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dea:	b8 05 00 00 00       	mov    $0x5,%eax
  800def:	8b 75 18             	mov    0x18(%ebp),%esi
  800df2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e00:	85 c0                	test   %eax,%eax
  800e02:	7e 28                	jle    800e2c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e08:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e0f:	00 
  800e10:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800e17:	00 
  800e18:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1f:	00 
  800e20:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800e27:	e8 38 f3 ff ff       	call   800164 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e2c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e2f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e32:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e35:	89 ec                	mov    %ebp,%esp
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 38             	sub    $0x38,%esp
  800e3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e45:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7e 28                	jle    800e8a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e66:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e6d:	00 
  800e6e:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800e75:	00 
  800e76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7d:	00 
  800e7e:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800e85:	e8 da f2 ff ff       	call   800164 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e93:	89 ec                	mov    %ebp,%esp
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 38             	sub    $0x38,%esp
  800e9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7e 28                	jle    800ee8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ecb:	00 
  800ecc:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edb:	00 
  800edc:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800ee3:	e8 7c f2 ff ff       	call   800164 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eeb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef1:	89 ec                	mov    %ebp,%esp
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 38             	sub    $0x38,%esp
  800efb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f09:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	89 df                	mov    %ebx,%edi
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	7e 28                	jle    800f46 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f22:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f29:	00 
  800f2a:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800f31:	00 
  800f32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f39:	00 
  800f3a:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800f41:	e8 1e f2 ff ff       	call   800164 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4f:	89 ec                	mov    %ebp,%esp
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 38             	sub    $0x38,%esp
  800f59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 df                	mov    %ebx,%edi
  800f74:	89 de                	mov    %ebx,%esi
  800f76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7e 28                	jle    800fa4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f80:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f87:	00 
  800f88:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800f9f:	e8 c0 f1 ff ff       	call   800164 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800faa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fad:	89 ec                	mov    %ebp,%esp
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc0:	be 00 00 00 00       	mov    $0x0,%esi
  800fc5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fdb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fde:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe1:	89 ec                	mov    %ebp,%esp
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 38             	sub    $0x38,%esp
  800feb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  801001:	89 cb                	mov    %ecx,%ebx
  801003:	89 cf                	mov    %ecx,%edi
  801005:	89 ce                	mov    %ecx,%esi
  801007:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7e 28                	jle    801035 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801011:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801018:	00 
  801019:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  801020:	00 
  801021:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801028:	00 
  801029:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  801030:	e8 2f f1 ff ff       	call   800164 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801035:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801038:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80103b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80103e:	89 ec                	mov    %ebp,%esp
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    
	...

00801044 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80104a:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801051:	75 54                	jne    8010a7 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  801053:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80105a:	00 
  80105b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801062:	ee 
  801063:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80106a:	e8 0d fd ff ff       	call   800d7c <sys_page_alloc>
  80106f:	85 c0                	test   %eax,%eax
  801071:	79 20                	jns    801093 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  801073:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801077:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80107e:	00 
  80107f:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801086:	00 
  801087:	c7 04 24 c2 26 80 00 	movl   $0x8026c2,(%esp)
  80108e:	e8 d1 f0 ff ff       	call   800164 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801093:	c7 44 24 04 b4 10 80 	movl   $0x8010b4,0x4(%esp)
  80109a:	00 
  80109b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010a2:	e8 ac fe ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	a3 08 40 80 00       	mov    %eax,0x804008
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    
  8010b1:	00 00                	add    %al,(%eax)
	...

008010b4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010b4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010b5:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  8010ba:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010bc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8010bf:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8010c3:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8010c6:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8010ca:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8010ce:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8010d0:	83 c4 08             	add    $0x8,%esp
	popal
  8010d3:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010d4:	83 c4 04             	add    $0x4,%esp
	popfl
  8010d7:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8010d8:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010d9:	c3                   	ret    
  8010da:	00 00                	add    %al,(%eax)
  8010dc:	00 00                	add    %al,(%eax)
	...

008010e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	89 04 24             	mov    %eax,(%esp)
  8010fc:	e8 df ff ff ff       	call   8010e0 <fd2num>
  801101:	05 20 00 0d 00       	add    $0xd0020,%eax
  801106:	c1 e0 0c             	shl    $0xc,%eax
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	53                   	push   %ebx
  80110f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801112:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 34                	je     80114f <fd_alloc+0x44>
  80111b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801120:	a8 01                	test   $0x1,%al
  801122:	74 32                	je     801156 <fd_alloc+0x4b>
  801124:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801129:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	c1 ea 16             	shr    $0x16,%edx
  801130:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801137:	f6 c2 01             	test   $0x1,%dl
  80113a:	74 1f                	je     80115b <fd_alloc+0x50>
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	c1 ea 0c             	shr    $0xc,%edx
  801141:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801148:	f6 c2 01             	test   $0x1,%dl
  80114b:	75 17                	jne    801164 <fd_alloc+0x59>
  80114d:	eb 0c                	jmp    80115b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80114f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801154:	eb 05                	jmp    80115b <fd_alloc+0x50>
  801156:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80115b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
  801162:	eb 17                	jmp    80117b <fd_alloc+0x70>
  801164:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801169:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80116e:	75 b9                	jne    801129 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801170:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801176:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80117b:	5b                   	pop    %ebx
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801184:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801189:	83 fa 1f             	cmp    $0x1f,%edx
  80118c:	77 3f                	ja     8011cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80118e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801194:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801197:	89 d0                	mov    %edx,%eax
  801199:	c1 e8 16             	shr    $0x16,%eax
  80119c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a8:	f6 c1 01             	test   $0x1,%cl
  8011ab:	74 20                	je     8011cd <fd_lookup+0x4f>
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	c1 e8 0c             	shr    $0xc,%eax
  8011b2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011be:	f6 c1 01             	test   $0x1,%cl
  8011c1:	74 0a                	je     8011cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	89 10                	mov    %edx,(%eax)
	return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 14             	sub    $0x14,%esp
  8011d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8011e7:	75 17                	jne    801200 <dev_lookup+0x31>
  8011e9:	eb 07                	jmp    8011f2 <dev_lookup+0x23>
  8011eb:	39 0a                	cmp    %ecx,(%edx)
  8011ed:	75 11                	jne    801200 <dev_lookup+0x31>
  8011ef:	90                   	nop
  8011f0:	eb 05                	jmp    8011f7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011f2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011f7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	eb 35                	jmp    801235 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801200:	83 c0 01             	add    $0x1,%eax
  801203:	8b 14 85 50 27 80 00 	mov    0x802750(,%eax,4),%edx
  80120a:	85 d2                	test   %edx,%edx
  80120c:	75 dd                	jne    8011eb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120e:	a1 04 40 80 00       	mov    0x804004,%eax
  801213:	8b 40 48             	mov    0x48(%eax),%eax
  801216:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80121a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121e:	c7 04 24 d0 26 80 00 	movl   $0x8026d0,(%esp)
  801225:	e8 35 f0 ff ff       	call   80025f <cprintf>
	*dev = 0;
  80122a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801235:	83 c4 14             	add    $0x14,%esp
  801238:	5b                   	pop    %ebx
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 38             	sub    $0x38,%esp
  801241:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801244:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801247:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80124a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80124d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801251:	89 3c 24             	mov    %edi,(%esp)
  801254:	e8 87 fe ff ff       	call   8010e0 <fd2num>
  801259:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80125c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801260:	89 04 24             	mov    %eax,(%esp)
  801263:	e8 16 ff ff ff       	call   80117e <fd_lookup>
  801268:	89 c3                	mov    %eax,%ebx
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 05                	js     801273 <fd_close+0x38>
	    || fd != fd2)
  80126e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801271:	74 0e                	je     801281 <fd_close+0x46>
		return (must_exist ? r : 0);
  801273:	89 f0                	mov    %esi,%eax
  801275:	84 c0                	test   %al,%al
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
  80127c:	0f 44 d8             	cmove  %eax,%ebx
  80127f:	eb 3d                	jmp    8012be <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801281:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	8b 07                	mov    (%edi),%eax
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	e8 3d ff ff ff       	call   8011cf <dev_lookup>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	85 c0                	test   %eax,%eax
  801296:	78 16                	js     8012ae <fd_close+0x73>
		if (dev->dev_close)
  801298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	74 07                	je     8012ae <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8012a7:	89 3c 24             	mov    %edi,(%esp)
  8012aa:	ff d0                	call   *%eax
  8012ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b9:	e8 7b fb ff ff       	call   800e39 <sys_page_unmap>
	return r;
}
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c9:	89 ec                	mov    %ebp,%esp
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	89 04 24             	mov    %eax,(%esp)
  8012e0:	e8 99 fe ff ff       	call   80117e <fd_lookup>
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 13                	js     8012fc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8012e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012f0:	00 
  8012f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f4:	89 04 24             	mov    %eax,(%esp)
  8012f7:	e8 3f ff ff ff       	call   80123b <fd_close>
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <close_all>:

void
close_all(void)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	53                   	push   %ebx
  801302:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801305:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80130a:	89 1c 24             	mov    %ebx,(%esp)
  80130d:	e8 bb ff ff ff       	call   8012cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801312:	83 c3 01             	add    $0x1,%ebx
  801315:	83 fb 20             	cmp    $0x20,%ebx
  801318:	75 f0                	jne    80130a <close_all+0xc>
		close(i);
}
  80131a:	83 c4 14             	add    $0x14,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    

00801320 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 58             	sub    $0x58,%esp
  801326:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801329:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80132c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80132f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801332:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801335:	89 44 24 04          	mov    %eax,0x4(%esp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	89 04 24             	mov    %eax,(%esp)
  80133f:	e8 3a fe ff ff       	call   80117e <fd_lookup>
  801344:	89 c3                	mov    %eax,%ebx
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 88 e1 00 00 00    	js     80142f <dup+0x10f>
		return r;
	close(newfdnum);
  80134e:	89 3c 24             	mov    %edi,(%esp)
  801351:	e8 77 ff ff ff       	call   8012cd <close>

	newfd = INDEX2FD(newfdnum);
  801356:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80135c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80135f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	e8 86 fd ff ff       	call   8010f0 <fd2data>
  80136a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80136c:	89 34 24             	mov    %esi,(%esp)
  80136f:	e8 7c fd ff ff       	call   8010f0 <fd2data>
  801374:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801377:	89 d8                	mov    %ebx,%eax
  801379:	c1 e8 16             	shr    $0x16,%eax
  80137c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801383:	a8 01                	test   $0x1,%al
  801385:	74 46                	je     8013cd <dup+0xad>
  801387:	89 d8                	mov    %ebx,%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
  80138c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801393:	f6 c2 01             	test   $0x1,%dl
  801396:	74 35                	je     8013cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801398:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139f:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b6:	00 
  8013b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c2:	e8 14 fa ff ff       	call   800ddb <sys_page_map>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 3b                	js     801408 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 0c             	shr    $0xc,%edx
  8013d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013dc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f1:	00 
  8013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fd:	e8 d9 f9 ff ff       	call   800ddb <sys_page_map>
  801402:	89 c3                	mov    %eax,%ebx
  801404:	85 c0                	test   %eax,%eax
  801406:	79 25                	jns    80142d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801408:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801413:	e8 21 fa ff ff       	call   800e39 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80141b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801426:	e8 0e fa ff ff       	call   800e39 <sys_page_unmap>
	return r;
  80142b:	eb 02                	jmp    80142f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80142d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142f:	89 d8                	mov    %ebx,%eax
  801431:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801434:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801437:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80143a:	89 ec                	mov    %ebp,%esp
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	53                   	push   %ebx
  801442:	83 ec 24             	sub    $0x24,%esp
  801445:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801448:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144f:	89 1c 24             	mov    %ebx,(%esp)
  801452:	e8 27 fd ff ff       	call   80117e <fd_lookup>
  801457:	85 c0                	test   %eax,%eax
  801459:	78 6d                	js     8014c8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	89 04 24             	mov    %eax,(%esp)
  80146a:	e8 60 fd ff ff       	call   8011cf <dev_lookup>
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 55                	js     8014c8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	8b 50 08             	mov    0x8(%eax),%edx
  801479:	83 e2 03             	and    $0x3,%edx
  80147c:	83 fa 01             	cmp    $0x1,%edx
  80147f:	75 23                	jne    8014a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801481:	a1 04 40 80 00       	mov    0x804004,%eax
  801486:	8b 40 48             	mov    0x48(%eax),%eax
  801489:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	c7 04 24 14 27 80 00 	movl   $0x802714,(%esp)
  801498:	e8 c2 ed ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  80149d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a2:	eb 24                	jmp    8014c8 <read+0x8a>
	}
	if (!dev->dev_read)
  8014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a7:	8b 52 08             	mov    0x8(%edx),%edx
  8014aa:	85 d2                	test   %edx,%edx
  8014ac:	74 15                	je     8014c3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014bc:	89 04 24             	mov    %eax,(%esp)
  8014bf:	ff d2                	call   *%edx
  8014c1:	eb 05                	jmp    8014c8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014c8:	83 c4 24             	add    $0x24,%esp
  8014cb:	5b                   	pop    %ebx
  8014cc:	5d                   	pop    %ebp
  8014cd:	c3                   	ret    

008014ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	57                   	push   %edi
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 1c             	sub    $0x1c,%esp
  8014d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	85 f6                	test   %esi,%esi
  8014e4:	74 30                	je     801516 <readn+0x48>
  8014e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014eb:	89 f2                	mov    %esi,%edx
  8014ed:	29 c2                	sub    %eax,%edx
  8014ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014f3:	03 45 0c             	add    0xc(%ebp),%eax
  8014f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fa:	89 3c 24             	mov    %edi,(%esp)
  8014fd:	e8 3c ff ff ff       	call   80143e <read>
		if (m < 0)
  801502:	85 c0                	test   %eax,%eax
  801504:	78 10                	js     801516 <readn+0x48>
			return m;
		if (m == 0)
  801506:	85 c0                	test   %eax,%eax
  801508:	74 0a                	je     801514 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150a:	01 c3                	add    %eax,%ebx
  80150c:	89 d8                	mov    %ebx,%eax
  80150e:	39 f3                	cmp    %esi,%ebx
  801510:	72 d9                	jb     8014eb <readn+0x1d>
  801512:	eb 02                	jmp    801516 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801514:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801516:	83 c4 1c             	add    $0x1c,%esp
  801519:	5b                   	pop    %ebx
  80151a:	5e                   	pop    %esi
  80151b:	5f                   	pop    %edi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 24             	sub    $0x24,%esp
  801525:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801528:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152f:	89 1c 24             	mov    %ebx,(%esp)
  801532:	e8 47 fc ff ff       	call   80117e <fd_lookup>
  801537:	85 c0                	test   %eax,%eax
  801539:	78 68                	js     8015a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 80 fc ff ff       	call   8011cf <dev_lookup>
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 50                	js     8015a3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155a:	75 23                	jne    80157f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80155c:	a1 04 40 80 00       	mov    0x804004,%eax
  801561:	8b 40 48             	mov    0x48(%eax),%eax
  801564:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156c:	c7 04 24 30 27 80 00 	movl   $0x802730,(%esp)
  801573:	e8 e7 ec ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb 24                	jmp    8015a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	8b 52 0c             	mov    0xc(%edx),%edx
  801585:	85 d2                	test   %edx,%edx
  801587:	74 15                	je     80159e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801589:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801590:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801593:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801597:	89 04 24             	mov    %eax,(%esp)
  80159a:	ff d2                	call   *%edx
  80159c:	eb 05                	jmp    8015a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80159e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015a3:	83 c4 24             	add    $0x24,%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 04 24             	mov    %eax,(%esp)
  8015bc:	e8 bd fb ff ff       	call   80117e <fd_lookup>
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 0e                	js     8015d3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 24             	sub    $0x24,%esp
  8015dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e6:	89 1c 24             	mov    %ebx,(%esp)
  8015e9:	e8 90 fb ff ff       	call   80117e <fd_lookup>
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 61                	js     801653 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 c9 fb ff ff       	call   8011cf <dev_lookup>
  801606:	85 c0                	test   %eax,%eax
  801608:	78 49                	js     801653 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801611:	75 23                	jne    801636 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801613:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801618:	8b 40 48             	mov    0x48(%eax),%eax
  80161b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80161f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801623:	c7 04 24 f0 26 80 00 	movl   $0x8026f0,(%esp)
  80162a:	e8 30 ec ff ff       	call   80025f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80162f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801634:	eb 1d                	jmp    801653 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801639:	8b 52 18             	mov    0x18(%edx),%edx
  80163c:	85 d2                	test   %edx,%edx
  80163e:	74 0e                	je     80164e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	ff d2                	call   *%edx
  80164c:	eb 05                	jmp    801653 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80164e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801653:	83 c4 24             	add    $0x24,%esp
  801656:	5b                   	pop    %ebx
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
  80165d:	83 ec 24             	sub    $0x24,%esp
  801660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	89 04 24             	mov    %eax,(%esp)
  801670:	e8 09 fb ff ff       	call   80117e <fd_lookup>
  801675:	85 c0                	test   %eax,%eax
  801677:	78 52                	js     8016cb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 42 fb ff ff       	call   8011cf <dev_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 3a                	js     8016cb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801698:	74 2c                	je     8016c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a4:	00 00 00 
	stat->st_isdir = 0;
  8016a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ae:	00 00 00 
	stat->st_dev = dev;
  8016b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016be:	89 14 24             	mov    %edx,(%esp)
  8016c1:	ff 50 14             	call   *0x14(%eax)
  8016c4:	eb 05                	jmp    8016cb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016cb:	83 c4 24             	add    $0x24,%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 18             	sub    $0x18,%esp
  8016d7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016da:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016e4:	00 
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	89 04 24             	mov    %eax,(%esp)
  8016eb:	e8 bc 01 00 00       	call   8018ac <open>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 1b                	js     801711 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fd:	89 1c 24             	mov    %ebx,(%esp)
  801700:	e8 54 ff ff ff       	call   801659 <fstat>
  801705:	89 c6                	mov    %eax,%esi
	close(fd);
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 be fb ff ff       	call   8012cd <close>
	return r;
  80170f:	89 f3                	mov    %esi,%ebx
}
  801711:	89 d8                	mov    %ebx,%eax
  801713:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801716:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801719:	89 ec                	mov    %ebp,%esp
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    
  80171d:	00 00                	add    %al,(%eax)
	...

00801720 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 18             	sub    $0x18,%esp
  801726:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801729:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801730:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801737:	75 11                	jne    80174a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801740:	e8 61 08 00 00       	call   801fa6 <ipc_find_env>
  801745:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801751:	00 
  801752:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801759:	00 
  80175a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80175e:	a1 00 40 80 00       	mov    0x804000,%eax
  801763:	89 04 24             	mov    %eax,(%esp)
  801766:	e8 b7 07 00 00       	call   801f22 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80176b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801772:	00 
  801773:	89 74 24 04          	mov    %esi,0x4(%esp)
  801777:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177e:	e8 4d 07 00 00       	call   801ed0 <ipc_recv>
}
  801783:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801786:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801789:	89 ec                	mov    %ebp,%esp
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	53                   	push   %ebx
  801791:	83 ec 14             	sub    $0x14,%esp
  801794:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ac:	e8 6f ff ff ff       	call   801720 <fsipc>
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 2b                	js     8017e0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017b5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017bc:	00 
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 b6 f0 ff ff       	call   80087b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017c5:	a1 80 50 80 00       	mov    0x805080,%eax
  8017ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017d0:	a1 84 50 80 00       	mov    0x805084,%eax
  8017d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e0:	83 c4 14             	add    $0x14,%esp
  8017e3:	5b                   	pop    %ebx
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 06 00 00 00       	mov    $0x6,%eax
  801801:	e8 1a ff ff ff       	call   801720 <fsipc>
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 10             	sub    $0x10,%esp
  801810:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8b 40 0c             	mov    0xc(%eax),%eax
  801819:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80181e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801824:	ba 00 00 00 00       	mov    $0x0,%edx
  801829:	b8 03 00 00 00       	mov    $0x3,%eax
  80182e:	e8 ed fe ff ff       	call   801720 <fsipc>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	85 c0                	test   %eax,%eax
  801837:	78 6a                	js     8018a3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801839:	39 c6                	cmp    %eax,%esi
  80183b:	73 24                	jae    801861 <devfile_read+0x59>
  80183d:	c7 44 24 0c 60 27 80 	movl   $0x802760,0xc(%esp)
  801844:	00 
  801845:	c7 44 24 08 67 27 80 	movl   $0x802767,0x8(%esp)
  80184c:	00 
  80184d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801854:	00 
  801855:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  80185c:	e8 03 e9 ff ff       	call   800164 <_panic>
	assert(r <= PGSIZE);
  801861:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801866:	7e 24                	jle    80188c <devfile_read+0x84>
  801868:	c7 44 24 0c 87 27 80 	movl   $0x802787,0xc(%esp)
  80186f:	00 
  801870:	c7 44 24 08 67 27 80 	movl   $0x802767,0x8(%esp)
  801877:	00 
  801878:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80187f:	00 
  801880:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  801887:	e8 d8 e8 ff ff       	call   800164 <_panic>
	memmove(buf, &fsipcbuf, r);
  80188c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801890:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801897:	00 
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 c9 f1 ff ff       	call   800a6c <memmove>
	return r;
}
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 20             	sub    $0x20,%esp
  8018b4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018b7:	89 34 24             	mov    %esi,(%esp)
  8018ba:	e8 71 ef ff ff       	call   800830 <strlen>
		return -E_BAD_PATH;
  8018bf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c9:	7f 5e                	jg     801929 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 35 f8 ff ff       	call   80110b <fd_alloc>
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 4d                	js     801929 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018e7:	e8 8f ef ff ff       	call   80087b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ef:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fc:	e8 1f fe ff ff       	call   801720 <fsipc>
  801901:	89 c3                	mov    %eax,%ebx
  801903:	85 c0                	test   %eax,%eax
  801905:	79 15                	jns    80191c <open+0x70>
		fd_close(fd, 0);
  801907:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190e:	00 
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 21 f9 ff ff       	call   80123b <fd_close>
		return r;
  80191a:	eb 0d                	jmp    801929 <open+0x7d>
	}

	return fd2num(fd);
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 b9 f7 ff ff       	call   8010e0 <fd2num>
  801927:	89 c3                	mov    %eax,%ebx
}
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	83 c4 20             	add    $0x20,%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    
	...

00801940 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 18             	sub    $0x18,%esp
  801946:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801949:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80194c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	e8 96 f7 ff ff       	call   8010f0 <fd2data>
  80195a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80195c:	c7 44 24 04 93 27 80 	movl   $0x802793,0x4(%esp)
  801963:	00 
  801964:	89 34 24             	mov    %esi,(%esp)
  801967:	e8 0f ef ff ff       	call   80087b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80196c:	8b 43 04             	mov    0x4(%ebx),%eax
  80196f:	2b 03                	sub    (%ebx),%eax
  801971:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801977:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80197e:	00 00 00 
	stat->st_dev = &devpipe;
  801981:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801988:	30 80 00 
	return 0;
}
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801993:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801996:	89 ec                	mov    %ebp,%esp
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 14             	sub    $0x14,%esp
  8019a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019af:	e8 85 f4 ff ff       	call   800e39 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019b4:	89 1c 24             	mov    %ebx,(%esp)
  8019b7:	e8 34 f7 ff ff       	call   8010f0 <fd2data>
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c7:	e8 6d f4 ff ff       	call   800e39 <sys_page_unmap>
}
  8019cc:	83 c4 14             	add    $0x14,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 2c             	sub    $0x2c,%esp
  8019db:	89 c7                	mov    %eax,%edi
  8019dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019e8:	89 3c 24             	mov    %edi,(%esp)
  8019eb:	e8 00 06 00 00       	call   801ff0 <pageref>
  8019f0:	89 c6                	mov    %eax,%esi
  8019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f5:	89 04 24             	mov    %eax,(%esp)
  8019f8:	e8 f3 05 00 00       	call   801ff0 <pageref>
  8019fd:	39 c6                	cmp    %eax,%esi
  8019ff:	0f 94 c0             	sete   %al
  801a02:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801a05:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a0b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a0e:	39 cb                	cmp    %ecx,%ebx
  801a10:	75 08                	jne    801a1a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801a12:	83 c4 2c             	add    $0x2c,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801a1a:	83 f8 01             	cmp    $0x1,%eax
  801a1d:	75 c1                	jne    8019e0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a1f:	8b 52 58             	mov    0x58(%edx),%edx
  801a22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a2e:	c7 04 24 9a 27 80 00 	movl   $0x80279a,(%esp)
  801a35:	e8 25 e8 ff ff       	call   80025f <cprintf>
  801a3a:	eb a4                	jmp    8019e0 <_pipeisclosed+0xe>

00801a3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	57                   	push   %edi
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 2c             	sub    $0x2c,%esp
  801a45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a48:	89 34 24             	mov    %esi,(%esp)
  801a4b:	e8 a0 f6 ff ff       	call   8010f0 <fd2data>
  801a50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a52:	bf 00 00 00 00       	mov    $0x0,%edi
  801a57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5b:	75 50                	jne    801aad <devpipe_write+0x71>
  801a5d:	eb 5c                	jmp    801abb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a5f:	89 da                	mov    %ebx,%edx
  801a61:	89 f0                	mov    %esi,%eax
  801a63:	e8 6a ff ff ff       	call   8019d2 <_pipeisclosed>
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	75 53                	jne    801abf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a6c:	e8 db f2 ff ff       	call   800d4c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a71:	8b 43 04             	mov    0x4(%ebx),%eax
  801a74:	8b 13                	mov    (%ebx),%edx
  801a76:	83 c2 20             	add    $0x20,%edx
  801a79:	39 d0                	cmp    %edx,%eax
  801a7b:	73 e2                	jae    801a5f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801a84:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801a87:	89 c2                	mov    %eax,%edx
  801a89:	c1 fa 1f             	sar    $0x1f,%edx
  801a8c:	c1 ea 1b             	shr    $0x1b,%edx
  801a8f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a92:	83 e1 1f             	and    $0x1f,%ecx
  801a95:	29 d1                	sub    %edx,%ecx
  801a97:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a9b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a9f:	83 c0 01             	add    $0x1,%eax
  801aa2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801aa5:	83 c7 01             	add    $0x1,%edi
  801aa8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801aab:	74 0e                	je     801abb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aad:	8b 43 04             	mov    0x4(%ebx),%eax
  801ab0:	8b 13                	mov    (%ebx),%edx
  801ab2:	83 c2 20             	add    $0x20,%edx
  801ab5:	39 d0                	cmp    %edx,%eax
  801ab7:	73 a6                	jae    801a5f <devpipe_write+0x23>
  801ab9:	eb c2                	jmp    801a7d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801abb:	89 f8                	mov    %edi,%eax
  801abd:	eb 05                	jmp    801ac4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ac4:	83 c4 2c             	add    $0x2c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 28             	sub    $0x28,%esp
  801ad2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ad5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ad8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801adb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ade:	89 3c 24             	mov    %edi,(%esp)
  801ae1:	e8 0a f6 ff ff       	call   8010f0 <fd2data>
  801ae6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ae8:	be 00 00 00 00       	mov    $0x0,%esi
  801aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801af1:	75 47                	jne    801b3a <devpipe_read+0x6e>
  801af3:	eb 52                	jmp    801b47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801af5:	89 f0                	mov    %esi,%eax
  801af7:	eb 5e                	jmp    801b57 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801af9:	89 da                	mov    %ebx,%edx
  801afb:	89 f8                	mov    %edi,%eax
  801afd:	8d 76 00             	lea    0x0(%esi),%esi
  801b00:	e8 cd fe ff ff       	call   8019d2 <_pipeisclosed>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	75 49                	jne    801b52 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b09:	e8 3e f2 ff ff       	call   800d4c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b0e:	8b 03                	mov    (%ebx),%eax
  801b10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b13:	74 e4                	je     801af9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b15:	89 c2                	mov    %eax,%edx
  801b17:	c1 fa 1f             	sar    $0x1f,%edx
  801b1a:	c1 ea 1b             	shr    $0x1b,%edx
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	83 e0 1f             	and    $0x1f,%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801b2f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b32:	83 c6 01             	add    $0x1,%esi
  801b35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b38:	74 0d                	je     801b47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801b3a:	8b 03                	mov    (%ebx),%eax
  801b3c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b3f:	75 d4                	jne    801b15 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b41:	85 f6                	test   %esi,%esi
  801b43:	75 b0                	jne    801af5 <devpipe_read+0x29>
  801b45:	eb b2                	jmp    801af9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b47:	89 f0                	mov    %esi,%eax
  801b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b50:	eb 05                	jmp    801b57 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b60:	89 ec                	mov    %ebp,%esp
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 48             	sub    $0x48,%esp
  801b6a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b6d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b70:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b73:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b79:	89 04 24             	mov    %eax,(%esp)
  801b7c:	e8 8a f5 ff ff       	call   80110b <fd_alloc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	0f 88 45 01 00 00    	js     801cd0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b92:	00 
  801b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba1:	e8 d6 f1 ff ff       	call   800d7c <sys_page_alloc>
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 88 20 01 00 00    	js     801cd0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801bb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 50 f5 ff ff       	call   80110b <fd_alloc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	0f 88 f8 00 00 00    	js     801cbd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bcc:	00 
  801bcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdb:	e8 9c f1 ff ff       	call   800d7c <sys_page_alloc>
  801be0:	89 c3                	mov    %eax,%ebx
  801be2:	85 c0                	test   %eax,%eax
  801be4:	0f 88 d3 00 00 00    	js     801cbd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bed:	89 04 24             	mov    %eax,(%esp)
  801bf0:	e8 fb f4 ff ff       	call   8010f0 <fd2data>
  801bf5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bfe:	00 
  801bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0a:	e8 6d f1 ff ff       	call   800d7c <sys_page_alloc>
  801c0f:	89 c3                	mov    %eax,%ebx
  801c11:	85 c0                	test   %eax,%eax
  801c13:	0f 88 91 00 00 00    	js     801caa <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 cc f4 ff ff       	call   8010f0 <fd2data>
  801c24:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801c2b:	00 
  801c2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c37:	00 
  801c38:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c43:	e8 93 f1 ff ff       	call   800ddb <sys_page_map>
  801c48:	89 c3                	mov    %eax,%ebx
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 4c                	js     801c9a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c57:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c71:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 5d f4 ff ff       	call   8010e0 <fd2num>
  801c83:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c88:	89 04 24             	mov    %eax,(%esp)
  801c8b:	e8 50 f4 ff ff       	call   8010e0 <fd2num>
  801c90:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c98:	eb 36                	jmp    801cd0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801c9a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca5:	e8 8f f1 ff ff       	call   800e39 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb8:	e8 7c f1 ff ff       	call   800e39 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccb:	e8 69 f1 ff ff       	call   800e39 <sys_page_unmap>
    err:
	return r;
}
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cdb:	89 ec                	mov    %ebp,%esp
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 87 f4 ff ff       	call   80117e <fd_lookup>
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 15                	js     801d10 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 ea f3 ff ff       	call   8010f0 <fd2data>
	return _pipeisclosed(fd, p);
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0b:	e8 c2 fc ff ff       	call   8019d2 <_pipeisclosed>
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    
	...

00801d20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801d30:	c7 44 24 04 b2 27 80 	movl   $0x8027b2,0x4(%esp)
  801d37:	00 
  801d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 38 eb ff ff       	call   80087b <strcpy>
	return 0;
}
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	57                   	push   %edi
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d56:	be 00 00 00 00       	mov    $0x0,%esi
  801d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d5f:	74 43                	je     801da4 <devcons_write+0x5a>
  801d61:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d66:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801d71:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d74:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d79:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d80:	03 45 0c             	add    0xc(%ebp),%eax
  801d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d87:	89 3c 24             	mov    %edi,(%esp)
  801d8a:	e8 dd ec ff ff       	call   800a6c <memmove>
		sys_cputs(buf, m);
  801d8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d93:	89 3c 24             	mov    %edi,(%esp)
  801d96:	e8 c5 ee ff ff       	call   800c60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d9b:	01 de                	add    %ebx,%esi
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da2:	72 c8                	jb     801d6c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801da4:	89 f0                	mov    %esi,%eax
  801da6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dc0:	75 07                	jne    801dc9 <devcons_read+0x18>
  801dc2:	eb 31                	jmp    801df5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801dc4:	e8 83 ef ff ff       	call   800d4c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	e8 ba ee ff ff       	call   800c8f <sys_cgetc>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 eb                	je     801dc4 <devcons_read+0x13>
  801dd9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	78 16                	js     801df5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ddf:	83 f8 04             	cmp    $0x4,%eax
  801de2:	74 0c                	je     801df0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de7:	88 10                	mov    %dl,(%eax)
	return 1;
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dee:	eb 05                	jmp    801df5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e0a:	00 
  801e0b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 4a ee ff ff       	call   800c60 <sys_cputs>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <getchar>:

int
getchar(void)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e1e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e25:	00 
  801e26:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e34:	e8 05 f6 ff ff       	call   80143e <read>
	if (r < 0)
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	78 0f                	js     801e4c <getchar+0x34>
		return r;
	if (r < 1)
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	7e 06                	jle    801e47 <getchar+0x2f>
		return -E_EOF;
	return c;
  801e41:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e45:	eb 05                	jmp    801e4c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e47:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	e8 18 f3 ff ff       	call   80117e <fd_lookup>
  801e66:	85 c0                	test   %eax,%eax
  801e68:	78 11                	js     801e7b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e73:	39 10                	cmp    %edx,(%eax)
  801e75:	0f 94 c0             	sete   %al
  801e78:	0f b6 c0             	movzbl %al,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <opencons>:

int
opencons(void)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 7d f2 ff ff       	call   80110b <fd_alloc>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 3c                	js     801ece <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e99:	00 
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea8:	e8 cf ee ff ff       	call   800d7c <sys_page_alloc>
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 1d                	js     801ece <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801eb1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 12 f2 ff ff       	call   8010e0 <fd2num>
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
  801ed8:	8b 75 08             	mov    0x8(%ebp),%esi
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801ee1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801ee3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ee8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801eeb:	89 04 24             	mov    %eax,(%esp)
  801eee:	e8 f2 f0 ff ff       	call   800fe5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801ef3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 0e                	js     801f0f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801f01:	a1 04 40 80 00       	mov    0x804004,%eax
  801f06:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801f09:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801f0c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801f0f:	85 f6                	test   %esi,%esi
  801f11:	74 02                	je     801f15 <ipc_recv+0x45>
		*from_env_store = sender;
  801f13:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801f15:	85 db                	test   %ebx,%ebx
  801f17:	74 02                	je     801f1b <ipc_recv+0x4b>
		*perm_store = perm;
  801f19:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    

00801f22 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	57                   	push   %edi
  801f26:	56                   	push   %esi
  801f27:	53                   	push   %ebx
  801f28:	83 ec 1c             	sub    $0x1c,%esp
  801f2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f31:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801f34:	85 db                	test   %ebx,%ebx
  801f36:	75 04                	jne    801f3c <ipc_send+0x1a>
  801f38:	85 f6                	test   %esi,%esi
  801f3a:	75 15                	jne    801f51 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801f3c:	85 db                	test   %ebx,%ebx
  801f3e:	74 16                	je     801f56 <ipc_send+0x34>
  801f40:	85 f6                	test   %esi,%esi
  801f42:	0f 94 c0             	sete   %al
      pg = 0;
  801f45:	84 c0                	test   %al,%al
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	0f 45 d8             	cmovne %eax,%ebx
  801f4f:	eb 05                	jmp    801f56 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801f51:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801f56:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f5a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f5e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	89 04 24             	mov    %eax,(%esp)
  801f68:	e8 44 f0 ff ff       	call   800fb1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801f6d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f70:	75 07                	jne    801f79 <ipc_send+0x57>
           sys_yield();
  801f72:	e8 d5 ed ff ff       	call   800d4c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801f77:	eb dd                	jmp    801f56 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	90                   	nop
  801f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f80:	74 1c                	je     801f9e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801f82:	c7 44 24 08 be 27 80 	movl   $0x8027be,0x8(%esp)
  801f89:	00 
  801f8a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f91:	00 
  801f92:	c7 04 24 c8 27 80 00 	movl   $0x8027c8,(%esp)
  801f99:	e8 c6 e1 ff ff       	call   800164 <_panic>
		}
    }
}
  801f9e:	83 c4 1c             	add    $0x1c,%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    

00801fa6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801fac:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801fb1:	39 c8                	cmp    %ecx,%eax
  801fb3:	74 17                	je     801fcc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fb5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801fba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fbd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fc3:	8b 52 50             	mov    0x50(%edx),%edx
  801fc6:	39 ca                	cmp    %ecx,%edx
  801fc8:	75 14                	jne    801fde <ipc_find_env+0x38>
  801fca:	eb 05                	jmp    801fd1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801fd1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801fd9:	8b 40 40             	mov    0x40(%eax),%eax
  801fdc:	eb 0e                	jmp    801fec <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fde:	83 c0 01             	add    $0x1,%eax
  801fe1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fe6:	75 d2                	jne    801fba <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801fe8:	66 b8 00 00          	mov    $0x0,%ax
}
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    
	...

00801ff0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ff6:	89 d0                	mov    %edx,%eax
  801ff8:	c1 e8 16             	shr    $0x16,%eax
  801ffb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802007:	f6 c1 01             	test   $0x1,%cl
  80200a:	74 1d                	je     802029 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80200c:	c1 ea 0c             	shr    $0xc,%edx
  80200f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802016:	f6 c2 01             	test   $0x1,%dl
  802019:	74 0e                	je     802029 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80201b:	c1 ea 0c             	shr    $0xc,%edx
  80201e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802025:	ef 
  802026:	0f b7 c0             	movzwl %ax,%eax
}
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    
  80202b:	00 00                	add    %al,(%eax)
  80202d:	00 00                	add    %al,(%eax)
	...

00802030 <__udivdi3>:
  802030:	83 ec 1c             	sub    $0x1c,%esp
  802033:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802037:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80203b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80203f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802043:	89 74 24 10          	mov    %esi,0x10(%esp)
  802047:	8b 74 24 24          	mov    0x24(%esp),%esi
  80204b:	85 ff                	test   %edi,%edi
  80204d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	89 cd                	mov    %ecx,%ebp
  802057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205b:	75 33                	jne    802090 <__udivdi3+0x60>
  80205d:	39 f1                	cmp    %esi,%ecx
  80205f:	77 57                	ja     8020b8 <__udivdi3+0x88>
  802061:	85 c9                	test   %ecx,%ecx
  802063:	75 0b                	jne    802070 <__udivdi3+0x40>
  802065:	b8 01 00 00 00       	mov    $0x1,%eax
  80206a:	31 d2                	xor    %edx,%edx
  80206c:	f7 f1                	div    %ecx
  80206e:	89 c1                	mov    %eax,%ecx
  802070:	89 f0                	mov    %esi,%eax
  802072:	31 d2                	xor    %edx,%edx
  802074:	f7 f1                	div    %ecx
  802076:	89 c6                	mov    %eax,%esi
  802078:	8b 44 24 04          	mov    0x4(%esp),%eax
  80207c:	f7 f1                	div    %ecx
  80207e:	89 f2                	mov    %esi,%edx
  802080:	8b 74 24 10          	mov    0x10(%esp),%esi
  802084:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802088:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	c3                   	ret    
  802090:	31 d2                	xor    %edx,%edx
  802092:	31 c0                	xor    %eax,%eax
  802094:	39 f7                	cmp    %esi,%edi
  802096:	77 e8                	ja     802080 <__udivdi3+0x50>
  802098:	0f bd cf             	bsr    %edi,%ecx
  80209b:	83 f1 1f             	xor    $0x1f,%ecx
  80209e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020a2:	75 2c                	jne    8020d0 <__udivdi3+0xa0>
  8020a4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8020a8:	76 04                	jbe    8020ae <__udivdi3+0x7e>
  8020aa:	39 f7                	cmp    %esi,%edi
  8020ac:	73 d2                	jae    802080 <__udivdi3+0x50>
  8020ae:	31 d2                	xor    %edx,%edx
  8020b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b5:	eb c9                	jmp    802080 <__udivdi3+0x50>
  8020b7:	90                   	nop
  8020b8:	89 f2                	mov    %esi,%edx
  8020ba:	f7 f1                	div    %ecx
  8020bc:	31 d2                	xor    %edx,%edx
  8020be:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020c2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020c6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ca:	83 c4 1c             	add    $0x1c,%esp
  8020cd:	c3                   	ret    
  8020ce:	66 90                	xchg   %ax,%ax
  8020d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020d5:	b8 20 00 00 00       	mov    $0x20,%eax
  8020da:	89 ea                	mov    %ebp,%edx
  8020dc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8020e0:	d3 e7                	shl    %cl,%edi
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	d3 ea                	shr    %cl,%edx
  8020e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020eb:	09 fa                	or     %edi,%edx
  8020ed:	89 f7                	mov    %esi,%edi
  8020ef:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020f3:	89 f2                	mov    %esi,%edx
  8020f5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8020f9:	d3 e5                	shl    %cl,%ebp
  8020fb:	89 c1                	mov    %eax,%ecx
  8020fd:	d3 ef                	shr    %cl,%edi
  8020ff:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802104:	d3 e2                	shl    %cl,%edx
  802106:	89 c1                	mov    %eax,%ecx
  802108:	d3 ee                	shr    %cl,%esi
  80210a:	09 d6                	or     %edx,%esi
  80210c:	89 fa                	mov    %edi,%edx
  80210e:	89 f0                	mov    %esi,%eax
  802110:	f7 74 24 0c          	divl   0xc(%esp)
  802114:	89 d7                	mov    %edx,%edi
  802116:	89 c6                	mov    %eax,%esi
  802118:	f7 e5                	mul    %ebp
  80211a:	39 d7                	cmp    %edx,%edi
  80211c:	72 22                	jb     802140 <__udivdi3+0x110>
  80211e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802122:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802127:	d3 e5                	shl    %cl,%ebp
  802129:	39 c5                	cmp    %eax,%ebp
  80212b:	73 04                	jae    802131 <__udivdi3+0x101>
  80212d:	39 d7                	cmp    %edx,%edi
  80212f:	74 0f                	je     802140 <__udivdi3+0x110>
  802131:	89 f0                	mov    %esi,%eax
  802133:	31 d2                	xor    %edx,%edx
  802135:	e9 46 ff ff ff       	jmp    802080 <__udivdi3+0x50>
  80213a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802140:	8d 46 ff             	lea    -0x1(%esi),%eax
  802143:	31 d2                	xor    %edx,%edx
  802145:	8b 74 24 10          	mov    0x10(%esp),%esi
  802149:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80214d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802151:	83 c4 1c             	add    $0x1c,%esp
  802154:	c3                   	ret    
	...

00802160 <__umoddi3>:
  802160:	83 ec 1c             	sub    $0x1c,%esp
  802163:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802167:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80216b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80216f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802173:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802177:	8b 74 24 24          	mov    0x24(%esp),%esi
  80217b:	85 ed                	test   %ebp,%ebp
  80217d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802181:	89 44 24 08          	mov    %eax,0x8(%esp)
  802185:	89 cf                	mov    %ecx,%edi
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	89 f2                	mov    %esi,%edx
  80218c:	75 1a                	jne    8021a8 <__umoddi3+0x48>
  80218e:	39 f1                	cmp    %esi,%ecx
  802190:	76 4e                	jbe    8021e0 <__umoddi3+0x80>
  802192:	f7 f1                	div    %ecx
  802194:	89 d0                	mov    %edx,%eax
  802196:	31 d2                	xor    %edx,%edx
  802198:	8b 74 24 10          	mov    0x10(%esp),%esi
  80219c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021a0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	c3                   	ret    
  8021a8:	39 f5                	cmp    %esi,%ebp
  8021aa:	77 54                	ja     802200 <__umoddi3+0xa0>
  8021ac:	0f bd c5             	bsr    %ebp,%eax
  8021af:	83 f0 1f             	xor    $0x1f,%eax
  8021b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b6:	75 60                	jne    802218 <__umoddi3+0xb8>
  8021b8:	3b 0c 24             	cmp    (%esp),%ecx
  8021bb:	0f 87 07 01 00 00    	ja     8022c8 <__umoddi3+0x168>
  8021c1:	89 f2                	mov    %esi,%edx
  8021c3:	8b 34 24             	mov    (%esp),%esi
  8021c6:	29 ce                	sub    %ecx,%esi
  8021c8:	19 ea                	sbb    %ebp,%edx
  8021ca:	89 34 24             	mov    %esi,(%esp)
  8021cd:	8b 04 24             	mov    (%esp),%eax
  8021d0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021d4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021d8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021dc:	83 c4 1c             	add    $0x1c,%esp
  8021df:	c3                   	ret    
  8021e0:	85 c9                	test   %ecx,%ecx
  8021e2:	75 0b                	jne    8021ef <__umoddi3+0x8f>
  8021e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e9:	31 d2                	xor    %edx,%edx
  8021eb:	f7 f1                	div    %ecx
  8021ed:	89 c1                	mov    %eax,%ecx
  8021ef:	89 f0                	mov    %esi,%eax
  8021f1:	31 d2                	xor    %edx,%edx
  8021f3:	f7 f1                	div    %ecx
  8021f5:	8b 04 24             	mov    (%esp),%eax
  8021f8:	f7 f1                	div    %ecx
  8021fa:	eb 98                	jmp    802194 <__umoddi3+0x34>
  8021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 f2                	mov    %esi,%edx
  802202:	8b 74 24 10          	mov    0x10(%esp),%esi
  802206:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80220a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80220e:	83 c4 1c             	add    $0x1c,%esp
  802211:	c3                   	ret    
  802212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802218:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80221d:	89 e8                	mov    %ebp,%eax
  80221f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802224:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802228:	89 fa                	mov    %edi,%edx
  80222a:	d3 e0                	shl    %cl,%eax
  80222c:	89 e9                	mov    %ebp,%ecx
  80222e:	d3 ea                	shr    %cl,%edx
  802230:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802235:	09 c2                	or     %eax,%edx
  802237:	8b 44 24 08          	mov    0x8(%esp),%eax
  80223b:	89 14 24             	mov    %edx,(%esp)
  80223e:	89 f2                	mov    %esi,%edx
  802240:	d3 e7                	shl    %cl,%edi
  802242:	89 e9                	mov    %ebp,%ecx
  802244:	d3 ea                	shr    %cl,%edx
  802246:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80224b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80224f:	d3 e6                	shl    %cl,%esi
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e8                	shr    %cl,%eax
  802255:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225a:	09 f0                	or     %esi,%eax
  80225c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802260:	f7 34 24             	divl   (%esp)
  802263:	d3 e6                	shl    %cl,%esi
  802265:	89 74 24 08          	mov    %esi,0x8(%esp)
  802269:	89 d6                	mov    %edx,%esi
  80226b:	f7 e7                	mul    %edi
  80226d:	39 d6                	cmp    %edx,%esi
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 d7                	mov    %edx,%edi
  802273:	72 3f                	jb     8022b4 <__umoddi3+0x154>
  802275:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802279:	72 35                	jb     8022b0 <__umoddi3+0x150>
  80227b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80227f:	29 c8                	sub    %ecx,%eax
  802281:	19 fe                	sbb    %edi,%esi
  802283:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802288:	89 f2                	mov    %esi,%edx
  80228a:	d3 e8                	shr    %cl,%eax
  80228c:	89 e9                	mov    %ebp,%ecx
  80228e:	d3 e2                	shl    %cl,%edx
  802290:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802295:	09 d0                	or     %edx,%eax
  802297:	89 f2                	mov    %esi,%edx
  802299:	d3 ea                	shr    %cl,%edx
  80229b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80229f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022a3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022a7:	83 c4 1c             	add    $0x1c,%esp
  8022aa:	c3                   	ret    
  8022ab:	90                   	nop
  8022ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	39 d6                	cmp    %edx,%esi
  8022b2:	75 c7                	jne    80227b <__umoddi3+0x11b>
  8022b4:	89 d7                	mov    %edx,%edi
  8022b6:	89 c1                	mov    %eax,%ecx
  8022b8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8022bc:	1b 3c 24             	sbb    (%esp),%edi
  8022bf:	eb ba                	jmp    80227b <__umoddi3+0x11b>
  8022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	39 f5                	cmp    %esi,%ebp
  8022ca:	0f 82 f1 fe ff ff    	jb     8021c1 <__umoddi3+0x61>
  8022d0:	e9 f8 fe ff ff       	jmp    8021cd <__umoddi3+0x6d>
