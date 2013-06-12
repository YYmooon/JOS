
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  80003a:	c7 04 24 c0 21 80 00 	movl   $0x8021c0,(%esp)
  800041:	e8 29 01 00 00       	call   80016f <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800046:	a1 04 40 80 00       	mov    0x804004,%eax
  80004b:	8b 40 48             	mov    0x48(%eax),%eax
  80004e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800052:	c7 04 24 ce 21 80 00 	movl   $0x8021ce,(%esp)
  800059:	e8 11 01 00 00       	call   80016f <cprintf>
}
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	83 ec 18             	sub    $0x18,%esp
  800066:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800069:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80006c:	8b 75 08             	mov    0x8(%ebp),%esi
  80006f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800072:	e8 b5 0b 00 00       	call   800c2c <sys_getenvid>
  800077:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800084:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800089:	85 f6                	test   %esi,%esi
  80008b:	7e 07                	jle    800094 <libmain+0x34>
		binaryname = argv[0];
  80008d:	8b 03                	mov    (%ebx),%eax
  80008f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800094:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800098:	89 34 24             	mov    %esi,(%esp)
  80009b:	e8 94 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000a0:	e8 0b 00 00 00       	call   8000b0 <exit>
}
  8000a5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000ab:	89 ec                	mov    %ebp,%esp
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    
	...

008000b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b6:	e8 c3 10 00 00       	call   80117e <close_all>
	sys_env_destroy(0);
  8000bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c2:	e8 08 0b 00 00       	call   800bcf <sys_env_destroy>
}
  8000c7:	c9                   	leave  
  8000c8:	c3                   	ret    
  8000c9:	00 00                	add    %al,(%eax)
	...

008000cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	53                   	push   %ebx
  8000d0:	83 ec 14             	sub    $0x14,%esp
  8000d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d6:	8b 03                	mov    (%ebx),%eax
  8000d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000db:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8000df:	83 c0 01             	add    $0x1,%eax
  8000e2:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8000e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e9:	75 19                	jne    800104 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000eb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000f2:	00 
  8000f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f6:	89 04 24             	mov    %eax,(%esp)
  8000f9:	e8 72 0a 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  8000fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800104:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800108:	83 c4 14             	add    $0x14,%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800117:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011e:	00 00 00 
	b.cnt = 0;
  800121:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800128:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80012b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800132:	8b 45 08             	mov    0x8(%ebp),%eax
  800135:	89 44 24 08          	mov    %eax,0x8(%esp)
  800139:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	c7 04 24 cc 00 80 00 	movl   $0x8000cc,(%esp)
  80014a:	e8 9b 01 00 00       	call   8002ea <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800155:	89 44 24 04          	mov    %eax,0x4(%esp)
  800159:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015f:	89 04 24             	mov    %eax,(%esp)
  800162:	e8 09 0a 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  800167:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800175:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 87 ff ff ff       	call   80010e <vcprintf>
	va_end(ap);

	return cnt;
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    
  800189:	00 00                	add    %al,(%eax)
  80018b:	00 00                	add    %al,(%eax)
  80018d:	00 00                	add    %al,(%eax)
	...

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 3c             	sub    $0x3c,%esp
  800199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001ad:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001b8:	72 11                	jb     8001cb <printnum+0x3b>
  8001ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001bd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001c0:	76 09                	jbe    8001cb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001c2:	83 eb 01             	sub    $0x1,%ebx
  8001c5:	85 db                	test   %ebx,%ebx
  8001c7:	7f 51                	jg     80021a <printnum+0x8a>
  8001c9:	eb 5e                	jmp    800229 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001cb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8001cf:	83 eb 01             	sub    $0x1,%ebx
  8001d2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001dd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8001e1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8001e5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001ec:	00 
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	89 04 24             	mov    %eax,(%esp)
  8001f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fa:	e8 11 1d 00 00       	call   801f10 <__udivdi3>
  8001ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800203:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800207:	89 04 24             	mov    %eax,(%esp)
  80020a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80020e:	89 fa                	mov    %edi,%edx
  800210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800213:	e8 78 ff ff ff       	call   800190 <printnum>
  800218:	eb 0f                	jmp    800229 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80021a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80021e:	89 34 24             	mov    %esi,(%esp)
  800221:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	75 f1                	jne    80021a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800229:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80022d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800231:	8b 45 10             	mov    0x10(%ebp),%eax
  800234:	89 44 24 08          	mov    %eax,0x8(%esp)
  800238:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80023f:	00 
  800240:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800243:	89 04 24             	mov    %eax,(%esp)
  800246:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024d:	e8 ee 1d 00 00       	call   802040 <__umoddi3>
  800252:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800256:	0f be 80 ef 21 80 00 	movsbl 0x8021ef(%eax),%eax
  80025d:	89 04 24             	mov    %eax,(%esp)
  800260:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800263:	83 c4 3c             	add    $0x3c,%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80026e:	83 fa 01             	cmp    $0x1,%edx
  800271:	7e 0e                	jle    800281 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800273:	8b 10                	mov    (%eax),%edx
  800275:	8d 4a 08             	lea    0x8(%edx),%ecx
  800278:	89 08                	mov    %ecx,(%eax)
  80027a:	8b 02                	mov    (%edx),%eax
  80027c:	8b 52 04             	mov    0x4(%edx),%edx
  80027f:	eb 22                	jmp    8002a3 <getuint+0x38>
	else if (lflag)
  800281:	85 d2                	test   %edx,%edx
  800283:	74 10                	je     800295 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800285:	8b 10                	mov    (%eax),%edx
  800287:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028a:	89 08                	mov    %ecx,(%eax)
  80028c:	8b 02                	mov    (%edx),%eax
  80028e:	ba 00 00 00 00       	mov    $0x0,%edx
  800293:	eb 0e                	jmp    8002a3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800295:	8b 10                	mov    (%eax),%edx
  800297:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 02                	mov    (%edx),%eax
  80029e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ab:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002af:	8b 10                	mov    (%eax),%edx
  8002b1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b4:	73 0a                	jae    8002c0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b9:	88 0a                	mov    %cl,(%edx)
  8002bb:	83 c2 01             	add    $0x1,%edx
  8002be:	89 10                	mov    %edx,(%eax)
}
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    

