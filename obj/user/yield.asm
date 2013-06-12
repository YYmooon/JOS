
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6f 00 00 00       	call   8000a0 <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003b:	a1 04 40 80 00       	mov    0x804004,%eax
  800040:	8b 40 48             	mov    0x48(%eax),%eax
  800043:	89 44 24 04          	mov    %eax,0x4(%esp)
  800047:	c7 04 24 00 22 80 00 	movl   $0x802200,(%esp)
  80004e:	e8 5c 01 00 00       	call   8001af <cprintf>
	for (i = 0; i < 5; i++) {
  800053:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800058:	e8 3f 0c 00 00       	call   800c9c <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005d:	a1 04 40 80 00       	mov    0x804004,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800062:	8b 40 48             	mov    0x48(%eax),%eax
  800065:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006d:	c7 04 24 20 22 80 00 	movl   $0x802220,(%esp)
  800074:	e8 36 01 00 00       	call   8001af <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800079:	83 c3 01             	add    $0x1,%ebx
  80007c:	83 fb 05             	cmp    $0x5,%ebx
  80007f:	75 d7                	jne    800058 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800081:	a1 04 40 80 00       	mov    0x804004,%eax
  800086:	8b 40 48             	mov    0x48(%eax),%eax
  800089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008d:	c7 04 24 4c 22 80 00 	movl   $0x80224c,(%esp)
  800094:	e8 16 01 00 00       	call   8001af <cprintf>
}
  800099:	83 c4 14             	add    $0x14,%esp
  80009c:	5b                   	pop    %ebx
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
	...

008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 18             	sub    $0x18,%esp
  8000a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8000af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000b2:	e8 b5 0b 00 00       	call   800c6c <sys_getenvid>
  8000b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c4:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	85 f6                	test   %esi,%esi
  8000cb:	7e 07                	jle    8000d4 <libmain+0x34>
		binaryname = argv[0];
  8000cd:	8b 03                	mov    (%ebx),%eax
  8000cf:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 54 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0b 00 00 00       	call   8000f0 <exit>
}
  8000e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000eb:	89 ec                	mov    %ebp,%esp
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    
	...

008000f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000f6:	e8 c3 10 00 00       	call   8011be <close_all>
	sys_env_destroy(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 08 0b 00 00       	call   800c0f <sys_env_destroy>
}
  800107:	c9                   	leave  
  800108:	c3                   	ret    
  800109:	00 00                	add    %al,(%eax)
	...

0080010c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	53                   	push   %ebx
  800110:	83 ec 14             	sub    $0x14,%esp
  800113:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800116:	8b 03                	mov    (%ebx),%eax
  800118:	8b 55 08             	mov    0x8(%ebp),%edx
  80011b:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80011f:	83 c0 01             	add    $0x1,%eax
  800122:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800124:	3d ff 00 00 00       	cmp    $0xff,%eax
  800129:	75 19                	jne    800144 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80012b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800132:	00 
  800133:	8d 43 08             	lea    0x8(%ebx),%eax
  800136:	89 04 24             	mov    %eax,(%esp)
  800139:	e8 72 0a 00 00       	call   800bb0 <sys_cputs>
		b->idx = 0;
  80013e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800144:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800148:	83 c4 14             	add    $0x14,%esp
  80014b:	5b                   	pop    %ebx
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800157:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015e:	00 00 00 
	b.cnt = 0;
  800161:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800168:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800172:	8b 45 08             	mov    0x8(%ebp),%eax
  800175:	89 44 24 08          	mov    %eax,0x8(%esp)
  800179:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800183:	c7 04 24 0c 01 80 00 	movl   $0x80010c,(%esp)
  80018a:	e8 9b 01 00 00       	call   80032a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800195:	89 44 24 04          	mov    %eax,0x4(%esp)
  800199:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 09 0a 00 00       	call   800bb0 <sys_cputs>

	return b.cnt;
}
  8001a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bf:	89 04 24             	mov    %eax,(%esp)
  8001c2:	e8 87 ff ff ff       	call   80014e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    
  8001c9:	00 00                	add    %al,(%eax)
  8001cb:	00 00                	add    %al,(%eax)
  8001cd:	00 00                	add    %al,(%eax)
	...

