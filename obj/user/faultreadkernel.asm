
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  80003a:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 c0 21 80 00 	movl   $0x8021c0,(%esp)
  80004a:	e8 14 01 00 00       	call   800163 <cprintf>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    
  800051:	00 00                	add    %al,(%eax)
	...

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
  80005a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80005d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800060:	8b 75 08             	mov    0x8(%ebp),%esi
  800063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800066:	e8 b1 0b 00 00       	call   800c1c <sys_getenvid>
  80006b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800078:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007d:	85 f6                	test   %esi,%esi
  80007f:	7e 07                	jle    800088 <libmain+0x34>
		binaryname = argv[0];
  800081:	8b 03                	mov    (%ebx),%eax
  800083:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 a0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800094:	e8 0b 00 00 00       	call   8000a4 <exit>
}
  800099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80009c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009f:	89 ec                	mov    %ebp,%esp
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
	...

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000aa:	e8 bf 10 00 00       	call   80116e <close_all>
	sys_env_destroy(0);
  8000af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b6:	e8 04 0b 00 00       	call   800bbf <sys_env_destroy>
}
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    
  8000bd:	00 00                	add    %al,(%eax)
	...

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 14             	sub    $0x14,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 03                	mov    (%ebx),%eax
  8000cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cf:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8000d3:	83 c0 01             	add    $0x1,%eax
  8000d6:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	75 19                	jne    8000f8 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000df:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000e6:	00 
  8000e7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ea:	89 04 24             	mov    %eax,(%esp)
  8000ed:	e8 6e 0a 00 00       	call   800b60 <sys_cputs>
		b->idx = 0;
  8000f2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000f8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fc:	83 c4 14             	add    $0x14,%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	8b 45 08             	mov    0x8(%ebp),%eax
  800129:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	c7 04 24 c0 00 80 00 	movl   $0x8000c0,(%esp)
  80013e:	e8 97 01 00 00       	call   8002da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800143:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800153:	89 04 24             	mov    %eax,(%esp)
  800156:	e8 05 0a 00 00       	call   800b60 <sys_cputs>

	return b.cnt;
}
  80015b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800169:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 08             	mov    0x8(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 87 ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    
  80017d:	00 00                	add    %al,(%eax)
	...

00800180 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 3c             	sub    $0x3c,%esp
  800189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80018c:	89 d7                	mov    %edx,%edi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80019d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001a8:	72 11                	jb     8001bb <printnum+0x3b>
  8001aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ad:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b0:	76 09                	jbe    8001bb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001b2:	83 eb 01             	sub    $0x1,%ebx
  8001b5:	85 db                	test   %ebx,%ebx
  8001b7:	7f 51                	jg     80020a <printnum+0x8a>
  8001b9:	eb 5e                	jmp    800219 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001bb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8001bf:	83 eb 01             	sub    $0x1,%ebx
  8001c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8001d1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8001d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001dc:	00 
  8001dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ea:	e8 11 1d 00 00       	call   801f00 <__udivdi3>
  8001ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001f7:	89 04 24             	mov    %eax,(%esp)
  8001fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001fe:	89 fa                	mov    %edi,%edx
  800200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800203:	e8 78 ff ff ff       	call   800180 <printnum>
  800208:	eb 0f                	jmp    800219 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80020e:	89 34 24             	mov    %esi,(%esp)
  800211:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800214:	83 eb 01             	sub    $0x1,%ebx
  800217:	75 f1                	jne    80020a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800219:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80021d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800221:	8b 45 10             	mov    0x10(%ebp),%eax
  800224:	89 44 24 08          	mov    %eax,0x8(%esp)
  800228:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80022f:	00 
  800230:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800233:	89 04 24             	mov    %eax,(%esp)
  800236:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800239:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023d:	e8 ee 1d 00 00       	call   802030 <__umoddi3>
  800242:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800246:	0f be 80 f1 21 80 00 	movsbl 0x8021f1(%eax),%eax
  80024d:	89 04 24             	mov    %eax,(%esp)
  800250:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800253:	83 c4 3c             	add    $0x3c,%esp
  800256:	5b                   	pop    %ebx
  800257:	5e                   	pop    %esi
  800258:	5f                   	pop    %edi
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    

0080025b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80025e:	83 fa 01             	cmp    $0x1,%edx
  800261:	7e 0e                	jle    800271 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800263:	8b 10                	mov    (%eax),%edx
  800265:	8d 4a 08             	lea    0x8(%edx),%ecx
  800268:	89 08                	mov    %ecx,(%eax)
  80026a:	8b 02                	mov    (%edx),%eax
  80026c:	8b 52 04             	mov    0x4(%edx),%edx
  80026f:	eb 22                	jmp    800293 <getuint+0x38>
	else if (lflag)
  800271:	85 d2                	test   %edx,%edx
  800273:	74 10                	je     800285 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800275:	8b 10                	mov    (%eax),%edx
  800277:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027a:	89 08                	mov    %ecx,(%eax)
  80027c:	8b 02                	mov    (%edx),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	eb 0e                	jmp    800293 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800285:	8b 10                	mov    (%eax),%edx
  800287:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028a:	89 08                	mov    %ecx,(%eax)
  80028c:	8b 02                	mov    (%edx),%eax
  80028e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029f:	8b 10                	mov    (%eax),%edx
  8002a1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a4:	73 0a                	jae    8002b0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a9:	88 0a                	mov    %cl,(%edx)
  8002ab:	83 c2 01             	add    $0x1,%edx
  8002ae:	89 10                	mov    %edx,(%eax)
}
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    

