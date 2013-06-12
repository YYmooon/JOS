
obj/user/faultdie.debug:     file format elf32-i386


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

00800040 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 50 04             	mov    0x4(%eax),%edx
  80004c:	83 e2 07             	and    $0x7,%edx
  80004f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800053:	8b 00                	mov    (%eax),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 80 22 80 00 	movl   $0x802280,(%esp)
  800060:	e8 3e 01 00 00       	call   8001a3 <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 f2 0b 00 00       	call   800c5c <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 8d 0b 00 00       	call   800bff <sys_env_destroy>
}
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007a:	c7 04 24 40 00 80 00 	movl   $0x800040,(%esp)
  800081:	e8 fe 0e 00 00       	call   800f84 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800086:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  80008d:	00 00 00 
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    
	...

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
  8000a6:	e8 b1 0b 00 00       	call   800c5c <sys_getenvid>
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
  8000cf:	e8 a0 ff ff ff       	call   800074 <umain>

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
  8000ea:	e8 4f 11 00 00       	call   80123e <close_all>
	sys_env_destroy(0);
  8000ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f6:	e8 04 0b 00 00       	call   800bff <sys_env_destroy>
}
  8000fb:	c9                   	leave  
  8000fc:	c3                   	ret    
  8000fd:	00 00                	add    %al,(%eax)
	...

00800100 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	53                   	push   %ebx
  800104:	83 ec 14             	sub    $0x14,%esp
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010a:	8b 03                	mov    (%ebx),%eax
  80010c:	8b 55 08             	mov    0x8(%ebp),%edx
  80010f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800113:	83 c0 01             	add    $0x1,%eax
  800116:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800118:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011d:	75 19                	jne    800138 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80011f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800126:	00 
  800127:	8d 43 08             	lea    0x8(%ebx),%eax
  80012a:	89 04 24             	mov    %eax,(%esp)
  80012d:	e8 6e 0a 00 00       	call   800ba0 <sys_cputs>
		b->idx = 0;
  800132:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800138:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013c:	83 c4 14             	add    $0x14,%esp
  80013f:	5b                   	pop    %ebx
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80014b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800152:	00 00 00 
	b.cnt = 0;
  800155:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800162:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800166:	8b 45 08             	mov    0x8(%ebp),%eax
  800169:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800173:	89 44 24 04          	mov    %eax,0x4(%esp)
  800177:	c7 04 24 00 01 80 00 	movl   $0x800100,(%esp)
  80017e:	e8 97 01 00 00       	call   80031a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800183:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800193:	89 04 24             	mov    %eax,(%esp)
  800196:	e8 05 0a 00 00       	call   800ba0 <sys_cputs>

	return b.cnt;
}
  80019b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	89 04 24             	mov    %eax,(%esp)
  8001b6:	e8 87 ff ff ff       	call   800142 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    
  8001bd:	00 00                	add    %al,(%eax)
	...

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 3c             	sub    $0x3c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001dd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e8:	72 11                	jb     8001fb <printnum+0x3b>
  8001ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ed:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f0:	76 09                	jbe    8001fb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f2:	83 eb 01             	sub    $0x1,%ebx
  8001f5:	85 db                	test   %ebx,%ebx
  8001f7:	7f 51                	jg     80024a <printnum+0x8a>
  8001f9:	eb 5e                	jmp    800259 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8001ff:	83 eb 01             	sub    $0x1,%ebx
  800202:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800206:	8b 45 10             	mov    0x10(%ebp),%eax
  800209:	89 44 24 08          	mov    %eax,0x8(%esp)
  80020d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800211:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800215:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80021c:	00 
  80021d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800220:	89 04 24             	mov    %eax,(%esp)
  800223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022a:	e8 a1 1d 00 00       	call   801fd0 <__udivdi3>
  80022f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800233:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800237:	89 04 24             	mov    %eax,(%esp)
  80023a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80023e:	89 fa                	mov    %edi,%edx
  800240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800243:	e8 78 ff ff ff       	call   8001c0 <printnum>
  800248:	eb 0f                	jmp    800259 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80024e:	89 34 24             	mov    %esi,(%esp)
  800251:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800254:	83 eb 01             	sub    $0x1,%ebx
  800257:	75 f1                	jne    80024a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800259:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80025d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800261:	8b 45 10             	mov    0x10(%ebp),%eax
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80026f:	00 
  800270:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800273:	89 04 24             	mov    %eax,(%esp)
  800276:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027d:	e8 7e 1e 00 00       	call   802100 <__umoddi3>
  800282:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800286:	0f be 80 a6 22 80 00 	movsbl 0x8022a6(%eax),%eax
  80028d:	89 04 24             	mov    %eax,(%esp)
  800290:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800293:	83 c4 3c             	add    $0x3c,%esp
  800296:	5b                   	pop    %ebx
  800297:	5e                   	pop    %esi
  800298:	5f                   	pop    %edi
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80029e:	83 fa 01             	cmp    $0x1,%edx
  8002a1:	7e 0e                	jle    8002b1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002a3:	8b 10                	mov    (%eax),%edx
  8002a5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a8:	89 08                	mov    %ecx,(%eax)
  8002aa:	8b 02                	mov    (%edx),%eax
  8002ac:	8b 52 04             	mov    0x4(%edx),%edx
  8002af:	eb 22                	jmp    8002d3 <getuint+0x38>
	else if (lflag)
  8002b1:	85 d2                	test   %edx,%edx
  8002b3:	74 10                	je     8002c5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002b5:	8b 10                	mov    (%eax),%edx
  8002b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ba:	89 08                	mov    %ecx,(%eax)
  8002bc:	8b 02                	mov    (%edx),%eax
  8002be:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c3:	eb 0e                	jmp    8002d3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ca:	89 08                	mov    %ecx,(%eax)
  8002cc:	8b 02                	mov    (%edx),%eax
  8002ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002df:	8b 10                	mov    (%eax),%edx
  8002e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e4:	73 0a                	jae    8002f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e9:	88 0a                	mov    %cl,(%edx)
  8002eb:	83 c2 01             	add    $0x1,%edx
  8002ee:	89 10                	mov    %edx,(%eax)
}
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	89 44 24 08          	mov    %eax,0x8(%esp)
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	89 04 24             	mov    %eax,(%esp)
  800313:	e8 02 00 00 00       	call   80031a <vprintfmt>
	va_end(ap);
}
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 4c             	sub    $0x4c,%esp
  800323:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800326:	8b 75 10             	mov    0x10(%ebp),%esi
  800329:	eb 12                	jmp    80033d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80032b:	85 c0                	test   %eax,%eax
  80032d:	0f 84 a9 03 00 00    	je     8006dc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800333:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800337:	89 04 24             	mov    %eax,(%esp)
  80033a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80033d:	0f b6 06             	movzbl (%esi),%eax
  800340:	83 c6 01             	add    $0x1,%esi
  800343:	83 f8 25             	cmp    $0x25,%eax
  800346:	75 e3                	jne    80032b <vprintfmt+0x11>
  800348:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80034c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800353:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800358:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80035f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800364:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800367:	eb 2b                	jmp    800394 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80036c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800370:	eb 22                	jmp    800394 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800375:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800379:	eb 19                	jmp    800394 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80037e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800385:	eb 0d                	jmp    800394 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800387:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800394:	0f b6 06             	movzbl (%esi),%eax
  800397:	0f b6 d0             	movzbl %al,%edx
  80039a:	8d 7e 01             	lea    0x1(%esi),%edi
  80039d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8003a0:	83 e8 23             	sub    $0x23,%eax
  8003a3:	3c 55                	cmp    $0x55,%al
  8003a5:	0f 87 0b 03 00 00    	ja     8006b6 <vprintfmt+0x39c>
  8003ab:	0f b6 c0             	movzbl %al,%eax
  8003ae:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003b5:	83 ea 30             	sub    $0x30,%edx
  8003b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8003bb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003bf:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8003c5:	83 fa 09             	cmp    $0x9,%edx
  8003c8:	77 4a                	ja     800414 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003cd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003d0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8003d3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8003d7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003da:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003dd:	83 fa 09             	cmp    $0x9,%edx
  8003e0:	76 eb                	jbe    8003cd <vprintfmt+0xb3>
  8003e2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003e5:	eb 2d                	jmp    800414 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 50 04             	lea    0x4(%eax),%edx
  8003ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003f8:	eb 1a                	jmp    800414 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8003fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800401:	79 91                	jns    800394 <vprintfmt+0x7a>
  800403:	e9 73 ff ff ff       	jmp    80037b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800408:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80040b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800412:	eb 80                	jmp    800394 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800418:	0f 89 76 ff ff ff    	jns    800394 <vprintfmt+0x7a>
  80041e:	e9 64 ff ff ff       	jmp    800387 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800423:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800429:	e9 66 ff ff ff       	jmp    800394 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 50 04             	lea    0x4(%eax),%edx
  800434:	89 55 14             	mov    %edx,0x14(%ebp)
  800437:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800443:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800446:	e9 f2 fe ff ff       	jmp    80033d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 50 04             	lea    0x4(%eax),%edx
  800451:	89 55 14             	mov    %edx,0x14(%ebp)
  800454:	8b 00                	mov    (%eax),%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	c1 fa 1f             	sar    $0x1f,%edx
  80045b:	31 d0                	xor    %edx,%eax
  80045d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045f:	83 f8 0f             	cmp    $0xf,%eax
  800462:	7f 0b                	jg     80046f <vprintfmt+0x155>
  800464:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	75 23                	jne    800492 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80046f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800473:	c7 44 24 08 be 22 80 	movl   $0x8022be,0x8(%esp)
  80047a:	00 
  80047b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80047f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800482:	89 3c 24             	mov    %edi,(%esp)
  800485:	e8 68 fe ff ff       	call   8002f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80048d:	e9 ab fe ff ff       	jmp    80033d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800492:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800496:	c7 44 24 08 95 26 80 	movl   $0x802695,0x8(%esp)
  80049d:	00 
  80049e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004a5:	89 3c 24             	mov    %edi,(%esp)
  8004a8:	e8 45 fe ff ff       	call   8002f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8004b0:	e9 88 fe ff ff       	jmp    80033d <vprintfmt+0x23>
  8004b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8d 50 04             	lea    0x4(%eax),%edx
  8004c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004c9:	85 f6                	test   %esi,%esi
  8004cb:	ba b7 22 80 00       	mov    $0x8022b7,%edx
  8004d0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8004d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d7:	7e 06                	jle    8004df <vprintfmt+0x1c5>
  8004d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004dd:	75 10                	jne    8004ef <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004df:	0f be 06             	movsbl (%esi),%eax
  8004e2:	83 c6 01             	add    $0x1,%esi
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	0f 85 86 00 00 00    	jne    800573 <vprintfmt+0x259>
  8004ed:	eb 76                	jmp    800565 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f3:	89 34 24             	mov    %esi,(%esp)
  8004f6:	e8 90 02 00 00       	call   80078b <strnlen>
  8004fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004fe:	29 c2                	sub    %eax,%edx
  800500:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800503:	85 d2                	test   %edx,%edx
  800505:	7e d8                	jle    8004df <vprintfmt+0x1c5>
					putch(padc, putdat);
  800507:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80050b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80050e:	89 d6                	mov    %edx,%esi
  800510:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800513:	89 c7                	mov    %eax,%edi
  800515:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800519:	89 3c 24             	mov    %edi,(%esp)
  80051c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80051f:	83 ee 01             	sub    $0x1,%esi
  800522:	75 f1                	jne    800515 <vprintfmt+0x1fb>
  800524:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800527:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80052a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80052d:	eb b0                	jmp    8004df <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80052f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800533:	74 18                	je     80054d <vprintfmt+0x233>
  800535:	8d 50 e0             	lea    -0x20(%eax),%edx
  800538:	83 fa 5e             	cmp    $0x5e,%edx
  80053b:	76 10                	jbe    80054d <vprintfmt+0x233>
					putch('?', putdat);
  80053d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800541:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800548:	ff 55 08             	call   *0x8(%ebp)
  80054b:	eb 0a                	jmp    800557 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80054d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800557:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80055b:	0f be 06             	movsbl (%esi),%eax
  80055e:	83 c6 01             	add    $0x1,%esi
  800561:	85 c0                	test   %eax,%eax
  800563:	75 0e                	jne    800573 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056c:	7f 16                	jg     800584 <vprintfmt+0x26a>
  80056e:	e9 ca fd ff ff       	jmp    80033d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800573:	85 ff                	test   %edi,%edi
  800575:	78 b8                	js     80052f <vprintfmt+0x215>
  800577:	83 ef 01             	sub    $0x1,%edi
  80057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800580:	79 ad                	jns    80052f <vprintfmt+0x215>
  800582:	eb e1                	jmp    800565 <vprintfmt+0x24b>
  800584:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800587:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80058a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80058e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800595:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800597:	83 ee 01             	sub    $0x1,%esi
  80059a:	75 ee                	jne    80058a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80059f:	e9 99 fd ff ff       	jmp    80033d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005a4:	83 f9 01             	cmp    $0x1,%ecx
  8005a7:	7e 10                	jle    8005b9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8d 50 08             	lea    0x8(%eax),%edx
  8005af:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b2:	8b 30                	mov    (%eax),%esi
  8005b4:	8b 78 04             	mov    0x4(%eax),%edi
  8005b7:	eb 26                	jmp    8005df <vprintfmt+0x2c5>
	else if (lflag)
  8005b9:	85 c9                	test   %ecx,%ecx
  8005bb:	74 12                	je     8005cf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 50 04             	lea    0x4(%eax),%edx
  8005c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c6:	8b 30                	mov    (%eax),%esi
  8005c8:	89 f7                	mov    %esi,%edi
  8005ca:	c1 ff 1f             	sar    $0x1f,%edi
  8005cd:	eb 10                	jmp    8005df <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d8:	8b 30                	mov    (%eax),%esi
  8005da:	89 f7                	mov    %esi,%edi
  8005dc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005df:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005e4:	85 ff                	test   %edi,%edi
  8005e6:	0f 89 8c 00 00 00    	jns    800678 <vprintfmt+0x35e>
				putch('-', putdat);
  8005ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005f0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005f7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005fa:	f7 de                	neg    %esi
  8005fc:	83 d7 00             	adc    $0x0,%edi
  8005ff:	f7 df                	neg    %edi
			}
			base = 10;
  800601:	b8 0a 00 00 00       	mov    $0xa,%eax
  800606:	eb 70                	jmp    800678 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800608:	89 ca                	mov    %ecx,%edx
  80060a:	8d 45 14             	lea    0x14(%ebp),%eax
  80060d:	e8 89 fc ff ff       	call   80029b <getuint>
  800612:	89 c6                	mov    %eax,%esi
  800614:	89 d7                	mov    %edx,%edi
			base = 10;
  800616:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80061b:	eb 5b                	jmp    800678 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80061d:	89 ca                	mov    %ecx,%edx
  80061f:	8d 45 14             	lea    0x14(%ebp),%eax
  800622:	e8 74 fc ff ff       	call   80029b <getuint>
  800627:	89 c6                	mov    %eax,%esi
  800629:	89 d7                	mov    %edx,%edi
			base = 8;
  80062b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800630:	eb 46                	jmp    800678 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800632:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800636:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80063d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800640:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800644:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80064b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800657:	8b 30                	mov    (%eax),%esi
  800659:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80065e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800663:	eb 13                	jmp    800678 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800665:	89 ca                	mov    %ecx,%edx
  800667:	8d 45 14             	lea    0x14(%ebp),%eax
  80066a:	e8 2c fc ff ff       	call   80029b <getuint>
  80066f:	89 c6                	mov    %eax,%esi
  800671:	89 d7                	mov    %edx,%edi
			base = 16;
  800673:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800678:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80067c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800683:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800687:	89 44 24 08          	mov    %eax,0x8(%esp)
  80068b:	89 34 24             	mov    %esi,(%esp)
  80068e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800692:	89 da                	mov    %ebx,%edx
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	e8 24 fb ff ff       	call   8001c0 <printnum>
			break;
  80069c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80069f:	e9 99 fc ff ff       	jmp    80033d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a8:	89 14 24             	mov    %edx,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ae:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006b1:	e9 87 fc ff ff       	jmp    80033d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ba:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006c1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006c8:	0f 84 6f fc ff ff    	je     80033d <vprintfmt+0x23>
  8006ce:	83 ee 01             	sub    $0x1,%esi
  8006d1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006d5:	75 f7                	jne    8006ce <vprintfmt+0x3b4>
  8006d7:	e9 61 fc ff ff       	jmp    80033d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8006dc:	83 c4 4c             	add    $0x4c,%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 28             	sub    $0x28,%esp
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800701:	85 c0                	test   %eax,%eax
  800703:	74 30                	je     800735 <vsnprintf+0x51>
  800705:	85 d2                	test   %edx,%edx
  800707:	7e 2c                	jle    800735 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	89 44 24 08          	mov    %eax,0x8(%esp)
  800717:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80071a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071e:	c7 04 24 d5 02 80 00 	movl   $0x8002d5,(%esp)
  800725:	e8 f0 fb ff ff       	call   80031a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80072d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800733:	eb 05                	jmp    80073a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800742:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 04 24             	mov    %eax,(%esp)
  80075d:	e8 82 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    
	...