008001d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 3c             	sub    $0x3c,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001dc:	89 d7                	mov    %edx,%edi
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001ed:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001f8:	72 11                	jb     80020b <printnum+0x3b>
  8001fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fd:	39 45 10             	cmp    %eax,0x10(%ebp)
  800200:	76 09                	jbe    80020b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800202:	83 eb 01             	sub    $0x1,%ebx
  800205:	85 db                	test   %ebx,%ebx
  800207:	7f 51                	jg     80025a <printnum+0x8a>
  800209:	eb 5e                	jmp    800269 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80020f:	83 eb 01             	sub    $0x1,%ebx
  800212:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800216:	8b 45 10             	mov    0x10(%ebp),%eax
  800219:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800221:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800225:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80022c:	00 
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	89 04 24             	mov    %eax,(%esp)
  800233:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	e8 11 1d 00 00       	call   801f50 <__udivdi3>
  80023f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800243:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800247:	89 04 24             	mov    %eax,(%esp)
  80024a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80024e:	89 fa                	mov    %edi,%edx
  800250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800253:	e8 78 ff ff ff       	call   8001d0 <printnum>
  800258:	eb 0f                	jmp    800269 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80025a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80025e:	89 34 24             	mov    %esi,(%esp)
  800261:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800264:	83 eb 01             	sub    $0x1,%ebx
  800267:	75 f1                	jne    80025a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800269:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80026d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800271:	8b 45 10             	mov    0x10(%ebp),%eax
  800274:	89 44 24 08          	mov    %eax,0x8(%esp)
  800278:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80027f:	00 
  800280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800283:	89 04 24             	mov    %eax,(%esp)
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028d:	e8 ee 1d 00 00       	call   802080 <__umoddi3>
  800292:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800296:	0f be 80 75 22 80 00 	movsbl 0x802275(%eax),%eax
  80029d:	89 04 24             	mov    %eax,(%esp)
  8002a0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002a3:	83 c4 3c             	add    $0x3c,%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5f                   	pop    %edi
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002ae:	83 fa 01             	cmp    $0x1,%edx
  8002b1:	7e 0e                	jle    8002c1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 02                	mov    (%edx),%eax
  8002bc:	8b 52 04             	mov    0x4(%edx),%edx
  8002bf:	eb 22                	jmp    8002e3 <getuint+0x38>
	else if (lflag)
  8002c1:	85 d2                	test   %edx,%edx
  8002c3:	74 10                	je     8002d5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ca:	89 08                	mov    %ecx,(%eax)
  8002cc:	8b 02                	mov    (%edx),%eax
  8002ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d3:	eb 0e                	jmp    8002e3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002d5:	8b 10                	mov    (%eax),%edx
  8002d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002da:	89 08                	mov    %ecx,(%eax)
  8002dc:	8b 02                	mov    (%edx),%eax
  8002de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ef:	8b 10                	mov    (%eax),%edx
  8002f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f4:	73 0a                	jae    800300 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f9:	88 0a                	mov    %cl,(%edx)
  8002fb:	83 c2 01             	add    $0x1,%edx
  8002fe:	89 10                	mov    %edx,(%eax)
}
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800308:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	89 44 24 08          	mov    %eax,0x8(%esp)
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031d:	8b 45 08             	mov    0x8(%ebp),%eax
  800320:	89 04 24             	mov    %eax,(%esp)
  800323:	e8 02 00 00 00       	call   80032a <vprintfmt>
	va_end(ap);
}
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	57                   	push   %edi
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 4c             	sub    $0x4c,%esp
  800333:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800336:	8b 75 10             	mov    0x10(%ebp),%esi
  800339:	eb 12                	jmp    80034d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80033b:	85 c0                	test   %eax,%eax
  80033d:	0f 84 a9 03 00 00    	je     8006ec <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800343:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800347:	89 04 24             	mov    %eax,(%esp)
  80034a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80034d:	0f b6 06             	movzbl (%esi),%eax
  800350:	83 c6 01             	add    $0x1,%esi
  800353:	83 f8 25             	cmp    $0x25,%eax
  800356:	75 e3                	jne    80033b <vprintfmt+0x11>
  800358:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80035c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800363:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800368:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80036f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800374:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800377:	eb 2b                	jmp    8003a4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800379:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80037c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800380:	eb 22                	jmp    8003a4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800385:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800389:	eb 19                	jmp    8003a4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80038e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800395:	eb 0d                	jmp    8003a4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	0f b6 06             	movzbl (%esi),%eax
  8003a7:	0f b6 d0             	movzbl %al,%edx
  8003aa:	8d 7e 01             	lea    0x1(%esi),%edi
  8003ad:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8003b0:	83 e8 23             	sub    $0x23,%eax
  8003b3:	3c 55                	cmp    $0x55,%al
  8003b5:	0f 87 0b 03 00 00    	ja     8006c6 <vprintfmt+0x39c>
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	ff 24 85 c0 23 80 00 	jmp    *0x8023c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003c5:	83 ea 30             	sub    $0x30,%edx
  8003c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8003cb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003cf:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8003d5:	83 fa 09             	cmp    $0x9,%edx
  8003d8:	77 4a                	ja     800424 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003dd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003e0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8003e3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8003e7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003ea:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003ed:	83 fa 09             	cmp    $0x9,%edx
  8003f0:	76 eb                	jbe    8003dd <vprintfmt+0xb3>
  8003f2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003f5:	eb 2d                	jmp    800424 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 50 04             	lea    0x4(%eax),%edx
  8003fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800400:	8b 00                	mov    (%eax),%eax
  800402:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800408:	eb 1a                	jmp    800424 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80040d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800411:	79 91                	jns    8003a4 <vprintfmt+0x7a>
  800413:	e9 73 ff ff ff       	jmp    80038b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80041b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800422:	eb 80                	jmp    8003a4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800424:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800428:	0f 89 76 ff ff ff    	jns    8003a4 <vprintfmt+0x7a>
  80042e:	e9 64 ff ff ff       	jmp    800397 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800433:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800439:	e9 66 ff ff ff       	jmp    8003a4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	8d 50 04             	lea    0x4(%eax),%edx
  800444:	89 55 14             	mov    %edx,0x14(%ebp)
  800447:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	89 04 24             	mov    %eax,(%esp)
  800450:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800453:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800456:	e9 f2 fe ff ff       	jmp    80034d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 50 04             	lea    0x4(%eax),%edx
  800461:	89 55 14             	mov    %edx,0x14(%ebp)
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	c1 fa 1f             	sar    $0x1f,%edx
  80046b:	31 d0                	xor    %edx,%eax
  80046d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80046f:	83 f8 0f             	cmp    $0xf,%eax
  800472:	7f 0b                	jg     80047f <vprintfmt+0x155>
  800474:	8b 14 85 20 25 80 00 	mov    0x802520(,%eax,4),%edx
  80047b:	85 d2                	test   %edx,%edx
  80047d:	75 23                	jne    8004a2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80047f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800483:	c7 44 24 08 8d 22 80 	movl   $0x80228d,0x8(%esp)
  80048a:	00 
  80048b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80048f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800492:	89 3c 24             	mov    %edi,(%esp)
  800495:	e8 68 fe ff ff       	call   800302 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80049d:	e9 ab fe ff ff       	jmp    80034d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8004a2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004a6:	c7 44 24 08 51 26 80 	movl   $0x802651,0x8(%esp)
  8004ad:	00 
  8004ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004b2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004b5:	89 3c 24             	mov    %edi,(%esp)
  8004b8:	e8 45 fe ff ff       	call   800302 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8004c0:	e9 88 fe ff ff       	jmp    80034d <vprintfmt+0x23>
  8004c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8d 50 04             	lea    0x4(%eax),%edx
  8004d4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004d9:	85 f6                	test   %esi,%esi
  8004db:	ba 86 22 80 00       	mov    $0x802286,%edx
  8004e0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8004e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004e7:	7e 06                	jle    8004ef <vprintfmt+0x1c5>
  8004e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004ed:	75 10                	jne    8004ff <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ef:	0f be 06             	movsbl (%esi),%eax
  8004f2:	83 c6 01             	add    $0x1,%esi
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	0f 85 86 00 00 00    	jne    800583 <vprintfmt+0x259>
  8004fd:	eb 76                	jmp    800575 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ff:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800503:	89 34 24             	mov    %esi,(%esp)
  800506:	e8 90 02 00 00       	call   80079b <strnlen>
  80050b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80050e:	29 c2                	sub    %eax,%edx
  800510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800513:	85 d2                	test   %edx,%edx
  800515:	7e d8                	jle    8004ef <vprintfmt+0x1c5>
					putch(padc, putdat);
  800517:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80051b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80051e:	89 d6                	mov    %edx,%esi
  800520:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800523:	89 c7                	mov    %eax,%edi
  800525:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800529:	89 3c 24             	mov    %edi,(%esp)
  80052c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	83 ee 01             	sub    $0x1,%esi
  800532:	75 f1                	jne    800525 <vprintfmt+0x1fb>
  800534:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800537:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80053a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80053d:	eb b0                	jmp    8004ef <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80053f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800543:	74 18                	je     80055d <vprintfmt+0x233>
  800545:	8d 50 e0             	lea    -0x20(%eax),%edx
  800548:	83 fa 5e             	cmp    $0x5e,%edx
  80054b:	76 10                	jbe    80055d <vprintfmt+0x233>
					putch('?', putdat);
  80054d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800551:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800558:	ff 55 08             	call   *0x8(%ebp)
  80055b:	eb 0a                	jmp    800567 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80055d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800561:	89 04 24             	mov    %eax,(%esp)
  800564:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800567:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80056b:	0f be 06             	movsbl (%esi),%eax
  80056e:	83 c6 01             	add    $0x1,%esi
  800571:	85 c0                	test   %eax,%eax
  800573:	75 0e                	jne    800583 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800578:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057c:	7f 16                	jg     800594 <vprintfmt+0x26a>
  80057e:	e9 ca fd ff ff       	jmp    80034d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800583:	85 ff                	test   %edi,%edi
  800585:	78 b8                	js     80053f <vprintfmt+0x215>
  800587:	83 ef 01             	sub    $0x1,%edi
  80058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800590:	79 ad                	jns    80053f <vprintfmt+0x215>
  800592:	eb e1                	jmp    800575 <vprintfmt+0x24b>
  800594:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800597:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80059a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80059e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a7:	83 ee 01             	sub    $0x1,%esi
  8005aa:	75 ee                	jne    80059a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ac:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005af:	e9 99 fd ff ff       	jmp    80034d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005b4:	83 f9 01             	cmp    $0x1,%ecx
  8005b7:	7e 10                	jle    8005c9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 50 08             	lea    0x8(%eax),%edx
  8005bf:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c2:	8b 30                	mov    (%eax),%esi
  8005c4:	8b 78 04             	mov    0x4(%eax),%edi
  8005c7:	eb 26                	jmp    8005ef <vprintfmt+0x2c5>
	else if (lflag)
  8005c9:	85 c9                	test   %ecx,%ecx
  8005cb:	74 12                	je     8005df <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8d 50 04             	lea    0x4(%eax),%edx
  8005d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d6:	8b 30                	mov    (%eax),%esi
  8005d8:	89 f7                	mov    %esi,%edi
  8005da:	c1 ff 1f             	sar    $0x1f,%edi
  8005dd:	eb 10                	jmp    8005ef <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 30                	mov    (%eax),%esi
  8005ea:	89 f7                	mov    %esi,%edi
  8005ec:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005ef:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005f4:	85 ff                	test   %edi,%edi
  8005f6:	0f 89 8c 00 00 00    	jns    800688 <vprintfmt+0x35e>
				putch('-', putdat);
  8005fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800600:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800607:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80060a:	f7 de                	neg    %esi
  80060c:	83 d7 00             	adc    $0x0,%edi
  80060f:	f7 df                	neg    %edi
			}
			base = 10;
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
  800616:	eb 70                	jmp    800688 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800618:	89 ca                	mov    %ecx,%edx
  80061a:	8d 45 14             	lea    0x14(%ebp),%eax
  80061d:	e8 89 fc ff ff       	call   8002ab <getuint>
  800622:	89 c6                	mov    %eax,%esi
  800624:	89 d7                	mov    %edx,%edi
			base = 10;
  800626:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80062b:	eb 5b                	jmp    800688 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80062d:	89 ca                	mov    %ecx,%edx
  80062f:	8d 45 14             	lea    0x14(%ebp),%eax
  800632:	e8 74 fc ff ff       	call   8002ab <getuint>
  800637:	89 c6                	mov    %eax,%esi
  800639:	89 d7                	mov    %edx,%edi
			base = 8;
  80063b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800640:	eb 46                	jmp    800688 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800642:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800646:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80064d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800650:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800654:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80065b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 50 04             	lea    0x4(%eax),%edx
  800664:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800667:	8b 30                	mov    (%eax),%esi
  800669:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80066e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800673:	eb 13                	jmp    800688 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800675:	89 ca                	mov    %ecx,%edx
  800677:	8d 45 14             	lea    0x14(%ebp),%eax
  80067a:	e8 2c fc ff ff       	call   8002ab <getuint>
  80067f:	89 c6                	mov    %eax,%esi
  800681:	89 d7                	mov    %edx,%edi
			base = 16;
  800683:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800688:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80068c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800693:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800697:	89 44 24 08          	mov    %eax,0x8(%esp)
  80069b:	89 34 24             	mov    %esi,(%esp)
  80069e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a2:	89 da                	mov    %ebx,%edx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	e8 24 fb ff ff       	call   8001d0 <printnum>
			break;
  8006ac:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006af:	e9 99 fc ff ff       	jmp    80034d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006b8:	89 14 24             	mov    %edx,(%esp)
  8006bb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006be:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006c1:	e9 87 fc ff ff       	jmp    80034d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ca:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006d1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006d8:	0f 84 6f fc ff ff    	je     80034d <vprintfmt+0x23>
  8006de:	83 ee 01             	sub    $0x1,%esi
  8006e1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006e5:	75 f7                	jne    8006de <vprintfmt+0x3b4>
  8006e7:	e9 61 fc ff ff       	jmp    80034d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8006ec:	83 c4 4c             	add    $0x4c,%esp
  8006ef:	5b                   	pop    %ebx
  8006f0:	5e                   	pop    %esi
  8006f1:	5f                   	pop    %edi
  8006f2:	5d                   	pop    %ebp
  8006f3:	c3                   	ret    

008006f4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 28             	sub    $0x28,%esp
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800700:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800703:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800707:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800711:	85 c0                	test   %eax,%eax
  800713:	74 30                	je     800745 <vsnprintf+0x51>
  800715:	85 d2                	test   %edx,%edx
  800717:	7e 2c                	jle    800745 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	89 44 24 08          	mov    %eax,0x8(%esp)
  800727:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072e:	c7 04 24 e5 02 80 00 	movl   $0x8002e5,(%esp)
  800735:	e8 f0 fb ff ff       	call   80032a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800743:	eb 05                	jmp    80074a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800752:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800755:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	89 44 24 04          	mov    %eax,0x4(%esp)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	89 04 24             	mov    %eax,(%esp)
  80076d:	e8 82 ff ff ff       	call   8006f4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    
	...

