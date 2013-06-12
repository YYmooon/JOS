
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
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
  80004b:	e8 fb 01 00 00       	call   80024b <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  800050:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800057:	00 
  800058:	89 d8                	mov    %ebx,%eax
  80005a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800063:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80006a:	e8 fd 0c 00 00       	call   800d6c <sys_page_alloc>
  80006f:	85 c0                	test   %eax,%eax
  800071:	79 24                	jns    800097 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800073:	89 44 24 10          	mov    %eax,0x10(%esp)
  800077:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007b:	c7 44 24 08 00 23 80 	movl   $0x802300,0x8(%esp)
  800082:	00 
  800083:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008a:	00 
  80008b:	c7 04 24 ea 22 80 00 	movl   $0x8022ea,(%esp)
  800092:	e8 b9 00 00 00       	call   800150 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800097:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009b:	c7 44 24 08 2c 23 80 	movl   $0x80232c,0x8(%esp)
  8000a2:	00 
  8000a3:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000aa:	00 
  8000ab:	89 1c 24             	mov    %ebx,(%esp)
  8000ae:	e8 39 07 00 00       	call   8007ec <snprintf>
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
  8000c6:	e8 69 0f 00 00       	call   801034 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000cb:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d2:	00 
  8000d3:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000da:	e8 71 0b 00 00       	call   800c50 <sys_cputs>
}
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    
  8000e1:	00 00                	add    %al,(%eax)
	...

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
  8000ea:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000ed:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000f6:	e8 11 0c 00 00       	call   800d0c <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 f6                	test   %esi,%esi
  80010f:	7e 07                	jle    800118 <libmain+0x34>
		binaryname = argv[0];
  800111:	8b 03                	mov    (%ebx),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800118:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80011c:	89 34 24             	mov    %esi,(%esp)
  80011f:	e8 95 ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  800124:	e8 0b 00 00 00       	call   800134 <exit>
}
  800129:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80012c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80012f:	89 ec                	mov    %ebp,%esp
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
	...

00800134 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80013a:	e8 af 11 00 00       	call   8012ee <close_all>
	sys_env_destroy(0);
  80013f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800146:	e8 64 0b 00 00       	call   800caf <sys_env_destroy>
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    
  80014d:	00 00                	add    %al,(%eax)
	...

00800150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
  800155:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800158:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800161:	e8 a6 0b 00 00       	call   800d0c <sys_getenvid>
  800166:	8b 55 0c             	mov    0xc(%ebp),%edx
  800169:	89 54 24 10          	mov    %edx,0x10(%esp)
  80016d:	8b 55 08             	mov    0x8(%ebp),%edx
  800170:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800174:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017c:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  800183:	e8 c3 00 00 00       	call   80024b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800188:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	89 04 24             	mov    %eax,(%esp)
  800192:	e8 53 00 00 00       	call   8001ea <vcprintf>
	cprintf("\n");
  800197:	c7 04 24 ab 27 80 00 	movl   $0x8027ab,(%esp)
  80019e:	e8 a8 00 00 00       	call   80024b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001a3:	cc                   	int3   
  8001a4:	eb fd                	jmp    8001a3 <_panic+0x53>
	...

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 14             	sub    $0x14,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 03                	mov    (%ebx),%eax
  8001b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001bb:	83 c0 01             	add    $0x1,%eax
  8001be:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	75 19                	jne    8001e0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ce:	00 
  8001cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 76 0a 00 00       	call   800c50 <sys_cputs>
		b->idx = 0;
  8001da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e4:	83 c4 14             	add    $0x14,%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fa:	00 00 00 
	b.cnt = 0;
  8001fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800204:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 44 24 08          	mov    %eax,0x8(%esp)
  800215:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	c7 04 24 a8 01 80 00 	movl   $0x8001a8,(%esp)
  800226:	e8 9f 01 00 00       	call   8003ca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800231:	89 44 24 04          	mov    %eax,0x4(%esp)
  800235:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 0d 0a 00 00       	call   800c50 <sys_cputs>

	return b.cnt;
}
  800243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800251:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800254:	89 44 24 04          	mov    %eax,0x4(%esp)
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 87 ff ff ff       	call   8001ea <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    
	...

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80028d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800290:	b8 00 00 00 00       	mov    $0x0,%eax
  800295:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800298:	72 11                	jb     8002ab <printnum+0x3b>
  80029a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029d:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002a0:	76 09                	jbe    8002ab <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	85 db                	test   %ebx,%ebx
  8002a7:	7f 51                	jg     8002fa <printnum+0x8a>
  8002a9:	eb 5e                	jmp    800309 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ab:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002af:	83 eb 01             	sub    $0x1,%ebx
  8002b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8002c1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8002c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002cc:	00 
  8002cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002da:	e8 41 1d 00 00       	call   802020 <__udivdi3>
  8002df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ee:	89 fa                	mov    %edi,%edx
  8002f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f3:	e8 78 ff ff ff       	call   800270 <printnum>
  8002f8:	eb 0f                	jmp    800309 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002fe:	89 34 24             	mov    %esi,(%esp)
  800301:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800304:	83 eb 01             	sub    $0x1,%ebx
  800307:	75 f1                	jne    8002fa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800309:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800311:	8b 45 10             	mov    0x10(%ebp),%eax
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80031f:	00 
  800320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800323:	89 04 24             	mov    %eax,(%esp)
  800326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032d:	e8 1e 1e 00 00       	call   802150 <__umoddi3>
  800332:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800336:	0f be 80 7b 23 80 00 	movsbl 0x80237b(%eax),%eax
  80033d:	89 04 24             	mov    %eax,(%esp)
  800340:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800343:	83 c4 3c             	add    $0x3c,%esp
  800346:	5b                   	pop    %ebx
  800347:	5e                   	pop    %esi
  800348:	5f                   	pop    %edi
  800349:	5d                   	pop    %ebp
  80034a:	c3                   	ret    

0080034b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80034e:	83 fa 01             	cmp    $0x1,%edx
  800351:	7e 0e                	jle    800361 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800353:	8b 10                	mov    (%eax),%edx
  800355:	8d 4a 08             	lea    0x8(%edx),%ecx
  800358:	89 08                	mov    %ecx,(%eax)
  80035a:	8b 02                	mov    (%edx),%eax
  80035c:	8b 52 04             	mov    0x4(%edx),%edx
  80035f:	eb 22                	jmp    800383 <getuint+0x38>
	else if (lflag)
  800361:	85 d2                	test   %edx,%edx
  800363:	74 10                	je     800375 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036a:	89 08                	mov    %ecx,(%eax)
  80036c:	8b 02                	mov    (%edx),%eax
  80036e:	ba 00 00 00 00       	mov    $0x0,%edx
  800373:	eb 0e                	jmp    800383 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800375:	8b 10                	mov    (%eax),%edx
  800377:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 02                	mov    (%edx),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038f:	8b 10                	mov    (%eax),%edx
  800391:	3b 50 04             	cmp    0x4(%eax),%edx
  800394:	73 0a                	jae    8003a0 <sprintputch+0x1b>
		*b->buf++ = ch;
  800396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800399:	88 0a                	mov    %cl,(%edx)
  80039b:	83 c2 01             	add    $0x1,%edx
  80039e:	89 10                	mov    %edx,(%eax)
}
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    