00800770 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800776:	b8 00 00 00 00       	mov    $0x0,%eax
  80077b:	80 3a 00             	cmpb   $0x0,(%edx)
  80077e:	74 09                	je     800789 <strlen+0x19>
		n++;
  800780:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800783:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800787:	75 f7                	jne    800780 <strlen+0x10>
		n++;
	return n;
}
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800792:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800795:	b8 00 00 00 00       	mov    $0x0,%eax
  80079a:	85 c9                	test   %ecx,%ecx
  80079c:	74 1a                	je     8007b8 <strnlen+0x2d>
  80079e:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007a1:	74 15                	je     8007b8 <strnlen+0x2d>
  8007a3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8007a8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007aa:	39 ca                	cmp    %ecx,%edx
  8007ac:	74 0a                	je     8007b8 <strnlen+0x2d>
  8007ae:	83 c2 01             	add    $0x1,%edx
  8007b1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8007b6:	75 f0                	jne    8007a8 <strnlen+0x1d>
		n++;
	return n;
}
  8007b8:	5b                   	pop    %ebx
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007ce:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007d1:	83 c2 01             	add    $0x1,%edx
  8007d4:	84 c9                	test   %cl,%cl
  8007d6:	75 f2                	jne    8007ca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	53                   	push   %ebx
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e5:	89 1c 24             	mov    %ebx,(%esp)
  8007e8:	e8 83 ff ff ff       	call   800770 <strlen>
	strcpy(dst + len, src);
  8007ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007f4:	01 d8                	add    %ebx,%eax
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	e8 bd ff ff ff       	call   8007bb <strcpy>
	return dst;
}
  8007fe:	89 d8                	mov    %ebx,%eax
  800800:	83 c4 08             	add    $0x8,%esp
  800803:	5b                   	pop    %ebx
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800811:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800814:	85 f6                	test   %esi,%esi
  800816:	74 18                	je     800830 <strncpy+0x2a>
  800818:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80081d:	0f b6 1a             	movzbl (%edx),%ebx
  800820:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800823:	80 3a 01             	cmpb   $0x1,(%edx)
  800826:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800829:	83 c1 01             	add    $0x1,%ecx
  80082c:	39 f1                	cmp    %esi,%ecx
  80082e:	75 ed                	jne    80081d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	57                   	push   %edi
  800838:	56                   	push   %esi
  800839:	53                   	push   %ebx
  80083a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80083d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800840:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800843:	89 f8                	mov    %edi,%eax
  800845:	85 f6                	test   %esi,%esi
  800847:	74 2b                	je     800874 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800849:	83 fe 01             	cmp    $0x1,%esi
  80084c:	74 23                	je     800871 <strlcpy+0x3d>
  80084e:	0f b6 0b             	movzbl (%ebx),%ecx
  800851:	84 c9                	test   %cl,%cl
  800853:	74 1c                	je     800871 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800855:	83 ee 02             	sub    $0x2,%esi
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80085d:	88 08                	mov    %cl,(%eax)
  80085f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800862:	39 f2                	cmp    %esi,%edx
  800864:	74 0b                	je     800871 <strlcpy+0x3d>
  800866:	83 c2 01             	add    $0x1,%edx
  800869:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80086d:	84 c9                	test   %cl,%cl
  80086f:	75 ec                	jne    80085d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800871:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800874:	29 f8                	sub    %edi,%eax
}
  800876:	5b                   	pop    %ebx
  800877:	5e                   	pop    %esi
  800878:	5f                   	pop    %edi
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800884:	0f b6 01             	movzbl (%ecx),%eax
  800887:	84 c0                	test   %al,%al
  800889:	74 16                	je     8008a1 <strcmp+0x26>
  80088b:	3a 02                	cmp    (%edx),%al
  80088d:	75 12                	jne    8008a1 <strcmp+0x26>
		p++, q++;
  80088f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800892:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800896:	84 c0                	test   %al,%al
  800898:	74 07                	je     8008a1 <strcmp+0x26>
  80089a:	83 c1 01             	add    $0x1,%ecx
  80089d:	3a 02                	cmp    (%edx),%al
  80089f:	74 ee                	je     80088f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a1:	0f b6 c0             	movzbl %al,%eax
  8008a4:	0f b6 12             	movzbl (%edx),%edx
  8008a7:	29 d0                	sub    %edx,%eax
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008b5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008b8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008bd:	85 d2                	test   %edx,%edx
  8008bf:	74 28                	je     8008e9 <strncmp+0x3e>
  8008c1:	0f b6 01             	movzbl (%ecx),%eax
  8008c4:	84 c0                	test   %al,%al
  8008c6:	74 24                	je     8008ec <strncmp+0x41>
  8008c8:	3a 03                	cmp    (%ebx),%al
  8008ca:	75 20                	jne    8008ec <strncmp+0x41>
  8008cc:	83 ea 01             	sub    $0x1,%edx
  8008cf:	74 13                	je     8008e4 <strncmp+0x39>
		n--, p++, q++;
  8008d1:	83 c1 01             	add    $0x1,%ecx
  8008d4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008d7:	0f b6 01             	movzbl (%ecx),%eax
  8008da:	84 c0                	test   %al,%al
  8008dc:	74 0e                	je     8008ec <strncmp+0x41>
  8008de:	3a 03                	cmp    (%ebx),%al
  8008e0:	74 ea                	je     8008cc <strncmp+0x21>
  8008e2:	eb 08                	jmp    8008ec <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e9:	5b                   	pop    %ebx
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ec:	0f b6 01             	movzbl (%ecx),%eax
  8008ef:	0f b6 13             	movzbl (%ebx),%edx
  8008f2:	29 d0                	sub    %edx,%eax
  8008f4:	eb f3                	jmp    8008e9 <strncmp+0x3e>