00800780 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
  80078b:	80 3a 00             	cmpb   $0x0,(%edx)
  80078e:	74 09                	je     800799 <strlen+0x19>
		n++;
  800790:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800793:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800797:	75 f7                	jne    800790 <strlen+0x10>
		n++;
	return n;
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	85 c9                	test   %ecx,%ecx
  8007ac:	74 1a                	je     8007c8 <strnlen+0x2d>
  8007ae:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007b1:	74 15                	je     8007c8 <strnlen+0x2d>
  8007b3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8007b8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ba:	39 ca                	cmp    %ecx,%edx
  8007bc:	74 0a                	je     8007c8 <strnlen+0x2d>
  8007be:	83 c2 01             	add    $0x1,%edx
  8007c1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8007c6:	75 f0                	jne    8007b8 <strnlen+0x1d>
		n++;
	return n;
}
  8007c8:	5b                   	pop    %ebx
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	53                   	push   %ebx
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007da:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007de:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007e1:	83 c2 01             	add    $0x1,%edx
  8007e4:	84 c9                	test   %cl,%cl
  8007e6:	75 f2                	jne    8007da <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007e8:	5b                   	pop    %ebx
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f5:	89 1c 24             	mov    %ebx,(%esp)
  8007f8:	e8 83 ff ff ff       	call   800780 <strlen>
	strcpy(dst + len, src);
  8007fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800800:	89 54 24 04          	mov    %edx,0x4(%esp)
  800804:	01 d8                	add    %ebx,%eax
  800806:	89 04 24             	mov    %eax,(%esp)
  800809:	e8 bd ff ff ff       	call   8007cb <strcpy>
	return dst;
}
  80080e:	89 d8                	mov    %ebx,%eax
  800810:	83 c4 08             	add    $0x8,%esp
  800813:	5b                   	pop    %ebx
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	56                   	push   %esi
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800821:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800824:	85 f6                	test   %esi,%esi
  800826:	74 18                	je     800840 <strncpy+0x2a>
  800828:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80082d:	0f b6 1a             	movzbl (%edx),%ebx
  800830:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800833:	80 3a 01             	cmpb   $0x1,(%edx)
  800836:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800839:	83 c1 01             	add    $0x1,%ecx
  80083c:	39 f1                	cmp    %esi,%ecx
  80083e:	75 ed                	jne    80082d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	57                   	push   %edi
  800848:	56                   	push   %esi
  800849:	53                   	push   %ebx
  80084a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80084d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800850:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800853:	89 f8                	mov    %edi,%eax
  800855:	85 f6                	test   %esi,%esi
  800857:	74 2b                	je     800884 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800859:	83 fe 01             	cmp    $0x1,%esi
  80085c:	74 23                	je     800881 <strlcpy+0x3d>
  80085e:	0f b6 0b             	movzbl (%ebx),%ecx
  800861:	84 c9                	test   %cl,%cl
  800863:	74 1c                	je     800881 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800865:	83 ee 02             	sub    $0x2,%esi
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80086d:	88 08                	mov    %cl,(%eax)
  80086f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800872:	39 f2                	cmp    %esi,%edx
  800874:	74 0b                	je     800881 <strlcpy+0x3d>
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80087d:	84 c9                	test   %cl,%cl
  80087f:	75 ec                	jne    80086d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800881:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800884:	29 f8                	sub    %edi,%eax
}
  800886:	5b                   	pop    %ebx
  800887:	5e                   	pop    %esi
  800888:	5f                   	pop    %edi
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800894:	0f b6 01             	movzbl (%ecx),%eax
  800897:	84 c0                	test   %al,%al
  800899:	74 16                	je     8008b1 <strcmp+0x26>
  80089b:	3a 02                	cmp    (%edx),%al
  80089d:	75 12                	jne    8008b1 <strcmp+0x26>
		p++, q++;
  80089f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008a2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8008a6:	84 c0                	test   %al,%al
  8008a8:	74 07                	je     8008b1 <strcmp+0x26>
  8008aa:	83 c1 01             	add    $0x1,%ecx
  8008ad:	3a 02                	cmp    (%edx),%al
  8008af:	74 ee                	je     80089f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b1:	0f b6 c0             	movzbl %al,%eax
  8008b4:	0f b6 12             	movzbl (%edx),%edx
  8008b7:	29 d0                	sub    %edx,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008c5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008cd:	85 d2                	test   %edx,%edx
  8008cf:	74 28                	je     8008f9 <strncmp+0x3e>
  8008d1:	0f b6 01             	movzbl (%ecx),%eax
  8008d4:	84 c0                	test   %al,%al
  8008d6:	74 24                	je     8008fc <strncmp+0x41>
  8008d8:	3a 03                	cmp    (%ebx),%al
  8008da:	75 20                	jne    8008fc <strncmp+0x41>
  8008dc:	83 ea 01             	sub    $0x1,%edx
  8008df:	74 13                	je     8008f4 <strncmp+0x39>
		n--, p++, q++;
  8008e1:	83 c1 01             	add    $0x1,%ecx
  8008e4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008e7:	0f b6 01             	movzbl (%ecx),%eax
  8008ea:	84 c0                	test   %al,%al
  8008ec:	74 0e                	je     8008fc <strncmp+0x41>
  8008ee:	3a 03                	cmp    (%ebx),%al
  8008f0:	74 ea                	je     8008dc <strncmp+0x21>
  8008f2:	eb 08                	jmp    8008fc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008f9:	5b                   	pop    %ebx
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fc:	0f b6 01             	movzbl (%ecx),%eax
  8008ff:	0f b6 13             	movzbl (%ebx),%edx
  800902:	29 d0                	sub    %edx,%eax
  800904:	eb f3                	jmp    8008f9 <strncmp+0x3e>

00800906 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800910:	0f b6 10             	movzbl (%eax),%edx
  800913:	84 d2                	test   %dl,%dl
  800915:	74 1c                	je     800933 <strchr+0x2d>
		if (*s == c)
  800917:	38 ca                	cmp    %cl,%dl
  800919:	75 09                	jne    800924 <strchr+0x1e>
  80091b:	eb 1b                	jmp    800938 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80091d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800920:	38 ca                	cmp    %cl,%dl
  800922:	74 14                	je     800938 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800924:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800928:	84 d2                	test   %dl,%dl
  80092a:	75 f1                	jne    80091d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80092c:	b8 00 00 00 00       	mov    $0x0,%eax
  800931:	eb 05                	jmp    800938 <strchr+0x32>
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	0f b6 10             	movzbl (%eax),%edx
  800947:	84 d2                	test   %dl,%dl
  800949:	74 14                	je     80095f <strfind+0x25>
		if (*s == c)
  80094b:	38 ca                	cmp    %cl,%dl
  80094d:	75 06                	jne    800955 <strfind+0x1b>
  80094f:	eb 0e                	jmp    80095f <strfind+0x25>
  800951:	38 ca                	cmp    %cl,%dl
  800953:	74 0a                	je     80095f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	0f b6 10             	movzbl (%eax),%edx
  80095b:	84 d2                	test   %dl,%dl
  80095d:	75 f2                	jne    800951 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 0c             	sub    $0xc,%esp
  800967:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80096a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80096d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800970:	8b 7d 08             	mov    0x8(%ebp),%edi
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800979:	85 c9                	test   %ecx,%ecx
  80097b:	74 30                	je     8009ad <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800983:	75 25                	jne    8009aa <memset+0x49>
  800985:	f6 c1 03             	test   $0x3,%cl
  800988:	75 20                	jne    8009aa <memset+0x49>
		c &= 0xFF;
  80098a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098d:	89 d3                	mov    %edx,%ebx
  80098f:	c1 e3 08             	shl    $0x8,%ebx
  800992:	89 d6                	mov    %edx,%esi
  800994:	c1 e6 18             	shl    $0x18,%esi
  800997:	89 d0                	mov    %edx,%eax
  800999:	c1 e0 10             	shl    $0x10,%eax
  80099c:	09 f0                	or     %esi,%eax
  80099e:	09 d0                	or     %edx,%eax
  8009a0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009a5:	fc                   	cld    
  8009a6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a8:	eb 03                	jmp    8009ad <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009b2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009b5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009b8:	89 ec                	mov    %ebp,%esp
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d1:	39 c6                	cmp    %eax,%esi
  8009d3:	73 36                	jae    800a0b <memmove+0x4f>
  8009d5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d8:	39 d0                	cmp    %edx,%eax
  8009da:	73 2f                	jae    800a0b <memmove+0x4f>
		s += n;
		d += n;
  8009dc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	f6 c2 03             	test   $0x3,%dl
  8009e2:	75 1b                	jne    8009ff <memmove+0x43>
  8009e4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ea:	75 13                	jne    8009ff <memmove+0x43>
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 0e                	jne    8009ff <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 09                	jmp    800a08 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ff:	83 ef 01             	sub    $0x1,%edi
  800a02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a05:	fd                   	std    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a08:	fc                   	cld    
  800a09:	eb 20                	jmp    800a2b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a11:	75 13                	jne    800a26 <memmove+0x6a>
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 0f                	jne    800a26 <memmove+0x6a>
  800a17:	f6 c1 03             	test   $0x3,%cl
  800a1a:	75 0a                	jne    800a26 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a1f:	89 c7                	mov    %eax,%edi
  800a21:	fc                   	cld    
  800a22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a24:	eb 05                	jmp    800a2b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a26:	89 c7                	mov    %eax,%edi
  800a28:	fc                   	cld    
  800a29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a31:	89 ec                	mov    %ebp,%esp
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	89 04 24             	mov    %eax,(%esp)
  800a4f:	e8 68 ff ff ff       	call   8009bc <memmove>
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a62:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6a:	85 ff                	test   %edi,%edi
  800a6c:	74 37                	je     800aa5 <memcmp+0x4f>
		if (*s1 != *s2)
  800a6e:	0f b6 03             	movzbl (%ebx),%eax
  800a71:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a74:	83 ef 01             	sub    $0x1,%edi
  800a77:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a7c:	38 c8                	cmp    %cl,%al
  800a7e:	74 1c                	je     800a9c <memcmp+0x46>
  800a80:	eb 10                	jmp    800a92 <memcmp+0x3c>
  800a82:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a87:	83 c2 01             	add    $0x1,%edx
  800a8a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a8e:	38 c8                	cmp    %cl,%al
  800a90:	74 0a                	je     800a9c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800a92:	0f b6 c0             	movzbl %al,%eax
  800a95:	0f b6 c9             	movzbl %cl,%ecx
  800a98:	29 c8                	sub    %ecx,%eax
  800a9a:	eb 09                	jmp    800aa5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9c:	39 fa                	cmp    %edi,%edx
  800a9e:	75 e2                	jne    800a82 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5f                   	pop    %edi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab5:	39 d0                	cmp    %edx,%eax
  800ab7:	73 19                	jae    800ad2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800abd:	38 08                	cmp    %cl,(%eax)
  800abf:	75 06                	jne    800ac7 <memfind+0x1d>
  800ac1:	eb 0f                	jmp    800ad2 <memfind+0x28>
  800ac3:	38 08                	cmp    %cl,(%eax)
  800ac5:	74 0b                	je     800ad2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ac7:	83 c0 01             	add    $0x1,%eax
  800aca:	39 d0                	cmp    %edx,%eax
  800acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ad0:	75 f1                	jne    800ac3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 55 08             	mov    0x8(%ebp),%edx
  800add:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae0:	0f b6 02             	movzbl (%edx),%eax
  800ae3:	3c 20                	cmp    $0x20,%al
  800ae5:	74 04                	je     800aeb <strtol+0x17>
  800ae7:	3c 09                	cmp    $0x9,%al
  800ae9:	75 0e                	jne    800af9 <strtol+0x25>
		s++;
  800aeb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aee:	0f b6 02             	movzbl (%edx),%eax
  800af1:	3c 20                	cmp    $0x20,%al
  800af3:	74 f6                	je     800aeb <strtol+0x17>
  800af5:	3c 09                	cmp    $0x9,%al
  800af7:	74 f2                	je     800aeb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800af9:	3c 2b                	cmp    $0x2b,%al
  800afb:	75 0a                	jne    800b07 <strtol+0x33>
		s++;
  800afd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b00:	bf 00 00 00 00       	mov    $0x0,%edi
  800b05:	eb 10                	jmp    800b17 <strtol+0x43>
  800b07:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b0c:	3c 2d                	cmp    $0x2d,%al
  800b0e:	75 07                	jne    800b17 <strtol+0x43>
		s++, neg = 1;
  800b10:	83 c2 01             	add    $0x1,%edx
  800b13:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	0f 94 c0             	sete   %al
  800b1c:	74 05                	je     800b23 <strtol+0x4f>
  800b1e:	83 fb 10             	cmp    $0x10,%ebx
  800b21:	75 15                	jne    800b38 <strtol+0x64>
  800b23:	80 3a 30             	cmpb   $0x30,(%edx)
  800b26:	75 10                	jne    800b38 <strtol+0x64>
  800b28:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b2c:	75 0a                	jne    800b38 <strtol+0x64>
		s += 2, base = 16;
  800b2e:	83 c2 02             	add    $0x2,%edx
  800b31:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b36:	eb 13                	jmp    800b4b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b38:	84 c0                	test   %al,%al
  800b3a:	74 0f                	je     800b4b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b3c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b41:	80 3a 30             	cmpb   $0x30,(%edx)
  800b44:	75 05                	jne    800b4b <strtol+0x77>
		s++, base = 8;
  800b46:	83 c2 01             	add    $0x1,%edx
  800b49:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b52:	0f b6 0a             	movzbl (%edx),%ecx
  800b55:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b58:	80 fb 09             	cmp    $0x9,%bl
  800b5b:	77 08                	ja     800b65 <strtol+0x91>
			dig = *s - '0';
  800b5d:	0f be c9             	movsbl %cl,%ecx
  800b60:	83 e9 30             	sub    $0x30,%ecx
  800b63:	eb 1e                	jmp    800b83 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b65:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b68:	80 fb 19             	cmp    $0x19,%bl
  800b6b:	77 08                	ja     800b75 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b6d:	0f be c9             	movsbl %cl,%ecx
  800b70:	83 e9 57             	sub    $0x57,%ecx
  800b73:	eb 0e                	jmp    800b83 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b75:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b78:	80 fb 19             	cmp    $0x19,%bl
  800b7b:	77 14                	ja     800b91 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b7d:	0f be c9             	movsbl %cl,%ecx
  800b80:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b83:	39 f1                	cmp    %esi,%ecx
  800b85:	7d 0e                	jge    800b95 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b87:	83 c2 01             	add    $0x1,%edx
  800b8a:	0f af c6             	imul   %esi,%eax
  800b8d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800b8f:	eb c1                	jmp    800b52 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800b91:	89 c1                	mov    %eax,%ecx
  800b93:	eb 02                	jmp    800b97 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b95:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800b97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9b:	74 05                	je     800ba2 <strtol+0xce>
		*endptr = (char *) s;
  800b9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ba0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ba2:	89 ca                	mov    %ecx,%edx
  800ba4:	f7 da                	neg    %edx
  800ba6:	85 ff                	test   %edi,%edi
  800ba8:	0f 45 c2             	cmovne %edx,%eax
}
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 0c             	sub    $0xc,%esp
  800bb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bb9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	89 c3                	mov    %eax,%ebx
  800bcc:	89 c7                	mov    %eax,%edi
  800bce:	89 c6                	mov    %eax,%esi
  800bd0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bdb:	89 ec                	mov    %ebp,%esp
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_cgetc>:

int
sys_cgetc(void)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800be8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800beb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bee:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf8:	89 d1                	mov    %edx,%ecx
  800bfa:	89 d3                	mov    %edx,%ebx
  800bfc:	89 d7                	mov    %edx,%edi
  800bfe:	89 d6                	mov    %edx,%esi
  800c00:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c02:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c05:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c08:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c0b:	89 ec                	mov    %ebp,%esp
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 38             	sub    $0x38,%esp
  800c15:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	89 cb                	mov    %ecx,%ebx
  800c2d:	89 cf                	mov    %ecx,%edi
  800c2f:	89 ce                	mov    %ecx,%esi
  800c31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c33:	85 c0                	test   %eax,%eax
  800c35:	7e 28                	jle    800c5f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c3b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800c5a:	e8 31 11 00 00       	call   801d90 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c68:	89 ec                	mov    %ebp,%esp
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800c80:	b8 02 00 00 00       	mov    $0x2,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c98:	89 ec                	mov    %ebp,%esp
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_yield>:

void
sys_yield(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ca5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ca8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cbf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cc2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cc5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cc8:	89 ec                	mov    %ebp,%esp
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 38             	sub    $0x38,%esp
  800cd2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cd5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cd8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdb:	be 00 00 00 00       	mov    $0x0,%esi
  800ce0:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	89 f7                	mov    %esi,%edi
  800cf0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	7e 28                	jle    800d1e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfa:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d01:	00 
  800d02:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800d09:	00 
  800d0a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d11:	00 
  800d12:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800d19:	e8 72 10 00 00       	call   801d90 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d21:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d24:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d27:	89 ec                	mov    %ebp,%esp
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 38             	sub    $0x38,%esp
  800d31:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d34:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d37:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d3f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	7e 28                	jle    800d7c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d58:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d5f:	00 
  800d60:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800d67:	00 
  800d68:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6f:	00 
  800d70:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800d77:	e8 14 10 00 00       	call   801d90 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d7c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d7f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d82:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d85:	89 ec                	mov    %ebp,%esp
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 38             	sub    $0x38,%esp
  800d8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d95:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9d:	b8 06 00 00 00       	mov    $0x6,%eax
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	89 df                	mov    %ebx,%edi
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7e 28                	jle    800dda <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dbd:	00 
  800dbe:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800dc5:	00 
  800dc6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcd:	00 
  800dce:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800dd5:	e8 b6 0f 00 00       	call   801d90 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dda:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ddd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de3:	89 ec                	mov    %ebp,%esp
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 38             	sub    $0x38,%esp
  800ded:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7e 28                	jle    800e38 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800e23:	00 
  800e24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2b:	00 
  800e2c:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800e33:	e8 58 0f 00 00       	call   801d90 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e38:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e41:	89 ec                	mov    %ebp,%esp
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 38             	sub    $0x38,%esp
  800e4b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e51:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7e 28                	jle    800e96 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e72:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e79:	00 
  800e7a:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800e81:	00 
  800e82:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e89:	00 
  800e8a:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800e91:	e8 fa 0e 00 00       	call   801d90 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9f:	89 ec                	mov    %ebp,%esp
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 38             	sub    $0x38,%esp
  800ea9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eaf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7e 28                	jle    800ef4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed7:	00 
  800ed8:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800edf:	00 
  800ee0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee7:	00 
  800ee8:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800eef:	e8 9c 0e 00 00       	call   801d90 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efd:	89 ec                	mov    %ebp,%esp
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f10:	be 00 00 00 00       	mov    $0x0,%esi
  800f15:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f31:	89 ec                	mov    %ebp,%esp
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 38             	sub    $0x38,%esp
  800f3b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f41:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f49:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	89 cb                	mov    %ecx,%ebx
  800f53:	89 cf                	mov    %ecx,%edi
  800f55:	89 ce                	mov    %ecx,%esi
  800f57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7e 28                	jle    800f85 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f61:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f68:	00 
  800f69:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
  800f70:	00 
  800f71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f78:	00 
  800f79:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  800f80:	e8 0b 0e 00 00       	call   801d90 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f85:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f88:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8e:	89 ec                	mov    %ebp,%esp
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    
	...

00800fa0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fab:	c1 e8 0c             	shr    $0xc,%eax
}
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	89 04 24             	mov    %eax,(%esp)
  800fbc:	e8 df ff ff ff       	call   800fa0 <fd2num>
  800fc1:	05 20 00 0d 00       	add    $0xd0020,%eax
  800fc6:	c1 e0 0c             	shl    $0xc,%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	53                   	push   %ebx
  800fcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fd2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800fd7:	a8 01                	test   $0x1,%al
  800fd9:	74 34                	je     80100f <fd_alloc+0x44>
  800fdb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800fe0:	a8 01                	test   $0x1,%al
  800fe2:	74 32                	je     801016 <fd_alloc+0x4b>
  800fe4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fe9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800feb:	89 c2                	mov    %eax,%edx
  800fed:	c1 ea 16             	shr    $0x16,%edx
  800ff0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff7:	f6 c2 01             	test   $0x1,%dl
  800ffa:	74 1f                	je     80101b <fd_alloc+0x50>
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	c1 ea 0c             	shr    $0xc,%edx
  801001:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801008:	f6 c2 01             	test   $0x1,%dl
  80100b:	75 17                	jne    801024 <fd_alloc+0x59>
  80100d:	eb 0c                	jmp    80101b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80100f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801014:	eb 05                	jmp    80101b <fd_alloc+0x50>
  801016:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80101b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
  801022:	eb 17                	jmp    80103b <fd_alloc+0x70>
  801024:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801029:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80102e:	75 b9                	jne    800fe9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801030:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801036:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80103b:	5b                   	pop    %ebx
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801049:	83 fa 1f             	cmp    $0x1f,%edx
  80104c:	77 3f                	ja     80108d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80104e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801054:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801057:	89 d0                	mov    %edx,%eax
  801059:	c1 e8 16             	shr    $0x16,%eax
  80105c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801063:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801068:	f6 c1 01             	test   $0x1,%cl
  80106b:	74 20                	je     80108d <fd_lookup+0x4f>
  80106d:	89 d0                	mov    %edx,%eax
  80106f:	c1 e8 0c             	shr    $0xc,%eax
  801072:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80107e:	f6 c1 01             	test   $0x1,%cl
  801081:	74 0a                	je     80108d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
	return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    

0080108f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	53                   	push   %ebx
  801093:	83 ec 14             	sub    $0x14,%esp
  801096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801099:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80109c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010a1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8010a7:	75 17                	jne    8010c0 <dev_lookup+0x31>
  8010a9:	eb 07                	jmp    8010b2 <dev_lookup+0x23>
  8010ab:	39 0a                	cmp    %ecx,(%edx)
  8010ad:	75 11                	jne    8010c0 <dev_lookup+0x31>
  8010af:	90                   	nop
  8010b0:	eb 05                	jmp    8010b7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010b2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8010b7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8010b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010be:	eb 35                	jmp    8010f5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010c0:	83 c0 01             	add    $0x1,%eax
  8010c3:	8b 14 85 28 26 80 00 	mov    0x802628(,%eax,4),%edx
  8010ca:	85 d2                	test   %edx,%edx
  8010cc:	75 dd                	jne    8010ab <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8010d3:	8b 40 48             	mov    0x48(%eax),%eax
  8010d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010de:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8010e5:	e8 c5 f0 ff ff       	call   8001af <cprintf>
	*dev = 0;
  8010ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f5:	83 c4 14             	add    $0x14,%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 38             	sub    $0x38,%esp
  801101:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801104:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801107:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80110a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80110d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801111:	89 3c 24             	mov    %edi,(%esp)
  801114:	e8 87 fe ff ff       	call   800fa0 <fd2num>
  801119:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80111c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801120:	89 04 24             	mov    %eax,(%esp)
  801123:	e8 16 ff ff ff       	call   80103e <fd_lookup>
  801128:	89 c3                	mov    %eax,%ebx
  80112a:	85 c0                	test   %eax,%eax
  80112c:	78 05                	js     801133 <fd_close+0x38>
	    || fd != fd2)
  80112e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801131:	74 0e                	je     801141 <fd_close+0x46>
		return (must_exist ? r : 0);
  801133:	89 f0                	mov    %esi,%eax
  801135:	84 c0                	test   %al,%al
  801137:	b8 00 00 00 00       	mov    $0x0,%eax
  80113c:	0f 44 d8             	cmove  %eax,%ebx
  80113f:	eb 3d                	jmp    80117e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801141:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801144:	89 44 24 04          	mov    %eax,0x4(%esp)
  801148:	8b 07                	mov    (%edi),%eax
  80114a:	89 04 24             	mov    %eax,(%esp)
  80114d:	e8 3d ff ff ff       	call   80108f <dev_lookup>
  801152:	89 c3                	mov    %eax,%ebx
  801154:	85 c0                	test   %eax,%eax
  801156:	78 16                	js     80116e <fd_close+0x73>
		if (dev->dev_close)
  801158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801163:	85 c0                	test   %eax,%eax
  801165:	74 07                	je     80116e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801167:	89 3c 24             	mov    %edi,(%esp)
  80116a:	ff d0                	call   *%eax
  80116c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80116e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801179:	e8 0b fc ff ff       	call   800d89 <sys_page_unmap>
	return r;
}
  80117e:	89 d8                	mov    %ebx,%eax
  801180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801183:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801186:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801189:	89 ec                	mov    %ebp,%esp
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801193:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801196:	89 44 24 04          	mov    %eax,0x4(%esp)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	89 04 24             	mov    %eax,(%esp)
  8011a0:	e8 99 fe ff ff       	call   80103e <fd_lookup>
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	78 13                	js     8011bc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8011a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011b0:	00 
  8011b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b4:	89 04 24             	mov    %eax,(%esp)
  8011b7:	e8 3f ff ff ff       	call   8010fb <fd_close>
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <close_all>:

void
close_all(void)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011ca:	89 1c 24             	mov    %ebx,(%esp)
  8011cd:	e8 bb ff ff ff       	call   80118d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d2:	83 c3 01             	add    $0x1,%ebx
  8011d5:	83 fb 20             	cmp    $0x20,%ebx
  8011d8:	75 f0                	jne    8011ca <close_all+0xc>
		close(i);
}
  8011da:	83 c4 14             	add    $0x14,%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    

008011e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 58             	sub    $0x58,%esp
  8011e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8011ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 04 24             	mov    %eax,(%esp)
  8011ff:	e8 3a fe ff ff       	call   80103e <fd_lookup>
  801204:	89 c3                	mov    %eax,%ebx
  801206:	85 c0                	test   %eax,%eax
  801208:	0f 88 e1 00 00 00    	js     8012ef <dup+0x10f>
		return r;
	close(newfdnum);
  80120e:	89 3c 24             	mov    %edi,(%esp)
  801211:	e8 77 ff ff ff       	call   80118d <close>

	newfd = INDEX2FD(newfdnum);
  801216:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80121c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80121f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801222:	89 04 24             	mov    %eax,(%esp)
  801225:	e8 86 fd ff ff       	call   800fb0 <fd2data>
  80122a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80122c:	89 34 24             	mov    %esi,(%esp)
  80122f:	e8 7c fd ff ff       	call   800fb0 <fd2data>
  801234:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801237:	89 d8                	mov    %ebx,%eax
  801239:	c1 e8 16             	shr    $0x16,%eax
  80123c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801243:	a8 01                	test   $0x1,%al
  801245:	74 46                	je     80128d <dup+0xad>
  801247:	89 d8                	mov    %ebx,%eax
  801249:	c1 e8 0c             	shr    $0xc,%eax
  80124c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801253:	f6 c2 01             	test   $0x1,%dl
  801256:	74 35                	je     80128d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801258:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125f:	25 07 0e 00 00       	and    $0xe07,%eax
  801264:	89 44 24 10          	mov    %eax,0x10(%esp)
  801268:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80126b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801276:	00 
  801277:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80127b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801282:	e8 a4 fa ff ff       	call   800d2b <sys_page_map>
  801287:	89 c3                	mov    %eax,%ebx
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 3b                	js     8012c8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80128d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801290:	89 c2                	mov    %eax,%edx
  801292:	c1 ea 0c             	shr    $0xc,%edx
  801295:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b1:	00 
  8012b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bd:	e8 69 fa ff ff       	call   800d2b <sys_page_map>
  8012c2:	89 c3                	mov    %eax,%ebx
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 25                	jns    8012ed <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d3:	e8 b1 fa ff ff       	call   800d89 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e6:	e8 9e fa ff ff       	call   800d89 <sys_page_unmap>
	return r;
  8012eb:	eb 02                	jmp    8012ef <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8012ed:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012ef:	89 d8                	mov    %ebx,%eax
  8012f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012fa:	89 ec                	mov    %ebp,%esp
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	53                   	push   %ebx
  801302:	83 ec 24             	sub    $0x24,%esp
  801305:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801308:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130f:	89 1c 24             	mov    %ebx,(%esp)
  801312:	e8 27 fd ff ff       	call   80103e <fd_lookup>
  801317:	85 c0                	test   %eax,%eax
  801319:	78 6d                	js     801388 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801325:	8b 00                	mov    (%eax),%eax
  801327:	89 04 24             	mov    %eax,(%esp)
  80132a:	e8 60 fd ff ff       	call   80108f <dev_lookup>
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 55                	js     801388 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	8b 50 08             	mov    0x8(%eax),%edx
  801339:	83 e2 03             	and    $0x3,%edx
  80133c:	83 fa 01             	cmp    $0x1,%edx
  80133f:	75 23                	jne    801364 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801341:	a1 04 40 80 00       	mov    0x804004,%eax
  801346:	8b 40 48             	mov    0x48(%eax),%eax
  801349:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80134d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801351:	c7 04 24 ed 25 80 00 	movl   $0x8025ed,(%esp)
  801358:	e8 52 ee ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  80135d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801362:	eb 24                	jmp    801388 <read+0x8a>
	}
	if (!dev->dev_read)
  801364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801367:	8b 52 08             	mov    0x8(%edx),%edx
  80136a:	85 d2                	test   %edx,%edx
  80136c:	74 15                	je     801383 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80136e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801371:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801375:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801378:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80137c:	89 04 24             	mov    %eax,(%esp)
  80137f:	ff d2                	call   *%edx
  801381:	eb 05                	jmp    801388 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801383:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801388:	83 c4 24             	add    $0x24,%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
  801394:	83 ec 1c             	sub    $0x1c,%esp
  801397:	8b 7d 08             	mov    0x8(%ebp),%edi
  80139a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a2:	85 f6                	test   %esi,%esi
  8013a4:	74 30                	je     8013d6 <readn+0x48>
  8013a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ab:	89 f2                	mov    %esi,%edx
  8013ad:	29 c2                	sub    %eax,%edx
  8013af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013b3:	03 45 0c             	add    0xc(%ebp),%eax
  8013b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ba:	89 3c 24             	mov    %edi,(%esp)
  8013bd:	e8 3c ff ff ff       	call   8012fe <read>
		if (m < 0)
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 10                	js     8013d6 <readn+0x48>
			return m;
		if (m == 0)
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	74 0a                	je     8013d4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ca:	01 c3                	add    %eax,%ebx
  8013cc:	89 d8                	mov    %ebx,%eax
  8013ce:	39 f3                	cmp    %esi,%ebx
  8013d0:	72 d9                	jb     8013ab <readn+0x1d>
  8013d2:	eb 02                	jmp    8013d6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8013d4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8013d6:	83 c4 1c             	add    $0x1c,%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5f                   	pop    %edi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 24             	sub    $0x24,%esp
  8013e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ef:	89 1c 24             	mov    %ebx,(%esp)
  8013f2:	e8 47 fc ff ff       	call   80103e <fd_lookup>
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 68                	js     801463 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	89 04 24             	mov    %eax,(%esp)
  80140a:	e8 80 fc ff ff       	call   80108f <dev_lookup>
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 50                	js     801463 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141a:	75 23                	jne    80143f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80141c:	a1 04 40 80 00       	mov    0x804004,%eax
  801421:	8b 40 48             	mov    0x48(%eax),%eax
  801424:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142c:	c7 04 24 09 26 80 00 	movl   $0x802609,(%esp)
  801433:	e8 77 ed ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  801438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143d:	eb 24                	jmp    801463 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80143f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801442:	8b 52 0c             	mov    0xc(%edx),%edx
  801445:	85 d2                	test   %edx,%edx
  801447:	74 15                	je     80145e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801449:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	ff d2                	call   *%edx
  80145c:	eb 05                	jmp    801463 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80145e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801463:	83 c4 24             	add    $0x24,%esp
  801466:	5b                   	pop    %ebx
  801467:	5d                   	pop    %ebp
  801468:	c3                   	ret    

00801469 <seek>:

int
seek(int fdnum, off_t offset)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801472:	89 44 24 04          	mov    %eax,0x4(%esp)
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	89 04 24             	mov    %eax,(%esp)
  80147c:	e8 bd fb ff ff       	call   80103e <fd_lookup>
  801481:	85 c0                	test   %eax,%eax
  801483:	78 0e                	js     801493 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	53                   	push   %ebx
  801499:	83 ec 24             	sub    $0x24,%esp
  80149c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	89 1c 24             	mov    %ebx,(%esp)
  8014a9:	e8 90 fb ff ff       	call   80103e <fd_lookup>
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 61                	js     801513 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	89 04 24             	mov    %eax,(%esp)
  8014c1:	e8 c9 fb ff ff       	call   80108f <dev_lookup>
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 49                	js     801513 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d1:	75 23                	jne    8014f6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014d3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d8:	8b 40 48             	mov    0x48(%eax),%eax
  8014db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e3:	c7 04 24 cc 25 80 00 	movl   $0x8025cc,(%esp)
  8014ea:	e8 c0 ec ff ff       	call   8001af <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb 1d                	jmp    801513 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f9:	8b 52 18             	mov    0x18(%edx),%edx
  8014fc:	85 d2                	test   %edx,%edx
  8014fe:	74 0e                	je     80150e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801503:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801507:	89 04 24             	mov    %eax,(%esp)
  80150a:	ff d2                	call   *%edx
  80150c:	eb 05                	jmp    801513 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80150e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801513:	83 c4 24             	add    $0x24,%esp
  801516:	5b                   	pop    %ebx
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	53                   	push   %ebx
  80151d:	83 ec 24             	sub    $0x24,%esp
  801520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801523:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 04 24             	mov    %eax,(%esp)
  801530:	e8 09 fb ff ff       	call   80103e <fd_lookup>
  801535:	85 c0                	test   %eax,%eax
  801537:	78 52                	js     80158b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801539:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	89 04 24             	mov    %eax,(%esp)
  801548:	e8 42 fb ff ff       	call   80108f <dev_lookup>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 3a                	js     80158b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801558:	74 2c                	je     801586 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80155a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80155d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801564:	00 00 00 
	stat->st_isdir = 0;
  801567:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80156e:	00 00 00 
	stat->st_dev = dev;
  801571:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801577:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80157b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157e:	89 14 24             	mov    %edx,(%esp)
  801581:	ff 50 14             	call   *0x14(%eax)
  801584:	eb 05                	jmp    80158b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801586:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80158b:	83 c4 24             	add    $0x24,%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    

00801591 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
  801597:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80159a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80159d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015a4:	00 
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	89 04 24             	mov    %eax,(%esp)
  8015ab:	e8 bc 01 00 00       	call   80176c <open>
  8015b0:	89 c3                	mov    %eax,%ebx
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 1b                	js     8015d1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bd:	89 1c 24             	mov    %ebx,(%esp)
  8015c0:	e8 54 ff ff ff       	call   801519 <fstat>
  8015c5:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c7:	89 1c 24             	mov    %ebx,(%esp)
  8015ca:	e8 be fb ff ff       	call   80118d <close>
	return r;
  8015cf:	89 f3                	mov    %esi,%ebx
}
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015d9:	89 ec                	mov    %ebp,%esp
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    
  8015dd:	00 00                	add    %al,(%eax)
	...