008003a2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	89 04 24             	mov    %eax,(%esp)
  8003c3:	e8 02 00 00 00       	call   8003ca <vprintfmt>
	va_end(ap);
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	83 ec 4c             	sub    $0x4c,%esp
  8003d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d6:	8b 75 10             	mov    0x10(%ebp),%esi
  8003d9:	eb 12                	jmp    8003ed <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	0f 84 a9 03 00 00    	je     80078c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8003e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	0f b6 06             	movzbl (%esi),%eax
  8003f0:	83 c6 01             	add    $0x1,%esi
  8003f3:	83 f8 25             	cmp    $0x25,%eax
  8003f6:	75 e3                	jne    8003db <vprintfmt+0x11>
  8003f8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800403:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800408:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800414:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800417:	eb 2b                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800419:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80041c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800420:	eb 22                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800425:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800429:	eb 19                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80042e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800435:	eb 0d                	jmp    800444 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800437:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800444:	0f b6 06             	movzbl (%esi),%eax
  800447:	0f b6 d0             	movzbl %al,%edx
  80044a:	8d 7e 01             	lea    0x1(%esi),%edi
  80044d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800450:	83 e8 23             	sub    $0x23,%eax
  800453:	3c 55                	cmp    $0x55,%al
  800455:	0f 87 0b 03 00 00    	ja     800766 <vprintfmt+0x39c>
  80045b:	0f b6 c0             	movzbl %al,%eax
  80045e:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800465:	83 ea 30             	sub    $0x30,%edx
  800468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80046b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80046f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800472:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800475:	83 fa 09             	cmp    $0x9,%edx
  800478:	77 4a                	ja     8004c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80047d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800480:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800483:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800487:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80048a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80048d:	83 fa 09             	cmp    $0x9,%edx
  800490:	76 eb                	jbe    80047d <vprintfmt+0xb3>
  800492:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800495:	eb 2d                	jmp    8004c4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 50 04             	lea    0x4(%eax),%edx
  80049d:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a8:	eb 1a                	jmp    8004c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8004ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b1:	79 91                	jns    800444 <vprintfmt+0x7a>
  8004b3:	e9 73 ff ff ff       	jmp    80042b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004c2:	eb 80                	jmp    800444 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8004c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c8:	0f 89 76 ff ff ff    	jns    800444 <vprintfmt+0x7a>
  8004ce:	e9 64 ff ff ff       	jmp    800437 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004d9:	e9 66 ff ff ff       	jmp    800444 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8d 50 04             	lea    0x4(%eax),%edx
  8004e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	89 04 24             	mov    %eax,(%esp)
  8004f0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004f6:	e9 f2 fe ff ff       	jmp    8003ed <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 c2                	mov    %eax,%edx
  800508:	c1 fa 1f             	sar    $0x1f,%edx
  80050b:	31 d0                	xor    %edx,%eax
  80050d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050f:	83 f8 0f             	cmp    $0xf,%eax
  800512:	7f 0b                	jg     80051f <vprintfmt+0x155>
  800514:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  80051b:	85 d2                	test   %edx,%edx
  80051d:	75 23                	jne    800542 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80051f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800523:	c7 44 24 08 93 23 80 	movl   $0x802393,0x8(%esp)
  80052a:	00 
  80052b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80052f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800532:	89 3c 24             	mov    %edi,(%esp)
  800535:	e8 68 fe ff ff       	call   8003a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80053d:	e9 ab fe ff ff       	jmp    8003ed <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800542:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800546:	c7 44 24 08 79 27 80 	movl   $0x802779,0x8(%esp)
  80054d:	00 
  80054e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800552:	8b 7d 08             	mov    0x8(%ebp),%edi
  800555:	89 3c 24             	mov    %edi,(%esp)
  800558:	e8 45 fe ff ff       	call   8003a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800560:	e9 88 fe ff ff       	jmp    8003ed <vprintfmt+0x23>
  800565:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 50 04             	lea    0x4(%eax),%edx
  800574:	89 55 14             	mov    %edx,0x14(%ebp)
  800577:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800579:	85 f6                	test   %esi,%esi
  80057b:	ba 8c 23 80 00       	mov    $0x80238c,%edx
  800580:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800583:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800587:	7e 06                	jle    80058f <vprintfmt+0x1c5>
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	75 10                	jne    80059f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058f:	0f be 06             	movsbl (%esi),%eax
  800592:	83 c6 01             	add    $0x1,%esi
  800595:	85 c0                	test   %eax,%eax
  800597:	0f 85 86 00 00 00    	jne    800623 <vprintfmt+0x259>
  80059d:	eb 76                	jmp    800615 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a3:	89 34 24             	mov    %esi,(%esp)
  8005a6:	e8 90 02 00 00       	call   80083b <strnlen>
  8005ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ae:	29 c2                	sub    %eax,%edx
  8005b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005b3:	85 d2                	test   %edx,%edx
  8005b5:	7e d8                	jle    80058f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005b7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005be:	89 d6                	mov    %edx,%esi
  8005c0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8005c3:	89 c7                	mov    %eax,%edi
  8005c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c9:	89 3c 24             	mov    %edi,(%esp)
  8005cc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cf:	83 ee 01             	sub    $0x1,%esi
  8005d2:	75 f1                	jne    8005c5 <vprintfmt+0x1fb>
  8005d4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005d7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8005da:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8005dd:	eb b0                	jmp    80058f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e3:	74 18                	je     8005fd <vprintfmt+0x233>
  8005e5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005e8:	83 fa 5e             	cmp    $0x5e,%edx
  8005eb:	76 10                	jbe    8005fd <vprintfmt+0x233>
					putch('?', putdat);
  8005ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005f1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005f8:	ff 55 08             	call   *0x8(%ebp)
  8005fb:	eb 0a                	jmp    800607 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8005fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800607:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80060b:	0f be 06             	movsbl (%esi),%eax
  80060e:	83 c6 01             	add    $0x1,%esi
  800611:	85 c0                	test   %eax,%eax
  800613:	75 0e                	jne    800623 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	7f 16                	jg     800634 <vprintfmt+0x26a>
  80061e:	e9 ca fd ff ff       	jmp    8003ed <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800623:	85 ff                	test   %edi,%edi
  800625:	78 b8                	js     8005df <vprintfmt+0x215>
  800627:	83 ef 01             	sub    $0x1,%edi
  80062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800630:	79 ad                	jns    8005df <vprintfmt+0x215>
  800632:	eb e1                	jmp    800615 <vprintfmt+0x24b>
  800634:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800637:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80063a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80063e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800645:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800647:	83 ee 01             	sub    $0x1,%esi
  80064a:	75 ee                	jne    80063a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80064f:	e9 99 fd ff ff       	jmp    8003ed <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800654:	83 f9 01             	cmp    $0x1,%ecx
  800657:	7e 10                	jle    800669 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 50 08             	lea    0x8(%eax),%edx
  80065f:	89 55 14             	mov    %edx,0x14(%ebp)
  800662:	8b 30                	mov    (%eax),%esi
  800664:	8b 78 04             	mov    0x4(%eax),%edi
  800667:	eb 26                	jmp    80068f <vprintfmt+0x2c5>
	else if (lflag)
  800669:	85 c9                	test   %ecx,%ecx
  80066b:	74 12                	je     80067f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 50 04             	lea    0x4(%eax),%edx
  800673:	89 55 14             	mov    %edx,0x14(%ebp)
  800676:	8b 30                	mov    (%eax),%esi
  800678:	89 f7                	mov    %esi,%edi
  80067a:	c1 ff 1f             	sar    $0x1f,%edi
  80067d:	eb 10                	jmp    80068f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 f7                	mov    %esi,%edi
  80068c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800694:	85 ff                	test   %edi,%edi
  800696:	0f 89 8c 00 00 00    	jns    800728 <vprintfmt+0x35e>
				putch('-', putdat);
  80069c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006a7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006aa:	f7 de                	neg    %esi
  8006ac:	83 d7 00             	adc    $0x0,%edi
  8006af:	f7 df                	neg    %edi
			}
			base = 10;
  8006b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b6:	eb 70                	jmp    800728 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b8:	89 ca                	mov    %ecx,%edx
  8006ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bd:	e8 89 fc ff ff       	call   80034b <getuint>
  8006c2:	89 c6                	mov    %eax,%esi
  8006c4:	89 d7                	mov    %edx,%edi
			base = 10;
  8006c6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006cb:	eb 5b                	jmp    800728 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006cd:	89 ca                	mov    %ecx,%edx
  8006cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d2:	e8 74 fc ff ff       	call   80034b <getuint>
  8006d7:	89 c6                	mov    %eax,%esi
  8006d9:	89 d7                	mov    %edx,%edi
			base = 8;
  8006db:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006e0:	eb 46                	jmp    800728 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8006e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 50 04             	lea    0x4(%eax),%edx
  800704:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800707:	8b 30                	mov    (%eax),%esi
  800709:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80070e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800713:	eb 13                	jmp    800728 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800715:	89 ca                	mov    %ecx,%edx
  800717:	8d 45 14             	lea    0x14(%ebp),%eax
  80071a:	e8 2c fc ff ff       	call   80034b <getuint>
  80071f:	89 c6                	mov    %eax,%esi
  800721:	89 d7                	mov    %edx,%edi
			base = 16;
  800723:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800728:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80072c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800733:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800737:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073b:	89 34 24             	mov    %esi,(%esp)
  80073e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800742:	89 da                	mov    %ebx,%edx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	e8 24 fb ff ff       	call   800270 <printnum>
			break;
  80074c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80074f:	e9 99 fc ff ff       	jmp    8003ed <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800754:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800758:	89 14 24             	mov    %edx,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800761:	e9 87 fc ff ff       	jmp    8003ed <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800766:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80076a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800771:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800774:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800778:	0f 84 6f fc ff ff    	je     8003ed <vprintfmt+0x23>
  80077e:	83 ee 01             	sub    $0x1,%esi
  800781:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800785:	75 f7                	jne    80077e <vprintfmt+0x3b4>
  800787:	e9 61 fc ff ff       	jmp    8003ed <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80078c:	83 c4 4c             	add    $0x4c,%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 28             	sub    $0x28,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	74 30                	je     8007e5 <vsnprintf+0x51>
  8007b5:	85 d2                	test   %edx,%edx
  8007b7:	7e 2c                	jle    8007e5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ce:	c7 04 24 85 03 80 00 	movl   $0x800385,(%esp)
  8007d5:	e8 f0 fb ff ff       	call   8003ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e3:	eb 05                	jmp    8007ea <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	89 44 24 04          	mov    %eax,0x4(%esp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	e8 82 ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    
	...

00800820 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	80 3a 00             	cmpb   $0x0,(%edx)
  80082e:	74 09                	je     800839 <strlen+0x19>
		n++;
  800830:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800837:	75 f7                	jne    800830 <strlen+0x10>
		n++;
	return n;
}
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	53                   	push   %ebx
  80083f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	85 c9                	test   %ecx,%ecx
  80084c:	74 1a                	je     800868 <strnlen+0x2d>
  80084e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800851:	74 15                	je     800868 <strnlen+0x2d>
  800853:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800858:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085a:	39 ca                	cmp    %ecx,%edx
  80085c:	74 0a                	je     800868 <strnlen+0x2d>
  80085e:	83 c2 01             	add    $0x1,%edx
  800861:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800866:	75 f0                	jne    800858 <strnlen+0x1d>
		n++;
	return n;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800875:	ba 00 00 00 00       	mov    $0x0,%edx
  80087a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80087e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800881:	83 c2 01             	add    $0x1,%edx
  800884:	84 c9                	test   %cl,%cl
  800886:	75 f2                	jne    80087a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800895:	89 1c 24             	mov    %ebx,(%esp)
  800898:	e8 83 ff ff ff       	call   800820 <strlen>
	strcpy(dst + len, src);
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a4:	01 d8                	add    %ebx,%eax
  8008a6:	89 04 24             	mov    %eax,(%esp)
  8008a9:	e8 bd ff ff ff       	call   80086b <strcpy>
	return dst;
}
  8008ae:	89 d8                	mov    %ebx,%eax
  8008b0:	83 c4 08             	add    $0x8,%esp
  8008b3:	5b                   	pop    %ebx
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c4:	85 f6                	test   %esi,%esi
  8008c6:	74 18                	je     8008e0 <strncpy+0x2a>
  8008c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008cd:	0f b6 1a             	movzbl (%edx),%ebx
  8008d0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d3:	80 3a 01             	cmpb   $0x1,(%edx)
  8008d6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d9:	83 c1 01             	add    $0x1,%ecx
  8008dc:	39 f1                	cmp    %esi,%ecx
  8008de:	75 ed                	jne    8008cd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	57                   	push   %edi
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	89 f8                	mov    %edi,%eax
  8008f5:	85 f6                	test   %esi,%esi
  8008f7:	74 2b                	je     800924 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8008f9:	83 fe 01             	cmp    $0x1,%esi
  8008fc:	74 23                	je     800921 <strlcpy+0x3d>
  8008fe:	0f b6 0b             	movzbl (%ebx),%ecx
  800901:	84 c9                	test   %cl,%cl
  800903:	74 1c                	je     800921 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800905:	83 ee 02             	sub    $0x2,%esi
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80090d:	88 08                	mov    %cl,(%eax)
  80090f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 f2                	cmp    %esi,%edx
  800914:	74 0b                	je     800921 <strlcpy+0x3d>
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091d:	84 c9                	test   %cl,%cl
  80091f:	75 ec                	jne    80090d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800921:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800924:	29 f8                	sub    %edi,%eax
}
  800926:	5b                   	pop    %ebx
  800927:	5e                   	pop    %esi
  800928:	5f                   	pop    %edi
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800934:	0f b6 01             	movzbl (%ecx),%eax
  800937:	84 c0                	test   %al,%al
  800939:	74 16                	je     800951 <strcmp+0x26>
  80093b:	3a 02                	cmp    (%edx),%al
  80093d:	75 12                	jne    800951 <strcmp+0x26>
		p++, q++;
  80093f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800942:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800946:	84 c0                	test   %al,%al
  800948:	74 07                	je     800951 <strcmp+0x26>
  80094a:	83 c1 01             	add    $0x1,%ecx
  80094d:	3a 02                	cmp    (%edx),%al
  80094f:	74 ee                	je     80093f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800951:	0f b6 c0             	movzbl %al,%eax
  800954:	0f b6 12             	movzbl (%edx),%edx
  800957:	29 d0                	sub    %edx,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800962:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800965:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096d:	85 d2                	test   %edx,%edx
  80096f:	74 28                	je     800999 <strncmp+0x3e>
  800971:	0f b6 01             	movzbl (%ecx),%eax
  800974:	84 c0                	test   %al,%al
  800976:	74 24                	je     80099c <strncmp+0x41>
  800978:	3a 03                	cmp    (%ebx),%al
  80097a:	75 20                	jne    80099c <strncmp+0x41>
  80097c:	83 ea 01             	sub    $0x1,%edx
  80097f:	74 13                	je     800994 <strncmp+0x39>
		n--, p++, q++;
  800981:	83 c1 01             	add    $0x1,%ecx
  800984:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800987:	0f b6 01             	movzbl (%ecx),%eax
  80098a:	84 c0                	test   %al,%al
  80098c:	74 0e                	je     80099c <strncmp+0x41>
  80098e:	3a 03                	cmp    (%ebx),%al
  800990:	74 ea                	je     80097c <strncmp+0x21>
  800992:	eb 08                	jmp    80099c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800999:	5b                   	pop    %ebx
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80099c:	0f b6 01             	movzbl (%ecx),%eax
  80099f:	0f b6 13             	movzbl (%ebx),%edx
  8009a2:	29 d0                	sub    %edx,%eax
  8009a4:	eb f3                	jmp    800999 <strncmp+0x3e>