008002c2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002c8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	89 04 24             	mov    %eax,(%esp)
  8002e3:	e8 02 00 00 00       	call   8002ea <vprintfmt>
	va_end(ap);
}
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	57                   	push   %edi
  8002ee:	56                   	push   %esi
  8002ef:	53                   	push   %ebx
  8002f0:	83 ec 4c             	sub    $0x4c,%esp
  8002f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f6:	8b 75 10             	mov    0x10(%ebp),%esi
  8002f9:	eb 12                	jmp    80030d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002fb:	85 c0                	test   %eax,%eax
  8002fd:	0f 84 a9 03 00 00    	je     8006ac <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800303:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800307:	89 04 24             	mov    %eax,(%esp)
  80030a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80030d:	0f b6 06             	movzbl (%esi),%eax
  800310:	83 c6 01             	add    $0x1,%esi
  800313:	83 f8 25             	cmp    $0x25,%eax
  800316:	75 e3                	jne    8002fb <vprintfmt+0x11>
  800318:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80031c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800323:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800328:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80032f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800334:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800337:	eb 2b                	jmp    800364 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800339:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80033c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800340:	eb 22                	jmp    800364 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800345:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800349:	eb 19                	jmp    800364 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80034e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800355:	eb 0d                	jmp    800364 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800364:	0f b6 06             	movzbl (%esi),%eax
  800367:	0f b6 d0             	movzbl %al,%edx
  80036a:	8d 7e 01             	lea    0x1(%esi),%edi
  80036d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800370:	83 e8 23             	sub    $0x23,%eax
  800373:	3c 55                	cmp    $0x55,%al
  800375:	0f 87 0b 03 00 00    	ja     800686 <vprintfmt+0x39c>
  80037b:	0f b6 c0             	movzbl %al,%eax
  80037e:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800385:	83 ea 30             	sub    $0x30,%edx
  800388:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80038b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80038f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800392:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800395:	83 fa 09             	cmp    $0x9,%edx
  800398:	77 4a                	ja     8003e4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80039d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003a0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8003a3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8003a7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003aa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003ad:	83 fa 09             	cmp    $0x9,%edx
  8003b0:	76 eb                	jbe    80039d <vprintfmt+0xb3>
  8003b2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003b5:	eb 2d                	jmp    8003e4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8d 50 04             	lea    0x4(%eax),%edx
  8003bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003c8:	eb 1a                	jmp    8003e4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003d1:	79 91                	jns    800364 <vprintfmt+0x7a>
  8003d3:	e9 73 ff ff ff       	jmp    80034b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003db:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8003e2:	eb 80                	jmp    800364 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8003e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003e8:	0f 89 76 ff ff ff    	jns    800364 <vprintfmt+0x7a>
  8003ee:	e9 64 ff ff ff       	jmp    800357 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003f3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003f9:	e9 66 ff ff ff       	jmp    800364 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 50 04             	lea    0x4(%eax),%edx
  800404:	89 55 14             	mov    %edx,0x14(%ebp)
  800407:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	89 04 24             	mov    %eax,(%esp)
  800410:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800416:	e9 f2 fe ff ff       	jmp    80030d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8d 50 04             	lea    0x4(%eax),%edx
  800421:	89 55 14             	mov    %edx,0x14(%ebp)
  800424:	8b 00                	mov    (%eax),%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	c1 fa 1f             	sar    $0x1f,%edx
  80042b:	31 d0                	xor    %edx,%eax
  80042d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042f:	83 f8 0f             	cmp    $0xf,%eax
  800432:	7f 0b                	jg     80043f <vprintfmt+0x155>
  800434:	8b 14 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%edx
  80043b:	85 d2                	test   %edx,%edx
  80043d:	75 23                	jne    800462 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80043f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800443:	c7 44 24 08 07 22 80 	movl   $0x802207,0x8(%esp)
  80044a:	00 
  80044b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80044f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800452:	89 3c 24             	mov    %edi,(%esp)
  800455:	e8 68 fe ff ff       	call   8002c2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80045d:	e9 ab fe ff ff       	jmp    80030d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800462:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800466:	c7 44 24 08 d1 25 80 	movl   $0x8025d1,0x8(%esp)
  80046d:	00 
  80046e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800472:	8b 7d 08             	mov    0x8(%ebp),%edi
  800475:	89 3c 24             	mov    %edi,(%esp)
  800478:	e8 45 fe ff ff       	call   8002c2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800480:	e9 88 fe ff ff       	jmp    80030d <vprintfmt+0x23>
  800485:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80048b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8d 50 04             	lea    0x4(%eax),%edx
  800494:	89 55 14             	mov    %edx,0x14(%ebp)
  800497:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800499:	85 f6                	test   %esi,%esi
  80049b:	ba 00 22 80 00       	mov    $0x802200,%edx
  8004a0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8004a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a7:	7e 06                	jle    8004af <vprintfmt+0x1c5>
  8004a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004ad:	75 10                	jne    8004bf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004af:	0f be 06             	movsbl (%esi),%eax
  8004b2:	83 c6 01             	add    $0x1,%esi
  8004b5:	85 c0                	test   %eax,%eax
  8004b7:	0f 85 86 00 00 00    	jne    800543 <vprintfmt+0x259>
  8004bd:	eb 76                	jmp    800535 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c3:	89 34 24             	mov    %esi,(%esp)
  8004c6:	e8 90 02 00 00       	call   80075b <strnlen>
  8004cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004ce:	29 c2                	sub    %eax,%edx
  8004d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d3:	85 d2                	test   %edx,%edx
  8004d5:	7e d8                	jle    8004af <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8004de:	89 d6                	mov    %edx,%esi
  8004e0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8004e3:	89 c7                	mov    %eax,%edi
  8004e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004e9:	89 3c 24             	mov    %edi,(%esp)
  8004ec:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ef:	83 ee 01             	sub    $0x1,%esi
  8004f2:	75 f1                	jne    8004e5 <vprintfmt+0x1fb>
  8004f4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8004f7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8004fa:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8004fd:	eb b0                	jmp    8004af <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800503:	74 18                	je     80051d <vprintfmt+0x233>
  800505:	8d 50 e0             	lea    -0x20(%eax),%edx
  800508:	83 fa 5e             	cmp    $0x5e,%edx
  80050b:	76 10                	jbe    80051d <vprintfmt+0x233>
					putch('?', putdat);
  80050d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800511:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800518:	ff 55 08             	call   *0x8(%ebp)
  80051b:	eb 0a                	jmp    800527 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80051d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800521:	89 04 24             	mov    %eax,(%esp)
  800524:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800527:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80052b:	0f be 06             	movsbl (%esi),%eax
  80052e:	83 c6 01             	add    $0x1,%esi
  800531:	85 c0                	test   %eax,%eax
  800533:	75 0e                	jne    800543 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053c:	7f 16                	jg     800554 <vprintfmt+0x26a>
  80053e:	e9 ca fd ff ff       	jmp    80030d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800543:	85 ff                	test   %edi,%edi
  800545:	78 b8                	js     8004ff <vprintfmt+0x215>
  800547:	83 ef 01             	sub    $0x1,%edi
  80054a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800550:	79 ad                	jns    8004ff <vprintfmt+0x215>
  800552:	eb e1                	jmp    800535 <vprintfmt+0x24b>
  800554:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800557:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80055a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80055e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800565:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800567:	83 ee 01             	sub    $0x1,%esi
  80056a:	75 ee                	jne    80055a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80056f:	e9 99 fd ff ff       	jmp    80030d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800574:	83 f9 01             	cmp    $0x1,%ecx
  800577:	7e 10                	jle    800589 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	89 55 14             	mov    %edx,0x14(%ebp)
  800582:	8b 30                	mov    (%eax),%esi
  800584:	8b 78 04             	mov    0x4(%eax),%edi
  800587:	eb 26                	jmp    8005af <vprintfmt+0x2c5>
	else if (lflag)
  800589:	85 c9                	test   %ecx,%ecx
  80058b:	74 12                	je     80059f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 50 04             	lea    0x4(%eax),%edx
  800593:	89 55 14             	mov    %edx,0x14(%ebp)
  800596:	8b 30                	mov    (%eax),%esi
  800598:	89 f7                	mov    %esi,%edi
  80059a:	c1 ff 1f             	sar    $0x1f,%edi
  80059d:	eb 10                	jmp    8005af <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a8:	8b 30                	mov    (%eax),%esi
  8005aa:	89 f7                	mov    %esi,%edi
  8005ac:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005b4:	85 ff                	test   %edi,%edi
  8005b6:	0f 89 8c 00 00 00    	jns    800648 <vprintfmt+0x35e>
				putch('-', putdat);
  8005bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005c7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005ca:	f7 de                	neg    %esi
  8005cc:	83 d7 00             	adc    $0x0,%edi
  8005cf:	f7 df                	neg    %edi
			}
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	eb 70                	jmp    800648 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005d8:	89 ca                	mov    %ecx,%edx
  8005da:	8d 45 14             	lea    0x14(%ebp),%eax
  8005dd:	e8 89 fc ff ff       	call   80026b <getuint>
  8005e2:	89 c6                	mov    %eax,%esi
  8005e4:	89 d7                	mov    %edx,%edi
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8005eb:	eb 5b                	jmp    800648 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005ed:	89 ca                	mov    %ecx,%edx
  8005ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f2:	e8 74 fc ff ff       	call   80026b <getuint>
  8005f7:	89 c6                	mov    %eax,%esi
  8005f9:	89 d7                	mov    %edx,%edi
			base = 8;
  8005fb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800600:	eb 46                	jmp    800648 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800602:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800606:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80060d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800610:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800614:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80061b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 50 04             	lea    0x4(%eax),%edx
  800624:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800627:	8b 30                	mov    (%eax),%esi
  800629:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80062e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800633:	eb 13                	jmp    800648 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800635:	89 ca                	mov    %ecx,%edx
  800637:	8d 45 14             	lea    0x14(%ebp),%eax
  80063a:	e8 2c fc ff ff       	call   80026b <getuint>
  80063f:	89 c6                	mov    %eax,%esi
  800641:	89 d7                	mov    %edx,%edi
			base = 16;
  800643:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800648:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80064c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800653:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800657:	89 44 24 08          	mov    %eax,0x8(%esp)
  80065b:	89 34 24             	mov    %esi,(%esp)
  80065e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800662:	89 da                	mov    %ebx,%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	e8 24 fb ff ff       	call   800190 <printnum>
			break;
  80066c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80066f:	e9 99 fc ff ff       	jmp    80030d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800674:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800678:	89 14 24             	mov    %edx,(%esp)
  80067b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800681:	e9 87 fc ff ff       	jmp    80030d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800686:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80068a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800691:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800694:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800698:	0f 84 6f fc ff ff    	je     80030d <vprintfmt+0x23>
  80069e:	83 ee 01             	sub    $0x1,%esi
  8006a1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006a5:	75 f7                	jne    80069e <vprintfmt+0x3b4>
  8006a7:	e9 61 fc ff ff       	jmp    80030d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8006ac:	83 c4 4c             	add    $0x4c,%esp
  8006af:	5b                   	pop    %ebx
  8006b0:	5e                   	pop    %esi
  8006b1:	5f                   	pop    %edi
  8006b2:	5d                   	pop    %ebp
  8006b3:	c3                   	ret    

008006b4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 28             	sub    $0x28,%esp
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	74 30                	je     800705 <vsnprintf+0x51>
  8006d5:	85 d2                	test   %edx,%edx
  8006d7:	7e 2c                	jle    800705 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ee:	c7 04 24 a5 02 80 00 	movl   $0x8002a5,(%esp)
  8006f5:	e8 f0 fb ff ff       	call   8002ea <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800703:	eb 05                	jmp    80070a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800705:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80070a:	c9                   	leave  
  80070b:	c3                   	ret    

0080070c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800712:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800715:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800719:	8b 45 10             	mov    0x10(%ebp),%eax
  80071c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	89 44 24 04          	mov    %eax,0x4(%esp)
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	89 04 24             	mov    %eax,(%esp)
  80072d:	e8 82 ff ff ff       	call   8006b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800732:	c9                   	leave  
  800733:	c3                   	ret    
	...

00800740 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
  80074b:	80 3a 00             	cmpb   $0x0,(%edx)
  80074e:	74 09                	je     800759 <strlen+0x19>
		n++;
  800750:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800753:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800757:	75 f7                	jne    800750 <strlen+0x10>
		n++;
	return n;
}
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	53                   	push   %ebx
  80075f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800762:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800765:	b8 00 00 00 00       	mov    $0x0,%eax
  80076a:	85 c9                	test   %ecx,%ecx
  80076c:	74 1a                	je     800788 <strnlen+0x2d>
  80076e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800771:	74 15                	je     800788 <strnlen+0x2d>
  800773:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800778:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077a:	39 ca                	cmp    %ecx,%edx
  80077c:	74 0a                	je     800788 <strnlen+0x2d>
  80077e:	83 c2 01             	add    $0x1,%edx
  800781:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800786:	75 f0                	jne    800778 <strnlen+0x1d>
		n++;
	return n;
}
  800788:	5b                   	pop    %ebx
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80079e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007a1:	83 c2 01             	add    $0x1,%edx
  8007a4:	84 c9                	test   %cl,%cl
  8007a6:	75 f2                	jne    80079a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007a8:	5b                   	pop    %ebx
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b5:	89 1c 24             	mov    %ebx,(%esp)
  8007b8:	e8 83 ff ff ff       	call   800740 <strlen>
	strcpy(dst + len, src);
  8007bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c4:	01 d8                	add    %ebx,%eax
  8007c6:	89 04 24             	mov    %eax,(%esp)
  8007c9:	e8 bd ff ff ff       	call   80078b <strcpy>
	return dst;
}
  8007ce:	89 d8                	mov    %ebx,%eax
  8007d0:	83 c4 08             	add    $0x8,%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e4:	85 f6                	test   %esi,%esi
  8007e6:	74 18                	je     800800 <strncpy+0x2a>
  8007e8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8007ed:	0f b6 1a             	movzbl (%edx),%ebx
  8007f0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f3:	80 3a 01             	cmpb   $0x1,(%edx)
  8007f6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f9:	83 c1 01             	add    $0x1,%ecx
  8007fc:	39 f1                	cmp    %esi,%ecx
  8007fe:	75 ed                	jne    8007ed <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800800:	5b                   	pop    %ebx
  800801:	5e                   	pop    %esi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	57                   	push   %edi
  800808:	56                   	push   %esi
  800809:	53                   	push   %ebx
  80080a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80080d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800810:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800813:	89 f8                	mov    %edi,%eax
  800815:	85 f6                	test   %esi,%esi
  800817:	74 2b                	je     800844 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800819:	83 fe 01             	cmp    $0x1,%esi
  80081c:	74 23                	je     800841 <strlcpy+0x3d>
  80081e:	0f b6 0b             	movzbl (%ebx),%ecx
  800821:	84 c9                	test   %cl,%cl
  800823:	74 1c                	je     800841 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800825:	83 ee 02             	sub    $0x2,%esi
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80082d:	88 08                	mov    %cl,(%eax)
  80082f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800832:	39 f2                	cmp    %esi,%edx
  800834:	74 0b                	je     800841 <strlcpy+0x3d>
  800836:	83 c2 01             	add    $0x1,%edx
  800839:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80083d:	84 c9                	test   %cl,%cl
  80083f:	75 ec                	jne    80082d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800841:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800844:	29 f8                	sub    %edi,%eax
}
  800846:	5b                   	pop    %ebx
  800847:	5e                   	pop    %esi
  800848:	5f                   	pop    %edi
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800854:	0f b6 01             	movzbl (%ecx),%eax
  800857:	84 c0                	test   %al,%al
  800859:	74 16                	je     800871 <strcmp+0x26>
  80085b:	3a 02                	cmp    (%edx),%al
  80085d:	75 12                	jne    800871 <strcmp+0x26>
		p++, q++;
  80085f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800862:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800866:	84 c0                	test   %al,%al
  800868:	74 07                	je     800871 <strcmp+0x26>
  80086a:	83 c1 01             	add    $0x1,%ecx
  80086d:	3a 02                	cmp    (%edx),%al
  80086f:	74 ee                	je     80085f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800871:	0f b6 c0             	movzbl %al,%eax
  800874:	0f b6 12             	movzbl (%edx),%edx
  800877:	29 d0                	sub    %edx,%eax
}
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800882:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800885:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800888:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80088d:	85 d2                	test   %edx,%edx
  80088f:	74 28                	je     8008b9 <strncmp+0x3e>
  800891:	0f b6 01             	movzbl (%ecx),%eax
  800894:	84 c0                	test   %al,%al
  800896:	74 24                	je     8008bc <strncmp+0x41>
  800898:	3a 03                	cmp    (%ebx),%al
  80089a:	75 20                	jne    8008bc <strncmp+0x41>
  80089c:	83 ea 01             	sub    $0x1,%edx
  80089f:	74 13                	je     8008b4 <strncmp+0x39>
		n--, p++, q++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	84 c0                	test   %al,%al
  8008ac:	74 0e                	je     8008bc <strncmp+0x41>
  8008ae:	3a 03                	cmp    (%ebx),%al
  8008b0:	74 ea                	je     80089c <strncmp+0x21>
  8008b2:	eb 08                	jmp    8008bc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008b9:	5b                   	pop    %ebx
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bc:	0f b6 01             	movzbl (%ecx),%eax
  8008bf:	0f b6 13             	movzbl (%ebx),%edx
  8008c2:	29 d0                	sub    %edx,%eax
  8008c4:	eb f3                	jmp    8008b9 <strncmp+0x3e>

