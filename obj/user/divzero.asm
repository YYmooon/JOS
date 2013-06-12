
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 37 00 00 00       	call   800068 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	zero = 0;
  80003a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800041:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800044:	b8 01 00 00 00       	mov    $0x1,%eax
  800049:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004e:	89 c2                	mov    %eax,%edx
  800050:	c1 fa 1f             	sar    $0x1f,%edx
  800053:	f7 f9                	idiv   %ecx
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 e0 21 80 00 	movl   $0x8021e0,(%esp)
  800060:	e8 12 01 00 00       	call   800177 <cprintf>
}
  800065:	c9                   	leave  
  800066:	c3                   	ret    
	...

00800068 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	83 ec 18             	sub    $0x18,%esp
  80006e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800071:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800074:	8b 75 08             	mov    0x8(%ebp),%esi
  800077:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80007a:	e8 bd 0b 00 00       	call   800c3c <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 08 40 80 00       	mov    %eax,0x804008
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 f6                	test   %esi,%esi
  800093:	7e 07                	jle    80009c <libmain+0x34>
		binaryname = argv[0];
  800095:	8b 03                	mov    (%ebx),%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a0:	89 34 24             	mov    %esi,(%esp)
  8000a3:	e8 8c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000a8:	e8 0b 00 00 00       	call   8000b8 <exit>
}
  8000ad:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000b0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000b3:	89 ec                	mov    %ebp,%esp
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    
	...

008000b8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000be:	e8 cb 10 00 00       	call   80118e <close_all>
	sys_env_destroy(0);
  8000c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ca:	e8 10 0b 00 00       	call   800bdf <sys_env_destroy>
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    
  8000d1:	00 00                	add    %al,(%eax)
	...

008000d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 14             	sub    $0x14,%esp
  8000db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000de:	8b 03                	mov    (%ebx),%eax
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8000e7:	83 c0 01             	add    $0x1,%eax
  8000ea:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8000ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f1:	75 19                	jne    80010c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000f3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000fa:	00 
  8000fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fe:	89 04 24             	mov    %eax,(%esp)
  800101:	e8 7a 0a 00 00       	call   800b80 <sys_cputs>
		b->idx = 0;
  800106:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80010c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80011f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800126:	00 00 00 
	b.cnt = 0;
  800129:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800130:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800133:	8b 45 0c             	mov    0xc(%ebp),%eax
  800136:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013a:	8b 45 08             	mov    0x8(%ebp),%eax
  80013d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800141:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014b:	c7 04 24 d4 00 80 00 	movl   $0x8000d4,(%esp)
  800152:	e8 a3 01 00 00       	call   8002fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800157:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800167:	89 04 24             	mov    %eax,(%esp)
  80016a:	e8 11 0a 00 00       	call   800b80 <sys_cputs>

	return b.cnt;
}
  80016f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800180:	89 44 24 04          	mov    %eax,0x4(%esp)
  800184:	8b 45 08             	mov    0x8(%ebp),%eax
  800187:	89 04 24             	mov    %eax,(%esp)
  80018a:	e8 87 ff ff ff       	call   800116 <vcprintf>
	va_end(ap);

	return cnt;
}
  80018f:	c9                   	leave  
  800190:	c3                   	ret    
	...

008001a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	57                   	push   %edi
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
  8001a6:	83 ec 3c             	sub    $0x3c,%esp
  8001a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001ac:	89 d7                	mov    %edx,%edi
  8001ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001c8:	72 11                	jb     8001db <printnum+0x3b>
  8001ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d0:	76 09                	jbe    8001db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001d2:	83 eb 01             	sub    $0x1,%ebx
  8001d5:	85 db                	test   %ebx,%ebx
  8001d7:	7f 51                	jg     80022a <printnum+0x8a>
  8001d9:	eb 5e                	jmp    800239 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8001f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8001f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fc:	00 
  8001fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800200:	89 04 24             	mov    %eax,(%esp)
  800203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020a:	e8 11 1d 00 00       	call   801f20 <__udivdi3>
  80020f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800213:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800217:	89 04 24             	mov    %eax,(%esp)
  80021a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80021e:	89 fa                	mov    %edi,%edx
  800220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800223:	e8 78 ff ff ff       	call   8001a0 <printnum>
  800228:	eb 0f                	jmp    800239 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80022a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80022e:	89 34 24             	mov    %esi,(%esp)
  800231:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	75 f1                	jne    80022a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800239:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80023d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800241:	8b 45 10             	mov    0x10(%ebp),%eax
  800244:	89 44 24 08          	mov    %eax,0x8(%esp)
  800248:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80024f:	00 
  800250:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025d:	e8 ee 1d 00 00       	call   802050 <__umoddi3>
  800262:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800266:	0f be 80 f8 21 80 00 	movsbl 0x8021f8(%eax),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800273:	83 c4 3c             	add    $0x3c,%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5f                   	pop    %edi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80027e:	83 fa 01             	cmp    $0x1,%edx
  800281:	7e 0e                	jle    800291 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800283:	8b 10                	mov    (%eax),%edx
  800285:	8d 4a 08             	lea    0x8(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 02                	mov    (%edx),%eax
  80028c:	8b 52 04             	mov    0x4(%edx),%edx
  80028f:	eb 22                	jmp    8002b3 <getuint+0x38>
	else if (lflag)
  800291:	85 d2                	test   %edx,%edx
  800293:	74 10                	je     8002a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800295:	8b 10                	mov    (%eax),%edx
  800297:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 02                	mov    (%edx),%eax
  80029e:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a3:	eb 0e                	jmp    8002b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a5:	8b 10                	mov    (%eax),%edx
  8002a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002aa:	89 08                	mov    %ecx,(%eax)
  8002ac:	8b 02                	mov    (%edx),%eax
  8002ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bf:	8b 10                	mov    (%eax),%edx
  8002c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c4:	73 0a                	jae    8002d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c9:	88 0a                	mov    %cl,(%edx)
  8002cb:	83 c2 01             	add    $0x1,%edx
  8002ce:	89 10                	mov    %edx,(%eax)
}
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002df:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f0:	89 04 24             	mov    %eax,(%esp)
  8002f3:	e8 02 00 00 00       	call   8002fa <vprintfmt>
	va_end(ap);
}
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 4c             	sub    $0x4c,%esp
  800303:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800306:	8b 75 10             	mov    0x10(%ebp),%esi
  800309:	eb 12                	jmp    80031d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80030b:	85 c0                	test   %eax,%eax
  80030d:	0f 84 a9 03 00 00    	je     8006bc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800313:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800317:	89 04 24             	mov    %eax,(%esp)
  80031a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80031d:	0f b6 06             	movzbl (%esi),%eax
  800320:	83 c6 01             	add    $0x1,%esi
  800323:	83 f8 25             	cmp    $0x25,%eax
  800326:	75 e3                	jne    80030b <vprintfmt+0x11>
  800328:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80032c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800333:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800338:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80033f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800344:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800347:	eb 2b                	jmp    800374 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80034c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800350:	eb 22                	jmp    800374 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800355:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800359:	eb 19                	jmp    800374 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80035e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800365:	eb 0d                	jmp    800374 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800374:	0f b6 06             	movzbl (%esi),%eax
  800377:	0f b6 d0             	movzbl %al,%edx
  80037a:	8d 7e 01             	lea    0x1(%esi),%edi
  80037d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800380:	83 e8 23             	sub    $0x23,%eax
  800383:	3c 55                	cmp    $0x55,%al
  800385:	0f 87 0b 03 00 00    	ja     800696 <vprintfmt+0x39c>
  80038b:	0f b6 c0             	movzbl %al,%eax
  80038e:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800395:	83 ea 30             	sub    $0x30,%edx
  800398:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80039b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80039f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8003a5:	83 fa 09             	cmp    $0x9,%edx
  8003a8:	77 4a                	ja     8003f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003b0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8003b3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8003b7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003ba:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003bd:	83 fa 09             	cmp    $0x9,%edx
  8003c0:	76 eb                	jbe    8003ad <vprintfmt+0xb3>
  8003c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003c5:	eb 2d                	jmp    8003f4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	8d 50 04             	lea    0x4(%eax),%edx
  8003cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003d8:	eb 1a                	jmp    8003f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8003dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003e1:	79 91                	jns    800374 <vprintfmt+0x7a>
  8003e3:	e9 73 ff ff ff       	jmp    80035b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8003f2:	eb 80                	jmp    800374 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8003f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003f8:	0f 89 76 ff ff ff    	jns    800374 <vprintfmt+0x7a>
  8003fe:	e9 64 ff ff ff       	jmp    800367 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800403:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800409:	e9 66 ff ff ff       	jmp    800374 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8d 50 04             	lea    0x4(%eax),%edx
  800414:	89 55 14             	mov    %edx,0x14(%ebp)
  800417:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	89 04 24             	mov    %eax,(%esp)
  800420:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800426:	e9 f2 fe ff ff       	jmp    80031d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 50 04             	lea    0x4(%eax),%edx
  800431:	89 55 14             	mov    %edx,0x14(%ebp)
  800434:	8b 00                	mov    (%eax),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	c1 fa 1f             	sar    $0x1f,%edx
  80043b:	31 d0                	xor    %edx,%eax
  80043d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043f:	83 f8 0f             	cmp    $0xf,%eax
  800442:	7f 0b                	jg     80044f <vprintfmt+0x155>
  800444:	8b 14 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%edx
  80044b:	85 d2                	test   %edx,%edx
  80044d:	75 23                	jne    800472 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80044f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800453:	c7 44 24 08 10 22 80 	movl   $0x802210,0x8(%esp)
  80045a:	00 
  80045b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80045f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800462:	89 3c 24             	mov    %edi,(%esp)
  800465:	e8 68 fe ff ff       	call   8002d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80046d:	e9 ab fe ff ff       	jmp    80031d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800472:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800476:	c7 44 24 08 d1 25 80 	movl   $0x8025d1,0x8(%esp)
  80047d:	00 
  80047e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800482:	8b 7d 08             	mov    0x8(%ebp),%edi
  800485:	89 3c 24             	mov    %edi,(%esp)
  800488:	e8 45 fe ff ff       	call   8002d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800490:	e9 88 fe ff ff       	jmp    80031d <vprintfmt+0x23>
  800495:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 50 04             	lea    0x4(%eax),%edx
  8004a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004a9:	85 f6                	test   %esi,%esi
  8004ab:	ba 09 22 80 00       	mov    $0x802209,%edx
  8004b0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8004b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b7:	7e 06                	jle    8004bf <vprintfmt+0x1c5>
  8004b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004bd:	75 10                	jne    8004cf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004bf:	0f be 06             	movsbl (%esi),%eax
  8004c2:	83 c6 01             	add    $0x1,%esi
  8004c5:	85 c0                	test   %eax,%eax
  8004c7:	0f 85 86 00 00 00    	jne    800553 <vprintfmt+0x259>
  8004cd:	eb 76                	jmp    800545 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d3:	89 34 24             	mov    %esi,(%esp)
  8004d6:	e8 90 02 00 00       	call   80076b <strnlen>
  8004db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004de:	29 c2                	sub    %eax,%edx
  8004e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004e3:	85 d2                	test   %edx,%edx
  8004e5:	7e d8                	jle    8004bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004e7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8004ee:	89 d6                	mov    %edx,%esi
  8004f0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8004f3:	89 c7                	mov    %eax,%edi
  8004f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004f9:	89 3c 24             	mov    %edi,(%esp)
  8004fc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ff:	83 ee 01             	sub    $0x1,%esi
  800502:	75 f1                	jne    8004f5 <vprintfmt+0x1fb>
  800504:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800507:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80050a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80050d:	eb b0                	jmp    8004bf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800513:	74 18                	je     80052d <vprintfmt+0x233>
  800515:	8d 50 e0             	lea    -0x20(%eax),%edx
  800518:	83 fa 5e             	cmp    $0x5e,%edx
  80051b:	76 10                	jbe    80052d <vprintfmt+0x233>
					putch('?', putdat);
  80051d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800521:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800528:	ff 55 08             	call   *0x8(%ebp)
  80052b:	eb 0a                	jmp    800537 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80052d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800531:	89 04 24             	mov    %eax,(%esp)
  800534:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800537:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80053b:	0f be 06             	movsbl (%esi),%eax
  80053e:	83 c6 01             	add    $0x1,%esi
  800541:	85 c0                	test   %eax,%eax
  800543:	75 0e                	jne    800553 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800548:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054c:	7f 16                	jg     800564 <vprintfmt+0x26a>
  80054e:	e9 ca fd ff ff       	jmp    80031d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800553:	85 ff                	test   %edi,%edi
  800555:	78 b8                	js     80050f <vprintfmt+0x215>
  800557:	83 ef 01             	sub    $0x1,%edi
  80055a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800560:	79 ad                	jns    80050f <vprintfmt+0x215>
  800562:	eb e1                	jmp    800545 <vprintfmt+0x24b>
  800564:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800567:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80056a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80056e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800575:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800577:	83 ee 01             	sub    $0x1,%esi
  80057a:	75 ee                	jne    80056a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80057f:	e9 99 fd ff ff       	jmp    80031d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7e 10                	jle    800599 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8d 50 08             	lea    0x8(%eax),%edx
  80058f:	89 55 14             	mov    %edx,0x14(%ebp)
  800592:	8b 30                	mov    (%eax),%esi
  800594:	8b 78 04             	mov    0x4(%eax),%edi
  800597:	eb 26                	jmp    8005bf <vprintfmt+0x2c5>
	else if (lflag)
  800599:	85 c9                	test   %ecx,%ecx
  80059b:	74 12                	je     8005af <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 50 04             	lea    0x4(%eax),%edx
  8005a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a6:	8b 30                	mov    (%eax),%esi
  8005a8:	89 f7                	mov    %esi,%edi
  8005aa:	c1 ff 1f             	sar    $0x1f,%edi
  8005ad:	eb 10                	jmp    8005bf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 30                	mov    (%eax),%esi
  8005ba:	89 f7                	mov    %esi,%edi
  8005bc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005c4:	85 ff                	test   %edi,%edi
  8005c6:	0f 89 8c 00 00 00    	jns    800658 <vprintfmt+0x35e>
				putch('-', putdat);
  8005cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005d7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005da:	f7 de                	neg    %esi
  8005dc:	83 d7 00             	adc    $0x0,%edi
  8005df:	f7 df                	neg    %edi
			}
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	eb 70                	jmp    800658 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005e8:	89 ca                	mov    %ecx,%edx
  8005ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ed:	e8 89 fc ff ff       	call   80027b <getuint>
  8005f2:	89 c6                	mov    %eax,%esi
  8005f4:	89 d7                	mov    %edx,%edi
			base = 10;
  8005f6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8005fb:	eb 5b                	jmp    800658 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005fd:	89 ca                	mov    %ecx,%edx
  8005ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800602:	e8 74 fc ff ff       	call   80027b <getuint>
  800607:	89 c6                	mov    %eax,%esi
  800609:	89 d7                	mov    %edx,%edi
			base = 8;
  80060b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800610:	eb 46                	jmp    800658 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800612:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800616:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80061d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800620:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800624:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80062b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 50 04             	lea    0x4(%eax),%edx
  800634:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800637:	8b 30                	mov    (%eax),%esi
  800639:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80063e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800643:	eb 13                	jmp    800658 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800645:	89 ca                	mov    %ecx,%edx
  800647:	8d 45 14             	lea    0x14(%ebp),%eax
  80064a:	e8 2c fc ff ff       	call   80027b <getuint>
  80064f:	89 c6                	mov    %eax,%esi
  800651:	89 d7                	mov    %edx,%edi
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800658:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80065c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800663:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800667:	89 44 24 08          	mov    %eax,0x8(%esp)
  80066b:	89 34 24             	mov    %esi,(%esp)
  80066e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800672:	89 da                	mov    %ebx,%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	e8 24 fb ff ff       	call   8001a0 <printnum>
			break;
  80067c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80067f:	e9 99 fc ff ff       	jmp    80031d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800684:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800688:	89 14 24             	mov    %edx,(%esp)
  80068b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800691:	e9 87 fc ff ff       	jmp    80031d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800696:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80069a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006a8:	0f 84 6f fc ff ff    	je     80031d <vprintfmt+0x23>
  8006ae:	83 ee 01             	sub    $0x1,%esi
  8006b1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006b5:	75 f7                	jne    8006ae <vprintfmt+0x3b4>
  8006b7:	e9 61 fc ff ff       	jmp    80031d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8006bc:	83 c4 4c             	add    $0x4c,%esp
  8006bf:	5b                   	pop    %ebx
  8006c0:	5e                   	pop    %esi
  8006c1:	5f                   	pop    %edi
  8006c2:	5d                   	pop    %ebp
  8006c3:	c3                   	ret    

