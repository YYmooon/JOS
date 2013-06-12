
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 63 00 00 00       	call   800094 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  80004d:	e8 a9 01 00 00       	call   8001fb <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800052:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800059:	00 
  80005a:	c7 44 24 04 9e 28 80 	movl   $0x80289e,0x4(%esp)
  800061:	00 
  800062:	c7 04 24 9e 28 80 00 	movl   $0x80289e,(%esp)
  800069:	e8 df 1d 00 00       	call   801e4d <spawnl>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 20                	jns    800092 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800072:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800076:	c7 44 24 08 a4 28 80 	movl   $0x8028a4,0x8(%esp)
  80007d:	00 
  80007e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800085:	00 
  800086:	c7 04 24 bc 28 80 00 	movl   $0x8028bc,(%esp)
  80008d:	e8 6e 00 00 00       	call   800100 <_panic>
}
  800092:	c9                   	leave  
  800093:	c3                   	ret    

00800094 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 18             	sub    $0x18,%esp
  80009a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80009d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000a6:	e8 11 0c 00 00       	call   800cbc <sys_getenvid>
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b8:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	85 f6                	test   %esi,%esi
  8000bf:	7e 07                	jle    8000c8 <libmain+0x34>
		binaryname = argv[0];
  8000c1:	8b 03                	mov    (%ebx),%eax
  8000c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cc:	89 34 24             	mov    %esi,(%esp)
  8000cf:	e8 60 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0b 00 00 00       	call   8000e4 <exit>
}
  8000d9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000dc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000df:	89 ec                	mov    %ebp,%esp
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    
	...

008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ea:	e8 1f 11 00 00       	call   80120e <close_all>
	sys_env_destroy(0);
  8000ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f6:	e8 64 0b 00 00       	call   800c5f <sys_env_destroy>
}
  8000fb:	c9                   	leave  
  8000fc:	c3                   	ret    
  8000fd:	00 00                	add    %al,(%eax)
	...

00800100 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800108:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80010b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800111:	e8 a6 0b 00 00       	call   800cbc <sys_getenvid>
  800116:	8b 55 0c             	mov    0xc(%ebp),%edx
  800119:	89 54 24 10          	mov    %edx,0x10(%esp)
  80011d:	8b 55 08             	mov    0x8(%ebp),%edx
  800120:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800124:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012c:	c7 04 24 d8 28 80 00 	movl   $0x8028d8,(%esp)
  800133:	e8 c3 00 00 00       	call   8001fb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800138:	89 74 24 04          	mov    %esi,0x4(%esp)
  80013c:	8b 45 10             	mov    0x10(%ebp),%eax
  80013f:	89 04 24             	mov    %eax,(%esp)
  800142:	e8 53 00 00 00       	call   80019a <vcprintf>
	cprintf("\n");
  800147:	c7 04 24 a0 2d 80 00 	movl   $0x802da0,(%esp)
  80014e:	e8 a8 00 00 00       	call   8001fb <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800153:	cc                   	int3   
  800154:	eb fd                	jmp    800153 <_panic+0x53>
	...

00800158 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	53                   	push   %ebx
  80015c:	83 ec 14             	sub    $0x14,%esp
  80015f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800162:	8b 03                	mov    (%ebx),%eax
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80016b:	83 c0 01             	add    $0x1,%eax
  80016e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800170:	3d ff 00 00 00       	cmp    $0xff,%eax
  800175:	75 19                	jne    800190 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800177:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80017e:	00 
  80017f:	8d 43 08             	lea    0x8(%ebx),%eax
  800182:	89 04 24             	mov    %eax,(%esp)
  800185:	e8 76 0a 00 00       	call   800c00 <sys_cputs>
		b->idx = 0;
  80018a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	83 c4 14             	add    $0x14,%esp
  800197:	5b                   	pop    %ebx
  800198:	5d                   	pop    %ebp
  800199:	c3                   	ret    

0080019a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001aa:	00 00 00 
	b.cnt = 0;
  8001ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cf:	c7 04 24 58 01 80 00 	movl   $0x800158,(%esp)
  8001d6:	e8 9f 01 00 00       	call   80037a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001eb:	89 04 24             	mov    %eax,(%esp)
  8001ee:	e8 0d 0a 00 00       	call   800c00 <sys_cputs>

	return b.cnt;
}
  8001f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f9:	c9                   	leave  
  8001fa:	c3                   	ret    

008001fb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800201:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800204:	89 44 24 04          	mov    %eax,0x4(%esp)
  800208:	8b 45 08             	mov    0x8(%ebp),%eax
  80020b:	89 04 24             	mov    %eax,(%esp)
  80020e:	e8 87 ff ff ff       	call   80019a <vcprintf>
	va_end(ap);

	return cnt;
}
  800213:	c9                   	leave  
  800214:	c3                   	ret    
	...

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80023a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80023d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800248:	72 11                	jb     80025b <printnum+0x3b>
  80024a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800250:	76 09                	jbe    80025b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800252:	83 eb 01             	sub    $0x1,%ebx
  800255:	85 db                	test   %ebx,%ebx
  800257:	7f 51                	jg     8002aa <printnum+0x8a>
  800259:	eb 5e                	jmp    8002b9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800271:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800275:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80027c:	00 
  80027d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800280:	89 04 24             	mov    %eax,(%esp)
  800283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800286:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028a:	e8 41 23 00 00       	call   8025d0 <__udivdi3>
  80028f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800293:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800297:	89 04 24             	mov    %eax,(%esp)
  80029a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80029e:	89 fa                	mov    %edi,%edx
  8002a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a3:	e8 78 ff ff ff       	call   800220 <printnum>
  8002a8:	eb 0f                	jmp    8002b9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ae:	89 34 24             	mov    %esi,(%esp)
  8002b1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b4:	83 eb 01             	sub    $0x1,%ebx
  8002b7:	75 f1                	jne    8002aa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002bd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002cf:	00 
  8002d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d3:	89 04 24             	mov    %eax,(%esp)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002dd:	e8 1e 24 00 00       	call   802700 <__umoddi3>
  8002e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e6:	0f be 80 fb 28 80 00 	movsbl 0x8028fb(%eax),%eax
  8002ed:	89 04 24             	mov    %eax,(%esp)
  8002f0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002f3:	83 c4 3c             	add    $0x3c,%esp
  8002f6:	5b                   	pop    %ebx
  8002f7:	5e                   	pop    %esi
  8002f8:	5f                   	pop    %edi
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002fe:	83 fa 01             	cmp    $0x1,%edx
  800301:	7e 0e                	jle    800311 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800303:	8b 10                	mov    (%eax),%edx
  800305:	8d 4a 08             	lea    0x8(%edx),%ecx
  800308:	89 08                	mov    %ecx,(%eax)
  80030a:	8b 02                	mov    (%edx),%eax
  80030c:	8b 52 04             	mov    0x4(%edx),%edx
  80030f:	eb 22                	jmp    800333 <getuint+0x38>
	else if (lflag)
  800311:	85 d2                	test   %edx,%edx
  800313:	74 10                	je     800325 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800315:	8b 10                	mov    (%eax),%edx
  800317:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031a:	89 08                	mov    %ecx,(%eax)
  80031c:	8b 02                	mov    (%edx),%eax
  80031e:	ba 00 00 00 00       	mov    $0x0,%edx
  800323:	eb 0e                	jmp    800333 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800325:	8b 10                	mov    (%eax),%edx
  800327:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032a:	89 08                	mov    %ecx,(%eax)
  80032c:	8b 02                	mov    (%edx),%eax
  80032e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    