008008f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800900:	0f b6 10             	movzbl (%eax),%edx
  800903:	84 d2                	test   %dl,%dl
  800905:	74 1c                	je     800923 <strchr+0x2d>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	75 09                	jne    800914 <strchr+0x1e>
  80090b:	eb 1b                	jmp    800928 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80090d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800910:	38 ca                	cmp    %cl,%dl
  800912:	74 14                	je     800928 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800914:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800918:	84 d2                	test   %dl,%dl
  80091a:	75 f1                	jne    80090d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb 05                	jmp    800928 <strchr+0x32>
  800923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800934:	0f b6 10             	movzbl (%eax),%edx
  800937:	84 d2                	test   %dl,%dl
  800939:	74 14                	je     80094f <strfind+0x25>
		if (*s == c)
  80093b:	38 ca                	cmp    %cl,%dl
  80093d:	75 06                	jne    800945 <strfind+0x1b>
  80093f:	eb 0e                	jmp    80094f <strfind+0x25>
  800941:	38 ca                	cmp    %cl,%dl
  800943:	74 0a                	je     80094f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800945:	83 c0 01             	add    $0x1,%eax
  800948:	0f b6 10             	movzbl (%eax),%edx
  80094b:	84 d2                	test   %dl,%dl
  80094d:	75 f2                	jne    800941 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 0c             	sub    $0xc,%esp
  800957:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80095a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80095d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800960:	8b 7d 08             	mov    0x8(%ebp),%edi
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800969:	85 c9                	test   %ecx,%ecx
  80096b:	74 30                	je     80099d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800973:	75 25                	jne    80099a <memset+0x49>
  800975:	f6 c1 03             	test   $0x3,%cl
  800978:	75 20                	jne    80099a <memset+0x49>
		c &= 0xFF;
  80097a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097d:	89 d3                	mov    %edx,%ebx
  80097f:	c1 e3 08             	shl    $0x8,%ebx
  800982:	89 d6                	mov    %edx,%esi
  800984:	c1 e6 18             	shl    $0x18,%esi
  800987:	89 d0                	mov    %edx,%eax
  800989:	c1 e0 10             	shl    $0x10,%eax
  80098c:	09 f0                	or     %esi,%eax
  80098e:	09 d0                	or     %edx,%eax
  800990:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800992:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800995:	fc                   	cld    
  800996:	f3 ab                	rep stos %eax,%es:(%edi)
  800998:	eb 03                	jmp    80099d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099a:	fc                   	cld    
  80099b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099d:	89 f8                	mov    %edi,%eax
  80099f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009a5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009a8:	89 ec                	mov    %ebp,%esp
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009be:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c1:	39 c6                	cmp    %eax,%esi
  8009c3:	73 36                	jae    8009fb <memmove+0x4f>
  8009c5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c8:	39 d0                	cmp    %edx,%eax
  8009ca:	73 2f                	jae    8009fb <memmove+0x4f>
		s += n;
		d += n;
  8009cc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cf:	f6 c2 03             	test   $0x3,%dl
  8009d2:	75 1b                	jne    8009ef <memmove+0x43>
  8009d4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009da:	75 13                	jne    8009ef <memmove+0x43>
  8009dc:	f6 c1 03             	test   $0x3,%cl
  8009df:	75 0e                	jne    8009ef <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e1:	83 ef 04             	sub    $0x4,%edi
  8009e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 09                	jmp    8009f8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ef:	83 ef 01             	sub    $0x1,%edi
  8009f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f8:	fc                   	cld    
  8009f9:	eb 20                	jmp    800a1b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a01:	75 13                	jne    800a16 <memmove+0x6a>
  800a03:	a8 03                	test   $0x3,%al
  800a05:	75 0f                	jne    800a16 <memmove+0x6a>
  800a07:	f6 c1 03             	test   $0x3,%cl
  800a0a:	75 0a                	jne    800a16 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a0c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a0f:	89 c7                	mov    %eax,%edi
  800a11:	fc                   	cld    
  800a12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a14:	eb 05                	jmp    800a1b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a16:	89 c7                	mov    %eax,%edi
  800a18:	fc                   	cld    
  800a19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a21:	89 ec                	mov    %ebp,%esp
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	89 04 24             	mov    %eax,(%esp)
  800a3f:	e8 68 ff ff ff       	call   8009ac <memmove>
}
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	57                   	push   %edi
  800a4a:	56                   	push   %esi
  800a4b:	53                   	push   %ebx
  800a4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a52:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a55:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5a:	85 ff                	test   %edi,%edi
  800a5c:	74 37                	je     800a95 <memcmp+0x4f>
		if (*s1 != *s2)
  800a5e:	0f b6 03             	movzbl (%ebx),%eax
  800a61:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a64:	83 ef 01             	sub    $0x1,%edi
  800a67:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a6c:	38 c8                	cmp    %cl,%al
  800a6e:	74 1c                	je     800a8c <memcmp+0x46>
  800a70:	eb 10                	jmp    800a82 <memcmp+0x3c>
  800a72:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a77:	83 c2 01             	add    $0x1,%edx
  800a7a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a7e:	38 c8                	cmp    %cl,%al
  800a80:	74 0a                	je     800a8c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800a82:	0f b6 c0             	movzbl %al,%eax
  800a85:	0f b6 c9             	movzbl %cl,%ecx
  800a88:	29 c8                	sub    %ecx,%eax
  800a8a:	eb 09                	jmp    800a95 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8c:	39 fa                	cmp    %edi,%edx
  800a8e:	75 e2                	jne    800a72 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800aa0:	89 c2                	mov    %eax,%edx
  800aa2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa5:	39 d0                	cmp    %edx,%eax
  800aa7:	73 19                	jae    800ac2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800aad:	38 08                	cmp    %cl,(%eax)
  800aaf:	75 06                	jne    800ab7 <memfind+0x1d>
  800ab1:	eb 0f                	jmp    800ac2 <memfind+0x28>
  800ab3:	38 08                	cmp    %cl,(%eax)
  800ab5:	74 0b                	je     800ac2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ab7:	83 c0 01             	add    $0x1,%eax
  800aba:	39 d0                	cmp    %edx,%eax
  800abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ac0:	75 f1                	jne    800ab3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad0:	0f b6 02             	movzbl (%edx),%eax
  800ad3:	3c 20                	cmp    $0x20,%al
  800ad5:	74 04                	je     800adb <strtol+0x17>
  800ad7:	3c 09                	cmp    $0x9,%al
  800ad9:	75 0e                	jne    800ae9 <strtol+0x25>
		s++;
  800adb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ade:	0f b6 02             	movzbl (%edx),%eax
  800ae1:	3c 20                	cmp    $0x20,%al
  800ae3:	74 f6                	je     800adb <strtol+0x17>
  800ae5:	3c 09                	cmp    $0x9,%al
  800ae7:	74 f2                	je     800adb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ae9:	3c 2b                	cmp    $0x2b,%al
  800aeb:	75 0a                	jne    800af7 <strtol+0x33>
		s++;
  800aed:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800af0:	bf 00 00 00 00       	mov    $0x0,%edi
  800af5:	eb 10                	jmp    800b07 <strtol+0x43>
  800af7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800afc:	3c 2d                	cmp    $0x2d,%al
  800afe:	75 07                	jne    800b07 <strtol+0x43>
		s++, neg = 1;
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	0f 94 c0             	sete   %al
  800b0c:	74 05                	je     800b13 <strtol+0x4f>
  800b0e:	83 fb 10             	cmp    $0x10,%ebx
  800b11:	75 15                	jne    800b28 <strtol+0x64>
  800b13:	80 3a 30             	cmpb   $0x30,(%edx)
  800b16:	75 10                	jne    800b28 <strtol+0x64>
  800b18:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b1c:	75 0a                	jne    800b28 <strtol+0x64>
		s += 2, base = 16;
  800b1e:	83 c2 02             	add    $0x2,%edx
  800b21:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b26:	eb 13                	jmp    800b3b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b28:	84 c0                	test   %al,%al
  800b2a:	74 0f                	je     800b3b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b31:	80 3a 30             	cmpb   $0x30,(%edx)
  800b34:	75 05                	jne    800b3b <strtol+0x77>
		s++, base = 8;
  800b36:	83 c2 01             	add    $0x1,%edx
  800b39:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b42:	0f b6 0a             	movzbl (%edx),%ecx
  800b45:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b48:	80 fb 09             	cmp    $0x9,%bl
  800b4b:	77 08                	ja     800b55 <strtol+0x91>
			dig = *s - '0';
  800b4d:	0f be c9             	movsbl %cl,%ecx
  800b50:	83 e9 30             	sub    $0x30,%ecx
  800b53:	eb 1e                	jmp    800b73 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b55:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b58:	80 fb 19             	cmp    $0x19,%bl
  800b5b:	77 08                	ja     800b65 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b5d:	0f be c9             	movsbl %cl,%ecx
  800b60:	83 e9 57             	sub    $0x57,%ecx
  800b63:	eb 0e                	jmp    800b73 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b65:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b68:	80 fb 19             	cmp    $0x19,%bl
  800b6b:	77 14                	ja     800b81 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b6d:	0f be c9             	movsbl %cl,%ecx
  800b70:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b73:	39 f1                	cmp    %esi,%ecx
  800b75:	7d 0e                	jge    800b85 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	0f af c6             	imul   %esi,%eax
  800b7d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800b7f:	eb c1                	jmp    800b42 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800b81:	89 c1                	mov    %eax,%ecx
  800b83:	eb 02                	jmp    800b87 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b85:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800b87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8b:	74 05                	je     800b92 <strtol+0xce>
		*endptr = (char *) s;
  800b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b90:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b92:	89 ca                	mov    %ecx,%edx
  800b94:	f7 da                	neg    %edx
  800b96:	85 ff                	test   %edi,%edi
  800b98:	0f 45 c2             	cmovne %edx,%eax
}
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ba9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800baf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bba:	89 c3                	mov    %eax,%ebx
  800bbc:	89 c7                	mov    %eax,%edi
  800bbe:	89 c6                	mov    %eax,%esi
  800bc0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bcb:	89 ec                	mov    %ebp,%esp
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <sys_cgetc>:

int
sys_cgetc(void)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bd8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bdb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 01 00 00 00       	mov    $0x1,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bf5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bf8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bfb:	89 ec                	mov    %ebp,%esp
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 38             	sub    $0x38,%esp
  800c05:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c08:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c0b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c13:	b8 03 00 00 00       	mov    $0x3,%eax
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	89 cb                	mov    %ecx,%ebx
  800c1d:	89 cf                	mov    %ecx,%edi
  800c1f:	89 ce                	mov    %ecx,%esi
  800c21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c23:	85 c0                	test   %eax,%eax
  800c25:	7e 28                	jle    800c4f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c2b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c32:	00 
  800c33:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800c3a:	00 
  800c3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c42:	00 
  800c43:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800c4a:	e8 c1 11 00 00       	call   801e10 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c58:	89 ec                	mov    %ebp,%esp
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800c70:	b8 02 00 00 00       	mov    $0x2,%eax
  800c75:	89 d1                	mov    %edx,%ecx
  800c77:	89 d3                	mov    %edx,%ebx
  800c79:	89 d7                	mov    %edx,%edi
  800c7b:	89 d6                	mov    %edx,%esi
  800c7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c88:	89 ec                	mov    %ebp,%esp
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_yield>:

void
sys_yield(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c98:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800caf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cb8:	89 ec                	mov    %ebp,%esp
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 38             	sub    $0x38,%esp
  800cc2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccb:	be 00 00 00 00       	mov    $0x0,%esi
  800cd0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	89 f7                	mov    %esi,%edi
  800ce0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7e 28                	jle    800d0e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cea:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cf1:	00 
  800cf2:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800cf9:	00 
  800cfa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d01:	00 
  800d02:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800d09:	e8 02 11 00 00       	call   801e10 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d11:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d14:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d17:	89 ec                	mov    %ebp,%esp
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 38             	sub    $0x38,%esp
  800d21:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d24:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d27:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	7e 28                	jle    800d6c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d48:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d4f:	00 
  800d50:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800d57:	00 
  800d58:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d5f:	00 
  800d60:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800d67:	e8 a4 10 00 00       	call   801e10 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d6c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d6f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d72:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d75:	89 ec                	mov    %ebp,%esp
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 38             	sub    $0x38,%esp
  800d7f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d82:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d85:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	89 df                	mov    %ebx,%edi
  800d9a:	89 de                	mov    %ebx,%esi
  800d9c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	7e 28                	jle    800dca <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dad:	00 
  800dae:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800db5:	00 
  800db6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbd:	00 
  800dbe:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800dc5:	e8 46 10 00 00       	call   801e10 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dcd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd3:	89 ec                	mov    %ebp,%esp
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 38             	sub    $0x38,%esp
  800ddd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800deb:	b8 08 00 00 00       	mov    $0x8,%eax
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	89 df                	mov    %ebx,%edi
  800df8:	89 de                	mov    %ebx,%esi
  800dfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 28                	jle    800e28 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800e13:	00 
  800e14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1b:	00 
  800e1c:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800e23:	e8 e8 0f 00 00       	call   801e10 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e2b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e31:	89 ec                	mov    %ebp,%esp
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 38             	sub    $0x38,%esp
  800e3b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e3e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e41:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7e 28                	jle    800e86 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e62:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e69:	00 
  800e6a:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800e71:	00 
  800e72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e79:	00 
  800e7a:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800e81:	e8 8a 0f 00 00       	call   801e10 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e8f:	89 ec                	mov    %ebp,%esp
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 38             	sub    $0x38,%esp
  800e99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	89 df                	mov    %ebx,%edi
  800eb4:	89 de                	mov    %ebx,%esi
  800eb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7e 28                	jle    800ee4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed7:	00 
  800ed8:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800edf:	e8 2c 0f 00 00       	call   801e10 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eed:	89 ec                	mov    %ebp,%esp
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800efd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f00:	be 00 00 00 00       	mov    $0x0,%esi
  800f05:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f0a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f18:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f21:	89 ec                	mov    %ebp,%esp
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 38             	sub    $0x38,%esp
  800f2b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f2e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f31:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	89 cb                	mov    %ecx,%ebx
  800f43:	89 cf                	mov    %ecx,%edi
  800f45:	89 ce                	mov    %ecx,%esi
  800f47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7e 28                	jle    800f75 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f51:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f58:	00 
  800f59:	c7 44 24 08 9f 25 80 	movl   $0x80259f,0x8(%esp)
  800f60:	00 
  800f61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f68:	00 
  800f69:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  800f70:	e8 9b 0e 00 00       	call   801e10 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f75:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f78:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f7b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f7e:	89 ec                	mov    %ebp,%esp
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    
	...

00800f84 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f8a:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800f91:	75 54                	jne    800fe7 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  800f93:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f9a:	00 
  800f9b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800fa2:	ee 
  800fa3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800faa:	e8 0d fd ff ff       	call   800cbc <sys_page_alloc>
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	79 20                	jns    800fd3 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  800fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fb7:	c7 44 24 08 ca 25 80 	movl   $0x8025ca,0x8(%esp)
  800fbe:	00 
  800fbf:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800fc6:	00 
  800fc7:	c7 04 24 e2 25 80 00 	movl   $0x8025e2,(%esp)
  800fce:	e8 3d 0e 00 00       	call   801e10 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  800fd3:	c7 44 24 04 f4 0f 80 	movl   $0x800ff4,0x4(%esp)
  800fda:	00 
  800fdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fe2:	e8 ac fe ff ff       	call   800e93 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    
  800ff1:	00 00                	add    %al,(%eax)
	...

00800ff4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800ff4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800ff5:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800ffa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800ffc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  800fff:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801003:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  801006:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  80100a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80100e:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801010:	83 c4 08             	add    $0x8,%esp
	popal
  801013:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801014:	83 c4 04             	add    $0x4,%esp
	popfl
  801017:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  801018:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801019:	c3                   	ret    
  80101a:	00 00                	add    %al,(%eax)
  80101c:	00 00                	add    %al,(%eax)
	...

00801020 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	05 00 00 00 30       	add    $0x30000000,%eax
  80102b:	c1 e8 0c             	shr    $0xc,%eax
}
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 04 24             	mov    %eax,(%esp)
  80103c:	e8 df ff ff ff       	call   801020 <fd2num>
  801041:	05 20 00 0d 00       	add    $0xd0020,%eax
  801046:	c1 e0 0c             	shl    $0xc,%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	53                   	push   %ebx
  80104f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801052:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801057:	a8 01                	test   $0x1,%al
  801059:	74 34                	je     80108f <fd_alloc+0x44>
  80105b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801060:	a8 01                	test   $0x1,%al
  801062:	74 32                	je     801096 <fd_alloc+0x4b>
  801064:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801069:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80106b:	89 c2                	mov    %eax,%edx
  80106d:	c1 ea 16             	shr    $0x16,%edx
  801070:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801077:	f6 c2 01             	test   $0x1,%dl
  80107a:	74 1f                	je     80109b <fd_alloc+0x50>
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	c1 ea 0c             	shr    $0xc,%edx
  801081:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	75 17                	jne    8010a4 <fd_alloc+0x59>
  80108d:	eb 0c                	jmp    80109b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80108f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801094:	eb 05                	jmp    80109b <fd_alloc+0x50>
  801096:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80109b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80109d:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a2:	eb 17                	jmp    8010bb <fd_alloc+0x70>
  8010a4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ae:	75 b9                	jne    801069 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8010b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010bb:	5b                   	pop    %ebx
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010c9:	83 fa 1f             	cmp    $0x1f,%edx
  8010cc:	77 3f                	ja     80110d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ce:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8010d4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d7:	89 d0                	mov    %edx,%eax
  8010d9:	c1 e8 16             	shr    $0x16,%eax
  8010dc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010e8:	f6 c1 01             	test   $0x1,%cl
  8010eb:	74 20                	je     80110d <fd_lookup+0x4f>
  8010ed:	89 d0                	mov    %edx,%eax
  8010ef:	c1 e8 0c             	shr    $0xc,%eax
  8010f2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010fe:	f6 c1 01             	test   $0x1,%cl
  801101:	74 0a                	je     80110d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
	return 0;
  801108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	53                   	push   %ebx
  801113:	83 ec 14             	sub    $0x14,%esp
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80111c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801121:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801127:	75 17                	jne    801140 <dev_lookup+0x31>
  801129:	eb 07                	jmp    801132 <dev_lookup+0x23>
  80112b:	39 0a                	cmp    %ecx,(%edx)
  80112d:	75 11                	jne    801140 <dev_lookup+0x31>
  80112f:	90                   	nop
  801130:	eb 05                	jmp    801137 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801132:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801137:	89 13                	mov    %edx,(%ebx)
			return 0;
  801139:	b8 00 00 00 00       	mov    $0x0,%eax
  80113e:	eb 35                	jmp    801175 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801140:	83 c0 01             	add    $0x1,%eax
  801143:	8b 14 85 6c 26 80 00 	mov    0x80266c(,%eax,4),%edx
  80114a:	85 d2                	test   %edx,%edx
  80114c:	75 dd                	jne    80112b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80114e:	a1 04 40 80 00       	mov    0x804004,%eax
  801153:	8b 40 48             	mov    0x48(%eax),%eax
  801156:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80115a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115e:	c7 04 24 f0 25 80 00 	movl   $0x8025f0,(%esp)
  801165:	e8 39 f0 ff ff       	call   8001a3 <cprintf>
	*dev = 0;
  80116a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801170:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801175:	83 c4 14             	add    $0x14,%esp
  801178:	5b                   	pop    %ebx
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 38             	sub    $0x38,%esp
  801181:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801184:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801187:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80118a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80118d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801191:	89 3c 24             	mov    %edi,(%esp)
  801194:	e8 87 fe ff ff       	call   801020 <fd2num>
  801199:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80119c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011a0:	89 04 24             	mov    %eax,(%esp)
  8011a3:	e8 16 ff ff ff       	call   8010be <fd_lookup>
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	78 05                	js     8011b3 <fd_close+0x38>
	    || fd != fd2)
  8011ae:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8011b1:	74 0e                	je     8011c1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	84 c0                	test   %al,%al
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bc:	0f 44 d8             	cmove  %eax,%ebx
  8011bf:	eb 3d                	jmp    8011fe <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c8:	8b 07                	mov    (%edi),%eax
  8011ca:	89 04 24             	mov    %eax,(%esp)
  8011cd:	e8 3d ff ff ff       	call   80110f <dev_lookup>
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 16                	js     8011ee <fd_close+0x73>
		if (dev->dev_close)
  8011d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	74 07                	je     8011ee <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8011e7:	89 3c 24             	mov    %edi,(%esp)
  8011ea:	ff d0                	call   *%eax
  8011ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f9:	e8 7b fb ff ff       	call   800d79 <sys_page_unmap>
	return r;
}
  8011fe:	89 d8                	mov    %ebx,%eax
  801200:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801203:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801206:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801209:	89 ec                	mov    %ebp,%esp
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801213:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	89 04 24             	mov    %eax,(%esp)
  801220:	e8 99 fe ff ff       	call   8010be <fd_lookup>
  801225:	85 c0                	test   %eax,%eax
  801227:	78 13                	js     80123c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801229:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801230:	00 
  801231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801234:	89 04 24             	mov    %eax,(%esp)
  801237:	e8 3f ff ff ff       	call   80117b <fd_close>
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <close_all>:

void
close_all(void)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	53                   	push   %ebx
  801242:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801245:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80124a:	89 1c 24             	mov    %ebx,(%esp)
  80124d:	e8 bb ff ff ff       	call   80120d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801252:	83 c3 01             	add    $0x1,%ebx
  801255:	83 fb 20             	cmp    $0x20,%ebx
  801258:	75 f0                	jne    80124a <close_all+0xc>
		close(i);
}
  80125a:	83 c4 14             	add    $0x14,%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    

00801260 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	83 ec 58             	sub    $0x58,%esp
  801266:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801269:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80126c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80126f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801272:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801275:	89 44 24 04          	mov    %eax,0x4(%esp)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	89 04 24             	mov    %eax,(%esp)
  80127f:	e8 3a fe ff ff       	call   8010be <fd_lookup>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	85 c0                	test   %eax,%eax
  801288:	0f 88 e1 00 00 00    	js     80136f <dup+0x10f>
		return r;
	close(newfdnum);
  80128e:	89 3c 24             	mov    %edi,(%esp)
  801291:	e8 77 ff ff ff       	call   80120d <close>

	newfd = INDEX2FD(newfdnum);
  801296:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80129c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80129f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a2:	89 04 24             	mov    %eax,(%esp)
  8012a5:	e8 86 fd ff ff       	call   801030 <fd2data>
  8012aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012ac:	89 34 24             	mov    %esi,(%esp)
  8012af:	e8 7c fd ff ff       	call   801030 <fd2data>
  8012b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b7:	89 d8                	mov    %ebx,%eax
  8012b9:	c1 e8 16             	shr    $0x16,%eax
  8012bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c3:	a8 01                	test   $0x1,%al
  8012c5:	74 46                	je     80130d <dup+0xad>
  8012c7:	89 d8                	mov    %ebx,%eax
  8012c9:	c1 e8 0c             	shr    $0xc,%eax
  8012cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d3:	f6 c2 01             	test   $0x1,%dl
  8012d6:	74 35                	je     80130d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012df:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012f6:	00 
  8012f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801302:	e8 14 fa ff ff       	call   800d1b <sys_page_map>
  801307:	89 c3                	mov    %eax,%ebx
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 3b                	js     801348 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80130d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801310:	89 c2                	mov    %eax,%edx
  801312:	c1 ea 0c             	shr    $0xc,%edx
  801315:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801322:	89 54 24 10          	mov    %edx,0x10(%esp)
  801326:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80132a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801331:	00 
  801332:	89 44 24 04          	mov    %eax,0x4(%esp)
  801336:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133d:	e8 d9 f9 ff ff       	call   800d1b <sys_page_map>
  801342:	89 c3                	mov    %eax,%ebx
  801344:	85 c0                	test   %eax,%eax
  801346:	79 25                	jns    80136d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801348:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801353:	e8 21 fa ff ff       	call   800d79 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80135b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801366:	e8 0e fa ff ff       	call   800d79 <sys_page_unmap>
	return r;
  80136b:	eb 02                	jmp    80136f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80136d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80136f:	89 d8                	mov    %ebx,%eax
  801371:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801374:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801377:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80137a:	89 ec                	mov    %ebp,%esp
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    

0080137e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	53                   	push   %ebx
  801382:	83 ec 24             	sub    $0x24,%esp
  801385:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801388:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138f:	89 1c 24             	mov    %ebx,(%esp)
  801392:	e8 27 fd ff ff       	call   8010be <fd_lookup>
  801397:	85 c0                	test   %eax,%eax
  801399:	78 6d                	js     801408 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80139b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a5:	8b 00                	mov    (%eax),%eax
  8013a7:	89 04 24             	mov    %eax,(%esp)
  8013aa:	e8 60 fd ff ff       	call   80110f <dev_lookup>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 55                	js     801408 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b6:	8b 50 08             	mov    0x8(%eax),%edx
  8013b9:	83 e2 03             	and    $0x3,%edx
  8013bc:	83 fa 01             	cmp    $0x1,%edx
  8013bf:	75 23                	jne    8013e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c6:	8b 40 48             	mov    0x48(%eax),%eax
  8013c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	c7 04 24 31 26 80 00 	movl   $0x802631,(%esp)
  8013d8:	e8 c6 ed ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e2:	eb 24                	jmp    801408 <read+0x8a>
	}
	if (!dev->dev_read)
  8013e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e7:	8b 52 08             	mov    0x8(%edx),%edx
  8013ea:	85 d2                	test   %edx,%edx
  8013ec:	74 15                	je     801403 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013fc:	89 04 24             	mov    %eax,(%esp)
  8013ff:	ff d2                	call   *%edx
  801401:	eb 05                	jmp    801408 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801403:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801408:	83 c4 24             	add    $0x24,%esp
  80140b:	5b                   	pop    %ebx
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	57                   	push   %edi
  801412:	56                   	push   %esi
  801413:	53                   	push   %ebx
  801414:	83 ec 1c             	sub    $0x1c,%esp
  801417:	8b 7d 08             	mov    0x8(%ebp),%edi
  80141a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
  801422:	85 f6                	test   %esi,%esi
  801424:	74 30                	je     801456 <readn+0x48>
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142b:	89 f2                	mov    %esi,%edx
  80142d:	29 c2                	sub    %eax,%edx
  80142f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801433:	03 45 0c             	add    0xc(%ebp),%eax
  801436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143a:	89 3c 24             	mov    %edi,(%esp)
  80143d:	e8 3c ff ff ff       	call   80137e <read>
		if (m < 0)
  801442:	85 c0                	test   %eax,%eax
  801444:	78 10                	js     801456 <readn+0x48>
			return m;
		if (m == 0)
  801446:	85 c0                	test   %eax,%eax
  801448:	74 0a                	je     801454 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144a:	01 c3                	add    %eax,%ebx
  80144c:	89 d8                	mov    %ebx,%eax
  80144e:	39 f3                	cmp    %esi,%ebx
  801450:	72 d9                	jb     80142b <readn+0x1d>
  801452:	eb 02                	jmp    801456 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801454:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801456:	83 c4 1c             	add    $0x1c,%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    

0080145e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	53                   	push   %ebx
  801462:	83 ec 24             	sub    $0x24,%esp
  801465:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801468:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146f:	89 1c 24             	mov    %ebx,(%esp)
  801472:	e8 47 fc ff ff       	call   8010be <fd_lookup>
  801477:	85 c0                	test   %eax,%eax
  801479:	78 68                	js     8014e3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	8b 00                	mov    (%eax),%eax
  801487:	89 04 24             	mov    %eax,(%esp)
  80148a:	e8 80 fc ff ff       	call   80110f <dev_lookup>
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 50                	js     8014e3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149a:	75 23                	jne    8014bf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80149c:	a1 04 40 80 00       	mov    0x804004,%eax
  8014a1:	8b 40 48             	mov    0x48(%eax),%eax
  8014a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ac:	c7 04 24 4d 26 80 00 	movl   $0x80264d,(%esp)
  8014b3:	e8 eb ec ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  8014b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bd:	eb 24                	jmp    8014e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c5:	85 d2                	test   %edx,%edx
  8014c7:	74 15                	je     8014de <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014d7:	89 04 24             	mov    %eax,(%esp)
  8014da:	ff d2                	call   *%edx
  8014dc:	eb 05                	jmp    8014e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014e3:	83 c4 24             	add    $0x24,%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 04 24             	mov    %eax,(%esp)
  8014fc:	e8 bd fb ff ff       	call   8010be <fd_lookup>
  801501:	85 c0                	test   %eax,%eax
  801503:	78 0e                	js     801513 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	53                   	push   %ebx
  801519:	83 ec 24             	sub    $0x24,%esp
  80151c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801522:	89 44 24 04          	mov    %eax,0x4(%esp)
  801526:	89 1c 24             	mov    %ebx,(%esp)
  801529:	e8 90 fb ff ff       	call   8010be <fd_lookup>
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 61                	js     801593 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801532:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801535:	89 44 24 04          	mov    %eax,0x4(%esp)
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	89 04 24             	mov    %eax,(%esp)
  801541:	e8 c9 fb ff ff       	call   80110f <dev_lookup>
  801546:	85 c0                	test   %eax,%eax
  801548:	78 49                	js     801593 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80154a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801551:	75 23                	jne    801576 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801553:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801558:	8b 40 48             	mov    0x48(%eax),%eax
  80155b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801563:	c7 04 24 10 26 80 00 	movl   $0x802610,(%esp)
  80156a:	e8 34 ec ff ff       	call   8001a3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801574:	eb 1d                	jmp    801593 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801579:	8b 52 18             	mov    0x18(%edx),%edx
  80157c:	85 d2                	test   %edx,%edx
  80157e:	74 0e                	je     80158e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801583:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	ff d2                	call   *%edx
  80158c:	eb 05                	jmp    801593 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80158e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801593:	83 c4 24             	add    $0x24,%esp
  801596:	5b                   	pop    %ebx
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    

00801599 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	53                   	push   %ebx
  80159d:	83 ec 24             	sub    $0x24,%esp
  8015a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	89 04 24             	mov    %eax,(%esp)
  8015b0:	e8 09 fb ff ff       	call   8010be <fd_lookup>
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 52                	js     80160b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	89 04 24             	mov    %eax,(%esp)
  8015c8:	e8 42 fb ff ff       	call   80110f <dev_lookup>
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 3a                	js     80160b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015d8:	74 2c                	je     801606 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015e4:	00 00 00 
	stat->st_isdir = 0;
  8015e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ee:	00 00 00 
	stat->st_dev = dev;
  8015f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fe:	89 14 24             	mov    %edx,(%esp)
  801601:	ff 50 14             	call   *0x14(%eax)
  801604:	eb 05                	jmp    80160b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801606:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80160b:	83 c4 24             	add    $0x24,%esp
  80160e:	5b                   	pop    %ebx
  80160f:	5d                   	pop    %ebp
  801610:	c3                   	ret    

00801611 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 18             	sub    $0x18,%esp
  801617:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80161a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80161d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801624:	00 
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	89 04 24             	mov    %eax,(%esp)
  80162b:	e8 bc 01 00 00       	call   8017ec <open>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	85 c0                	test   %eax,%eax
  801634:	78 1b                	js     801651 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801636:	8b 45 0c             	mov    0xc(%ebp),%eax
  801639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163d:	89 1c 24             	mov    %ebx,(%esp)
  801640:	e8 54 ff ff ff       	call   801599 <fstat>
  801645:	89 c6                	mov    %eax,%esi
	close(fd);
  801647:	89 1c 24             	mov    %ebx,(%esp)
  80164a:	e8 be fb ff ff       	call   80120d <close>
	return r;
  80164f:	89 f3                	mov    %esi,%ebx
}
  801651:	89 d8                	mov    %ebx,%eax
  801653:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801656:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801659:	89 ec                	mov    %ebp,%esp
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    
  80165d:	00 00                	add    %al,(%eax)
	...