008006c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 28             	sub    $0x28,%esp
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	74 30                	je     800715 <vsnprintf+0x51>
  8006e5:	85 d2                	test   %edx,%edx
  8006e7:	7e 2c                	jle    800715 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fe:	c7 04 24 b5 02 80 00 	movl   $0x8002b5,(%esp)
  800705:	e8 f0 fb ff ff       	call   8002fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800713:	eb 05                	jmp    80071a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800715:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800722:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800725:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800729:	8b 45 10             	mov    0x10(%ebp),%eax
  80072c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	89 44 24 04          	mov    %eax,0x4(%esp)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 04 24             	mov    %eax,(%esp)
  80073d:	e8 82 ff ff ff       	call   8006c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800742:	c9                   	leave  
  800743:	c3                   	ret    
	...

00800750 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	80 3a 00             	cmpb   $0x0,(%edx)
  80075e:	74 09                	je     800769 <strlen+0x19>
		n++;
  800760:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800767:	75 f7                	jne    800760 <strlen+0x10>
		n++;
	return n;
}
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	53                   	push   %ebx
  80076f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800772:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800775:	b8 00 00 00 00       	mov    $0x0,%eax
  80077a:	85 c9                	test   %ecx,%ecx
  80077c:	74 1a                	je     800798 <strnlen+0x2d>
  80077e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800781:	74 15                	je     800798 <strnlen+0x2d>
  800783:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800788:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078a:	39 ca                	cmp    %ecx,%edx
  80078c:	74 0a                	je     800798 <strnlen+0x2d>
  80078e:	83 c2 01             	add    $0x1,%edx
  800791:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800796:	75 f0                	jne    800788 <strnlen+0x1d>
		n++;
	return n;
}
  800798:	5b                   	pop    %ebx
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007aa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007b1:	83 c2 01             	add    $0x1,%edx
  8007b4:	84 c9                	test   %cl,%cl
  8007b6:	75 f2                	jne    8007aa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007b8:	5b                   	pop    %ebx
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c5:	89 1c 24             	mov    %ebx,(%esp)
  8007c8:	e8 83 ff ff ff       	call   800750 <strlen>
	strcpy(dst + len, src);
  8007cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d4:	01 d8                	add    %ebx,%eax
  8007d6:	89 04 24             	mov    %eax,(%esp)
  8007d9:	e8 bd ff ff ff       	call   80079b <strcpy>
	return dst;
}
  8007de:	89 d8                	mov    %ebx,%eax
  8007e0:	83 c4 08             	add    $0x8,%esp
  8007e3:	5b                   	pop    %ebx
  8007e4:	5d                   	pop    %ebp
  8007e5:	c3                   	ret    