008009a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	0f b6 10             	movzbl (%eax),%edx
  8009b3:	84 d2                	test   %dl,%dl
  8009b5:	74 1c                	je     8009d3 <strchr+0x2d>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	75 09                	jne    8009c4 <strchr+0x1e>
  8009bb:	eb 1b                	jmp    8009d8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009bd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 14                	je     8009d8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009c4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8009c8:	84 d2                	test   %dl,%dl
  8009ca:	75 f1                	jne    8009bd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	eb 05                	jmp    8009d8 <strchr+0x32>
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
  8009e7:	84 d2                	test   %dl,%dl
  8009e9:	74 14                	je     8009ff <strfind+0x25>
		if (*s == c)
  8009eb:	38 ca                	cmp    %cl,%dl
  8009ed:	75 06                	jne    8009f5 <strfind+0x1b>
  8009ef:	eb 0e                	jmp    8009ff <strfind+0x25>
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	0f b6 10             	movzbl (%eax),%edx
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	75 f2                	jne    8009f1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 0c             	sub    $0xc,%esp
  800a07:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a0a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a0d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a10:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a19:	85 c9                	test   %ecx,%ecx
  800a1b:	74 30                	je     800a4d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a1d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a23:	75 25                	jne    800a4a <memset+0x49>
  800a25:	f6 c1 03             	test   $0x3,%cl
  800a28:	75 20                	jne    800a4a <memset+0x49>
		c &= 0xFF;
  800a2a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2d:	89 d3                	mov    %edx,%ebx
  800a2f:	c1 e3 08             	shl    $0x8,%ebx
  800a32:	89 d6                	mov    %edx,%esi
  800a34:	c1 e6 18             	shl    $0x18,%esi
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	c1 e0 10             	shl    $0x10,%eax
  800a3c:	09 f0                	or     %esi,%eax
  800a3e:	09 d0                	or     %edx,%eax
  800a40:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a42:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a45:	fc                   	cld    
  800a46:	f3 ab                	rep stos %eax,%es:(%edi)
  800a48:	eb 03                	jmp    800a4d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4a:	fc                   	cld    
  800a4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4d:	89 f8                	mov    %edi,%eax
  800a4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a58:	89 ec                	mov    %ebp,%esp
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a65:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a71:	39 c6                	cmp    %eax,%esi
  800a73:	73 36                	jae    800aab <memmove+0x4f>
  800a75:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a78:	39 d0                	cmp    %edx,%eax
  800a7a:	73 2f                	jae    800aab <memmove+0x4f>
		s += n;
		d += n;
  800a7c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 1b                	jne    800a9f <memmove+0x43>
  800a84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8a:	75 13                	jne    800a9f <memmove+0x43>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 20                	jmp    800acb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab1:	75 13                	jne    800ac6 <memmove+0x6a>
  800ab3:	a8 03                	test   $0x3,%al
  800ab5:	75 0f                	jne    800ac6 <memmove+0x6a>
  800ab7:	f6 c1 03             	test   $0x3,%cl
  800aba:	75 0a                	jne    800ac6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abf:	89 c7                	mov    %eax,%edi
  800ac1:	fc                   	cld    
  800ac2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac4:	eb 05                	jmp    800acb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	fc                   	cld    
  800ac9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ace:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ad1:	89 ec                	mov    %ebp,%esp
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	89 04 24             	mov    %eax,(%esp)
  800aef:	e8 68 ff ff ff       	call   800a5c <memmove>
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
  800afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800aff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b02:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0a:	85 ff                	test   %edi,%edi
  800b0c:	74 37                	je     800b45 <memcmp+0x4f>
		if (*s1 != *s2)
  800b0e:	0f b6 03             	movzbl (%ebx),%eax
  800b11:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b14:	83 ef 01             	sub    $0x1,%edi
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b1c:	38 c8                	cmp    %cl,%al
  800b1e:	74 1c                	je     800b3c <memcmp+0x46>
  800b20:	eb 10                	jmp    800b32 <memcmp+0x3c>
  800b22:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b2e:	38 c8                	cmp    %cl,%al
  800b30:	74 0a                	je     800b3c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800b32:	0f b6 c0             	movzbl %al,%eax
  800b35:	0f b6 c9             	movzbl %cl,%ecx
  800b38:	29 c8                	sub    %ecx,%eax
  800b3a:	eb 09                	jmp    800b45 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3c:	39 fa                	cmp    %edi,%edx
  800b3e:	75 e2                	jne    800b22 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b55:	39 d0                	cmp    %edx,%eax
  800b57:	73 19                	jae    800b72 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b5d:	38 08                	cmp    %cl,(%eax)
  800b5f:	75 06                	jne    800b67 <memfind+0x1d>
  800b61:	eb 0f                	jmp    800b72 <memfind+0x28>
  800b63:	38 08                	cmp    %cl,(%eax)
  800b65:	74 0b                	je     800b72 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b67:	83 c0 01             	add    $0x1,%eax
  800b6a:	39 d0                	cmp    %edx,%eax
  800b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b70:	75 f1                	jne    800b63 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b80:	0f b6 02             	movzbl (%edx),%eax
  800b83:	3c 20                	cmp    $0x20,%al
  800b85:	74 04                	je     800b8b <strtol+0x17>
  800b87:	3c 09                	cmp    $0x9,%al
  800b89:	75 0e                	jne    800b99 <strtol+0x25>
		s++;
  800b8b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8e:	0f b6 02             	movzbl (%edx),%eax
  800b91:	3c 20                	cmp    $0x20,%al
  800b93:	74 f6                	je     800b8b <strtol+0x17>
  800b95:	3c 09                	cmp    $0x9,%al
  800b97:	74 f2                	je     800b8b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b99:	3c 2b                	cmp    $0x2b,%al
  800b9b:	75 0a                	jne    800ba7 <strtol+0x33>
		s++;
  800b9d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba5:	eb 10                	jmp    800bb7 <strtol+0x43>
  800ba7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bac:	3c 2d                	cmp    $0x2d,%al
  800bae:	75 07                	jne    800bb7 <strtol+0x43>
		s++, neg = 1;
  800bb0:	83 c2 01             	add    $0x1,%edx
  800bb3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	0f 94 c0             	sete   %al
  800bbc:	74 05                	je     800bc3 <strtol+0x4f>
  800bbe:	83 fb 10             	cmp    $0x10,%ebx
  800bc1:	75 15                	jne    800bd8 <strtol+0x64>
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 10                	jne    800bd8 <strtol+0x64>
  800bc8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bcc:	75 0a                	jne    800bd8 <strtol+0x64>
		s += 2, base = 16;
  800bce:	83 c2 02             	add    $0x2,%edx
  800bd1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd6:	eb 13                	jmp    800beb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800bd8:	84 c0                	test   %al,%al
  800bda:	74 0f                	je     800beb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be1:	80 3a 30             	cmpb   $0x30,(%edx)
  800be4:	75 05                	jne    800beb <strtol+0x77>
		s++, base = 8;
  800be6:	83 c2 01             	add    $0x1,%edx
  800be9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf2:	0f b6 0a             	movzbl (%edx),%ecx
  800bf5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bf8:	80 fb 09             	cmp    $0x9,%bl
  800bfb:	77 08                	ja     800c05 <strtol+0x91>
			dig = *s - '0';
  800bfd:	0f be c9             	movsbl %cl,%ecx
  800c00:	83 e9 30             	sub    $0x30,%ecx
  800c03:	eb 1e                	jmp    800c23 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c05:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c08:	80 fb 19             	cmp    $0x19,%bl
  800c0b:	77 08                	ja     800c15 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c0d:	0f be c9             	movsbl %cl,%ecx
  800c10:	83 e9 57             	sub    $0x57,%ecx
  800c13:	eb 0e                	jmp    800c23 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c15:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 14                	ja     800c31 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c1d:	0f be c9             	movsbl %cl,%ecx
  800c20:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c23:	39 f1                	cmp    %esi,%ecx
  800c25:	7d 0e                	jge    800c35 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c27:	83 c2 01             	add    $0x1,%edx
  800c2a:	0f af c6             	imul   %esi,%eax
  800c2d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c2f:	eb c1                	jmp    800bf2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c31:	89 c1                	mov    %eax,%ecx
  800c33:	eb 02                	jmp    800c37 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c35:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 05                	je     800c42 <strtol+0xce>
		*endptr = (char *) s;
  800c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c40:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c42:	89 ca                	mov    %ecx,%edx
  800c44:	f7 da                	neg    %edx
  800c46:	85 ff                	test   %edi,%edi
  800c48:	0f 45 c2             	cmovne %edx,%eax
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	89 c3                	mov    %eax,%ebx
  800c6c:	89 c7                	mov    %eax,%edi
  800c6e:	89 c6                	mov    %eax,%esi
  800c70:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c7b:	89 ec                	mov    %ebp,%esp
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c93:	b8 01 00 00 00       	mov    $0x1,%eax
  800c98:	89 d1                	mov    %edx,%ecx
  800c9a:	89 d3                	mov    %edx,%ebx
  800c9c:	89 d7                	mov    %edx,%edi
  800c9e:	89 d6                	mov    %edx,%esi
  800ca0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ca5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ca8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cab:	89 ec                	mov    %ebp,%esp
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 38             	sub    $0x38,%esp
  800cb5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cb8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccb:	89 cb                	mov    %ecx,%ebx
  800ccd:	89 cf                	mov    %ecx,%edi
  800ccf:	89 ce                	mov    %ecx,%esi
  800cd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800cfa:	e8 51 f4 ff ff       	call   800150 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d08:	89 ec                	mov    %ebp,%esp
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d15:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d18:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d38:	89 ec                	mov    %ebp,%esp
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_yield>:

void
sys_yield(void)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d55:	89 d1                	mov    %edx,%ecx
  800d57:	89 d3                	mov    %edx,%ebx
  800d59:	89 d7                	mov    %edx,%edi
  800d5b:	89 d6                	mov    %edx,%esi
  800d5d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d68:	89 ec                	mov    %ebp,%esp
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 38             	sub    $0x38,%esp
  800d72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7b:	be 00 00 00 00       	mov    $0x0,%esi
  800d80:	b8 04 00 00 00       	mov    $0x4,%eax
  800d85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	89 f7                	mov    %esi,%edi
  800d90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	7e 28                	jle    800dbe <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800da1:	00 
  800da2:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800da9:	00 
  800daa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db1:	00 
  800db2:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800db9:	e8 92 f3 ff ff       	call   800150 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dbe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dc4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc7:	89 ec                	mov    %ebp,%esp
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 38             	sub    $0x38,%esp
  800dd1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dd4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dda:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddf:	8b 75 18             	mov    0x18(%ebp),%esi
  800de2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7e 28                	jle    800e1c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dff:	00 
  800e00:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800e07:	00 
  800e08:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0f:	00 
  800e10:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800e17:	e8 34 f3 ff ff       	call   800150 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e1c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e1f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e22:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e25:	89 ec                	mov    %ebp,%esp
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 38             	sub    $0x38,%esp
  800e2f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e32:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e35:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	89 df                	mov    %ebx,%edi
  800e4a:	89 de                	mov    %ebx,%esi
  800e4c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	7e 28                	jle    800e7a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e56:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e5d:	00 
  800e5e:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800e65:	00 
  800e66:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6d:	00 
  800e6e:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800e75:	e8 d6 f2 ff ff       	call   800150 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e7d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e80:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e83:	89 ec                	mov    %ebp,%esp
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 38             	sub    $0x38,%esp
  800e8d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e90:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e93:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7e 28                	jle    800ed8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecb:	00 
  800ecc:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800ed3:	e8 78 f2 ff ff       	call   800150 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800edb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ede:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee1:	89 ec                	mov    %ebp,%esp
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 38             	sub    $0x38,%esp
  800eeb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	b8 09 00 00 00       	mov    $0x9,%eax
  800efe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7e 28                	jle    800f36 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f12:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f19:	00 
  800f1a:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800f21:	00 
  800f22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f29:	00 
  800f2a:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800f31:	e8 1a f2 ff ff       	call   800150 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3f:	89 ec                	mov    %ebp,%esp
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 38             	sub    $0x38,%esp
  800f49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	89 de                	mov    %ebx,%esi
  800f66:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7e 28                	jle    800f94 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f70:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f77:	00 
  800f78:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800f7f:	00 
  800f80:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f87:	00 
  800f88:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  800f8f:	e8 bc f1 ff ff       	call   800150 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f94:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f97:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f9a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f9d:	89 ec                	mov    %ebp,%esp
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800faa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb0:	be 00 00 00 00       	mov    $0x0,%esi
  800fb5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fcb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd1:	89 ec                	mov    %ebp,%esp
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 38             	sub    $0x38,%esp
  800fdb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fde:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7e 28                	jle    801025 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801001:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801008:	00 
  801009:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  801010:	00 
  801011:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801018:	00 
  801019:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  801020:	e8 2b f1 ff ff       	call   800150 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801025:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801028:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102e:	89 ec                	mov    %ebp,%esp
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
	...

00801034 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80103a:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801041:	75 54                	jne    801097 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  801043:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80104a:	00 
  80104b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801052:	ee 
  801053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80105a:	e8 0d fd ff ff       	call   800d6c <sys_page_alloc>
  80105f:	85 c0                	test   %eax,%eax
  801061:	79 20                	jns    801083 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  801063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801067:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80106e:	00 
  80106f:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801076:	00 
  801077:	c7 04 24 c2 26 80 00 	movl   $0x8026c2,(%esp)
  80107e:	e8 cd f0 ff ff       	call   800150 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801083:	c7 44 24 04 a4 10 80 	movl   $0x8010a4,0x4(%esp)
  80108a:	00 
  80108b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801092:	e8 ac fe ff ff       	call   800f43 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	a3 08 40 80 00       	mov    %eax,0x804008
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    
  8010a1:	00 00                	add    %al,(%eax)
	...

008010a4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010a4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010a5:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  8010aa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010ac:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8010af:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8010b3:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8010b6:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8010ba:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8010be:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8010c0:	83 c4 08             	add    $0x8,%esp
	popal
  8010c3:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010c4:	83 c4 04             	add    $0x4,%esp
	popfl
  8010c7:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8010c8:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010c9:	c3                   	ret    
  8010ca:	00 00                	add    %al,(%eax)
  8010cc:	00 00                	add    %al,(%eax)
	...

008010d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010db:	c1 e8 0c             	shr    $0xc,%eax
}
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 04 24             	mov    %eax,(%esp)
  8010ec:	e8 df ff ff ff       	call   8010d0 <fd2num>
  8010f1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8010f6:	c1 e0 0c             	shl    $0xc,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	53                   	push   %ebx
  8010ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801102:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801107:	a8 01                	test   $0x1,%al
  801109:	74 34                	je     80113f <fd_alloc+0x44>
  80110b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801110:	a8 01                	test   $0x1,%al
  801112:	74 32                	je     801146 <fd_alloc+0x4b>
  801114:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801119:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	c1 ea 16             	shr    $0x16,%edx
  801120:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	74 1f                	je     80114b <fd_alloc+0x50>
  80112c:	89 c2                	mov    %eax,%edx
  80112e:	c1 ea 0c             	shr    $0xc,%edx
  801131:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801138:	f6 c2 01             	test   $0x1,%dl
  80113b:	75 17                	jne    801154 <fd_alloc+0x59>
  80113d:	eb 0c                	jmp    80114b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80113f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801144:	eb 05                	jmp    80114b <fd_alloc+0x50>
  801146:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80114b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	eb 17                	jmp    80116b <fd_alloc+0x70>
  801154:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801159:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80115e:	75 b9                	jne    801119 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801160:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801166:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80116b:	5b                   	pop    %ebx
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801174:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801179:	83 fa 1f             	cmp    $0x1f,%edx
  80117c:	77 3f                	ja     8011bd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80117e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801184:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801187:	89 d0                	mov    %edx,%eax
  801189:	c1 e8 16             	shr    $0x16,%eax
  80118c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801193:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801198:	f6 c1 01             	test   $0x1,%cl
  80119b:	74 20                	je     8011bd <fd_lookup+0x4f>
  80119d:	89 d0                	mov    %edx,%eax
  80119f:	c1 e8 0c             	shr    $0xc,%eax
  8011a2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011ae:	f6 c1 01             	test   $0x1,%cl
  8011b1:	74 0a                	je     8011bd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	89 10                	mov    %edx,(%eax)
	return 0;
  8011b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bd:	5d                   	pop    %ebp
  8011be:	c3                   	ret    

008011bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 14             	sub    $0x14,%esp
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011d1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8011d7:	75 17                	jne    8011f0 <dev_lookup+0x31>
  8011d9:	eb 07                	jmp    8011e2 <dev_lookup+0x23>
  8011db:	39 0a                	cmp    %ecx,(%edx)
  8011dd:	75 11                	jne    8011f0 <dev_lookup+0x31>
  8011df:	90                   	nop
  8011e0:	eb 05                	jmp    8011e7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011e2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011e7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8011e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ee:	eb 35                	jmp    801225 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011f0:	83 c0 01             	add    $0x1,%eax
  8011f3:	8b 14 85 50 27 80 00 	mov    0x802750(,%eax,4),%edx
  8011fa:	85 d2                	test   %edx,%edx
  8011fc:	75 dd                	jne    8011db <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011fe:	a1 04 40 80 00       	mov    0x804004,%eax
  801203:	8b 40 48             	mov    0x48(%eax),%eax
  801206:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80120a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120e:	c7 04 24 d0 26 80 00 	movl   $0x8026d0,(%esp)
  801215:	e8 31 f0 ff ff       	call   80024b <cprintf>
	*dev = 0;
  80121a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801220:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801225:	83 c4 14             	add    $0x14,%esp
  801228:	5b                   	pop    %ebx
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 38             	sub    $0x38,%esp
  801231:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801234:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801237:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80123a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80123d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801241:	89 3c 24             	mov    %edi,(%esp)
  801244:	e8 87 fe ff ff       	call   8010d0 <fd2num>
  801249:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80124c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801250:	89 04 24             	mov    %eax,(%esp)
  801253:	e8 16 ff ff ff       	call   80116e <fd_lookup>
  801258:	89 c3                	mov    %eax,%ebx
  80125a:	85 c0                	test   %eax,%eax
  80125c:	78 05                	js     801263 <fd_close+0x38>
	    || fd != fd2)
  80125e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801261:	74 0e                	je     801271 <fd_close+0x46>
		return (must_exist ? r : 0);
  801263:	89 f0                	mov    %esi,%eax
  801265:	84 c0                	test   %al,%al
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	0f 44 d8             	cmove  %eax,%ebx
  80126f:	eb 3d                	jmp    8012ae <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801271:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801274:	89 44 24 04          	mov    %eax,0x4(%esp)
  801278:	8b 07                	mov    (%edi),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 3d ff ff ff       	call   8011bf <dev_lookup>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	85 c0                	test   %eax,%eax
  801286:	78 16                	js     80129e <fd_close+0x73>
		if (dev->dev_close)
  801288:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801293:	85 c0                	test   %eax,%eax
  801295:	74 07                	je     80129e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801297:	89 3c 24             	mov    %edi,(%esp)
  80129a:	ff d0                	call   *%eax
  80129c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80129e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a9:	e8 7b fb ff ff       	call   800e29 <sys_page_unmap>
	return r;
}
  8012ae:	89 d8                	mov    %ebx,%eax
  8012b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012b9:	89 ec                	mov    %ebp,%esp
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	89 04 24             	mov    %eax,(%esp)
  8012d0:	e8 99 fe ff ff       	call   80116e <fd_lookup>
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 13                	js     8012ec <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8012d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012e0:	00 
  8012e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e4:	89 04 24             	mov    %eax,(%esp)
  8012e7:	e8 3f ff ff ff       	call   80122b <fd_close>
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <close_all>:

void
close_all(void)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012fa:	89 1c 24             	mov    %ebx,(%esp)
  8012fd:	e8 bb ff ff ff       	call   8012bd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801302:	83 c3 01             	add    $0x1,%ebx
  801305:	83 fb 20             	cmp    $0x20,%ebx
  801308:	75 f0                	jne    8012fa <close_all+0xc>
		close(i);
}
  80130a:	83 c4 14             	add    $0x14,%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 58             	sub    $0x58,%esp
  801316:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801319:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80131c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80131f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801322:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801325:	89 44 24 04          	mov    %eax,0x4(%esp)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	89 04 24             	mov    %eax,(%esp)
  80132f:	e8 3a fe ff ff       	call   80116e <fd_lookup>
  801334:	89 c3                	mov    %eax,%ebx
  801336:	85 c0                	test   %eax,%eax
  801338:	0f 88 e1 00 00 00    	js     80141f <dup+0x10f>
		return r;
	close(newfdnum);
  80133e:	89 3c 24             	mov    %edi,(%esp)
  801341:	e8 77 ff ff ff       	call   8012bd <close>

	newfd = INDEX2FD(newfdnum);
  801346:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80134c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80134f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	e8 86 fd ff ff       	call   8010e0 <fd2data>
  80135a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80135c:	89 34 24             	mov    %esi,(%esp)
  80135f:	e8 7c fd ff ff       	call   8010e0 <fd2data>
  801364:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801367:	89 d8                	mov    %ebx,%eax
  801369:	c1 e8 16             	shr    $0x16,%eax
  80136c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801373:	a8 01                	test   $0x1,%al
  801375:	74 46                	je     8013bd <dup+0xad>
  801377:	89 d8                	mov    %ebx,%eax
  801379:	c1 e8 0c             	shr    $0xc,%eax
  80137c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801383:	f6 c2 01             	test   $0x1,%dl
  801386:	74 35                	je     8013bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801388:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138f:	25 07 0e 00 00       	and    $0xe07,%eax
  801394:	89 44 24 10          	mov    %eax,0x10(%esp)
  801398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80139b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80139f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013a6:	00 
  8013a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b2:	e8 14 fa ff ff       	call   800dcb <sys_page_map>
  8013b7:	89 c3                	mov    %eax,%ebx
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 3b                	js     8013f8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	c1 ea 0c             	shr    $0xc,%edx
  8013c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013cc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013e1:	00 
  8013e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ed:	e8 d9 f9 ff ff       	call   800dcb <sys_page_map>
  8013f2:	89 c3                	mov    %eax,%ebx
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	79 25                	jns    80141d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801403:	e8 21 fa ff ff       	call   800e29 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80140b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801416:	e8 0e fa ff ff       	call   800e29 <sys_page_unmap>
	return r;
  80141b:	eb 02                	jmp    80141f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80141d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141f:	89 d8                	mov    %ebx,%eax
  801421:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801424:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801427:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80142a:	89 ec                	mov    %ebp,%esp
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	53                   	push   %ebx
  801432:	83 ec 24             	sub    $0x24,%esp
  801435:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801438:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143f:	89 1c 24             	mov    %ebx,(%esp)
  801442:	e8 27 fd ff ff       	call   80116e <fd_lookup>
  801447:	85 c0                	test   %eax,%eax
  801449:	78 6d                	js     8014b8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801455:	8b 00                	mov    (%eax),%eax
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	e8 60 fd ff ff       	call   8011bf <dev_lookup>
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 55                	js     8014b8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801466:	8b 50 08             	mov    0x8(%eax),%edx
  801469:	83 e2 03             	and    $0x3,%edx
  80146c:	83 fa 01             	cmp    $0x1,%edx
  80146f:	75 23                	jne    801494 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801471:	a1 04 40 80 00       	mov    0x804004,%eax
  801476:	8b 40 48             	mov    0x48(%eax),%eax
  801479:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801481:	c7 04 24 14 27 80 00 	movl   $0x802714,(%esp)
  801488:	e8 be ed ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  80148d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801492:	eb 24                	jmp    8014b8 <read+0x8a>
	}
	if (!dev->dev_read)
  801494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801497:	8b 52 08             	mov    0x8(%edx),%edx
  80149a:	85 d2                	test   %edx,%edx
  80149c:	74 15                	je     8014b3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80149e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ac:	89 04 24             	mov    %eax,(%esp)
  8014af:	ff d2                	call   *%edx
  8014b1:	eb 05                	jmp    8014b8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014b8:	83 c4 24             	add    $0x24,%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 1c             	sub    $0x1c,%esp
  8014c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d2:	85 f6                	test   %esi,%esi
  8014d4:	74 30                	je     801506 <readn+0x48>
  8014d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014db:	89 f2                	mov    %esi,%edx
  8014dd:	29 c2                	sub    %eax,%edx
  8014df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014e3:	03 45 0c             	add    0xc(%ebp),%eax
  8014e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ea:	89 3c 24             	mov    %edi,(%esp)
  8014ed:	e8 3c ff ff ff       	call   80142e <read>
		if (m < 0)
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 10                	js     801506 <readn+0x48>
			return m;
		if (m == 0)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	74 0a                	je     801504 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fa:	01 c3                	add    %eax,%ebx
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	39 f3                	cmp    %esi,%ebx
  801500:	72 d9                	jb     8014db <readn+0x1d>
  801502:	eb 02                	jmp    801506 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801504:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801506:	83 c4 1c             	add    $0x1c,%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 24             	sub    $0x24,%esp
  801515:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151f:	89 1c 24             	mov    %ebx,(%esp)
  801522:	e8 47 fc ff ff       	call   80116e <fd_lookup>
  801527:	85 c0                	test   %eax,%eax
  801529:	78 68                	js     801593 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 80 fc ff ff       	call   8011bf <dev_lookup>
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 50                	js     801593 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154a:	75 23                	jne    80156f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80154c:	a1 04 40 80 00       	mov    0x804004,%eax
  801551:	8b 40 48             	mov    0x48(%eax),%eax
  801554:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155c:	c7 04 24 30 27 80 00 	movl   $0x802730,(%esp)
  801563:	e8 e3 ec ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156d:	eb 24                	jmp    801593 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80156f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801572:	8b 52 0c             	mov    0xc(%edx),%edx
  801575:	85 d2                	test   %edx,%edx
  801577:	74 15                	je     80158e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801579:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801583:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	ff d2                	call   *%edx
  80158c:	eb 05                	jmp    801593 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80158e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801593:	83 c4 24             	add    $0x24,%esp
  801596:	5b                   	pop    %ebx
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    

00801599 <seek>:

int
seek(int fdnum, off_t offset)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 04 24             	mov    %eax,(%esp)
  8015ac:	e8 bd fb ff ff       	call   80116e <fd_lookup>
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 0e                	js     8015c3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 24             	sub    $0x24,%esp
  8015cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	89 1c 24             	mov    %ebx,(%esp)
  8015d9:	e8 90 fb ff ff       	call   80116e <fd_lookup>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 61                	js     801643 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	89 04 24             	mov    %eax,(%esp)
  8015f1:	e8 c9 fb ff ff       	call   8011bf <dev_lookup>
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 49                	js     801643 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801601:	75 23                	jne    801626 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801603:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801608:	8b 40 48             	mov    0x48(%eax),%eax
  80160b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801613:	c7 04 24 f0 26 80 00 	movl   $0x8026f0,(%esp)
  80161a:	e8 2c ec ff ff       	call   80024b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801624:	eb 1d                	jmp    801643 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801629:	8b 52 18             	mov    0x18(%edx),%edx
  80162c:	85 d2                	test   %edx,%edx
  80162e:	74 0e                	je     80163e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801637:	89 04 24             	mov    %eax,(%esp)
  80163a:	ff d2                	call   *%edx
  80163c:	eb 05                	jmp    801643 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80163e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801643:	83 c4 24             	add    $0x24,%esp
  801646:	5b                   	pop    %ebx
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	53                   	push   %ebx
  80164d:	83 ec 24             	sub    $0x24,%esp
  801650:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801653:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	89 04 24             	mov    %eax,(%esp)
  801660:	e8 09 fb ff ff       	call   80116e <fd_lookup>
  801665:	85 c0                	test   %eax,%eax
  801667:	78 52                	js     8016bb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	8b 00                	mov    (%eax),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 42 fb ff ff       	call   8011bf <dev_lookup>
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 3a                	js     8016bb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801684:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801688:	74 2c                	je     8016b6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80168a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80168d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801694:	00 00 00 
	stat->st_isdir = 0;
  801697:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80169e:	00 00 00 
	stat->st_dev = dev;
  8016a1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ae:	89 14 24             	mov    %edx,(%esp)
  8016b1:	ff 50 14             	call   *0x14(%eax)
  8016b4:	eb 05                	jmp    8016bb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016bb:	83 c4 24             	add    $0x24,%esp
  8016be:	5b                   	pop    %ebx
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 18             	sub    $0x18,%esp
  8016c7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016ca:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016d4:	00 
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	89 04 24             	mov    %eax,(%esp)
  8016db:	e8 bc 01 00 00       	call   80189c <open>
  8016e0:	89 c3                	mov    %eax,%ebx
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 1b                	js     801701 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ed:	89 1c 24             	mov    %ebx,(%esp)
  8016f0:	e8 54 ff ff ff       	call   801649 <fstat>
  8016f5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f7:	89 1c 24             	mov    %ebx,(%esp)
  8016fa:	e8 be fb ff ff       	call   8012bd <close>
	return r;
  8016ff:	89 f3                	mov    %esi,%ebx
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801706:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801709:	89 ec                	mov    %ebp,%esp
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    
  80170d:	00 00                	add    %al,(%eax)
	...

00801710 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 18             	sub    $0x18,%esp
  801716:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801719:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801720:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801727:	75 11                	jne    80173a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801729:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801730:	e8 61 08 00 00       	call   801f96 <ipc_find_env>
  801735:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80173a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801741:	00 
  801742:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801749:	00 
  80174a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80174e:	a1 00 40 80 00       	mov    0x804000,%eax
  801753:	89 04 24             	mov    %eax,(%esp)
  801756:	e8 b7 07 00 00       	call   801f12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80175b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801762:	00 
  801763:	89 74 24 04          	mov    %esi,0x4(%esp)
  801767:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80176e:	e8 4d 07 00 00       	call   801ec0 <ipc_recv>
}
  801773:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801776:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801779:	89 ec                	mov    %ebp,%esp
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    