008015e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 18             	sub    $0x18,%esp
  8015e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015ec:	89 c3                	mov    %eax,%ebx
  8015ee:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8015f0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015f7:	75 11                	jne    80160a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801600:	e8 c1 08 00 00       	call   801ec6 <ipc_find_env>
  801605:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80160a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801611:	00 
  801612:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801619:	00 
  80161a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80161e:	a1 00 40 80 00       	mov    0x804000,%eax
  801623:	89 04 24             	mov    %eax,(%esp)
  801626:	e8 17 08 00 00       	call   801e42 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80162b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801632:	00 
  801633:	89 74 24 04          	mov    %esi,0x4(%esp)
  801637:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163e:	e8 ad 07 00 00       	call   801df0 <ipc_recv>
}
  801643:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801646:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801649:	89 ec                	mov    %ebp,%esp
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	53                   	push   %ebx
  801651:	83 ec 14             	sub    $0x14,%esp
  801654:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8b 40 0c             	mov    0xc(%eax),%eax
  80165d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 05 00 00 00       	mov    $0x5,%eax
  80166c:	e8 6f ff ff ff       	call   8015e0 <fsipc>
  801671:	85 c0                	test   %eax,%eax
  801673:	78 2b                	js     8016a0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801675:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80167c:	00 
  80167d:	89 1c 24             	mov    %ebx,(%esp)
  801680:	e8 46 f1 ff ff       	call   8007cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801685:	a1 80 50 80 00       	mov    0x805080,%eax
  80168a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801690:	a1 84 50 80 00       	mov    0x805084,%eax
  801695:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a0:	83 c4 14             	add    $0x14,%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c1:	e8 1a ff ff ff       	call   8015e0 <fsipc>
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 10             	sub    $0x10,%esp
  8016d0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016de:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ee:	e8 ed fe ff ff       	call   8015e0 <fsipc>
  8016f3:	89 c3                	mov    %eax,%ebx
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 6a                	js     801763 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016f9:	39 c6                	cmp    %eax,%esi
  8016fb:	73 24                	jae    801721 <devfile_read+0x59>
  8016fd:	c7 44 24 0c 38 26 80 	movl   $0x802638,0xc(%esp)
  801704:	00 
  801705:	c7 44 24 08 3f 26 80 	movl   $0x80263f,0x8(%esp)
  80170c:	00 
  80170d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801714:	00 
  801715:	c7 04 24 54 26 80 00 	movl   $0x802654,(%esp)
  80171c:	e8 6f 06 00 00       	call   801d90 <_panic>
	assert(r <= PGSIZE);
  801721:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801726:	7e 24                	jle    80174c <devfile_read+0x84>
  801728:	c7 44 24 0c 5f 26 80 	movl   $0x80265f,0xc(%esp)
  80172f:	00 
  801730:	c7 44 24 08 3f 26 80 	movl   $0x80263f,0x8(%esp)
  801737:	00 
  801738:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80173f:	00 
  801740:	c7 04 24 54 26 80 00 	movl   $0x802654,(%esp)
  801747:	e8 44 06 00 00       	call   801d90 <_panic>
	memmove(buf, &fsipcbuf, r);
  80174c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801750:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801757:	00 
  801758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175b:	89 04 24             	mov    %eax,(%esp)
  80175e:	e8 59 f2 ff ff       	call   8009bc <memmove>
	return r;
}
  801763:	89 d8                	mov    %ebx,%eax
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 20             	sub    $0x20,%esp
  801774:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801777:	89 34 24             	mov    %esi,(%esp)
  80177a:	e8 01 f0 ff ff       	call   800780 <strlen>
		return -E_BAD_PATH;
  80177f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801784:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801789:	7f 5e                	jg     8017e9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80178b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178e:	89 04 24             	mov    %eax,(%esp)
  801791:	e8 35 f8 ff ff       	call   800fcb <fd_alloc>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 4d                	js     8017e9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80179c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017a7:	e8 1f f0 ff ff       	call   8007cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017af:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bc:	e8 1f fe ff ff       	call   8015e0 <fsipc>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	79 15                	jns    8017dc <open+0x70>
		fd_close(fd, 0);
  8017c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017ce:	00 
  8017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d2:	89 04 24             	mov    %eax,(%esp)
  8017d5:	e8 21 f9 ff ff       	call   8010fb <fd_close>
		return r;
  8017da:	eb 0d                	jmp    8017e9 <open+0x7d>
	}

	return fd2num(fd);
  8017dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017df:	89 04 24             	mov    %eax,(%esp)
  8017e2:	e8 b9 f7 ff ff       	call   800fa0 <fd2num>
  8017e7:	89 c3                	mov    %eax,%ebx
}
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	83 c4 20             	add    $0x20,%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    
	...

00801800 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 18             	sub    $0x18,%esp
  801806:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801809:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80180c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 96 f7 ff ff       	call   800fb0 <fd2data>
  80181a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80181c:	c7 44 24 04 6b 26 80 	movl   $0x80266b,0x4(%esp)
  801823:	00 
  801824:	89 34 24             	mov    %esi,(%esp)
  801827:	e8 9f ef ff ff       	call   8007cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80182c:	8b 43 04             	mov    0x4(%ebx),%eax
  80182f:	2b 03                	sub    (%ebx),%eax
  801831:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801837:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80183e:	00 00 00 
	stat->st_dev = &devpipe;
  801841:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801848:	30 80 00 
	return 0;
}
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801853:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801856:	89 ec                	mov    %ebp,%esp
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	83 ec 14             	sub    $0x14,%esp
  801861:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801864:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801868:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186f:	e8 15 f5 ff ff       	call   800d89 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801874:	89 1c 24             	mov    %ebx,(%esp)
  801877:	e8 34 f7 ff ff       	call   800fb0 <fd2data>
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801887:	e8 fd f4 ff ff       	call   800d89 <sys_page_unmap>
}
  80188c:	83 c4 14             	add    $0x14,%esp
  80188f:	5b                   	pop    %ebx
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	57                   	push   %edi
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	83 ec 2c             	sub    $0x2c,%esp
  80189b:	89 c7                	mov    %eax,%edi
  80189d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8018a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8018a5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018a8:	89 3c 24             	mov    %edi,(%esp)
  8018ab:	e8 60 06 00 00       	call   801f10 <pageref>
  8018b0:	89 c6                	mov    %eax,%esi
  8018b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	e8 53 06 00 00       	call   801f10 <pageref>
  8018bd:	39 c6                	cmp    %eax,%esi
  8018bf:	0f 94 c0             	sete   %al
  8018c2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8018c5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018ce:	39 cb                	cmp    %ecx,%ebx
  8018d0:	75 08                	jne    8018da <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8018d2:	83 c4 2c             	add    $0x2c,%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5f                   	pop    %edi
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8018da:	83 f8 01             	cmp    $0x1,%eax
  8018dd:	75 c1                	jne    8018a0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018df:	8b 52 58             	mov    0x58(%edx),%edx
  8018e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ee:	c7 04 24 72 26 80 00 	movl   $0x802672,(%esp)
  8018f5:	e8 b5 e8 ff ff       	call   8001af <cprintf>
  8018fa:	eb a4                	jmp    8018a0 <_pipeisclosed+0xe>

008018fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	57                   	push   %edi
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 2c             	sub    $0x2c,%esp
  801905:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801908:	89 34 24             	mov    %esi,(%esp)
  80190b:	e8 a0 f6 ff ff       	call   800fb0 <fd2data>
  801910:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801912:	bf 00 00 00 00       	mov    $0x0,%edi
  801917:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80191b:	75 50                	jne    80196d <devpipe_write+0x71>
  80191d:	eb 5c                	jmp    80197b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80191f:	89 da                	mov    %ebx,%edx
  801921:	89 f0                	mov    %esi,%eax
  801923:	e8 6a ff ff ff       	call   801892 <_pipeisclosed>
  801928:	85 c0                	test   %eax,%eax
  80192a:	75 53                	jne    80197f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80192c:	e8 6b f3 ff ff       	call   800c9c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801931:	8b 43 04             	mov    0x4(%ebx),%eax
  801934:	8b 13                	mov    (%ebx),%edx
  801936:	83 c2 20             	add    $0x20,%edx
  801939:	39 d0                	cmp    %edx,%eax
  80193b:	73 e2                	jae    80191f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801944:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801947:	89 c2                	mov    %eax,%edx
  801949:	c1 fa 1f             	sar    $0x1f,%edx
  80194c:	c1 ea 1b             	shr    $0x1b,%edx
  80194f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801952:	83 e1 1f             	and    $0x1f,%ecx
  801955:	29 d1                	sub    %edx,%ecx
  801957:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80195b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80195f:	83 c0 01             	add    $0x1,%eax
  801962:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801965:	83 c7 01             	add    $0x1,%edi
  801968:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80196b:	74 0e                	je     80197b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80196d:	8b 43 04             	mov    0x4(%ebx),%eax
  801970:	8b 13                	mov    (%ebx),%edx
  801972:	83 c2 20             	add    $0x20,%edx
  801975:	39 d0                	cmp    %edx,%eax
  801977:	73 a6                	jae    80191f <devpipe_write+0x23>
  801979:	eb c2                	jmp    80193d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80197b:	89 f8                	mov    %edi,%eax
  80197d:	eb 05                	jmp    801984 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801984:	83 c4 2c             	add    $0x2c,%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5f                   	pop    %edi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 28             	sub    $0x28,%esp
  801992:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801995:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801998:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80199b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80199e:	89 3c 24             	mov    %edi,(%esp)
  8019a1:	e8 0a f6 ff ff       	call   800fb0 <fd2data>
  8019a6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019a8:	be 00 00 00 00       	mov    $0x0,%esi
  8019ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b1:	75 47                	jne    8019fa <devpipe_read+0x6e>
  8019b3:	eb 52                	jmp    801a07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8019b5:	89 f0                	mov    %esi,%eax
  8019b7:	eb 5e                	jmp    801a17 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8019b9:	89 da                	mov    %ebx,%edx
  8019bb:	89 f8                	mov    %edi,%eax
  8019bd:	8d 76 00             	lea    0x0(%esi),%esi
  8019c0:	e8 cd fe ff ff       	call   801892 <_pipeisclosed>
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	75 49                	jne    801a12 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8019c9:	e8 ce f2 ff ff       	call   800c9c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8019ce:	8b 03                	mov    (%ebx),%eax
  8019d0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019d3:	74 e4                	je     8019b9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019d5:	89 c2                	mov    %eax,%edx
  8019d7:	c1 fa 1f             	sar    $0x1f,%edx
  8019da:	c1 ea 1b             	shr    $0x1b,%edx
  8019dd:	01 d0                	add    %edx,%eax
  8019df:	83 e0 1f             	and    $0x1f,%eax
  8019e2:	29 d0                	sub    %edx,%eax
  8019e4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8019ef:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019f2:	83 c6 01             	add    $0x1,%esi
  8019f5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019f8:	74 0d                	je     801a07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8019fa:	8b 03                	mov    (%ebx),%eax
  8019fc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019ff:	75 d4                	jne    8019d5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a01:	85 f6                	test   %esi,%esi
  801a03:	75 b0                	jne    8019b5 <devpipe_read+0x29>
  801a05:	eb b2                	jmp    8019b9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a07:	89 f0                	mov    %esi,%eax
  801a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801a10:	eb 05                	jmp    801a17 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a12:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801a17:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a1a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a1d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a20:	89 ec                	mov    %ebp,%esp
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 48             	sub    $0x48,%esp
  801a2a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a2d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a30:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a33:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a39:	89 04 24             	mov    %eax,(%esp)
  801a3c:	e8 8a f5 ff ff       	call   800fcb <fd_alloc>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	85 c0                	test   %eax,%eax
  801a45:	0f 88 45 01 00 00    	js     801b90 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a4b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a52:	00 
  801a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a61:	e8 66 f2 ff ff       	call   800ccc <sys_page_alloc>
  801a66:	89 c3                	mov    %eax,%ebx
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	0f 88 20 01 00 00    	js     801b90 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801a70:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a73:	89 04 24             	mov    %eax,(%esp)
  801a76:	e8 50 f5 ff ff       	call   800fcb <fd_alloc>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	0f 88 f8 00 00 00    	js     801b7d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a85:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a8c:	00 
  801a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9b:	e8 2c f2 ff ff       	call   800ccc <sys_page_alloc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	0f 88 d3 00 00 00    	js     801b7d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aad:	89 04 24             	mov    %eax,(%esp)
  801ab0:	e8 fb f4 ff ff       	call   800fb0 <fd2data>
  801ab5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801abe:	00 
  801abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aca:	e8 fd f1 ff ff       	call   800ccc <sys_page_alloc>
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	0f 88 91 00 00 00    	js     801b6a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adc:	89 04 24             	mov    %eax,(%esp)
  801adf:	e8 cc f4 ff ff       	call   800fb0 <fd2data>
  801ae4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801aeb:	00 
  801aec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af7:	00 
  801af8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b03:	e8 23 f2 ff ff       	call   800d2b <sys_page_map>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 4c                	js     801b5a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b0e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b17:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b23:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b31:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b3b:	89 04 24             	mov    %eax,(%esp)
  801b3e:	e8 5d f4 ff ff       	call   800fa0 <fd2num>
  801b43:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b48:	89 04 24             	mov    %eax,(%esp)
  801b4b:	e8 50 f4 ff ff       	call   800fa0 <fd2num>
  801b50:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801b53:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b58:	eb 36                	jmp    801b90 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801b5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b65:	e8 1f f2 ff ff       	call   800d89 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b78:	e8 0c f2 ff ff       	call   800d89 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8b:	e8 f9 f1 ff ff       	call   800d89 <sys_page_unmap>
    err:
	return r;
}
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b95:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b98:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b9b:	89 ec                	mov    %ebp,%esp
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ba5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	89 04 24             	mov    %eax,(%esp)
  801bb2:	e8 87 f4 ff ff       	call   80103e <fd_lookup>
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 15                	js     801bd0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 ea f3 ff ff       	call   800fb0 <fd2data>
	return _pipeisclosed(fd, p);
  801bc6:	89 c2                	mov    %eax,%edx
  801bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcb:	e8 c2 fc ff ff       	call   801892 <_pipeisclosed>
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    
	...