00801660 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 18             	sub    $0x18,%esp
  801666:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801669:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801670:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801677:	75 11                	jne    80168a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801679:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801680:	e8 c1 08 00 00       	call   801f46 <ipc_find_env>
  801685:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80168a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801691:	00 
  801692:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801699:	00 
  80169a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169e:	a1 00 40 80 00       	mov    0x804000,%eax
  8016a3:	89 04 24             	mov    %eax,(%esp)
  8016a6:	e8 17 08 00 00       	call   801ec2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b2:	00 
  8016b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016be:	e8 ad 07 00 00       	call   801e70 <ipc_recv>
}
  8016c3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016c6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016c9:	89 ec                	mov    %ebp,%esp
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    

008016cd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 14             	sub    $0x14,%esp
  8016d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8b 40 0c             	mov    0xc(%eax),%eax
  8016dd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ec:	e8 6f ff ff ff       	call   801660 <fsipc>
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 2b                	js     801720 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016fc:	00 
  8016fd:	89 1c 24             	mov    %ebx,(%esp)
  801700:	e8 b6 f0 ff ff       	call   8007bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801705:	a1 80 50 80 00       	mov    0x805080,%eax
  80170a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801710:	a1 84 50 80 00       	mov    0x805084,%eax
  801715:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801720:	83 c4 14             	add    $0x14,%esp
  801723:	5b                   	pop    %ebx
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8b 40 0c             	mov    0xc(%eax),%eax
  801732:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	b8 06 00 00 00       	mov    $0x6,%eax
  801741:	e8 1a ff ff ff       	call   801660 <fsipc>
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	83 ec 10             	sub    $0x10,%esp
  801750:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8b 40 0c             	mov    0xc(%eax),%eax
  801759:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80175e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801764:	ba 00 00 00 00       	mov    $0x0,%edx
  801769:	b8 03 00 00 00       	mov    $0x3,%eax
  80176e:	e8 ed fe ff ff       	call   801660 <fsipc>
  801773:	89 c3                	mov    %eax,%ebx
  801775:	85 c0                	test   %eax,%eax
  801777:	78 6a                	js     8017e3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801779:	39 c6                	cmp    %eax,%esi
  80177b:	73 24                	jae    8017a1 <devfile_read+0x59>
  80177d:	c7 44 24 0c 7c 26 80 	movl   $0x80267c,0xc(%esp)
  801784:	00 
  801785:	c7 44 24 08 83 26 80 	movl   $0x802683,0x8(%esp)
  80178c:	00 
  80178d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801794:	00 
  801795:	c7 04 24 98 26 80 00 	movl   $0x802698,(%esp)
  80179c:	e8 6f 06 00 00       	call   801e10 <_panic>
	assert(r <= PGSIZE);
  8017a1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a6:	7e 24                	jle    8017cc <devfile_read+0x84>
  8017a8:	c7 44 24 0c a3 26 80 	movl   $0x8026a3,0xc(%esp)
  8017af:	00 
  8017b0:	c7 44 24 08 83 26 80 	movl   $0x802683,0x8(%esp)
  8017b7:	00 
  8017b8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8017bf:	00 
  8017c0:	c7 04 24 98 26 80 00 	movl   $0x802698,(%esp)
  8017c7:	e8 44 06 00 00       	call   801e10 <_panic>
	memmove(buf, &fsipcbuf, r);
  8017cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017d0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d7:	00 
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 c9 f1 ff ff       	call   8009ac <memmove>
	return r;
}
  8017e3:	89 d8                	mov    %ebx,%eax
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	56                   	push   %esi
  8017f0:	53                   	push   %ebx
  8017f1:	83 ec 20             	sub    $0x20,%esp
  8017f4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017f7:	89 34 24             	mov    %esi,(%esp)
  8017fa:	e8 71 ef ff ff       	call   800770 <strlen>
		return -E_BAD_PATH;
  8017ff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801804:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801809:	7f 5e                	jg     801869 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80180b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180e:	89 04 24             	mov    %eax,(%esp)
  801811:	e8 35 f8 ff ff       	call   80104b <fd_alloc>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 4d                	js     801869 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80181c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801820:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801827:	e8 8f ef ff ff       	call   8007bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  80182c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801837:	b8 01 00 00 00       	mov    $0x1,%eax
  80183c:	e8 1f fe ff ff       	call   801660 <fsipc>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	85 c0                	test   %eax,%eax
  801845:	79 15                	jns    80185c <open+0x70>
		fd_close(fd, 0);
  801847:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80184e:	00 
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	e8 21 f9 ff ff       	call   80117b <fd_close>
		return r;
  80185a:	eb 0d                	jmp    801869 <open+0x7d>
	}

	return fd2num(fd);
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	e8 b9 f7 ff ff       	call   801020 <fd2num>
  801867:	89 c3                	mov    %eax,%ebx
}
  801869:	89 d8                	mov    %ebx,%eax
  80186b:	83 c4 20             	add    $0x20,%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5d                   	pop    %ebp
  801871:	c3                   	ret    
	...

00801880 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 18             	sub    $0x18,%esp
  801886:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801889:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80188c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	89 04 24             	mov    %eax,(%esp)
  801895:	e8 96 f7 ff ff       	call   801030 <fd2data>
  80189a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80189c:	c7 44 24 04 af 26 80 	movl   $0x8026af,0x4(%esp)
  8018a3:	00 
  8018a4:	89 34 24             	mov    %esi,(%esp)
  8018a7:	e8 0f ef ff ff       	call   8007bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018ac:	8b 43 04             	mov    0x4(%ebx),%eax
  8018af:	2b 03                	sub    (%ebx),%eax
  8018b1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8018b7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8018be:	00 00 00 
	stat->st_dev = &devpipe;
  8018c1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  8018c8:	30 80 00 
	return 0;
}
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018d3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018d6:	89 ec                	mov    %ebp,%esp
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    

008018da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 14             	sub    $0x14,%esp
  8018e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ef:	e8 85 f4 ff ff       	call   800d79 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018f4:	89 1c 24             	mov    %ebx,(%esp)
  8018f7:	e8 34 f7 ff ff       	call   801030 <fd2data>
  8018fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801900:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801907:	e8 6d f4 ff ff       	call   800d79 <sys_page_unmap>
}
  80190c:	83 c4 14             	add    $0x14,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    

00801912 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	57                   	push   %edi
  801916:	56                   	push   %esi
  801917:	53                   	push   %ebx
  801918:	83 ec 2c             	sub    $0x2c,%esp
  80191b:	89 c7                	mov    %eax,%edi
  80191d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801920:	a1 04 40 80 00       	mov    0x804004,%eax
  801925:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801928:	89 3c 24             	mov    %edi,(%esp)
  80192b:	e8 60 06 00 00       	call   801f90 <pageref>
  801930:	89 c6                	mov    %eax,%esi
  801932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801935:	89 04 24             	mov    %eax,(%esp)
  801938:	e8 53 06 00 00       	call   801f90 <pageref>
  80193d:	39 c6                	cmp    %eax,%esi
  80193f:	0f 94 c0             	sete   %al
  801942:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801945:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80194b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80194e:	39 cb                	cmp    %ecx,%ebx
  801950:	75 08                	jne    80195a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801952:	83 c4 2c             	add    $0x2c,%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5f                   	pop    %edi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80195a:	83 f8 01             	cmp    $0x1,%eax
  80195d:	75 c1                	jne    801920 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80195f:	8b 52 58             	mov    0x58(%edx),%edx
  801962:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801966:	89 54 24 08          	mov    %edx,0x8(%esp)
  80196a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80196e:	c7 04 24 b6 26 80 00 	movl   $0x8026b6,(%esp)
  801975:	e8 29 e8 ff ff       	call   8001a3 <cprintf>
  80197a:	eb a4                	jmp    801920 <_pipeisclosed+0xe>

0080197c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	57                   	push   %edi
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	83 ec 2c             	sub    $0x2c,%esp
  801985:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801988:	89 34 24             	mov    %esi,(%esp)
  80198b:	e8 a0 f6 ff ff       	call   801030 <fd2data>
  801990:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801992:	bf 00 00 00 00       	mov    $0x0,%edi
  801997:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80199b:	75 50                	jne    8019ed <devpipe_write+0x71>
  80199d:	eb 5c                	jmp    8019fb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80199f:	89 da                	mov    %ebx,%edx
  8019a1:	89 f0                	mov    %esi,%eax
  8019a3:	e8 6a ff ff ff       	call   801912 <_pipeisclosed>
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	75 53                	jne    8019ff <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8019ac:	e8 db f2 ff ff       	call   800c8c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019b4:	8b 13                	mov    (%ebx),%edx
  8019b6:	83 c2 20             	add    $0x20,%edx
  8019b9:	39 d0                	cmp    %edx,%eax
  8019bb:	73 e2                	jae    80199f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8019c4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8019c7:	89 c2                	mov    %eax,%edx
  8019c9:	c1 fa 1f             	sar    $0x1f,%edx
  8019cc:	c1 ea 1b             	shr    $0x1b,%edx
  8019cf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8019d2:	83 e1 1f             	and    $0x1f,%ecx
  8019d5:	29 d1                	sub    %edx,%ecx
  8019d7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8019db:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8019df:	83 c0 01             	add    $0x1,%eax
  8019e2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019e5:	83 c7 01             	add    $0x1,%edi
  8019e8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019eb:	74 0e                	je     8019fb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019ed:	8b 43 04             	mov    0x4(%ebx),%eax
  8019f0:	8b 13                	mov    (%ebx),%edx
  8019f2:	83 c2 20             	add    $0x20,%edx
  8019f5:	39 d0                	cmp    %edx,%eax
  8019f7:	73 a6                	jae    80199f <devpipe_write+0x23>
  8019f9:	eb c2                	jmp    8019bd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019fb:	89 f8                	mov    %edi,%eax
  8019fd:	eb 05                	jmp    801a04 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a04:	83 c4 2c             	add    $0x2c,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 28             	sub    $0x28,%esp
  801a12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a15:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a18:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a1e:	89 3c 24             	mov    %edi,(%esp)
  801a21:	e8 0a f6 ff ff       	call   801030 <fd2data>
  801a26:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a28:	be 00 00 00 00       	mov    $0x0,%esi
  801a2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a31:	75 47                	jne    801a7a <devpipe_read+0x6e>
  801a33:	eb 52                	jmp    801a87 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a35:	89 f0                	mov    %esi,%eax
  801a37:	eb 5e                	jmp    801a97 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a39:	89 da                	mov    %ebx,%edx
  801a3b:	89 f8                	mov    %edi,%eax
  801a3d:	8d 76 00             	lea    0x0(%esi),%esi
  801a40:	e8 cd fe ff ff       	call   801912 <_pipeisclosed>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	75 49                	jne    801a92 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a49:	e8 3e f2 ff ff       	call   800c8c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a4e:	8b 03                	mov    (%ebx),%eax
  801a50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a53:	74 e4                	je     801a39 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a55:	89 c2                	mov    %eax,%edx
  801a57:	c1 fa 1f             	sar    $0x1f,%edx
  801a5a:	c1 ea 1b             	shr    $0x1b,%edx
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	83 e0 1f             	and    $0x1f,%eax
  801a62:	29 d0                	sub    %edx,%eax
  801a64:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801a6f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a72:	83 c6 01             	add    $0x1,%esi
  801a75:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a78:	74 0d                	je     801a87 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801a7a:	8b 03                	mov    (%ebx),%eax
  801a7c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a7f:	75 d4                	jne    801a55 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a81:	85 f6                	test   %esi,%esi
  801a83:	75 b0                	jne    801a35 <devpipe_read+0x29>
  801a85:	eb b2                	jmp    801a39 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a87:	89 f0                	mov    %esi,%eax
  801a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801a90:	eb 05                	jmp    801a97 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a92:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801a97:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a9a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a9d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801aa0:	89 ec                	mov    %ebp,%esp
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    