0080177d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	53                   	push   %ebx
  801781:	83 ec 14             	sub    $0x14,%esp
  801784:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8b 40 0c             	mov    0xc(%eax),%eax
  80178d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 05 00 00 00       	mov    $0x5,%eax
  80179c:	e8 6f ff ff ff       	call   801710 <fsipc>
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 2b                	js     8017d0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017a5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017ac:	00 
  8017ad:	89 1c 24             	mov    %ebx,(%esp)
  8017b0:	e8 b6 f0 ff ff       	call   80086b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b5:	a1 80 50 80 00       	mov    0x805080,%eax
  8017ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c0:	a1 84 50 80 00       	mov    0x805084,%eax
  8017c5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d0:	83 c4 14             	add    $0x14,%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    

008017d6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f1:	e8 1a ff ff ff       	call   801710 <fsipc>
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
  8017fd:	83 ec 10             	sub    $0x10,%esp
  801800:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8b 40 0c             	mov    0xc(%eax),%eax
  801809:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80180e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801814:	ba 00 00 00 00       	mov    $0x0,%edx
  801819:	b8 03 00 00 00       	mov    $0x3,%eax
  80181e:	e8 ed fe ff ff       	call   801710 <fsipc>
  801823:	89 c3                	mov    %eax,%ebx
  801825:	85 c0                	test   %eax,%eax
  801827:	78 6a                	js     801893 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801829:	39 c6                	cmp    %eax,%esi
  80182b:	73 24                	jae    801851 <devfile_read+0x59>
  80182d:	c7 44 24 0c 60 27 80 	movl   $0x802760,0xc(%esp)
  801834:	00 
  801835:	c7 44 24 08 67 27 80 	movl   $0x802767,0x8(%esp)
  80183c:	00 
  80183d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801844:	00 
  801845:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  80184c:	e8 ff e8 ff ff       	call   800150 <_panic>
	assert(r <= PGSIZE);
  801851:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801856:	7e 24                	jle    80187c <devfile_read+0x84>
  801858:	c7 44 24 0c 87 27 80 	movl   $0x802787,0xc(%esp)
  80185f:	00 
  801860:	c7 44 24 08 67 27 80 	movl   $0x802767,0x8(%esp)
  801867:	00 
  801868:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80186f:	00 
  801870:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  801877:	e8 d4 e8 ff ff       	call   800150 <_panic>
	memmove(buf, &fsipcbuf, r);
  80187c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801880:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801887:	00 
  801888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188b:	89 04 24             	mov    %eax,(%esp)
  80188e:	e8 c9 f1 ff ff       	call   800a5c <memmove>
	return r;
}
  801893:	89 d8                	mov    %ebx,%eax
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	83 ec 20             	sub    $0x20,%esp
  8018a4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018a7:	89 34 24             	mov    %esi,(%esp)
  8018aa:	e8 71 ef ff ff       	call   800820 <strlen>
		return -E_BAD_PATH;
  8018af:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018b4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018b9:	7f 5e                	jg     801919 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 35 f8 ff ff       	call   8010fb <fd_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 4d                	js     801919 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018d0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018d7:	e8 8f ef ff ff       	call   80086b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ec:	e8 1f fe ff ff       	call   801710 <fsipc>
  8018f1:	89 c3                	mov    %eax,%ebx
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	79 15                	jns    80190c <open+0x70>
		fd_close(fd, 0);
  8018f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018fe:	00 
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 21 f9 ff ff       	call   80122b <fd_close>
		return r;
  80190a:	eb 0d                	jmp    801919 <open+0x7d>
	}

	return fd2num(fd);
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 b9 f7 ff ff       	call   8010d0 <fd2num>
  801917:	89 c3                	mov    %eax,%ebx
}
  801919:	89 d8                	mov    %ebx,%eax
  80191b:	83 c4 20             	add    $0x20,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    
	...

00801930 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 18             	sub    $0x18,%esp
  801936:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801939:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80193c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	89 04 24             	mov    %eax,(%esp)
  801945:	e8 96 f7 ff ff       	call   8010e0 <fd2data>
  80194a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80194c:	c7 44 24 04 93 27 80 	movl   $0x802793,0x4(%esp)
  801953:	00 
  801954:	89 34 24             	mov    %esi,(%esp)
  801957:	e8 0f ef ff ff       	call   80086b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80195c:	8b 43 04             	mov    0x4(%ebx),%eax
  80195f:	2b 03                	sub    (%ebx),%eax
  801961:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801967:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80196e:	00 00 00 
	stat->st_dev = &devpipe;
  801971:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801978:	30 80 00 
	return 0;
}
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
  801980:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801983:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801986:	89 ec                	mov    %ebp,%esp
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	53                   	push   %ebx
  80198e:	83 ec 14             	sub    $0x14,%esp
  801991:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801994:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801998:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199f:	e8 85 f4 ff ff       	call   800e29 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019a4:	89 1c 24             	mov    %ebx,(%esp)
  8019a7:	e8 34 f7 ff ff       	call   8010e0 <fd2data>
  8019ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b7:	e8 6d f4 ff ff       	call   800e29 <sys_page_unmap>
}
  8019bc:	83 c4 14             	add    $0x14,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5d                   	pop    %ebp
  8019c1:	c3                   	ret    

008019c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	57                   	push   %edi
  8019c6:	56                   	push   %esi
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 2c             	sub    $0x2c,%esp
  8019cb:	89 c7                	mov    %eax,%edi
  8019cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019d8:	89 3c 24             	mov    %edi,(%esp)
  8019db:	e8 00 06 00 00       	call   801fe0 <pageref>
  8019e0:	89 c6                	mov    %eax,%esi
  8019e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	e8 f3 05 00 00       	call   801fe0 <pageref>
  8019ed:	39 c6                	cmp    %eax,%esi
  8019ef:	0f 94 c0             	sete   %al
  8019f2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8019f5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019fe:	39 cb                	cmp    %ecx,%ebx
  801a00:	75 08                	jne    801a0a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801a02:	83 c4 2c             	add    $0x2c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801a0a:	83 f8 01             	cmp    $0x1,%eax
  801a0d:	75 c1                	jne    8019d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a0f:	8b 52 58             	mov    0x58(%edx),%edx
  801a12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a16:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a1e:	c7 04 24 9a 27 80 00 	movl   $0x80279a,(%esp)
  801a25:	e8 21 e8 ff ff       	call   80024b <cprintf>
  801a2a:	eb a4                	jmp    8019d0 <_pipeisclosed+0xe>

00801a2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	57                   	push   %edi
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 2c             	sub    $0x2c,%esp
  801a35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a38:	89 34 24             	mov    %esi,(%esp)
  801a3b:	e8 a0 f6 ff ff       	call   8010e0 <fd2data>
  801a40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a42:	bf 00 00 00 00       	mov    $0x0,%edi
  801a47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a4b:	75 50                	jne    801a9d <devpipe_write+0x71>
  801a4d:	eb 5c                	jmp    801aab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a4f:	89 da                	mov    %ebx,%edx
  801a51:	89 f0                	mov    %esi,%eax
  801a53:	e8 6a ff ff ff       	call   8019c2 <_pipeisclosed>
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	75 53                	jne    801aaf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a5c:	e8 db f2 ff ff       	call   800d3c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a61:	8b 43 04             	mov    0x4(%ebx),%eax
  801a64:	8b 13                	mov    (%ebx),%edx
  801a66:	83 c2 20             	add    $0x20,%edx
  801a69:	39 d0                	cmp    %edx,%eax
  801a6b:	73 e2                	jae    801a4f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801a74:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801a77:	89 c2                	mov    %eax,%edx
  801a79:	c1 fa 1f             	sar    $0x1f,%edx
  801a7c:	c1 ea 1b             	shr    $0x1b,%edx
  801a7f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a82:	83 e1 1f             	and    $0x1f,%ecx
  801a85:	29 d1                	sub    %edx,%ecx
  801a87:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a8b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a8f:	83 c0 01             	add    $0x1,%eax
  801a92:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a95:	83 c7 01             	add    $0x1,%edi
  801a98:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a9b:	74 0e                	je     801aab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a9d:	8b 43 04             	mov    0x4(%ebx),%eax
  801aa0:	8b 13                	mov    (%ebx),%edx
  801aa2:	83 c2 20             	add    $0x20,%edx
  801aa5:	39 d0                	cmp    %edx,%eax
  801aa7:	73 a6                	jae    801a4f <devpipe_write+0x23>
  801aa9:	eb c2                	jmp    801a6d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801aab:	89 f8                	mov    %edi,%eax
  801aad:	eb 05                	jmp    801ab4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ab4:	83 c4 2c             	add    $0x2c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 28             	sub    $0x28,%esp
  801ac2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ac5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ac8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801acb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ace:	89 3c 24             	mov    %edi,(%esp)
  801ad1:	e8 0a f6 ff ff       	call   8010e0 <fd2data>
  801ad6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ad8:	be 00 00 00 00       	mov    $0x0,%esi
  801add:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ae1:	75 47                	jne    801b2a <devpipe_read+0x6e>
  801ae3:	eb 52                	jmp    801b37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ae5:	89 f0                	mov    %esi,%eax
  801ae7:	eb 5e                	jmp    801b47 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ae9:	89 da                	mov    %ebx,%edx
  801aeb:	89 f8                	mov    %edi,%eax
  801aed:	8d 76 00             	lea    0x0(%esi),%esi
  801af0:	e8 cd fe ff ff       	call   8019c2 <_pipeisclosed>
  801af5:	85 c0                	test   %eax,%eax
  801af7:	75 49                	jne    801b42 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801af9:	e8 3e f2 ff ff       	call   800d3c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801afe:	8b 03                	mov    (%ebx),%eax
  801b00:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b03:	74 e4                	je     801ae9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b05:	89 c2                	mov    %eax,%edx
  801b07:	c1 fa 1f             	sar    $0x1f,%edx
  801b0a:	c1 ea 1b             	shr    $0x1b,%edx
  801b0d:	01 d0                	add    %edx,%eax
  801b0f:	83 e0 1f             	and    $0x1f,%eax
  801b12:	29 d0                	sub    %edx,%eax
  801b14:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801b1f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b22:	83 c6 01             	add    $0x1,%esi
  801b25:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b28:	74 0d                	je     801b37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801b2a:	8b 03                	mov    (%ebx),%eax
  801b2c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b2f:	75 d4                	jne    801b05 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b31:	85 f6                	test   %esi,%esi
  801b33:	75 b0                	jne    801ae5 <devpipe_read+0x29>
  801b35:	eb b2                	jmp    801ae9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b37:	89 f0                	mov    %esi,%eax
  801b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b40:	eb 05                	jmp    801b47 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b42:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b47:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b4a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b50:	89 ec                	mov    %ebp,%esp
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 48             	sub    $0x48,%esp
  801b5a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b5d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b60:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b63:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b69:	89 04 24             	mov    %eax,(%esp)
  801b6c:	e8 8a f5 ff ff       	call   8010fb <fd_alloc>
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	85 c0                	test   %eax,%eax
  801b75:	0f 88 45 01 00 00    	js     801cc0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b7b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b82:	00 
  801b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b91:	e8 d6 f1 ff ff       	call   800d6c <sys_page_alloc>
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	0f 88 20 01 00 00    	js     801cc0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ba0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 50 f5 ff ff       	call   8010fb <fd_alloc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	85 c0                	test   %eax,%eax
  801baf:	0f 88 f8 00 00 00    	js     801cad <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bbc:	00 
  801bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bcb:	e8 9c f1 ff ff       	call   800d6c <sys_page_alloc>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	0f 88 d3 00 00 00    	js     801cad <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801bda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bdd:	89 04 24             	mov    %eax,(%esp)
  801be0:	e8 fb f4 ff ff       	call   8010e0 <fd2data>
  801be5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bee:	00 
  801bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfa:	e8 6d f1 ff ff       	call   800d6c <sys_page_alloc>
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	85 c0                	test   %eax,%eax
  801c03:	0f 88 91 00 00 00    	js     801c9a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0c:	89 04 24             	mov    %eax,(%esp)
  801c0f:	e8 cc f4 ff ff       	call   8010e0 <fd2data>
  801c14:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801c1b:	00 
  801c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c27:	00 
  801c28:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c33:	e8 93 f1 ff ff       	call   800dcb <sys_page_map>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 4c                	js     801c8a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c3e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c47:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c6b:	89 04 24             	mov    %eax,(%esp)
  801c6e:	e8 5d f4 ff ff       	call   8010d0 <fd2num>
  801c73:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c78:	89 04 24             	mov    %eax,(%esp)
  801c7b:	e8 50 f4 ff ff       	call   8010d0 <fd2num>
  801c80:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c88:	eb 36                	jmp    801cc0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801c8a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c95:	e8 8f f1 ff ff       	call   800e29 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca8:	e8 7c f1 ff ff       	call   800e29 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbb:	e8 69 f1 ff ff       	call   800e29 <sys_page_unmap>
    err:
	return r;
}
  801cc0:	89 d8                	mov    %ebx,%eax
  801cc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ccb:	89 ec                	mov    %ebp,%esp
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    