00800335 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033f:	8b 10                	mov    (%eax),%edx
  800341:	3b 50 04             	cmp    0x4(%eax),%edx
  800344:	73 0a                	jae    800350 <sprintputch+0x1b>
		*b->buf++ = ch;
  800346:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800349:	88 0a                	mov    %cl,(%edx)
  80034b:	83 c2 01             	add    $0x1,%edx
  80034e:	89 10                	mov    %edx,(%eax)
}
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800358:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80035f:	8b 45 10             	mov    0x10(%ebp),%eax
  800362:	89 44 24 08          	mov    %eax,0x8(%esp)
  800366:	8b 45 0c             	mov    0xc(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 02 00 00 00       	call   80037a <vprintfmt>
	va_end(ap);
}
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	57                   	push   %edi
  80037e:	56                   	push   %esi
  80037f:	53                   	push   %ebx
  800380:	83 ec 4c             	sub    $0x4c,%esp
  800383:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800386:	8b 75 10             	mov    0x10(%ebp),%esi
  800389:	eb 12                	jmp    80039d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80038b:	85 c0                	test   %eax,%eax
  80038d:	0f 84 a9 03 00 00    	je     80073c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800393:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800397:	89 04 24             	mov    %eax,(%esp)
  80039a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80039d:	0f b6 06             	movzbl (%esi),%eax
  8003a0:	83 c6 01             	add    $0x1,%esi
  8003a3:	83 f8 25             	cmp    $0x25,%eax
  8003a6:	75 e3                	jne    80038b <vprintfmt+0x11>
  8003a8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003b3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8003b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003c7:	eb 2b                	jmp    8003f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003cc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003d0:	eb 22                	jmp    8003f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003d5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003d9:	eb 19                	jmp    8003f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8003de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003e5:	eb 0d                	jmp    8003f4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ed:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	0f b6 06             	movzbl (%esi),%eax
  8003f7:	0f b6 d0             	movzbl %al,%edx
  8003fa:	8d 7e 01             	lea    0x1(%esi),%edi
  8003fd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800400:	83 e8 23             	sub    $0x23,%eax
  800403:	3c 55                	cmp    $0x55,%al
  800405:	0f 87 0b 03 00 00    	ja     800716 <vprintfmt+0x39c>
  80040b:	0f b6 c0             	movzbl %al,%eax
  80040e:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800415:	83 ea 30             	sub    $0x30,%edx
  800418:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80041b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80041f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800425:	83 fa 09             	cmp    $0x9,%edx
  800428:	77 4a                	ja     800474 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80042d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800430:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800433:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800437:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80043a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80043d:	83 fa 09             	cmp    $0x9,%edx
  800440:	76 eb                	jbe    80042d <vprintfmt+0xb3>
  800442:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800445:	eb 2d                	jmp    800474 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 50 04             	lea    0x4(%eax),%edx
  80044d:	89 55 14             	mov    %edx,0x14(%ebp)
  800450:	8b 00                	mov    (%eax),%eax
  800452:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800455:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800458:	eb 1a                	jmp    800474 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80045d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800461:	79 91                	jns    8003f4 <vprintfmt+0x7a>
  800463:	e9 73 ff ff ff       	jmp    8003db <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800472:	eb 80                	jmp    8003f4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800474:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800478:	0f 89 76 ff ff ff    	jns    8003f4 <vprintfmt+0x7a>
  80047e:	e9 64 ff ff ff       	jmp    8003e7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800483:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800489:	e9 66 ff ff ff       	jmp    8003f4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8d 50 04             	lea    0x4(%eax),%edx
  800494:	89 55 14             	mov    %edx,0x14(%ebp)
  800497:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	89 04 24             	mov    %eax,(%esp)
  8004a0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004a6:	e9 f2 fe ff ff       	jmp    80039d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8d 50 04             	lea    0x4(%eax),%edx
  8004b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 c2                	mov    %eax,%edx
  8004b8:	c1 fa 1f             	sar    $0x1f,%edx
  8004bb:	31 d0                	xor    %edx,%eax
  8004bd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004bf:	83 f8 0f             	cmp    $0xf,%eax
  8004c2:	7f 0b                	jg     8004cf <vprintfmt+0x155>
  8004c4:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  8004cb:	85 d2                	test   %edx,%edx
  8004cd:	75 23                	jne    8004f2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8004cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004d3:	c7 44 24 08 13 29 80 	movl   $0x802913,0x8(%esp)
  8004da:	00 
  8004db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004e2:	89 3c 24             	mov    %edi,(%esp)
  8004e5:	e8 68 fe ff ff       	call   800352 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004ed:	e9 ab fe ff ff       	jmp    80039d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8004f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004f6:	c7 44 24 08 d1 2c 80 	movl   $0x802cd1,0x8(%esp)
  8004fd:	00 
  8004fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800502:	8b 7d 08             	mov    0x8(%ebp),%edi
  800505:	89 3c 24             	mov    %edi,(%esp)
  800508:	e8 45 fe ff ff       	call   800352 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800510:	e9 88 fe ff ff       	jmp    80039d <vprintfmt+0x23>
  800515:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80051b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 50 04             	lea    0x4(%eax),%edx
  800524:	89 55 14             	mov    %edx,0x14(%ebp)
  800527:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800529:	85 f6                	test   %esi,%esi
  80052b:	ba 0c 29 80 00       	mov    $0x80290c,%edx
  800530:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800533:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800537:	7e 06                	jle    80053f <vprintfmt+0x1c5>
  800539:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80053d:	75 10                	jne    80054f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053f:	0f be 06             	movsbl (%esi),%eax
  800542:	83 c6 01             	add    $0x1,%esi
  800545:	85 c0                	test   %eax,%eax
  800547:	0f 85 86 00 00 00    	jne    8005d3 <vprintfmt+0x259>
  80054d:	eb 76                	jmp    8005c5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800553:	89 34 24             	mov    %esi,(%esp)
  800556:	e8 90 02 00 00       	call   8007eb <strnlen>
  80055b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80055e:	29 c2                	sub    %eax,%edx
  800560:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800563:	85 d2                	test   %edx,%edx
  800565:	7e d8                	jle    80053f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800567:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80056b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80056e:	89 d6                	mov    %edx,%esi
  800570:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800573:	89 c7                	mov    %eax,%edi
  800575:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800579:	89 3c 24             	mov    %edi,(%esp)
  80057c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057f:	83 ee 01             	sub    $0x1,%esi
  800582:	75 f1                	jne    800575 <vprintfmt+0x1fb>
  800584:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800587:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80058a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80058d:	eb b0                	jmp    80053f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80058f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800593:	74 18                	je     8005ad <vprintfmt+0x233>
  800595:	8d 50 e0             	lea    -0x20(%eax),%edx
  800598:	83 fa 5e             	cmp    $0x5e,%edx
  80059b:	76 10                	jbe    8005ad <vprintfmt+0x233>
					putch('?', putdat);
  80059d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005a1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a8:	ff 55 08             	call   *0x8(%ebp)
  8005ab:	eb 0a                	jmp    8005b7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8005ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005b1:	89 04 24             	mov    %eax,(%esp)
  8005b4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005bb:	0f be 06             	movsbl (%esi),%eax
  8005be:	83 c6 01             	add    $0x1,%esi
  8005c1:	85 c0                	test   %eax,%eax
  8005c3:	75 0e                	jne    8005d3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cc:	7f 16                	jg     8005e4 <vprintfmt+0x26a>
  8005ce:	e9 ca fd ff ff       	jmp    80039d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	78 b8                	js     80058f <vprintfmt+0x215>
  8005d7:	83 ef 01             	sub    $0x1,%edi
  8005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8005e0:	79 ad                	jns    80058f <vprintfmt+0x215>
  8005e2:	eb e1                	jmp    8005c5 <vprintfmt+0x24b>
  8005e4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005e7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005f5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f7:	83 ee 01             	sub    $0x1,%esi
  8005fa:	75 ee                	jne    8005ea <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005ff:	e9 99 fd ff ff       	jmp    80039d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800604:	83 f9 01             	cmp    $0x1,%ecx
  800607:	7e 10                	jle    800619 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 50 08             	lea    0x8(%eax),%edx
  80060f:	89 55 14             	mov    %edx,0x14(%ebp)
  800612:	8b 30                	mov    (%eax),%esi
  800614:	8b 78 04             	mov    0x4(%eax),%edi
  800617:	eb 26                	jmp    80063f <vprintfmt+0x2c5>
	else if (lflag)
  800619:	85 c9                	test   %ecx,%ecx
  80061b:	74 12                	je     80062f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 50 04             	lea    0x4(%eax),%edx
  800623:	89 55 14             	mov    %edx,0x14(%ebp)
  800626:	8b 30                	mov    (%eax),%esi
  800628:	89 f7                	mov    %esi,%edi
  80062a:	c1 ff 1f             	sar    $0x1f,%edi
  80062d:	eb 10                	jmp    80063f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 50 04             	lea    0x4(%eax),%edx
  800635:	89 55 14             	mov    %edx,0x14(%ebp)
  800638:	8b 30                	mov    (%eax),%esi
  80063a:	89 f7                	mov    %esi,%edi
  80063c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800644:	85 ff                	test   %edi,%edi
  800646:	0f 89 8c 00 00 00    	jns    8006d8 <vprintfmt+0x35e>
				putch('-', putdat);
  80064c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800650:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800657:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80065a:	f7 de                	neg    %esi
  80065c:	83 d7 00             	adc    $0x0,%edi
  80065f:	f7 df                	neg    %edi
			}
			base = 10;
  800661:	b8 0a 00 00 00       	mov    $0xa,%eax
  800666:	eb 70                	jmp    8006d8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800668:	89 ca                	mov    %ecx,%edx
  80066a:	8d 45 14             	lea    0x14(%ebp),%eax
  80066d:	e8 89 fc ff ff       	call   8002fb <getuint>
  800672:	89 c6                	mov    %eax,%esi
  800674:	89 d7                	mov    %edx,%edi
			base = 10;
  800676:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80067b:	eb 5b                	jmp    8006d8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80067d:	89 ca                	mov    %ecx,%edx
  80067f:	8d 45 14             	lea    0x14(%ebp),%eax
  800682:	e8 74 fc ff ff       	call   8002fb <getuint>
  800687:	89 c6                	mov    %eax,%esi
  800689:	89 d7                	mov    %edx,%edi
			base = 8;
  80068b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800690:	eb 46                	jmp    8006d8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800692:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800696:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80069d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006b7:	8b 30                	mov    (%eax),%esi
  8006b9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006be:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006c3:	eb 13                	jmp    8006d8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c5:	89 ca                	mov    %ecx,%edx
  8006c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ca:	e8 2c fc ff ff       	call   8002fb <getuint>
  8006cf:	89 c6                	mov    %eax,%esi
  8006d1:	89 d7                	mov    %edx,%edi
			base = 16;
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006d8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8006dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006eb:	89 34 24             	mov    %esi,(%esp)
  8006ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f2:	89 da                	mov    %ebx,%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	e8 24 fb ff ff       	call   800220 <printnum>
			break;
  8006fc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006ff:	e9 99 fc ff ff       	jmp    80039d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800704:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800708:	89 14 24             	mov    %edx,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800711:	e9 87 fc ff ff       	jmp    80039d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800716:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80071a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800721:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800724:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800728:	0f 84 6f fc ff ff    	je     80039d <vprintfmt+0x23>
  80072e:	83 ee 01             	sub    $0x1,%esi
  800731:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800735:	75 f7                	jne    80072e <vprintfmt+0x3b4>
  800737:	e9 61 fc ff ff       	jmp    80039d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80073c:	83 c4 4c             	add    $0x4c,%esp
  80073f:	5b                   	pop    %ebx
  800740:	5e                   	pop    %esi
  800741:	5f                   	pop    %edi
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 28             	sub    $0x28,%esp
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800750:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800753:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800757:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80075a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800761:	85 c0                	test   %eax,%eax
  800763:	74 30                	je     800795 <vsnprintf+0x51>
  800765:	85 d2                	test   %edx,%edx
  800767:	7e 2c                	jle    800795 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800770:	8b 45 10             	mov    0x10(%ebp),%eax
  800773:	89 44 24 08          	mov    %eax,0x8(%esp)
  800777:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077e:	c7 04 24 35 03 80 00 	movl   $0x800335,(%esp)
  800785:	e8 f0 fb ff ff       	call   80037a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800793:	eb 05                	jmp    80079a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	89 04 24             	mov    %eax,(%esp)
  8007bd:	e8 82 ff ff ff       	call   800744 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    
	...

008007d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	80 3a 00             	cmpb   $0x0,(%edx)
  8007de:	74 09                	je     8007e9 <strlen+0x19>
		n++;
  8007e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e7:	75 f7                	jne    8007e0 <strlen+0x10>
		n++;
	return n;
}
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fa:	85 c9                	test   %ecx,%ecx
  8007fc:	74 1a                	je     800818 <strnlen+0x2d>
  8007fe:	80 3b 00             	cmpb   $0x0,(%ebx)
  800801:	74 15                	je     800818 <strnlen+0x2d>
  800803:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800808:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080a:	39 ca                	cmp    %ecx,%edx
  80080c:	74 0a                	je     800818 <strnlen+0x2d>
  80080e:	83 c2 01             	add    $0x1,%edx
  800811:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800816:	75 f0                	jne    800808 <strnlen+0x1d>
		n++;
	return n;
}
  800818:	5b                   	pop    %ebx
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	53                   	push   %ebx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800825:	ba 00 00 00 00       	mov    $0x0,%edx
  80082a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80082e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800831:	83 c2 01             	add    $0x1,%edx
  800834:	84 c9                	test   %cl,%cl
  800836:	75 f2                	jne    80082a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800838:	5b                   	pop    %ebx
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	53                   	push   %ebx
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800845:	89 1c 24             	mov    %ebx,(%esp)
  800848:	e8 83 ff ff ff       	call   8007d0 <strlen>
	strcpy(dst + len, src);
  80084d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800850:	89 54 24 04          	mov    %edx,0x4(%esp)
  800854:	01 d8                	add    %ebx,%eax
  800856:	89 04 24             	mov    %eax,(%esp)
  800859:	e8 bd ff ff ff       	call   80081b <strcpy>
	return dst;
}
  80085e:	89 d8                	mov    %ebx,%eax
  800860:	83 c4 08             	add    $0x8,%esp
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800874:	85 f6                	test   %esi,%esi
  800876:	74 18                	je     800890 <strncpy+0x2a>
  800878:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80087d:	0f b6 1a             	movzbl (%edx),%ebx
  800880:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800883:	80 3a 01             	cmpb   $0x1,(%edx)
  800886:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800889:	83 c1 01             	add    $0x1,%ecx
  80088c:	39 f1                	cmp    %esi,%ecx
  80088e:	75 ed                	jne    80087d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	57                   	push   %edi
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80089d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008a0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a3:	89 f8                	mov    %edi,%eax
  8008a5:	85 f6                	test   %esi,%esi
  8008a7:	74 2b                	je     8008d4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8008a9:	83 fe 01             	cmp    $0x1,%esi
  8008ac:	74 23                	je     8008d1 <strlcpy+0x3d>
  8008ae:	0f b6 0b             	movzbl (%ebx),%ecx
  8008b1:	84 c9                	test   %cl,%cl
  8008b3:	74 1c                	je     8008d1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  8008b5:	83 ee 02             	sub    $0x2,%esi
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008bd:	88 08                	mov    %cl,(%eax)
  8008bf:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c2:	39 f2                	cmp    %esi,%edx
  8008c4:	74 0b                	je     8008d1 <strlcpy+0x3d>
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008cd:	84 c9                	test   %cl,%cl
  8008cf:	75 ec                	jne    8008bd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8008d1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008d4:	29 f8                	sub    %edi,%eax
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5e                   	pop    %esi
  8008d8:	5f                   	pop    %edi
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e4:	0f b6 01             	movzbl (%ecx),%eax
  8008e7:	84 c0                	test   %al,%al
  8008e9:	74 16                	je     800901 <strcmp+0x26>
  8008eb:	3a 02                	cmp    (%edx),%al
  8008ed:	75 12                	jne    800901 <strcmp+0x26>
		p++, q++;
  8008ef:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008f2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8008f6:	84 c0                	test   %al,%al
  8008f8:	74 07                	je     800901 <strcmp+0x26>
  8008fa:	83 c1 01             	add    $0x1,%ecx
  8008fd:	3a 02                	cmp    (%edx),%al
  8008ff:	74 ee                	je     8008ef <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800901:	0f b6 c0             	movzbl %al,%eax
  800904:	0f b6 12             	movzbl (%edx),%edx
  800907:	29 d0                	sub    %edx,%eax
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800912:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800915:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800918:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80091d:	85 d2                	test   %edx,%edx
  80091f:	74 28                	je     800949 <strncmp+0x3e>
  800921:	0f b6 01             	movzbl (%ecx),%eax
  800924:	84 c0                	test   %al,%al
  800926:	74 24                	je     80094c <strncmp+0x41>
  800928:	3a 03                	cmp    (%ebx),%al
  80092a:	75 20                	jne    80094c <strncmp+0x41>
  80092c:	83 ea 01             	sub    $0x1,%edx
  80092f:	74 13                	je     800944 <strncmp+0x39>
		n--, p++, q++;
  800931:	83 c1 01             	add    $0x1,%ecx
  800934:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800937:	0f b6 01             	movzbl (%ecx),%eax
  80093a:	84 c0                	test   %al,%al
  80093c:	74 0e                	je     80094c <strncmp+0x41>
  80093e:	3a 03                	cmp    (%ebx),%al
  800940:	74 ea                	je     80092c <strncmp+0x21>
  800942:	eb 08                	jmp    80094c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800949:	5b                   	pop    %ebx
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094c:	0f b6 01             	movzbl (%ecx),%eax
  80094f:	0f b6 13             	movzbl (%ebx),%edx
  800952:	29 d0                	sub    %edx,%eax
  800954:	eb f3                	jmp    800949 <strncmp+0x3e>