008008c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d0:	0f b6 10             	movzbl (%eax),%edx
  8008d3:	84 d2                	test   %dl,%dl
  8008d5:	74 1c                	je     8008f3 <strchr+0x2d>
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	75 09                	jne    8008e4 <strchr+0x1e>
  8008db:	eb 1b                	jmp    8008f8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008dd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8008e0:	38 ca                	cmp    %cl,%dl
  8008e2:	74 14                	je     8008f8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008e4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8008e8:	84 d2                	test   %dl,%dl
  8008ea:	75 f1                	jne    8008dd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	eb 05                	jmp    8008f8 <strchr+0x32>
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800904:	0f b6 10             	movzbl (%eax),%edx
  800907:	84 d2                	test   %dl,%dl
  800909:	74 14                	je     80091f <strfind+0x25>
		if (*s == c)
  80090b:	38 ca                	cmp    %cl,%dl
  80090d:	75 06                	jne    800915 <strfind+0x1b>
  80090f:	eb 0e                	jmp    80091f <strfind+0x25>
  800911:	38 ca                	cmp    %cl,%dl
  800913:	74 0a                	je     80091f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800915:	83 c0 01             	add    $0x1,%eax
  800918:	0f b6 10             	movzbl (%eax),%edx
  80091b:	84 d2                	test   %dl,%dl
  80091d:	75 f2                	jne    800911 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	83 ec 0c             	sub    $0xc,%esp
  800927:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80092a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80092d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800930:	8b 7d 08             	mov    0x8(%ebp),%edi
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800939:	85 c9                	test   %ecx,%ecx
  80093b:	74 30                	je     80096d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80093d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800943:	75 25                	jne    80096a <memset+0x49>
  800945:	f6 c1 03             	test   $0x3,%cl
  800948:	75 20                	jne    80096a <memset+0x49>
		c &= 0xFF;
  80094a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80094d:	89 d3                	mov    %edx,%ebx
  80094f:	c1 e3 08             	shl    $0x8,%ebx
  800952:	89 d6                	mov    %edx,%esi
  800954:	c1 e6 18             	shl    $0x18,%esi
  800957:	89 d0                	mov    %edx,%eax
  800959:	c1 e0 10             	shl    $0x10,%eax
  80095c:	09 f0                	or     %esi,%eax
  80095e:	09 d0                	or     %edx,%eax
  800960:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800962:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800965:	fc                   	cld    
  800966:	f3 ab                	rep stos %eax,%es:(%edi)
  800968:	eb 03                	jmp    80096d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096a:	fc                   	cld    
  80096b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80096d:	89 f8                	mov    %edi,%eax
  80096f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800972:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800975:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800978:	89 ec                	mov    %ebp,%esp
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800985:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800991:	39 c6                	cmp    %eax,%esi
  800993:	73 36                	jae    8009cb <memmove+0x4f>
  800995:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800998:	39 d0                	cmp    %edx,%eax
  80099a:	73 2f                	jae    8009cb <memmove+0x4f>
		s += n;
		d += n;
  80099c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099f:	f6 c2 03             	test   $0x3,%dl
  8009a2:	75 1b                	jne    8009bf <memmove+0x43>
  8009a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009aa:	75 13                	jne    8009bf <memmove+0x43>
  8009ac:	f6 c1 03             	test   $0x3,%cl
  8009af:	75 0e                	jne    8009bf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b1:	83 ef 04             	sub    $0x4,%edi
  8009b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ba:	fd                   	std    
  8009bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bd:	eb 09                	jmp    8009c8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009bf:	83 ef 01             	sub    $0x1,%edi
  8009c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009c5:	fd                   	std    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c8:	fc                   	cld    
  8009c9:	eb 20                	jmp    8009eb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d1:	75 13                	jne    8009e6 <memmove+0x6a>
  8009d3:	a8 03                	test   $0x3,%al
  8009d5:	75 0f                	jne    8009e6 <memmove+0x6a>
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 0a                	jne    8009e6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb 05                	jmp    8009eb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009e6:	89 c7                	mov    %eax,%edi
  8009e8:	fc                   	cld    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009f1:	89 ec                	mov    %ebp,%esp
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	89 04 24             	mov    %eax,(%esp)
  800a0f:	e8 68 ff ff ff       	call   80097c <memmove>
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	57                   	push   %edi
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a22:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2a:	85 ff                	test   %edi,%edi
  800a2c:	74 37                	je     800a65 <memcmp+0x4f>
		if (*s1 != *s2)
  800a2e:	0f b6 03             	movzbl (%ebx),%eax
  800a31:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a34:	83 ef 01             	sub    $0x1,%edi
  800a37:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a3c:	38 c8                	cmp    %cl,%al
  800a3e:	74 1c                	je     800a5c <memcmp+0x46>
  800a40:	eb 10                	jmp    800a52 <memcmp+0x3c>
  800a42:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a47:	83 c2 01             	add    $0x1,%edx
  800a4a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a4e:	38 c8                	cmp    %cl,%al
  800a50:	74 0a                	je     800a5c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800a52:	0f b6 c0             	movzbl %al,%eax
  800a55:	0f b6 c9             	movzbl %cl,%ecx
  800a58:	29 c8                	sub    %ecx,%eax
  800a5a:	eb 09                	jmp    800a65 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5c:	39 fa                	cmp    %edi,%edx
  800a5e:	75 e2                	jne    800a42 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a70:	89 c2                	mov    %eax,%edx
  800a72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a75:	39 d0                	cmp    %edx,%eax
  800a77:	73 19                	jae    800a92 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a79:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800a7d:	38 08                	cmp    %cl,(%eax)
  800a7f:	75 06                	jne    800a87 <memfind+0x1d>
  800a81:	eb 0f                	jmp    800a92 <memfind+0x28>
  800a83:	38 08                	cmp    %cl,(%eax)
  800a85:	74 0b                	je     800a92 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	39 d0                	cmp    %edx,%eax
  800a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a90:	75 f1                	jne    800a83 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	57                   	push   %edi
  800a98:	56                   	push   %esi
  800a99:	53                   	push   %ebx
  800a9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa0:	0f b6 02             	movzbl (%edx),%eax
  800aa3:	3c 20                	cmp    $0x20,%al
  800aa5:	74 04                	je     800aab <strtol+0x17>
  800aa7:	3c 09                	cmp    $0x9,%al
  800aa9:	75 0e                	jne    800ab9 <strtol+0x25>
		s++;
  800aab:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aae:	0f b6 02             	movzbl (%edx),%eax
  800ab1:	3c 20                	cmp    $0x20,%al
  800ab3:	74 f6                	je     800aab <strtol+0x17>
  800ab5:	3c 09                	cmp    $0x9,%al
  800ab7:	74 f2                	je     800aab <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab9:	3c 2b                	cmp    $0x2b,%al
  800abb:	75 0a                	jne    800ac7 <strtol+0x33>
		s++;
  800abd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac5:	eb 10                	jmp    800ad7 <strtol+0x43>
  800ac7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800acc:	3c 2d                	cmp    $0x2d,%al
  800ace:	75 07                	jne    800ad7 <strtol+0x43>
		s++, neg = 1;
  800ad0:	83 c2 01             	add    $0x1,%edx
  800ad3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	0f 94 c0             	sete   %al
  800adc:	74 05                	je     800ae3 <strtol+0x4f>
  800ade:	83 fb 10             	cmp    $0x10,%ebx
  800ae1:	75 15                	jne    800af8 <strtol+0x64>
  800ae3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ae6:	75 10                	jne    800af8 <strtol+0x64>
  800ae8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800aec:	75 0a                	jne    800af8 <strtol+0x64>
		s += 2, base = 16;
  800aee:	83 c2 02             	add    $0x2,%edx
  800af1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af6:	eb 13                	jmp    800b0b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800af8:	84 c0                	test   %al,%al
  800afa:	74 0f                	je     800b0b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800afc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b01:	80 3a 30             	cmpb   $0x30,(%edx)
  800b04:	75 05                	jne    800b0b <strtol+0x77>
		s++, base = 8;
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b10:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b12:	0f b6 0a             	movzbl (%edx),%ecx
  800b15:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b18:	80 fb 09             	cmp    $0x9,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0x91>
			dig = *s - '0';
  800b1d:	0f be c9             	movsbl %cl,%ecx
  800b20:	83 e9 30             	sub    $0x30,%ecx
  800b23:	eb 1e                	jmp    800b43 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b25:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b28:	80 fb 19             	cmp    $0x19,%bl
  800b2b:	77 08                	ja     800b35 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b2d:	0f be c9             	movsbl %cl,%ecx
  800b30:	83 e9 57             	sub    $0x57,%ecx
  800b33:	eb 0e                	jmp    800b43 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b35:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 14                	ja     800b51 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b3d:	0f be c9             	movsbl %cl,%ecx
  800b40:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b43:	39 f1                	cmp    %esi,%ecx
  800b45:	7d 0e                	jge    800b55 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b47:	83 c2 01             	add    $0x1,%edx
  800b4a:	0f af c6             	imul   %esi,%eax
  800b4d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800b4f:	eb c1                	jmp    800b12 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800b51:	89 c1                	mov    %eax,%ecx
  800b53:	eb 02                	jmp    800b57 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b55:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xce>
		*endptr = (char *) s;
  800b5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b60:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b62:	89 ca                	mov    %ecx,%edx
  800b64:	f7 da                	neg    %edx
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c2             	cmovne %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 0c             	sub    $0xc,%esp
  800b76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8a:	89 c3                	mov    %eax,%ebx
  800b8c:	89 c7                	mov    %eax,%edi
  800b8e:	89 c6                	mov    %eax,%esi
  800b90:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b95:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b98:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b9b:	89 ec                	mov    %ebp,%esp
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ba8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bab:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb8:	89 d1                	mov    %edx,%ecx
  800bba:	89 d3                	mov    %edx,%ebx
  800bbc:	89 d7                	mov    %edx,%edi
  800bbe:	89 d6                	mov    %edx,%esi
  800bc0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bcb:	89 ec                	mov    %ebp,%esp
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 38             	sub    $0x38,%esp
  800bd5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bd8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bdb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be3:	b8 03 00 00 00       	mov    $0x3,%eax
  800be8:	8b 55 08             	mov    0x8(%ebp),%edx
  800beb:	89 cb                	mov    %ecx,%ebx
  800bed:	89 cf                	mov    %ecx,%edi
  800bef:	89 ce                	mov    %ecx,%esi
  800bf1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7e 28                	jle    800c1f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bfb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c02:	00 
  800c03:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800c0a:	00 
  800c0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c12:	00 
  800c13:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800c1a:	e8 31 11 00 00       	call   801d50 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c28:	89 ec                	mov    %ebp,%esp
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c35:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c38:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 02 00 00 00       	mov    $0x2,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c58:	89 ec                	mov    %ebp,%esp
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_yield>:

void
sys_yield(void)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c65:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c68:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c70:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c75:	89 d1                	mov    %edx,%ecx
  800c77:	89 d3                	mov    %edx,%ebx
  800c79:	89 d7                	mov    %edx,%edi
  800c7b:	89 d6                	mov    %edx,%esi
  800c7d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c88:	89 ec                	mov    %ebp,%esp
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 38             	sub    $0x38,%esp
  800c92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c98:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9b:	be 00 00 00 00       	mov    $0x0,%esi
  800ca0:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	89 f7                	mov    %esi,%edi
  800cb0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7e 28                	jle    800cde <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cba:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc1:	00 
  800cc2:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800cc9:	00 
  800cca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd1:	00 
  800cd2:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800cd9:	e8 72 10 00 00       	call   801d50 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cde:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ce7:	89 ec                	mov    %ebp,%esp
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 38             	sub    $0x38,%esp
  800cf1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cf7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfa:	b8 05 00 00 00       	mov    $0x5,%eax
  800cff:	8b 75 18             	mov    0x18(%ebp),%esi
  800d02:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7e 28                	jle    800d3c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d18:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d1f:	00 
  800d20:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d27:	00 
  800d28:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2f:	00 
  800d30:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800d37:	e8 14 10 00 00       	call   801d50 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d3f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d42:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d45:	89 ec                	mov    %ebp,%esp
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 38             	sub    $0x38,%esp
  800d4f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d52:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d55:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	89 df                	mov    %ebx,%edi
  800d6a:	89 de                	mov    %ebx,%esi
  800d6c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7e 28                	jle    800d9a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d76:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d85:	00 
  800d86:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8d:	00 
  800d8e:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800d95:	e8 b6 0f 00 00       	call   801d50 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d9a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d9d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da3:	89 ec                	mov    %ebp,%esp
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 38             	sub    $0x38,%esp
  800dad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 28                	jle    800df8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800df3:	e8 58 0f 00 00       	call   801d50 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e01:	89 ec                	mov    %ebp,%esp
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 38             	sub    $0x38,%esp
  800e0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	b8 09 00 00 00       	mov    $0x9,%eax
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7e 28                	jle    800e56 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e32:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e39:	00 
  800e3a:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800e41:	00 
  800e42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e49:	00 
  800e4a:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800e51:	e8 fa 0e 00 00       	call   801d50 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5f:	89 ec                	mov    %ebp,%esp
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 38             	sub    $0x38,%esp
  800e69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	89 df                	mov    %ebx,%edi
  800e84:	89 de                	mov    %ebx,%esi
  800e86:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	7e 28                	jle    800eb4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e90:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e97:	00 
  800e98:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800e9f:	00 
  800ea0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea7:	00 
  800ea8:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800eaf:	e8 9c 0e 00 00       	call   801d50 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ebd:	89 ec                	mov    %ebp,%esp
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 0c             	sub    $0xc,%esp
  800ec7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ecd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed0:	be 00 00 00 00       	mov    $0x0,%esi
  800ed5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eeb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef1:	89 ec                	mov    %ebp,%esp
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
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
  800f04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f09:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	89 cb                	mov    %ecx,%ebx
  800f13:	89 cf                	mov    %ecx,%edi
  800f15:	89 ce                	mov    %ecx,%esi
  800f17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	7e 28                	jle    800f45 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f21:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f28:	00 
  800f29:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800f30:	00 
  800f31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f38:	00 
  800f39:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800f40:	e8 0b 0e 00 00       	call   801d50 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f45:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f48:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4e:	89 ec                	mov    %ebp,%esp
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    
	...

00800f60 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	05 00 00 00 30       	add    $0x30000000,%eax
  800f6b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	89 04 24             	mov    %eax,(%esp)
  800f7c:	e8 df ff ff ff       	call   800f60 <fd2num>
  800f81:	05 20 00 0d 00       	add    $0xd0020,%eax
  800f86:	c1 e0 0c             	shl    $0xc,%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	53                   	push   %ebx
  800f8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f92:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800f97:	a8 01                	test   $0x1,%al
  800f99:	74 34                	je     800fcf <fd_alloc+0x44>
  800f9b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800fa0:	a8 01                	test   $0x1,%al
  800fa2:	74 32                	je     800fd6 <fd_alloc+0x4b>
  800fa4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fa9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fab:	89 c2                	mov    %eax,%edx
  800fad:	c1 ea 16             	shr    $0x16,%edx
  800fb0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fb7:	f6 c2 01             	test   $0x1,%dl
  800fba:	74 1f                	je     800fdb <fd_alloc+0x50>
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	c1 ea 0c             	shr    $0xc,%edx
  800fc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fc8:	f6 c2 01             	test   $0x1,%dl
  800fcb:	75 17                	jne    800fe4 <fd_alloc+0x59>
  800fcd:	eb 0c                	jmp    800fdb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fcf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800fd4:	eb 05                	jmp    800fdb <fd_alloc+0x50>
  800fd6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800fdb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb 17                	jmp    800ffb <fd_alloc+0x70>
  800fe4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fe9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fee:	75 b9                	jne    800fa9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ff0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800ff6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ffb:	5b                   	pop    %ebx
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801004:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801009:	83 fa 1f             	cmp    $0x1f,%edx
  80100c:	77 3f                	ja     80104d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80100e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801014:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801017:	89 d0                	mov    %edx,%eax
  801019:	c1 e8 16             	shr    $0x16,%eax
  80101c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801023:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801028:	f6 c1 01             	test   $0x1,%cl
  80102b:	74 20                	je     80104d <fd_lookup+0x4f>
  80102d:	89 d0                	mov    %edx,%eax
  80102f:	c1 e8 0c             	shr    $0xc,%eax
  801032:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801039:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80103e:	f6 c1 01             	test   $0x1,%cl
  801041:	74 0a                	je     80104d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	89 10                	mov    %edx,(%eax)
	return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	53                   	push   %ebx
  801053:	83 ec 14             	sub    $0x14,%esp
  801056:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801059:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801061:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801067:	75 17                	jne    801080 <dev_lookup+0x31>
  801069:	eb 07                	jmp    801072 <dev_lookup+0x23>
  80106b:	39 0a                	cmp    %ecx,(%edx)
  80106d:	75 11                	jne    801080 <dev_lookup+0x31>
  80106f:	90                   	nop
  801070:	eb 05                	jmp    801077 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801072:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801077:	89 13                	mov    %edx,(%ebx)
			return 0;
  801079:	b8 00 00 00 00       	mov    $0x0,%eax
  80107e:	eb 35                	jmp    8010b5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801080:	83 c0 01             	add    $0x1,%eax
  801083:	8b 14 85 a8 25 80 00 	mov    0x8025a8(,%eax,4),%edx
  80108a:	85 d2                	test   %edx,%edx
  80108c:	75 dd                	jne    80106b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80108e:	a1 04 40 80 00       	mov    0x804004,%eax
  801093:	8b 40 48             	mov    0x48(%eax),%eax
  801096:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80109a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80109e:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  8010a5:	e8 c5 f0 ff ff       	call   80016f <cprintf>
	*dev = 0;
  8010aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010b5:	83 c4 14             	add    $0x14,%esp
  8010b8:	5b                   	pop    %ebx
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 38             	sub    $0x38,%esp
  8010c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010cd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d1:	89 3c 24             	mov    %edi,(%esp)
  8010d4:	e8 87 fe ff ff       	call   800f60 <fd2num>
  8010d9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8010dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010e0:	89 04 24             	mov    %eax,(%esp)
  8010e3:	e8 16 ff ff ff       	call   800ffe <fd_lookup>
  8010e8:	89 c3                	mov    %eax,%ebx
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 05                	js     8010f3 <fd_close+0x38>
	    || fd != fd2)
  8010ee:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8010f1:	74 0e                	je     801101 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010f3:	89 f0                	mov    %esi,%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	0f 44 d8             	cmove  %eax,%ebx
  8010ff:	eb 3d                	jmp    80113e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801101:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801104:	89 44 24 04          	mov    %eax,0x4(%esp)
  801108:	8b 07                	mov    (%edi),%eax
  80110a:	89 04 24             	mov    %eax,(%esp)
  80110d:	e8 3d ff ff ff       	call   80104f <dev_lookup>
  801112:	89 c3                	mov    %eax,%ebx
  801114:	85 c0                	test   %eax,%eax
  801116:	78 16                	js     80112e <fd_close+0x73>
		if (dev->dev_close)
  801118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80111b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80111e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801123:	85 c0                	test   %eax,%eax
  801125:	74 07                	je     80112e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801127:	89 3c 24             	mov    %edi,(%esp)
  80112a:	ff d0                	call   *%eax
  80112c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80112e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801139:	e8 0b fc ff ff       	call   800d49 <sys_page_unmap>
	return r;
}
  80113e:	89 d8                	mov    %ebx,%eax
  801140:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801143:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801146:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801149:	89 ec                	mov    %ebp,%esp
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	89 04 24             	mov    %eax,(%esp)
  801160:	e8 99 fe ff ff       	call   800ffe <fd_lookup>
  801165:	85 c0                	test   %eax,%eax
  801167:	78 13                	js     80117c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801170:	00 
  801171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801174:	89 04 24             	mov    %eax,(%esp)
  801177:	e8 3f ff ff ff       	call   8010bb <fd_close>
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <close_all>:

void
close_all(void)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	53                   	push   %ebx
  801182:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80118a:	89 1c 24             	mov    %ebx,(%esp)
  80118d:	e8 bb ff ff ff       	call   80114d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801192:	83 c3 01             	add    $0x1,%ebx
  801195:	83 fb 20             	cmp    $0x20,%ebx
  801198:	75 f0                	jne    80118a <close_all+0xc>
		close(i);
}
  80119a:	83 c4 14             	add    $0x14,%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 58             	sub    $0x58,%esp
  8011a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8011af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	89 04 24             	mov    %eax,(%esp)
  8011bf:	e8 3a fe ff ff       	call   800ffe <fd_lookup>
  8011c4:	89 c3                	mov    %eax,%ebx
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	0f 88 e1 00 00 00    	js     8012af <dup+0x10f>
		return r;
	close(newfdnum);
  8011ce:	89 3c 24             	mov    %edi,(%esp)
  8011d1:	e8 77 ff ff ff       	call   80114d <close>

	newfd = INDEX2FD(newfdnum);
  8011d6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8011dc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8011df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e2:	89 04 24             	mov    %eax,(%esp)
  8011e5:	e8 86 fd ff ff       	call   800f70 <fd2data>
  8011ea:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011ec:	89 34 24             	mov    %esi,(%esp)
  8011ef:	e8 7c fd ff ff       	call   800f70 <fd2data>
  8011f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f7:	89 d8                	mov    %ebx,%eax
  8011f9:	c1 e8 16             	shr    $0x16,%eax
  8011fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801203:	a8 01                	test   $0x1,%al
  801205:	74 46                	je     80124d <dup+0xad>
  801207:	89 d8                	mov    %ebx,%eax
  801209:	c1 e8 0c             	shr    $0xc,%eax
  80120c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801213:	f6 c2 01             	test   $0x1,%dl
  801216:	74 35                	je     80124d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801218:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80121f:	25 07 0e 00 00       	and    $0xe07,%eax
  801224:	89 44 24 10          	mov    %eax,0x10(%esp)
  801228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80122b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801236:	00 
  801237:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80123b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801242:	e8 a4 fa ff ff       	call   800ceb <sys_page_map>
  801247:	89 c3                	mov    %eax,%ebx
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 3b                	js     801288 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80124d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801250:	89 c2                	mov    %eax,%edx
  801252:	c1 ea 0c             	shr    $0xc,%edx
  801255:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80125c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801262:	89 54 24 10          	mov    %edx,0x10(%esp)
  801266:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80126a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801271:	00 
  801272:	89 44 24 04          	mov    %eax,0x4(%esp)
  801276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127d:	e8 69 fa ff ff       	call   800ceb <sys_page_map>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	85 c0                	test   %eax,%eax
  801286:	79 25                	jns    8012ad <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801288:	89 74 24 04          	mov    %esi,0x4(%esp)
  80128c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801293:	e8 b1 fa ff ff       	call   800d49 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801298:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80129b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a6:	e8 9e fa ff ff       	call   800d49 <sys_page_unmap>
	return r;
  8012ab:	eb 02                	jmp    8012af <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8012ad:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012af:	89 d8                	mov    %ebx,%eax
  8012b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ba:	89 ec                	mov    %ebp,%esp
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 24             	sub    $0x24,%esp
  8012c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cf:	89 1c 24             	mov    %ebx,(%esp)
  8012d2:	e8 27 fd ff ff       	call   800ffe <fd_lookup>
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 6d                	js     801348 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	89 04 24             	mov    %eax,(%esp)
  8012ea:	e8 60 fd ff ff       	call   80104f <dev_lookup>
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 55                	js     801348 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f6:	8b 50 08             	mov    0x8(%eax),%edx
  8012f9:	83 e2 03             	and    $0x3,%edx
  8012fc:	83 fa 01             	cmp    $0x1,%edx
  8012ff:	75 23                	jne    801324 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	8b 40 48             	mov    0x48(%eax),%eax
  801309:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80130d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801311:	c7 04 24 6d 25 80 00 	movl   $0x80256d,(%esp)
  801318:	e8 52 ee ff ff       	call   80016f <cprintf>
		return -E_INVAL;
  80131d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801322:	eb 24                	jmp    801348 <read+0x8a>
	}
	if (!dev->dev_read)
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 52 08             	mov    0x8(%edx),%edx
  80132a:	85 d2                	test   %edx,%edx
  80132c:	74 15                	je     801343 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80132e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801331:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801338:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80133c:	89 04 24             	mov    %eax,(%esp)
  80133f:	ff d2                	call   *%edx
  801341:	eb 05                	jmp    801348 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801343:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801348:	83 c4 24             	add    $0x24,%esp
  80134b:	5b                   	pop    %ebx
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    

0080134e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 1c             	sub    $0x1c,%esp
  801357:	8b 7d 08             	mov    0x8(%ebp),%edi
  80135a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	85 f6                	test   %esi,%esi
  801364:	74 30                	je     801396 <readn+0x48>
  801366:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136b:	89 f2                	mov    %esi,%edx
  80136d:	29 c2                	sub    %eax,%edx
  80136f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801373:	03 45 0c             	add    0xc(%ebp),%eax
  801376:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137a:	89 3c 24             	mov    %edi,(%esp)
  80137d:	e8 3c ff ff ff       	call   8012be <read>
		if (m < 0)
  801382:	85 c0                	test   %eax,%eax
  801384:	78 10                	js     801396 <readn+0x48>
			return m;
		if (m == 0)
  801386:	85 c0                	test   %eax,%eax
  801388:	74 0a                	je     801394 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80138a:	01 c3                	add    %eax,%ebx
  80138c:	89 d8                	mov    %ebx,%eax
  80138e:	39 f3                	cmp    %esi,%ebx
  801390:	72 d9                	jb     80136b <readn+0x1d>
  801392:	eb 02                	jmp    801396 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801394:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801396:	83 c4 1c             	add    $0x1c,%esp
  801399:	5b                   	pop    %ebx
  80139a:	5e                   	pop    %esi
  80139b:	5f                   	pop    %edi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 24             	sub    $0x24,%esp
  8013a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013af:	89 1c 24             	mov    %ebx,(%esp)
  8013b2:	e8 47 fc ff ff       	call   800ffe <fd_lookup>
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 68                	js     801423 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	89 04 24             	mov    %eax,(%esp)
  8013ca:	e8 80 fc ff ff       	call   80104f <dev_lookup>
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 50                	js     801423 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013da:	75 23                	jne    8013ff <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e1:	8b 40 48             	mov    0x48(%eax),%eax
  8013e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ec:	c7 04 24 89 25 80 00 	movl   $0x802589,(%esp)
  8013f3:	e8 77 ed ff ff       	call   80016f <cprintf>
		return -E_INVAL;
  8013f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fd:	eb 24                	jmp    801423 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801402:	8b 52 0c             	mov    0xc(%edx),%edx
  801405:	85 d2                	test   %edx,%edx
  801407:	74 15                	je     80141e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801409:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80140c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801413:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801417:	89 04 24             	mov    %eax,(%esp)
  80141a:	ff d2                	call   *%edx
  80141c:	eb 05                	jmp    801423 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80141e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801423:	83 c4 24             	add    $0x24,%esp
  801426:	5b                   	pop    %ebx
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    

00801429 <seek>:

int
seek(int fdnum, off_t offset)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80142f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801432:	89 44 24 04          	mov    %eax,0x4(%esp)
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 04 24             	mov    %eax,(%esp)
  80143c:	e8 bd fb ff ff       	call   800ffe <fd_lookup>
  801441:	85 c0                	test   %eax,%eax
  801443:	78 0e                	js     801453 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801445:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	53                   	push   %ebx
  801459:	83 ec 24             	sub    $0x24,%esp
  80145c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801462:	89 44 24 04          	mov    %eax,0x4(%esp)
  801466:	89 1c 24             	mov    %ebx,(%esp)
  801469:	e8 90 fb ff ff       	call   800ffe <fd_lookup>
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 61                	js     8014d3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801472:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801475:	89 44 24 04          	mov    %eax,0x4(%esp)
  801479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147c:	8b 00                	mov    (%eax),%eax
  80147e:	89 04 24             	mov    %eax,(%esp)
  801481:	e8 c9 fb ff ff       	call   80104f <dev_lookup>
  801486:	85 c0                	test   %eax,%eax
  801488:	78 49                	js     8014d3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801491:	75 23                	jne    8014b6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801493:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801498:	8b 40 48             	mov    0x48(%eax),%eax
  80149b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a3:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  8014aa:	e8 c0 ec ff ff       	call   80016f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b4:	eb 1d                	jmp    8014d3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8014b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b9:	8b 52 18             	mov    0x18(%edx),%edx
  8014bc:	85 d2                	test   %edx,%edx
  8014be:	74 0e                	je     8014ce <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014c7:	89 04 24             	mov    %eax,(%esp)
  8014ca:	ff d2                	call   *%edx
  8014cc:	eb 05                	jmp    8014d3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014d3:	83 c4 24             	add    $0x24,%esp
  8014d6:	5b                   	pop    %ebx
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    

008014d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 24             	sub    $0x24,%esp
  8014e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 04 24             	mov    %eax,(%esp)
  8014f0:	e8 09 fb ff ff       	call   800ffe <fd_lookup>
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 52                	js     80154b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	89 04 24             	mov    %eax,(%esp)
  801508:	e8 42 fb ff ff       	call   80104f <dev_lookup>
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 3a                	js     80154b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801518:	74 2c                	je     801546 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80151a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801524:	00 00 00 
	stat->st_isdir = 0;
  801527:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152e:	00 00 00 
	stat->st_dev = dev;
  801531:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801537:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80153b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153e:	89 14 24             	mov    %edx,(%esp)
  801541:	ff 50 14             	call   *0x14(%eax)
  801544:	eb 05                	jmp    80154b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801546:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80154b:	83 c4 24             	add    $0x24,%esp
  80154e:	5b                   	pop    %ebx
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    

00801551 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 18             	sub    $0x18,%esp
  801557:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80155a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80155d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801564:	00 
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	89 04 24             	mov    %eax,(%esp)
  80156b:	e8 bc 01 00 00       	call   80172c <open>
  801570:	89 c3                	mov    %eax,%ebx
  801572:	85 c0                	test   %eax,%eax
  801574:	78 1b                	js     801591 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801576:	8b 45 0c             	mov    0xc(%ebp),%eax
  801579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157d:	89 1c 24             	mov    %ebx,(%esp)
  801580:	e8 54 ff ff ff       	call   8014d9 <fstat>
  801585:	89 c6                	mov    %eax,%esi
	close(fd);
  801587:	89 1c 24             	mov    %ebx,(%esp)
  80158a:	e8 be fb ff ff       	call   80114d <close>
	return r;
  80158f:	89 f3                	mov    %esi,%ebx
}
  801591:	89 d8                	mov    %ebx,%eax
  801593:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801596:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801599:	89 ec                	mov    %ebp,%esp
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
  80159d:	00 00                	add    %al,(%eax)
	...