008007e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	56                   	push   %esi
  8007ea:	53                   	push   %ebx
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f4:	85 f6                	test   %esi,%esi
  8007f6:	74 18                	je     800810 <strncpy+0x2a>
  8007f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8007fd:	0f b6 1a             	movzbl (%edx),%ebx
  800800:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800803:	80 3a 01             	cmpb   $0x1,(%edx)
  800806:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800809:	83 c1 01             	add    $0x1,%ecx
  80080c:	39 f1                	cmp    %esi,%ecx
  80080e:	75 ed                	jne    8007fd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	57                   	push   %edi
  800818:	56                   	push   %esi
  800819:	53                   	push   %ebx
  80081a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80081d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800820:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	89 f8                	mov    %edi,%eax
  800825:	85 f6                	test   %esi,%esi
  800827:	74 2b                	je     800854 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800829:	83 fe 01             	cmp    $0x1,%esi
  80082c:	74 23                	je     800851 <strlcpy+0x3d>
  80082e:	0f b6 0b             	movzbl (%ebx),%ecx
  800831:	84 c9                	test   %cl,%cl
  800833:	74 1c                	je     800851 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800835:	83 ee 02             	sub    $0x2,%esi
  800838:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80083d:	88 08                	mov    %cl,(%eax)
  80083f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800842:	39 f2                	cmp    %esi,%edx
  800844:	74 0b                	je     800851 <strlcpy+0x3d>
  800846:	83 c2 01             	add    $0x1,%edx
  800849:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80084d:	84 c9                	test   %cl,%cl
  80084f:	75 ec                	jne    80083d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800851:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800854:	29 f8                	sub    %edi,%eax
}
  800856:	5b                   	pop    %ebx
  800857:	5e                   	pop    %esi
  800858:	5f                   	pop    %edi
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800864:	0f b6 01             	movzbl (%ecx),%eax
  800867:	84 c0                	test   %al,%al
  800869:	74 16                	je     800881 <strcmp+0x26>
  80086b:	3a 02                	cmp    (%edx),%al
  80086d:	75 12                	jne    800881 <strcmp+0x26>
		p++, q++;
  80086f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800872:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800876:	84 c0                	test   %al,%al
  800878:	74 07                	je     800881 <strcmp+0x26>
  80087a:	83 c1 01             	add    $0x1,%ecx
  80087d:	3a 02                	cmp    (%edx),%al
  80087f:	74 ee                	je     80086f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800881:	0f b6 c0             	movzbl %al,%eax
  800884:	0f b6 12             	movzbl (%edx),%edx
  800887:	29 d0                	sub    %edx,%eax
}
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800895:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80089d:	85 d2                	test   %edx,%edx
  80089f:	74 28                	je     8008c9 <strncmp+0x3e>
  8008a1:	0f b6 01             	movzbl (%ecx),%eax
  8008a4:	84 c0                	test   %al,%al
  8008a6:	74 24                	je     8008cc <strncmp+0x41>
  8008a8:	3a 03                	cmp    (%ebx),%al
  8008aa:	75 20                	jne    8008cc <strncmp+0x41>
  8008ac:	83 ea 01             	sub    $0x1,%edx
  8008af:	74 13                	je     8008c4 <strncmp+0x39>
		n--, p++, q++;
  8008b1:	83 c1 01             	add    $0x1,%ecx
  8008b4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b7:	0f b6 01             	movzbl (%ecx),%eax
  8008ba:	84 c0                	test   %al,%al
  8008bc:	74 0e                	je     8008cc <strncmp+0x41>
  8008be:	3a 03                	cmp    (%ebx),%al
  8008c0:	74 ea                	je     8008ac <strncmp+0x21>
  8008c2:	eb 08                	jmp    8008cc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008c9:	5b                   	pop    %ebx
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cc:	0f b6 01             	movzbl (%ecx),%eax
  8008cf:	0f b6 13             	movzbl (%ebx),%edx
  8008d2:	29 d0                	sub    %edx,%eax
  8008d4:	eb f3                	jmp    8008c9 <strncmp+0x3e>

008008d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e0:	0f b6 10             	movzbl (%eax),%edx
  8008e3:	84 d2                	test   %dl,%dl
  8008e5:	74 1c                	je     800903 <strchr+0x2d>
		if (*s == c)
  8008e7:	38 ca                	cmp    %cl,%dl
  8008e9:	75 09                	jne    8008f4 <strchr+0x1e>
  8008eb:	eb 1b                	jmp    800908 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ed:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8008f0:	38 ca                	cmp    %cl,%dl
  8008f2:	74 14                	je     800908 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008f4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8008f8:	84 d2                	test   %dl,%dl
  8008fa:	75 f1                	jne    8008ed <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	eb 05                	jmp    800908 <strchr+0x32>
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800914:	0f b6 10             	movzbl (%eax),%edx
  800917:	84 d2                	test   %dl,%dl
  800919:	74 14                	je     80092f <strfind+0x25>
		if (*s == c)
  80091b:	38 ca                	cmp    %cl,%dl
  80091d:	75 06                	jne    800925 <strfind+0x1b>
  80091f:	eb 0e                	jmp    80092f <strfind+0x25>
  800921:	38 ca                	cmp    %cl,%dl
  800923:	74 0a                	je     80092f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800925:	83 c0 01             	add    $0x1,%eax
  800928:	0f b6 10             	movzbl (%eax),%edx
  80092b:	84 d2                	test   %dl,%dl
  80092d:	75 f2                	jne    800921 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 0c             	sub    $0xc,%esp
  800937:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80093a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80093d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800940:	8b 7d 08             	mov    0x8(%ebp),%edi
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800949:	85 c9                	test   %ecx,%ecx
  80094b:	74 30                	je     80097d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80094d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800953:	75 25                	jne    80097a <memset+0x49>
  800955:	f6 c1 03             	test   $0x3,%cl
  800958:	75 20                	jne    80097a <memset+0x49>
		c &= 0xFF;
  80095a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095d:	89 d3                	mov    %edx,%ebx
  80095f:	c1 e3 08             	shl    $0x8,%ebx
  800962:	89 d6                	mov    %edx,%esi
  800964:	c1 e6 18             	shl    $0x18,%esi
  800967:	89 d0                	mov    %edx,%eax
  800969:	c1 e0 10             	shl    $0x10,%eax
  80096c:	09 f0                	or     %esi,%eax
  80096e:	09 d0                	or     %edx,%eax
  800970:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800972:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800975:	fc                   	cld    
  800976:	f3 ab                	rep stos %eax,%es:(%edi)
  800978:	eb 03                	jmp    80097d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097a:	fc                   	cld    
  80097b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097d:	89 f8                	mov    %edi,%eax
  80097f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800982:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800985:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800988:	89 ec                	mov    %ebp,%esp
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800995:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a1:	39 c6                	cmp    %eax,%esi
  8009a3:	73 36                	jae    8009db <memmove+0x4f>
  8009a5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a8:	39 d0                	cmp    %edx,%eax
  8009aa:	73 2f                	jae    8009db <memmove+0x4f>
		s += n;
		d += n;
  8009ac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	f6 c2 03             	test   $0x3,%dl
  8009b2:	75 1b                	jne    8009cf <memmove+0x43>
  8009b4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ba:	75 13                	jne    8009cf <memmove+0x43>
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 0e                	jne    8009cf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c1:	83 ef 04             	sub    $0x4,%edi
  8009c4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ca:	fd                   	std    
  8009cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009cd:	eb 09                	jmp    8009d8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cf:	83 ef 01             	sub    $0x1,%edi
  8009d2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009d5:	fd                   	std    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d8:	fc                   	cld    
  8009d9:	eb 20                	jmp    8009fb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009db:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e1:	75 13                	jne    8009f6 <memmove+0x6a>
  8009e3:	a8 03                	test   $0x3,%al
  8009e5:	75 0f                	jne    8009f6 <memmove+0x6a>
  8009e7:	f6 c1 03             	test   $0x3,%cl
  8009ea:	75 0a                	jne    8009f6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ec:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009ef:	89 c7                	mov    %eax,%edi
  8009f1:	fc                   	cld    
  8009f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f4:	eb 05                	jmp    8009fb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f6:	89 c7                	mov    %eax,%edi
  8009f8:	fc                   	cld    
  8009f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a01:	89 ec                	mov    %ebp,%esp
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	89 04 24             	mov    %eax,(%esp)
  800a1f:	e8 68 ff ff ff       	call   80098c <memmove>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	53                   	push   %ebx
  800a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a32:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3a:	85 ff                	test   %edi,%edi
  800a3c:	74 37                	je     800a75 <memcmp+0x4f>
		if (*s1 != *s2)
  800a3e:	0f b6 03             	movzbl (%ebx),%eax
  800a41:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a44:	83 ef 01             	sub    $0x1,%edi
  800a47:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a4c:	38 c8                	cmp    %cl,%al
  800a4e:	74 1c                	je     800a6c <memcmp+0x46>
  800a50:	eb 10                	jmp    800a62 <memcmp+0x3c>
  800a52:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a57:	83 c2 01             	add    $0x1,%edx
  800a5a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a5e:	38 c8                	cmp    %cl,%al
  800a60:	74 0a                	je     800a6c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800a62:	0f b6 c0             	movzbl %al,%eax
  800a65:	0f b6 c9             	movzbl %cl,%ecx
  800a68:	29 c8                	sub    %ecx,%eax
  800a6a:	eb 09                	jmp    800a75 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6c:	39 fa                	cmp    %edi,%edx
  800a6e:	75 e2                	jne    800a52 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5f                   	pop    %edi
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a80:	89 c2                	mov    %eax,%edx
  800a82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a85:	39 d0                	cmp    %edx,%eax
  800a87:	73 19                	jae    800aa2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800a8d:	38 08                	cmp    %cl,(%eax)
  800a8f:	75 06                	jne    800a97 <memfind+0x1d>
  800a91:	eb 0f                	jmp    800aa2 <memfind+0x28>
  800a93:	38 08                	cmp    %cl,(%eax)
  800a95:	74 0b                	je     800aa2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a97:	83 c0 01             	add    $0x1,%eax
  800a9a:	39 d0                	cmp    %edx,%eax
  800a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800aa0:	75 f1                	jne    800a93 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	57                   	push   %edi
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800aad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab0:	0f b6 02             	movzbl (%edx),%eax
  800ab3:	3c 20                	cmp    $0x20,%al
  800ab5:	74 04                	je     800abb <strtol+0x17>
  800ab7:	3c 09                	cmp    $0x9,%al
  800ab9:	75 0e                	jne    800ac9 <strtol+0x25>
		s++;
  800abb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abe:	0f b6 02             	movzbl (%edx),%eax
  800ac1:	3c 20                	cmp    $0x20,%al
  800ac3:	74 f6                	je     800abb <strtol+0x17>
  800ac5:	3c 09                	cmp    $0x9,%al
  800ac7:	74 f2                	je     800abb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ac9:	3c 2b                	cmp    $0x2b,%al
  800acb:	75 0a                	jne    800ad7 <strtol+0x33>
		s++;
  800acd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ad0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad5:	eb 10                	jmp    800ae7 <strtol+0x43>
  800ad7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800adc:	3c 2d                	cmp    $0x2d,%al
  800ade:	75 07                	jne    800ae7 <strtol+0x43>
		s++, neg = 1;
  800ae0:	83 c2 01             	add    $0x1,%edx
  800ae3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae7:	85 db                	test   %ebx,%ebx
  800ae9:	0f 94 c0             	sete   %al
  800aec:	74 05                	je     800af3 <strtol+0x4f>
  800aee:	83 fb 10             	cmp    $0x10,%ebx
  800af1:	75 15                	jne    800b08 <strtol+0x64>
  800af3:	80 3a 30             	cmpb   $0x30,(%edx)
  800af6:	75 10                	jne    800b08 <strtol+0x64>
  800af8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800afc:	75 0a                	jne    800b08 <strtol+0x64>
		s += 2, base = 16;
  800afe:	83 c2 02             	add    $0x2,%edx
  800b01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b06:	eb 13                	jmp    800b1b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b08:	84 c0                	test   %al,%al
  800b0a:	74 0f                	je     800b1b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b11:	80 3a 30             	cmpb   $0x30,(%edx)
  800b14:	75 05                	jne    800b1b <strtol+0x77>
		s++, base = 8;
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b20:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b22:	0f b6 0a             	movzbl (%edx),%ecx
  800b25:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b28:	80 fb 09             	cmp    $0x9,%bl
  800b2b:	77 08                	ja     800b35 <strtol+0x91>
			dig = *s - '0';
  800b2d:	0f be c9             	movsbl %cl,%ecx
  800b30:	83 e9 30             	sub    $0x30,%ecx
  800b33:	eb 1e                	jmp    800b53 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b35:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 08                	ja     800b45 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b3d:	0f be c9             	movsbl %cl,%ecx
  800b40:	83 e9 57             	sub    $0x57,%ecx
  800b43:	eb 0e                	jmp    800b53 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b48:	80 fb 19             	cmp    $0x19,%bl
  800b4b:	77 14                	ja     800b61 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b4d:	0f be c9             	movsbl %cl,%ecx
  800b50:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b53:	39 f1                	cmp    %esi,%ecx
  800b55:	7d 0e                	jge    800b65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b57:	83 c2 01             	add    $0x1,%edx
  800b5a:	0f af c6             	imul   %esi,%eax
  800b5d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800b5f:	eb c1                	jmp    800b22 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800b61:	89 c1                	mov    %eax,%ecx
  800b63:	eb 02                	jmp    800b67 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b65:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800b67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6b:	74 05                	je     800b72 <strtol+0xce>
		*endptr = (char *) s;
  800b6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b70:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b72:	89 ca                	mov    %ecx,%edx
  800b74:	f7 da                	neg    %edx
  800b76:	85 ff                	test   %edi,%edi
  800b78:	0f 45 c2             	cmovne %edx,%eax
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	89 c3                	mov    %eax,%ebx
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	89 c6                	mov    %eax,%esi
  800ba0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ba5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ba8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bab:	89 ec                	mov    %ebp,%esp
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <sys_cgetc>:

int
sys_cgetc(void)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 0c             	sub    $0xc,%esp
  800bb5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bb8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc8:	89 d1                	mov    %edx,%ecx
  800bca:	89 d3                	mov    %edx,%ebx
  800bcc:	89 d7                	mov    %edx,%edi
  800bce:	89 d6                	mov    %edx,%esi
  800bd0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bdb:	89 ec                	mov    %ebp,%esp
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 38             	sub    $0x38,%esp
  800be5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800be8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800beb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	89 cb                	mov    %ecx,%ebx
  800bfd:	89 cf                	mov    %ecx,%edi
  800bff:	89 ce                	mov    %ecx,%esi
  800c01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	7e 28                	jle    800c2f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c12:	00 
  800c13:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800c2a:	e8 31 11 00 00       	call   801d60 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c38:	89 ec                	mov    %ebp,%esp
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 0c             	sub    $0xc,%esp
  800c42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 02 00 00 00       	mov    $0x2,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c68:	89 ec                	mov    %ebp,%esp
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_yield>:

void
sys_yield(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c98:	89 ec                	mov    %ebp,%esp
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 38             	sub    $0x38,%esp
  800ca2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ca5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ca8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cab:	be 00 00 00 00       	mov    $0x0,%esi
  800cb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	89 f7                	mov    %esi,%edi
  800cc0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7e 28                	jle    800cee <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cca:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cd1:	00 
  800cd2:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800cd9:	00 
  800cda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce1:	00 
  800ce2:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800ce9:	e8 72 10 00 00       	call   801d60 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cf1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cf4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cf7:	89 ec                	mov    %ebp,%esp
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 38             	sub    $0x38,%esp
  800d01:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d04:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d07:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d0f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7e 28                	jle    800d4c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d24:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d28:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d2f:	00 
  800d30:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d37:	00 
  800d38:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3f:	00 
  800d40:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800d47:	e8 14 10 00 00       	call   801d60 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d4c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d4f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d52:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d55:	89 ec                	mov    %ebp,%esp
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 38             	sub    $0x38,%esp
  800d5f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d65:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7e 28                	jle    800daa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d86:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d95:	00 
  800d96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9d:	00 
  800d9e:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800da5:	e8 b6 0f 00 00       	call   801d60 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800daa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db3:	89 ec                	mov    %ebp,%esp
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 38             	sub    $0x38,%esp
  800dbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7e 28                	jle    800e08 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800deb:	00 
  800dec:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800df3:	00 
  800df4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfb:	00 
  800dfc:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800e03:	e8 58 0f 00 00       	call   801d60 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e08:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e11:	89 ec                	mov    %ebp,%esp
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 38             	sub    $0x38,%esp
  800e1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7e 28                	jle    800e66 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e42:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e49:	00 
  800e4a:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800e51:	00 
  800e52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e59:	00 
  800e5a:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800e61:	e8 fa 0e 00 00       	call   801d60 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6f:	89 ec                	mov    %ebp,%esp
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 38             	sub    $0x38,%esp
  800e79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7e 28                	jle    800ec4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ea7:	00 
  800ea8:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800ebf:	e8 9c 0e 00 00       	call   801d60 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecd:	89 ec                	mov    %ebp,%esp
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eda:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eea:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f01:	89 ec                	mov    %ebp,%esp
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 38             	sub    $0x38,%esp
  800f0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f19:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	89 cb                	mov    %ecx,%ebx
  800f23:	89 cf                	mov    %ecx,%edi
  800f25:	89 ce                	mov    %ecx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800f50:	e8 0b 0e 00 00       	call   801d60 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f55:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f58:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5e:	89 ec                	mov    %ebp,%esp
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
	...

00800f70 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	05 00 00 00 30       	add    $0x30000000,%eax
  800f7b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	89 04 24             	mov    %eax,(%esp)
  800f8c:	e8 df ff ff ff       	call   800f70 <fd2num>
  800f91:	05 20 00 0d 00       	add    $0xd0020,%eax
  800f96:	c1 e0 0c             	shl    $0xc,%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	53                   	push   %ebx
  800f9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fa2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800fa7:	a8 01                	test   $0x1,%al
  800fa9:	74 34                	je     800fdf <fd_alloc+0x44>
  800fab:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800fb0:	a8 01                	test   $0x1,%al
  800fb2:	74 32                	je     800fe6 <fd_alloc+0x4b>
  800fb4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fb9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fbb:	89 c2                	mov    %eax,%edx
  800fbd:	c1 ea 16             	shr    $0x16,%edx
  800fc0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc7:	f6 c2 01             	test   $0x1,%dl
  800fca:	74 1f                	je     800feb <fd_alloc+0x50>
  800fcc:	89 c2                	mov    %eax,%edx
  800fce:	c1 ea 0c             	shr    $0xc,%edx
  800fd1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd8:	f6 c2 01             	test   $0x1,%dl
  800fdb:	75 17                	jne    800ff4 <fd_alloc+0x59>
  800fdd:	eb 0c                	jmp    800feb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fdf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800fe4:	eb 05                	jmp    800feb <fd_alloc+0x50>
  800fe6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800feb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff2:	eb 17                	jmp    80100b <fd_alloc+0x70>
  800ff4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ff9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ffe:	75 b9                	jne    800fb9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801000:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801006:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80100b:	5b                   	pop    %ebx
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801014:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801019:	83 fa 1f             	cmp    $0x1f,%edx
  80101c:	77 3f                	ja     80105d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80101e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801024:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801027:	89 d0                	mov    %edx,%eax
  801029:	c1 e8 16             	shr    $0x16,%eax
  80102c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801033:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801038:	f6 c1 01             	test   $0x1,%cl
  80103b:	74 20                	je     80105d <fd_lookup+0x4f>
  80103d:	89 d0                	mov    %edx,%eax
  80103f:	c1 e8 0c             	shr    $0xc,%eax
  801042:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801049:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104e:	f6 c1 01             	test   $0x1,%cl
  801051:	74 0a                	je     80105d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	89 10                	mov    %edx,(%eax)
	return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	53                   	push   %ebx
  801063:	83 ec 14             	sub    $0x14,%esp
  801066:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801069:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801071:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801077:	75 17                	jne    801090 <dev_lookup+0x31>
  801079:	eb 07                	jmp    801082 <dev_lookup+0x23>
  80107b:	39 0a                	cmp    %ecx,(%edx)
  80107d:	75 11                	jne    801090 <dev_lookup+0x31>
  80107f:	90                   	nop
  801080:	eb 05                	jmp    801087 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801082:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801087:	89 13                	mov    %edx,(%ebx)
			return 0;
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
  80108e:	eb 35                	jmp    8010c5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801090:	83 c0 01             	add    $0x1,%eax
  801093:	8b 14 85 a8 25 80 00 	mov    0x8025a8(,%eax,4),%edx
  80109a:	85 d2                	test   %edx,%edx
  80109c:	75 dd                	jne    80107b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80109e:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a3:	8b 40 48             	mov    0x48(%eax),%eax
  8010a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ae:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  8010b5:	e8 bd f0 ff ff       	call   800177 <cprintf>
	*dev = 0;
  8010ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c5:	83 c4 14             	add    $0x14,%esp
  8010c8:	5b                   	pop    %ebx
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 38             	sub    $0x38,%esp
  8010d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010dd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e1:	89 3c 24             	mov    %edi,(%esp)
  8010e4:	e8 87 fe ff ff       	call   800f70 <fd2num>
  8010e9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8010ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010f0:	89 04 24             	mov    %eax,(%esp)
  8010f3:	e8 16 ff ff ff       	call   80100e <fd_lookup>
  8010f8:	89 c3                	mov    %eax,%ebx
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	78 05                	js     801103 <fd_close+0x38>
	    || fd != fd2)
  8010fe:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801101:	74 0e                	je     801111 <fd_close+0x46>
		return (must_exist ? r : 0);
  801103:	89 f0                	mov    %esi,%eax
  801105:	84 c0                	test   %al,%al
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	0f 44 d8             	cmove  %eax,%ebx
  80110f:	eb 3d                	jmp    80114e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801111:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801114:	89 44 24 04          	mov    %eax,0x4(%esp)
  801118:	8b 07                	mov    (%edi),%eax
  80111a:	89 04 24             	mov    %eax,(%esp)
  80111d:	e8 3d ff ff ff       	call   80105f <dev_lookup>
  801122:	89 c3                	mov    %eax,%ebx
  801124:	85 c0                	test   %eax,%eax
  801126:	78 16                	js     80113e <fd_close+0x73>
		if (dev->dev_close)
  801128:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801133:	85 c0                	test   %eax,%eax
  801135:	74 07                	je     80113e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801137:	89 3c 24             	mov    %edi,(%esp)
  80113a:	ff d0                	call   *%eax
  80113c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80113e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801149:	e8 0b fc ff ff       	call   800d59 <sys_page_unmap>
	return r;
}
  80114e:	89 d8                	mov    %ebx,%eax
  801150:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801153:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801156:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801159:	89 ec                	mov    %ebp,%esp
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	89 04 24             	mov    %eax,(%esp)
  801170:	e8 99 fe ff ff       	call   80100e <fd_lookup>
  801175:	85 c0                	test   %eax,%eax
  801177:	78 13                	js     80118c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801179:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801180:	00 
  801181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801184:	89 04 24             	mov    %eax,(%esp)
  801187:	e8 3f ff ff ff       	call   8010cb <fd_close>
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <close_all>:

void
close_all(void)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	53                   	push   %ebx
  801192:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801195:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80119a:	89 1c 24             	mov    %ebx,(%esp)
  80119d:	e8 bb ff ff ff       	call   80115d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a2:	83 c3 01             	add    $0x1,%ebx
  8011a5:	83 fb 20             	cmp    $0x20,%ebx
  8011a8:	75 f0                	jne    80119a <close_all+0xc>
		close(i);
}
  8011aa:	83 c4 14             	add    $0x14,%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 58             	sub    $0x58,%esp
  8011b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8011bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	89 04 24             	mov    %eax,(%esp)
  8011cf:	e8 3a fe ff ff       	call   80100e <fd_lookup>
  8011d4:	89 c3                	mov    %eax,%ebx
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 88 e1 00 00 00    	js     8012bf <dup+0x10f>
		return r;
	close(newfdnum);
  8011de:	89 3c 24             	mov    %edi,(%esp)
  8011e1:	e8 77 ff ff ff       	call   80115d <close>

	newfd = INDEX2FD(newfdnum);
  8011e6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8011ec:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8011ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f2:	89 04 24             	mov    %eax,(%esp)
  8011f5:	e8 86 fd ff ff       	call   800f80 <fd2data>
  8011fa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011fc:	89 34 24             	mov    %esi,(%esp)
  8011ff:	e8 7c fd ff ff       	call   800f80 <fd2data>
  801204:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801207:	89 d8                	mov    %ebx,%eax
  801209:	c1 e8 16             	shr    $0x16,%eax
  80120c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801213:	a8 01                	test   $0x1,%al
  801215:	74 46                	je     80125d <dup+0xad>
  801217:	89 d8                	mov    %ebx,%eax
  801219:	c1 e8 0c             	shr    $0xc,%eax
  80121c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801223:	f6 c2 01             	test   $0x1,%dl
  801226:	74 35                	je     80125d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801228:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122f:	25 07 0e 00 00       	and    $0xe07,%eax
  801234:	89 44 24 10          	mov    %eax,0x10(%esp)
  801238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80123b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80123f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801246:	00 
  801247:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80124b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801252:	e8 a4 fa ff ff       	call   800cfb <sys_page_map>
  801257:	89 c3                	mov    %eax,%ebx
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 3b                	js     801298 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80125d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801260:	89 c2                	mov    %eax,%edx
  801262:	c1 ea 0c             	shr    $0xc,%edx
  801265:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801272:	89 54 24 10          	mov    %edx,0x10(%esp)
  801276:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80127a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801281:	00 
  801282:	89 44 24 04          	mov    %eax,0x4(%esp)
  801286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80128d:	e8 69 fa ff ff       	call   800cfb <sys_page_map>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	85 c0                	test   %eax,%eax
  801296:	79 25                	jns    8012bd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801298:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a3:	e8 b1 fa ff ff       	call   800d59 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b6:	e8 9e fa ff ff       	call   800d59 <sys_page_unmap>
	return r;
  8012bb:	eb 02                	jmp    8012bf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8012bd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012bf:	89 d8                	mov    %ebx,%eax
  8012c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ca:	89 ec                	mov    %ebp,%esp
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 24             	sub    $0x24,%esp
  8012d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012df:	89 1c 24             	mov    %ebx,(%esp)
  8012e2:	e8 27 fd ff ff       	call   80100e <fd_lookup>
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 6d                	js     801358 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	8b 00                	mov    (%eax),%eax
  8012f7:	89 04 24             	mov    %eax,(%esp)
  8012fa:	e8 60 fd ff ff       	call   80105f <dev_lookup>
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 55                	js     801358 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801306:	8b 50 08             	mov    0x8(%eax),%edx
  801309:	83 e2 03             	and    $0x3,%edx
  80130c:	83 fa 01             	cmp    $0x1,%edx
  80130f:	75 23                	jne    801334 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801311:	a1 08 40 80 00       	mov    0x804008,%eax
  801316:	8b 40 48             	mov    0x48(%eax),%eax
  801319:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80131d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801321:	c7 04 24 6d 25 80 00 	movl   $0x80256d,(%esp)
  801328:	e8 4a ee ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  80132d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801332:	eb 24                	jmp    801358 <read+0x8a>
	}
	if (!dev->dev_read)
  801334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801337:	8b 52 08             	mov    0x8(%edx),%edx
  80133a:	85 d2                	test   %edx,%edx
  80133c:	74 15                	je     801353 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80133e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801341:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801345:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801348:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80134c:	89 04 24             	mov    %eax,(%esp)
  80134f:	ff d2                	call   *%edx
  801351:	eb 05                	jmp    801358 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801353:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801358:	83 c4 24             	add    $0x24,%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 1c             	sub    $0x1c,%esp
  801367:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	85 f6                	test   %esi,%esi
  801374:	74 30                	je     8013a6 <readn+0x48>
  801376:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137b:	89 f2                	mov    %esi,%edx
  80137d:	29 c2                	sub    %eax,%edx
  80137f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801383:	03 45 0c             	add    0xc(%ebp),%eax
  801386:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138a:	89 3c 24             	mov    %edi,(%esp)
  80138d:	e8 3c ff ff ff       	call   8012ce <read>
		if (m < 0)
  801392:	85 c0                	test   %eax,%eax
  801394:	78 10                	js     8013a6 <readn+0x48>
			return m;
		if (m == 0)
  801396:	85 c0                	test   %eax,%eax
  801398:	74 0a                	je     8013a4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139a:	01 c3                	add    %eax,%ebx
  80139c:	89 d8                	mov    %ebx,%eax
  80139e:	39 f3                	cmp    %esi,%ebx
  8013a0:	72 d9                	jb     80137b <readn+0x1d>
  8013a2:	eb 02                	jmp    8013a6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8013a4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8013a6:	83 c4 1c             	add    $0x1c,%esp
  8013a9:	5b                   	pop    %ebx
  8013aa:	5e                   	pop    %esi
  8013ab:	5f                   	pop    %edi
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 24             	sub    $0x24,%esp
  8013b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bf:	89 1c 24             	mov    %ebx,(%esp)
  8013c2:	e8 47 fc ff ff       	call   80100e <fd_lookup>
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 68                	js     801433 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	89 04 24             	mov    %eax,(%esp)
  8013da:	e8 80 fc ff ff       	call   80105f <dev_lookup>
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	78 50                	js     801433 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ea:	75 23                	jne    80140f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f1:	8b 40 48             	mov    0x48(%eax),%eax
  8013f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fc:	c7 04 24 89 25 80 00 	movl   $0x802589,(%esp)
  801403:	e8 6f ed ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb 24                	jmp    801433 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80140f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801412:	8b 52 0c             	mov    0xc(%edx),%edx
  801415:	85 d2                	test   %edx,%edx
  801417:	74 15                	je     80142e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801419:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801423:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801427:	89 04 24             	mov    %eax,(%esp)
  80142a:	ff d2                	call   *%edx
  80142c:	eb 05                	jmp    801433 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80142e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801433:	83 c4 24             	add    $0x24,%esp
  801436:	5b                   	pop    %ebx
  801437:	5d                   	pop    %ebp
  801438:	c3                   	ret    

00801439 <seek>:

int
seek(int fdnum, off_t offset)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801442:	89 44 24 04          	mov    %eax,0x4(%esp)
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	89 04 24             	mov    %eax,(%esp)
  80144c:	e8 bd fb ff ff       	call   80100e <fd_lookup>
  801451:	85 c0                	test   %eax,%eax
  801453:	78 0e                	js     801463 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801455:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80145e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	53                   	push   %ebx
  801469:	83 ec 24             	sub    $0x24,%esp
  80146c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801472:	89 44 24 04          	mov    %eax,0x4(%esp)
  801476:	89 1c 24             	mov    %ebx,(%esp)
  801479:	e8 90 fb ff ff       	call   80100e <fd_lookup>
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 61                	js     8014e3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	89 44 24 04          	mov    %eax,0x4(%esp)
  801489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	89 04 24             	mov    %eax,(%esp)
  801491:	e8 c9 fb ff ff       	call   80105f <dev_lookup>
  801496:	85 c0                	test   %eax,%eax
  801498:	78 49                	js     8014e3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a1:	75 23                	jne    8014c6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014a3:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014a8:	8b 40 48             	mov    0x48(%eax),%eax
  8014ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  8014ba:	e8 b8 ec ff ff       	call   800177 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c4:	eb 1d                	jmp    8014e3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8014c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c9:	8b 52 18             	mov    0x18(%edx),%edx
  8014cc:	85 d2                	test   %edx,%edx
  8014ce:	74 0e                	je     8014de <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014d7:	89 04 24             	mov    %eax,(%esp)
  8014da:	ff d2                	call   *%edx
  8014dc:	eb 05                	jmp    8014e3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014e3:	83 c4 24             	add    $0x24,%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	53                   	push   %ebx
  8014ed:	83 ec 24             	sub    $0x24,%esp
  8014f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	89 04 24             	mov    %eax,(%esp)
  801500:	e8 09 fb ff ff       	call   80100e <fd_lookup>
  801505:	85 c0                	test   %eax,%eax
  801507:	78 52                	js     80155b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801509:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	89 04 24             	mov    %eax,(%esp)
  801518:	e8 42 fb ff ff       	call   80105f <dev_lookup>
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 3a                	js     80155b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801528:	74 2c                	je     801556 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80152a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80152d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801534:	00 00 00 
	stat->st_isdir = 0;
  801537:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80153e:	00 00 00 
	stat->st_dev = dev;
  801541:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801547:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80154b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154e:	89 14 24             	mov    %edx,(%esp)
  801551:	ff 50 14             	call   *0x14(%eax)
  801554:	eb 05                	jmp    80155b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801556:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80155b:	83 c4 24             	add    $0x24,%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    

00801561 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 18             	sub    $0x18,%esp
  801567:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80156a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801574:	00 
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	89 04 24             	mov    %eax,(%esp)
  80157b:	e8 bc 01 00 00       	call   80173c <open>
  801580:	89 c3                	mov    %eax,%ebx
  801582:	85 c0                	test   %eax,%eax
  801584:	78 1b                	js     8015a1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158d:	89 1c 24             	mov    %ebx,(%esp)
  801590:	e8 54 ff ff ff       	call   8014e9 <fstat>
  801595:	89 c6                	mov    %eax,%esi
	close(fd);
  801597:	89 1c 24             	mov    %ebx,(%esp)
  80159a:	e8 be fb ff ff       	call   80115d <close>
	return r;
  80159f:	89 f3                	mov    %esi,%ebx
}
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015a6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015a9:	89 ec                	mov    %ebp,%esp
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    
  8015ad:	00 00                	add    %al,(%eax)
	...