00801aa4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 48             	sub    $0x48,%esp
  801aaa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ab0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ab3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ab6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ab9:	89 04 24             	mov    %eax,(%esp)
  801abc:	e8 8a f5 ff ff       	call   80104b <fd_alloc>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 88 45 01 00 00    	js     801c10 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801acb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ad2:	00 
  801ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae1:	e8 d6 f1 ff ff       	call   800cbc <sys_page_alloc>
  801ae6:	89 c3                	mov    %eax,%ebx
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	0f 88 20 01 00 00    	js     801c10 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801af0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801af3:	89 04 24             	mov    %eax,(%esp)
  801af6:	e8 50 f5 ff ff       	call   80104b <fd_alloc>
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	85 c0                	test   %eax,%eax
  801aff:	0f 88 f8 00 00 00    	js     801bfd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b05:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b0c:	00 
  801b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1b:	e8 9c f1 ff ff       	call   800cbc <sys_page_alloc>
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	85 c0                	test   %eax,%eax
  801b24:	0f 88 d3 00 00 00    	js     801bfd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 fb f4 ff ff       	call   801030 <fd2data>
  801b35:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b37:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b3e:	00 
  801b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4a:	e8 6d f1 ff ff       	call   800cbc <sys_page_alloc>
  801b4f:	89 c3                	mov    %eax,%ebx
  801b51:	85 c0                	test   %eax,%eax
  801b53:	0f 88 91 00 00 00    	js     801bea <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5c:	89 04 24             	mov    %eax,(%esp)
  801b5f:	e8 cc f4 ff ff       	call   801030 <fd2data>
  801b64:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b6b:	00 
  801b6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b77:	00 
  801b78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b83:	e8 93 f1 ff ff       	call   800d1b <sys_page_map>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 4c                	js     801bda <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b8e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b97:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ba3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bac:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbb:	89 04 24             	mov    %eax,(%esp)
  801bbe:	e8 5d f4 ff ff       	call   801020 <fd2num>
  801bc3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc8:	89 04 24             	mov    %eax,(%esp)
  801bcb:	e8 50 f4 ff ff       	call   801020 <fd2num>
  801bd0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801bd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bd8:	eb 36                	jmp    801c10 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801bda:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be5:	e8 8f f1 ff ff       	call   800d79 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf8:	e8 7c f1 ff ff       	call   800d79 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0b:	e8 69 f1 ff ff       	call   800d79 <sys_page_unmap>
    err:
	return r;
}
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c15:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c18:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c1b:	89 ec                	mov    %ebp,%esp
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	89 04 24             	mov    %eax,(%esp)
  801c32:	e8 87 f4 ff ff       	call   8010be <fd_lookup>
  801c37:	85 c0                	test   %eax,%eax
  801c39:	78 15                	js     801c50 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	89 04 24             	mov    %eax,(%esp)
  801c41:	e8 ea f3 ff ff       	call   801030 <fd2data>
	return _pipeisclosed(fd, p);
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4b:	e8 c2 fc ff ff       	call   801912 <_pipeisclosed>
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    
	...

00801c60 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c70:	c7 44 24 04 ce 26 80 	movl   $0x8026ce,0x4(%esp)
  801c77:	00 
  801c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 38 eb ff ff       	call   8007bb <strcpy>
	return 0;
}
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	57                   	push   %edi
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c96:	be 00 00 00 00       	mov    $0x0,%esi
  801c9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c9f:	74 43                	je     801ce4 <devcons_write+0x5a>
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ca6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801caf:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801cb1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cb4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801cb9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cc0:	03 45 0c             	add    0xc(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	89 3c 24             	mov    %edi,(%esp)
  801cca:	e8 dd ec ff ff       	call   8009ac <memmove>
		sys_cputs(buf, m);
  801ccf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd3:	89 3c 24             	mov    %edi,(%esp)
  801cd6:	e8 c5 ee ff ff       	call   800ba0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cdb:	01 de                	add    %ebx,%esi
  801cdd:	89 f0                	mov    %esi,%eax
  801cdf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce2:	72 c8                	jb     801cac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801ce4:	89 f0                	mov    %esi,%eax
  801ce6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5f                   	pop    %edi
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d00:	75 07                	jne    801d09 <devcons_read+0x18>
  801d02:	eb 31                	jmp    801d35 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d04:	e8 83 ef ff ff       	call   800c8c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d10:	e8 ba ee ff ff       	call   800bcf <sys_cgetc>
  801d15:	85 c0                	test   %eax,%eax
  801d17:	74 eb                	je     801d04 <devcons_read+0x13>
  801d19:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 16                	js     801d35 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d1f:	83 f8 04             	cmp    $0x4,%eax
  801d22:	74 0c                	je     801d30 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d27:	88 10                	mov    %dl,(%eax)
	return 1;
  801d29:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2e:	eb 05                	jmp    801d35 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d4a:	00 
  801d4b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 4a ee ff ff       	call   800ba0 <sys_cputs>
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <getchar>:

int
getchar(void)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d5e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d65:	00 
  801d66:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d74:	e8 05 f6 ff ff       	call   80137e <read>
	if (r < 0)
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 0f                	js     801d8c <getchar+0x34>
		return r;
	if (r < 1)
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	7e 06                	jle    801d87 <getchar+0x2f>
		return -E_EOF;
	return c;
  801d81:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801d85:	eb 05                	jmp    801d8c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801d87:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 04 24             	mov    %eax,(%esp)
  801da1:	e8 18 f3 ff ff       	call   8010be <fd_lookup>
  801da6:	85 c0                	test   %eax,%eax
  801da8:	78 11                	js     801dbb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db3:	39 10                	cmp    %edx,(%eax)
  801db5:	0f 94 c0             	sete   %al
  801db8:	0f b6 c0             	movzbl %al,%eax
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <opencons>:

int
opencons(void)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801dc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 7d f2 ff ff       	call   80104b <fd_alloc>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 3c                	js     801e0e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dd2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dd9:	00 
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de8:	e8 cf ee ff ff       	call   800cbc <sys_page_alloc>
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 1d                	js     801e0e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801df1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 12 f2 ff ff       	call   801020 <fd2num>
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801e18:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e1b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801e21:	e8 36 ee ff ff       	call   800c5c <sys_getenvid>
  801e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e29:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e30:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e34:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3c:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  801e43:	e8 5b e3 ff ff       	call   8001a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e48:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 eb e2 ff ff       	call   800142 <vcprintf>
	cprintf("\n");
  801e57:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  801e5e:	e8 40 e3 ff ff       	call   8001a3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e63:	cc                   	int3   
  801e64:	eb fd                	jmp    801e63 <_panic+0x53>
	...

00801e70 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	56                   	push   %esi
  801e74:	53                   	push   %ebx
  801e75:	83 ec 10             	sub    $0x10,%esp
  801e78:	8b 75 08             	mov    0x8(%ebp),%esi
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801e81:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801e83:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e88:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 92 f0 ff ff       	call   800f25 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801e93:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801e98:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 0e                	js     801eaf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801ea1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ea6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801ea9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801eac:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801eaf:	85 f6                	test   %esi,%esi
  801eb1:	74 02                	je     801eb5 <ipc_recv+0x45>
		*from_env_store = sender;
  801eb3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801eb5:	85 db                	test   %ebx,%ebx
  801eb7:	74 02                	je     801ebb <ipc_recv+0x4b>
		*perm_store = perm;
  801eb9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    

00801ec2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 1c             	sub    $0x1c,%esp
  801ecb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ed1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801ed4:	85 db                	test   %ebx,%ebx
  801ed6:	75 04                	jne    801edc <ipc_send+0x1a>
  801ed8:	85 f6                	test   %esi,%esi
  801eda:	75 15                	jne    801ef1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801edc:	85 db                	test   %ebx,%ebx
  801ede:	74 16                	je     801ef6 <ipc_send+0x34>
  801ee0:	85 f6                	test   %esi,%esi
  801ee2:	0f 94 c0             	sete   %al
      pg = 0;
  801ee5:	84 c0                	test   %al,%al
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	0f 45 d8             	cmovne %eax,%ebx
  801eef:	eb 05                	jmp    801ef6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801ef1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801ef6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801efa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801efe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	89 04 24             	mov    %eax,(%esp)
  801f08:	e8 e4 ef ff ff       	call   800ef1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801f0d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f10:	75 07                	jne    801f19 <ipc_send+0x57>
           sys_yield();
  801f12:	e8 75 ed ff ff       	call   800c8c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801f17:	eb dd                	jmp    801ef6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	90                   	nop
  801f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f20:	74 1c                	je     801f3e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801f22:	c7 44 24 08 00 27 80 	movl   $0x802700,0x8(%esp)
  801f29:	00 
  801f2a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f31:	00 
  801f32:	c7 04 24 0a 27 80 00 	movl   $0x80270a,(%esp)
  801f39:	e8 d2 fe ff ff       	call   801e10 <_panic>
		}
    }
}
  801f3e:	83 c4 1c             	add    $0x1c,%esp
  801f41:	5b                   	pop    %ebx
  801f42:	5e                   	pop    %esi
  801f43:	5f                   	pop    %edi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    

00801f46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f4c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f51:	39 c8                	cmp    %ecx,%eax
  801f53:	74 17                	je     801f6c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f55:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f5a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f5d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f63:	8b 52 50             	mov    0x50(%edx),%edx
  801f66:	39 ca                	cmp    %ecx,%edx
  801f68:	75 14                	jne    801f7e <ipc_find_env+0x38>
  801f6a:	eb 05                	jmp    801f71 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f71:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f74:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f79:	8b 40 40             	mov    0x40(%eax),%eax
  801f7c:	eb 0e                	jmp    801f8c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f7e:	83 c0 01             	add    $0x1,%eax
  801f81:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f86:	75 d2                	jne    801f5a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f88:	66 b8 00 00          	mov    $0x0,%ax
}
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    
	...

00801f90 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f96:	89 d0                	mov    %edx,%eax
  801f98:	c1 e8 16             	shr    $0x16,%eax
  801f9b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fa7:	f6 c1 01             	test   $0x1,%cl
  801faa:	74 1d                	je     801fc9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801fac:	c1 ea 0c             	shr    $0xc,%edx
  801faf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fb6:	f6 c2 01             	test   $0x1,%dl
  801fb9:	74 0e                	je     801fc9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fbb:	c1 ea 0c             	shr    $0xc,%edx
  801fbe:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fc5:	ef 
  801fc6:	0f b7 c0             	movzwl %ax,%eax
}
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    
  801fcb:	00 00                	add    %al,(%eax)
  801fcd:	00 00                	add    %al,(%eax)
	...