008015a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 18             	sub    $0x18,%esp
  8015a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015ac:	89 c3                	mov    %eax,%ebx
  8015ae:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8015b0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b7:	75 11                	jne    8015ca <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015c0:	e8 c1 08 00 00       	call   801e86 <ipc_find_env>
  8015c5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ca:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015d1:	00 
  8015d2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015d9:	00 
  8015da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015de:	a1 00 40 80 00       	mov    0x804000,%eax
  8015e3:	89 04 24             	mov    %eax,(%esp)
  8015e6:	e8 17 08 00 00       	call   801e02 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f2:	00 
  8015f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fe:	e8 ad 07 00 00       	call   801db0 <ipc_recv>
}
  801603:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801606:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801609:	89 ec                	mov    %ebp,%esp
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	53                   	push   %ebx
  801611:	83 ec 14             	sub    $0x14,%esp
  801614:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8b 40 0c             	mov    0xc(%eax),%eax
  80161d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
  801627:	b8 05 00 00 00       	mov    $0x5,%eax
  80162c:	e8 6f ff ff ff       	call   8015a0 <fsipc>
  801631:	85 c0                	test   %eax,%eax
  801633:	78 2b                	js     801660 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801635:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80163c:	00 
  80163d:	89 1c 24             	mov    %ebx,(%esp)
  801640:	e8 46 f1 ff ff       	call   80078b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801645:	a1 80 50 80 00       	mov    0x805080,%eax
  80164a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801650:	a1 84 50 80 00       	mov    0x805084,%eax
  801655:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801660:	83 c4 14             	add    $0x14,%esp
  801663:	5b                   	pop    %ebx
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8b 40 0c             	mov    0xc(%eax),%eax
  801672:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	b8 06 00 00 00       	mov    $0x6,%eax
  801681:	e8 1a ff ff ff       	call   8015a0 <fsipc>
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	56                   	push   %esi
  80168c:	53                   	push   %ebx
  80168d:	83 ec 10             	sub    $0x10,%esp
  801690:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8b 40 0c             	mov    0xc(%eax),%eax
  801699:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80169e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ae:	e8 ed fe ff ff       	call   8015a0 <fsipc>
  8016b3:	89 c3                	mov    %eax,%ebx
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 6a                	js     801723 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016b9:	39 c6                	cmp    %eax,%esi
  8016bb:	73 24                	jae    8016e1 <devfile_read+0x59>
  8016bd:	c7 44 24 0c b8 25 80 	movl   $0x8025b8,0xc(%esp)
  8016c4:	00 
  8016c5:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  8016cc:	00 
  8016cd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016d4:	00 
  8016d5:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  8016dc:	e8 6f 06 00 00       	call   801d50 <_panic>
	assert(r <= PGSIZE);
  8016e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e6:	7e 24                	jle    80170c <devfile_read+0x84>
  8016e8:	c7 44 24 0c df 25 80 	movl   $0x8025df,0xc(%esp)
  8016ef:	00 
  8016f0:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  8016f7:	00 
  8016f8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8016ff:	00 
  801700:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  801707:	e8 44 06 00 00       	call   801d50 <_panic>
	memmove(buf, &fsipcbuf, r);
  80170c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801710:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801717:	00 
  801718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171b:	89 04 24             	mov    %eax,(%esp)
  80171e:	e8 59 f2 ff ff       	call   80097c <memmove>
	return r;
}
  801723:	89 d8                	mov    %ebx,%eax
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	5b                   	pop    %ebx
  801729:	5e                   	pop    %esi
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	56                   	push   %esi
  801730:	53                   	push   %ebx
  801731:	83 ec 20             	sub    $0x20,%esp
  801734:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801737:	89 34 24             	mov    %esi,(%esp)
  80173a:	e8 01 f0 ff ff       	call   800740 <strlen>
		return -E_BAD_PATH;
  80173f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801744:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801749:	7f 5e                	jg     8017a9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80174b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174e:	89 04 24             	mov    %eax,(%esp)
  801751:	e8 35 f8 ff ff       	call   800f8b <fd_alloc>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 4d                	js     8017a9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80175c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801760:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801767:	e8 1f f0 ff ff       	call   80078b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801777:	b8 01 00 00 00       	mov    $0x1,%eax
  80177c:	e8 1f fe ff ff       	call   8015a0 <fsipc>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	85 c0                	test   %eax,%eax
  801785:	79 15                	jns    80179c <open+0x70>
		fd_close(fd, 0);
  801787:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80178e:	00 
  80178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801792:	89 04 24             	mov    %eax,(%esp)
  801795:	e8 21 f9 ff ff       	call   8010bb <fd_close>
		return r;
  80179a:	eb 0d                	jmp    8017a9 <open+0x7d>
	}

	return fd2num(fd);
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	89 04 24             	mov    %eax,(%esp)
  8017a2:	e8 b9 f7 ff ff       	call   800f60 <fd2num>
  8017a7:	89 c3                	mov    %eax,%ebx
}
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	83 c4 20             	add    $0x20,%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    
	...

008017c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 18             	sub    $0x18,%esp
  8017c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	89 04 24             	mov    %eax,(%esp)
  8017d5:	e8 96 f7 ff ff       	call   800f70 <fd2data>
  8017da:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8017dc:	c7 44 24 04 eb 25 80 	movl   $0x8025eb,0x4(%esp)
  8017e3:	00 
  8017e4:	89 34 24             	mov    %esi,(%esp)
  8017e7:	e8 9f ef ff ff       	call   80078b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ef:	2b 03                	sub    (%ebx),%eax
  8017f1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8017f7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8017fe:	00 00 00 
	stat->st_dev = &devpipe;
  801801:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801808:	30 80 00 
	return 0;
}
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801813:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801816:	89 ec                	mov    %ebp,%esp
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	53                   	push   %ebx
  80181e:	83 ec 14             	sub    $0x14,%esp
  801821:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801824:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801828:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80182f:	e8 15 f5 ff ff       	call   800d49 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801834:	89 1c 24             	mov    %ebx,(%esp)
  801837:	e8 34 f7 ff ff       	call   800f70 <fd2data>
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801847:	e8 fd f4 ff ff       	call   800d49 <sys_page_unmap>
}
  80184c:	83 c4 14             	add    $0x14,%esp
  80184f:	5b                   	pop    %ebx
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	57                   	push   %edi
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 2c             	sub    $0x2c,%esp
  80185b:	89 c7                	mov    %eax,%edi
  80185d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801860:	a1 04 40 80 00       	mov    0x804004,%eax
  801865:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801868:	89 3c 24             	mov    %edi,(%esp)
  80186b:	e8 60 06 00 00       	call   801ed0 <pageref>
  801870:	89 c6                	mov    %eax,%esi
  801872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801875:	89 04 24             	mov    %eax,(%esp)
  801878:	e8 53 06 00 00       	call   801ed0 <pageref>
  80187d:	39 c6                	cmp    %eax,%esi
  80187f:	0f 94 c0             	sete   %al
  801882:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801885:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80188b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80188e:	39 cb                	cmp    %ecx,%ebx
  801890:	75 08                	jne    80189a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801892:	83 c4 2c             	add    $0x2c,%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5f                   	pop    %edi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80189a:	83 f8 01             	cmp    $0x1,%eax
  80189d:	75 c1                	jne    801860 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80189f:	8b 52 58             	mov    0x58(%edx),%edx
  8018a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ae:	c7 04 24 f2 25 80 00 	movl   $0x8025f2,(%esp)
  8018b5:	e8 b5 e8 ff ff       	call   80016f <cprintf>
  8018ba:	eb a4                	jmp    801860 <_pipeisclosed+0xe>

008018bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 2c             	sub    $0x2c,%esp
  8018c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018c8:	89 34 24             	mov    %esi,(%esp)
  8018cb:	e8 a0 f6 ff ff       	call   800f70 <fd2data>
  8018d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018db:	75 50                	jne    80192d <devpipe_write+0x71>
  8018dd:	eb 5c                	jmp    80193b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8018df:	89 da                	mov    %ebx,%edx
  8018e1:	89 f0                	mov    %esi,%eax
  8018e3:	e8 6a ff ff ff       	call   801852 <_pipeisclosed>
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	75 53                	jne    80193f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018ec:	e8 6b f3 ff ff       	call   800c5c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018f1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018f4:	8b 13                	mov    (%ebx),%edx
  8018f6:	83 c2 20             	add    $0x20,%edx
  8018f9:	39 d0                	cmp    %edx,%eax
  8018fb:	73 e2                	jae    8018df <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801904:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801907:	89 c2                	mov    %eax,%edx
  801909:	c1 fa 1f             	sar    $0x1f,%edx
  80190c:	c1 ea 1b             	shr    $0x1b,%edx
  80190f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801912:	83 e1 1f             	and    $0x1f,%ecx
  801915:	29 d1                	sub    %edx,%ecx
  801917:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80191b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80191f:	83 c0 01             	add    $0x1,%eax
  801922:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801925:	83 c7 01             	add    $0x1,%edi
  801928:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80192b:	74 0e                	je     80193b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80192d:	8b 43 04             	mov    0x4(%ebx),%eax
  801930:	8b 13                	mov    (%ebx),%edx
  801932:	83 c2 20             	add    $0x20,%edx
  801935:	39 d0                	cmp    %edx,%eax
  801937:	73 a6                	jae    8018df <devpipe_write+0x23>
  801939:	eb c2                	jmp    8018fd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80193b:	89 f8                	mov    %edi,%eax
  80193d:	eb 05                	jmp    801944 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801944:	83 c4 2c             	add    $0x2c,%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 28             	sub    $0x28,%esp
  801952:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801955:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801958:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80195b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80195e:	89 3c 24             	mov    %edi,(%esp)
  801961:	e8 0a f6 ff ff       	call   800f70 <fd2data>
  801966:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801968:	be 00 00 00 00       	mov    $0x0,%esi
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 47                	jne    8019ba <devpipe_read+0x6e>
  801973:	eb 52                	jmp    8019c7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801975:	89 f0                	mov    %esi,%eax
  801977:	eb 5e                	jmp    8019d7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801979:	89 da                	mov    %ebx,%edx
  80197b:	89 f8                	mov    %edi,%eax
  80197d:	8d 76 00             	lea    0x0(%esi),%esi
  801980:	e8 cd fe ff ff       	call   801852 <_pipeisclosed>
  801985:	85 c0                	test   %eax,%eax
  801987:	75 49                	jne    8019d2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801989:	e8 ce f2 ff ff       	call   800c5c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80198e:	8b 03                	mov    (%ebx),%eax
  801990:	3b 43 04             	cmp    0x4(%ebx),%eax
  801993:	74 e4                	je     801979 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801995:	89 c2                	mov    %eax,%edx
  801997:	c1 fa 1f             	sar    $0x1f,%edx
  80199a:	c1 ea 1b             	shr    $0x1b,%edx
  80199d:	01 d0                	add    %edx,%eax
  80199f:	83 e0 1f             	and    $0x1f,%eax
  8019a2:	29 d0                	sub    %edx,%eax
  8019a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8019af:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019b2:	83 c6 01             	add    $0x1,%esi
  8019b5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019b8:	74 0d                	je     8019c7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8019ba:	8b 03                	mov    (%ebx),%eax
  8019bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019bf:	75 d4                	jne    801995 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019c1:	85 f6                	test   %esi,%esi
  8019c3:	75 b0                	jne    801975 <devpipe_read+0x29>
  8019c5:	eb b2                	jmp    801979 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019c7:	89 f0                	mov    %esi,%eax
  8019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8019d0:	eb 05                	jmp    8019d7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8019d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019e0:	89 ec                	mov    %ebp,%esp
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 48             	sub    $0x48,%esp
  8019ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8019f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019f9:	89 04 24             	mov    %eax,(%esp)
  8019fc:	e8 8a f5 ff ff       	call   800f8b <fd_alloc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	85 c0                	test   %eax,%eax
  801a05:	0f 88 45 01 00 00    	js     801b50 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a0b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a12:	00 
  801a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a21:	e8 66 f2 ff ff       	call   800c8c <sys_page_alloc>
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	0f 88 20 01 00 00    	js     801b50 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801a30:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a33:	89 04 24             	mov    %eax,(%esp)
  801a36:	e8 50 f5 ff ff       	call   800f8b <fd_alloc>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	0f 88 f8 00 00 00    	js     801b3d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a4c:	00 
  801a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5b:	e8 2c f2 ff ff       	call   800c8c <sys_page_alloc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	0f 88 d3 00 00 00    	js     801b3d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6d:	89 04 24             	mov    %eax,(%esp)
  801a70:	e8 fb f4 ff ff       	call   800f70 <fd2data>
  801a75:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a77:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a7e:	00 
  801a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8a:	e8 fd f1 ff ff       	call   800c8c <sys_page_alloc>
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	85 c0                	test   %eax,%eax
  801a93:	0f 88 91 00 00 00    	js     801b2a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9c:	89 04 24             	mov    %eax,(%esp)
  801a9f:	e8 cc f4 ff ff       	call   800f70 <fd2data>
  801aa4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801aab:	00 
  801aac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ab7:	00 
  801ab8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac3:	e8 23 f2 ff ff       	call   800ceb <sys_page_map>
  801ac8:	89 c3                	mov    %eax,%ebx
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 4c                	js     801b1a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ace:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ae3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aec:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801afb:	89 04 24             	mov    %eax,(%esp)
  801afe:	e8 5d f4 ff ff       	call   800f60 <fd2num>
  801b03:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	e8 50 f4 ff ff       	call   800f60 <fd2num>
  801b10:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801b13:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b18:	eb 36                	jmp    801b50 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801b1a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b25:	e8 1f f2 ff ff       	call   800d49 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b38:	e8 0c f2 ff ff       	call   800d49 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4b:	e8 f9 f1 ff ff       	call   800d49 <sys_page_unmap>
    err:
	return r;
}
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b5b:	89 ec                	mov    %ebp,%esp
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    