008002b2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002b8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 02 00 00 00       	call   8002da <vprintfmt>
	va_end(ap);
}
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	57                   	push   %edi
  8002de:	56                   	push   %esi
  8002df:	53                   	push   %ebx
  8002e0:	83 ec 4c             	sub    $0x4c,%esp
  8002e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e6:	8b 75 10             	mov    0x10(%ebp),%esi
  8002e9:	eb 12                	jmp    8002fd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	0f 84 a9 03 00 00    	je     80069c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8002f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002f7:	89 04 24             	mov    %eax,(%esp)
  8002fa:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002fd:	0f b6 06             	movzbl (%esi),%eax
  800300:	83 c6 01             	add    $0x1,%esi
  800303:	83 f8 25             	cmp    $0x25,%eax
  800306:	75 e3                	jne    8002eb <vprintfmt+0x11>
  800308:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80030c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800313:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800318:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80031f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800324:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800327:	eb 2b                	jmp    800354 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800329:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80032c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800330:	eb 22                	jmp    800354 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800335:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800339:	eb 19                	jmp    800354 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80033e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800345:	eb 0d                	jmp    800354 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800354:	0f b6 06             	movzbl (%esi),%eax
  800357:	0f b6 d0             	movzbl %al,%edx
  80035a:	8d 7e 01             	lea    0x1(%esi),%edi
  80035d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800360:	83 e8 23             	sub    $0x23,%eax
  800363:	3c 55                	cmp    $0x55,%al
  800365:	0f 87 0b 03 00 00    	ja     800676 <vprintfmt+0x39c>
  80036b:	0f b6 c0             	movzbl %al,%eax
  80036e:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800375:	83 ea 30             	sub    $0x30,%edx
  800378:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80037b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80037f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800385:	83 fa 09             	cmp    $0x9,%edx
  800388:	77 4a                	ja     8003d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80038a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80038d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800390:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800393:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800397:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80039a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80039d:	83 fa 09             	cmp    $0x9,%edx
  8003a0:	76 eb                	jbe    80038d <vprintfmt+0xb3>
  8003a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003a5:	eb 2d                	jmp    8003d4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	8d 50 04             	lea    0x4(%eax),%edx
  8003ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003b8:	eb 1a                	jmp    8003d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8003bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003c1:	79 91                	jns    800354 <vprintfmt+0x7a>
  8003c3:	e9 73 ff ff ff       	jmp    80033b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8003d2:	eb 80                	jmp    800354 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8003d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003d8:	0f 89 76 ff ff ff    	jns    800354 <vprintfmt+0x7a>
  8003de:	e9 64 ff ff ff       	jmp    800347 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003e3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003e9:	e9 66 ff ff ff       	jmp    800354 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f1:	8d 50 04             	lea    0x4(%eax),%edx
  8003f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	89 04 24             	mov    %eax,(%esp)
  800400:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800406:	e9 f2 fe ff ff       	jmp    8002fd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 50 04             	lea    0x4(%eax),%edx
  800411:	89 55 14             	mov    %edx,0x14(%ebp)
  800414:	8b 00                	mov    (%eax),%eax
  800416:	89 c2                	mov    %eax,%edx
  800418:	c1 fa 1f             	sar    $0x1f,%edx
  80041b:	31 d0                	xor    %edx,%eax
  80041d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041f:	83 f8 0f             	cmp    $0xf,%eax
  800422:	7f 0b                	jg     80042f <vprintfmt+0x155>
  800424:	8b 14 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%edx
  80042b:	85 d2                	test   %edx,%edx
  80042d:	75 23                	jne    800452 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80042f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800433:	c7 44 24 08 09 22 80 	movl   $0x802209,0x8(%esp)
  80043a:	00 
  80043b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80043f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800442:	89 3c 24             	mov    %edi,(%esp)
  800445:	e8 68 fe ff ff       	call   8002b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80044d:	e9 ab fe ff ff       	jmp    8002fd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800452:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800456:	c7 44 24 08 d1 25 80 	movl   $0x8025d1,0x8(%esp)
  80045d:	00 
  80045e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800462:	8b 7d 08             	mov    0x8(%ebp),%edi
  800465:	89 3c 24             	mov    %edi,(%esp)
  800468:	e8 45 fe ff ff       	call   8002b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800470:	e9 88 fe ff ff       	jmp    8002fd <vprintfmt+0x23>
  800475:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 50 04             	lea    0x4(%eax),%edx
  800484:	89 55 14             	mov    %edx,0x14(%ebp)
  800487:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800489:	85 f6                	test   %esi,%esi
  80048b:	ba 02 22 80 00       	mov    $0x802202,%edx
  800490:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800493:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800497:	7e 06                	jle    80049f <vprintfmt+0x1c5>
  800499:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80049d:	75 10                	jne    8004af <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049f:	0f be 06             	movsbl (%esi),%eax
  8004a2:	83 c6 01             	add    $0x1,%esi
  8004a5:	85 c0                	test   %eax,%eax
  8004a7:	0f 85 86 00 00 00    	jne    800533 <vprintfmt+0x259>
  8004ad:	eb 76                	jmp    800525 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004af:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004b3:	89 34 24             	mov    %esi,(%esp)
  8004b6:	e8 90 02 00 00       	call   80074b <strnlen>
  8004bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004be:	29 c2                	sub    %eax,%edx
  8004c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004c3:	85 d2                	test   %edx,%edx
  8004c5:	7e d8                	jle    80049f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004c7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8004ce:	89 d6                	mov    %edx,%esi
  8004d0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8004d3:	89 c7                	mov    %eax,%edi
  8004d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004d9:	89 3c 24             	mov    %edi,(%esp)
  8004dc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ee 01             	sub    $0x1,%esi
  8004e2:	75 f1                	jne    8004d5 <vprintfmt+0x1fb>
  8004e4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8004e7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8004ea:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8004ed:	eb b0                	jmp    80049f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f3:	74 18                	je     80050d <vprintfmt+0x233>
  8004f5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004f8:	83 fa 5e             	cmp    $0x5e,%edx
  8004fb:	76 10                	jbe    80050d <vprintfmt+0x233>
					putch('?', putdat);
  8004fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800501:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800508:	ff 55 08             	call   *0x8(%ebp)
  80050b:	eb 0a                	jmp    800517 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80050d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800511:	89 04 24             	mov    %eax,(%esp)
  800514:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800517:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80051b:	0f be 06             	movsbl (%esi),%eax
  80051e:	83 c6 01             	add    $0x1,%esi
  800521:	85 c0                	test   %eax,%eax
  800523:	75 0e                	jne    800533 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800528:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052c:	7f 16                	jg     800544 <vprintfmt+0x26a>
  80052e:	e9 ca fd ff ff       	jmp    8002fd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800533:	85 ff                	test   %edi,%edi
  800535:	78 b8                	js     8004ef <vprintfmt+0x215>
  800537:	83 ef 01             	sub    $0x1,%edi
  80053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800540:	79 ad                	jns    8004ef <vprintfmt+0x215>
  800542:	eb e1                	jmp    800525 <vprintfmt+0x24b>
  800544:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800547:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80054a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80054e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800555:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800557:	83 ee 01             	sub    $0x1,%esi
  80055a:	75 ee                	jne    80054a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80055f:	e9 99 fd ff ff       	jmp    8002fd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800564:	83 f9 01             	cmp    $0x1,%ecx
  800567:	7e 10                	jle    800579 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 50 08             	lea    0x8(%eax),%edx
  80056f:	89 55 14             	mov    %edx,0x14(%ebp)
  800572:	8b 30                	mov    (%eax),%esi
  800574:	8b 78 04             	mov    0x4(%eax),%edi
  800577:	eb 26                	jmp    80059f <vprintfmt+0x2c5>
	else if (lflag)
  800579:	85 c9                	test   %ecx,%ecx
  80057b:	74 12                	je     80058f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 50 04             	lea    0x4(%eax),%edx
  800583:	89 55 14             	mov    %edx,0x14(%ebp)
  800586:	8b 30                	mov    (%eax),%esi
  800588:	89 f7                	mov    %esi,%edi
  80058a:	c1 ff 1f             	sar    $0x1f,%edi
  80058d:	eb 10                	jmp    80059f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	89 55 14             	mov    %edx,0x14(%ebp)
  800598:	8b 30                	mov    (%eax),%esi
  80059a:	89 f7                	mov    %esi,%edi
  80059c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80059f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005a4:	85 ff                	test   %edi,%edi
  8005a6:	0f 89 8c 00 00 00    	jns    800638 <vprintfmt+0x35e>
				putch('-', putdat);
  8005ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005b7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005ba:	f7 de                	neg    %esi
  8005bc:	83 d7 00             	adc    $0x0,%edi
  8005bf:	f7 df                	neg    %edi
			}
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	eb 70                	jmp    800638 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005c8:	89 ca                	mov    %ecx,%edx
  8005ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8005cd:	e8 89 fc ff ff       	call   80025b <getuint>
  8005d2:	89 c6                	mov    %eax,%esi
  8005d4:	89 d7                	mov    %edx,%edi
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8005db:	eb 5b                	jmp    800638 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8005dd:	89 ca                	mov    %ecx,%edx
  8005df:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e2:	e8 74 fc ff ff       	call   80025b <getuint>
  8005e7:	89 c6                	mov    %eax,%esi
  8005e9:	89 d7                	mov    %edx,%edi
			base = 8;
  8005eb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005f0:	eb 46                	jmp    800638 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8005f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8005fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800600:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800604:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80060b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800617:	8b 30                	mov    (%eax),%esi
  800619:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80061e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800623:	eb 13                	jmp    800638 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800625:	89 ca                	mov    %ecx,%edx
  800627:	8d 45 14             	lea    0x14(%ebp),%eax
  80062a:	e8 2c fc ff ff       	call   80025b <getuint>
  80062f:	89 c6                	mov    %eax,%esi
  800631:	89 d7                	mov    %edx,%edi
			base = 16;
  800633:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800638:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80063c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800643:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800647:	89 44 24 08          	mov    %eax,0x8(%esp)
  80064b:	89 34 24             	mov    %esi,(%esp)
  80064e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800652:	89 da                	mov    %ebx,%edx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	e8 24 fb ff ff       	call   800180 <printnum>
			break;
  80065c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80065f:	e9 99 fc ff ff       	jmp    8002fd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800664:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800668:	89 14 24             	mov    %edx,(%esp)
  80066b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800671:	e9 87 fc ff ff       	jmp    8002fd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800676:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80067a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800681:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800684:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800688:	0f 84 6f fc ff ff    	je     8002fd <vprintfmt+0x23>
  80068e:	83 ee 01             	sub    $0x1,%esi
  800691:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800695:	75 f7                	jne    80068e <vprintfmt+0x3b4>
  800697:	e9 61 fc ff ff       	jmp    8002fd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80069c:	83 c4 4c             	add    $0x4c,%esp
  80069f:	5b                   	pop    %ebx
  8006a0:	5e                   	pop    %esi
  8006a1:	5f                   	pop    %edi
  8006a2:	5d                   	pop    %ebp
  8006a3:	c3                   	ret    

008006a4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 28             	sub    $0x28,%esp
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006b3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006b7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006c1:	85 c0                	test   %eax,%eax
  8006c3:	74 30                	je     8006f5 <vsnprintf+0x51>
  8006c5:	85 d2                	test   %edx,%edx
  8006c7:	7e 2c                	jle    8006f5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006de:	c7 04 24 95 02 80 00 	movl   $0x800295,(%esp)
  8006e5:	e8 f0 fb ff ff       	call   8002da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f3:	eb 05                	jmp    8006fa <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800702:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800705:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800709:	8b 45 10             	mov    0x10(%ebp),%eax
  80070c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800710:	8b 45 0c             	mov    0xc(%ebp),%eax
  800713:	89 44 24 04          	mov    %eax,0x4(%esp)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 04 24             	mov    %eax,(%esp)
  80071d:	e8 82 ff ff ff       	call   8006a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800722:	c9                   	leave  
  800723:	c3                   	ret    
	...

00800730 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800736:	b8 00 00 00 00       	mov    $0x0,%eax
  80073b:	80 3a 00             	cmpb   $0x0,(%edx)
  80073e:	74 09                	je     800749 <strlen+0x19>
		n++;
  800740:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800743:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800747:	75 f7                	jne    800740 <strlen+0x10>
		n++;
	return n;
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	53                   	push   %ebx
  80074f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800755:	b8 00 00 00 00       	mov    $0x0,%eax
  80075a:	85 c9                	test   %ecx,%ecx
  80075c:	74 1a                	je     800778 <strnlen+0x2d>
  80075e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800761:	74 15                	je     800778 <strnlen+0x2d>
  800763:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800768:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076a:	39 ca                	cmp    %ecx,%edx
  80076c:	74 0a                	je     800778 <strnlen+0x2d>
  80076e:	83 c2 01             	add    $0x1,%edx
  800771:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800776:	75 f0                	jne    800768 <strnlen+0x1d>
		n++;
	return n;
}
  800778:	5b                   	pop    %ebx
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    

0080077b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	53                   	push   %ebx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800785:	ba 00 00 00 00       	mov    $0x0,%edx
  80078a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80078e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800791:	83 c2 01             	add    $0x1,%edx
  800794:	84 c9                	test   %cl,%cl
  800796:	75 f2                	jne    80078a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800798:	5b                   	pop    %ebx
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a5:	89 1c 24             	mov    %ebx,(%esp)
  8007a8:	e8 83 ff ff ff       	call   800730 <strlen>
	strcpy(dst + len, src);
  8007ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	89 04 24             	mov    %eax,(%esp)
  8007b9:	e8 bd ff ff ff       	call   80077b <strcpy>
	return dst;
}
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 c4 08             	add    $0x8,%esp
  8007c3:	5b                   	pop    %ebx
  8007c4:	5d                   	pop    %ebp
  8007c5:	c3                   	ret    

008007c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	56                   	push   %esi
  8007ca:	53                   	push   %ebx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d4:	85 f6                	test   %esi,%esi
  8007d6:	74 18                	je     8007f0 <strncpy+0x2a>
  8007d8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8007dd:	0f b6 1a             	movzbl (%edx),%ebx
  8007e0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e3:	80 3a 01             	cmpb   $0x1,(%edx)
  8007e6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e9:	83 c1 01             	add    $0x1,%ecx
  8007ec:	39 f1                	cmp    %esi,%ecx
  8007ee:	75 ed                	jne    8007dd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007f0:	5b                   	pop    %ebx
  8007f1:	5e                   	pop    %esi
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	57                   	push   %edi
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800800:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800803:	89 f8                	mov    %edi,%eax
  800805:	85 f6                	test   %esi,%esi
  800807:	74 2b                	je     800834 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800809:	83 fe 01             	cmp    $0x1,%esi
  80080c:	74 23                	je     800831 <strlcpy+0x3d>
  80080e:	0f b6 0b             	movzbl (%ebx),%ecx
  800811:	84 c9                	test   %cl,%cl
  800813:	74 1c                	je     800831 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800815:	83 ee 02             	sub    $0x2,%esi
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80081d:	88 08                	mov    %cl,(%eax)
  80081f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800822:	39 f2                	cmp    %esi,%edx
  800824:	74 0b                	je     800831 <strlcpy+0x3d>
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80082d:	84 c9                	test   %cl,%cl
  80082f:	75 ec                	jne    80081d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800831:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800834:	29 f8                	sub    %edi,%eax
}
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5f                   	pop    %edi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800841:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800844:	0f b6 01             	movzbl (%ecx),%eax
  800847:	84 c0                	test   %al,%al
  800849:	74 16                	je     800861 <strcmp+0x26>
  80084b:	3a 02                	cmp    (%edx),%al
  80084d:	75 12                	jne    800861 <strcmp+0x26>
		p++, q++;
  80084f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800852:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800856:	84 c0                	test   %al,%al
  800858:	74 07                	je     800861 <strcmp+0x26>
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	3a 02                	cmp    (%edx),%al
  80085f:	74 ee                	je     80084f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800861:	0f b6 c0             	movzbl %al,%eax
  800864:	0f b6 12             	movzbl (%edx),%edx
  800867:	29 d0                	sub    %edx,%eax
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800872:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800875:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80087d:	85 d2                	test   %edx,%edx
  80087f:	74 28                	je     8008a9 <strncmp+0x3e>
  800881:	0f b6 01             	movzbl (%ecx),%eax
  800884:	84 c0                	test   %al,%al
  800886:	74 24                	je     8008ac <strncmp+0x41>
  800888:	3a 03                	cmp    (%ebx),%al
  80088a:	75 20                	jne    8008ac <strncmp+0x41>
  80088c:	83 ea 01             	sub    $0x1,%edx
  80088f:	74 13                	je     8008a4 <strncmp+0x39>
		n--, p++, q++;
  800891:	83 c1 01             	add    $0x1,%ecx
  800894:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800897:	0f b6 01             	movzbl (%ecx),%eax
  80089a:	84 c0                	test   %al,%al
  80089c:	74 0e                	je     8008ac <strncmp+0x41>
  80089e:	3a 03                	cmp    (%ebx),%al
  8008a0:	74 ea                	je     80088c <strncmp+0x21>
  8008a2:	eb 08                	jmp    8008ac <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008a9:	5b                   	pop    %ebx
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ac:	0f b6 01             	movzbl (%ecx),%eax
  8008af:	0f b6 13             	movzbl (%ebx),%edx
  8008b2:	29 d0                	sub    %edx,%eax
  8008b4:	eb f3                	jmp    8008a9 <strncmp+0x3e>