008015b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
  8015b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8015c0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c7:	75 11                	jne    8015da <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015d0:	e8 c1 08 00 00       	call   801e96 <ipc_find_env>
  8015d5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015da:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015e1:	00 
  8015e2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015e9:	00 
  8015ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8015f3:	89 04 24             	mov    %eax,(%esp)
  8015f6:	e8 17 08 00 00       	call   801e12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801602:	00 
  801603:	89 74 24 04          	mov    %esi,0x4(%esp)
  801607:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80160e:	e8 ad 07 00 00       	call   801dc0 <ipc_recv>
}
  801613:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801616:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801619:	89 ec                	mov    %ebp,%esp
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
  801621:	83 ec 14             	sub    $0x14,%esp
  801624:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	b8 05 00 00 00       	mov    $0x5,%eax
  80163c:	e8 6f ff ff ff       	call   8015b0 <fsipc>
  801641:	85 c0                	test   %eax,%eax
  801643:	78 2b                	js     801670 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801645:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80164c:	00 
  80164d:	89 1c 24             	mov    %ebx,(%esp)
  801650:	e8 46 f1 ff ff       	call   80079b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801655:	a1 80 50 80 00       	mov    0x805080,%eax
  80165a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801660:	a1 84 50 80 00       	mov    0x805084,%eax
  801665:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801670:	83 c4 14             	add    $0x14,%esp
  801673:	5b                   	pop    %ebx
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8b 40 0c             	mov    0xc(%eax),%eax
  801682:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	b8 06 00 00 00       	mov    $0x6,%eax
  801691:	e8 1a ff ff ff       	call   8015b0 <fsipc>
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	56                   	push   %esi
  80169c:	53                   	push   %ebx
  80169d:	83 ec 10             	sub    $0x10,%esp
  8016a0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ae:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016be:	e8 ed fe ff ff       	call   8015b0 <fsipc>
  8016c3:	89 c3                	mov    %eax,%ebx
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 6a                	js     801733 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016c9:	39 c6                	cmp    %eax,%esi
  8016cb:	73 24                	jae    8016f1 <devfile_read+0x59>
  8016cd:	c7 44 24 0c b8 25 80 	movl   $0x8025b8,0xc(%esp)
  8016d4:	00 
  8016d5:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  8016dc:	00 
  8016dd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016e4:	00 
  8016e5:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  8016ec:	e8 6f 06 00 00       	call   801d60 <_panic>
	assert(r <= PGSIZE);
  8016f1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f6:	7e 24                	jle    80171c <devfile_read+0x84>
  8016f8:	c7 44 24 0c df 25 80 	movl   $0x8025df,0xc(%esp)
  8016ff:	00 
  801700:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  801707:	00 
  801708:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80170f:	00 
  801710:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  801717:	e8 44 06 00 00       	call   801d60 <_panic>
	memmove(buf, &fsipcbuf, r);
  80171c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801720:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801727:	00 
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	89 04 24             	mov    %eax,(%esp)
  80172e:	e8 59 f2 ff ff       	call   80098c <memmove>
	return r;
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	83 ec 20             	sub    $0x20,%esp
  801744:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801747:	89 34 24             	mov    %esi,(%esp)
  80174a:	e8 01 f0 ff ff       	call   800750 <strlen>
		return -E_BAD_PATH;
  80174f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801754:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801759:	7f 5e                	jg     8017b9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80175b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175e:	89 04 24             	mov    %eax,(%esp)
  801761:	e8 35 f8 ff ff       	call   800f9b <fd_alloc>
  801766:	89 c3                	mov    %eax,%ebx
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 4d                	js     8017b9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80176c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801770:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801777:	e8 1f f0 ff ff       	call   80079b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801787:	b8 01 00 00 00       	mov    $0x1,%eax
  80178c:	e8 1f fe ff ff       	call   8015b0 <fsipc>
  801791:	89 c3                	mov    %eax,%ebx
  801793:	85 c0                	test   %eax,%eax
  801795:	79 15                	jns    8017ac <open+0x70>
		fd_close(fd, 0);
  801797:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80179e:	00 
  80179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	e8 21 f9 ff ff       	call   8010cb <fd_close>
		return r;
  8017aa:	eb 0d                	jmp    8017b9 <open+0x7d>
	}

	return fd2num(fd);
  8017ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 b9 f7 ff ff       	call   800f70 <fd2num>
  8017b7:	89 c3                	mov    %eax,%ebx
}
  8017b9:	89 d8                	mov    %ebx,%eax
  8017bb:	83 c4 20             	add    $0x20,%esp
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5d                   	pop    %ebp
  8017c1:	c3                   	ret    
	...

008017d0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 18             	sub    $0x18,%esp
  8017d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	89 04 24             	mov    %eax,(%esp)
  8017e5:	e8 96 f7 ff ff       	call   800f80 <fd2data>
  8017ea:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8017ec:	c7 44 24 04 eb 25 80 	movl   $0x8025eb,0x4(%esp)
  8017f3:	00 
  8017f4:	89 34 24             	mov    %esi,(%esp)
  8017f7:	e8 9f ef ff ff       	call   80079b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017fc:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ff:	2b 03                	sub    (%ebx),%eax
  801801:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801807:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80180e:	00 00 00 
	stat->st_dev = &devpipe;
  801811:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801818:	30 80 00 
	return 0;
}
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801823:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801826:	89 ec                	mov    %ebp,%esp
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    

0080182a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 14             	sub    $0x14,%esp
  801831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801834:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801838:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183f:	e8 15 f5 ff ff       	call   800d59 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801844:	89 1c 24             	mov    %ebx,(%esp)
  801847:	e8 34 f7 ff ff       	call   800f80 <fd2data>
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801857:	e8 fd f4 ff ff       	call   800d59 <sys_page_unmap>
}
  80185c:	83 c4 14             	add    $0x14,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    

00801862 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	57                   	push   %edi
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	83 ec 2c             	sub    $0x2c,%esp
  80186b:	89 c7                	mov    %eax,%edi
  80186d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801870:	a1 08 40 80 00       	mov    0x804008,%eax
  801875:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801878:	89 3c 24             	mov    %edi,(%esp)
  80187b:	e8 60 06 00 00       	call   801ee0 <pageref>
  801880:	89 c6                	mov    %eax,%esi
  801882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 53 06 00 00       	call   801ee0 <pageref>
  80188d:	39 c6                	cmp    %eax,%esi
  80188f:	0f 94 c0             	sete   %al
  801892:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801895:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80189b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80189e:	39 cb                	cmp    %ecx,%ebx
  8018a0:	75 08                	jne    8018aa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8018a2:	83 c4 2c             	add    $0x2c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8018aa:	83 f8 01             	cmp    $0x1,%eax
  8018ad:	75 c1                	jne    801870 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018af:	8b 52 58             	mov    0x58(%edx),%edx
  8018b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018be:	c7 04 24 f2 25 80 00 	movl   $0x8025f2,(%esp)
  8018c5:	e8 ad e8 ff ff       	call   800177 <cprintf>
  8018ca:	eb a4                	jmp    801870 <_pipeisclosed+0xe>

008018cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	57                   	push   %edi
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	83 ec 2c             	sub    $0x2c,%esp
  8018d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018d8:	89 34 24             	mov    %esi,(%esp)
  8018db:	e8 a0 f6 ff ff       	call   800f80 <fd2data>
  8018e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8018e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018eb:	75 50                	jne    80193d <devpipe_write+0x71>
  8018ed:	eb 5c                	jmp    80194b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8018ef:	89 da                	mov    %ebx,%edx
  8018f1:	89 f0                	mov    %esi,%eax
  8018f3:	e8 6a ff ff ff       	call   801862 <_pipeisclosed>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 53                	jne    80194f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018fc:	e8 6b f3 ff ff       	call   800c6c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801901:	8b 43 04             	mov    0x4(%ebx),%eax
  801904:	8b 13                	mov    (%ebx),%edx
  801906:	83 c2 20             	add    $0x20,%edx
  801909:	39 d0                	cmp    %edx,%eax
  80190b:	73 e2                	jae    8018ef <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801914:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801917:	89 c2                	mov    %eax,%edx
  801919:	c1 fa 1f             	sar    $0x1f,%edx
  80191c:	c1 ea 1b             	shr    $0x1b,%edx
  80191f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801922:	83 e1 1f             	and    $0x1f,%ecx
  801925:	29 d1                	sub    %edx,%ecx
  801927:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80192b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80192f:	83 c0 01             	add    $0x1,%eax
  801932:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801935:	83 c7 01             	add    $0x1,%edi
  801938:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80193b:	74 0e                	je     80194b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80193d:	8b 43 04             	mov    0x4(%ebx),%eax
  801940:	8b 13                	mov    (%ebx),%edx
  801942:	83 c2 20             	add    $0x20,%edx
  801945:	39 d0                	cmp    %edx,%eax
  801947:	73 a6                	jae    8018ef <devpipe_write+0x23>
  801949:	eb c2                	jmp    80190d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80194b:	89 f8                	mov    %edi,%eax
  80194d:	eb 05                	jmp    801954 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80194f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801954:	83 c4 2c             	add    $0x2c,%esp
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5f                   	pop    %edi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 28             	sub    $0x28,%esp
  801962:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801965:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801968:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80196b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80196e:	89 3c 24             	mov    %edi,(%esp)
  801971:	e8 0a f6 ff ff       	call   800f80 <fd2data>
  801976:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801978:	be 00 00 00 00       	mov    $0x0,%esi
  80197d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801981:	75 47                	jne    8019ca <devpipe_read+0x6e>
  801983:	eb 52                	jmp    8019d7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801985:	89 f0                	mov    %esi,%eax
  801987:	eb 5e                	jmp    8019e7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801989:	89 da                	mov    %ebx,%edx
  80198b:	89 f8                	mov    %edi,%eax
  80198d:	8d 76 00             	lea    0x0(%esi),%esi
  801990:	e8 cd fe ff ff       	call   801862 <_pipeisclosed>
  801995:	85 c0                	test   %eax,%eax
  801997:	75 49                	jne    8019e2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801999:	e8 ce f2 ff ff       	call   800c6c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80199e:	8b 03                	mov    (%ebx),%eax
  8019a0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019a3:	74 e4                	je     801989 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	c1 fa 1f             	sar    $0x1f,%edx
  8019aa:	c1 ea 1b             	shr    $0x1b,%edx
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	83 e0 1f             	and    $0x1f,%eax
  8019b2:	29 d0                	sub    %edx,%eax
  8019b4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8019bf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019c2:	83 c6 01             	add    $0x1,%esi
  8019c5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019c8:	74 0d                	je     8019d7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8019ca:	8b 03                	mov    (%ebx),%eax
  8019cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019cf:	75 d4                	jne    8019a5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019d1:	85 f6                	test   %esi,%esi
  8019d3:	75 b0                	jne    801985 <devpipe_read+0x29>
  8019d5:	eb b2                	jmp    801989 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019d7:	89 f0                	mov    %esi,%eax
  8019d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8019e0:	eb 05                	jmp    8019e7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8019e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019f0:	89 ec                	mov    %ebp,%esp
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 48             	sub    $0x48,%esp
  8019fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a00:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a03:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a06:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a09:	89 04 24             	mov    %eax,(%esp)
  801a0c:	e8 8a f5 ff ff       	call   800f9b <fd_alloc>
  801a11:	89 c3                	mov    %eax,%ebx
  801a13:	85 c0                	test   %eax,%eax
  801a15:	0f 88 45 01 00 00    	js     801b60 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a1b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a22:	00 
  801a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a31:	e8 66 f2 ff ff       	call   800c9c <sys_page_alloc>
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	0f 88 20 01 00 00    	js     801b60 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801a40:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a43:	89 04 24             	mov    %eax,(%esp)
  801a46:	e8 50 f5 ff ff       	call   800f9b <fd_alloc>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	0f 88 f8 00 00 00    	js     801b4d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a55:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a5c:	00 
  801a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6b:	e8 2c f2 ff ff       	call   800c9c <sys_page_alloc>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	85 c0                	test   %eax,%eax
  801a74:	0f 88 d3 00 00 00    	js     801b4d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7d:	89 04 24             	mov    %eax,(%esp)
  801a80:	e8 fb f4 ff ff       	call   800f80 <fd2data>
  801a85:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a87:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a8e:	00 
  801a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9a:	e8 fd f1 ff ff       	call   800c9c <sys_page_alloc>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	0f 88 91 00 00 00    	js     801b3a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 cc f4 ff ff       	call   800f80 <fd2data>
  801ab4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801abb:	00 
  801abc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ac7:	00 
  801ac8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801acc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad3:	e8 23 f2 ff ff       	call   800cfb <sys_page_map>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 4c                	js     801b2a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ade:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801af3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b01:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	e8 5d f4 ff ff       	call   800f70 <fd2num>
  801b13:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	e8 50 f4 ff ff       	call   800f70 <fd2num>
  801b20:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b28:	eb 36                	jmp    801b60 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801b2a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b35:	e8 1f f2 ff ff       	call   800d59 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b48:	e8 0c f2 ff ff       	call   800d59 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5b:	e8 f9 f1 ff ff       	call   800d59 <sys_page_unmap>
    err:
	return r;
}
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b65:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b68:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b6b:	89 ec                	mov    %ebp,%esp
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 87 f4 ff ff       	call   80100e <fd_lookup>
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 15                	js     801ba0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 ea f3 ff ff       	call   800f80 <fd2data>
	return _pipeisclosed(fd, p);
  801b96:	89 c2                	mov    %eax,%edx
  801b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9b:	e8 c2 fc ff ff       	call   801862 <_pipeisclosed>
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    
	...