00800956 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800960:	0f b6 10             	movzbl (%eax),%edx
  800963:	84 d2                	test   %dl,%dl
  800965:	74 1c                	je     800983 <strchr+0x2d>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	75 09                	jne    800974 <strchr+0x1e>
  80096b:	eb 1b                	jmp    800988 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80096d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800970:	38 ca                	cmp    %cl,%dl
  800972:	74 14                	je     800988 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800974:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800978:	84 d2                	test   %dl,%dl
  80097a:	75 f1                	jne    80096d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	eb 05                	jmp    800988 <strchr+0x32>
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	0f b6 10             	movzbl (%eax),%edx
  800997:	84 d2                	test   %dl,%dl
  800999:	74 14                	je     8009af <strfind+0x25>
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	75 06                	jne    8009a5 <strfind+0x1b>
  80099f:	eb 0e                	jmp    8009af <strfind+0x25>
  8009a1:	38 ca                	cmp    %cl,%dl
  8009a3:	74 0a                	je     8009af <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009a5:	83 c0 01             	add    $0x1,%eax
  8009a8:	0f b6 10             	movzbl (%eax),%edx
  8009ab:	84 d2                	test   %dl,%dl
  8009ad:	75 f2                	jne    8009a1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009ba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009bd:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8009c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c9:	85 c9                	test   %ecx,%ecx
  8009cb:	74 30                	je     8009fd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d3:	75 25                	jne    8009fa <memset+0x49>
  8009d5:	f6 c1 03             	test   $0x3,%cl
  8009d8:	75 20                	jne    8009fa <memset+0x49>
		c &= 0xFF;
  8009da:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009dd:	89 d3                	mov    %edx,%ebx
  8009df:	c1 e3 08             	shl    $0x8,%ebx
  8009e2:	89 d6                	mov    %edx,%esi
  8009e4:	c1 e6 18             	shl    $0x18,%esi
  8009e7:	89 d0                	mov    %edx,%eax
  8009e9:	c1 e0 10             	shl    $0x10,%eax
  8009ec:	09 f0                	or     %esi,%eax
  8009ee:	09 d0                	or     %edx,%eax
  8009f0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009f5:	fc                   	cld    
  8009f6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f8:	eb 03                	jmp    8009fd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a08:	89 ec                	mov    %ebp,%esp
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a15:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a21:	39 c6                	cmp    %eax,%esi
  800a23:	73 36                	jae    800a5b <memmove+0x4f>
  800a25:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a28:	39 d0                	cmp    %edx,%eax
  800a2a:	73 2f                	jae    800a5b <memmove+0x4f>
		s += n;
		d += n;
  800a2c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2f:	f6 c2 03             	test   $0x3,%dl
  800a32:	75 1b                	jne    800a4f <memmove+0x43>
  800a34:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3a:	75 13                	jne    800a4f <memmove+0x43>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 20                	jmp    800a7b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a61:	75 13                	jne    800a76 <memmove+0x6a>
  800a63:	a8 03                	test   $0x3,%al
  800a65:	75 0f                	jne    800a76 <memmove+0x6a>
  800a67:	f6 c1 03             	test   $0x3,%cl
  800a6a:	75 0a                	jne    800a76 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6f:	89 c7                	mov    %eax,%edi
  800a71:	fc                   	cld    
  800a72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a74:	eb 05                	jmp    800a7b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a76:	89 c7                	mov    %eax,%edi
  800a78:	fc                   	cld    
  800a79:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a81:	89 ec                	mov    %ebp,%esp
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	89 04 24             	mov    %eax,(%esp)
  800a9f:	e8 68 ff ff ff       	call   800a0c <memmove>
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800aaf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aba:	85 ff                	test   %edi,%edi
  800abc:	74 37                	je     800af5 <memcmp+0x4f>
		if (*s1 != *s2)
  800abe:	0f b6 03             	movzbl (%ebx),%eax
  800ac1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac4:	83 ef 01             	sub    $0x1,%edi
  800ac7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800acc:	38 c8                	cmp    %cl,%al
  800ace:	74 1c                	je     800aec <memcmp+0x46>
  800ad0:	eb 10                	jmp    800ae2 <memcmp+0x3c>
  800ad2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ad7:	83 c2 01             	add    $0x1,%edx
  800ada:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800ade:	38 c8                	cmp    %cl,%al
  800ae0:	74 0a                	je     800aec <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800ae2:	0f b6 c0             	movzbl %al,%eax
  800ae5:	0f b6 c9             	movzbl %cl,%ecx
  800ae8:	29 c8                	sub    %ecx,%eax
  800aea:	eb 09                	jmp    800af5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aec:	39 fa                	cmp    %edi,%edx
  800aee:	75 e2                	jne    800ad2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b00:	89 c2                	mov    %eax,%edx
  800b02:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b05:	39 d0                	cmp    %edx,%eax
  800b07:	73 19                	jae    800b22 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b0d:	38 08                	cmp    %cl,(%eax)
  800b0f:	75 06                	jne    800b17 <memfind+0x1d>
  800b11:	eb 0f                	jmp    800b22 <memfind+0x28>
  800b13:	38 08                	cmp    %cl,(%eax)
  800b15:	74 0b                	je     800b22 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b17:	83 c0 01             	add    $0x1,%eax
  800b1a:	39 d0                	cmp    %edx,%eax
  800b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b20:	75 f1                	jne    800b13 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b30:	0f b6 02             	movzbl (%edx),%eax
  800b33:	3c 20                	cmp    $0x20,%al
  800b35:	74 04                	je     800b3b <strtol+0x17>
  800b37:	3c 09                	cmp    $0x9,%al
  800b39:	75 0e                	jne    800b49 <strtol+0x25>
		s++;
  800b3b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3e:	0f b6 02             	movzbl (%edx),%eax
  800b41:	3c 20                	cmp    $0x20,%al
  800b43:	74 f6                	je     800b3b <strtol+0x17>
  800b45:	3c 09                	cmp    $0x9,%al
  800b47:	74 f2                	je     800b3b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b49:	3c 2b                	cmp    $0x2b,%al
  800b4b:	75 0a                	jne    800b57 <strtol+0x33>
		s++;
  800b4d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b50:	bf 00 00 00 00       	mov    $0x0,%edi
  800b55:	eb 10                	jmp    800b67 <strtol+0x43>
  800b57:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b5c:	3c 2d                	cmp    $0x2d,%al
  800b5e:	75 07                	jne    800b67 <strtol+0x43>
		s++, neg = 1;
  800b60:	83 c2 01             	add    $0x1,%edx
  800b63:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 94 c0             	sete   %al
  800b6c:	74 05                	je     800b73 <strtol+0x4f>
  800b6e:	83 fb 10             	cmp    $0x10,%ebx
  800b71:	75 15                	jne    800b88 <strtol+0x64>
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 10                	jne    800b88 <strtol+0x64>
  800b78:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b7c:	75 0a                	jne    800b88 <strtol+0x64>
		s += 2, base = 16;
  800b7e:	83 c2 02             	add    $0x2,%edx
  800b81:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b86:	eb 13                	jmp    800b9b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b91:	80 3a 30             	cmpb   $0x30,(%edx)
  800b94:	75 05                	jne    800b9b <strtol+0x77>
		s++, base = 8;
  800b96:	83 c2 01             	add    $0x1,%edx
  800b99:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ba2:	0f b6 0a             	movzbl (%edx),%ecx
  800ba5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ba8:	80 fb 09             	cmp    $0x9,%bl
  800bab:	77 08                	ja     800bb5 <strtol+0x91>
			dig = *s - '0';
  800bad:	0f be c9             	movsbl %cl,%ecx
  800bb0:	83 e9 30             	sub    $0x30,%ecx
  800bb3:	eb 1e                	jmp    800bd3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800bb5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bb8:	80 fb 19             	cmp    $0x19,%bl
  800bbb:	77 08                	ja     800bc5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800bbd:	0f be c9             	movsbl %cl,%ecx
  800bc0:	83 e9 57             	sub    $0x57,%ecx
  800bc3:	eb 0e                	jmp    800bd3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800bc5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 14                	ja     800be1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800bcd:	0f be c9             	movsbl %cl,%ecx
  800bd0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bd3:	39 f1                	cmp    %esi,%ecx
  800bd5:	7d 0e                	jge    800be5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd7:	83 c2 01             	add    $0x1,%edx
  800bda:	0f af c6             	imul   %esi,%eax
  800bdd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800bdf:	eb c1                	jmp    800ba2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800be1:	89 c1                	mov    %eax,%ecx
  800be3:	eb 02                	jmp    800be7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 05                	je     800bf2 <strtol+0xce>
		*endptr = (char *) s;
  800bed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bf2:	89 ca                	mov    %ecx,%edx
  800bf4:	f7 da                	neg    %edx
  800bf6:	85 ff                	test   %edi,%edi
  800bf8:	0f 45 c2             	cmovne %edx,%eax
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c09:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c17:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1a:	89 c3                	mov    %eax,%ebx
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	89 c6                	mov    %eax,%esi
  800c20:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c25:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c2b:	89 ec                	mov    %ebp,%esp
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c38:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c3b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c43:	b8 01 00 00 00       	mov    $0x1,%eax
  800c48:	89 d1                	mov    %edx,%ecx
  800c4a:	89 d3                	mov    %edx,%ebx
  800c4c:	89 d7                	mov    %edx,%edi
  800c4e:	89 d6                	mov    %edx,%esi
  800c50:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c5b:	89 ec                	mov    %ebp,%esp
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 38             	sub    $0x38,%esp
  800c65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c73:	b8 03 00 00 00       	mov    $0x3,%eax
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	89 cb                	mov    %ecx,%ebx
  800c7d:	89 cf                	mov    %ecx,%edi
  800c7f:	89 ce                	mov    %ecx,%esi
  800c81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c83:	85 c0                	test   %eax,%eax
  800c85:	7e 28                	jle    800caf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c92:	00 
  800c93:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800c9a:	00 
  800c9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca2:	00 
  800ca3:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800caa:	e8 51 f4 ff ff       	call   800100 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800caf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cb8:	89 ec                	mov    %ebp,%esp
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ce8:	89 ec                	mov    %ebp,%esp
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_yield>:

void
sys_yield(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cf8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d18:	89 ec                	mov    %ebp,%esp
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 38             	sub    $0x38,%esp
  800d22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	be 00 00 00 00       	mov    $0x0,%esi
  800d30:	b8 04 00 00 00       	mov    $0x4,%eax
  800d35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	89 f7                	mov    %esi,%edi
  800d40:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	7e 28                	jle    800d6e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d51:	00 
  800d52:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800d59:	00 
  800d5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d61:	00 
  800d62:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800d69:	e8 92 f3 ff ff       	call   800100 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d71:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d74:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d77:	89 ec                	mov    %ebp,%esp
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 38             	sub    $0x38,%esp
  800d81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d87:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d8f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7e 28                	jle    800dcc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800daf:	00 
  800db0:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800db7:	00 
  800db8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbf:	00 
  800dc0:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800dc7:	e8 34 f3 ff ff       	call   800100 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dcc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dcf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd5:	89 ec                	mov    %ebp,%esp
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 38             	sub    $0x38,%esp
  800ddf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ded:	b8 06 00 00 00       	mov    $0x6,%eax
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	8b 55 08             	mov    0x8(%ebp),%edx
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	89 de                	mov    %ebx,%esi
  800dfc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7e 28                	jle    800e2a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e06:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e0d:	00 
  800e0e:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800e15:	00 
  800e16:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1d:	00 
  800e1e:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800e25:	e8 d6 f2 ff ff       	call   800100 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e2d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e30:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e33:	89 ec                	mov    %ebp,%esp
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 38             	sub    $0x38,%esp
  800e3d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e40:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e43:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7e 28                	jle    800e88 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e6b:	00 
  800e6c:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800e73:	00 
  800e74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7b:	00 
  800e7c:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800e83:	e8 78 f2 ff ff       	call   800100 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e88:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e8e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e91:	89 ec                	mov    %ebp,%esp
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 38             	sub    $0x38,%esp
  800e9b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e9e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea9:	b8 09 00 00 00       	mov    $0x9,%eax
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	89 df                	mov    %ebx,%edi
  800eb6:	89 de                	mov    %ebx,%esi
  800eb8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	7e 28                	jle    800ee6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ec9:	00 
  800eca:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed9:	00 
  800eda:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800ee1:	e8 1a f2 ff ff       	call   800100 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ee6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eef:	89 ec                	mov    %ebp,%esp
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 38             	sub    $0x38,%esp
  800ef9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	89 df                	mov    %ebx,%edi
  800f14:	89 de                	mov    %ebx,%esi
  800f16:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	7e 28                	jle    800f44 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f20:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f27:	00 
  800f28:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800f2f:	00 
  800f30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f37:	00 
  800f38:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800f3f:	e8 bc f1 ff ff       	call   800100 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f44:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f47:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4d:	89 ec                	mov    %ebp,%esp
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f60:	be 00 00 00 00       	mov    $0x0,%esi
  800f65:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f78:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f81:	89 ec                	mov    %ebp,%esp
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 38             	sub    $0x38,%esp
  800f8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800fd0:	e8 2b f1 ff ff       	call   800100 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fdb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fde:	89 ec                	mov    %ebp,%esp
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    
	...

00800ff0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	05 00 00 00 30       	add    $0x30000000,%eax
  800ffb:	c1 e8 0c             	shr    $0xc,%eax
}
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 04 24             	mov    %eax,(%esp)
  80100c:	e8 df ff ff ff       	call   800ff0 <fd2num>
  801011:	05 20 00 0d 00       	add    $0xd0020,%eax
  801016:	c1 e0 0c             	shl    $0xc,%eax
}
  801019:	c9                   	leave  
  80101a:	c3                   	ret    