008008b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c0:	0f b6 10             	movzbl (%eax),%edx
  8008c3:	84 d2                	test   %dl,%dl
  8008c5:	74 1c                	je     8008e3 <strchr+0x2d>
		if (*s == c)
  8008c7:	38 ca                	cmp    %cl,%dl
  8008c9:	75 09                	jne    8008d4 <strchr+0x1e>
  8008cb:	eb 1b                	jmp    8008e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008cd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8008d0:	38 ca                	cmp    %cl,%dl
  8008d2:	74 14                	je     8008e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008d4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8008d8:	84 d2                	test   %dl,%dl
  8008da:	75 f1                	jne    8008cd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8008dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e1:	eb 05                	jmp    8008e8 <strchr+0x32>
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f4:	0f b6 10             	movzbl (%eax),%edx
  8008f7:	84 d2                	test   %dl,%dl
  8008f9:	74 14                	je     80090f <strfind+0x25>
		if (*s == c)
  8008fb:	38 ca                	cmp    %cl,%dl
  8008fd:	75 06                	jne    800905 <strfind+0x1b>
  8008ff:	eb 0e                	jmp    80090f <strfind+0x25>
  800901:	38 ca                	cmp    %cl,%dl
  800903:	74 0a                	je     80090f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800905:	83 c0 01             	add    $0x1,%eax
  800908:	0f b6 10             	movzbl (%eax),%edx
  80090b:	84 d2                	test   %dl,%dl
  80090d:	75 f2                	jne    800901 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80091a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80091d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800920:	8b 7d 08             	mov    0x8(%ebp),%edi
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800929:	85 c9                	test   %ecx,%ecx
  80092b:	74 30                	je     80095d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800933:	75 25                	jne    80095a <memset+0x49>
  800935:	f6 c1 03             	test   $0x3,%cl
  800938:	75 20                	jne    80095a <memset+0x49>
		c &= 0xFF;
  80093a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093d:	89 d3                	mov    %edx,%ebx
  80093f:	c1 e3 08             	shl    $0x8,%ebx
  800942:	89 d6                	mov    %edx,%esi
  800944:	c1 e6 18             	shl    $0x18,%esi
  800947:	89 d0                	mov    %edx,%eax
  800949:	c1 e0 10             	shl    $0x10,%eax
  80094c:	09 f0                	or     %esi,%eax
  80094e:	09 d0                	or     %edx,%eax
  800950:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800952:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800955:	fc                   	cld    
  800956:	f3 ab                	rep stos %eax,%es:(%edi)
  800958:	eb 03                	jmp    80095d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095a:	fc                   	cld    
  80095b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800962:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800965:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800968:	89 ec                	mov    %ebp,%esp
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800975:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800981:	39 c6                	cmp    %eax,%esi
  800983:	73 36                	jae    8009bb <memmove+0x4f>
  800985:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800988:	39 d0                	cmp    %edx,%eax
  80098a:	73 2f                	jae    8009bb <memmove+0x4f>
		s += n;
		d += n;
  80098c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098f:	f6 c2 03             	test   $0x3,%dl
  800992:	75 1b                	jne    8009af <memmove+0x43>
  800994:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099a:	75 13                	jne    8009af <memmove+0x43>
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 0e                	jne    8009af <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a1:	83 ef 04             	sub    $0x4,%edi
  8009a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009aa:	fd                   	std    
  8009ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ad:	eb 09                	jmp    8009b8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009af:	83 ef 01             	sub    $0x1,%edi
  8009b2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b8:	fc                   	cld    
  8009b9:	eb 20                	jmp    8009db <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c1:	75 13                	jne    8009d6 <memmove+0x6a>
  8009c3:	a8 03                	test   $0x3,%al
  8009c5:	75 0f                	jne    8009d6 <memmove+0x6a>
  8009c7:	f6 c1 03             	test   $0x3,%cl
  8009ca:	75 0a                	jne    8009d6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009cc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009cf:	89 c7                	mov    %eax,%edi
  8009d1:	fc                   	cld    
  8009d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d4:	eb 05                	jmp    8009db <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d6:	89 c7                	mov    %eax,%edi
  8009d8:	fc                   	cld    
  8009d9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009e1:	89 ec                	mov    %ebp,%esp
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	89 04 24             	mov    %eax,(%esp)
  8009ff:	e8 68 ff ff ff       	call   80096c <memmove>
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	57                   	push   %edi
  800a0a:	56                   	push   %esi
  800a0b:	53                   	push   %ebx
  800a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a12:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1a:	85 ff                	test   %edi,%edi
  800a1c:	74 37                	je     800a55 <memcmp+0x4f>
		if (*s1 != *s2)
  800a1e:	0f b6 03             	movzbl (%ebx),%eax
  800a21:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a24:	83 ef 01             	sub    $0x1,%edi
  800a27:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a2c:	38 c8                	cmp    %cl,%al
  800a2e:	74 1c                	je     800a4c <memcmp+0x46>
  800a30:	eb 10                	jmp    800a42 <memcmp+0x3c>
  800a32:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a37:	83 c2 01             	add    $0x1,%edx
  800a3a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a3e:	38 c8                	cmp    %cl,%al
  800a40:	74 0a                	je     800a4c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800a42:	0f b6 c0             	movzbl %al,%eax
  800a45:	0f b6 c9             	movzbl %cl,%ecx
  800a48:	29 c8                	sub    %ecx,%eax
  800a4a:	eb 09                	jmp    800a55 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4c:	39 fa                	cmp    %edi,%edx
  800a4e:	75 e2                	jne    800a32 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5f                   	pop    %edi
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a60:	89 c2                	mov    %eax,%edx
  800a62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a65:	39 d0                	cmp    %edx,%eax
  800a67:	73 19                	jae    800a82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800a6d:	38 08                	cmp    %cl,(%eax)
  800a6f:	75 06                	jne    800a77 <memfind+0x1d>
  800a71:	eb 0f                	jmp    800a82 <memfind+0x28>
  800a73:	38 08                	cmp    %cl,(%eax)
  800a75:	74 0b                	je     800a82 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a77:	83 c0 01             	add    $0x1,%eax
  800a7a:	39 d0                	cmp    %edx,%eax
  800a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a80:	75 f1                	jne    800a73 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a90:	0f b6 02             	movzbl (%edx),%eax
  800a93:	3c 20                	cmp    $0x20,%al
  800a95:	74 04                	je     800a9b <strtol+0x17>
  800a97:	3c 09                	cmp    $0x9,%al
  800a99:	75 0e                	jne    800aa9 <strtol+0x25>
		s++;
  800a9b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9e:	0f b6 02             	movzbl (%edx),%eax
  800aa1:	3c 20                	cmp    $0x20,%al
  800aa3:	74 f6                	je     800a9b <strtol+0x17>
  800aa5:	3c 09                	cmp    $0x9,%al
  800aa7:	74 f2                	je     800a9b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800aa9:	3c 2b                	cmp    $0x2b,%al
  800aab:	75 0a                	jne    800ab7 <strtol+0x33>
		s++;
  800aad:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab5:	eb 10                	jmp    800ac7 <strtol+0x43>
  800ab7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800abc:	3c 2d                	cmp    $0x2d,%al
  800abe:	75 07                	jne    800ac7 <strtol+0x43>
		s++, neg = 1;
  800ac0:	83 c2 01             	add    $0x1,%edx
  800ac3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	0f 94 c0             	sete   %al
  800acc:	74 05                	je     800ad3 <strtol+0x4f>
  800ace:	83 fb 10             	cmp    $0x10,%ebx
  800ad1:	75 15                	jne    800ae8 <strtol+0x64>
  800ad3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ad6:	75 10                	jne    800ae8 <strtol+0x64>
  800ad8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800adc:	75 0a                	jne    800ae8 <strtol+0x64>
		s += 2, base = 16;
  800ade:	83 c2 02             	add    $0x2,%edx
  800ae1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae6:	eb 13                	jmp    800afb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800ae8:	84 c0                	test   %al,%al
  800aea:	74 0f                	je     800afb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aec:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af1:	80 3a 30             	cmpb   $0x30,(%edx)
  800af4:	75 05                	jne    800afb <strtol+0x77>
		s++, base = 8;
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b02:	0f b6 0a             	movzbl (%edx),%ecx
  800b05:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b08:	80 fb 09             	cmp    $0x9,%bl
  800b0b:	77 08                	ja     800b15 <strtol+0x91>
			dig = *s - '0';
  800b0d:	0f be c9             	movsbl %cl,%ecx
  800b10:	83 e9 30             	sub    $0x30,%ecx
  800b13:	eb 1e                	jmp    800b33 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b15:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b1d:	0f be c9             	movsbl %cl,%ecx
  800b20:	83 e9 57             	sub    $0x57,%ecx
  800b23:	eb 0e                	jmp    800b33 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b25:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b28:	80 fb 19             	cmp    $0x19,%bl
  800b2b:	77 14                	ja     800b41 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b2d:	0f be c9             	movsbl %cl,%ecx
  800b30:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b33:	39 f1                	cmp    %esi,%ecx
  800b35:	7d 0e                	jge    800b45 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	0f af c6             	imul   %esi,%eax
  800b3d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800b3f:	eb c1                	jmp    800b02 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800b41:	89 c1                	mov    %eax,%ecx
  800b43:	eb 02                	jmp    800b47 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b45:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4b:	74 05                	je     800b52 <strtol+0xce>
		*endptr = (char *) s;
  800b4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b50:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b52:	89 ca                	mov    %ecx,%edx
  800b54:	f7 da                	neg    %edx
  800b56:	85 ff                	test   %edi,%edi
  800b58:	0f 45 c2             	cmovne %edx,%eax
}
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5f                   	pop    %edi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 0c             	sub    $0xc,%esp
  800b66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b77:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7a:	89 c3                	mov    %eax,%ebx
  800b7c:	89 c7                	mov    %eax,%edi
  800b7e:	89 c6                	mov    %eax,%esi
  800b80:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b8b:	89 ec                	mov    %ebp,%esp
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba8:	89 d1                	mov    %edx,%ecx
  800baa:	89 d3                	mov    %edx,%ebx
  800bac:	89 d7                	mov    %edx,%edi
  800bae:	89 d6                	mov    %edx,%esi
  800bb0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bbb:	89 ec                	mov    %ebp,%esp
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 38             	sub    $0x38,%esp
  800bc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bcb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	89 cb                	mov    %ecx,%ebx
  800bdd:	89 cf                	mov    %ecx,%edi
  800bdf:	89 ce                	mov    %ecx,%esi
  800be1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800be3:	85 c0                	test   %eax,%eax
  800be5:	7e 28                	jle    800c0f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800be7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800beb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bf2:	00 
  800bf3:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800bfa:	00 
  800bfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c02:	00 
  800c03:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800c0a:	e8 31 11 00 00       	call   801d40 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c18:	89 ec                	mov    %ebp,%esp
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 02 00 00 00       	mov    $0x2,%eax
  800c35:	89 d1                	mov    %edx,%ecx
  800c37:	89 d3                	mov    %edx,%ebx
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	89 d6                	mov    %edx,%esi
  800c3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c48:	89 ec                	mov    %ebp,%esp
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <sys_yield>:

void
sys_yield(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c78:	89 ec                	mov    %ebp,%esp
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 38             	sub    $0x38,%esp
  800c82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8b:	be 00 00 00 00       	mov    $0x0,%esi
  800c90:	b8 04 00 00 00       	mov    $0x4,%eax
  800c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	89 f7                	mov    %esi,%edi
  800ca0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7e 28                	jle    800cce <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800caa:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb1:	00 
  800cb2:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800cb9:	00 
  800cba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc1:	00 
  800cc2:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800cc9:	e8 72 10 00 00       	call   801d40 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cd1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cd4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cd7:	89 ec                	mov    %ebp,%esp
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 38             	sub    $0x38,%esp
  800ce1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ce4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ce7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	b8 05 00 00 00       	mov    $0x5,%eax
  800cef:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7e 28                	jle    800d2c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d04:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d08:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d0f:	00 
  800d10:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d17:	00 
  800d18:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1f:	00 
  800d20:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800d27:	e8 14 10 00 00       	call   801d40 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d2f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d32:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d35:	89 ec                	mov    %ebp,%esp
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 38             	sub    $0x38,%esp
  800d3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d45:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	89 df                	mov    %ebx,%edi
  800d5a:	89 de                	mov    %ebx,%esi
  800d5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	7e 28                	jle    800d8a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d66:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d6d:	00 
  800d6e:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800d75:	00 
  800d76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7d:	00 
  800d7e:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800d85:	e8 b6 0f 00 00       	call   801d40 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d93:	89 ec                	mov    %ebp,%esp
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 38             	sub    $0x38,%esp
  800d9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800da0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800da3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	b8 08 00 00 00       	mov    $0x8,%eax
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7e 28                	jle    800de8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dcb:	00 
  800dcc:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800dd3:	00 
  800dd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ddb:	00 
  800ddc:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800de3:	e8 58 0f 00 00       	call   801d40 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800deb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df1:	89 ec                	mov    %ebp,%esp
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 38             	sub    $0x38,%esp
  800dfb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dfe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7e 28                	jle    800e46 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e22:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e29:	00 
  800e2a:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800e31:	00 
  800e32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e39:	00 
  800e3a:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800e41:	e8 fa 0e 00 00       	call   801d40 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e4f:	89 ec                	mov    %ebp,%esp
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 38             	sub    $0x38,%esp
  800e59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	89 df                	mov    %ebx,%edi
  800e74:	89 de                	mov    %ebx,%esi
  800e76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7e 28                	jle    800ea4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e80:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e87:	00 
  800e88:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800e8f:	00 
  800e90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e97:	00 
  800e98:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800e9f:	e8 9c 0e 00 00       	call   801d40 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eaa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ead:	89 ec                	mov    %ebp,%esp
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	be 00 00 00 00       	mov    $0x0,%esi
  800ec5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800edb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ede:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee1:	89 ec                	mov    %ebp,%esp
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
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
  800ef4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	89 cb                	mov    %ecx,%ebx
  800f03:	89 cf                	mov    %ecx,%edi
  800f05:	89 ce                	mov    %ecx,%esi
  800f07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	7e 28                	jle    800f35 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f11:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f18:	00 
  800f19:	c7 44 24 08 ff 24 80 	movl   $0x8024ff,0x8(%esp)
  800f20:	00 
  800f21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f28:	00 
  800f29:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  800f30:	e8 0b 0e 00 00       	call   801d40 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f35:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f38:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f3b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3e:	89 ec                	mov    %ebp,%esp
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
	...

00800f50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	05 00 00 00 30       	add    $0x30000000,%eax
  800f5b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	89 04 24             	mov    %eax,(%esp)
  800f6c:	e8 df ff ff ff       	call   800f50 <fd2num>
  800f71:	05 20 00 0d 00       	add    $0xd0020,%eax
  800f76:	c1 e0 0c             	shl    $0xc,%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	53                   	push   %ebx
  800f7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f82:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800f87:	a8 01                	test   $0x1,%al
  800f89:	74 34                	je     800fbf <fd_alloc+0x44>
  800f8b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800f90:	a8 01                	test   $0x1,%al
  800f92:	74 32                	je     800fc6 <fd_alloc+0x4b>
  800f94:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f99:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f9b:	89 c2                	mov    %eax,%edx
  800f9d:	c1 ea 16             	shr    $0x16,%edx
  800fa0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fa7:	f6 c2 01             	test   $0x1,%dl
  800faa:	74 1f                	je     800fcb <fd_alloc+0x50>
  800fac:	89 c2                	mov    %eax,%edx
  800fae:	c1 ea 0c             	shr    $0xc,%edx
  800fb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb8:	f6 c2 01             	test   $0x1,%dl
  800fbb:	75 17                	jne    800fd4 <fd_alloc+0x59>
  800fbd:	eb 0c                	jmp    800fcb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fbf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800fc4:	eb 05                	jmp    800fcb <fd_alloc+0x50>
  800fc6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800fcb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd2:	eb 17                	jmp    800feb <fd_alloc+0x70>
  800fd4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fd9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fde:	75 b9                	jne    800f99 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fe0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800fe6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800feb:	5b                   	pop    %ebx
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ff4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ff9:	83 fa 1f             	cmp    $0x1f,%edx
  800ffc:	77 3f                	ja     80103d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ffe:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801004:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801007:	89 d0                	mov    %edx,%eax
  801009:	c1 e8 16             	shr    $0x16,%eax
  80100c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801013:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801018:	f6 c1 01             	test   $0x1,%cl
  80101b:	74 20                	je     80103d <fd_lookup+0x4f>
  80101d:	89 d0                	mov    %edx,%eax
  80101f:	c1 e8 0c             	shr    $0xc,%eax
  801022:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80102e:	f6 c1 01             	test   $0x1,%cl
  801031:	74 0a                	je     80103d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 10                	mov    %edx,(%eax)
	return 0;
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	53                   	push   %ebx
  801043:	83 ec 14             	sub    $0x14,%esp
  801046:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801049:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801051:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801057:	75 17                	jne    801070 <dev_lookup+0x31>
  801059:	eb 07                	jmp    801062 <dev_lookup+0x23>
  80105b:	39 0a                	cmp    %ecx,(%edx)
  80105d:	75 11                	jne    801070 <dev_lookup+0x31>
  80105f:	90                   	nop
  801060:	eb 05                	jmp    801067 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801062:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801067:	89 13                	mov    %edx,(%ebx)
			return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
  80106e:	eb 35                	jmp    8010a5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801070:	83 c0 01             	add    $0x1,%eax
  801073:	8b 14 85 a8 25 80 00 	mov    0x8025a8(,%eax,4),%edx
  80107a:	85 d2                	test   %edx,%edx
  80107c:	75 dd                	jne    80105b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80107e:	a1 04 40 80 00       	mov    0x804004,%eax
  801083:	8b 40 48             	mov    0x48(%eax),%eax
  801086:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80108a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108e:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  801095:	e8 c9 f0 ff ff       	call   800163 <cprintf>
	*dev = 0;
  80109a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010a5:	83 c4 14             	add    $0x14,%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 38             	sub    $0x38,%esp
  8010b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010bd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c1:	89 3c 24             	mov    %edi,(%esp)
  8010c4:	e8 87 fe ff ff       	call   800f50 <fd2num>
  8010c9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8010cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010d0:	89 04 24             	mov    %eax,(%esp)
  8010d3:	e8 16 ff ff ff       	call   800fee <fd_lookup>
  8010d8:	89 c3                	mov    %eax,%ebx
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 05                	js     8010e3 <fd_close+0x38>
	    || fd != fd2)
  8010de:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8010e1:	74 0e                	je     8010f1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010e3:	89 f0                	mov    %esi,%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ec:	0f 44 d8             	cmove  %eax,%ebx
  8010ef:	eb 3d                	jmp    80112e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f8:	8b 07                	mov    (%edi),%eax
  8010fa:	89 04 24             	mov    %eax,(%esp)
  8010fd:	e8 3d ff ff ff       	call   80103f <dev_lookup>
  801102:	89 c3                	mov    %eax,%ebx
  801104:	85 c0                	test   %eax,%eax
  801106:	78 16                	js     80111e <fd_close+0x73>
		if (dev->dev_close)
  801108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80110b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80110e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801113:	85 c0                	test   %eax,%eax
  801115:	74 07                	je     80111e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801117:	89 3c 24             	mov    %edi,(%esp)
  80111a:	ff d0                	call   *%eax
  80111c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80111e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801129:	e8 0b fc ff ff       	call   800d39 <sys_page_unmap>
	return r;
}
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801133:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801136:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801139:	89 ec                	mov    %ebp,%esp
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	89 04 24             	mov    %eax,(%esp)
  801150:	e8 99 fe ff ff       	call   800fee <fd_lookup>
  801155:	85 c0                	test   %eax,%eax
  801157:	78 13                	js     80116c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801160:	00 
  801161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801164:	89 04 24             	mov    %eax,(%esp)
  801167:	e8 3f ff ff ff       	call   8010ab <fd_close>
}
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    

0080116e <close_all>:

void
close_all(void)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	53                   	push   %ebx
  801172:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801175:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80117a:	89 1c 24             	mov    %ebx,(%esp)
  80117d:	e8 bb ff ff ff       	call   80113d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801182:	83 c3 01             	add    $0x1,%ebx
  801185:	83 fb 20             	cmp    $0x20,%ebx
  801188:	75 f0                	jne    80117a <close_all+0xc>
		close(i);
}
  80118a:	83 c4 14             	add    $0x14,%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 58             	sub    $0x58,%esp
  801196:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801199:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80119f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	89 04 24             	mov    %eax,(%esp)
  8011af:	e8 3a fe ff ff       	call   800fee <fd_lookup>
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	0f 88 e1 00 00 00    	js     80129f <dup+0x10f>
		return r;
	close(newfdnum);
  8011be:	89 3c 24             	mov    %edi,(%esp)
  8011c1:	e8 77 ff ff ff       	call   80113d <close>

	newfd = INDEX2FD(newfdnum);
  8011c6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8011cc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8011cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d2:	89 04 24             	mov    %eax,(%esp)
  8011d5:	e8 86 fd ff ff       	call   800f60 <fd2data>
  8011da:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011dc:	89 34 24             	mov    %esi,(%esp)
  8011df:	e8 7c fd ff ff       	call   800f60 <fd2data>
  8011e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011e7:	89 d8                	mov    %ebx,%eax
  8011e9:	c1 e8 16             	shr    $0x16,%eax
  8011ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f3:	a8 01                	test   $0x1,%al
  8011f5:	74 46                	je     80123d <dup+0xad>
  8011f7:	89 d8                	mov    %ebx,%eax
  8011f9:	c1 e8 0c             	shr    $0xc,%eax
  8011fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801203:	f6 c2 01             	test   $0x1,%dl
  801206:	74 35                	je     80123d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801208:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120f:	25 07 0e 00 00       	and    $0xe07,%eax
  801214:	89 44 24 10          	mov    %eax,0x10(%esp)
  801218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80121b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80121f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801226:	00 
  801227:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80122b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801232:	e8 a4 fa ff ff       	call   800cdb <sys_page_map>
  801237:	89 c3                	mov    %eax,%ebx
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 3b                	js     801278 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80123d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801240:	89 c2                	mov    %eax,%edx
  801242:	c1 ea 0c             	shr    $0xc,%edx
  801245:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801252:	89 54 24 10          	mov    %edx,0x10(%esp)
  801256:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80125a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801261:	00 
  801262:	89 44 24 04          	mov    %eax,0x4(%esp)
  801266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126d:	e8 69 fa ff ff       	call   800cdb <sys_page_map>
  801272:	89 c3                	mov    %eax,%ebx
  801274:	85 c0                	test   %eax,%eax
  801276:	79 25                	jns    80129d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801278:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801283:	e8 b1 fa ff ff       	call   800d39 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80128b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801296:	e8 9e fa ff ff       	call   800d39 <sys_page_unmap>
	return r;
  80129b:	eb 02                	jmp    80129f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80129d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012aa:	89 ec                	mov    %ebp,%esp
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 24             	sub    $0x24,%esp
  8012b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bf:	89 1c 24             	mov    %ebx,(%esp)
  8012c2:	e8 27 fd ff ff       	call   800fee <fd_lookup>
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 6d                	js     801338 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	89 04 24             	mov    %eax,(%esp)
  8012da:	e8 60 fd ff ff       	call   80103f <dev_lookup>
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	78 55                	js     801338 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e6:	8b 50 08             	mov    0x8(%eax),%edx
  8012e9:	83 e2 03             	and    $0x3,%edx
  8012ec:	83 fa 01             	cmp    $0x1,%edx
  8012ef:	75 23                	jne    801314 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f1:	a1 04 40 80 00       	mov    0x804004,%eax
  8012f6:	8b 40 48             	mov    0x48(%eax),%eax
  8012f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801301:	c7 04 24 6d 25 80 00 	movl   $0x80256d,(%esp)
  801308:	e8 56 ee ff ff       	call   800163 <cprintf>
		return -E_INVAL;
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801312:	eb 24                	jmp    801338 <read+0x8a>
	}
	if (!dev->dev_read)
  801314:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801317:	8b 52 08             	mov    0x8(%edx),%edx
  80131a:	85 d2                	test   %edx,%edx
  80131c:	74 15                	je     801333 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80131e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801321:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801328:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80132c:	89 04 24             	mov    %eax,(%esp)
  80132f:	ff d2                	call   *%edx
  801331:	eb 05                	jmp    801338 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801333:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801338:	83 c4 24             	add    $0x24,%esp
  80133b:	5b                   	pop    %ebx
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	83 ec 1c             	sub    $0x1c,%esp
  801347:	8b 7d 08             	mov    0x8(%ebp),%edi
  80134a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	85 f6                	test   %esi,%esi
  801354:	74 30                	je     801386 <readn+0x48>
  801356:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135b:	89 f2                	mov    %esi,%edx
  80135d:	29 c2                	sub    %eax,%edx
  80135f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801363:	03 45 0c             	add    0xc(%ebp),%eax
  801366:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136a:	89 3c 24             	mov    %edi,(%esp)
  80136d:	e8 3c ff ff ff       	call   8012ae <read>
		if (m < 0)
  801372:	85 c0                	test   %eax,%eax
  801374:	78 10                	js     801386 <readn+0x48>
			return m;
		if (m == 0)
  801376:	85 c0                	test   %eax,%eax
  801378:	74 0a                	je     801384 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137a:	01 c3                	add    %eax,%ebx
  80137c:	89 d8                	mov    %ebx,%eax
  80137e:	39 f3                	cmp    %esi,%ebx
  801380:	72 d9                	jb     80135b <readn+0x1d>
  801382:	eb 02                	jmp    801386 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801384:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801386:	83 c4 1c             	add    $0x1c,%esp
  801389:	5b                   	pop    %ebx
  80138a:	5e                   	pop    %esi
  80138b:	5f                   	pop    %edi
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 24             	sub    $0x24,%esp
  801395:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801398:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139f:	89 1c 24             	mov    %ebx,(%esp)
  8013a2:	e8 47 fc ff ff       	call   800fee <fd_lookup>
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 68                	js     801413 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	89 04 24             	mov    %eax,(%esp)
  8013ba:	e8 80 fc ff ff       	call   80103f <dev_lookup>
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 50                	js     801413 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ca:	75 23                	jne    8013ef <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cc:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d1:	8b 40 48             	mov    0x48(%eax),%eax
  8013d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dc:	c7 04 24 89 25 80 00 	movl   $0x802589,(%esp)
  8013e3:	e8 7b ed ff ff       	call   800163 <cprintf>
		return -E_INVAL;
  8013e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ed:	eb 24                	jmp    801413 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	74 15                	je     80140e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801400:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801403:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801407:	89 04 24             	mov    %eax,(%esp)
  80140a:	ff d2                	call   *%edx
  80140c:	eb 05                	jmp    801413 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80140e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801413:	83 c4 24             	add    $0x24,%esp
  801416:	5b                   	pop    %ebx
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <seek>:

int
seek(int fdnum, off_t offset)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80141f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801422:	89 44 24 04          	mov    %eax,0x4(%esp)
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	89 04 24             	mov    %eax,(%esp)
  80142c:	e8 bd fb ff ff       	call   800fee <fd_lookup>
  801431:	85 c0                	test   %eax,%eax
  801433:	78 0e                	js     801443 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80143e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	53                   	push   %ebx
  801449:	83 ec 24             	sub    $0x24,%esp
  80144c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801452:	89 44 24 04          	mov    %eax,0x4(%esp)
  801456:	89 1c 24             	mov    %ebx,(%esp)
  801459:	e8 90 fb ff ff       	call   800fee <fd_lookup>
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 61                	js     8014c3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	89 44 24 04          	mov    %eax,0x4(%esp)
  801469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146c:	8b 00                	mov    (%eax),%eax
  80146e:	89 04 24             	mov    %eax,(%esp)
  801471:	e8 c9 fb ff ff       	call   80103f <dev_lookup>
  801476:	85 c0                	test   %eax,%eax
  801478:	78 49                	js     8014c3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801481:	75 23                	jne    8014a6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801483:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801488:	8b 40 48             	mov    0x48(%eax),%eax
  80148b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801493:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  80149a:	e8 c4 ec ff ff       	call   800163 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80149f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a4:	eb 1d                	jmp    8014c3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a9:	8b 52 18             	mov    0x18(%edx),%edx
  8014ac:	85 d2                	test   %edx,%edx
  8014ae:	74 0e                	je     8014be <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014b7:	89 04 24             	mov    %eax,(%esp)
  8014ba:	ff d2                	call   *%edx
  8014bc:	eb 05                	jmp    8014c3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014c3:	83 c4 24             	add    $0x24,%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 24             	sub    $0x24,%esp
  8014d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	89 04 24             	mov    %eax,(%esp)
  8014e0:	e8 09 fb ff ff       	call   800fee <fd_lookup>
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 52                	js     80153b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	89 04 24             	mov    %eax,(%esp)
  8014f8:	e8 42 fb ff ff       	call   80103f <dev_lookup>
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	78 3a                	js     80153b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801504:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801508:	74 2c                	je     801536 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80150a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80150d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801514:	00 00 00 
	stat->st_isdir = 0;
  801517:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80151e:	00 00 00 
	stat->st_dev = dev;
  801521:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801527:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80152b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80152e:	89 14 24             	mov    %edx,(%esp)
  801531:	ff 50 14             	call   *0x14(%eax)
  801534:	eb 05                	jmp    80153b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801536:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80153b:	83 c4 24             	add    $0x24,%esp
  80153e:	5b                   	pop    %ebx
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 18             	sub    $0x18,%esp
  801547:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80154a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80154d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801554:	00 
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	89 04 24             	mov    %eax,(%esp)
  80155b:	e8 bc 01 00 00       	call   80171c <open>
  801560:	89 c3                	mov    %eax,%ebx
  801562:	85 c0                	test   %eax,%eax
  801564:	78 1b                	js     801581 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156d:	89 1c 24             	mov    %ebx,(%esp)
  801570:	e8 54 ff ff ff       	call   8014c9 <fstat>
  801575:	89 c6                	mov    %eax,%esi
	close(fd);
  801577:	89 1c 24             	mov    %ebx,(%esp)
  80157a:	e8 be fb ff ff       	call   80113d <close>
	return r;
  80157f:	89 f3                	mov    %esi,%ebx
}
  801581:	89 d8                	mov    %ebx,%eax
  801583:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801586:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801589:	89 ec                	mov    %ebp,%esp
  80158b:	5d                   	pop    %ebp
  80158c:	c3                   	ret    
  80158d:	00 00                	add    %al,(%eax)
	...