00801be0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    

00801bea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801bf0:	c7 44 24 04 8a 26 80 	movl   $0x80268a,0x4(%esp)
  801bf7:	00 
  801bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfb:	89 04 24             	mov    %eax,(%esp)
  801bfe:	e8 c8 eb ff ff       	call   8007cb <strcpy>
	return 0;
}
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	57                   	push   %edi
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c16:	be 00 00 00 00       	mov    $0x0,%esi
  801c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c1f:	74 43                	je     801c64 <devcons_write+0x5a>
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c2f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801c31:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c34:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801c39:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c40:	03 45 0c             	add    0xc(%ebp),%eax
  801c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c47:	89 3c 24             	mov    %edi,(%esp)
  801c4a:	e8 6d ed ff ff       	call   8009bc <memmove>
		sys_cputs(buf, m);
  801c4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c53:	89 3c 24             	mov    %edi,(%esp)
  801c56:	e8 55 ef ff ff       	call   800bb0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c5b:	01 de                	add    %ebx,%esi
  801c5d:	89 f0                	mov    %esi,%eax
  801c5f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c62:	72 c8                	jb     801c2c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801c64:	89 f0                	mov    %esi,%eax
  801c66:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5f                   	pop    %edi
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    

00801c71 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c80:	75 07                	jne    801c89 <devcons_read+0x18>
  801c82:	eb 31                	jmp    801cb5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801c84:	e8 13 f0 ff ff       	call   800c9c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c90:	e8 4a ef ff ff       	call   800bdf <sys_cgetc>
  801c95:	85 c0                	test   %eax,%eax
  801c97:	74 eb                	je     801c84 <devcons_read+0x13>
  801c99:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 16                	js     801cb5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801c9f:	83 f8 04             	cmp    $0x4,%eax
  801ca2:	74 0c                	je     801cb0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca7:	88 10                	mov    %dl,(%eax)
	return 1;
  801ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cae:	eb 05                	jmp    801cb5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801cc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801cca:	00 
  801ccb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 da ee ff ff       	call   800bb0 <sys_cputs>
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <getchar>:

int
getchar(void)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801cde:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ce5:	00 
  801ce6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ced:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf4:	e8 05 f6 ff ff       	call   8012fe <read>
	if (r < 0)
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 0f                	js     801d0c <getchar+0x34>
		return r;
	if (r < 1)
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	7e 06                	jle    801d07 <getchar+0x2f>
		return -E_EOF;
	return c;
  801d01:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801d05:	eb 05                	jmp    801d0c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801d07:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	89 04 24             	mov    %eax,(%esp)
  801d21:	e8 18 f3 ff ff       	call   80103e <fd_lookup>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 11                	js     801d3b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d33:	39 10                	cmp    %edx,(%eax)
  801d35:	0f 94 c0             	sete   %al
  801d38:	0f b6 c0             	movzbl %al,%eax
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <opencons>:

int
opencons(void)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d46:	89 04 24             	mov    %eax,(%esp)
  801d49:	e8 7d f2 ff ff       	call   800fcb <fd_alloc>
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	78 3c                	js     801d8e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d59:	00 
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d68:	e8 5f ef ff ff       	call   800ccc <sys_page_alloc>
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 1d                	js     801d8e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d71:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 12 f2 ff ff       	call   800fa0 <fd2num>
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801d98:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d9b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801da1:	e8 c6 ee ff ff       	call   800c6c <sys_getenvid>
  801da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da9:	89 54 24 10          	mov    %edx,0x10(%esp)
  801dad:	8b 55 08             	mov    0x8(%ebp),%edx
  801db0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801db4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801db8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbc:	c7 04 24 98 26 80 00 	movl   $0x802698,(%esp)
  801dc3:	e8 e7 e3 ff ff       	call   8001af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801dc8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcf:	89 04 24             	mov    %eax,(%esp)
  801dd2:	e8 77 e3 ff ff       	call   80014e <vcprintf>
	cprintf("\n");
  801dd7:	c7 04 24 83 26 80 00 	movl   $0x802683,(%esp)
  801dde:	e8 cc e3 ff ff       	call   8001af <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801de3:	cc                   	int3   
  801de4:	eb fd                	jmp    801de3 <_panic+0x53>
	...

00801df0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	83 ec 10             	sub    $0x10,%esp
  801df8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801e01:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801e03:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e08:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e0b:	89 04 24             	mov    %eax,(%esp)
  801e0e:	e8 22 f1 ff ff       	call   800f35 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801e13:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801e18:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 0e                	js     801e2f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801e21:	a1 04 40 80 00       	mov    0x804004,%eax
  801e26:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801e29:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801e2c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801e2f:	85 f6                	test   %esi,%esi
  801e31:	74 02                	je     801e35 <ipc_recv+0x45>
		*from_env_store = sender;
  801e33:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801e35:	85 db                	test   %ebx,%ebx
  801e37:	74 02                	je     801e3b <ipc_recv+0x4b>
		*perm_store = perm;
  801e39:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e51:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e54:	85 db                	test   %ebx,%ebx
  801e56:	75 04                	jne    801e5c <ipc_send+0x1a>
  801e58:	85 f6                	test   %esi,%esi
  801e5a:	75 15                	jne    801e71 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e5c:	85 db                	test   %ebx,%ebx
  801e5e:	74 16                	je     801e76 <ipc_send+0x34>
  801e60:	85 f6                	test   %esi,%esi
  801e62:	0f 94 c0             	sete   %al
      pg = 0;
  801e65:	84 c0                	test   %al,%al
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	0f 45 d8             	cmovne %eax,%ebx
  801e6f:	eb 05                	jmp    801e76 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e71:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e76:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e7a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	89 04 24             	mov    %eax,(%esp)
  801e88:	e8 74 f0 ff ff       	call   800f01 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e8d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e90:	75 07                	jne    801e99 <ipc_send+0x57>
           sys_yield();
  801e92:	e8 05 ee ff ff       	call   800c9c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e97:	eb dd                	jmp    801e76 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	90                   	nop
  801e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	74 1c                	je     801ebe <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801ea2:	c7 44 24 08 bc 26 80 	movl   $0x8026bc,0x8(%esp)
  801ea9:	00 
  801eaa:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801eb1:	00 
  801eb2:	c7 04 24 c6 26 80 00 	movl   $0x8026c6,(%esp)
  801eb9:	e8 d2 fe ff ff       	call   801d90 <_panic>
		}
    }
}
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801ecc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801ed1:	39 c8                	cmp    %ecx,%eax
  801ed3:	74 17                	je     801eec <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ed5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801eda:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801edd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ee3:	8b 52 50             	mov    0x50(%edx),%edx
  801ee6:	39 ca                	cmp    %ecx,%edx
  801ee8:	75 14                	jne    801efe <ipc_find_env+0x38>
  801eea:	eb 05                	jmp    801ef1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ef1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ef4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ef9:	8b 40 40             	mov    0x40(%eax),%eax
  801efc:	eb 0e                	jmp    801f0c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801efe:	83 c0 01             	add    $0x1,%eax
  801f01:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f06:	75 d2                	jne    801eda <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f08:	66 b8 00 00          	mov    $0x0,%ax
}
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    
	...

00801f10 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f16:	89 d0                	mov    %edx,%eax
  801f18:	c1 e8 16             	shr    $0x16,%eax
  801f1b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f27:	f6 c1 01             	test   $0x1,%cl
  801f2a:	74 1d                	je     801f49 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f2c:	c1 ea 0c             	shr    $0xc,%edx
  801f2f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f36:	f6 c2 01             	test   $0x1,%dl
  801f39:	74 0e                	je     801f49 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f3b:	c1 ea 0c             	shr    $0xc,%edx
  801f3e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f45:	ef 
  801f46:	0f b7 c0             	movzwl %ax,%eax
}
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    
  801f4b:	00 00                	add    %al,(%eax)
  801f4d:	00 00                	add    %al,(%eax)
	...