00801b5f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 87 f4 ff ff       	call   800ffe <fd_lookup>
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 15                	js     801b90 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7e:	89 04 24             	mov    %eax,(%esp)
  801b81:	e8 ea f3 ff ff       	call   800f70 <fd2data>
	return _pipeisclosed(fd, p);
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	e8 c2 fc ff ff       	call   801852 <_pipeisclosed>
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    
	...

00801ba0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801bb0:	c7 44 24 04 0a 26 80 	movl   $0x80260a,0x4(%esp)
  801bb7:	00 
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	89 04 24             	mov    %eax,(%esp)
  801bbe:	e8 c8 eb ff ff       	call   80078b <strcpy>
	return 0;
}
  801bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	57                   	push   %edi
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bd6:	be 00 00 00 00       	mov    $0x0,%esi
  801bdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bdf:	74 43                	je     801c24 <devcons_write+0x5a>
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801be6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bef:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801bf1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bf4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801bf9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c00:	03 45 0c             	add    0xc(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	89 3c 24             	mov    %edi,(%esp)
  801c0a:	e8 6d ed ff ff       	call   80097c <memmove>
		sys_cputs(buf, m);
  801c0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c13:	89 3c 24             	mov    %edi,(%esp)
  801c16:	e8 55 ef ff ff       	call   800b70 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c1b:	01 de                	add    %ebx,%esi
  801c1d:	89 f0                	mov    %esi,%eax
  801c1f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c22:	72 c8                	jb     801bec <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801c24:	89 f0                	mov    %esi,%eax
  801c26:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801c3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c40:	75 07                	jne    801c49 <devcons_read+0x18>
  801c42:	eb 31                	jmp    801c75 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801c44:	e8 13 f0 ff ff       	call   800c5c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c50:	e8 4a ef ff ff       	call   800b9f <sys_cgetc>
  801c55:	85 c0                	test   %eax,%eax
  801c57:	74 eb                	je     801c44 <devcons_read+0x13>
  801c59:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 16                	js     801c75 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801c5f:	83 f8 04             	cmp    $0x4,%eax
  801c62:	74 0c                	je     801c70 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	88 10                	mov    %dl,(%eax)
	return 1;
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6e:	eb 05                	jmp    801c75 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c83:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c8a:	00 
  801c8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 da ee ff ff       	call   800b70 <sys_cputs>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <getchar>:

int
getchar(void)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c9e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ca5:	00 
  801ca6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb4:	e8 05 f6 ff ff       	call   8012be <read>
	if (r < 0)
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	78 0f                	js     801ccc <getchar+0x34>
		return r;
	if (r < 1)
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	7e 06                	jle    801cc7 <getchar+0x2f>
		return -E_EOF;
	return c;
  801cc1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801cc5:	eb 05                	jmp    801ccc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801cc7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	89 04 24             	mov    %eax,(%esp)
  801ce1:	e8 18 f3 ff ff       	call   800ffe <fd_lookup>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	78 11                	js     801cfb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ced:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cf3:	39 10                	cmp    %edx,(%eax)
  801cf5:	0f 94 c0             	sete   %al
  801cf8:	0f b6 c0             	movzbl %al,%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <opencons>:

int
opencons(void)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d06:	89 04 24             	mov    %eax,(%esp)
  801d09:	e8 7d f2 ff ff       	call   800f8b <fd_alloc>
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 3c                	js     801d4e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d19:	00 
  801d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d28:	e8 5f ef ff ff       	call   800c8c <sys_page_alloc>
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	78 1d                	js     801d4e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d31:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d46:	89 04 24             	mov    %eax,(%esp)
  801d49:	e8 12 f2 ff ff       	call   800f60 <fd2num>
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801d58:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d5b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801d61:	e8 c6 ee ff ff       	call   800c2c <sys_getenvid>
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d70:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d74:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7c:	c7 04 24 18 26 80 00 	movl   $0x802618,(%esp)
  801d83:	e8 e7 e3 ff ff       	call   80016f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d88:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	e8 77 e3 ff ff       	call   80010e <vcprintf>
	cprintf("\n");
  801d97:	c7 04 24 03 26 80 00 	movl   $0x802603,(%esp)
  801d9e:	e8 cc e3 ff ff       	call   80016f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801da3:	cc                   	int3   
  801da4:	eb fd                	jmp    801da3 <_panic+0x53>
	...

00801db0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 10             	sub    $0x10,%esp
  801db8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801dc1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801dc3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dc8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dcb:	89 04 24             	mov    %eax,(%esp)
  801dce:	e8 22 f1 ff ff       	call   800ef5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801dd8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 0e                	js     801def <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801de1:	a1 04 40 80 00       	mov    0x804004,%eax
  801de6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801de9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801dec:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801def:	85 f6                	test   %esi,%esi
  801df1:	74 02                	je     801df5 <ipc_recv+0x45>
		*from_env_store = sender;
  801df3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801df5:	85 db                	test   %ebx,%ebx
  801df7:	74 02                	je     801dfb <ipc_recv+0x4b>
		*perm_store = perm;
  801df9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
  801e0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e11:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e14:	85 db                	test   %ebx,%ebx
  801e16:	75 04                	jne    801e1c <ipc_send+0x1a>
  801e18:	85 f6                	test   %esi,%esi
  801e1a:	75 15                	jne    801e31 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e1c:	85 db                	test   %ebx,%ebx
  801e1e:	74 16                	je     801e36 <ipc_send+0x34>
  801e20:	85 f6                	test   %esi,%esi
  801e22:	0f 94 c0             	sete   %al
      pg = 0;
  801e25:	84 c0                	test   %al,%al
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2c:	0f 45 d8             	cmovne %eax,%ebx
  801e2f:	eb 05                	jmp    801e36 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e31:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e36:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e3a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	89 04 24             	mov    %eax,(%esp)
  801e48:	e8 74 f0 ff ff       	call   800ec1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e4d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e50:	75 07                	jne    801e59 <ipc_send+0x57>
           sys_yield();
  801e52:	e8 05 ee ff ff       	call   800c5c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e57:	eb dd                	jmp    801e36 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	90                   	nop
  801e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e60:	74 1c                	je     801e7e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e62:	c7 44 24 08 3c 26 80 	movl   $0x80263c,0x8(%esp)
  801e69:	00 
  801e6a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e71:	00 
  801e72:	c7 04 24 46 26 80 00 	movl   $0x802646,(%esp)
  801e79:	e8 d2 fe ff ff       	call   801d50 <_panic>
		}
    }
}
  801e7e:	83 c4 1c             	add    $0x1c,%esp
  801e81:	5b                   	pop    %ebx
  801e82:	5e                   	pop    %esi
  801e83:	5f                   	pop    %edi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e8c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e91:	39 c8                	cmp    %ecx,%eax
  801e93:	74 17                	je     801eac <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e9a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e9d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ea3:	8b 52 50             	mov    0x50(%edx),%edx
  801ea6:	39 ca                	cmp    %ecx,%edx
  801ea8:	75 14                	jne    801ebe <ipc_find_env+0x38>
  801eaa:	eb 05                	jmp    801eb1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801eb1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801eb4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801eb9:	8b 40 40             	mov    0x40(%eax),%eax
  801ebc:	eb 0e                	jmp    801ecc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ebe:	83 c0 01             	add    $0x1,%eax
  801ec1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ec6:	75 d2                	jne    801e9a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ec8:	66 b8 00 00          	mov    $0x0,%ax
}
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
	...

00801ed0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ed6:	89 d0                	mov    %edx,%eax
  801ed8:	c1 e8 16             	shr    $0x16,%eax
  801edb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee7:	f6 c1 01             	test   $0x1,%cl
  801eea:	74 1d                	je     801f09 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801eec:	c1 ea 0c             	shr    $0xc,%edx
  801eef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ef6:	f6 c2 01             	test   $0x1,%dl
  801ef9:	74 0e                	je     801f09 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801efb:	c1 ea 0c             	shr    $0xc,%edx
  801efe:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f05:	ef 
  801f06:	0f b7 c0             	movzwl %ax,%eax
}
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    
  801f0b:	00 00                	add    %al,(%eax)
  801f0d:	00 00                	add    %al,(%eax)
	...