00801590 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 18             	sub    $0x18,%esp
  801596:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801599:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80159c:	89 c3                	mov    %eax,%ebx
  80159e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8015a0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a7:	75 11                	jne    8015ba <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015b0:	e8 c1 08 00 00       	call   801e76 <ipc_find_env>
  8015b5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015c1:	00 
  8015c2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015c9:	00 
  8015ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ce:	a1 00 40 80 00       	mov    0x804000,%eax
  8015d3:	89 04 24             	mov    %eax,(%esp)
  8015d6:	e8 17 08 00 00       	call   801df2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015e2:	00 
  8015e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ee:	e8 ad 07 00 00       	call   801da0 <ipc_recv>
}
  8015f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015f9:	89 ec                	mov    %ebp,%esp
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	53                   	push   %ebx
  801601:	83 ec 14             	sub    $0x14,%esp
  801604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8b 40 0c             	mov    0xc(%eax),%eax
  80160d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801612:	ba 00 00 00 00       	mov    $0x0,%edx
  801617:	b8 05 00 00 00       	mov    $0x5,%eax
  80161c:	e8 6f ff ff ff       	call   801590 <fsipc>
  801621:	85 c0                	test   %eax,%eax
  801623:	78 2b                	js     801650 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801625:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80162c:	00 
  80162d:	89 1c 24             	mov    %ebx,(%esp)
  801630:	e8 46 f1 ff ff       	call   80077b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801635:	a1 80 50 80 00       	mov    0x805080,%eax
  80163a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801640:	a1 84 50 80 00       	mov    0x805084,%eax
  801645:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801650:	83 c4 14             	add    $0x14,%esp
  801653:	5b                   	pop    %ebx
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8b 40 0c             	mov    0xc(%eax),%eax
  801662:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801667:	ba 00 00 00 00       	mov    $0x0,%edx
  80166c:	b8 06 00 00 00       	mov    $0x6,%eax
  801671:	e8 1a ff ff ff       	call   801590 <fsipc>
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 10             	sub    $0x10,%esp
  801680:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8b 40 0c             	mov    0xc(%eax),%eax
  801689:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80168e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	b8 03 00 00 00       	mov    $0x3,%eax
  80169e:	e8 ed fe ff ff       	call   801590 <fsipc>
  8016a3:	89 c3                	mov    %eax,%ebx
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 6a                	js     801713 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016a9:	39 c6                	cmp    %eax,%esi
  8016ab:	73 24                	jae    8016d1 <devfile_read+0x59>
  8016ad:	c7 44 24 0c b8 25 80 	movl   $0x8025b8,0xc(%esp)
  8016b4:	00 
  8016b5:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  8016bc:	00 
  8016bd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016c4:	00 
  8016c5:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  8016cc:	e8 6f 06 00 00       	call   801d40 <_panic>
	assert(r <= PGSIZE);
  8016d1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d6:	7e 24                	jle    8016fc <devfile_read+0x84>
  8016d8:	c7 44 24 0c df 25 80 	movl   $0x8025df,0xc(%esp)
  8016df:	00 
  8016e0:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  8016e7:	00 
  8016e8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8016ef:	00 
  8016f0:	c7 04 24 d4 25 80 00 	movl   $0x8025d4,(%esp)
  8016f7:	e8 44 06 00 00       	call   801d40 <_panic>
	memmove(buf, &fsipcbuf, r);
  8016fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801700:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801707:	00 
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	89 04 24             	mov    %eax,(%esp)
  80170e:	e8 59 f2 ff ff       	call   80096c <memmove>
	return r;
}
  801713:	89 d8                	mov    %ebx,%eax
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 20             	sub    $0x20,%esp
  801724:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801727:	89 34 24             	mov    %esi,(%esp)
  80172a:	e8 01 f0 ff ff       	call   800730 <strlen>
		return -E_BAD_PATH;
  80172f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801734:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801739:	7f 5e                	jg     801799 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80173b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173e:	89 04 24             	mov    %eax,(%esp)
  801741:	e8 35 f8 ff ff       	call   800f7b <fd_alloc>
  801746:	89 c3                	mov    %eax,%ebx
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 4d                	js     801799 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80174c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801750:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801757:	e8 1f f0 ff ff       	call   80077b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80175c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801767:	b8 01 00 00 00       	mov    $0x1,%eax
  80176c:	e8 1f fe ff ff       	call   801590 <fsipc>
  801771:	89 c3                	mov    %eax,%ebx
  801773:	85 c0                	test   %eax,%eax
  801775:	79 15                	jns    80178c <open+0x70>
		fd_close(fd, 0);
  801777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80177e:	00 
  80177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801782:	89 04 24             	mov    %eax,(%esp)
  801785:	e8 21 f9 ff ff       	call   8010ab <fd_close>
		return r;
  80178a:	eb 0d                	jmp    801799 <open+0x7d>
	}

	return fd2num(fd);
  80178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178f:	89 04 24             	mov    %eax,(%esp)
  801792:	e8 b9 f7 ff ff       	call   800f50 <fd2num>
  801797:	89 c3                	mov    %eax,%ebx
}
  801799:	89 d8                	mov    %ebx,%eax
  80179b:	83 c4 20             	add    $0x20,%esp
  80179e:	5b                   	pop    %ebx
  80179f:	5e                   	pop    %esi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    
	...

008017b0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 18             	sub    $0x18,%esp
  8017b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 96 f7 ff ff       	call   800f60 <fd2data>
  8017ca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8017cc:	c7 44 24 04 eb 25 80 	movl   $0x8025eb,0x4(%esp)
  8017d3:	00 
  8017d4:	89 34 24             	mov    %esi,(%esp)
  8017d7:	e8 9f ef ff ff       	call   80077b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8017df:	2b 03                	sub    (%ebx),%eax
  8017e1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8017e7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8017ee:	00 00 00 
	stat->st_dev = &devpipe;
  8017f1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  8017f8:	30 80 00 
	return 0;
}
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801803:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801806:	89 ec                	mov    %ebp,%esp
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    

0080180a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	53                   	push   %ebx
  80180e:	83 ec 14             	sub    $0x14,%esp
  801811:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801814:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181f:	e8 15 f5 ff ff       	call   800d39 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801824:	89 1c 24             	mov    %ebx,(%esp)
  801827:	e8 34 f7 ff ff       	call   800f60 <fd2data>
  80182c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801837:	e8 fd f4 ff ff       	call   800d39 <sys_page_unmap>
}
  80183c:	83 c4 14             	add    $0x14,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	57                   	push   %edi
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	83 ec 2c             	sub    $0x2c,%esp
  80184b:	89 c7                	mov    %eax,%edi
  80184d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801850:	a1 04 40 80 00       	mov    0x804004,%eax
  801855:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801858:	89 3c 24             	mov    %edi,(%esp)
  80185b:	e8 60 06 00 00       	call   801ec0 <pageref>
  801860:	89 c6                	mov    %eax,%esi
  801862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801865:	89 04 24             	mov    %eax,(%esp)
  801868:	e8 53 06 00 00       	call   801ec0 <pageref>
  80186d:	39 c6                	cmp    %eax,%esi
  80186f:	0f 94 c0             	sete   %al
  801872:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801875:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80187b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80187e:	39 cb                	cmp    %ecx,%ebx
  801880:	75 08                	jne    80188a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801882:	83 c4 2c             	add    $0x2c,%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5f                   	pop    %edi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80188a:	83 f8 01             	cmp    $0x1,%eax
  80188d:	75 c1                	jne    801850 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80188f:	8b 52 58             	mov    0x58(%edx),%edx
  801892:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801896:	89 54 24 08          	mov    %edx,0x8(%esp)
  80189a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80189e:	c7 04 24 f2 25 80 00 	movl   $0x8025f2,(%esp)
  8018a5:	e8 b9 e8 ff ff       	call   800163 <cprintf>
  8018aa:	eb a4                	jmp    801850 <_pipeisclosed+0xe>