0080101b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	53                   	push   %ebx
  80101f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801022:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801027:	a8 01                	test   $0x1,%al
  801029:	74 34                	je     80105f <fd_alloc+0x44>
  80102b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801030:	a8 01                	test   $0x1,%al
  801032:	74 32                	je     801066 <fd_alloc+0x4b>
  801034:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801039:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	c1 ea 16             	shr    $0x16,%edx
  801040:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801047:	f6 c2 01             	test   $0x1,%dl
  80104a:	74 1f                	je     80106b <fd_alloc+0x50>
  80104c:	89 c2                	mov    %eax,%edx
  80104e:	c1 ea 0c             	shr    $0xc,%edx
  801051:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801058:	f6 c2 01             	test   $0x1,%dl
  80105b:	75 17                	jne    801074 <fd_alloc+0x59>
  80105d:	eb 0c                	jmp    80106b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80105f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801064:	eb 05                	jmp    80106b <fd_alloc+0x50>
  801066:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80106b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
  801072:	eb 17                	jmp    80108b <fd_alloc+0x70>
  801074:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801079:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80107e:	75 b9                	jne    801039 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801080:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801086:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80108b:	5b                   	pop    %ebx
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801099:	83 fa 1f             	cmp    $0x1f,%edx
  80109c:	77 3f                	ja     8010dd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80109e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8010a4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010a7:	89 d0                	mov    %edx,%eax
  8010a9:	c1 e8 16             	shr    $0x16,%eax
  8010ac:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b8:	f6 c1 01             	test   $0x1,%cl
  8010bb:	74 20                	je     8010dd <fd_lookup+0x4f>
  8010bd:	89 d0                	mov    %edx,%eax
  8010bf:	c1 e8 0c             	shr    $0xc,%eax
  8010c2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ce:	f6 c1 01             	test   $0x1,%cl
  8010d1:	74 0a                	je     8010dd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 10                	mov    %edx,(%eax)
	return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 14             	sub    $0x14,%esp
  8010e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010f1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8010f7:	75 17                	jne    801110 <dev_lookup+0x31>
  8010f9:	eb 07                	jmp    801102 <dev_lookup+0x23>
  8010fb:	39 0a                	cmp    %ecx,(%edx)
  8010fd:	75 11                	jne    801110 <dev_lookup+0x31>
  8010ff:	90                   	nop
  801100:	eb 05                	jmp    801107 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801102:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801107:	89 13                	mov    %edx,(%ebx)
			return 0;
  801109:	b8 00 00 00 00       	mov    $0x0,%eax
  80110e:	eb 35                	jmp    801145 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801110:	83 c0 01             	add    $0x1,%eax
  801113:	8b 14 85 a8 2c 80 00 	mov    0x802ca8(,%eax,4),%edx
  80111a:	85 d2                	test   %edx,%edx
  80111c:	75 dd                	jne    8010fb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80111e:	a1 04 40 80 00       	mov    0x804004,%eax
  801123:	8b 40 48             	mov    0x48(%eax),%eax
  801126:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80112a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112e:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  801135:	e8 c1 f0 ff ff       	call   8001fb <cprintf>
	*dev = 0;
  80113a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801140:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801145:	83 c4 14             	add    $0x14,%esp
  801148:	5b                   	pop    %ebx
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 38             	sub    $0x38,%esp
  801151:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801154:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801157:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80115a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80115d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801161:	89 3c 24             	mov    %edi,(%esp)
  801164:	e8 87 fe ff ff       	call   800ff0 <fd2num>
  801169:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80116c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801170:	89 04 24             	mov    %eax,(%esp)
  801173:	e8 16 ff ff ff       	call   80108e <fd_lookup>
  801178:	89 c3                	mov    %eax,%ebx
  80117a:	85 c0                	test   %eax,%eax
  80117c:	78 05                	js     801183 <fd_close+0x38>
	    || fd != fd2)
  80117e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801181:	74 0e                	je     801191 <fd_close+0x46>
		return (must_exist ? r : 0);
  801183:	89 f0                	mov    %esi,%eax
  801185:	84 c0                	test   %al,%al
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	0f 44 d8             	cmove  %eax,%ebx
  80118f:	eb 3d                	jmp    8011ce <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801191:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801194:	89 44 24 04          	mov    %eax,0x4(%esp)
  801198:	8b 07                	mov    (%edi),%eax
  80119a:	89 04 24             	mov    %eax,(%esp)
  80119d:	e8 3d ff ff ff       	call   8010df <dev_lookup>
  8011a2:	89 c3                	mov    %eax,%ebx
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	78 16                	js     8011be <fd_close+0x73>
		if (dev->dev_close)
  8011a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	74 07                	je     8011be <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8011b7:	89 3c 24             	mov    %edi,(%esp)
  8011ba:	ff d0                	call   *%eax
  8011bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c9:	e8 0b fc ff ff       	call   800dd9 <sys_page_unmap>
	return r;
}
  8011ce:	89 d8                	mov    %ebx,%eax
  8011d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d9:	89 ec                	mov    %ebp,%esp
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 04 24             	mov    %eax,(%esp)
  8011f0:	e8 99 fe ff ff       	call   80108e <fd_lookup>
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 13                	js     80120c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8011f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801200:	00 
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	89 04 24             	mov    %eax,(%esp)
  801207:	e8 3f ff ff ff       	call   80114b <fd_close>
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <close_all>:

void
close_all(void)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	53                   	push   %ebx
  801212:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801215:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80121a:	89 1c 24             	mov    %ebx,(%esp)
  80121d:	e8 bb ff ff ff       	call   8011dd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801222:	83 c3 01             	add    $0x1,%ebx
  801225:	83 fb 20             	cmp    $0x20,%ebx
  801228:	75 f0                	jne    80121a <close_all+0xc>
		close(i);
}
  80122a:	83 c4 14             	add    $0x14,%esp
  80122d:	5b                   	pop    %ebx
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 58             	sub    $0x58,%esp
  801236:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801239:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80123c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80123f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801242:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801245:	89 44 24 04          	mov    %eax,0x4(%esp)
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	89 04 24             	mov    %eax,(%esp)
  80124f:	e8 3a fe ff ff       	call   80108e <fd_lookup>
  801254:	89 c3                	mov    %eax,%ebx
  801256:	85 c0                	test   %eax,%eax
  801258:	0f 88 e1 00 00 00    	js     80133f <dup+0x10f>
		return r;
	close(newfdnum);
  80125e:	89 3c 24             	mov    %edi,(%esp)
  801261:	e8 77 ff ff ff       	call   8011dd <close>

	newfd = INDEX2FD(newfdnum);
  801266:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80126c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80126f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801272:	89 04 24             	mov    %eax,(%esp)
  801275:	e8 86 fd ff ff       	call   801000 <fd2data>
  80127a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80127c:	89 34 24             	mov    %esi,(%esp)
  80127f:	e8 7c fd ff ff       	call   801000 <fd2data>
  801284:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e8 16             	shr    $0x16,%eax
  80128c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801293:	a8 01                	test   $0x1,%al
  801295:	74 46                	je     8012dd <dup+0xad>
  801297:	89 d8                	mov    %ebx,%eax
  801299:	c1 e8 0c             	shr    $0xc,%eax
  80129c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a3:	f6 c2 01             	test   $0x1,%dl
  8012a6:	74 35                	je     8012dd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012af:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c6:	00 
  8012c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d2:	e8 a4 fa ff ff       	call   800d7b <sys_page_map>
  8012d7:	89 c3                	mov    %eax,%ebx
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 3b                	js     801318 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	c1 ea 0c             	shr    $0xc,%edx
  8012e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ec:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012f2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801301:	00 
  801302:	89 44 24 04          	mov    %eax,0x4(%esp)
  801306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130d:	e8 69 fa ff ff       	call   800d7b <sys_page_map>
  801312:	89 c3                	mov    %eax,%ebx
  801314:	85 c0                	test   %eax,%eax
  801316:	79 25                	jns    80133d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801318:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801323:	e8 b1 fa ff ff       	call   800dd9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80132b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801336:	e8 9e fa ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  80133b:	eb 02                	jmp    80133f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80133d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80133f:	89 d8                	mov    %ebx,%eax
  801341:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801344:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801347:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80134a:	89 ec                	mov    %ebp,%esp
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    

0080134e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	53                   	push   %ebx
  801352:	83 ec 24             	sub    $0x24,%esp
  801355:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801358:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80135b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135f:	89 1c 24             	mov    %ebx,(%esp)
  801362:	e8 27 fd ff ff       	call   80108e <fd_lookup>
  801367:	85 c0                	test   %eax,%eax
  801369:	78 6d                	js     8013d8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80136b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	89 04 24             	mov    %eax,(%esp)
  80137a:	e8 60 fd ff ff       	call   8010df <dev_lookup>
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 55                	js     8013d8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 50 08             	mov    0x8(%eax),%edx
  801389:	83 e2 03             	and    $0x3,%edx
  80138c:	83 fa 01             	cmp    $0x1,%edx
  80138f:	75 23                	jne    8013b4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801391:	a1 04 40 80 00       	mov    0x804004,%eax
  801396:	8b 40 48             	mov    0x48(%eax),%eax
  801399:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	c7 04 24 6d 2c 80 00 	movl   $0x802c6d,(%esp)
  8013a8:	e8 4e ee ff ff       	call   8001fb <cprintf>
		return -E_INVAL;
  8013ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b2:	eb 24                	jmp    8013d8 <read+0x8a>
	}
	if (!dev->dev_read)
  8013b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b7:	8b 52 08             	mov    0x8(%edx),%edx
  8013ba:	85 d2                	test   %edx,%edx
  8013bc:	74 15                	je     8013d3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013cc:	89 04 24             	mov    %eax,(%esp)
  8013cf:	ff d2                	call   *%edx
  8013d1:	eb 05                	jmp    8013d8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013d8:	83 c4 24             	add    $0x24,%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 1c             	sub    $0x1c,%esp
  8013e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	85 f6                	test   %esi,%esi
  8013f4:	74 30                	je     801426 <readn+0x48>
  8013f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013fb:	89 f2                	mov    %esi,%edx
  8013fd:	29 c2                	sub    %eax,%edx
  8013ff:	89 54 24 08          	mov    %edx,0x8(%esp)
  801403:	03 45 0c             	add    0xc(%ebp),%eax
  801406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140a:	89 3c 24             	mov    %edi,(%esp)
  80140d:	e8 3c ff ff ff       	call   80134e <read>
		if (m < 0)
  801412:	85 c0                	test   %eax,%eax
  801414:	78 10                	js     801426 <readn+0x48>
			return m;
		if (m == 0)
  801416:	85 c0                	test   %eax,%eax
  801418:	74 0a                	je     801424 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141a:	01 c3                	add    %eax,%ebx
  80141c:	89 d8                	mov    %ebx,%eax
  80141e:	39 f3                	cmp    %esi,%ebx
  801420:	72 d9                	jb     8013fb <readn+0x1d>
  801422:	eb 02                	jmp    801426 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801424:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801426:	83 c4 1c             	add    $0x1c,%esp
  801429:	5b                   	pop    %ebx
  80142a:	5e                   	pop    %esi
  80142b:	5f                   	pop    %edi
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  801442:	e8 47 fc ff ff       	call   80108e <fd_lookup>
  801447:	85 c0                	test   %eax,%eax
  801449:	78 68                	js     8014b3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801455:	8b 00                	mov    (%eax),%eax
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	e8 80 fc ff ff       	call   8010df <dev_lookup>
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 50                	js     8014b3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801466:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80146a:	75 23                	jne    80148f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80146c:	a1 04 40 80 00       	mov    0x804004,%eax
  801471:	8b 40 48             	mov    0x48(%eax),%eax
  801474:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147c:	c7 04 24 89 2c 80 00 	movl   $0x802c89,(%esp)
  801483:	e8 73 ed ff ff       	call   8001fb <cprintf>
		return -E_INVAL;
  801488:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148d:	eb 24                	jmp    8014b3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801492:	8b 52 0c             	mov    0xc(%edx),%edx
  801495:	85 d2                	test   %edx,%edx
  801497:	74 15                	je     8014ae <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801499:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a7:	89 04 24             	mov    %eax,(%esp)
  8014aa:	ff d2                	call   *%edx
  8014ac:	eb 05                	jmp    8014b3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014b3:	83 c4 24             	add    $0x24,%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014bf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	89 04 24             	mov    %eax,(%esp)
  8014cc:	e8 bd fb ff ff       	call   80108e <fd_lookup>
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 0e                	js     8014e3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 24             	sub    $0x24,%esp
  8014ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f6:	89 1c 24             	mov    %ebx,(%esp)
  8014f9:	e8 90 fb ff ff       	call   80108e <fd_lookup>
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 61                	js     801563 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	89 04 24             	mov    %eax,(%esp)
  801511:	e8 c9 fb ff ff       	call   8010df <dev_lookup>
  801516:	85 c0                	test   %eax,%eax
  801518:	78 49                	js     801563 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801521:	75 23                	jne    801546 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801523:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801528:	8b 40 48             	mov    0x48(%eax),%eax
  80152b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801533:	c7 04 24 4c 2c 80 00 	movl   $0x802c4c,(%esp)
  80153a:	e8 bc ec ff ff       	call   8001fb <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801544:	eb 1d                	jmp    801563 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	8b 52 18             	mov    0x18(%edx),%edx
  80154c:	85 d2                	test   %edx,%edx
  80154e:	74 0e                	je     80155e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801553:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	ff d2                	call   *%edx
  80155c:	eb 05                	jmp    801563 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80155e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801563:	83 c4 24             	add    $0x24,%esp
  801566:	5b                   	pop    %ebx
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	53                   	push   %ebx
  80156d:	83 ec 24             	sub    $0x24,%esp
  801570:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801573:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	89 04 24             	mov    %eax,(%esp)
  801580:	e8 09 fb ff ff       	call   80108e <fd_lookup>
  801585:	85 c0                	test   %eax,%eax
  801587:	78 52                	js     8015db <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801589:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	8b 00                	mov    (%eax),%eax
  801595:	89 04 24             	mov    %eax,(%esp)
  801598:	e8 42 fb ff ff       	call   8010df <dev_lookup>
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 3a                	js     8015db <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015a8:	74 2c                	je     8015d6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015aa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ad:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015b4:	00 00 00 
	stat->st_isdir = 0;
  8015b7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015be:	00 00 00 
	stat->st_dev = dev;
  8015c1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ce:	89 14 24             	mov    %edx,(%esp)
  8015d1:	ff 50 14             	call   *0x14(%eax)
  8015d4:	eb 05                	jmp    8015db <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015db:	83 c4 24             	add    $0x24,%esp
  8015de:	5b                   	pop    %ebx
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    