00801ccf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	89 04 24             	mov    %eax,(%esp)
  801ce2:	e8 87 f4 ff ff       	call   80116e <fd_lookup>
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 15                	js     801d00 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 ea f3 ff ff       	call   8010e0 <fd2data>
	return _pipeisclosed(fd, p);
  801cf6:	89 c2                	mov    %eax,%edx
  801cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfb:	e8 c2 fc ff ff       	call   8019c2 <_pipeisclosed>
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    
	...

00801d10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    

00801d1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801d20:	c7 44 24 04 b2 27 80 	movl   $0x8027b2,0x4(%esp)
  801d27:	00 
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 38 eb ff ff       	call   80086b <strcpy>
	return 0;
}
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	57                   	push   %edi
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d46:	be 00 00 00 00       	mov    $0x0,%esi
  801d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4f:	74 43                	je     801d94 <devcons_write+0x5a>
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d56:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d5f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801d61:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d64:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d69:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d70:	03 45 0c             	add    0xc(%ebp),%eax
  801d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d77:	89 3c 24             	mov    %edi,(%esp)
  801d7a:	e8 dd ec ff ff       	call   800a5c <memmove>
		sys_cputs(buf, m);
  801d7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d83:	89 3c 24             	mov    %edi,(%esp)
  801d86:	e8 c5 ee ff ff       	call   800c50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d8b:	01 de                	add    %ebx,%esi
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d92:	72 c8                	jb     801d5c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d94:	89 f0                	mov    %esi,%eax
  801d96:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db0:	75 07                	jne    801db9 <devcons_read+0x18>
  801db2:	eb 31                	jmp    801de5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801db4:	e8 83 ef ff ff       	call   800d3c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dc0:	e8 ba ee ff ff       	call   800c7f <sys_cgetc>
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 eb                	je     801db4 <devcons_read+0x13>
  801dc9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 16                	js     801de5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801dcf:	83 f8 04             	cmp    $0x4,%eax
  801dd2:	74 0c                	je     801de0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	88 10                	mov    %dl,(%eax)
	return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801df3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801dfa:	00 
  801dfb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 4a ee ff ff       	call   800c50 <sys_cputs>
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <getchar>:

int
getchar(void)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e0e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e15:	00 
  801e16:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e24:	e8 05 f6 ff ff       	call   80142e <read>
	if (r < 0)
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 0f                	js     801e3c <getchar+0x34>
		return r;
	if (r < 1)
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	7e 06                	jle    801e37 <getchar+0x2f>
		return -E_EOF;
	return c;
  801e31:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e35:	eb 05                	jmp    801e3c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e37:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 04 24             	mov    %eax,(%esp)
  801e51:	e8 18 f3 ff ff       	call   80116e <fd_lookup>
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 11                	js     801e6b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e63:	39 10                	cmp    %edx,(%eax)
  801e65:	0f 94 c0             	sete   %al
  801e68:	0f b6 c0             	movzbl %al,%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <opencons>:

int
opencons(void)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e76:	89 04 24             	mov    %eax,(%esp)
  801e79:	e8 7d f2 ff ff       	call   8010fb <fd_alloc>
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 3c                	js     801ebe <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e89:	00 
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e98:	e8 cf ee ff ff       	call   800d6c <sys_page_alloc>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 1d                	js     801ebe <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801ea1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801eb6:	89 04 24             	mov    %eax,(%esp)
  801eb9:	e8 12 f2 ff ff       	call   8010d0 <fd2num>
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	56                   	push   %esi
  801ec4:	53                   	push   %ebx
  801ec5:	83 ec 10             	sub    $0x10,%esp
  801ec8:	8b 75 08             	mov    0x8(%ebp),%esi
  801ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801ed1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801ed3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ed8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801edb:	89 04 24             	mov    %eax,(%esp)
  801ede:	e8 f2 f0 ff ff       	call   800fd5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801ee3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801ee8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801eed:	85 c0                	test   %eax,%eax
  801eef:	78 0e                	js     801eff <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801ef1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ef6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801ef9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801efc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801eff:	85 f6                	test   %esi,%esi
  801f01:	74 02                	je     801f05 <ipc_recv+0x45>
		*from_env_store = sender;
  801f03:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801f05:	85 db                	test   %ebx,%ebx
  801f07:	74 02                	je     801f0b <ipc_recv+0x4b>
		*perm_store = perm;
  801f09:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5e                   	pop    %esi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    

00801f12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	57                   	push   %edi
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 1c             	sub    $0x1c,%esp
  801f1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f21:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801f24:	85 db                	test   %ebx,%ebx
  801f26:	75 04                	jne    801f2c <ipc_send+0x1a>
  801f28:	85 f6                	test   %esi,%esi
  801f2a:	75 15                	jne    801f41 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801f2c:	85 db                	test   %ebx,%ebx
  801f2e:	74 16                	je     801f46 <ipc_send+0x34>
  801f30:	85 f6                	test   %esi,%esi
  801f32:	0f 94 c0             	sete   %al
      pg = 0;
  801f35:	84 c0                	test   %al,%al
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	0f 45 d8             	cmovne %eax,%ebx
  801f3f:	eb 05                	jmp    801f46 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801f41:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801f46:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	89 04 24             	mov    %eax,(%esp)
  801f58:	e8 44 f0 ff ff       	call   800fa1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801f5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f60:	75 07                	jne    801f69 <ipc_send+0x57>
           sys_yield();
  801f62:	e8 d5 ed ff ff       	call   800d3c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801f67:	eb dd                	jmp    801f46 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	90                   	nop
  801f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f70:	74 1c                	je     801f8e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801f72:	c7 44 24 08 be 27 80 	movl   $0x8027be,0x8(%esp)
  801f79:	00 
  801f7a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f81:	00 
  801f82:	c7 04 24 c8 27 80 00 	movl   $0x8027c8,(%esp)
  801f89:	e8 c2 e1 ff ff       	call   800150 <_panic>
		}
    }
}
  801f8e:	83 c4 1c             	add    $0x1c,%esp
  801f91:	5b                   	pop    %ebx
  801f92:	5e                   	pop    %esi
  801f93:	5f                   	pop    %edi
  801f94:	5d                   	pop    %ebp
  801f95:	c3                   	ret    

00801f96 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f9c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801fa1:	39 c8                	cmp    %ecx,%eax
  801fa3:	74 17                	je     801fbc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801faa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb3:	8b 52 50             	mov    0x50(%edx),%edx
  801fb6:	39 ca                	cmp    %ecx,%edx
  801fb8:	75 14                	jne    801fce <ipc_find_env+0x38>
  801fba:	eb 05                	jmp    801fc1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801fc1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fc4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801fc9:	8b 40 40             	mov    0x40(%eax),%eax
  801fcc:	eb 0e                	jmp    801fdc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801fce:	83 c0 01             	add    $0x1,%eax
  801fd1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fd6:	75 d2                	jne    801faa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801fd8:	66 b8 00 00          	mov    $0x0,%ax
}
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
	...

00801fe0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe6:	89 d0                	mov    %edx,%eax
  801fe8:	c1 e8 16             	shr    $0x16,%eax
  801feb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ff7:	f6 c1 01             	test   $0x1,%cl
  801ffa:	74 1d                	je     802019 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ffc:	c1 ea 0c             	shr    $0xc,%edx
  801fff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802006:	f6 c2 01             	test   $0x1,%dl
  802009:	74 0e                	je     802019 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80200b:	c1 ea 0c             	shr    $0xc,%edx
  80200e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802015:	ef 
  802016:	0f b7 c0             	movzwl %ax,%eax
}
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    
  80201b:	00 00                	add    %al,(%eax)
  80201d:	00 00                	add    %al,(%eax)
	...