008018ac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 2c             	sub    $0x2c,%esp
  8018b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018b8:	89 34 24             	mov    %esi,(%esp)
  8018bb:	e8 a0 f6 ff ff       	call   800f60 <fd2data>
  8018c0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018cb:	75 50                	jne    80191d <devpipe_write+0x71>
  8018cd:	eb 5c                	jmp    80192b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8018cf:	89 da                	mov    %ebx,%edx
  8018d1:	89 f0                	mov    %esi,%eax
  8018d3:	e8 6a ff ff ff       	call   801842 <_pipeisclosed>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	75 53                	jne    80192f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018dc:	e8 6b f3 ff ff       	call   800c4c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018e4:	8b 13                	mov    (%ebx),%edx
  8018e6:	83 c2 20             	add    $0x20,%edx
  8018e9:	39 d0                	cmp    %edx,%eax
  8018eb:	73 e2                	jae    8018cf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8018f4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	c1 fa 1f             	sar    $0x1f,%edx
  8018fc:	c1 ea 1b             	shr    $0x1b,%edx
  8018ff:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801902:	83 e1 1f             	and    $0x1f,%ecx
  801905:	29 d1                	sub    %edx,%ecx
  801907:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80190b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80190f:	83 c0 01             	add    $0x1,%eax
  801912:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801915:	83 c7 01             	add    $0x1,%edi
  801918:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80191b:	74 0e                	je     80192b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80191d:	8b 43 04             	mov    0x4(%ebx),%eax
  801920:	8b 13                	mov    (%ebx),%edx
  801922:	83 c2 20             	add    $0x20,%edx
  801925:	39 d0                	cmp    %edx,%eax
  801927:	73 a6                	jae    8018cf <devpipe_write+0x23>
  801929:	eb c2                	jmp    8018ed <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80192b:	89 f8                	mov    %edi,%eax
  80192d:	eb 05                	jmp    801934 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801934:	83 c4 2c             	add    $0x2c,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 28             	sub    $0x28,%esp
  801942:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801945:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801948:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80194b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80194e:	89 3c 24             	mov    %edi,(%esp)
  801951:	e8 0a f6 ff ff       	call   800f60 <fd2data>
  801956:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801958:	be 00 00 00 00       	mov    $0x0,%esi
  80195d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801961:	75 47                	jne    8019aa <devpipe_read+0x6e>
  801963:	eb 52                	jmp    8019b7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801965:	89 f0                	mov    %esi,%eax
  801967:	eb 5e                	jmp    8019c7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801969:	89 da                	mov    %ebx,%edx
  80196b:	89 f8                	mov    %edi,%eax
  80196d:	8d 76 00             	lea    0x0(%esi),%esi
  801970:	e8 cd fe ff ff       	call   801842 <_pipeisclosed>
  801975:	85 c0                	test   %eax,%eax
  801977:	75 49                	jne    8019c2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801979:	e8 ce f2 ff ff       	call   800c4c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80197e:	8b 03                	mov    (%ebx),%eax
  801980:	3b 43 04             	cmp    0x4(%ebx),%eax
  801983:	74 e4                	je     801969 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801985:	89 c2                	mov    %eax,%edx
  801987:	c1 fa 1f             	sar    $0x1f,%edx
  80198a:	c1 ea 1b             	shr    $0x1b,%edx
  80198d:	01 d0                	add    %edx,%eax
  80198f:	83 e0 1f             	and    $0x1f,%eax
  801992:	29 d0                	sub    %edx,%eax
  801994:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80199f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019a2:	83 c6 01             	add    $0x1,%esi
  8019a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019a8:	74 0d                	je     8019b7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8019aa:	8b 03                	mov    (%ebx),%eax
  8019ac:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019af:	75 d4                	jne    801985 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019b1:	85 f6                	test   %esi,%esi
  8019b3:	75 b0                	jne    801965 <devpipe_read+0x29>
  8019b5:	eb b2                	jmp    801969 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019b7:	89 f0                	mov    %esi,%eax
  8019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8019c0:	eb 05                	jmp    8019c7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8019c7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019ca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019cd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019d0:	89 ec                	mov    %ebp,%esp
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 48             	sub    $0x48,%esp
  8019da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019e3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8019e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e9:	89 04 24             	mov    %eax,(%esp)
  8019ec:	e8 8a f5 ff ff       	call   800f7b <fd_alloc>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	0f 88 45 01 00 00    	js     801b40 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a02:	00 
  801a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a11:	e8 66 f2 ff ff       	call   800c7c <sys_page_alloc>
  801a16:	89 c3                	mov    %eax,%ebx
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	0f 88 20 01 00 00    	js     801b40 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801a20:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a23:	89 04 24             	mov    %eax,(%esp)
  801a26:	e8 50 f5 ff ff       	call   800f7b <fd_alloc>
  801a2b:	89 c3                	mov    %eax,%ebx
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	0f 88 f8 00 00 00    	js     801b2d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a35:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a3c:	00 
  801a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4b:	e8 2c f2 ff ff       	call   800c7c <sys_page_alloc>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	85 c0                	test   %eax,%eax
  801a54:	0f 88 d3 00 00 00    	js     801b2d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a5d:	89 04 24             	mov    %eax,(%esp)
  801a60:	e8 fb f4 ff ff       	call   800f60 <fd2data>
  801a65:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a67:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a6e:	00 
  801a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7a:	e8 fd f1 ff ff       	call   800c7c <sys_page_alloc>
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	85 c0                	test   %eax,%eax
  801a83:	0f 88 91 00 00 00    	js     801b1a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8c:	89 04 24             	mov    %eax,(%esp)
  801a8f:	e8 cc f4 ff ff       	call   800f60 <fd2data>
  801a94:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a9b:	00 
  801a9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aa7:	00 
  801aa8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab3:	e8 23 f2 ff ff       	call   800cdb <sys_page_map>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 4c                	js     801b0a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801abe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ac4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ad3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aeb:	89 04 24             	mov    %eax,(%esp)
  801aee:	e8 5d f4 ff ff       	call   800f50 <fd2num>
  801af3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af8:	89 04 24             	mov    %eax,(%esp)
  801afb:	e8 50 f4 ff ff       	call   800f50 <fd2num>
  801b00:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801b03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b08:	eb 36                	jmp    801b40 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801b0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b15:	e8 1f f2 ff ff       	call   800d39 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b28:	e8 0c f2 ff ff       	call   800d39 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801b2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3b:	e8 f9 f1 ff ff       	call   800d39 <sys_page_unmap>
    err:
	return r;
}
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b45:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b48:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b4b:	89 ec                	mov    %ebp,%esp
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 87 f4 ff ff       	call   800fee <fd_lookup>
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 15                	js     801b80 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6e:	89 04 24             	mov    %eax,(%esp)
  801b71:	e8 ea f3 ff ff       	call   800f60 <fd2data>
	return _pipeisclosed(fd, p);
  801b76:	89 c2                	mov    %eax,%edx
  801b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7b:	e8 c2 fc ff ff       	call   801842 <_pipeisclosed>
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    
	...

00801b90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
  801b98:	5d                   	pop    %ebp
  801b99:	c3                   	ret    

00801b9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ba0:	c7 44 24 04 0a 26 80 	movl   $0x80260a,0x4(%esp)
  801ba7:	00 
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	89 04 24             	mov    %eax,(%esp)
  801bae:	e8 c8 eb ff ff       	call   80077b <strcpy>
	return 0;
}
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bc6:	be 00 00 00 00       	mov    $0x0,%esi
  801bcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bcf:	74 43                	je     801c14 <devcons_write+0x5a>
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bd6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bdf:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801be1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801be4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801be9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf0:	03 45 0c             	add    0xc(%ebp),%eax
  801bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf7:	89 3c 24             	mov    %edi,(%esp)
  801bfa:	e8 6d ed ff ff       	call   80096c <memmove>
		sys_cputs(buf, m);
  801bff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c03:	89 3c 24             	mov    %edi,(%esp)
  801c06:	e8 55 ef ff ff       	call   800b60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c0b:	01 de                	add    %ebx,%esi
  801c0d:	89 f0                	mov    %esi,%eax
  801c0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c12:	72 c8                	jb     801bdc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801c14:	89 f0                	mov    %esi,%eax
  801c16:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5f                   	pop    %edi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801c2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c30:	75 07                	jne    801c39 <devcons_read+0x18>
  801c32:	eb 31                	jmp    801c65 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801c34:	e8 13 f0 ff ff       	call   800c4c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c40:	e8 4a ef ff ff       	call   800b8f <sys_cgetc>
  801c45:	85 c0                	test   %eax,%eax
  801c47:	74 eb                	je     801c34 <devcons_read+0x13>
  801c49:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 16                	js     801c65 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801c4f:	83 f8 04             	cmp    $0x4,%eax
  801c52:	74 0c                	je     801c60 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	88 10                	mov    %dl,(%eax)
	return 1;
  801c59:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5e:	eb 05                	jmp    801c65 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c73:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c7a:	00 
  801c7b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c7e:	89 04 24             	mov    %eax,(%esp)
  801c81:	e8 da ee ff ff       	call   800b60 <sys_cputs>
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <getchar>:

int
getchar(void)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c8e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c95:	00 
  801c96:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca4:	e8 05 f6 ff ff       	call   8012ae <read>
	if (r < 0)
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 0f                	js     801cbc <getchar+0x34>
		return r;
	if (r < 1)
  801cad:	85 c0                	test   %eax,%eax
  801caf:	7e 06                	jle    801cb7 <getchar+0x2f>
		return -E_EOF;
	return c;
  801cb1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801cb5:	eb 05                	jmp    801cbc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801cb7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 18 f3 ff ff       	call   800fee <fd_lookup>
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 11                	js     801ceb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ce3:	39 10                	cmp    %edx,(%eax)
  801ce5:	0f 94 c0             	sete   %al
  801ce8:	0f b6 c0             	movzbl %al,%eax
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <opencons>:

int
opencons(void)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801cf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf6:	89 04 24             	mov    %eax,(%esp)
  801cf9:	e8 7d f2 ff ff       	call   800f7b <fd_alloc>
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 3c                	js     801d3e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d09:	00 
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d18:	e8 5f ef ff ff       	call   800c7c <sys_page_alloc>
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 1d                	js     801d3e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d21:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d36:	89 04 24             	mov    %eax,(%esp)
  801d39:	e8 12 f2 ff ff       	call   800f50 <fd2num>
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	56                   	push   %esi
  801d44:	53                   	push   %ebx
  801d45:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801d48:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d4b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801d51:	e8 c6 ee ff ff       	call   800c1c <sys_getenvid>
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d60:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d64:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6c:	c7 04 24 18 26 80 00 	movl   $0x802618,(%esp)
  801d73:	e8 eb e3 ff ff       	call   800163 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	89 04 24             	mov    %eax,(%esp)
  801d82:	e8 7b e3 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801d87:	c7 04 24 03 26 80 00 	movl   $0x802603,(%esp)
  801d8e:	e8 d0 e3 ff ff       	call   800163 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d93:	cc                   	int3   
  801d94:	eb fd                	jmp    801d93 <_panic+0x53>
	...

00801da0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 10             	sub    $0x10,%esp
  801da8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801db1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801db3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801db8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 22 f1 ff ff       	call   800ee5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801dc3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801dc8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	78 0e                	js     801ddf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801dd1:	a1 04 40 80 00       	mov    0x804004,%eax
  801dd6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801dd9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801ddc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801ddf:	85 f6                	test   %esi,%esi
  801de1:	74 02                	je     801de5 <ipc_recv+0x45>
		*from_env_store = sender;
  801de3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801de5:	85 db                	test   %ebx,%ebx
  801de7:	74 02                	je     801deb <ipc_recv+0x4b>
		*perm_store = perm;
  801de9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    

00801df2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 1c             	sub    $0x1c,%esp
  801dfb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e01:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e04:	85 db                	test   %ebx,%ebx
  801e06:	75 04                	jne    801e0c <ipc_send+0x1a>
  801e08:	85 f6                	test   %esi,%esi
  801e0a:	75 15                	jne    801e21 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e0c:	85 db                	test   %ebx,%ebx
  801e0e:	74 16                	je     801e26 <ipc_send+0x34>
  801e10:	85 f6                	test   %esi,%esi
  801e12:	0f 94 c0             	sete   %al
      pg = 0;
  801e15:	84 c0                	test   %al,%al
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	0f 45 d8             	cmovne %eax,%ebx
  801e1f:	eb 05                	jmp    801e26 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e26:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	89 04 24             	mov    %eax,(%esp)
  801e38:	e8 74 f0 ff ff       	call   800eb1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e3d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e40:	75 07                	jne    801e49 <ipc_send+0x57>
           sys_yield();
  801e42:	e8 05 ee ff ff       	call   800c4c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e47:	eb dd                	jmp    801e26 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	90                   	nop
  801e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e50:	74 1c                	je     801e6e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e52:	c7 44 24 08 3c 26 80 	movl   $0x80263c,0x8(%esp)
  801e59:	00 
  801e5a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e61:	00 
  801e62:	c7 04 24 46 26 80 00 	movl   $0x802646,(%esp)
  801e69:	e8 d2 fe ff ff       	call   801d40 <_panic>
		}
    }
}
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e7c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e81:	39 c8                	cmp    %ecx,%eax
  801e83:	74 17                	je     801e9c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e85:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e8a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e8d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e93:	8b 52 50             	mov    0x50(%edx),%edx
  801e96:	39 ca                	cmp    %ecx,%edx
  801e98:	75 14                	jne    801eae <ipc_find_env+0x38>
  801e9a:	eb 05                	jmp    801ea1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ea1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ea9:	8b 40 40             	mov    0x40(%eax),%eax
  801eac:	eb 0e                	jmp    801ebc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eae:	83 c0 01             	add    $0x1,%eax
  801eb1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801eb6:	75 d2                	jne    801e8a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801eb8:	66 b8 00 00          	mov    $0x0,%ax
}
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    
	...