008015e1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 18             	sub    $0x18,%esp
  8015e7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015ea:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015f4:	00 
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	89 04 24             	mov    %eax,(%esp)
  8015fb:	e8 bc 01 00 00       	call   8017bc <open>
  801600:	89 c3                	mov    %eax,%ebx
  801602:	85 c0                	test   %eax,%eax
  801604:	78 1b                	js     801621 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160d:	89 1c 24             	mov    %ebx,(%esp)
  801610:	e8 54 ff ff ff       	call   801569 <fstat>
  801615:	89 c6                	mov    %eax,%esi
	close(fd);
  801617:	89 1c 24             	mov    %ebx,(%esp)
  80161a:	e8 be fb ff ff       	call   8011dd <close>
	return r;
  80161f:	89 f3                	mov    %esi,%ebx
}
  801621:	89 d8                	mov    %ebx,%eax
  801623:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801626:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801629:	89 ec                	mov    %ebp,%esp
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    
  80162d:	00 00                	add    %al,(%eax)
	...

00801630 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 18             	sub    $0x18,%esp
  801636:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801639:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80163c:	89 c3                	mov    %eax,%ebx
  80163e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801640:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801647:	75 11                	jne    80165a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801649:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801650:	e8 f1 0e 00 00       	call   802546 <ipc_find_env>
  801655:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80165a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801661:	00 
  801662:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801669:	00 
  80166a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80166e:	a1 00 40 80 00       	mov    0x804000,%eax
  801673:	89 04 24             	mov    %eax,(%esp)
  801676:	e8 47 0e 00 00       	call   8024c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801682:	00 
  801683:	89 74 24 04          	mov    %esi,0x4(%esp)
  801687:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168e:	e8 dd 0d 00 00       	call   802470 <ipc_recv>
}
  801693:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801696:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801699:	89 ec                	mov    %ebp,%esp
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 14             	sub    $0x14,%esp
  8016a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ad:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016bc:	e8 6f ff ff ff       	call   801630 <fsipc>
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 2b                	js     8016f0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016c5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016cc:	00 
  8016cd:	89 1c 24             	mov    %ebx,(%esp)
  8016d0:	e8 46 f1 ff ff       	call   80081b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016d5:	a1 80 50 80 00       	mov    0x805080,%eax
  8016da:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016e0:	a1 84 50 80 00       	mov    0x805084,%eax
  8016e5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f0:	83 c4 14             	add    $0x14,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801702:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801707:	ba 00 00 00 00       	mov    $0x0,%edx
  80170c:	b8 06 00 00 00       	mov    $0x6,%eax
  801711:	e8 1a ff ff ff       	call   801630 <fsipc>
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
  80171d:	83 ec 10             	sub    $0x10,%esp
  801720:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8b 40 0c             	mov    0xc(%eax),%eax
  801729:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80172e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 03 00 00 00       	mov    $0x3,%eax
  80173e:	e8 ed fe ff ff       	call   801630 <fsipc>
  801743:	89 c3                	mov    %eax,%ebx
  801745:	85 c0                	test   %eax,%eax
  801747:	78 6a                	js     8017b3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801749:	39 c6                	cmp    %eax,%esi
  80174b:	73 24                	jae    801771 <devfile_read+0x59>
  80174d:	c7 44 24 0c b8 2c 80 	movl   $0x802cb8,0xc(%esp)
  801754:	00 
  801755:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  80175c:	00 
  80175d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801764:	00 
  801765:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  80176c:	e8 8f e9 ff ff       	call   800100 <_panic>
	assert(r <= PGSIZE);
  801771:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801776:	7e 24                	jle    80179c <devfile_read+0x84>
  801778:	c7 44 24 0c df 2c 80 	movl   $0x802cdf,0xc(%esp)
  80177f:	00 
  801780:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  801787:	00 
  801788:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80178f:	00 
  801790:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  801797:	e8 64 e9 ff ff       	call   800100 <_panic>
	memmove(buf, &fsipcbuf, r);
  80179c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017a0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017a7:	00 
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	89 04 24             	mov    %eax,(%esp)
  8017ae:	e8 59 f2 ff ff       	call   800a0c <memmove>
	return r;
}
  8017b3:	89 d8                	mov    %ebx,%eax
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 20             	sub    $0x20,%esp
  8017c4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017c7:	89 34 24             	mov    %esi,(%esp)
  8017ca:	e8 01 f0 ff ff       	call   8007d0 <strlen>
		return -E_BAD_PATH;
  8017cf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017d4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d9:	7f 5e                	jg     801839 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017de:	89 04 24             	mov    %eax,(%esp)
  8017e1:	e8 35 f8 ff ff       	call   80101b <fd_alloc>
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 4d                	js     801839 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017f7:	e8 1f f0 ff ff       	call   80081b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801807:	b8 01 00 00 00       	mov    $0x1,%eax
  80180c:	e8 1f fe ff ff       	call   801630 <fsipc>
  801811:	89 c3                	mov    %eax,%ebx
  801813:	85 c0                	test   %eax,%eax
  801815:	79 15                	jns    80182c <open+0x70>
		fd_close(fd, 0);
  801817:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80181e:	00 
  80181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801822:	89 04 24             	mov    %eax,(%esp)
  801825:	e8 21 f9 ff ff       	call   80114b <fd_close>
		return r;
  80182a:	eb 0d                	jmp    801839 <open+0x7d>
	}

	return fd2num(fd);
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	89 04 24             	mov    %eax,(%esp)
  801832:	e8 b9 f7 ff ff       	call   800ff0 <fd2num>
  801837:	89 c3                	mov    %eax,%ebx
}
  801839:	89 d8                	mov    %ebx,%eax
  80183b:	83 c4 20             	add    $0x20,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    
	...