00801f50 <__udivdi3>:
  801f50:	83 ec 1c             	sub    $0x1c,%esp
  801f53:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f57:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f5b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f5f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f63:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f67:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f6b:	85 ff                	test   %edi,%edi
  801f6d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f71:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f75:	89 cd                	mov    %ecx,%ebp
  801f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7b:	75 33                	jne    801fb0 <__udivdi3+0x60>
  801f7d:	39 f1                	cmp    %esi,%ecx
  801f7f:	77 57                	ja     801fd8 <__udivdi3+0x88>
  801f81:	85 c9                	test   %ecx,%ecx
  801f83:	75 0b                	jne    801f90 <__udivdi3+0x40>
  801f85:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8a:	31 d2                	xor    %edx,%edx
  801f8c:	f7 f1                	div    %ecx
  801f8e:	89 c1                	mov    %eax,%ecx
  801f90:	89 f0                	mov    %esi,%eax
  801f92:	31 d2                	xor    %edx,%edx
  801f94:	f7 f1                	div    %ecx
  801f96:	89 c6                	mov    %eax,%esi
  801f98:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f9c:	f7 f1                	div    %ecx
  801f9e:	89 f2                	mov    %esi,%edx
  801fa0:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fa4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fa8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801fac:	83 c4 1c             	add    $0x1c,%esp
  801faf:	c3                   	ret    
  801fb0:	31 d2                	xor    %edx,%edx
  801fb2:	31 c0                	xor    %eax,%eax
  801fb4:	39 f7                	cmp    %esi,%edi
  801fb6:	77 e8                	ja     801fa0 <__udivdi3+0x50>
  801fb8:	0f bd cf             	bsr    %edi,%ecx
  801fbb:	83 f1 1f             	xor    $0x1f,%ecx
  801fbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fc2:	75 2c                	jne    801ff0 <__udivdi3+0xa0>
  801fc4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801fc8:	76 04                	jbe    801fce <__udivdi3+0x7e>
  801fca:	39 f7                	cmp    %esi,%edi
  801fcc:	73 d2                	jae    801fa0 <__udivdi3+0x50>
  801fce:	31 d2                	xor    %edx,%edx
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd5:	eb c9                	jmp    801fa0 <__udivdi3+0x50>
  801fd7:	90                   	nop
  801fd8:	89 f2                	mov    %esi,%edx
  801fda:	f7 f1                	div    %ecx
  801fdc:	31 d2                	xor    %edx,%edx
  801fde:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fe2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fe6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801fea:	83 c4 1c             	add    $0x1c,%esp
  801fed:	c3                   	ret    
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ff5:	b8 20 00 00 00       	mov    $0x20,%eax
  801ffa:	89 ea                	mov    %ebp,%edx
  801ffc:	2b 44 24 04          	sub    0x4(%esp),%eax
  802000:	d3 e7                	shl    %cl,%edi
  802002:	89 c1                	mov    %eax,%ecx
  802004:	d3 ea                	shr    %cl,%edx
  802006:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80200b:	09 fa                	or     %edi,%edx
  80200d:	89 f7                	mov    %esi,%edi
  80200f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802013:	89 f2                	mov    %esi,%edx
  802015:	8b 74 24 08          	mov    0x8(%esp),%esi
  802019:	d3 e5                	shl    %cl,%ebp
  80201b:	89 c1                	mov    %eax,%ecx
  80201d:	d3 ef                	shr    %cl,%edi
  80201f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802024:	d3 e2                	shl    %cl,%edx
  802026:	89 c1                	mov    %eax,%ecx
  802028:	d3 ee                	shr    %cl,%esi
  80202a:	09 d6                	or     %edx,%esi
  80202c:	89 fa                	mov    %edi,%edx
  80202e:	89 f0                	mov    %esi,%eax
  802030:	f7 74 24 0c          	divl   0xc(%esp)
  802034:	89 d7                	mov    %edx,%edi
  802036:	89 c6                	mov    %eax,%esi
  802038:	f7 e5                	mul    %ebp
  80203a:	39 d7                	cmp    %edx,%edi
  80203c:	72 22                	jb     802060 <__udivdi3+0x110>
  80203e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802042:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802047:	d3 e5                	shl    %cl,%ebp
  802049:	39 c5                	cmp    %eax,%ebp
  80204b:	73 04                	jae    802051 <__udivdi3+0x101>
  80204d:	39 d7                	cmp    %edx,%edi
  80204f:	74 0f                	je     802060 <__udivdi3+0x110>
  802051:	89 f0                	mov    %esi,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	e9 46 ff ff ff       	jmp    801fa0 <__udivdi3+0x50>
  80205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802060:	8d 46 ff             	lea    -0x1(%esi),%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	8b 74 24 10          	mov    0x10(%esp),%esi
  802069:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80206d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802071:	83 c4 1c             	add    $0x1c,%esp
  802074:	c3                   	ret    
	...

00802080 <__umoddi3>:
  802080:	83 ec 1c             	sub    $0x1c,%esp
  802083:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802087:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80208b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80208f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802093:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802097:	8b 74 24 24          	mov    0x24(%esp),%esi
  80209b:	85 ed                	test   %ebp,%ebp
  80209d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8020a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a5:	89 cf                	mov    %ecx,%edi
  8020a7:	89 04 24             	mov    %eax,(%esp)
  8020aa:	89 f2                	mov    %esi,%edx
  8020ac:	75 1a                	jne    8020c8 <__umoddi3+0x48>
  8020ae:	39 f1                	cmp    %esi,%ecx
  8020b0:	76 4e                	jbe    802100 <__umoddi3+0x80>
  8020b2:	f7 f1                	div    %ecx
  8020b4:	89 d0                	mov    %edx,%eax
  8020b6:	31 d2                	xor    %edx,%edx
  8020b8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020bc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020c0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	c3                   	ret    
  8020c8:	39 f5                	cmp    %esi,%ebp
  8020ca:	77 54                	ja     802120 <__umoddi3+0xa0>
  8020cc:	0f bd c5             	bsr    %ebp,%eax
  8020cf:	83 f0 1f             	xor    $0x1f,%eax
  8020d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d6:	75 60                	jne    802138 <__umoddi3+0xb8>
  8020d8:	3b 0c 24             	cmp    (%esp),%ecx
  8020db:	0f 87 07 01 00 00    	ja     8021e8 <__umoddi3+0x168>
  8020e1:	89 f2                	mov    %esi,%edx
  8020e3:	8b 34 24             	mov    (%esp),%esi
  8020e6:	29 ce                	sub    %ecx,%esi
  8020e8:	19 ea                	sbb    %ebp,%edx
  8020ea:	89 34 24             	mov    %esi,(%esp)
  8020ed:	8b 04 24             	mov    (%esp),%eax
  8020f0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020f4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020f8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020fc:	83 c4 1c             	add    $0x1c,%esp
  8020ff:	c3                   	ret    
  802100:	85 c9                	test   %ecx,%ecx
  802102:	75 0b                	jne    80210f <__umoddi3+0x8f>
  802104:	b8 01 00 00 00       	mov    $0x1,%eax
  802109:	31 d2                	xor    %edx,%edx
  80210b:	f7 f1                	div    %ecx
  80210d:	89 c1                	mov    %eax,%ecx
  80210f:	89 f0                	mov    %esi,%eax
  802111:	31 d2                	xor    %edx,%edx
  802113:	f7 f1                	div    %ecx
  802115:	8b 04 24             	mov    (%esp),%eax
  802118:	f7 f1                	div    %ecx
  80211a:	eb 98                	jmp    8020b4 <__umoddi3+0x34>
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	89 f2                	mov    %esi,%edx
  802122:	8b 74 24 10          	mov    0x10(%esp),%esi
  802126:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80212a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80212e:	83 c4 1c             	add    $0x1c,%esp
  802131:	c3                   	ret    
  802132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802138:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213d:	89 e8                	mov    %ebp,%eax
  80213f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802144:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802148:	89 fa                	mov    %edi,%edx
  80214a:	d3 e0                	shl    %cl,%eax
  80214c:	89 e9                	mov    %ebp,%ecx
  80214e:	d3 ea                	shr    %cl,%edx
  802150:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802155:	09 c2                	or     %eax,%edx
  802157:	8b 44 24 08          	mov    0x8(%esp),%eax
  80215b:	89 14 24             	mov    %edx,(%esp)
  80215e:	89 f2                	mov    %esi,%edx
  802160:	d3 e7                	shl    %cl,%edi
  802162:	89 e9                	mov    %ebp,%ecx
  802164:	d3 ea                	shr    %cl,%edx
  802166:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80216b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80216f:	d3 e6                	shl    %cl,%esi
  802171:	89 e9                	mov    %ebp,%ecx
  802173:	d3 e8                	shr    %cl,%eax
  802175:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80217a:	09 f0                	or     %esi,%eax
  80217c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802180:	f7 34 24             	divl   (%esp)
  802183:	d3 e6                	shl    %cl,%esi
  802185:	89 74 24 08          	mov    %esi,0x8(%esp)
  802189:	89 d6                	mov    %edx,%esi
  80218b:	f7 e7                	mul    %edi
  80218d:	39 d6                	cmp    %edx,%esi
  80218f:	89 c1                	mov    %eax,%ecx
  802191:	89 d7                	mov    %edx,%edi
  802193:	72 3f                	jb     8021d4 <__umoddi3+0x154>
  802195:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802199:	72 35                	jb     8021d0 <__umoddi3+0x150>
  80219b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80219f:	29 c8                	sub    %ecx,%eax
  8021a1:	19 fe                	sbb    %edi,%esi
  8021a3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021a8:	89 f2                	mov    %esi,%edx
  8021aa:	d3 e8                	shr    %cl,%eax
  8021ac:	89 e9                	mov    %ebp,%ecx
  8021ae:	d3 e2                	shl    %cl,%edx
  8021b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021b5:	09 d0                	or     %edx,%eax
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	d3 ea                	shr    %cl,%edx
  8021bb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021bf:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021c3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021c7:	83 c4 1c             	add    $0x1c,%esp
  8021ca:	c3                   	ret    
  8021cb:	90                   	nop
  8021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	39 d6                	cmp    %edx,%esi
  8021d2:	75 c7                	jne    80219b <__umoddi3+0x11b>
  8021d4:	89 d7                	mov    %edx,%edi
  8021d6:	89 c1                	mov    %eax,%ecx
  8021d8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8021dc:	1b 3c 24             	sbb    (%esp),%edi
  8021df:	eb ba                	jmp    80219b <__umoddi3+0x11b>
  8021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e8:	39 f5                	cmp    %esi,%ebp
  8021ea:	0f 82 f1 fe ff ff    	jb     8020e1 <__umoddi3+0x61>
  8021f0:	e9 f8 fe ff ff       	jmp    8020ed <__umoddi3+0x6d>