00801fd0 <__udivdi3>:
  801fd0:	83 ec 1c             	sub    $0x1c,%esp
  801fd3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801fd7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801fdb:	8b 44 24 20          	mov    0x20(%esp),%eax
  801fdf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801fe3:	89 74 24 10          	mov    %esi,0x10(%esp)
  801fe7:	8b 74 24 24          	mov    0x24(%esp),%esi
  801feb:	85 ff                	test   %edi,%edi
  801fed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801ff1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff5:	89 cd                	mov    %ecx,%ebp
  801ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffb:	75 33                	jne    802030 <__udivdi3+0x60>
  801ffd:	39 f1                	cmp    %esi,%ecx
  801fff:	77 57                	ja     802058 <__udivdi3+0x88>
  802001:	85 c9                	test   %ecx,%ecx
  802003:	75 0b                	jne    802010 <__udivdi3+0x40>
  802005:	b8 01 00 00 00       	mov    $0x1,%eax
  80200a:	31 d2                	xor    %edx,%edx
  80200c:	f7 f1                	div    %ecx
  80200e:	89 c1                	mov    %eax,%ecx
  802010:	89 f0                	mov    %esi,%eax
  802012:	31 d2                	xor    %edx,%edx
  802014:	f7 f1                	div    %ecx
  802016:	89 c6                	mov    %eax,%esi
  802018:	8b 44 24 04          	mov    0x4(%esp),%eax
  80201c:	f7 f1                	div    %ecx
  80201e:	89 f2                	mov    %esi,%edx
  802020:	8b 74 24 10          	mov    0x10(%esp),%esi
  802024:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802028:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	c3                   	ret    
  802030:	31 d2                	xor    %edx,%edx
  802032:	31 c0                	xor    %eax,%eax
  802034:	39 f7                	cmp    %esi,%edi
  802036:	77 e8                	ja     802020 <__udivdi3+0x50>
  802038:	0f bd cf             	bsr    %edi,%ecx
  80203b:	83 f1 1f             	xor    $0x1f,%ecx
  80203e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802042:	75 2c                	jne    802070 <__udivdi3+0xa0>
  802044:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802048:	76 04                	jbe    80204e <__udivdi3+0x7e>
  80204a:	39 f7                	cmp    %esi,%edi
  80204c:	73 d2                	jae    802020 <__udivdi3+0x50>
  80204e:	31 d2                	xor    %edx,%edx
  802050:	b8 01 00 00 00       	mov    $0x1,%eax
  802055:	eb c9                	jmp    802020 <__udivdi3+0x50>
  802057:	90                   	nop
  802058:	89 f2                	mov    %esi,%edx
  80205a:	f7 f1                	div    %ecx
  80205c:	31 d2                	xor    %edx,%edx
  80205e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802062:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802066:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80206a:	83 c4 1c             	add    $0x1c,%esp
  80206d:	c3                   	ret    
  80206e:	66 90                	xchg   %ax,%ax
  802070:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802075:	b8 20 00 00 00       	mov    $0x20,%eax
  80207a:	89 ea                	mov    %ebp,%edx
  80207c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802080:	d3 e7                	shl    %cl,%edi
  802082:	89 c1                	mov    %eax,%ecx
  802084:	d3 ea                	shr    %cl,%edx
  802086:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80208b:	09 fa                	or     %edi,%edx
  80208d:	89 f7                	mov    %esi,%edi
  80208f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802093:	89 f2                	mov    %esi,%edx
  802095:	8b 74 24 08          	mov    0x8(%esp),%esi
  802099:	d3 e5                	shl    %cl,%ebp
  80209b:	89 c1                	mov    %eax,%ecx
  80209d:	d3 ef                	shr    %cl,%edi
  80209f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020a4:	d3 e2                	shl    %cl,%edx
  8020a6:	89 c1                	mov    %eax,%ecx
  8020a8:	d3 ee                	shr    %cl,%esi
  8020aa:	09 d6                	or     %edx,%esi
  8020ac:	89 fa                	mov    %edi,%edx
  8020ae:	89 f0                	mov    %esi,%eax
  8020b0:	f7 74 24 0c          	divl   0xc(%esp)
  8020b4:	89 d7                	mov    %edx,%edi
  8020b6:	89 c6                	mov    %eax,%esi
  8020b8:	f7 e5                	mul    %ebp
  8020ba:	39 d7                	cmp    %edx,%edi
  8020bc:	72 22                	jb     8020e0 <__udivdi3+0x110>
  8020be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8020c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020c7:	d3 e5                	shl    %cl,%ebp
  8020c9:	39 c5                	cmp    %eax,%ebp
  8020cb:	73 04                	jae    8020d1 <__udivdi3+0x101>
  8020cd:	39 d7                	cmp    %edx,%edi
  8020cf:	74 0f                	je     8020e0 <__udivdi3+0x110>
  8020d1:	89 f0                	mov    %esi,%eax
  8020d3:	31 d2                	xor    %edx,%edx
  8020d5:	e9 46 ff ff ff       	jmp    802020 <__udivdi3+0x50>
  8020da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8020e3:	31 d2                	xor    %edx,%edx
  8020e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020f1:	83 c4 1c             	add    $0x1c,%esp
  8020f4:	c3                   	ret    
	...

00802100 <__umoddi3>:
  802100:	83 ec 1c             	sub    $0x1c,%esp
  802103:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802107:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80210b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80210f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802113:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802117:	8b 74 24 24          	mov    0x24(%esp),%esi
  80211b:	85 ed                	test   %ebp,%ebp
  80211d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802121:	89 44 24 08          	mov    %eax,0x8(%esp)
  802125:	89 cf                	mov    %ecx,%edi
  802127:	89 04 24             	mov    %eax,(%esp)
  80212a:	89 f2                	mov    %esi,%edx
  80212c:	75 1a                	jne    802148 <__umoddi3+0x48>
  80212e:	39 f1                	cmp    %esi,%ecx
  802130:	76 4e                	jbe    802180 <__umoddi3+0x80>
  802132:	f7 f1                	div    %ecx
  802134:	89 d0                	mov    %edx,%eax
  802136:	31 d2                	xor    %edx,%edx
  802138:	8b 74 24 10          	mov    0x10(%esp),%esi
  80213c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802140:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	c3                   	ret    
  802148:	39 f5                	cmp    %esi,%ebp
  80214a:	77 54                	ja     8021a0 <__umoddi3+0xa0>
  80214c:	0f bd c5             	bsr    %ebp,%eax
  80214f:	83 f0 1f             	xor    $0x1f,%eax
  802152:	89 44 24 04          	mov    %eax,0x4(%esp)
  802156:	75 60                	jne    8021b8 <__umoddi3+0xb8>
  802158:	3b 0c 24             	cmp    (%esp),%ecx
  80215b:	0f 87 07 01 00 00    	ja     802268 <__umoddi3+0x168>
  802161:	89 f2                	mov    %esi,%edx
  802163:	8b 34 24             	mov    (%esp),%esi
  802166:	29 ce                	sub    %ecx,%esi
  802168:	19 ea                	sbb    %ebp,%edx
  80216a:	89 34 24             	mov    %esi,(%esp)
  80216d:	8b 04 24             	mov    (%esp),%eax
  802170:	8b 74 24 10          	mov    0x10(%esp),%esi
  802174:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802178:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80217c:	83 c4 1c             	add    $0x1c,%esp
  80217f:	c3                   	ret    
  802180:	85 c9                	test   %ecx,%ecx
  802182:	75 0b                	jne    80218f <__umoddi3+0x8f>
  802184:	b8 01 00 00 00       	mov    $0x1,%eax
  802189:	31 d2                	xor    %edx,%edx
  80218b:	f7 f1                	div    %ecx
  80218d:	89 c1                	mov    %eax,%ecx
  80218f:	89 f0                	mov    %esi,%eax
  802191:	31 d2                	xor    %edx,%edx
  802193:	f7 f1                	div    %ecx
  802195:	8b 04 24             	mov    (%esp),%eax
  802198:	f7 f1                	div    %ecx
  80219a:	eb 98                	jmp    802134 <__umoddi3+0x34>
  80219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	89 f2                	mov    %esi,%edx
  8021a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021ae:	83 c4 1c             	add    $0x1c,%esp
  8021b1:	c3                   	ret    
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021bd:	89 e8                	mov    %ebp,%eax
  8021bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	d3 e0                	shl    %cl,%eax
  8021cc:	89 e9                	mov    %ebp,%ecx
  8021ce:	d3 ea                	shr    %cl,%edx
  8021d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021d5:	09 c2                	or     %eax,%edx
  8021d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021db:	89 14 24             	mov    %edx,(%esp)
  8021de:	89 f2                	mov    %esi,%edx
  8021e0:	d3 e7                	shl    %cl,%edi
  8021e2:	89 e9                	mov    %ebp,%ecx
  8021e4:	d3 ea                	shr    %cl,%edx
  8021e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ef:	d3 e6                	shl    %cl,%esi
  8021f1:	89 e9                	mov    %ebp,%ecx
  8021f3:	d3 e8                	shr    %cl,%eax
  8021f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021fa:	09 f0                	or     %esi,%eax
  8021fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802200:	f7 34 24             	divl   (%esp)
  802203:	d3 e6                	shl    %cl,%esi
  802205:	89 74 24 08          	mov    %esi,0x8(%esp)
  802209:	89 d6                	mov    %edx,%esi
  80220b:	f7 e7                	mul    %edi
  80220d:	39 d6                	cmp    %edx,%esi
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	89 d7                	mov    %edx,%edi
  802213:	72 3f                	jb     802254 <__umoddi3+0x154>
  802215:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802219:	72 35                	jb     802250 <__umoddi3+0x150>
  80221b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221f:	29 c8                	sub    %ecx,%eax
  802221:	19 fe                	sbb    %edi,%esi
  802223:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802228:	89 f2                	mov    %esi,%edx
  80222a:	d3 e8                	shr    %cl,%eax
  80222c:	89 e9                	mov    %ebp,%ecx
  80222e:	d3 e2                	shl    %cl,%edx
  802230:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802235:	09 d0                	or     %edx,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	d3 ea                	shr    %cl,%edx
  80223b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80223f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802243:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802247:	83 c4 1c             	add    $0x1c,%esp
  80224a:	c3                   	ret    
  80224b:	90                   	nop
  80224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802250:	39 d6                	cmp    %edx,%esi
  802252:	75 c7                	jne    80221b <__umoddi3+0x11b>
  802254:	89 d7                	mov    %edx,%edi
  802256:	89 c1                	mov    %eax,%ecx
  802258:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80225c:	1b 3c 24             	sbb    (%esp),%edi
  80225f:	eb ba                	jmp    80221b <__umoddi3+0x11b>
  802261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802268:	39 f5                	cmp    %esi,%ebp
  80226a:	0f 82 f1 fe ff ff    	jb     802161 <__umoddi3+0x61>
  802270:	e9 f8 fe ff ff       	jmp    80216d <__umoddi3+0x6d>