00801844 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	57                   	push   %edi
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801850:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801857:	00 
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	89 04 24             	mov    %eax,(%esp)
  80185e:	e8 59 ff ff ff       	call   8017bc <open>
  801863:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801869:	85 c0                	test   %eax,%eax
  80186b:	0f 88 b2 05 00 00    	js     801e23 <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801871:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801878:	00 
  801879:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80187f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801883:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801889:	89 04 24             	mov    %eax,(%esp)
  80188c:	e8 4d fb ff ff       	call   8013de <readn>
  801891:	3d 00 02 00 00       	cmp    $0x200,%eax
  801896:	75 0c                	jne    8018a4 <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  801898:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80189f:	45 4c 46 
  8018a2:	74 3b                	je     8018df <spawn+0x9b>
		close(fd);
  8018a4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8018aa:	89 04 24             	mov    %eax,(%esp)
  8018ad:	e8 2b f9 ff ff       	call   8011dd <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8018b2:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8018b9:	46 
  8018ba:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c4:	c7 04 24 eb 2c 80 00 	movl   $0x802ceb,(%esp)
  8018cb:	e8 2b e9 ff ff       	call   8001fb <cprintf>
		return -E_NOT_EXEC;
  8018d0:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  8018d7:	ff ff ff 
  8018da:	e9 50 05 00 00       	jmp    801e2f <spawn+0x5eb>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8018df:	ba 07 00 00 00       	mov    $0x7,%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	cd 30                	int    $0x30
  8018e8:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8018ee:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	0f 88 33 05 00 00    	js     801e2f <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8018fc:	89 c6                	mov    %eax,%esi
  8018fe:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801904:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801907:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80190d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801913:	b9 11 00 00 00       	mov    $0x11,%ecx
  801918:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80191a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801920:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 02                	mov    (%edx),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	74 5f                	je     80198e <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80192f:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801934:	be 00 00 00 00       	mov    $0x0,%esi
  801939:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  80193b:	89 04 24             	mov    %eax,(%esp)
  80193e:	e8 8d ee ff ff       	call   8007d0 <strlen>
  801943:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801947:	83 c6 01             	add    $0x1,%esi
  80194a:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  80194c:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801953:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801956:	85 c0                	test   %eax,%eax
  801958:	75 e1                	jne    80193b <spawn+0xf7>
  80195a:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801960:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801966:	bf 00 10 40 00       	mov    $0x401000,%edi
  80196b:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80196d:	89 f8                	mov    %edi,%eax
  80196f:	83 e0 fc             	and    $0xfffffffc,%eax
  801972:	f7 d2                	not    %edx
  801974:	8d 14 90             	lea    (%eax,%edx,4),%edx
  801977:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	83 e8 08             	sub    $0x8,%eax
  801982:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801987:	77 2d                	ja     8019b6 <spawn+0x172>
  801989:	e9 b2 04 00 00       	jmp    801e40 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80198e:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801995:	00 00 00 
  801998:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  80199f:	00 00 00 
  8019a2:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019a7:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  8019ae:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019b1:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019b6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019bd:	00 
  8019be:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019c5:	00 
  8019c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cd:	e8 4a f3 ff ff       	call   800d1c <sys_page_alloc>
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	0f 88 6b 04 00 00    	js     801e45 <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019da:	85 f6                	test   %esi,%esi
  8019dc:	7e 46                	jle    801a24 <spawn+0x1e0>
  8019de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e3:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  8019e9:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  8019ec:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8019f2:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8019f8:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  8019fb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a02:	89 3c 24             	mov    %edi,(%esp)
  801a05:	e8 11 ee ff ff       	call   80081b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a0a:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801a0d:	89 04 24             	mov    %eax,(%esp)
  801a10:	e8 bb ed ff ff       	call   8007d0 <strlen>
  801a15:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a19:	83 c3 01             	add    $0x1,%ebx
  801a1c:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801a22:	75 c8                	jne    8019ec <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801a24:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801a2a:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801a30:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a37:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a3d:	74 24                	je     801a63 <spawn+0x21f>
  801a3f:	c7 44 24 0c 60 2d 80 	movl   $0x802d60,0xc(%esp)
  801a46:	00 
  801a47:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  801a4e:	00 
  801a4f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801a56:	00 
  801a57:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  801a5e:	e8 9d e6 ff ff       	call   800100 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a63:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a69:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801a6e:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801a74:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801a77:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801a7d:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801a87:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a8d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a94:	00 
  801a95:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801a9c:	ee 
  801a9d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801aae:	00 
  801aaf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab6:	e8 c0 f2 ff ff       	call   800d7b <sys_page_map>
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 1a                	js     801adb <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801ac1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ac8:	00 
  801ac9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad0:	e8 04 f3 ff ff       	call   800dd9 <sys_page_unmap>
  801ad5:	89 c3                	mov    %eax,%ebx
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	79 1f                	jns    801afa <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801adb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ae2:	00 
  801ae3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aea:	e8 ea f2 ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  801aef:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801af5:	e9 35 03 00 00       	jmp    801e2f <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801afa:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b00:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801b07:	00 
  801b08:	0f 84 e2 01 00 00    	je     801cf0 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b0e:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b15:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b1b:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801b22:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801b25:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801b2b:	83 3a 01             	cmpl   $0x1,(%edx)
  801b2e:	0f 85 9b 01 00 00    	jne    801ccf <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b34:	8b 42 18             	mov    0x18(%edx),%eax
  801b37:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b3a:	83 f8 01             	cmp    $0x1,%eax
  801b3d:	19 c0                	sbb    %eax,%eax
  801b3f:	83 e0 fe             	and    $0xfffffffe,%eax
  801b42:	83 c0 07             	add    $0x7,%eax
  801b45:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b4b:	8b 52 04             	mov    0x4(%edx),%edx
  801b4e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801b54:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b5a:	8b 70 10             	mov    0x10(%eax),%esi
  801b5d:	8b 50 14             	mov    0x14(%eax),%edx
  801b60:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801b66:	8b 40 08             	mov    0x8(%eax),%eax
  801b69:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801b6f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b74:	74 16                	je     801b8c <spawn+0x348>
		va -= i;
  801b76:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  801b7c:	01 c2                	add    %eax,%edx
  801b7e:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  801b84:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  801b86:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801b8c:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801b93:	0f 84 36 01 00 00    	je     801ccf <spawn+0x48b>
  801b99:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  801ba3:	39 f7                	cmp    %esi,%edi
  801ba5:	72 31                	jb     801bd8 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801ba7:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801bad:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bb1:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801bb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bbb:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bc1:	89 04 24             	mov    %eax,(%esp)
  801bc4:	e8 53 f1 ff ff       	call   800d1c <sys_page_alloc>
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	0f 89 ea 00 00 00    	jns    801cbb <spawn+0x477>
  801bd1:	89 c6                	mov    %eax,%esi
  801bd3:	e9 27 02 00 00       	jmp    801dff <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bd8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bdf:	00 
  801be0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801be7:	00 
  801be8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bef:	e8 28 f1 ff ff       	call   800d1c <sys_page_alloc>
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	0f 88 f9 01 00 00    	js     801df5 <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801bfc:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  801c02:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 a3 f8 ff ff       	call   8014b9 <seek>
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 88 db 01 00 00    	js     801df9 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c1e:	89 f0                	mov    %esi,%eax
  801c20:	29 f8                	sub    %edi,%eax
  801c22:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c27:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c2c:	0f 47 c2             	cmova  %edx,%eax
  801c2f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c33:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c3a:	00 
  801c3b:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 95 f7 ff ff       	call   8013de <readn>
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	0f 88 ac 01 00 00    	js     801dfd <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c51:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801c57:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c5b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801c61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c65:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c76:	00 
  801c77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c7e:	e8 f8 f0 ff ff       	call   800d7b <sys_page_map>
  801c83:	85 c0                	test   %eax,%eax
  801c85:	79 20                	jns    801ca7 <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  801c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8b:	c7 44 24 08 11 2d 80 	movl   $0x802d11,0x8(%esp)
  801c92:	00 
  801c93:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801c9a:	00 
  801c9b:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  801ca2:	e8 59 e4 ff ff       	call   800100 <_panic>
			sys_page_unmap(0, UTEMP);
  801ca7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cae:	00 
  801caf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb6:	e8 1e f1 ff ff       	call   800dd9 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801cbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cc1:	89 df                	mov    %ebx,%edi
  801cc3:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801cc9:	0f 82 d4 fe ff ff    	jb     801ba3 <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ccf:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801cd6:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  801cdd:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ce4:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801cea:	0f 8f 35 fe ff ff    	jg     801b25 <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801cf0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cf6:	89 04 24             	mov    %eax,(%esp)
  801cf9:	e8 df f4 ff ff       	call   8011dd <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  801cfe:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	c1 e2 0c             	shl    $0xc,%edx
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	c1 e8 16             	shr    $0x16,%eax
  801d0d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  801d14:	f6 c1 01             	test   $0x1,%cl
  801d17:	74 5b                	je     801d74 <spawn+0x530>
  801d19:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d20:	a8 04                	test   $0x4,%al
  801d22:	74 50                	je     801d74 <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  801d24:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801d2b:	a8 01                	test   $0x1,%al
  801d2d:	74 45                	je     801d74 <spawn+0x530>
  801d2f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801d36:	a8 04                	test   $0x4,%al
  801d38:	74 3a                	je     801d74 <spawn+0x530>
  801d3a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801d41:	f6 c4 04             	test   $0x4,%ah
  801d44:	74 2e                	je     801d74 <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  801d46:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801d4d:	25 07 0e 00 00       	and    $0xe07,%eax
  801d52:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d56:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d5a:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d64:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6f:	e8 07 f0 ff ff       	call   800d7b <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  801d74:	83 c6 01             	add    $0x1,%esi
  801d77:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  801d7d:	75 84                	jne    801d03 <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d7f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d89:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	e8 fe f0 ff ff       	call   800e95 <sys_env_set_trapframe>
  801d97:	85 c0                	test   %eax,%eax
  801d99:	79 20                	jns    801dbb <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  801d9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d9f:	c7 44 24 08 2e 2d 80 	movl   $0x802d2e,0x8(%esp)
  801da6:	00 
  801da7:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801dae:	00 
  801daf:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  801db6:	e8 45 e3 ff ff       	call   800100 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dbb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801dc2:	00 
  801dc3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dc9:	89 04 24             	mov    %eax,(%esp)
  801dcc:	e8 66 f0 ff ff       	call   800e37 <sys_env_set_status>
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	79 5a                	jns    801e2f <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  801dd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd9:	c7 44 24 08 48 2d 80 	movl   $0x802d48,0x8(%esp)
  801de0:	00 
  801de1:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801de8:	00 
  801de9:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  801df0:	e8 0b e3 ff ff       	call   800100 <_panic>
  801df5:	89 c6                	mov    %eax,%esi
  801df7:	eb 06                	jmp    801dff <spawn+0x5bb>
  801df9:	89 c6                	mov    %eax,%esi
  801dfb:	eb 02                	jmp    801dff <spawn+0x5bb>
  801dfd:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  801dff:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e05:	89 04 24             	mov    %eax,(%esp)
  801e08:	e8 52 ee ff ff       	call   800c5f <sys_env_destroy>
	close(fd);
  801e0d:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e13:	89 04 24             	mov    %eax,(%esp)
  801e16:	e8 c2 f3 ff ff       	call   8011dd <close>
	return r;
  801e1b:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  801e21:	eb 0c                	jmp    801e2f <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801e23:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e29:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801e2f:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e35:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e40:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801e45:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801e4b:	eb e2                	jmp    801e2f <spawn+0x5eb>

00801e4d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	83 ec 10             	sub    $0x10,%esp
  801e55:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e58:	8d 45 14             	lea    0x14(%ebp),%eax
  801e5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e5f:	74 66                	je     801ec7 <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801e61:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801e66:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e69:	89 c2                	mov    %eax,%edx
  801e6b:	83 c0 04             	add    $0x4,%eax
  801e6e:	83 3a 00             	cmpl   $0x0,(%edx)
  801e71:	75 f3                	jne    801e66 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801e73:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  801e7a:	83 e0 f0             	and    $0xfffffff0,%eax
  801e7d:	29 c4                	sub    %eax,%esp
  801e7f:	8d 44 24 17          	lea    0x17(%esp),%eax
  801e83:	83 e0 f0             	and    $0xfffffff0,%eax
  801e86:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801e88:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  801e8a:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  801e91:	00 

	va_start(vl, arg0);
  801e92:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  801e95:	89 ce                	mov    %ecx,%esi
  801e97:	85 c9                	test   %ecx,%ecx
  801e99:	74 16                	je     801eb1 <spawnl+0x64>
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801ea0:	83 c0 01             	add    $0x1,%eax
  801ea3:	89 d1                	mov    %edx,%ecx
  801ea5:	83 c2 04             	add    $0x4,%edx
  801ea8:	8b 09                	mov    (%ecx),%ecx
  801eaa:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801ead:	39 f0                	cmp    %esi,%eax
  801eaf:	75 ef                	jne    801ea0 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801eb1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	89 04 24             	mov    %eax,(%esp)
  801ebb:	e8 84 f9 ff ff       	call   801844 <spawn>
}
  801ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec3:	5b                   	pop    %ebx
  801ec4:	5e                   	pop    %esi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801ec7:	83 ec 20             	sub    $0x20,%esp
  801eca:	8d 44 24 17          	lea    0x17(%esp),%eax
  801ece:	83 e0 f0             	and    $0xfffffff0,%eax
  801ed1:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801ed3:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  801ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801edc:	eb d3                	jmp    801eb1 <spawnl+0x64>
	...

00801ee0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
  801ee6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ee9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801eec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	89 04 24             	mov    %eax,(%esp)
  801ef5:	e8 06 f1 ff ff       	call   801000 <fd2data>
  801efa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801efc:	c7 44 24 04 88 2d 80 	movl   $0x802d88,0x4(%esp)
  801f03:	00 
  801f04:	89 34 24             	mov    %esi,(%esp)
  801f07:	e8 0f e9 ff ff       	call   80081b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f0c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f0f:	2b 03                	sub    (%ebx),%eax
  801f11:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801f17:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801f1e:	00 00 00 
	stat->st_dev = &devpipe;
  801f21:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801f28:	30 80 00 
	return 0;
}
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f33:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f36:	89 ec                	mov    %ebp,%esp
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 14             	sub    $0x14,%esp
  801f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4f:	e8 85 ee ff ff       	call   800dd9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f54:	89 1c 24             	mov    %ebx,(%esp)
  801f57:	e8 a4 f0 ff ff       	call   801000 <fd2data>
  801f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f67:	e8 6d ee ff ff       	call   800dd9 <sys_page_unmap>
}
  801f6c:	83 c4 14             	add    $0x14,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5d                   	pop    %ebp
  801f71:	c3                   	ret    

00801f72 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	57                   	push   %edi
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	83 ec 2c             	sub    $0x2c,%esp
  801f7b:	89 c7                	mov    %eax,%edi
  801f7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f80:	a1 04 40 80 00       	mov    0x804004,%eax
  801f85:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f88:	89 3c 24             	mov    %edi,(%esp)
  801f8b:	e8 00 06 00 00       	call   802590 <pageref>
  801f90:	89 c6                	mov    %eax,%esi
  801f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f95:	89 04 24             	mov    %eax,(%esp)
  801f98:	e8 f3 05 00 00       	call   802590 <pageref>
  801f9d:	39 c6                	cmp    %eax,%esi
  801f9f:	0f 94 c0             	sete   %al
  801fa2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801fa5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fae:	39 cb                	cmp    %ecx,%ebx
  801fb0:	75 08                	jne    801fba <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801fb2:	83 c4 2c             	add    $0x2c,%esp
  801fb5:	5b                   	pop    %ebx
  801fb6:	5e                   	pop    %esi
  801fb7:	5f                   	pop    %edi
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801fba:	83 f8 01             	cmp    $0x1,%eax
  801fbd:	75 c1                	jne    801f80 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fbf:	8b 52 58             	mov    0x58(%edx),%edx
  801fc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fce:	c7 04 24 8f 2d 80 00 	movl   $0x802d8f,(%esp)
  801fd5:	e8 21 e2 ff ff       	call   8001fb <cprintf>
  801fda:	eb a4                	jmp    801f80 <_pipeisclosed+0xe>