00801bb0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801bc0:	c7 44 24 04 0a 26 80 	movl   $0x80260a,0x4(%esp)
  801bc7:	00 
  801bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcb:	89 04 24             	mov    %eax,(%esp)
  801bce:	e8 c8 eb ff ff       	call   80079b <strcpy>
	return 0;
}
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	57                   	push   %edi
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801be6:	be 00 00 00 00       	mov    $0x0,%esi
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	74 43                	je     801c34 <devcons_write+0x5a>
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bf6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bff:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801c01:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c04:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801c09:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c10:	03 45 0c             	add    0xc(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	89 3c 24             	mov    %edi,(%esp)
  801c1a:	e8 6d ed ff ff       	call   80098c <memmove>
		sys_cputs(buf, m);
  801c1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c23:	89 3c 24             	mov    %edi,(%esp)
  801c26:	e8 55 ef ff ff       	call   800b80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c2b:	01 de                	add    %ebx,%esi
  801c2d:	89 f0                	mov    %esi,%eax
  801c2f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c32:	72 c8                	jb     801bfc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801c34:	89 f0                	mov    %esi,%eax
  801c36:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    

00801c41 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c50:	75 07                	jne    801c59 <devcons_read+0x18>
  801c52:	eb 31                	jmp    801c85 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801c54:	e8 13 f0 ff ff       	call   800c6c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	e8 4a ef ff ff       	call   800baf <sys_cgetc>
  801c65:	85 c0                	test   %eax,%eax
  801c67:	74 eb                	je     801c54 <devcons_read+0x13>
  801c69:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 16                	js     801c85 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801c6f:	83 f8 04             	cmp    $0x4,%eax
  801c72:	74 0c                	je     801c80 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c77:	88 10                	mov    %dl,(%eax)
	return 1;
  801c79:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7e:	eb 05                	jmp    801c85 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c93:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c9a:	00 
  801c9b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 da ee ff ff       	call   800b80 <sys_cputs>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <getchar>:

int
getchar(void)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801cae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801cb5:	00 
  801cb6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cc4:	e8 05 f6 ff ff       	call   8012ce <read>
	if (r < 0)
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	78 0f                	js     801cdc <getchar+0x34>
		return r;
	if (r < 1)
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	7e 06                	jle    801cd7 <getchar+0x2f>
		return -E_EOF;
	return c;
  801cd1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801cd5:	eb 05                	jmp    801cdc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801cd7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 18 f3 ff ff       	call   80100e <fd_lookup>
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 11                	js     801d0b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d03:	39 10                	cmp    %edx,(%eax)
  801d05:	0f 94 c0             	sete   %al
  801d08:	0f b6 c0             	movzbl %al,%eax
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <opencons>:

int
opencons(void)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d16:	89 04 24             	mov    %eax,(%esp)
  801d19:	e8 7d f2 ff ff       	call   800f9b <fd_alloc>
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 3c                	js     801d5e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d22:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d29:	00 
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d38:	e8 5f ef ff ff       	call   800c9c <sys_page_alloc>
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	78 1d                	js     801d5e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d41:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 12 f2 ff ff       	call   800f70 <fd2num>
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	56                   	push   %esi
  801d64:	53                   	push   %ebx
  801d65:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801d68:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d6b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801d71:	e8 c6 ee ff ff       	call   800c3c <sys_getenvid>
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d79:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d80:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	c7 04 24 18 26 80 00 	movl   $0x802618,(%esp)
  801d93:	e8 df e3 ff ff       	call   800177 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d98:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 6f e3 ff ff       	call   800116 <vcprintf>
	cprintf("\n");
  801da7:	c7 04 24 ec 21 80 00 	movl   $0x8021ec,(%esp)
  801dae:	e8 c4 e3 ff ff       	call   800177 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801db3:	cc                   	int3   
  801db4:	eb fd                	jmp    801db3 <_panic+0x53>
	...

00801dc0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 10             	sub    $0x10,%esp
  801dc8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801dd1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801dd3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dd8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ddb:	89 04 24             	mov    %eax,(%esp)
  801dde:	e8 22 f1 ff ff       	call   800f05 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801de3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801de8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 0e                	js     801dff <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801df1:	a1 08 40 80 00       	mov    0x804008,%eax
  801df6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801df9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801dfc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801dff:	85 f6                	test   %esi,%esi
  801e01:	74 02                	je     801e05 <ipc_recv+0x45>
		*from_env_store = sender;
  801e03:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801e05:	85 db                	test   %ebx,%ebx
  801e07:	74 02                	je     801e0b <ipc_recv+0x4b>
		*perm_store = perm;
  801e09:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
  801e1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e21:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e24:	85 db                	test   %ebx,%ebx
  801e26:	75 04                	jne    801e2c <ipc_send+0x1a>
  801e28:	85 f6                	test   %esi,%esi
  801e2a:	75 15                	jne    801e41 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e2c:	85 db                	test   %ebx,%ebx
  801e2e:	74 16                	je     801e46 <ipc_send+0x34>
  801e30:	85 f6                	test   %esi,%esi
  801e32:	0f 94 c0             	sete   %al
      pg = 0;
  801e35:	84 c0                	test   %al,%al
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	0f 45 d8             	cmovne %eax,%ebx
  801e3f:	eb 05                	jmp    801e46 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e46:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 74 f0 ff ff       	call   800ed1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e60:	75 07                	jne    801e69 <ipc_send+0x57>
           sys_yield();
  801e62:	e8 05 ee ff ff       	call   800c6c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e67:	eb dd                	jmp    801e46 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	90                   	nop
  801e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e70:	74 1c                	je     801e8e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e72:	c7 44 24 08 3c 26 80 	movl   $0x80263c,0x8(%esp)
  801e79:	00 
  801e7a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e81:	00 
  801e82:	c7 04 24 46 26 80 00 	movl   $0x802646,(%esp)
  801e89:	e8 d2 fe ff ff       	call   801d60 <_panic>
		}
    }
}
  801e8e:	83 c4 1c             	add    $0x1c,%esp
  801e91:	5b                   	pop    %ebx
  801e92:	5e                   	pop    %esi
  801e93:	5f                   	pop    %edi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    

00801e96 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e9c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801ea1:	39 c8                	cmp    %ecx,%eax
  801ea3:	74 17                	je     801ebc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ea5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801eaa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ead:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801eb3:	8b 52 50             	mov    0x50(%edx),%edx
  801eb6:	39 ca                	cmp    %ecx,%edx
  801eb8:	75 14                	jne    801ece <ipc_find_env+0x38>
  801eba:	eb 05                	jmp    801ec1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ec1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ec4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ec9:	8b 40 40             	mov    0x40(%eax),%eax
  801ecc:	eb 0e                	jmp    801edc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ece:	83 c0 01             	add    $0x1,%eax
  801ed1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ed6:	75 d2                	jne    801eaa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ed8:	66 b8 00 00          	mov    $0x0,%ax
}
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
	...

00801ee0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee6:	89 d0                	mov    %edx,%eax
  801ee8:	c1 e8 16             	shr    $0x16,%eax
  801eeb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ef7:	f6 c1 01             	test   $0x1,%cl
  801efa:	74 1d                	je     801f19 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801efc:	c1 ea 0c             	shr    $0xc,%edx
  801eff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f06:	f6 c2 01             	test   $0x1,%dl
  801f09:	74 0e                	je     801f19 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f0b:	c1 ea 0c             	shr    $0xc,%edx
  801f0e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f15:	ef 
  801f16:	0f b7 c0             	movzwl %ax,%eax
}
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
  801f1b:	00 00                	add    %al,(%eax)
  801f1d:	00 00                	add    %al,(%eax)
	...