00801ec0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	c1 e8 16             	shr    $0x16,%eax
  801ecb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ed7:	f6 c1 01             	test   $0x1,%cl
  801eda:	74 1d                	je     801ef9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801edc:	c1 ea 0c             	shr    $0xc,%edx
  801edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ee6:	f6 c2 01             	test   $0x1,%dl
  801ee9:	74 0e                	je     801ef9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eeb:	c1 ea 0c             	shr    $0xc,%edx
  801eee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ef5:	ef 
  801ef6:	0f b7 c0             	movzwl %ax,%eax
}
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    
  801efb:	00 00                	add    %al,(%eax)
  801efd:	00 00                	add    %al,(%eax)
	...

00801f00 <__udivdi3>:
  801f00:	83 ec 1c             	sub    $0x1c,%esp
  801f03:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f07:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f0b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f0f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f13:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f17:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f1b:	85 ff                	test   %edi,%edi
  801f1d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f21:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f25:	89 cd                	mov    %ecx,%ebp
  801f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2b:	75 33                	jne    801f60 <__udivdi3+0x60>
  801f2d:	39 f1                	cmp    %esi,%ecx
  801f2f:	77 57                	ja     801f88 <__udivdi3+0x88>
  801f31:	85 c9                	test   %ecx,%ecx
  801f33:	75 0b                	jne    801f40 <__udivdi3+0x40>
  801f35:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3a:	31 d2                	xor    %edx,%edx
  801f3c:	f7 f1                	div    %ecx
  801f3e:	89 c1                	mov    %eax,%ecx
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	31 d2                	xor    %edx,%edx
  801f44:	f7 f1                	div    %ecx
  801f46:	89 c6                	mov    %eax,%esi
  801f48:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f4c:	f7 f1                	div    %ecx
  801f4e:	89 f2                	mov    %esi,%edx
  801f50:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f54:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f58:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f5c:	83 c4 1c             	add    $0x1c,%esp
  801f5f:	c3                   	ret    
  801f60:	31 d2                	xor    %edx,%edx
  801f62:	31 c0                	xor    %eax,%eax
  801f64:	39 f7                	cmp    %esi,%edi
  801f66:	77 e8                	ja     801f50 <__udivdi3+0x50>
  801f68:	0f bd cf             	bsr    %edi,%ecx
  801f6b:	83 f1 1f             	xor    $0x1f,%ecx
  801f6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f72:	75 2c                	jne    801fa0 <__udivdi3+0xa0>
  801f74:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f78:	76 04                	jbe    801f7e <__udivdi3+0x7e>
  801f7a:	39 f7                	cmp    %esi,%edi
  801f7c:	73 d2                	jae    801f50 <__udivdi3+0x50>
  801f7e:	31 d2                	xor    %edx,%edx
  801f80:	b8 01 00 00 00       	mov    $0x1,%eax
  801f85:	eb c9                	jmp    801f50 <__udivdi3+0x50>
  801f87:	90                   	nop
  801f88:	89 f2                	mov    %esi,%edx
  801f8a:	f7 f1                	div    %ecx
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f92:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f96:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f9a:	83 c4 1c             	add    $0x1c,%esp
  801f9d:	c3                   	ret    
  801f9e:	66 90                	xchg   %ax,%ax
  801fa0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fa5:	b8 20 00 00 00       	mov    $0x20,%eax
  801faa:	89 ea                	mov    %ebp,%edx
  801fac:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fb0:	d3 e7                	shl    %cl,%edi
  801fb2:	89 c1                	mov    %eax,%ecx
  801fb4:	d3 ea                	shr    %cl,%edx
  801fb6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fbb:	09 fa                	or     %edi,%edx
  801fbd:	89 f7                	mov    %esi,%edi
  801fbf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fc3:	89 f2                	mov    %esi,%edx
  801fc5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fc9:	d3 e5                	shl    %cl,%ebp
  801fcb:	89 c1                	mov    %eax,%ecx
  801fcd:	d3 ef                	shr    %cl,%edi
  801fcf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fd4:	d3 e2                	shl    %cl,%edx
  801fd6:	89 c1                	mov    %eax,%ecx
  801fd8:	d3 ee                	shr    %cl,%esi
  801fda:	09 d6                	or     %edx,%esi
  801fdc:	89 fa                	mov    %edi,%edx
  801fde:	89 f0                	mov    %esi,%eax
  801fe0:	f7 74 24 0c          	divl   0xc(%esp)
  801fe4:	89 d7                	mov    %edx,%edi
  801fe6:	89 c6                	mov    %eax,%esi
  801fe8:	f7 e5                	mul    %ebp
  801fea:	39 d7                	cmp    %edx,%edi
  801fec:	72 22                	jb     802010 <__udivdi3+0x110>
  801fee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  801ff2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ff7:	d3 e5                	shl    %cl,%ebp
  801ff9:	39 c5                	cmp    %eax,%ebp
  801ffb:	73 04                	jae    802001 <__udivdi3+0x101>
  801ffd:	39 d7                	cmp    %edx,%edi
  801fff:	74 0f                	je     802010 <__udivdi3+0x110>
  802001:	89 f0                	mov    %esi,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	e9 46 ff ff ff       	jmp    801f50 <__udivdi3+0x50>
  80200a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802010:	8d 46 ff             	lea    -0x1(%esi),%eax
  802013:	31 d2                	xor    %edx,%edx
  802015:	8b 74 24 10          	mov    0x10(%esp),%esi
  802019:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80201d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802021:	83 c4 1c             	add    $0x1c,%esp
  802024:	c3                   	ret    
	...

00802030 <__umoddi3>:
  802030:	83 ec 1c             	sub    $0x1c,%esp
  802033:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802037:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80203b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80203f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802043:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802047:	8b 74 24 24          	mov    0x24(%esp),%esi
  80204b:	85 ed                	test   %ebp,%ebp
  80204d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	89 cf                	mov    %ecx,%edi
  802057:	89 04 24             	mov    %eax,(%esp)
  80205a:	89 f2                	mov    %esi,%edx
  80205c:	75 1a                	jne    802078 <__umoddi3+0x48>
  80205e:	39 f1                	cmp    %esi,%ecx
  802060:	76 4e                	jbe    8020b0 <__umoddi3+0x80>
  802062:	f7 f1                	div    %ecx
  802064:	89 d0                	mov    %edx,%eax
  802066:	31 d2                	xor    %edx,%edx
  802068:	8b 74 24 10          	mov    0x10(%esp),%esi
  80206c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802070:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802074:	83 c4 1c             	add    $0x1c,%esp
  802077:	c3                   	ret    
  802078:	39 f5                	cmp    %esi,%ebp
  80207a:	77 54                	ja     8020d0 <__umoddi3+0xa0>
  80207c:	0f bd c5             	bsr    %ebp,%eax
  80207f:	83 f0 1f             	xor    $0x1f,%eax
  802082:	89 44 24 04          	mov    %eax,0x4(%esp)
  802086:	75 60                	jne    8020e8 <__umoddi3+0xb8>
  802088:	3b 0c 24             	cmp    (%esp),%ecx
  80208b:	0f 87 07 01 00 00    	ja     802198 <__umoddi3+0x168>
  802091:	89 f2                	mov    %esi,%edx
  802093:	8b 34 24             	mov    (%esp),%esi
  802096:	29 ce                	sub    %ecx,%esi
  802098:	19 ea                	sbb    %ebp,%edx
  80209a:	89 34 24             	mov    %esi,(%esp)
  80209d:	8b 04 24             	mov    (%esp),%eax
  8020a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	c3                   	ret    
  8020b0:	85 c9                	test   %ecx,%ecx
  8020b2:	75 0b                	jne    8020bf <__umoddi3+0x8f>
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b9:	31 d2                	xor    %edx,%edx
  8020bb:	f7 f1                	div    %ecx
  8020bd:	89 c1                	mov    %eax,%ecx
  8020bf:	89 f0                	mov    %esi,%eax
  8020c1:	31 d2                	xor    %edx,%edx
  8020c3:	f7 f1                	div    %ecx
  8020c5:	8b 04 24             	mov    (%esp),%eax
  8020c8:	f7 f1                	div    %ecx
  8020ca:	eb 98                	jmp    802064 <__umoddi3+0x34>
  8020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d0:	89 f2                	mov    %esi,%edx
  8020d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	c3                   	ret    
  8020e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020ed:	89 e8                	mov    %ebp,%eax
  8020ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8020f8:	89 fa                	mov    %edi,%edx
  8020fa:	d3 e0                	shl    %cl,%eax
  8020fc:	89 e9                	mov    %ebp,%ecx
  8020fe:	d3 ea                	shr    %cl,%edx
  802100:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802105:	09 c2                	or     %eax,%edx
  802107:	8b 44 24 08          	mov    0x8(%esp),%eax
  80210b:	89 14 24             	mov    %edx,(%esp)
  80210e:	89 f2                	mov    %esi,%edx
  802110:	d3 e7                	shl    %cl,%edi
  802112:	89 e9                	mov    %ebp,%ecx
  802114:	d3 ea                	shr    %cl,%edx
  802116:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80211b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80211f:	d3 e6                	shl    %cl,%esi
  802121:	89 e9                	mov    %ebp,%ecx
  802123:	d3 e8                	shr    %cl,%eax
  802125:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80212a:	09 f0                	or     %esi,%eax
  80212c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802130:	f7 34 24             	divl   (%esp)
  802133:	d3 e6                	shl    %cl,%esi
  802135:	89 74 24 08          	mov    %esi,0x8(%esp)
  802139:	89 d6                	mov    %edx,%esi
  80213b:	f7 e7                	mul    %edi
  80213d:	39 d6                	cmp    %edx,%esi
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	89 d7                	mov    %edx,%edi
  802143:	72 3f                	jb     802184 <__umoddi3+0x154>
  802145:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802149:	72 35                	jb     802180 <__umoddi3+0x150>
  80214b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80214f:	29 c8                	sub    %ecx,%eax
  802151:	19 fe                	sbb    %edi,%esi
  802153:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802158:	89 f2                	mov    %esi,%edx
  80215a:	d3 e8                	shr    %cl,%eax
  80215c:	89 e9                	mov    %ebp,%ecx
  80215e:	d3 e2                	shl    %cl,%edx
  802160:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802165:	09 d0                	or     %edx,%eax
  802167:	89 f2                	mov    %esi,%edx
  802169:	d3 ea                	shr    %cl,%edx
  80216b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80216f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802173:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802177:	83 c4 1c             	add    $0x1c,%esp
  80217a:	c3                   	ret    
  80217b:	90                   	nop
  80217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802180:	39 d6                	cmp    %edx,%esi
  802182:	75 c7                	jne    80214b <__umoddi3+0x11b>
  802184:	89 d7                	mov    %edx,%edi
  802186:	89 c1                	mov    %eax,%ecx
  802188:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80218c:	1b 3c 24             	sbb    (%esp),%edi
  80218f:	eb ba                	jmp    80214b <__umoddi3+0x11b>
  802191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802198:	39 f5                	cmp    %esi,%ebp
  80219a:	0f 82 f1 fe ff ff    	jb     802091 <__umoddi3+0x61>
  8021a0:	e9 f8 fe ff ff       	jmp    80209d <__umoddi3+0x6d>