00801fdc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	83 ec 2c             	sub    $0x2c,%esp
  801fe5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fe8:	89 34 24             	mov    %esi,(%esp)
  801feb:	e8 10 f0 ff ff       	call   801000 <fd2data>
  801ff0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffb:	75 50                	jne    80204d <devpipe_write+0x71>
  801ffd:	eb 5c                	jmp    80205b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fff:	89 da                	mov    %ebx,%edx
  802001:	89 f0                	mov    %esi,%eax
  802003:	e8 6a ff ff ff       	call   801f72 <_pipeisclosed>
  802008:	85 c0                	test   %eax,%eax
  80200a:	75 53                	jne    80205f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80200c:	e8 db ec ff ff       	call   800cec <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802011:	8b 43 04             	mov    0x4(%ebx),%eax
  802014:	8b 13                	mov    (%ebx),%edx
  802016:	83 c2 20             	add    $0x20,%edx
  802019:	39 d0                	cmp    %edx,%eax
  80201b:	73 e2                	jae    801fff <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80201d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802020:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  802024:	88 55 e7             	mov    %dl,-0x19(%ebp)
  802027:	89 c2                	mov    %eax,%edx
  802029:	c1 fa 1f             	sar    $0x1f,%edx
  80202c:	c1 ea 1b             	shr    $0x1b,%edx
  80202f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802032:	83 e1 1f             	and    $0x1f,%ecx
  802035:	29 d1                	sub    %edx,%ecx
  802037:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80203b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80203f:	83 c0 01             	add    $0x1,%eax
  802042:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802045:	83 c7 01             	add    $0x1,%edi
  802048:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80204b:	74 0e                	je     80205b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80204d:	8b 43 04             	mov    0x4(%ebx),%eax
  802050:	8b 13                	mov    (%ebx),%edx
  802052:	83 c2 20             	add    $0x20,%edx
  802055:	39 d0                	cmp    %edx,%eax
  802057:	73 a6                	jae    801fff <devpipe_write+0x23>
  802059:	eb c2                	jmp    80201d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80205b:	89 f8                	mov    %edi,%eax
  80205d:	eb 05                	jmp    802064 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802064:	83 c4 2c             	add    $0x2c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 28             	sub    $0x28,%esp
  802072:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802075:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802078:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80207b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80207e:	89 3c 24             	mov    %edi,(%esp)
  802081:	e8 7a ef ff ff       	call   801000 <fd2data>
  802086:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802088:	be 00 00 00 00       	mov    $0x0,%esi
  80208d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802091:	75 47                	jne    8020da <devpipe_read+0x6e>
  802093:	eb 52                	jmp    8020e7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802095:	89 f0                	mov    %esi,%eax
  802097:	eb 5e                	jmp    8020f7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802099:	89 da                	mov    %ebx,%edx
  80209b:	89 f8                	mov    %edi,%eax
  80209d:	8d 76 00             	lea    0x0(%esi),%esi
  8020a0:	e8 cd fe ff ff       	call   801f72 <_pipeisclosed>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	75 49                	jne    8020f2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020a9:	e8 3e ec ff ff       	call   800cec <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020ae:	8b 03                	mov    (%ebx),%eax
  8020b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b3:	74 e4                	je     802099 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020b5:	89 c2                	mov    %eax,%edx
  8020b7:	c1 fa 1f             	sar    $0x1f,%edx
  8020ba:	c1 ea 1b             	shr    $0x1b,%edx
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	83 e0 1f             	and    $0x1f,%eax
  8020c2:	29 d0                	sub    %edx,%eax
  8020c4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8020cf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020d2:	83 c6 01             	add    $0x1,%esi
  8020d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020d8:	74 0d                	je     8020e7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8020da:	8b 03                	mov    (%ebx),%eax
  8020dc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020df:	75 d4                	jne    8020b5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020e1:	85 f6                	test   %esi,%esi
  8020e3:	75 b0                	jne    802095 <devpipe_read+0x29>
  8020e5:	eb b2                	jmp    802099 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020e7:	89 f0                	mov    %esi,%eax
  8020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	eb 05                	jmp    8020f7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020f7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020fa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020fd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802100:	89 ec                	mov    %ebp,%esp
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 48             	sub    $0x48,%esp
  80210a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80210d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802110:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802113:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802116:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802119:	89 04 24             	mov    %eax,(%esp)
  80211c:	e8 fa ee ff ff       	call   80101b <fd_alloc>
  802121:	89 c3                	mov    %eax,%ebx
  802123:	85 c0                	test   %eax,%eax
  802125:	0f 88 45 01 00 00    	js     802270 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80212b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802132:	00 
  802133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802141:	e8 d6 eb ff ff       	call   800d1c <sys_page_alloc>
  802146:	89 c3                	mov    %eax,%ebx
  802148:	85 c0                	test   %eax,%eax
  80214a:	0f 88 20 01 00 00    	js     802270 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802150:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802153:	89 04 24             	mov    %eax,(%esp)
  802156:	e8 c0 ee ff ff       	call   80101b <fd_alloc>
  80215b:	89 c3                	mov    %eax,%ebx
  80215d:	85 c0                	test   %eax,%eax
  80215f:	0f 88 f8 00 00 00    	js     80225d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802165:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80216c:	00 
  80216d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802170:	89 44 24 04          	mov    %eax,0x4(%esp)
  802174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217b:	e8 9c eb ff ff       	call   800d1c <sys_page_alloc>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 88 d3 00 00 00    	js     80225d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80218a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218d:	89 04 24             	mov    %eax,(%esp)
  802190:	e8 6b ee ff ff       	call   801000 <fd2data>
  802195:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802197:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80219e:	00 
  80219f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021aa:	e8 6d eb ff ff       	call   800d1c <sys_page_alloc>
  8021af:	89 c3                	mov    %eax,%ebx
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	0f 88 91 00 00 00    	js     80224a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bc:	89 04 24             	mov    %eax,(%esp)
  8021bf:	e8 3c ee ff ff       	call   801000 <fd2data>
  8021c4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021cb:	00 
  8021cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021d7:	00 
  8021d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e3:	e8 93 eb ff ff       	call   800d7b <sys_page_map>
  8021e8:	89 c3                	mov    %eax,%ebx
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 4c                	js     80223a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021ee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8021f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802203:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80220e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802211:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221b:	89 04 24             	mov    %eax,(%esp)
  80221e:	e8 cd ed ff ff       	call   800ff0 <fd2num>
  802223:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802228:	89 04 24             	mov    %eax,(%esp)
  80222b:	e8 c0 ed ff ff       	call   800ff0 <fd2num>
  802230:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802233:	bb 00 00 00 00       	mov    $0x0,%ebx
  802238:	eb 36                	jmp    802270 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80223a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80223e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802245:	e8 8f eb ff ff       	call   800dd9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80224a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 7c eb ff ff       	call   800dd9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80225d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802260:	89 44 24 04          	mov    %eax,0x4(%esp)
  802264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80226b:	e8 69 eb ff ff       	call   800dd9 <sys_page_unmap>
    err:
	return r;
}
  802270:	89 d8                	mov    %ebx,%eax
  802272:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802275:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802278:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80227b:	89 ec                	mov    %ebp,%esp
  80227d:	5d                   	pop    %ebp
  80227e:	c3                   	ret    

0080227f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802285:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	89 04 24             	mov    %eax,(%esp)
  802292:	e8 f7 ed ff ff       	call   80108e <fd_lookup>
  802297:	85 c0                	test   %eax,%eax
  802299:	78 15                	js     8022b0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 5a ed ff ff       	call   801000 <fd2data>
	return _pipeisclosed(fd, p);
  8022a6:	89 c2                	mov    %eax,%edx
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	e8 c2 fc ff ff       	call   801f72 <_pipeisclosed>
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    
	...

008022c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022d0:	c7 44 24 04 a7 2d 80 	movl   $0x802da7,0x4(%esp)
  8022d7:	00 
  8022d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 38 e5 ff ff       	call   80081b <strcpy>
	return 0;
}
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	57                   	push   %edi
  8022ee:	56                   	push   %esi
  8022ef:	53                   	push   %ebx
  8022f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022f6:	be 00 00 00 00       	mov    $0x0,%esi
  8022fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ff:	74 43                	je     802344 <devcons_write+0x5a>
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802306:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80230c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80230f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802311:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802314:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802319:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80231c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802320:	03 45 0c             	add    0xc(%ebp),%eax
  802323:	89 44 24 04          	mov    %eax,0x4(%esp)
  802327:	89 3c 24             	mov    %edi,(%esp)
  80232a:	e8 dd e6 ff ff       	call   800a0c <memmove>
		sys_cputs(buf, m);
  80232f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802333:	89 3c 24             	mov    %edi,(%esp)
  802336:	e8 c5 e8 ff ff       	call   800c00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80233b:	01 de                	add    %ebx,%esi
  80233d:	89 f0                	mov    %esi,%eax
  80233f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802342:	72 c8                	jb     80230c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802344:	89 f0                	mov    %esi,%eax
  802346:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    

00802351 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80235c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802360:	75 07                	jne    802369 <devcons_read+0x18>
  802362:	eb 31                	jmp    802395 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802364:	e8 83 e9 ff ff       	call   800cec <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802370:	e8 ba e8 ff ff       	call   800c2f <sys_cgetc>
  802375:	85 c0                	test   %eax,%eax
  802377:	74 eb                	je     802364 <devcons_read+0x13>
  802379:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80237b:	85 c0                	test   %eax,%eax
  80237d:	78 16                	js     802395 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80237f:	83 f8 04             	cmp    $0x4,%eax
  802382:	74 0c                	je     802390 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802384:	8b 45 0c             	mov    0xc(%ebp),%eax
  802387:	88 10                	mov    %dl,(%eax)
	return 1;
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
  80238e:	eb 05                	jmp    802395 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8023a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023aa:	00 
  8023ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ae:	89 04 24             	mov    %eax,(%esp)
  8023b1:	e8 4a e8 ff ff       	call   800c00 <sys_cputs>
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <getchar>:

int
getchar(void)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023c5:	00 
  8023c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d4:	e8 75 ef ff ff       	call   80134e <read>
	if (r < 0)
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	78 0f                	js     8023ec <getchar+0x34>
		return r;
	if (r < 1)
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	7e 06                	jle    8023e7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023e1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023e5:	eb 05                	jmp    8023ec <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023e7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	89 04 24             	mov    %eax,(%esp)
  802401:	e8 88 ec ff ff       	call   80108e <fd_lookup>
  802406:	85 c0                	test   %eax,%eax
  802408:	78 11                	js     80241b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802413:	39 10                	cmp    %edx,(%eax)
  802415:	0f 94 c0             	sete   %al
  802418:	0f b6 c0             	movzbl %al,%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <opencons>:

int
opencons(void)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802423:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802426:	89 04 24             	mov    %eax,(%esp)
  802429:	e8 ed eb ff ff       	call   80101b <fd_alloc>
  80242e:	85 c0                	test   %eax,%eax
  802430:	78 3c                	js     80246e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802432:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802439:	00 
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802441:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802448:	e8 cf e8 ff ff       	call   800d1c <sys_page_alloc>
  80244d:	85 c0                	test   %eax,%eax
  80244f:	78 1d                	js     80246e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802451:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802466:	89 04 24             	mov    %eax,(%esp)
  802469:	e8 82 eb ff ff       	call   800ff0 <fd2num>
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	56                   	push   %esi
  802474:	53                   	push   %ebx
  802475:	83 ec 10             	sub    $0x10,%esp
  802478:	8b 75 08             	mov    0x8(%ebp),%esi
  80247b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802481:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802483:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802488:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80248b:	89 04 24             	mov    %eax,(%esp)
  80248e:	e8 f2 ea ff ff       	call   800f85 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802493:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802498:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80249d:	85 c0                	test   %eax,%eax
  80249f:	78 0e                	js     8024af <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8024a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8024a6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8024a9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8024ac:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8024af:	85 f6                	test   %esi,%esi
  8024b1:	74 02                	je     8024b5 <ipc_recv+0x45>
		*from_env_store = sender;
  8024b3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8024b5:	85 db                	test   %ebx,%ebx
  8024b7:	74 02                	je     8024bb <ipc_recv+0x4b>
		*perm_store = perm;
  8024b9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	5b                   	pop    %ebx
  8024bf:	5e                   	pop    %esi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    

008024c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	57                   	push   %edi
  8024c6:	56                   	push   %esi
  8024c7:	53                   	push   %ebx
  8024c8:	83 ec 1c             	sub    $0x1c,%esp
  8024cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024d1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8024d4:	85 db                	test   %ebx,%ebx
  8024d6:	75 04                	jne    8024dc <ipc_send+0x1a>
  8024d8:	85 f6                	test   %esi,%esi
  8024da:	75 15                	jne    8024f1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8024dc:	85 db                	test   %ebx,%ebx
  8024de:	74 16                	je     8024f6 <ipc_send+0x34>
  8024e0:	85 f6                	test   %esi,%esi
  8024e2:	0f 94 c0             	sete   %al
      pg = 0;
  8024e5:	84 c0                	test   %al,%al
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	0f 45 d8             	cmovne %eax,%ebx
  8024ef:	eb 05                	jmp    8024f6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8024f1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8024f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8024fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	89 04 24             	mov    %eax,(%esp)
  802508:	e8 44 ea ff ff       	call   800f51 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80250d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802510:	75 07                	jne    802519 <ipc_send+0x57>
           sys_yield();
  802512:	e8 d5 e7 ff ff       	call   800cec <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802517:	eb dd                	jmp    8024f6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802519:	85 c0                	test   %eax,%eax
  80251b:	90                   	nop
  80251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802520:	74 1c                	je     80253e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802522:	c7 44 24 08 b3 2d 80 	movl   $0x802db3,0x8(%esp)
  802529:	00 
  80252a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802531:	00 
  802532:	c7 04 24 bd 2d 80 00 	movl   $0x802dbd,(%esp)
  802539:	e8 c2 db ff ff       	call   800100 <_panic>
		}
    }
}
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    