00801f10 <__udivdi3>:
  801f10:	83 ec 1c             	sub    $0x1c,%esp
  801f13:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f17:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f1b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f1f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f23:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f27:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f2b:	85 ff                	test   %edi,%edi
  801f2d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f31:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f35:	89 cd                	mov    %ecx,%ebp
  801f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3b:	75 33                	jne    801f70 <__udivdi3+0x60>
  801f3d:	39 f1                	cmp    %esi,%ecx
  801f3f:	77 57                	ja     801f98 <__udivdi3+0x88>
  801f41:	85 c9                	test   %ecx,%ecx
  801f43:	75 0b                	jne    801f50 <__udivdi3+0x40>
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	31 d2                	xor    %edx,%edx
  801f4c:	f7 f1                	div    %ecx
  801f4e:	89 c1                	mov    %eax,%ecx
  801f50:	89 f0                	mov    %esi,%eax
  801f52:	31 d2                	xor    %edx,%edx
  801f54:	f7 f1                	div    %ecx
  801f56:	89 c6                	mov    %eax,%esi
  801f58:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f5c:	f7 f1                	div    %ecx
  801f5e:	89 f2                	mov    %esi,%edx
  801f60:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f64:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f68:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f6c:	83 c4 1c             	add    $0x1c,%esp
  801f6f:	c3                   	ret    
  801f70:	31 d2                	xor    %edx,%edx
  801f72:	31 c0                	xor    %eax,%eax
  801f74:	39 f7                	cmp    %esi,%edi
  801f76:	77 e8                	ja     801f60 <__udivdi3+0x50>
  801f78:	0f bd cf             	bsr    %edi,%ecx
  801f7b:	83 f1 1f             	xor    $0x1f,%ecx
  801f7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f82:	75 2c                	jne    801fb0 <__udivdi3+0xa0>
  801f84:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f88:	76 04                	jbe    801f8e <__udivdi3+0x7e>
  801f8a:	39 f7                	cmp    %esi,%edi
  801f8c:	73 d2                	jae    801f60 <__udivdi3+0x50>
  801f8e:	31 d2                	xor    %edx,%edx
  801f90:	b8 01 00 00 00       	mov    $0x1,%eax
  801f95:	eb c9                	jmp    801f60 <__udivdi3+0x50>
  801f97:	90                   	nop
  801f98:	89 f2                	mov    %esi,%edx
  801f9a:	f7 f1                	div    %ecx
  801f9c:	31 d2                	xor    %edx,%edx
  801f9e:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fa2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fa6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801faa:	83 c4 1c             	add    $0x1c,%esp
  801fad:	c3                   	ret    
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fb5:	b8 20 00 00 00       	mov    $0x20,%eax
  801fba:	89 ea                	mov    %ebp,%edx
  801fbc:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fc0:	d3 e7                	shl    %cl,%edi
  801fc2:	89 c1                	mov    %eax,%ecx
  801fc4:	d3 ea                	shr    %cl,%edx
  801fc6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fcb:	09 fa                	or     %edi,%edx
  801fcd:	89 f7                	mov    %esi,%edi
  801fcf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fd3:	89 f2                	mov    %esi,%edx
  801fd5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fd9:	d3 e5                	shl    %cl,%ebp
  801fdb:	89 c1                	mov    %eax,%ecx
  801fdd:	d3 ef                	shr    %cl,%edi
  801fdf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fe4:	d3 e2                	shl    %cl,%edx
  801fe6:	89 c1                	mov    %eax,%ecx
  801fe8:	d3 ee                	shr    %cl,%esi
  801fea:	09 d6                	or     %edx,%esi
  801fec:	89 fa                	mov    %edi,%edx
  801fee:	89 f0                	mov    %esi,%eax
  801ff0:	f7 74 24 0c          	divl   0xc(%esp)
  801ff4:	89 d7                	mov    %edx,%edi
  801ff6:	89 c6                	mov    %eax,%esi
  801ff8:	f7 e5                	mul    %ebp
  801ffa:	39 d7                	cmp    %edx,%edi
  801ffc:	72 22                	jb     802020 <__udivdi3+0x110>
  801ffe:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802002:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802007:	d3 e5                	shl    %cl,%ebp
  802009:	39 c5                	cmp    %eax,%ebp
  80200b:	73 04                	jae    802011 <__udivdi3+0x101>
  80200d:	39 d7                	cmp    %edx,%edi
  80200f:	74 0f                	je     802020 <__udivdi3+0x110>
  802011:	89 f0                	mov    %esi,%eax
  802013:	31 d2                	xor    %edx,%edx
  802015:	e9 46 ff ff ff       	jmp    801f60 <__udivdi3+0x50>
  80201a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802020:	8d 46 ff             	lea    -0x1(%esi),%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	8b 74 24 10          	mov    0x10(%esp),%esi
  802029:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80202d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802031:	83 c4 1c             	add    $0x1c,%esp
  802034:	c3                   	ret    
	...

00802040 <__umoddi3>:
  802040:	83 ec 1c             	sub    $0x1c,%esp
  802043:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802047:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80204b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80204f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802053:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802057:	8b 74 24 24          	mov    0x24(%esp),%esi
  80205b:	85 ed                	test   %ebp,%ebp
  80205d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802061:	89 44 24 08          	mov    %eax,0x8(%esp)
  802065:	89 cf                	mov    %ecx,%edi
  802067:	89 04 24             	mov    %eax,(%esp)
  80206a:	89 f2                	mov    %esi,%edx
  80206c:	75 1a                	jne    802088 <__umoddi3+0x48>
  80206e:	39 f1                	cmp    %esi,%ecx
  802070:	76 4e                	jbe    8020c0 <__umoddi3+0x80>
  802072:	f7 f1                	div    %ecx
  802074:	89 d0                	mov    %edx,%eax
  802076:	31 d2                	xor    %edx,%edx
  802078:	8b 74 24 10          	mov    0x10(%esp),%esi
  80207c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802080:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802084:	83 c4 1c             	add    $0x1c,%esp
  802087:	c3                   	ret    
  802088:	39 f5                	cmp    %esi,%ebp
  80208a:	77 54                	ja     8020e0 <__umoddi3+0xa0>
  80208c:	0f bd c5             	bsr    %ebp,%eax
  80208f:	83 f0 1f             	xor    $0x1f,%eax
  802092:	89 44 24 04          	mov    %eax,0x4(%esp)
  802096:	75 60                	jne    8020f8 <__umoddi3+0xb8>
  802098:	3b 0c 24             	cmp    (%esp),%ecx
  80209b:	0f 87 07 01 00 00    	ja     8021a8 <__umoddi3+0x168>
  8020a1:	89 f2                	mov    %esi,%edx
  8020a3:	8b 34 24             	mov    (%esp),%esi
  8020a6:	29 ce                	sub    %ecx,%esi
  8020a8:	19 ea                	sbb    %ebp,%edx
  8020aa:	89 34 24             	mov    %esi,(%esp)
  8020ad:	8b 04 24             	mov    (%esp),%eax
  8020b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020b8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020bc:	83 c4 1c             	add    $0x1c,%esp
  8020bf:	c3                   	ret    
  8020c0:	85 c9                	test   %ecx,%ecx
  8020c2:	75 0b                	jne    8020cf <__umoddi3+0x8f>
  8020c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c9:	31 d2                	xor    %edx,%edx
  8020cb:	f7 f1                	div    %ecx
  8020cd:	89 c1                	mov    %eax,%ecx
  8020cf:	89 f0                	mov    %esi,%eax
  8020d1:	31 d2                	xor    %edx,%edx
  8020d3:	f7 f1                	div    %ecx
  8020d5:	8b 04 24             	mov    (%esp),%eax
  8020d8:	f7 f1                	div    %ecx
  8020da:	eb 98                	jmp    802074 <__umoddi3+0x34>
  8020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	89 f2                	mov    %esi,%edx
  8020e2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020e6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020ea:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ee:	83 c4 1c             	add    $0x1c,%esp
  8020f1:	c3                   	ret    
  8020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020f8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020fd:	89 e8                	mov    %ebp,%eax
  8020ff:	bd 20 00 00 00       	mov    $0x20,%ebp
  802104:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802108:	89 fa                	mov    %edi,%edx
  80210a:	d3 e0                	shl    %cl,%eax
  80210c:	89 e9                	mov    %ebp,%ecx
  80210e:	d3 ea                	shr    %cl,%edx
  802110:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802115:	09 c2                	or     %eax,%edx
  802117:	8b 44 24 08          	mov    0x8(%esp),%eax
  80211b:	89 14 24             	mov    %edx,(%esp)
  80211e:	89 f2                	mov    %esi,%edx
  802120:	d3 e7                	shl    %cl,%edi
  802122:	89 e9                	mov    %ebp,%ecx
  802124:	d3 ea                	shr    %cl,%edx
  802126:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80212b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80212f:	d3 e6                	shl    %cl,%esi
  802131:	89 e9                	mov    %ebp,%ecx
  802133:	d3 e8                	shr    %cl,%eax
  802135:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213a:	09 f0                	or     %esi,%eax
  80213c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802140:	f7 34 24             	divl   (%esp)
  802143:	d3 e6                	shl    %cl,%esi
  802145:	89 74 24 08          	mov    %esi,0x8(%esp)
  802149:	89 d6                	mov    %edx,%esi
  80214b:	f7 e7                	mul    %edi
  80214d:	39 d6                	cmp    %edx,%esi
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	89 d7                	mov    %edx,%edi
  802153:	72 3f                	jb     802194 <__umoddi3+0x154>
  802155:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802159:	72 35                	jb     802190 <__umoddi3+0x150>
  80215b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80215f:	29 c8                	sub    %ecx,%eax
  802161:	19 fe                	sbb    %edi,%esi
  802163:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802168:	89 f2                	mov    %esi,%edx
  80216a:	d3 e8                	shr    %cl,%eax
  80216c:	89 e9                	mov    %ebp,%ecx
  80216e:	d3 e2                	shl    %cl,%edx
  802170:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802175:	09 d0                	or     %edx,%eax
  802177:	89 f2                	mov    %esi,%edx
  802179:	d3 ea                	shr    %cl,%edx
  80217b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80217f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802183:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802187:	83 c4 1c             	add    $0x1c,%esp
  80218a:	c3                   	ret    
  80218b:	90                   	nop
  80218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802190:	39 d6                	cmp    %edx,%esi
  802192:	75 c7                	jne    80215b <__umoddi3+0x11b>
  802194:	89 d7                	mov    %edx,%edi
  802196:	89 c1                	mov    %eax,%ecx
  802198:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80219c:	1b 3c 24             	sbb    (%esp),%edi
  80219f:	eb ba                	jmp    80215b <__umoddi3+0x11b>
  8021a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a8:	39 f5                	cmp    %esi,%ebp
  8021aa:	0f 82 f1 fe ff ff    	jb     8020a1 <__umoddi3+0x61>
  8021b0:	e9 f8 fe ff ff       	jmp    8020ad <__umoddi3+0x6d>