00801f20 <__udivdi3>:
  801f20:	83 ec 1c             	sub    $0x1c,%esp
  801f23:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f27:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f2b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f2f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f33:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f37:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f3b:	85 ff                	test   %edi,%edi
  801f3d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f41:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f45:	89 cd                	mov    %ecx,%ebp
  801f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4b:	75 33                	jne    801f80 <__udivdi3+0x60>
  801f4d:	39 f1                	cmp    %esi,%ecx
  801f4f:	77 57                	ja     801fa8 <__udivdi3+0x88>
  801f51:	85 c9                	test   %ecx,%ecx
  801f53:	75 0b                	jne    801f60 <__udivdi3+0x40>
  801f55:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5a:	31 d2                	xor    %edx,%edx
  801f5c:	f7 f1                	div    %ecx
  801f5e:	89 c1                	mov    %eax,%ecx
  801f60:	89 f0                	mov    %esi,%eax
  801f62:	31 d2                	xor    %edx,%edx
  801f64:	f7 f1                	div    %ecx
  801f66:	89 c6                	mov    %eax,%esi
  801f68:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6c:	f7 f1                	div    %ecx
  801f6e:	89 f2                	mov    %esi,%edx
  801f70:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f74:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f78:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f7c:	83 c4 1c             	add    $0x1c,%esp
  801f7f:	c3                   	ret    
  801f80:	31 d2                	xor    %edx,%edx
  801f82:	31 c0                	xor    %eax,%eax
  801f84:	39 f7                	cmp    %esi,%edi
  801f86:	77 e8                	ja     801f70 <__udivdi3+0x50>
  801f88:	0f bd cf             	bsr    %edi,%ecx
  801f8b:	83 f1 1f             	xor    $0x1f,%ecx
  801f8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f92:	75 2c                	jne    801fc0 <__udivdi3+0xa0>
  801f94:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f98:	76 04                	jbe    801f9e <__udivdi3+0x7e>
  801f9a:	39 f7                	cmp    %esi,%edi
  801f9c:	73 d2                	jae    801f70 <__udivdi3+0x50>
  801f9e:	31 d2                	xor    %edx,%edx
  801fa0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa5:	eb c9                	jmp    801f70 <__udivdi3+0x50>
  801fa7:	90                   	nop
  801fa8:	89 f2                	mov    %esi,%edx
  801faa:	f7 f1                	div    %ecx
  801fac:	31 d2                	xor    %edx,%edx
  801fae:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fb2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fb6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801fba:	83 c4 1c             	add    $0x1c,%esp
  801fbd:	c3                   	ret    
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fc5:	b8 20 00 00 00       	mov    $0x20,%eax
  801fca:	89 ea                	mov    %ebp,%edx
  801fcc:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fd0:	d3 e7                	shl    %cl,%edi
  801fd2:	89 c1                	mov    %eax,%ecx
  801fd4:	d3 ea                	shr    %cl,%edx
  801fd6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fdb:	09 fa                	or     %edi,%edx
  801fdd:	89 f7                	mov    %esi,%edi
  801fdf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fe3:	89 f2                	mov    %esi,%edx
  801fe5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fe9:	d3 e5                	shl    %cl,%ebp
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	d3 ef                	shr    %cl,%edi
  801fef:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ff4:	d3 e2                	shl    %cl,%edx
  801ff6:	89 c1                	mov    %eax,%ecx
  801ff8:	d3 ee                	shr    %cl,%esi
  801ffa:	09 d6                	or     %edx,%esi
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	89 f0                	mov    %esi,%eax
  802000:	f7 74 24 0c          	divl   0xc(%esp)
  802004:	89 d7                	mov    %edx,%edi
  802006:	89 c6                	mov    %eax,%esi
  802008:	f7 e5                	mul    %ebp
  80200a:	39 d7                	cmp    %edx,%edi
  80200c:	72 22                	jb     802030 <__udivdi3+0x110>
  80200e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802012:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802017:	d3 e5                	shl    %cl,%ebp
  802019:	39 c5                	cmp    %eax,%ebp
  80201b:	73 04                	jae    802021 <__udivdi3+0x101>
  80201d:	39 d7                	cmp    %edx,%edi
  80201f:	74 0f                	je     802030 <__udivdi3+0x110>
  802021:	89 f0                	mov    %esi,%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	e9 46 ff ff ff       	jmp    801f70 <__udivdi3+0x50>
  80202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802030:	8d 46 ff             	lea    -0x1(%esi),%eax
  802033:	31 d2                	xor    %edx,%edx
  802035:	8b 74 24 10          	mov    0x10(%esp),%esi
  802039:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80203d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802041:	83 c4 1c             	add    $0x1c,%esp
  802044:	c3                   	ret    
	...

00802050 <__umoddi3>:
  802050:	83 ec 1c             	sub    $0x1c,%esp
  802053:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802057:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80205b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80205f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802063:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802067:	8b 74 24 24          	mov    0x24(%esp),%esi
  80206b:	85 ed                	test   %ebp,%ebp
  80206d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802071:	89 44 24 08          	mov    %eax,0x8(%esp)
  802075:	89 cf                	mov    %ecx,%edi
  802077:	89 04 24             	mov    %eax,(%esp)
  80207a:	89 f2                	mov    %esi,%edx
  80207c:	75 1a                	jne    802098 <__umoddi3+0x48>
  80207e:	39 f1                	cmp    %esi,%ecx
  802080:	76 4e                	jbe    8020d0 <__umoddi3+0x80>
  802082:	f7 f1                	div    %ecx
  802084:	89 d0                	mov    %edx,%eax
  802086:	31 d2                	xor    %edx,%edx
  802088:	8b 74 24 10          	mov    0x10(%esp),%esi
  80208c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802090:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	c3                   	ret    
  802098:	39 f5                	cmp    %esi,%ebp
  80209a:	77 54                	ja     8020f0 <__umoddi3+0xa0>
  80209c:	0f bd c5             	bsr    %ebp,%eax
  80209f:	83 f0 1f             	xor    $0x1f,%eax
  8020a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a6:	75 60                	jne    802108 <__umoddi3+0xb8>
  8020a8:	3b 0c 24             	cmp    (%esp),%ecx
  8020ab:	0f 87 07 01 00 00    	ja     8021b8 <__umoddi3+0x168>
  8020b1:	89 f2                	mov    %esi,%edx
  8020b3:	8b 34 24             	mov    (%esp),%esi
  8020b6:	29 ce                	sub    %ecx,%esi
  8020b8:	19 ea                	sbb    %ebp,%edx
  8020ba:	89 34 24             	mov    %esi,(%esp)
  8020bd:	8b 04 24             	mov    (%esp),%eax
  8020c0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020c4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020c8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	c3                   	ret    
  8020d0:	85 c9                	test   %ecx,%ecx
  8020d2:	75 0b                	jne    8020df <__umoddi3+0x8f>
  8020d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d9:	31 d2                	xor    %edx,%edx
  8020db:	f7 f1                	div    %ecx
  8020dd:	89 c1                	mov    %eax,%ecx
  8020df:	89 f0                	mov    %esi,%eax
  8020e1:	31 d2                	xor    %edx,%edx
  8020e3:	f7 f1                	div    %ecx
  8020e5:	8b 04 24             	mov    (%esp),%eax
  8020e8:	f7 f1                	div    %ecx
  8020ea:	eb 98                	jmp    802084 <__umoddi3+0x34>
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	89 f2                	mov    %esi,%edx
  8020f2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020f6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020fa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020fe:	83 c4 1c             	add    $0x1c,%esp
  802101:	c3                   	ret    
  802102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802108:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80210d:	89 e8                	mov    %ebp,%eax
  80210f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802114:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802118:	89 fa                	mov    %edi,%edx
  80211a:	d3 e0                	shl    %cl,%eax
  80211c:	89 e9                	mov    %ebp,%ecx
  80211e:	d3 ea                	shr    %cl,%edx
  802120:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802125:	09 c2                	or     %eax,%edx
  802127:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212b:	89 14 24             	mov    %edx,(%esp)
  80212e:	89 f2                	mov    %esi,%edx
  802130:	d3 e7                	shl    %cl,%edi
  802132:	89 e9                	mov    %ebp,%ecx
  802134:	d3 ea                	shr    %cl,%edx
  802136:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80213f:	d3 e6                	shl    %cl,%esi
  802141:	89 e9                	mov    %ebp,%ecx
  802143:	d3 e8                	shr    %cl,%eax
  802145:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80214a:	09 f0                	or     %esi,%eax
  80214c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802150:	f7 34 24             	divl   (%esp)
  802153:	d3 e6                	shl    %cl,%esi
  802155:	89 74 24 08          	mov    %esi,0x8(%esp)
  802159:	89 d6                	mov    %edx,%esi
  80215b:	f7 e7                	mul    %edi
  80215d:	39 d6                	cmp    %edx,%esi
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 d7                	mov    %edx,%edi
  802163:	72 3f                	jb     8021a4 <__umoddi3+0x154>
  802165:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802169:	72 35                	jb     8021a0 <__umoddi3+0x150>
  80216b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80216f:	29 c8                	sub    %ecx,%eax
  802171:	19 fe                	sbb    %edi,%esi
  802173:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802178:	89 f2                	mov    %esi,%edx
  80217a:	d3 e8                	shr    %cl,%eax
  80217c:	89 e9                	mov    %ebp,%ecx
  80217e:	d3 e2                	shl    %cl,%edx
  802180:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802185:	09 d0                	or     %edx,%eax
  802187:	89 f2                	mov    %esi,%edx
  802189:	d3 ea                	shr    %cl,%edx
  80218b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80218f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802193:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802197:	83 c4 1c             	add    $0x1c,%esp
  80219a:	c3                   	ret    
  80219b:	90                   	nop
  80219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	39 d6                	cmp    %edx,%esi
  8021a2:	75 c7                	jne    80216b <__umoddi3+0x11b>
  8021a4:	89 d7                	mov    %edx,%edi
  8021a6:	89 c1                	mov    %eax,%ecx
  8021a8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8021ac:	1b 3c 24             	sbb    (%esp),%edi
  8021af:	eb ba                	jmp    80216b <__umoddi3+0x11b>
  8021b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b8:	39 f5                	cmp    %esi,%ebp
  8021ba:	0f 82 f1 fe ff ff    	jb     8020b1 <__umoddi3+0x61>
  8021c0:	e9 f8 fe ff ff       	jmp    8020bd <__umoddi3+0x6d>