00802546 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80254c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802551:	39 c8                	cmp    %ecx,%eax
  802553:	74 17                	je     80256c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802555:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80255a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80255d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802563:	8b 52 50             	mov    0x50(%edx),%edx
  802566:	39 ca                	cmp    %ecx,%edx
  802568:	75 14                	jne    80257e <ipc_find_env+0x38>
  80256a:	eb 05                	jmp    802571 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802571:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802574:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802579:	8b 40 40             	mov    0x40(%eax),%eax
  80257c:	eb 0e                	jmp    80258c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80257e:	83 c0 01             	add    $0x1,%eax
  802581:	3d 00 04 00 00       	cmp    $0x400,%eax
  802586:	75 d2                	jne    80255a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802588:	66 b8 00 00          	mov    $0x0,%ax
}
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    
	...

00802590 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802596:	89 d0                	mov    %edx,%eax
  802598:	c1 e8 16             	shr    $0x16,%eax
  80259b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025a7:	f6 c1 01             	test   $0x1,%cl
  8025aa:	74 1d                	je     8025c9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025ac:	c1 ea 0c             	shr    $0xc,%edx
  8025af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025b6:	f6 c2 01             	test   $0x1,%dl
  8025b9:	74 0e                	je     8025c9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025bb:	c1 ea 0c             	shr    $0xc,%edx
  8025be:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025c5:	ef 
  8025c6:	0f b7 c0             	movzwl %ax,%eax
}
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    
  8025cb:	00 00                	add    %al,(%eax)
  8025cd:	00 00                	add    %al,(%eax)
	...

008025d0 <__udivdi3>:
  8025d0:	83 ec 1c             	sub    $0x1c,%esp
  8025d3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8025d7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8025db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8025df:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8025e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8025e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8025eb:	85 ff                	test   %edi,%edi
  8025ed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8025f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f5:	89 cd                	mov    %ecx,%ebp
  8025f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025fb:	75 33                	jne    802630 <__udivdi3+0x60>
  8025fd:	39 f1                	cmp    %esi,%ecx
  8025ff:	77 57                	ja     802658 <__udivdi3+0x88>
  802601:	85 c9                	test   %ecx,%ecx
  802603:	75 0b                	jne    802610 <__udivdi3+0x40>
  802605:	b8 01 00 00 00       	mov    $0x1,%eax
  80260a:	31 d2                	xor    %edx,%edx
  80260c:	f7 f1                	div    %ecx
  80260e:	89 c1                	mov    %eax,%ecx
  802610:	89 f0                	mov    %esi,%eax
  802612:	31 d2                	xor    %edx,%edx
  802614:	f7 f1                	div    %ecx
  802616:	89 c6                	mov    %eax,%esi
  802618:	8b 44 24 04          	mov    0x4(%esp),%eax
  80261c:	f7 f1                	div    %ecx
  80261e:	89 f2                	mov    %esi,%edx
  802620:	8b 74 24 10          	mov    0x10(%esp),%esi
  802624:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802628:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80262c:	83 c4 1c             	add    $0x1c,%esp
  80262f:	c3                   	ret    
  802630:	31 d2                	xor    %edx,%edx
  802632:	31 c0                	xor    %eax,%eax
  802634:	39 f7                	cmp    %esi,%edi
  802636:	77 e8                	ja     802620 <__udivdi3+0x50>
  802638:	0f bd cf             	bsr    %edi,%ecx
  80263b:	83 f1 1f             	xor    $0x1f,%ecx
  80263e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802642:	75 2c                	jne    802670 <__udivdi3+0xa0>
  802644:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802648:	76 04                	jbe    80264e <__udivdi3+0x7e>
  80264a:	39 f7                	cmp    %esi,%edi
  80264c:	73 d2                	jae    802620 <__udivdi3+0x50>
  80264e:	31 d2                	xor    %edx,%edx
  802650:	b8 01 00 00 00       	mov    $0x1,%eax
  802655:	eb c9                	jmp    802620 <__udivdi3+0x50>
  802657:	90                   	nop
  802658:	89 f2                	mov    %esi,%edx
  80265a:	f7 f1                	div    %ecx
  80265c:	31 d2                	xor    %edx,%edx
  80265e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802662:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802666:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80266a:	83 c4 1c             	add    $0x1c,%esp
  80266d:	c3                   	ret    
  80266e:	66 90                	xchg   %ax,%ax
  802670:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802675:	b8 20 00 00 00       	mov    $0x20,%eax
  80267a:	89 ea                	mov    %ebp,%edx
  80267c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802680:	d3 e7                	shl    %cl,%edi
  802682:	89 c1                	mov    %eax,%ecx
  802684:	d3 ea                	shr    %cl,%edx
  802686:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80268b:	09 fa                	or     %edi,%edx
  80268d:	89 f7                	mov    %esi,%edi
  80268f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802693:	89 f2                	mov    %esi,%edx
  802695:	8b 74 24 08          	mov    0x8(%esp),%esi
  802699:	d3 e5                	shl    %cl,%ebp
  80269b:	89 c1                	mov    %eax,%ecx
  80269d:	d3 ef                	shr    %cl,%edi
  80269f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026a4:	d3 e2                	shl    %cl,%edx
  8026a6:	89 c1                	mov    %eax,%ecx
  8026a8:	d3 ee                	shr    %cl,%esi
  8026aa:	09 d6                	or     %edx,%esi
  8026ac:	89 fa                	mov    %edi,%edx
  8026ae:	89 f0                	mov    %esi,%eax
  8026b0:	f7 74 24 0c          	divl   0xc(%esp)
  8026b4:	89 d7                	mov    %edx,%edi
  8026b6:	89 c6                	mov    %eax,%esi
  8026b8:	f7 e5                	mul    %ebp
  8026ba:	39 d7                	cmp    %edx,%edi
  8026bc:	72 22                	jb     8026e0 <__udivdi3+0x110>
  8026be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8026c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026c7:	d3 e5                	shl    %cl,%ebp
  8026c9:	39 c5                	cmp    %eax,%ebp
  8026cb:	73 04                	jae    8026d1 <__udivdi3+0x101>
  8026cd:	39 d7                	cmp    %edx,%edi
  8026cf:	74 0f                	je     8026e0 <__udivdi3+0x110>
  8026d1:	89 f0                	mov    %esi,%eax
  8026d3:	31 d2                	xor    %edx,%edx
  8026d5:	e9 46 ff ff ff       	jmp    802620 <__udivdi3+0x50>
  8026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8026e3:	31 d2                	xor    %edx,%edx
  8026e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026f1:	83 c4 1c             	add    $0x1c,%esp
  8026f4:	c3                   	ret    
	...

00802700 <__umoddi3>:
  802700:	83 ec 1c             	sub    $0x1c,%esp
  802703:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802707:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80270b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80270f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802713:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802717:	8b 74 24 24          	mov    0x24(%esp),%esi
  80271b:	85 ed                	test   %ebp,%ebp
  80271d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802721:	89 44 24 08          	mov    %eax,0x8(%esp)
  802725:	89 cf                	mov    %ecx,%edi
  802727:	89 04 24             	mov    %eax,(%esp)
  80272a:	89 f2                	mov    %esi,%edx
  80272c:	75 1a                	jne    802748 <__umoddi3+0x48>
  80272e:	39 f1                	cmp    %esi,%ecx
  802730:	76 4e                	jbe    802780 <__umoddi3+0x80>
  802732:	f7 f1                	div    %ecx
  802734:	89 d0                	mov    %edx,%eax
  802736:	31 d2                	xor    %edx,%edx
  802738:	8b 74 24 10          	mov    0x10(%esp),%esi
  80273c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802740:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802744:	83 c4 1c             	add    $0x1c,%esp
  802747:	c3                   	ret    
  802748:	39 f5                	cmp    %esi,%ebp
  80274a:	77 54                	ja     8027a0 <__umoddi3+0xa0>
  80274c:	0f bd c5             	bsr    %ebp,%eax
  80274f:	83 f0 1f             	xor    $0x1f,%eax
  802752:	89 44 24 04          	mov    %eax,0x4(%esp)
  802756:	75 60                	jne    8027b8 <__umoddi3+0xb8>
  802758:	3b 0c 24             	cmp    (%esp),%ecx
  80275b:	0f 87 07 01 00 00    	ja     802868 <__umoddi3+0x168>
  802761:	89 f2                	mov    %esi,%edx
  802763:	8b 34 24             	mov    (%esp),%esi
  802766:	29 ce                	sub    %ecx,%esi
  802768:	19 ea                	sbb    %ebp,%edx
  80276a:	89 34 24             	mov    %esi,(%esp)
  80276d:	8b 04 24             	mov    (%esp),%eax
  802770:	8b 74 24 10          	mov    0x10(%esp),%esi
  802774:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802778:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80277c:	83 c4 1c             	add    $0x1c,%esp
  80277f:	c3                   	ret    
  802780:	85 c9                	test   %ecx,%ecx
  802782:	75 0b                	jne    80278f <__umoddi3+0x8f>
  802784:	b8 01 00 00 00       	mov    $0x1,%eax
  802789:	31 d2                	xor    %edx,%edx
  80278b:	f7 f1                	div    %ecx
  80278d:	89 c1                	mov    %eax,%ecx
  80278f:	89 f0                	mov    %esi,%eax
  802791:	31 d2                	xor    %edx,%edx
  802793:	f7 f1                	div    %ecx
  802795:	8b 04 24             	mov    (%esp),%eax
  802798:	f7 f1                	div    %ecx
  80279a:	eb 98                	jmp    802734 <__umoddi3+0x34>
  80279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a0:	89 f2                	mov    %esi,%edx
  8027a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	c3                   	ret    
  8027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027bd:	89 e8                	mov    %ebp,%eax
  8027bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	d3 e0                	shl    %cl,%eax
  8027cc:	89 e9                	mov    %ebp,%ecx
  8027ce:	d3 ea                	shr    %cl,%edx
  8027d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027d5:	09 c2                	or     %eax,%edx
  8027d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027db:	89 14 24             	mov    %edx,(%esp)
  8027de:	89 f2                	mov    %esi,%edx
  8027e0:	d3 e7                	shl    %cl,%edi
  8027e2:	89 e9                	mov    %ebp,%ecx
  8027e4:	d3 ea                	shr    %cl,%edx
  8027e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ef:	d3 e6                	shl    %cl,%esi
  8027f1:	89 e9                	mov    %ebp,%ecx
  8027f3:	d3 e8                	shr    %cl,%eax
  8027f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027fa:	09 f0                	or     %esi,%eax
  8027fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802800:	f7 34 24             	divl   (%esp)
  802803:	d3 e6                	shl    %cl,%esi
  802805:	89 74 24 08          	mov    %esi,0x8(%esp)
  802809:	89 d6                	mov    %edx,%esi
  80280b:	f7 e7                	mul    %edi
  80280d:	39 d6                	cmp    %edx,%esi
  80280f:	89 c1                	mov    %eax,%ecx
  802811:	89 d7                	mov    %edx,%edi
  802813:	72 3f                	jb     802854 <__umoddi3+0x154>
  802815:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802819:	72 35                	jb     802850 <__umoddi3+0x150>
  80281b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80281f:	29 c8                	sub    %ecx,%eax
  802821:	19 fe                	sbb    %edi,%esi
  802823:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802828:	89 f2                	mov    %esi,%edx
  80282a:	d3 e8                	shr    %cl,%eax
  80282c:	89 e9                	mov    %ebp,%ecx
  80282e:	d3 e2                	shl    %cl,%edx
  802830:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802835:	09 d0                	or     %edx,%eax
  802837:	89 f2                	mov    %esi,%edx
  802839:	d3 ea                	shr    %cl,%edx
  80283b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80283f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802843:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802847:	83 c4 1c             	add    $0x1c,%esp
  80284a:	c3                   	ret    
  80284b:	90                   	nop
  80284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802850:	39 d6                	cmp    %edx,%esi
  802852:	75 c7                	jne    80281b <__umoddi3+0x11b>
  802854:	89 d7                	mov    %edx,%edi
  802856:	89 c1                	mov    %eax,%ecx
  802858:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80285c:	1b 3c 24             	sbb    (%esp),%edi
  80285f:	eb ba                	jmp    80281b <__umoddi3+0x11b>
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	39 f5                	cmp    %esi,%ebp
  80286a:	0f 82 f1 fe ff ff    	jb     802761 <__umoddi3+0x61>
  802870:	e9 f8 fe ff ff       	jmp    80276d <__umoddi3+0x6d>