00802020 <__udivdi3>:
  802020:	83 ec 1c             	sub    $0x1c,%esp
  802023:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802027:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80202b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80202f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802033:	89 74 24 10          	mov    %esi,0x10(%esp)
  802037:	8b 74 24 24          	mov    0x24(%esp),%esi
  80203b:	85 ff                	test   %edi,%edi
  80203d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802041:	89 44 24 08          	mov    %eax,0x8(%esp)
  802045:	89 cd                	mov    %ecx,%ebp
  802047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204b:	75 33                	jne    802080 <__udivdi3+0x60>
  80204d:	39 f1                	cmp    %esi,%ecx
  80204f:	77 57                	ja     8020a8 <__udivdi3+0x88>
  802051:	85 c9                	test   %ecx,%ecx
  802053:	75 0b                	jne    802060 <__udivdi3+0x40>
  802055:	b8 01 00 00 00       	mov    $0x1,%eax
  80205a:	31 d2                	xor    %edx,%edx
  80205c:	f7 f1                	div    %ecx
  80205e:	89 c1                	mov    %eax,%ecx
  802060:	89 f0                	mov    %esi,%eax
  802062:	31 d2                	xor    %edx,%edx
  802064:	f7 f1                	div    %ecx
  802066:	89 c6                	mov    %eax,%esi
  802068:	8b 44 24 04          	mov    0x4(%esp),%eax
  80206c:	f7 f1                	div    %ecx
  80206e:	89 f2                	mov    %esi,%edx
  802070:	8b 74 24 10          	mov    0x10(%esp),%esi
  802074:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802078:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	c3                   	ret    
  802080:	31 d2                	xor    %edx,%edx
  802082:	31 c0                	xor    %eax,%eax
  802084:	39 f7                	cmp    %esi,%edi
  802086:	77 e8                	ja     802070 <__udivdi3+0x50>
  802088:	0f bd cf             	bsr    %edi,%ecx
  80208b:	83 f1 1f             	xor    $0x1f,%ecx
  80208e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802092:	75 2c                	jne    8020c0 <__udivdi3+0xa0>
  802094:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802098:	76 04                	jbe    80209e <__udivdi3+0x7e>
  80209a:	39 f7                	cmp    %esi,%edi
  80209c:	73 d2                	jae    802070 <__udivdi3+0x50>
  80209e:	31 d2                	xor    %edx,%edx
  8020a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a5:	eb c9                	jmp    802070 <__udivdi3+0x50>
  8020a7:	90                   	nop
  8020a8:	89 f2                	mov    %esi,%edx
  8020aa:	f7 f1                	div    %ecx
  8020ac:	31 d2                	xor    %edx,%edx
  8020ae:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020b2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020b6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ba:	83 c4 1c             	add    $0x1c,%esp
  8020bd:	c3                   	ret    
  8020be:	66 90                	xchg   %ax,%ax
  8020c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020c5:	b8 20 00 00 00       	mov    $0x20,%eax
  8020ca:	89 ea                	mov    %ebp,%edx
  8020cc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8020d0:	d3 e7                	shl    %cl,%edi
  8020d2:	89 c1                	mov    %eax,%ecx
  8020d4:	d3 ea                	shr    %cl,%edx
  8020d6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020db:	09 fa                	or     %edi,%edx
  8020dd:	89 f7                	mov    %esi,%edi
  8020df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020e3:	89 f2                	mov    %esi,%edx
  8020e5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8020e9:	d3 e5                	shl    %cl,%ebp
  8020eb:	89 c1                	mov    %eax,%ecx
  8020ed:	d3 ef                	shr    %cl,%edi
  8020ef:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020f4:	d3 e2                	shl    %cl,%edx
  8020f6:	89 c1                	mov    %eax,%ecx
  8020f8:	d3 ee                	shr    %cl,%esi
  8020fa:	09 d6                	or     %edx,%esi
  8020fc:	89 fa                	mov    %edi,%edx
  8020fe:	89 f0                	mov    %esi,%eax
  802100:	f7 74 24 0c          	divl   0xc(%esp)
  802104:	89 d7                	mov    %edx,%edi
  802106:	89 c6                	mov    %eax,%esi
  802108:	f7 e5                	mul    %ebp
  80210a:	39 d7                	cmp    %edx,%edi
  80210c:	72 22                	jb     802130 <__udivdi3+0x110>
  80210e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802112:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802117:	d3 e5                	shl    %cl,%ebp
  802119:	39 c5                	cmp    %eax,%ebp
  80211b:	73 04                	jae    802121 <__udivdi3+0x101>
  80211d:	39 d7                	cmp    %edx,%edi
  80211f:	74 0f                	je     802130 <__udivdi3+0x110>
  802121:	89 f0                	mov    %esi,%eax
  802123:	31 d2                	xor    %edx,%edx
  802125:	e9 46 ff ff ff       	jmp    802070 <__udivdi3+0x50>
  80212a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802130:	8d 46 ff             	lea    -0x1(%esi),%eax
  802133:	31 d2                	xor    %edx,%edx
  802135:	8b 74 24 10          	mov    0x10(%esp),%esi
  802139:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80213d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802141:	83 c4 1c             	add    $0x1c,%esp
  802144:	c3                   	ret    
	...

00802150 <__umoddi3>:
  802150:	83 ec 1c             	sub    $0x1c,%esp
  802153:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802157:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80215b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80215f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802163:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802167:	8b 74 24 24          	mov    0x24(%esp),%esi
  80216b:	85 ed                	test   %ebp,%ebp
  80216d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802171:	89 44 24 08          	mov    %eax,0x8(%esp)
  802175:	89 cf                	mov    %ecx,%edi
  802177:	89 04 24             	mov    %eax,(%esp)
  80217a:	89 f2                	mov    %esi,%edx
  80217c:	75 1a                	jne    802198 <__umoddi3+0x48>
  80217e:	39 f1                	cmp    %esi,%ecx
  802180:	76 4e                	jbe    8021d0 <__umoddi3+0x80>
  802182:	f7 f1                	div    %ecx
  802184:	89 d0                	mov    %edx,%eax
  802186:	31 d2                	xor    %edx,%edx
  802188:	8b 74 24 10          	mov    0x10(%esp),%esi
  80218c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802190:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802194:	83 c4 1c             	add    $0x1c,%esp
  802197:	c3                   	ret    
  802198:	39 f5                	cmp    %esi,%ebp
  80219a:	77 54                	ja     8021f0 <__umoddi3+0xa0>
  80219c:	0f bd c5             	bsr    %ebp,%eax
  80219f:	83 f0 1f             	xor    $0x1f,%eax
  8021a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a6:	75 60                	jne    802208 <__umoddi3+0xb8>
  8021a8:	3b 0c 24             	cmp    (%esp),%ecx
  8021ab:	0f 87 07 01 00 00    	ja     8022b8 <__umoddi3+0x168>
  8021b1:	89 f2                	mov    %esi,%edx
  8021b3:	8b 34 24             	mov    (%esp),%esi
  8021b6:	29 ce                	sub    %ecx,%esi
  8021b8:	19 ea                	sbb    %ebp,%edx
  8021ba:	89 34 24             	mov    %esi,(%esp)
  8021bd:	8b 04 24             	mov    (%esp),%eax
  8021c0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021c4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021c8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021cc:	83 c4 1c             	add    $0x1c,%esp
  8021cf:	c3                   	ret    
  8021d0:	85 c9                	test   %ecx,%ecx
  8021d2:	75 0b                	jne    8021df <__umoddi3+0x8f>
  8021d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d9:	31 d2                	xor    %edx,%edx
  8021db:	f7 f1                	div    %ecx
  8021dd:	89 c1                	mov    %eax,%ecx
  8021df:	89 f0                	mov    %esi,%eax
  8021e1:	31 d2                	xor    %edx,%edx
  8021e3:	f7 f1                	div    %ecx
  8021e5:	8b 04 24             	mov    (%esp),%eax
  8021e8:	f7 f1                	div    %ecx
  8021ea:	eb 98                	jmp    802184 <__umoddi3+0x34>
  8021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 f2                	mov    %esi,%edx
  8021f2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021f6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021fa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021fe:	83 c4 1c             	add    $0x1c,%esp
  802201:	c3                   	ret    
  802202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802208:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80220d:	89 e8                	mov    %ebp,%eax
  80220f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802214:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802218:	89 fa                	mov    %edi,%edx
  80221a:	d3 e0                	shl    %cl,%eax
  80221c:	89 e9                	mov    %ebp,%ecx
  80221e:	d3 ea                	shr    %cl,%edx
  802220:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802225:	09 c2                	or     %eax,%edx
  802227:	8b 44 24 08          	mov    0x8(%esp),%eax
  80222b:	89 14 24             	mov    %edx,(%esp)
  80222e:	89 f2                	mov    %esi,%edx
  802230:	d3 e7                	shl    %cl,%edi
  802232:	89 e9                	mov    %ebp,%ecx
  802234:	d3 ea                	shr    %cl,%edx
  802236:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80223b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80223f:	d3 e6                	shl    %cl,%esi
  802241:	89 e9                	mov    %ebp,%ecx
  802243:	d3 e8                	shr    %cl,%eax
  802245:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80224a:	09 f0                	or     %esi,%eax
  80224c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802250:	f7 34 24             	divl   (%esp)
  802253:	d3 e6                	shl    %cl,%esi
  802255:	89 74 24 08          	mov    %esi,0x8(%esp)
  802259:	89 d6                	mov    %edx,%esi
  80225b:	f7 e7                	mul    %edi
  80225d:	39 d6                	cmp    %edx,%esi
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 d7                	mov    %edx,%edi
  802263:	72 3f                	jb     8022a4 <__umoddi3+0x154>
  802265:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802269:	72 35                	jb     8022a0 <__umoddi3+0x150>
  80226b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226f:	29 c8                	sub    %ecx,%eax
  802271:	19 fe                	sbb    %edi,%esi
  802273:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802278:	89 f2                	mov    %esi,%edx
  80227a:	d3 e8                	shr    %cl,%eax
  80227c:	89 e9                	mov    %ebp,%ecx
  80227e:	d3 e2                	shl    %cl,%edx
  802280:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802285:	09 d0                	or     %edx,%eax
  802287:	89 f2                	mov    %esi,%edx
  802289:	d3 ea                	shr    %cl,%edx
  80228b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80228f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802293:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802297:	83 c4 1c             	add    $0x1c,%esp
  80229a:	c3                   	ret    
  80229b:	90                   	nop
  80229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	39 d6                	cmp    %edx,%esi
  8022a2:	75 c7                	jne    80226b <__umoddi3+0x11b>
  8022a4:	89 d7                	mov    %edx,%edi
  8022a6:	89 c1                	mov    %eax,%ecx
  8022a8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8022ac:	1b 3c 24             	sbb    (%esp),%edi
  8022af:	eb ba                	jmp    80226b <__umoddi3+0x11b>
  8022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	39 f5                	cmp    %esi,%ebp
  8022ba:	0f 82 f1 fe ff ff    	jb     8021b1 <__umoddi3+0x61>
  8022c0:	e9 f8 fe ff ff       	jmp    8021bd <__umoddi3+0x6d>
