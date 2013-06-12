
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  80004e:	e8 7c 01 00 00       	call   8001cf <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 5b 10 00 00       	call   8010b3 <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  800065:	e8 65 01 00 00       	call   8001cf <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 88 26 80 00 	movl   $0x802688,(%esp)
  800073:	e8 57 01 00 00       	call   8001cf <cprintf>
	sys_yield();
  800078:	e8 3f 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  80007d:	e8 3a 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  800082:	e8 35 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  800087:	e8 30 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 27 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  800095:	e8 22 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  80009a:	e8 1d 0c 00 00       	call   800cbc <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 17 0c 00 00       	call   800cbc <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 b0 26 80 00 	movl   $0x8026b0,(%esp)
  8000ac:	e8 1e 01 00 00       	call   8001cf <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 76 0b 00 00       	call   800c2f <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    
	...

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
  8000c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8000cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000d2:	e8 b5 0b 00 00       	call   800c8c <sys_getenvid>
  8000d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e4:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e9:	85 f6                	test   %esi,%esi
  8000eb:	7e 07                	jle    8000f4 <libmain+0x34>
		binaryname = argv[0];
  8000ed:	8b 03                	mov    (%ebx),%eax
  8000ef:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f8:	89 34 24             	mov    %esi,(%esp)
  8000fb:	e8 40 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800100:	e8 0b 00 00 00       	call   800110 <exit>
}
  800105:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800108:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80010b:	89 ec                	mov    %ebp,%esp
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    
	...

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800116:	e8 63 14 00 00       	call   80157e <close_all>
	sys_env_destroy(0);
  80011b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800122:	e8 08 0b 00 00       	call   800c2f <sys_env_destroy>
}
  800127:	c9                   	leave  
  800128:	c3                   	ret    
  800129:	00 00                	add    %al,(%eax)
	...

0080012c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	53                   	push   %ebx
  800130:	83 ec 14             	sub    $0x14,%esp
  800133:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800136:	8b 03                	mov    (%ebx),%eax
  800138:	8b 55 08             	mov    0x8(%ebp),%edx
  80013b:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80013f:	83 c0 01             	add    $0x1,%eax
  800142:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800144:	3d ff 00 00 00       	cmp    $0xff,%eax
  800149:	75 19                	jne    800164 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80014b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800152:	00 
  800153:	8d 43 08             	lea    0x8(%ebx),%eax
  800156:	89 04 24             	mov    %eax,(%esp)
  800159:	e8 72 0a 00 00       	call   800bd0 <sys_cputs>
		b->idx = 0;
  80015e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800164:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800168:	83 c4 14             	add    $0x14,%esp
  80016b:	5b                   	pop    %ebx
  80016c:	5d                   	pop    %ebp
  80016d:	c3                   	ret    

0080016e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800177:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017e:	00 00 00 
	b.cnt = 0;
  800181:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800188:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	8b 45 08             	mov    0x8(%ebp),%eax
  800195:	89 44 24 08          	mov    %eax,0x8(%esp)
  800199:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	c7 04 24 2c 01 80 00 	movl   $0x80012c,(%esp)
  8001aa:	e8 9b 01 00 00       	call   80034a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001af:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bf:	89 04 24             	mov    %eax,(%esp)
  8001c2:	e8 09 0a 00 00       	call   800bd0 <sys_cputs>

	return b.cnt;
}
  8001c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	89 04 24             	mov    %eax,(%esp)
  8001e2:	e8 87 ff ff ff       	call   80016e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    
  8001e9:	00 00                	add    %al,(%eax)
  8001eb:	00 00                	add    %al,(%eax)
  8001ed:	00 00                	add    %al,(%eax)
	...

008001f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 3c             	sub    $0x3c,%esp
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 d7                	mov    %edx,%edi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80020d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800218:	72 11                	jb     80022b <printnum+0x3b>
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800220:	76 09                	jbe    80022b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800222:	83 eb 01             	sub    $0x1,%ebx
  800225:	85 db                	test   %ebx,%ebx
  800227:	7f 51                	jg     80027a <printnum+0x8a>
  800229:	eb 5e                	jmp    800289 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80022b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80022f:	83 eb 01             	sub    $0x1,%ebx
  800232:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800236:	8b 45 10             	mov    0x10(%ebp),%eax
  800239:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800241:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800245:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80024c:	00 
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025a:	e8 41 21 00 00       	call   8023a0 <__udivdi3>
  80025f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800263:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800267:	89 04 24             	mov    %eax,(%esp)
  80026a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80026e:	89 fa                	mov    %edi,%edx
  800270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800273:	e8 78 ff ff ff       	call   8001f0 <printnum>
  800278:	eb 0f                	jmp    800289 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80027a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80027e:	89 34 24             	mov    %esi,(%esp)
  800281:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	75 f1                	jne    80027a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800289:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80028d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800291:	8b 45 10             	mov    0x10(%ebp),%eax
  800294:	89 44 24 08          	mov    %eax,0x8(%esp)
  800298:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80029f:	00 
  8002a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a3:	89 04 24             	mov    %eax,(%esp)
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ad:	e8 1e 22 00 00       	call   8024d0 <__umoddi3>
  8002b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b6:	0f be 80 00 27 80 00 	movsbl 0x802700(%eax),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002c3:	83 c4 3c             	add    $0x3c,%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002ce:	83 fa 01             	cmp    $0x1,%edx
  8002d1:	7e 0e                	jle    8002e1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d8:	89 08                	mov    %ecx,(%eax)
  8002da:	8b 02                	mov    (%edx),%eax
  8002dc:	8b 52 04             	mov    0x4(%edx),%edx
  8002df:	eb 22                	jmp    800303 <getuint+0x38>
	else if (lflag)
  8002e1:	85 d2                	test   %edx,%edx
  8002e3:	74 10                	je     8002f5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e5:	8b 10                	mov    (%eax),%edx
  8002e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ea:	89 08                	mov    %ecx,(%eax)
  8002ec:	8b 02                	mov    (%edx),%eax
  8002ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f3:	eb 0e                	jmp    800303 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f5:	8b 10                	mov    (%eax),%edx
  8002f7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 02                	mov    (%edx),%eax
  8002fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80030f:	8b 10                	mov    (%eax),%edx
  800311:	3b 50 04             	cmp    0x4(%eax),%edx
  800314:	73 0a                	jae    800320 <sprintputch+0x1b>
		*b->buf++ = ch;
  800316:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800319:	88 0a                	mov    %cl,(%edx)
  80031b:	83 c2 01             	add    $0x1,%edx
  80031e:	89 10                	mov    %edx,(%eax)
}
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800328:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	89 44 24 08          	mov    %eax,0x8(%esp)
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	89 04 24             	mov    %eax,(%esp)
  800343:	e8 02 00 00 00       	call   80034a <vprintfmt>
	va_end(ap);
}
  800348:	c9                   	leave  
  800349:	c3                   	ret    

0080034a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
  800350:	83 ec 4c             	sub    $0x4c,%esp
  800353:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800356:	8b 75 10             	mov    0x10(%ebp),%esi
  800359:	eb 12                	jmp    80036d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80035b:	85 c0                	test   %eax,%eax
  80035d:	0f 84 a9 03 00 00    	je     80070c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800363:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80036d:	0f b6 06             	movzbl (%esi),%eax
  800370:	83 c6 01             	add    $0x1,%esi
  800373:	83 f8 25             	cmp    $0x25,%eax
  800376:	75 e3                	jne    80035b <vprintfmt+0x11>
  800378:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80037c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800383:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80038f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800394:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800397:	eb 2b                	jmp    8003c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80039c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003a0:	eb 22                	jmp    8003c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003a5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003a9:	eb 19                	jmp    8003c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8003ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003b5:	eb 0d                	jmp    8003c4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	0f b6 06             	movzbl (%esi),%eax
  8003c7:	0f b6 d0             	movzbl %al,%edx
  8003ca:	8d 7e 01             	lea    0x1(%esi),%edi
  8003cd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8003d0:	83 e8 23             	sub    $0x23,%eax
  8003d3:	3c 55                	cmp    $0x55,%al
  8003d5:	0f 87 0b 03 00 00    	ja     8006e6 <vprintfmt+0x39c>
  8003db:	0f b6 c0             	movzbl %al,%eax
  8003de:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e5:	83 ea 30             	sub    $0x30,%edx
  8003e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8003eb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003ef:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8003f5:	83 fa 09             	cmp    $0x9,%edx
  8003f8:	77 4a                	ja     800444 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003fd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800400:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800403:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800407:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80040a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80040d:	83 fa 09             	cmp    $0x9,%edx
  800410:	76 eb                	jbe    8003fd <vprintfmt+0xb3>
  800412:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800415:	eb 2d                	jmp    800444 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	89 55 14             	mov    %edx,0x14(%ebp)
  800420:	8b 00                	mov    (%eax),%eax
  800422:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800428:	eb 1a                	jmp    800444 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80042d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800431:	79 91                	jns    8003c4 <vprintfmt+0x7a>
  800433:	e9 73 ff ff ff       	jmp    8003ab <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80043b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800442:	eb 80                	jmp    8003c4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800444:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800448:	0f 89 76 ff ff ff    	jns    8003c4 <vprintfmt+0x7a>
  80044e:	e9 64 ff ff ff       	jmp    8003b7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800453:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800459:	e9 66 ff ff ff       	jmp    8003c4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8d 50 04             	lea    0x4(%eax),%edx
  800464:	89 55 14             	mov    %edx,0x14(%ebp)
  800467:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	89 04 24             	mov    %eax,(%esp)
  800470:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800473:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800476:	e9 f2 fe ff ff       	jmp    80036d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	8d 50 04             	lea    0x4(%eax),%edx
  800481:	89 55 14             	mov    %edx,0x14(%ebp)
  800484:	8b 00                	mov    (%eax),%eax
  800486:	89 c2                	mov    %eax,%edx
  800488:	c1 fa 1f             	sar    $0x1f,%edx
  80048b:	31 d0                	xor    %edx,%eax
  80048d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048f:	83 f8 0f             	cmp    $0xf,%eax
  800492:	7f 0b                	jg     80049f <vprintfmt+0x155>
  800494:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80049b:	85 d2                	test   %edx,%edx
  80049d:	75 23                	jne    8004c2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80049f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a3:	c7 44 24 08 18 27 80 	movl   $0x802718,0x8(%esp)
  8004aa:	00 
  8004ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004b2:	89 3c 24             	mov    %edi,(%esp)
  8004b5:	e8 68 fe ff ff       	call   800322 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004bd:	e9 ab fe ff ff       	jmp    80036d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8004c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004c6:	c7 44 24 08 71 2c 80 	movl   $0x802c71,0x8(%esp)
  8004cd:	00 
  8004ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004d5:	89 3c 24             	mov    %edi,(%esp)
  8004d8:	e8 45 fe ff ff       	call   800322 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8004e0:	e9 88 fe ff ff       	jmp    80036d <vprintfmt+0x23>
  8004e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	8d 50 04             	lea    0x4(%eax),%edx
  8004f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004f9:	85 f6                	test   %esi,%esi
  8004fb:	ba 11 27 80 00       	mov    $0x802711,%edx
  800500:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800503:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800507:	7e 06                	jle    80050f <vprintfmt+0x1c5>
  800509:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80050d:	75 10                	jne    80051f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	0f be 06             	movsbl (%esi),%eax
  800512:	83 c6 01             	add    $0x1,%esi
  800515:	85 c0                	test   %eax,%eax
  800517:	0f 85 86 00 00 00    	jne    8005a3 <vprintfmt+0x259>
  80051d:	eb 76                	jmp    800595 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80051f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800523:	89 34 24             	mov    %esi,(%esp)
  800526:	e8 90 02 00 00       	call   8007bb <strnlen>
  80052b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80052e:	29 c2                	sub    %eax,%edx
  800530:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800533:	85 d2                	test   %edx,%edx
  800535:	7e d8                	jle    80050f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800537:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80053b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80053e:	89 d6                	mov    %edx,%esi
  800540:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800543:	89 c7                	mov    %eax,%edi
  800545:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800549:	89 3c 24             	mov    %edi,(%esp)
  80054c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054f:	83 ee 01             	sub    $0x1,%esi
  800552:	75 f1                	jne    800545 <vprintfmt+0x1fb>
  800554:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800557:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80055a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80055d:	eb b0                	jmp    80050f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80055f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800563:	74 18                	je     80057d <vprintfmt+0x233>
  800565:	8d 50 e0             	lea    -0x20(%eax),%edx
  800568:	83 fa 5e             	cmp    $0x5e,%edx
  80056b:	76 10                	jbe    80057d <vprintfmt+0x233>
					putch('?', putdat);
  80056d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800571:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800578:	ff 55 08             	call   *0x8(%ebp)
  80057b:	eb 0a                	jmp    800587 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80057d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800581:	89 04 24             	mov    %eax,(%esp)
  800584:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800587:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80058b:	0f be 06             	movsbl (%esi),%eax
  80058e:	83 c6 01             	add    $0x1,%esi
  800591:	85 c0                	test   %eax,%eax
  800593:	75 0e                	jne    8005a3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800598:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059c:	7f 16                	jg     8005b4 <vprintfmt+0x26a>
  80059e:	e9 ca fd ff ff       	jmp    80036d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a3:	85 ff                	test   %edi,%edi
  8005a5:	78 b8                	js     80055f <vprintfmt+0x215>
  8005a7:	83 ef 01             	sub    $0x1,%edi
  8005aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8005b0:	79 ad                	jns    80055f <vprintfmt+0x215>
  8005b2:	eb e1                	jmp    800595 <vprintfmt+0x24b>
  8005b4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005b7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005c5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005c7:	83 ee 01             	sub    $0x1,%esi
  8005ca:	75 ee                	jne    8005ba <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005cf:	e9 99 fd ff ff       	jmp    80036d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005d4:	83 f9 01             	cmp    $0x1,%ecx
  8005d7:	7e 10                	jle    8005e9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 50 08             	lea    0x8(%eax),%edx
  8005df:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e2:	8b 30                	mov    (%eax),%esi
  8005e4:	8b 78 04             	mov    0x4(%eax),%edi
  8005e7:	eb 26                	jmp    80060f <vprintfmt+0x2c5>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 12                	je     8005ff <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 50 04             	lea    0x4(%eax),%edx
  8005f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f6:	8b 30                	mov    (%eax),%esi
  8005f8:	89 f7                	mov    %esi,%edi
  8005fa:	c1 ff 1f             	sar    $0x1f,%edi
  8005fd:	eb 10                	jmp    80060f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 50 04             	lea    0x4(%eax),%edx
  800605:	89 55 14             	mov    %edx,0x14(%ebp)
  800608:	8b 30                	mov    (%eax),%esi
  80060a:	89 f7                	mov    %esi,%edi
  80060c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80060f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800614:	85 ff                	test   %edi,%edi
  800616:	0f 89 8c 00 00 00    	jns    8006a8 <vprintfmt+0x35e>
				putch('-', putdat);
  80061c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800620:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800627:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80062a:	f7 de                	neg    %esi
  80062c:	83 d7 00             	adc    $0x0,%edi
  80062f:	f7 df                	neg    %edi
			}
			base = 10;
  800631:	b8 0a 00 00 00       	mov    $0xa,%eax
  800636:	eb 70                	jmp    8006a8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800638:	89 ca                	mov    %ecx,%edx
  80063a:	8d 45 14             	lea    0x14(%ebp),%eax
  80063d:	e8 89 fc ff ff       	call   8002cb <getuint>
  800642:	89 c6                	mov    %eax,%esi
  800644:	89 d7                	mov    %edx,%edi
			base = 10;
  800646:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80064b:	eb 5b                	jmp    8006a8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80064d:	89 ca                	mov    %ecx,%edx
  80064f:	8d 45 14             	lea    0x14(%ebp),%eax
  800652:	e8 74 fc ff ff       	call   8002cb <getuint>
  800657:	89 c6                	mov    %eax,%esi
  800659:	89 d7                	mov    %edx,%edi
			base = 8;
  80065b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800660:	eb 46                	jmp    8006a8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800662:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800666:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80066d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800670:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800674:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80067b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 50 04             	lea    0x4(%eax),%edx
  800684:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800687:	8b 30                	mov    (%eax),%esi
  800689:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80068e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800693:	eb 13                	jmp    8006a8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800695:	89 ca                	mov    %ecx,%edx
  800697:	8d 45 14             	lea    0x14(%ebp),%eax
  80069a:	e8 2c fc ff ff       	call   8002cb <getuint>
  80069f:	89 c6                	mov    %eax,%esi
  8006a1:	89 d7                	mov    %edx,%edi
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8006ac:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006bb:	89 34 24             	mov    %esi,(%esp)
  8006be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c2:	89 da                	mov    %ebx,%edx
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	e8 24 fb ff ff       	call   8001f0 <printnum>
			break;
  8006cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006cf:	e9 99 fc ff ff       	jmp    80036d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006d8:	89 14 24             	mov    %edx,(%esp)
  8006db:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006de:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006e1:	e9 87 fc ff ff       	jmp    80036d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006f1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006f8:	0f 84 6f fc ff ff    	je     80036d <vprintfmt+0x23>
  8006fe:	83 ee 01             	sub    $0x1,%esi
  800701:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800705:	75 f7                	jne    8006fe <vprintfmt+0x3b4>
  800707:	e9 61 fc ff ff       	jmp    80036d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80070c:	83 c4 4c             	add    $0x4c,%esp
  80070f:	5b                   	pop    %ebx
  800710:	5e                   	pop    %esi
  800711:	5f                   	pop    %edi
  800712:	5d                   	pop    %ebp
  800713:	c3                   	ret    

00800714 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 28             	sub    $0x28,%esp
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800720:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800723:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800727:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800731:	85 c0                	test   %eax,%eax
  800733:	74 30                	je     800765 <vsnprintf+0x51>
  800735:	85 d2                	test   %edx,%edx
  800737:	7e 2c                	jle    800765 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800740:	8b 45 10             	mov    0x10(%ebp),%eax
  800743:	89 44 24 08          	mov    %eax,0x8(%esp)
  800747:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80074a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074e:	c7 04 24 05 03 80 00 	movl   $0x800305,(%esp)
  800755:	e8 f0 fb ff ff       	call   80034a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80075a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800763:	eb 05                	jmp    80076a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800775:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800779:	8b 45 10             	mov    0x10(%ebp),%eax
  80077c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800780:	8b 45 0c             	mov    0xc(%ebp),%eax
  800783:	89 44 24 04          	mov    %eax,0x4(%esp)
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 04 24             	mov    %eax,(%esp)
  80078d:	e8 82 ff ff ff       	call   800714 <vsnprintf>
	va_end(ap);

	return rc;
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    
	...

008007a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8007ae:	74 09                	je     8007b9 <strlen+0x19>
		n++;
  8007b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b7:	75 f7                	jne    8007b0 <strlen+0x10>
		n++;
	return n;
}
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	85 c9                	test   %ecx,%ecx
  8007cc:	74 1a                	je     8007e8 <strnlen+0x2d>
  8007ce:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007d1:	74 15                	je     8007e8 <strnlen+0x2d>
  8007d3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8007d8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007da:	39 ca                	cmp    %ecx,%edx
  8007dc:	74 0a                	je     8007e8 <strnlen+0x2d>
  8007de:	83 c2 01             	add    $0x1,%edx
  8007e1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8007e6:	75 f0                	jne    8007d8 <strnlen+0x1d>
		n++;
	return n;
}
  8007e8:	5b                   	pop    %ebx
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007fe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800801:	83 c2 01             	add    $0x1,%edx
  800804:	84 c9                	test   %cl,%cl
  800806:	75 f2                	jne    8007fa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800808:	5b                   	pop    %ebx
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	53                   	push   %ebx
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800815:	89 1c 24             	mov    %ebx,(%esp)
  800818:	e8 83 ff ff ff       	call   8007a0 <strlen>
	strcpy(dst + len, src);
  80081d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800820:	89 54 24 04          	mov    %edx,0x4(%esp)
  800824:	01 d8                	add    %ebx,%eax
  800826:	89 04 24             	mov    %eax,(%esp)
  800829:	e8 bd ff ff ff       	call   8007eb <strcpy>
	return dst;
}
  80082e:	89 d8                	mov    %ebx,%eax
  800830:	83 c4 08             	add    $0x8,%esp
  800833:	5b                   	pop    %ebx
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	56                   	push   %esi
  80083a:	53                   	push   %ebx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800841:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800844:	85 f6                	test   %esi,%esi
  800846:	74 18                	je     800860 <strncpy+0x2a>
  800848:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80084d:	0f b6 1a             	movzbl (%edx),%ebx
  800850:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800853:	80 3a 01             	cmpb   $0x1,(%edx)
  800856:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800859:	83 c1 01             	add    $0x1,%ecx
  80085c:	39 f1                	cmp    %esi,%ecx
  80085e:	75 ed                	jne    80084d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	57                   	push   %edi
  800868:	56                   	push   %esi
  800869:	53                   	push   %ebx
  80086a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80086d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800870:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	89 f8                	mov    %edi,%eax
  800875:	85 f6                	test   %esi,%esi
  800877:	74 2b                	je     8008a4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800879:	83 fe 01             	cmp    $0x1,%esi
  80087c:	74 23                	je     8008a1 <strlcpy+0x3d>
  80087e:	0f b6 0b             	movzbl (%ebx),%ecx
  800881:	84 c9                	test   %cl,%cl
  800883:	74 1c                	je     8008a1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800885:	83 ee 02             	sub    $0x2,%esi
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80088d:	88 08                	mov    %cl,(%eax)
  80088f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800892:	39 f2                	cmp    %esi,%edx
  800894:	74 0b                	je     8008a1 <strlcpy+0x3d>
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80089d:	84 c9                	test   %cl,%cl
  80089f:	75 ec                	jne    80088d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8008a1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008a4:	29 f8                	sub    %edi,%eax
}
  8008a6:	5b                   	pop    %ebx
  8008a7:	5e                   	pop    %esi
  8008a8:	5f                   	pop    %edi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b4:	0f b6 01             	movzbl (%ecx),%eax
  8008b7:	84 c0                	test   %al,%al
  8008b9:	74 16                	je     8008d1 <strcmp+0x26>
  8008bb:	3a 02                	cmp    (%edx),%al
  8008bd:	75 12                	jne    8008d1 <strcmp+0x26>
		p++, q++;
  8008bf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008c2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8008c6:	84 c0                	test   %al,%al
  8008c8:	74 07                	je     8008d1 <strcmp+0x26>
  8008ca:	83 c1 01             	add    $0x1,%ecx
  8008cd:	3a 02                	cmp    (%edx),%al
  8008cf:	74 ee                	je     8008bf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d1:	0f b6 c0             	movzbl %al,%eax
  8008d4:	0f b6 12             	movzbl (%edx),%edx
  8008d7:	29 d0                	sub    %edx,%eax
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008e5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008ed:	85 d2                	test   %edx,%edx
  8008ef:	74 28                	je     800919 <strncmp+0x3e>
  8008f1:	0f b6 01             	movzbl (%ecx),%eax
  8008f4:	84 c0                	test   %al,%al
  8008f6:	74 24                	je     80091c <strncmp+0x41>
  8008f8:	3a 03                	cmp    (%ebx),%al
  8008fa:	75 20                	jne    80091c <strncmp+0x41>
  8008fc:	83 ea 01             	sub    $0x1,%edx
  8008ff:	74 13                	je     800914 <strncmp+0x39>
		n--, p++, q++;
  800901:	83 c1 01             	add    $0x1,%ecx
  800904:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800907:	0f b6 01             	movzbl (%ecx),%eax
  80090a:	84 c0                	test   %al,%al
  80090c:	74 0e                	je     80091c <strncmp+0x41>
  80090e:	3a 03                	cmp    (%ebx),%al
  800910:	74 ea                	je     8008fc <strncmp+0x21>
  800912:	eb 08                	jmp    80091c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091c:	0f b6 01             	movzbl (%ecx),%eax
  80091f:	0f b6 13             	movzbl (%ebx),%edx
  800922:	29 d0                	sub    %edx,%eax
  800924:	eb f3                	jmp    800919 <strncmp+0x3e>

00800926 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	0f b6 10             	movzbl (%eax),%edx
  800933:	84 d2                	test   %dl,%dl
  800935:	74 1c                	je     800953 <strchr+0x2d>
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	75 09                	jne    800944 <strchr+0x1e>
  80093b:	eb 1b                	jmp    800958 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80093d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800940:	38 ca                	cmp    %cl,%dl
  800942:	74 14                	je     800958 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800944:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800948:	84 d2                	test   %dl,%dl
  80094a:	75 f1                	jne    80093d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80094c:	b8 00 00 00 00       	mov    $0x0,%eax
  800951:	eb 05                	jmp    800958 <strchr+0x32>
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800964:	0f b6 10             	movzbl (%eax),%edx
  800967:	84 d2                	test   %dl,%dl
  800969:	74 14                	je     80097f <strfind+0x25>
		if (*s == c)
  80096b:	38 ca                	cmp    %cl,%dl
  80096d:	75 06                	jne    800975 <strfind+0x1b>
  80096f:	eb 0e                	jmp    80097f <strfind+0x25>
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 0a                	je     80097f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800975:	83 c0 01             	add    $0x1,%eax
  800978:	0f b6 10             	movzbl (%eax),%edx
  80097b:	84 d2                	test   %dl,%dl
  80097d:	75 f2                	jne    800971 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80098a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80098d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800990:	8b 7d 08             	mov    0x8(%ebp),%edi
  800993:	8b 45 0c             	mov    0xc(%ebp),%eax
  800996:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800999:	85 c9                	test   %ecx,%ecx
  80099b:	74 30                	je     8009cd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a3:	75 25                	jne    8009ca <memset+0x49>
  8009a5:	f6 c1 03             	test   $0x3,%cl
  8009a8:	75 20                	jne    8009ca <memset+0x49>
		c &= 0xFF;
  8009aa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ad:	89 d3                	mov    %edx,%ebx
  8009af:	c1 e3 08             	shl    $0x8,%ebx
  8009b2:	89 d6                	mov    %edx,%esi
  8009b4:	c1 e6 18             	shl    $0x18,%esi
  8009b7:	89 d0                	mov    %edx,%eax
  8009b9:	c1 e0 10             	shl    $0x10,%eax
  8009bc:	09 f0                	or     %esi,%eax
  8009be:	09 d0                	or     %edx,%eax
  8009c0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009c5:	fc                   	cld    
  8009c6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c8:	eb 03                	jmp    8009cd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ca:	fc                   	cld    
  8009cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cd:	89 f8                	mov    %edi,%eax
  8009cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009d8:	89 ec                	mov    %ebp,%esp
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f1:	39 c6                	cmp    %eax,%esi
  8009f3:	73 36                	jae    800a2b <memmove+0x4f>
  8009f5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f8:	39 d0                	cmp    %edx,%eax
  8009fa:	73 2f                	jae    800a2b <memmove+0x4f>
		s += n;
		d += n;
  8009fc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	f6 c2 03             	test   $0x3,%dl
  800a02:	75 1b                	jne    800a1f <memmove+0x43>
  800a04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0a:	75 13                	jne    800a1f <memmove+0x43>
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	75 0e                	jne    800a1f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a11:	83 ef 04             	sub    $0x4,%edi
  800a14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a1a:	fd                   	std    
  800a1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1d:	eb 09                	jmp    800a28 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1f:	83 ef 01             	sub    $0x1,%edi
  800a22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a25:	fd                   	std    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a28:	fc                   	cld    
  800a29:	eb 20                	jmp    800a4b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a31:	75 13                	jne    800a46 <memmove+0x6a>
  800a33:	a8 03                	test   $0x3,%al
  800a35:	75 0f                	jne    800a46 <memmove+0x6a>
  800a37:	f6 c1 03             	test   $0x3,%cl
  800a3a:	75 0a                	jne    800a46 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a3f:	89 c7                	mov    %eax,%edi
  800a41:	fc                   	cld    
  800a42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a44:	eb 05                	jmp    800a4b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a46:	89 c7                	mov    %eax,%edi
  800a48:	fc                   	cld    
  800a49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a51:	89 ec                	mov    %ebp,%esp
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	89 04 24             	mov    %eax,(%esp)
  800a6f:	e8 68 ff ff ff       	call   8009dc <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a82:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	85 ff                	test   %edi,%edi
  800a8c:	74 37                	je     800ac5 <memcmp+0x4f>
		if (*s1 != *s2)
  800a8e:	0f b6 03             	movzbl (%ebx),%eax
  800a91:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a94:	83 ef 01             	sub    $0x1,%edi
  800a97:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800a9c:	38 c8                	cmp    %cl,%al
  800a9e:	74 1c                	je     800abc <memcmp+0x46>
  800aa0:	eb 10                	jmp    800ab2 <memcmp+0x3c>
  800aa2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800aa7:	83 c2 01             	add    $0x1,%edx
  800aaa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800aae:	38 c8                	cmp    %cl,%al
  800ab0:	74 0a                	je     800abc <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800ab2:	0f b6 c0             	movzbl %al,%eax
  800ab5:	0f b6 c9             	movzbl %cl,%ecx
  800ab8:	29 c8                	sub    %ecx,%eax
  800aba:	eb 09                	jmp    800ac5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abc:	39 fa                	cmp    %edi,%edx
  800abe:	75 e2                	jne    800aa2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5f                   	pop    %edi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad5:	39 d0                	cmp    %edx,%eax
  800ad7:	73 19                	jae    800af2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800add:	38 08                	cmp    %cl,(%eax)
  800adf:	75 06                	jne    800ae7 <memfind+0x1d>
  800ae1:	eb 0f                	jmp    800af2 <memfind+0x28>
  800ae3:	38 08                	cmp    %cl,(%eax)
  800ae5:	74 0b                	je     800af2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae7:	83 c0 01             	add    $0x1,%eax
  800aea:	39 d0                	cmp    %edx,%eax
  800aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800af0:	75 f1                	jne    800ae3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 55 08             	mov    0x8(%ebp),%edx
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	0f b6 02             	movzbl (%edx),%eax
  800b03:	3c 20                	cmp    $0x20,%al
  800b05:	74 04                	je     800b0b <strtol+0x17>
  800b07:	3c 09                	cmp    $0x9,%al
  800b09:	75 0e                	jne    800b19 <strtol+0x25>
		s++;
  800b0b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0e:	0f b6 02             	movzbl (%edx),%eax
  800b11:	3c 20                	cmp    $0x20,%al
  800b13:	74 f6                	je     800b0b <strtol+0x17>
  800b15:	3c 09                	cmp    $0x9,%al
  800b17:	74 f2                	je     800b0b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b19:	3c 2b                	cmp    $0x2b,%al
  800b1b:	75 0a                	jne    800b27 <strtol+0x33>
		s++;
  800b1d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
  800b25:	eb 10                	jmp    800b37 <strtol+0x43>
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b2c:	3c 2d                	cmp    $0x2d,%al
  800b2e:	75 07                	jne    800b37 <strtol+0x43>
		s++, neg = 1;
  800b30:	83 c2 01             	add    $0x1,%edx
  800b33:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b37:	85 db                	test   %ebx,%ebx
  800b39:	0f 94 c0             	sete   %al
  800b3c:	74 05                	je     800b43 <strtol+0x4f>
  800b3e:	83 fb 10             	cmp    $0x10,%ebx
  800b41:	75 15                	jne    800b58 <strtol+0x64>
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 10                	jne    800b58 <strtol+0x64>
  800b48:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b4c:	75 0a                	jne    800b58 <strtol+0x64>
		s += 2, base = 16;
  800b4e:	83 c2 02             	add    $0x2,%edx
  800b51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b56:	eb 13                	jmp    800b6b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b58:	84 c0                	test   %al,%al
  800b5a:	74 0f                	je     800b6b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b61:	80 3a 30             	cmpb   $0x30,(%edx)
  800b64:	75 05                	jne    800b6b <strtol+0x77>
		s++, base = 8;
  800b66:	83 c2 01             	add    $0x1,%edx
  800b69:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b72:	0f b6 0a             	movzbl (%edx),%ecx
  800b75:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b78:	80 fb 09             	cmp    $0x9,%bl
  800b7b:	77 08                	ja     800b85 <strtol+0x91>
			dig = *s - '0';
  800b7d:	0f be c9             	movsbl %cl,%ecx
  800b80:	83 e9 30             	sub    $0x30,%ecx
  800b83:	eb 1e                	jmp    800ba3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800b85:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800b88:	80 fb 19             	cmp    $0x19,%bl
  800b8b:	77 08                	ja     800b95 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800b8d:	0f be c9             	movsbl %cl,%ecx
  800b90:	83 e9 57             	sub    $0x57,%ecx
  800b93:	eb 0e                	jmp    800ba3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800b95:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800b98:	80 fb 19             	cmp    $0x19,%bl
  800b9b:	77 14                	ja     800bb1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b9d:	0f be c9             	movsbl %cl,%ecx
  800ba0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ba3:	39 f1                	cmp    %esi,%ecx
  800ba5:	7d 0e                	jge    800bb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	0f af c6             	imul   %esi,%eax
  800bad:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800baf:	eb c1                	jmp    800b72 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800bb1:	89 c1                	mov    %eax,%ecx
  800bb3:	eb 02                	jmp    800bb7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bb5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbb:	74 05                	je     800bc2 <strtol+0xce>
		*endptr = (char *) s;
  800bbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bc0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bc2:	89 ca                	mov    %ecx,%edx
  800bc4:	f7 da                	neg    %edx
  800bc6:	85 ff                	test   %edi,%edi
  800bc8:	0f 45 c2             	cmovne %edx,%eax
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bea:	89 c3                	mov    %eax,%ebx
  800bec:	89 c7                	mov    %eax,%edi
  800bee:	89 c6                	mov    %eax,%esi
  800bf0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bf5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bf8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bfb:	89 ec                	mov    %ebp,%esp
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_cgetc>:

int
sys_cgetc(void)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 0c             	sub    $0xc,%esp
  800c05:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c08:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c0b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c13:	b8 01 00 00 00       	mov    $0x1,%eax
  800c18:	89 d1                	mov    %edx,%ecx
  800c1a:	89 d3                	mov    %edx,%ebx
  800c1c:	89 d7                	mov    %edx,%edi
  800c1e:	89 d6                	mov    %edx,%esi
  800c20:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c25:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c2b:	89 ec                	mov    %ebp,%esp
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 38             	sub    $0x38,%esp
  800c35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c38:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c3b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	89 cb                	mov    %ecx,%ebx
  800c4d:	89 cf                	mov    %ecx,%edi
  800c4f:	89 ce                	mov    %ecx,%esi
  800c51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7e 28                	jle    800c7f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c62:	00 
  800c63:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c72:	00 
  800c73:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800c7a:	e8 d1 14 00 00       	call   802150 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c88:	89 ec                	mov    %ebp,%esp
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800caf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cb8:	89 ec                	mov    %ebp,%esp
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_yield>:

void
sys_yield(void)
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
  800cd0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cdf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ce8:	89 ec                	mov    %ebp,%esp
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 38             	sub    $0x38,%esp
  800cf2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cf8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfb:	be 00 00 00 00       	mov    $0x0,%esi
  800d00:	b8 04 00 00 00       	mov    $0x4,%eax
  800d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	89 f7                	mov    %esi,%edi
  800d10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7e 28                	jle    800d3e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d21:	00 
  800d22:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800d29:	00 
  800d2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d31:	00 
  800d32:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800d39:	e8 12 14 00 00       	call   802150 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d41:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d44:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d47:	89 ec                	mov    %ebp,%esp
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 38             	sub    $0x38,%esp
  800d51:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d54:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d57:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7e 28                	jle    800d9c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d78:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d7f:	00 
  800d80:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800d87:	00 
  800d88:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8f:	00 
  800d90:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800d97:	e8 b4 13 00 00       	call   802150 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d9f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da5:	89 ec                	mov    %ebp,%esp
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 38             	sub    $0x38,%esp
  800daf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbd:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7e 28                	jle    800dfa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ddd:	00 
  800dde:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800de5:	00 
  800de6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ded:	00 
  800dee:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800df5:	e8 56 13 00 00       	call   802150 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dfd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e00:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e03:	89 ec                	mov    %ebp,%esp
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 38             	sub    $0x38,%esp
  800e0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e13:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7e 28                	jle    800e58 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e3b:	00 
  800e3c:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800e43:	00 
  800e44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4b:	00 
  800e4c:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800e53:	e8 f8 12 00 00       	call   802150 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e5b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e5e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e61:	89 ec                	mov    %ebp,%esp
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 38             	sub    $0x38,%esp
  800e6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e71:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7e 28                	jle    800eb6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e92:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e99:	00 
  800e9a:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800ea1:	00 
  800ea2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea9:	00 
  800eaa:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800eb1:	e8 9a 12 00 00       	call   802150 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ebc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ebf:	89 ec                	mov    %ebp,%esp
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 38             	sub    $0x38,%esp
  800ec9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ecc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ecf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7e 28                	jle    800f14 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eec:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef7:	00 
  800ef8:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800eff:	00 
  800f00:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f07:	00 
  800f08:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800f0f:	e8 3c 12 00 00       	call   802150 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f14:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f17:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f1d:	89 ec                	mov    %ebp,%esp
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f2a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f2d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f30:	be 00 00 00 00       	mov    $0x0,%esi
  800f35:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f51:	89 ec                	mov    %ebp,%esp
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 38             	sub    $0x38,%esp
  800f5b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f61:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f69:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 cb                	mov    %ecx,%ebx
  800f73:	89 cf                	mov    %ecx,%edi
  800f75:	89 ce                	mov    %ecx,%esi
  800f77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7e 28                	jle    800fa5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f81:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f88:	00 
  800f89:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800fa0:	e8 ab 11 00 00       	call   802150 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fae:	89 ec                	mov    %ebp,%esp
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    
	...

00800fb4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 24             	sub    $0x24,%esp
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fbe:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800fc0:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fc4:	74 21                	je     800fe7 <pgfault+0x33>
  800fc6:	89 d8                	mov    %ebx,%eax
  800fc8:	c1 e8 16             	shr    $0x16,%eax
  800fcb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd2:	a8 01                	test   $0x1,%al
  800fd4:	74 11                	je     800fe7 <pgfault+0x33>
  800fd6:	89 d8                	mov    %ebx,%eax
  800fd8:	c1 e8 0c             	shr    $0xc,%eax
  800fdb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe2:	f6 c4 08             	test   $0x8,%ah
  800fe5:	75 1c                	jne    801003 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  800fe7:	c7 44 24 08 2c 2a 80 	movl   $0x802a2c,0x8(%esp)
  800fee:	00 
  800fef:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  800ff6:	00 
  800ff7:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  800ffe:	e8 4d 11 00 00       	call   802150 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801003:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80100a:	00 
  80100b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801012:	00 
  801013:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80101a:	e8 cd fc ff ff       	call   800cec <sys_page_alloc>
  80101f:	85 c0                	test   %eax,%eax
  801021:	79 20                	jns    801043 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801023:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801027:	c7 44 24 08 68 2a 80 	movl   $0x802a68,0x8(%esp)
  80102e:	00 
  80102f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801036:	00 
  801037:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  80103e:	e8 0d 11 00 00       	call   802150 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801043:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801049:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801050:	00 
  801051:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801055:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80105c:	e8 7b f9 ff ff       	call   8009dc <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801061:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801068:	00 
  801069:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80106d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801074:	00 
  801075:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80107c:	00 
  80107d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801084:	e8 c2 fc ff ff       	call   800d4b <sys_page_map>
  801089:	85 c0                	test   %eax,%eax
  80108b:	79 20                	jns    8010ad <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80108d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801091:	c7 44 24 08 90 2a 80 	movl   $0x802a90,0x8(%esp)
  801098:	00 
  801099:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8010a0:	00 
  8010a1:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  8010a8:	e8 a3 10 00 00       	call   802150 <_panic>
	//panic("pgfault not implemented");
}
  8010ad:	83 c4 24             	add    $0x24,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  8010bc:	c7 04 24 b4 0f 80 00 	movl   $0x800fb4,(%esp)
  8010c3:	e8 e0 10 00 00       	call   8021a8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010c8:	ba 07 00 00 00       	mov    $0x7,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	cd 30                	int    $0x30
  8010d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d4:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	79 20                	jns    8010fa <fork+0x47>
		panic("sys_exofork: %e", envid);
  8010da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010de:	c7 44 24 08 8e 2b 80 	movl   $0x802b8e,0x8(%esp)
  8010e5:	00 
  8010e6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  8010ed:	00 
  8010ee:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  8010f5:	e8 56 10 00 00       	call   802150 <_panic>
	if (envid == 0) {
  8010fa:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8010ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801103:	75 1c                	jne    801121 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801105:	e8 82 fb ff ff       	call   800c8c <sys_getenvid>
  80110a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80110f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801112:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801117:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80111c:	e9 06 02 00 00       	jmp    801327 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801121:	89 d8                	mov    %ebx,%eax
  801123:	c1 e8 16             	shr    $0x16,%eax
  801126:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112d:	a8 01                	test   $0x1,%al
  80112f:	0f 84 57 01 00 00    	je     80128c <fork+0x1d9>
  801135:	89 de                	mov    %ebx,%esi
  801137:	c1 ee 0c             	shr    $0xc,%esi
  80113a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801141:	a8 01                	test   $0x1,%al
  801143:	0f 84 43 01 00 00    	je     80128c <fork+0x1d9>
  801149:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801150:	a8 04                	test   $0x4,%al
  801152:	0f 84 34 01 00 00    	je     80128c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801158:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80115b:	89 f0                	mov    %esi,%eax
  80115d:	c1 e8 0c             	shr    $0xc,%eax
  801160:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801167:	f6 c4 04             	test   $0x4,%ah
  80116a:	74 45                	je     8011b1 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80116c:	25 07 0e 00 00       	and    $0xe07,%eax
  801171:	89 44 24 10          	mov    %eax,0x10(%esp)
  801175:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801179:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80117d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801188:	e8 be fb ff ff       	call   800d4b <sys_page_map>
  80118d:	85 c0                	test   %eax,%eax
  80118f:	0f 89 f7 00 00 00    	jns    80128c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801195:	c7 44 24 08 9e 2b 80 	movl   $0x802b9e,0x8(%esp)
  80119c:	00 
  80119d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  8011a4:	00 
  8011a5:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  8011ac:	e8 9f 0f 00 00       	call   802150 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  8011b1:	a9 02 08 00 00       	test   $0x802,%eax
  8011b6:	0f 84 8c 00 00 00    	je     801248 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8011bc:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011c3:	00 
  8011c4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011c8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d7:	e8 6f fb ff ff       	call   800d4b <sys_page_map>
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	79 20                	jns    801200 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  8011e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e4:	c7 44 24 08 b4 2a 80 	movl   $0x802ab4,0x8(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8011f3:	00 
  8011f4:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  8011fb:	e8 50 0f 00 00       	call   802150 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801200:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801207:	00 
  801208:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80120c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801213:	00 
  801214:	89 74 24 04          	mov    %esi,0x4(%esp)
  801218:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121f:	e8 27 fb ff ff       	call   800d4b <sys_page_map>
  801224:	85 c0                	test   %eax,%eax
  801226:	79 64                	jns    80128c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801228:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122c:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  801243:	e8 08 0f 00 00       	call   802150 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801248:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80124f:	00 
  801250:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801254:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801258:	89 74 24 04          	mov    %esi,0x4(%esp)
  80125c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801263:	e8 e3 fa ff ff       	call   800d4b <sys_page_map>
  801268:	85 c0                	test   %eax,%eax
  80126a:	79 20                	jns    80128c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80126c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801270:	c7 44 24 08 0c 2b 80 	movl   $0x802b0c,0x8(%esp)
  801277:	00 
  801278:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80127f:	00 
  801280:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  801287:	e8 c4 0e 00 00       	call   802150 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80128c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801292:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801298:	0f 85 83 fe ff ff    	jne    801121 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80129e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012a5:	00 
  8012a6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012ad:	ee 
  8012ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b1:	89 04 24             	mov    %eax,(%esp)
  8012b4:	e8 33 fa ff ff       	call   800cec <sys_page_alloc>
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	79 20                	jns    8012dd <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  8012bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c1:	c7 44 24 08 38 2b 80 	movl   $0x802b38,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  8012d8:	e8 73 0e 00 00       	call   802150 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  8012dd:	c7 44 24 04 18 22 80 	movl   $0x802218,0x4(%esp)
  8012e4:	00 
  8012e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e8:	89 04 24             	mov    %eax,(%esp)
  8012eb:	e8 d3 fb ff ff       	call   800ec3 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012f0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012f7:	00 
  8012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fb:	89 04 24             	mov    %eax,(%esp)
  8012fe:	e8 04 fb ff ff       	call   800e07 <sys_env_set_status>
  801303:	85 c0                	test   %eax,%eax
  801305:	79 20                	jns    801327 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801307:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80130b:	c7 44 24 08 5c 2b 80 	movl   $0x802b5c,0x8(%esp)
  801312:	00 
  801313:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80131a:	00 
  80131b:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  801322:	e8 29 0e 00 00       	call   802150 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132a:	83 c4 3c             	add    $0x3c,%esp
  80132d:	5b                   	pop    %ebx
  80132e:	5e                   	pop    %esi
  80132f:	5f                   	pop    %edi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <sfork>:

// Challenge!
int
sfork(void)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801338:	c7 44 24 08 b5 2b 80 	movl   $0x802bb5,0x8(%esp)
  80133f:	00 
  801340:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801347:	00 
  801348:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  80134f:	e8 fc 0d 00 00       	call   802150 <_panic>
	...

00801360 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	05 00 00 00 30       	add    $0x30000000,%eax
  80136b:	c1 e8 0c             	shr    $0xc,%eax
}
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	89 04 24             	mov    %eax,(%esp)
  80137c:	e8 df ff ff ff       	call   801360 <fd2num>
  801381:	05 20 00 0d 00       	add    $0xd0020,%eax
  801386:	c1 e0 0c             	shl    $0xc,%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	53                   	push   %ebx
  80138f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801392:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801397:	a8 01                	test   $0x1,%al
  801399:	74 34                	je     8013cf <fd_alloc+0x44>
  80139b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013a0:	a8 01                	test   $0x1,%al
  8013a2:	74 32                	je     8013d6 <fd_alloc+0x4b>
  8013a4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013a9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013ab:	89 c2                	mov    %eax,%edx
  8013ad:	c1 ea 16             	shr    $0x16,%edx
  8013b0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013b7:	f6 c2 01             	test   $0x1,%dl
  8013ba:	74 1f                	je     8013db <fd_alloc+0x50>
  8013bc:	89 c2                	mov    %eax,%edx
  8013be:	c1 ea 0c             	shr    $0xc,%edx
  8013c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c8:	f6 c2 01             	test   $0x1,%dl
  8013cb:	75 17                	jne    8013e4 <fd_alloc+0x59>
  8013cd:	eb 0c                	jmp    8013db <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013cf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8013d4:	eb 05                	jmp    8013db <fd_alloc+0x50>
  8013d6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8013db:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e2:	eb 17                	jmp    8013fb <fd_alloc+0x70>
  8013e4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ee:	75 b9                	jne    8013a9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8013f6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013fb:	5b                   	pop    %ebx
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801404:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801409:	83 fa 1f             	cmp    $0x1f,%edx
  80140c:	77 3f                	ja     80144d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80140e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801414:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801417:	89 d0                	mov    %edx,%eax
  801419:	c1 e8 16             	shr    $0x16,%eax
  80141c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801428:	f6 c1 01             	test   $0x1,%cl
  80142b:	74 20                	je     80144d <fd_lookup+0x4f>
  80142d:	89 d0                	mov    %edx,%eax
  80142f:	c1 e8 0c             	shr    $0xc,%eax
  801432:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801439:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80143e:	f6 c1 01             	test   $0x1,%cl
  801441:	74 0a                	je     80144d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	89 10                	mov    %edx,(%eax)
	return 0;
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144d:	5d                   	pop    %ebp
  80144e:	c3                   	ret    

0080144f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	53                   	push   %ebx
  801453:	83 ec 14             	sub    $0x14,%esp
  801456:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801459:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801461:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801467:	75 17                	jne    801480 <dev_lookup+0x31>
  801469:	eb 07                	jmp    801472 <dev_lookup+0x23>
  80146b:	39 0a                	cmp    %ecx,(%edx)
  80146d:	75 11                	jne    801480 <dev_lookup+0x31>
  80146f:	90                   	nop
  801470:	eb 05                	jmp    801477 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801472:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801477:	89 13                	mov    %edx,(%ebx)
			return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	eb 35                	jmp    8014b5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801480:	83 c0 01             	add    $0x1,%eax
  801483:	8b 14 85 48 2c 80 00 	mov    0x802c48(,%eax,4),%edx
  80148a:	85 d2                	test   %edx,%edx
  80148c:	75 dd                	jne    80146b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148e:	a1 04 40 80 00       	mov    0x804004,%eax
  801493:	8b 40 48             	mov    0x48(%eax),%eax
  801496:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80149a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149e:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  8014a5:	e8 25 ed ff ff       	call   8001cf <cprintf>
	*dev = 0;
  8014aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b5:	83 c4 14             	add    $0x14,%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 38             	sub    $0x38,%esp
  8014c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014cd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d1:	89 3c 24             	mov    %edi,(%esp)
  8014d4:	e8 87 fe ff ff       	call   801360 <fd2num>
  8014d9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8014dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014e0:	89 04 24             	mov    %eax,(%esp)
  8014e3:	e8 16 ff ff ff       	call   8013fe <fd_lookup>
  8014e8:	89 c3                	mov    %eax,%ebx
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 05                	js     8014f3 <fd_close+0x38>
	    || fd != fd2)
  8014ee:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8014f1:	74 0e                	je     801501 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014f3:	89 f0                	mov    %esi,%eax
  8014f5:	84 c0                	test   %al,%al
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	0f 44 d8             	cmove  %eax,%ebx
  8014ff:	eb 3d                	jmp    80153e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801501:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	8b 07                	mov    (%edi),%eax
  80150a:	89 04 24             	mov    %eax,(%esp)
  80150d:	e8 3d ff ff ff       	call   80144f <dev_lookup>
  801512:	89 c3                	mov    %eax,%ebx
  801514:	85 c0                	test   %eax,%eax
  801516:	78 16                	js     80152e <fd_close+0x73>
		if (dev->dev_close)
  801518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80151e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801523:	85 c0                	test   %eax,%eax
  801525:	74 07                	je     80152e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801527:	89 3c 24             	mov    %edi,(%esp)
  80152a:	ff d0                	call   *%eax
  80152c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80152e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801539:	e8 6b f8 ff ff       	call   800da9 <sys_page_unmap>
	return r;
}
  80153e:	89 d8                	mov    %ebx,%eax
  801540:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801543:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801546:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801549:	89 ec                	mov    %ebp,%esp
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    

0080154d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801553:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 04 24             	mov    %eax,(%esp)
  801560:	e8 99 fe ff ff       	call   8013fe <fd_lookup>
  801565:	85 c0                	test   %eax,%eax
  801567:	78 13                	js     80157c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801569:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801570:	00 
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	e8 3f ff ff ff       	call   8014bb <fd_close>
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <close_all>:

void
close_all(void)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	53                   	push   %ebx
  801582:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801585:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80158a:	89 1c 24             	mov    %ebx,(%esp)
  80158d:	e8 bb ff ff ff       	call   80154d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801592:	83 c3 01             	add    $0x1,%ebx
  801595:	83 fb 20             	cmp    $0x20,%ebx
  801598:	75 f0                	jne    80158a <close_all+0xc>
		close(i);
}
  80159a:	83 c4 14             	add    $0x14,%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 58             	sub    $0x58,%esp
  8015a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	89 04 24             	mov    %eax,(%esp)
  8015bf:	e8 3a fe ff ff       	call   8013fe <fd_lookup>
  8015c4:	89 c3                	mov    %eax,%ebx
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	0f 88 e1 00 00 00    	js     8016af <dup+0x10f>
		return r;
	close(newfdnum);
  8015ce:	89 3c 24             	mov    %edi,(%esp)
  8015d1:	e8 77 ff ff ff       	call   80154d <close>

	newfd = INDEX2FD(newfdnum);
  8015d6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8015dc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8015df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e2:	89 04 24             	mov    %eax,(%esp)
  8015e5:	e8 86 fd ff ff       	call   801370 <fd2data>
  8015ea:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015ec:	89 34 24             	mov    %esi,(%esp)
  8015ef:	e8 7c fd ff ff       	call   801370 <fd2data>
  8015f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	c1 e8 16             	shr    $0x16,%eax
  8015fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801603:	a8 01                	test   $0x1,%al
  801605:	74 46                	je     80164d <dup+0xad>
  801607:	89 d8                	mov    %ebx,%eax
  801609:	c1 e8 0c             	shr    $0xc,%eax
  80160c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801613:	f6 c2 01             	test   $0x1,%dl
  801616:	74 35                	je     80164d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801618:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161f:	25 07 0e 00 00       	and    $0xe07,%eax
  801624:	89 44 24 10          	mov    %eax,0x10(%esp)
  801628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80162b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80162f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801636:	00 
  801637:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80163b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801642:	e8 04 f7 ff ff       	call   800d4b <sys_page_map>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 3b                	js     801688 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80164d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801650:	89 c2                	mov    %eax,%edx
  801652:	c1 ea 0c             	shr    $0xc,%edx
  801655:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801662:	89 54 24 10          	mov    %edx,0x10(%esp)
  801666:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80166a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801671:	00 
  801672:	89 44 24 04          	mov    %eax,0x4(%esp)
  801676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167d:	e8 c9 f6 ff ff       	call   800d4b <sys_page_map>
  801682:	89 c3                	mov    %eax,%ebx
  801684:	85 c0                	test   %eax,%eax
  801686:	79 25                	jns    8016ad <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801688:	89 74 24 04          	mov    %esi,0x4(%esp)
  80168c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801693:	e8 11 f7 ff ff       	call   800da9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80169b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a6:	e8 fe f6 ff ff       	call   800da9 <sys_page_unmap>
	return r;
  8016ab:	eb 02                	jmp    8016af <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8016ad:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016af:	89 d8                	mov    %ebx,%eax
  8016b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016ba:	89 ec                	mov    %ebp,%esp
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	53                   	push   %ebx
  8016c2:	83 ec 24             	sub    $0x24,%esp
  8016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	89 1c 24             	mov    %ebx,(%esp)
  8016d2:	e8 27 fd ff ff       	call   8013fe <fd_lookup>
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 6d                	js     801748 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	89 04 24             	mov    %eax,(%esp)
  8016ea:	e8 60 fd ff ff       	call   80144f <dev_lookup>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 55                	js     801748 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	8b 50 08             	mov    0x8(%eax),%edx
  8016f9:	83 e2 03             	and    $0x3,%edx
  8016fc:	83 fa 01             	cmp    $0x1,%edx
  8016ff:	75 23                	jne    801724 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801701:	a1 04 40 80 00       	mov    0x804004,%eax
  801706:	8b 40 48             	mov    0x48(%eax),%eax
  801709:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801711:	c7 04 24 0d 2c 80 00 	movl   $0x802c0d,(%esp)
  801718:	e8 b2 ea ff ff       	call   8001cf <cprintf>
		return -E_INVAL;
  80171d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801722:	eb 24                	jmp    801748 <read+0x8a>
	}
	if (!dev->dev_read)
  801724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801727:	8b 52 08             	mov    0x8(%edx),%edx
  80172a:	85 d2                	test   %edx,%edx
  80172c:	74 15                	je     801743 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801735:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801738:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80173c:	89 04 24             	mov    %eax,(%esp)
  80173f:	ff d2                	call   *%edx
  801741:	eb 05                	jmp    801748 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801743:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801748:	83 c4 24             	add    $0x24,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    

0080174e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	57                   	push   %edi
  801752:	56                   	push   %esi
  801753:	53                   	push   %ebx
  801754:	83 ec 1c             	sub    $0x1c,%esp
  801757:	8b 7d 08             	mov    0x8(%ebp),%edi
  80175a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	85 f6                	test   %esi,%esi
  801764:	74 30                	je     801796 <readn+0x48>
  801766:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80176b:	89 f2                	mov    %esi,%edx
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801773:	03 45 0c             	add    0xc(%ebp),%eax
  801776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177a:	89 3c 24             	mov    %edi,(%esp)
  80177d:	e8 3c ff ff ff       	call   8016be <read>
		if (m < 0)
  801782:	85 c0                	test   %eax,%eax
  801784:	78 10                	js     801796 <readn+0x48>
			return m;
		if (m == 0)
  801786:	85 c0                	test   %eax,%eax
  801788:	74 0a                	je     801794 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80178a:	01 c3                	add    %eax,%ebx
  80178c:	89 d8                	mov    %ebx,%eax
  80178e:	39 f3                	cmp    %esi,%ebx
  801790:	72 d9                	jb     80176b <readn+0x1d>
  801792:	eb 02                	jmp    801796 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801794:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801796:	83 c4 1c             	add    $0x1c,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 24             	sub    $0x24,%esp
  8017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017af:	89 1c 24             	mov    %ebx,(%esp)
  8017b2:	e8 47 fc ff ff       	call   8013fe <fd_lookup>
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 68                	js     801823 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 80 fc ff ff       	call   80144f <dev_lookup>
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 50                	js     801823 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017da:	75 23                	jne    8017ff <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8017e1:	8b 40 48             	mov    0x48(%eax),%eax
  8017e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ec:	c7 04 24 29 2c 80 00 	movl   $0x802c29,(%esp)
  8017f3:	e8 d7 e9 ff ff       	call   8001cf <cprintf>
		return -E_INVAL;
  8017f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fd:	eb 24                	jmp    801823 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	8b 52 0c             	mov    0xc(%edx),%edx
  801805:	85 d2                	test   %edx,%edx
  801807:	74 15                	je     80181e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801809:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801813:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801817:	89 04 24             	mov    %eax,(%esp)
  80181a:	ff d2                	call   *%edx
  80181c:	eb 05                	jmp    801823 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80181e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801823:	83 c4 24             	add    $0x24,%esp
  801826:	5b                   	pop    %ebx
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    

00801829 <seek>:

int
seek(int fdnum, off_t offset)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801832:	89 44 24 04          	mov    %eax,0x4(%esp)
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	89 04 24             	mov    %eax,(%esp)
  80183c:	e8 bd fb ff ff       	call   8013fe <fd_lookup>
  801841:	85 c0                	test   %eax,%eax
  801843:	78 0e                	js     801853 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	53                   	push   %ebx
  801859:	83 ec 24             	sub    $0x24,%esp
  80185c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	89 1c 24             	mov    %ebx,(%esp)
  801869:	e8 90 fb ff ff       	call   8013fe <fd_lookup>
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 61                	js     8018d3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	89 44 24 04          	mov    %eax,0x4(%esp)
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	8b 00                	mov    (%eax),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 c9 fb ff ff       	call   80144f <dev_lookup>
  801886:	85 c0                	test   %eax,%eax
  801888:	78 49                	js     8018d3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801891:	75 23                	jne    8018b6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801893:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801898:	8b 40 48             	mov    0x48(%eax),%eax
  80189b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  8018aa:	e8 20 e9 ff ff       	call   8001cf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b4:	eb 1d                	jmp    8018d3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8018b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b9:	8b 52 18             	mov    0x18(%edx),%edx
  8018bc:	85 d2                	test   %edx,%edx
  8018be:	74 0e                	je     8018ce <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018c7:	89 04 24             	mov    %eax,(%esp)
  8018ca:	ff d2                	call   *%edx
  8018cc:	eb 05                	jmp    8018d3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018d3:	83 c4 24             	add    $0x24,%esp
  8018d6:	5b                   	pop    %ebx
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 24             	sub    $0x24,%esp
  8018e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	89 04 24             	mov    %eax,(%esp)
  8018f0:	e8 09 fb ff ff       	call   8013fe <fd_lookup>
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 52                	js     80194b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	8b 00                	mov    (%eax),%eax
  801905:	89 04 24             	mov    %eax,(%esp)
  801908:	e8 42 fb ff ff       	call   80144f <dev_lookup>
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 3a                	js     80194b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801914:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801918:	74 2c                	je     801946 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80191a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80191d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801924:	00 00 00 
	stat->st_isdir = 0;
  801927:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192e:	00 00 00 
	stat->st_dev = dev;
  801931:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801937:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80193b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193e:	89 14 24             	mov    %edx,(%esp)
  801941:	ff 50 14             	call   *0x14(%eax)
  801944:	eb 05                	jmp    80194b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801946:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80194b:	83 c4 24             	add    $0x24,%esp
  80194e:	5b                   	pop    %ebx
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    

00801951 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 18             	sub    $0x18,%esp
  801957:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80195a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80195d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801964:	00 
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	89 04 24             	mov    %eax,(%esp)
  80196b:	e8 bc 01 00 00       	call   801b2c <open>
  801970:	89 c3                	mov    %eax,%ebx
  801972:	85 c0                	test   %eax,%eax
  801974:	78 1b                	js     801991 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801976:	8b 45 0c             	mov    0xc(%ebp),%eax
  801979:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197d:	89 1c 24             	mov    %ebx,(%esp)
  801980:	e8 54 ff ff ff       	call   8018d9 <fstat>
  801985:	89 c6                	mov    %eax,%esi
	close(fd);
  801987:	89 1c 24             	mov    %ebx,(%esp)
  80198a:	e8 be fb ff ff       	call   80154d <close>
	return r;
  80198f:	89 f3                	mov    %esi,%ebx
}
  801991:	89 d8                	mov    %ebx,%eax
  801993:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801996:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801999:	89 ec                	mov    %ebp,%esp
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    
  80199d:	00 00                	add    %al,(%eax)
	...

008019a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 18             	sub    $0x18,%esp
  8019a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8019b0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019b7:	75 11                	jne    8019ca <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019c0:	e8 51 09 00 00       	call   802316 <ipc_find_env>
  8019c5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019ca:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019d1:	00 
  8019d2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8019d9:	00 
  8019da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019de:	a1 00 40 80 00       	mov    0x804000,%eax
  8019e3:	89 04 24             	mov    %eax,(%esp)
  8019e6:	e8 a7 08 00 00       	call   802292 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019f2:	00 
  8019f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fe:	e8 3d 08 00 00       	call   802240 <ipc_recv>
}
  801a03:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a06:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a09:	89 ec                	mov    %ebp,%esp
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	53                   	push   %ebx
  801a11:	83 ec 14             	sub    $0x14,%esp
  801a14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a22:	ba 00 00 00 00       	mov    $0x0,%edx
  801a27:	b8 05 00 00 00       	mov    $0x5,%eax
  801a2c:	e8 6f ff ff ff       	call   8019a0 <fsipc>
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 2b                	js     801a60 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a35:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a3c:	00 
  801a3d:	89 1c 24             	mov    %ebx,(%esp)
  801a40:	e8 a6 ed ff ff       	call   8007eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a45:	a1 80 50 80 00       	mov    0x805080,%eax
  801a4a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a50:	a1 84 50 80 00       	mov    0x805084,%eax
  801a55:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a60:	83 c4 14             	add    $0x14,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a72:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	b8 06 00 00 00       	mov    $0x6,%eax
  801a81:	e8 1a ff ff ff       	call   8019a0 <fsipc>
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 10             	sub    $0x10,%esp
  801a90:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8b 40 0c             	mov    0xc(%eax),%eax
  801a99:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a9e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa9:	b8 03 00 00 00       	mov    $0x3,%eax
  801aae:	e8 ed fe ff ff       	call   8019a0 <fsipc>
  801ab3:	89 c3                	mov    %eax,%ebx
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 6a                	js     801b23 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ab9:	39 c6                	cmp    %eax,%esi
  801abb:	73 24                	jae    801ae1 <devfile_read+0x59>
  801abd:	c7 44 24 0c 58 2c 80 	movl   $0x802c58,0xc(%esp)
  801ac4:	00 
  801ac5:	c7 44 24 08 5f 2c 80 	movl   $0x802c5f,0x8(%esp)
  801acc:	00 
  801acd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ad4:	00 
  801ad5:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  801adc:	e8 6f 06 00 00       	call   802150 <_panic>
	assert(r <= PGSIZE);
  801ae1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae6:	7e 24                	jle    801b0c <devfile_read+0x84>
  801ae8:	c7 44 24 0c 7f 2c 80 	movl   $0x802c7f,0xc(%esp)
  801aef:	00 
  801af0:	c7 44 24 08 5f 2c 80 	movl   $0x802c5f,0x8(%esp)
  801af7:	00 
  801af8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801aff:	00 
  801b00:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  801b07:	e8 44 06 00 00       	call   802150 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b10:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b17:	00 
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	89 04 24             	mov    %eax,(%esp)
  801b1e:	e8 b9 ee ff ff       	call   8009dc <memmove>
	return r;
}
  801b23:	89 d8                	mov    %ebx,%eax
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	5b                   	pop    %ebx
  801b29:	5e                   	pop    %esi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	83 ec 20             	sub    $0x20,%esp
  801b34:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b37:	89 34 24             	mov    %esi,(%esp)
  801b3a:	e8 61 ec ff ff       	call   8007a0 <strlen>
		return -E_BAD_PATH;
  801b3f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b44:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b49:	7f 5e                	jg     801ba9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4e:	89 04 24             	mov    %eax,(%esp)
  801b51:	e8 35 f8 ff ff       	call   80138b <fd_alloc>
  801b56:	89 c3                	mov    %eax,%ebx
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	78 4d                	js     801ba9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b60:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b67:	e8 7f ec ff ff       	call   8007eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b77:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7c:	e8 1f fe ff ff       	call   8019a0 <fsipc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	79 15                	jns    801b9c <open+0x70>
		fd_close(fd, 0);
  801b87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b8e:	00 
  801b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b92:	89 04 24             	mov    %eax,(%esp)
  801b95:	e8 21 f9 ff ff       	call   8014bb <fd_close>
		return r;
  801b9a:	eb 0d                	jmp    801ba9 <open+0x7d>
	}

	return fd2num(fd);
  801b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9f:	89 04 24             	mov    %eax,(%esp)
  801ba2:	e8 b9 f7 ff ff       	call   801360 <fd2num>
  801ba7:	89 c3                	mov    %eax,%ebx
}
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	83 c4 20             	add    $0x20,%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5e                   	pop    %esi
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    
	...

00801bc0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
  801bc6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bc9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	89 04 24             	mov    %eax,(%esp)
  801bd5:	e8 96 f7 ff ff       	call   801370 <fd2data>
  801bda:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801bdc:	c7 44 24 04 8b 2c 80 	movl   $0x802c8b,0x4(%esp)
  801be3:	00 
  801be4:	89 34 24             	mov    %esi,(%esp)
  801be7:	e8 ff eb ff ff       	call   8007eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bec:	8b 43 04             	mov    0x4(%ebx),%eax
  801bef:	2b 03                	sub    (%ebx),%eax
  801bf1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801bf7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801bfe:	00 00 00 
	stat->st_dev = &devpipe;
  801c01:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801c08:	30 80 00 
	return 0;
}
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c13:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c16:	89 ec                	mov    %ebp,%esp
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 14             	sub    $0x14,%esp
  801c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c24:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2f:	e8 75 f1 ff ff       	call   800da9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c34:	89 1c 24             	mov    %ebx,(%esp)
  801c37:	e8 34 f7 ff ff       	call   801370 <fd2data>
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c47:	e8 5d f1 ff ff       	call   800da9 <sys_page_unmap>
}
  801c4c:	83 c4 14             	add    $0x14,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    

00801c52 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 2c             	sub    $0x2c,%esp
  801c5b:	89 c7                	mov    %eax,%edi
  801c5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801c60:	a1 04 40 80 00       	mov    0x804004,%eax
  801c65:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c68:	89 3c 24             	mov    %edi,(%esp)
  801c6b:	e8 f0 06 00 00       	call   802360 <pageref>
  801c70:	89 c6                	mov    %eax,%esi
  801c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c75:	89 04 24             	mov    %eax,(%esp)
  801c78:	e8 e3 06 00 00       	call   802360 <pageref>
  801c7d:	39 c6                	cmp    %eax,%esi
  801c7f:	0f 94 c0             	sete   %al
  801c82:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801c85:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c8b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c8e:	39 cb                	cmp    %ecx,%ebx
  801c90:	75 08                	jne    801c9a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801c92:	83 c4 2c             	add    $0x2c,%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801c9a:	83 f8 01             	cmp    $0x1,%eax
  801c9d:	75 c1                	jne    801c60 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c9f:	8b 52 58             	mov    0x58(%edx),%edx
  801ca2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801caa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cae:	c7 04 24 92 2c 80 00 	movl   $0x802c92,(%esp)
  801cb5:	e8 15 e5 ff ff       	call   8001cf <cprintf>
  801cba:	eb a4                	jmp    801c60 <_pipeisclosed+0xe>

00801cbc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	57                   	push   %edi
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 2c             	sub    $0x2c,%esp
  801cc5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801cc8:	89 34 24             	mov    %esi,(%esp)
  801ccb:	e8 a0 f6 ff ff       	call   801370 <fd2data>
  801cd0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cdb:	75 50                	jne    801d2d <devpipe_write+0x71>
  801cdd:	eb 5c                	jmp    801d3b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801cdf:	89 da                	mov    %ebx,%edx
  801ce1:	89 f0                	mov    %esi,%eax
  801ce3:	e8 6a ff ff ff       	call   801c52 <_pipeisclosed>
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	75 53                	jne    801d3f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801cec:	e8 cb ef ff ff       	call   800cbc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cf1:	8b 43 04             	mov    0x4(%ebx),%eax
  801cf4:	8b 13                	mov    (%ebx),%edx
  801cf6:	83 c2 20             	add    $0x20,%edx
  801cf9:	39 d0                	cmp    %edx,%eax
  801cfb:	73 e2                	jae    801cdf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801d04:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801d07:	89 c2                	mov    %eax,%edx
  801d09:	c1 fa 1f             	sar    $0x1f,%edx
  801d0c:	c1 ea 1b             	shr    $0x1b,%edx
  801d0f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801d12:	83 e1 1f             	and    $0x1f,%ecx
  801d15:	29 d1                	sub    %edx,%ecx
  801d17:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801d1b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801d1f:	83 c0 01             	add    $0x1,%eax
  801d22:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d25:	83 c7 01             	add    $0x1,%edi
  801d28:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d2b:	74 0e                	je     801d3b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d2d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d30:	8b 13                	mov    (%ebx),%edx
  801d32:	83 c2 20             	add    $0x20,%edx
  801d35:	39 d0                	cmp    %edx,%eax
  801d37:	73 a6                	jae    801cdf <devpipe_write+0x23>
  801d39:	eb c2                	jmp    801cfd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801d3b:	89 f8                	mov    %edi,%eax
  801d3d:	eb 05                	jmp    801d44 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d44:	83 c4 2c             	add    $0x2c,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 28             	sub    $0x28,%esp
  801d52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d58:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d5b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d5e:	89 3c 24             	mov    %edi,(%esp)
  801d61:	e8 0a f6 ff ff       	call   801370 <fd2data>
  801d66:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d68:	be 00 00 00 00       	mov    $0x0,%esi
  801d6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d71:	75 47                	jne    801dba <devpipe_read+0x6e>
  801d73:	eb 52                	jmp    801dc7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801d75:	89 f0                	mov    %esi,%eax
  801d77:	eb 5e                	jmp    801dd7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d79:	89 da                	mov    %ebx,%edx
  801d7b:	89 f8                	mov    %edi,%eax
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	e8 cd fe ff ff       	call   801c52 <_pipeisclosed>
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 49                	jne    801dd2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801d89:	e8 2e ef ff ff       	call   800cbc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801d8e:	8b 03                	mov    (%ebx),%eax
  801d90:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d93:	74 e4                	je     801d79 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d95:	89 c2                	mov    %eax,%edx
  801d97:	c1 fa 1f             	sar    $0x1f,%edx
  801d9a:	c1 ea 1b             	shr    $0x1b,%edx
  801d9d:	01 d0                	add    %edx,%eax
  801d9f:	83 e0 1f             	and    $0x1f,%eax
  801da2:	29 d0                	sub    %edx,%eax
  801da4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801daf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801db2:	83 c6 01             	add    $0x1,%esi
  801db5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801db8:	74 0d                	je     801dc7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801dba:	8b 03                	mov    (%ebx),%eax
  801dbc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dbf:	75 d4                	jne    801d95 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801dc1:	85 f6                	test   %esi,%esi
  801dc3:	75 b0                	jne    801d75 <devpipe_read+0x29>
  801dc5:	eb b2                	jmp    801d79 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801dc7:	89 f0                	mov    %esi,%eax
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	eb 05                	jmp    801dd7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801dd7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801dda:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ddd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801de0:	89 ec                	mov    %ebp,%esp
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 48             	sub    $0x48,%esp
  801dea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ded:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801df0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801df3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801df6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801df9:	89 04 24             	mov    %eax,(%esp)
  801dfc:	e8 8a f5 ff ff       	call   80138b <fd_alloc>
  801e01:	89 c3                	mov    %eax,%ebx
  801e03:	85 c0                	test   %eax,%eax
  801e05:	0f 88 45 01 00 00    	js     801f50 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e12:	00 
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e21:	e8 c6 ee ff ff       	call   800cec <sys_page_alloc>
  801e26:	89 c3                	mov    %eax,%ebx
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	0f 88 20 01 00 00    	js     801f50 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e30:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e33:	89 04 24             	mov    %eax,(%esp)
  801e36:	e8 50 f5 ff ff       	call   80138b <fd_alloc>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	0f 88 f8 00 00 00    	js     801f3d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e4c:	00 
  801e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5b:	e8 8c ee ff ff       	call   800cec <sys_page_alloc>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	85 c0                	test   %eax,%eax
  801e64:	0f 88 d3 00 00 00    	js     801f3d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6d:	89 04 24             	mov    %eax,(%esp)
  801e70:	e8 fb f4 ff ff       	call   801370 <fd2data>
  801e75:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e77:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e7e:	00 
  801e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8a:	e8 5d ee ff ff       	call   800cec <sys_page_alloc>
  801e8f:	89 c3                	mov    %eax,%ebx
  801e91:	85 c0                	test   %eax,%eax
  801e93:	0f 88 91 00 00 00    	js     801f2a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9c:	89 04 24             	mov    %eax,(%esp)
  801e9f:	e8 cc f4 ff ff       	call   801370 <fd2data>
  801ea4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801eab:	00 
  801eac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eb7:	00 
  801eb8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ebc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec3:	e8 83 ee ff ff       	call   800d4b <sys_page_map>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 4c                	js     801f1a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ece:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801edc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ee3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eec:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801efb:	89 04 24             	mov    %eax,(%esp)
  801efe:	e8 5d f4 ff ff       	call   801360 <fd2num>
  801f03:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 50 f4 ff ff       	call   801360 <fd2num>
  801f10:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f18:	eb 36                	jmp    801f50 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801f1a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f25:	e8 7f ee ff ff       	call   800da9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f38:	e8 6c ee ff ff       	call   800da9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4b:	e8 59 ee ff ff       	call   800da9 <sys_page_unmap>
    err:
	return r;
}
  801f50:	89 d8                	mov    %ebx,%eax
  801f52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f5b:	89 ec                	mov    %ebp,%esp
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	89 04 24             	mov    %eax,(%esp)
  801f72:	e8 87 f4 ff ff       	call   8013fe <fd_lookup>
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 15                	js     801f90 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	89 04 24             	mov    %eax,(%esp)
  801f81:	e8 ea f3 ff ff       	call   801370 <fd2data>
	return _pipeisclosed(fd, p);
  801f86:	89 c2                	mov    %eax,%edx
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	e8 c2 fc ff ff       	call   801c52 <_pipeisclosed>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    
	...

00801fa0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    

00801faa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801fb0:	c7 44 24 04 aa 2c 80 	movl   $0x802caa,0x4(%esp)
  801fb7:	00 
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	89 04 24             	mov    %eax,(%esp)
  801fbe:	e8 28 e8 ff ff       	call   8007eb <strcpy>
	return 0;
}
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fd6:	be 00 00 00 00       	mov    $0x0,%esi
  801fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fdf:	74 43                	je     802024 <devcons_write+0x5a>
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fe6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fef:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801ff1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ff4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ff9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ffc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802000:	03 45 0c             	add    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	89 3c 24             	mov    %edi,(%esp)
  80200a:	e8 cd e9 ff ff       	call   8009dc <memmove>
		sys_cputs(buf, m);
  80200f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802013:	89 3c 24             	mov    %edi,(%esp)
  802016:	e8 b5 eb ff ff       	call   800bd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80201b:	01 de                	add    %ebx,%esi
  80201d:	89 f0                	mov    %esi,%eax
  80201f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802022:	72 c8                	jb     801fec <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802024:	89 f0                	mov    %esi,%eax
  802026:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    

00802031 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80203c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802040:	75 07                	jne    802049 <devcons_read+0x18>
  802042:	eb 31                	jmp    802075 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802044:	e8 73 ec ff ff       	call   800cbc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802050:	e8 aa eb ff ff       	call   800bff <sys_cgetc>
  802055:	85 c0                	test   %eax,%eax
  802057:	74 eb                	je     802044 <devcons_read+0x13>
  802059:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 16                	js     802075 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80205f:	83 f8 04             	cmp    $0x4,%eax
  802062:	74 0c                	je     802070 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802064:	8b 45 0c             	mov    0xc(%ebp),%eax
  802067:	88 10                	mov    %dl,(%eax)
	return 1;
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	eb 05                	jmp    802075 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802083:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80208a:	00 
  80208b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80208e:	89 04 24             	mov    %eax,(%esp)
  802091:	e8 3a eb ff ff       	call   800bd0 <sys_cputs>
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <getchar>:

int
getchar(void)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80209e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8020a5:	00 
  8020a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b4:	e8 05 f6 ff ff       	call   8016be <read>
	if (r < 0)
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	78 0f                	js     8020cc <getchar+0x34>
		return r;
	if (r < 1)
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	7e 06                	jle    8020c7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8020c1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8020c5:	eb 05                	jmp    8020cc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8020c7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 18 f3 ff ff       	call   8013fe <fd_lookup>
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 11                	js     8020fb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020f3:	39 10                	cmp    %edx,(%eax)
  8020f5:	0f 94 c0             	sete   %al
  8020f8:	0f b6 c0             	movzbl %al,%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <opencons>:

int
opencons(void)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802103:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 7d f2 ff ff       	call   80138b <fd_alloc>
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 3c                	js     80214e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802112:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802119:	00 
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802128:	e8 bf eb ff ff       	call   800cec <sys_page_alloc>
  80212d:	85 c0                	test   %eax,%eax
  80212f:	78 1d                	js     80214e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802131:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 12 f2 ff ff       	call   801360 <fd2num>
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	56                   	push   %esi
  802154:	53                   	push   %ebx
  802155:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802158:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80215b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  802161:	e8 26 eb ff ff       	call   800c8c <sys_getenvid>
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	89 54 24 10          	mov    %edx,0x10(%esp)
  80216d:	8b 55 08             	mov    0x8(%ebp),%edx
  802170:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802174:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217c:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  802183:	e8 47 e0 ff ff       	call   8001cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802188:	89 74 24 04          	mov    %esi,0x4(%esp)
  80218c:	8b 45 10             	mov    0x10(%ebp),%eax
  80218f:	89 04 24             	mov    %eax,(%esp)
  802192:	e8 d7 df ff ff       	call   80016e <vcprintf>
	cprintf("\n");
  802197:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  80219e:	e8 2c e0 ff ff       	call   8001cf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021a3:	cc                   	int3   
  8021a4:	eb fd                	jmp    8021a3 <_panic+0x53>
	...

008021a8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021ae:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021b5:	75 54                	jne    80220b <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8021b7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021be:	00 
  8021bf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8021c6:	ee 
  8021c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ce:	e8 19 eb ff ff       	call   800cec <sys_page_alloc>
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	79 20                	jns    8021f7 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  8021d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021db:	c7 44 24 08 dc 2c 80 	movl   $0x802cdc,0x8(%esp)
  8021e2:	00 
  8021e3:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8021ea:	00 
  8021eb:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8021f2:	e8 59 ff ff ff       	call   802150 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8021f7:	c7 44 24 04 18 22 80 	movl   $0x802218,0x4(%esp)
  8021fe:	00 
  8021ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802206:	e8 b8 ec ff ff       	call   800ec3 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    
  802215:	00 00                	add    %al,(%eax)
	...

00802218 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802218:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802219:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80221e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802220:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  802223:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802227:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  80222a:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  80222e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802232:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802234:	83 c4 08             	add    $0x8,%esp
	popal
  802237:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802238:	83 c4 04             	add    $0x4,%esp
	popfl
  80223b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80223c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80223d:	c3                   	ret    
	...

00802240 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	56                   	push   %esi
  802244:	53                   	push   %ebx
  802245:	83 ec 10             	sub    $0x10,%esp
  802248:	8b 75 08             	mov    0x8(%ebp),%esi
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802251:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802253:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802258:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80225b:	89 04 24             	mov    %eax,(%esp)
  80225e:	e8 f2 ec ff ff       	call   800f55 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802263:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802268:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80226d:	85 c0                	test   %eax,%eax
  80226f:	78 0e                	js     80227f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802271:	a1 04 40 80 00       	mov    0x804004,%eax
  802276:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802279:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80227c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80227f:	85 f6                	test   %esi,%esi
  802281:	74 02                	je     802285 <ipc_recv+0x45>
		*from_env_store = sender;
  802283:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802285:	85 db                	test   %ebx,%ebx
  802287:	74 02                	je     80228b <ipc_recv+0x4b>
		*perm_store = perm;
  802289:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    

00802292 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	57                   	push   %edi
  802296:	56                   	push   %esi
  802297:	53                   	push   %ebx
  802298:	83 ec 1c             	sub    $0x1c,%esp
  80229b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80229e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022a1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8022a4:	85 db                	test   %ebx,%ebx
  8022a6:	75 04                	jne    8022ac <ipc_send+0x1a>
  8022a8:	85 f6                	test   %esi,%esi
  8022aa:	75 15                	jne    8022c1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8022ac:	85 db                	test   %ebx,%ebx
  8022ae:	74 16                	je     8022c6 <ipc_send+0x34>
  8022b0:	85 f6                	test   %esi,%esi
  8022b2:	0f 94 c0             	sete   %al
      pg = 0;
  8022b5:	84 c0                	test   %al,%al
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	0f 45 d8             	cmovne %eax,%ebx
  8022bf:	eb 05                	jmp    8022c6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8022c1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8022c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	e8 44 ec ff ff       	call   800f21 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8022dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022e0:	75 07                	jne    8022e9 <ipc_send+0x57>
           sys_yield();
  8022e2:	e8 d5 e9 ff ff       	call   800cbc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8022e7:	eb dd                	jmp    8022c6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	90                   	nop
  8022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	74 1c                	je     80230e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8022f2:	c7 44 24 08 02 2d 80 	movl   $0x802d02,0x8(%esp)
  8022f9:	00 
  8022fa:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802301:	00 
  802302:	c7 04 24 0c 2d 80 00 	movl   $0x802d0c,(%esp)
  802309:	e8 42 fe ff ff       	call   802150 <_panic>
		}
    }
}
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    

00802316 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80231c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802321:	39 c8                	cmp    %ecx,%eax
  802323:	74 17                	je     80233c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802325:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80232a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80232d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802333:	8b 52 50             	mov    0x50(%edx),%edx
  802336:	39 ca                	cmp    %ecx,%edx
  802338:	75 14                	jne    80234e <ipc_find_env+0x38>
  80233a:	eb 05                	jmp    802341 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802341:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802344:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802349:	8b 40 40             	mov    0x40(%eax),%eax
  80234c:	eb 0e                	jmp    80235c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80234e:	83 c0 01             	add    $0x1,%eax
  802351:	3d 00 04 00 00       	cmp    $0x400,%eax
  802356:	75 d2                	jne    80232a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802358:	66 b8 00 00          	mov    $0x0,%ax
}
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    
	...

00802360 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802366:	89 d0                	mov    %edx,%eax
  802368:	c1 e8 16             	shr    $0x16,%eax
  80236b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802377:	f6 c1 01             	test   $0x1,%cl
  80237a:	74 1d                	je     802399 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80237c:	c1 ea 0c             	shr    $0xc,%edx
  80237f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802386:	f6 c2 01             	test   $0x1,%dl
  802389:	74 0e                	je     802399 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80238b:	c1 ea 0c             	shr    $0xc,%edx
  80238e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802395:	ef 
  802396:	0f b7 c0             	movzwl %ax,%eax
}
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    
  80239b:	00 00                	add    %al,(%eax)
  80239d:	00 00                	add    %al,(%eax)
	...

008023a0 <__udivdi3>:
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
  8023a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8023a7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8023ab:	8b 44 24 20          	mov    0x20(%esp),%eax
  8023af:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8023b3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8023b7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8023bb:	85 ff                	test   %edi,%edi
  8023bd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8023c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c5:	89 cd                	mov    %ecx,%ebp
  8023c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023cb:	75 33                	jne    802400 <__udivdi3+0x60>
  8023cd:	39 f1                	cmp    %esi,%ecx
  8023cf:	77 57                	ja     802428 <__udivdi3+0x88>
  8023d1:	85 c9                	test   %ecx,%ecx
  8023d3:	75 0b                	jne    8023e0 <__udivdi3+0x40>
  8023d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023da:	31 d2                	xor    %edx,%edx
  8023dc:	f7 f1                	div    %ecx
  8023de:	89 c1                	mov    %eax,%ecx
  8023e0:	89 f0                	mov    %esi,%eax
  8023e2:	31 d2                	xor    %edx,%edx
  8023e4:	f7 f1                	div    %ecx
  8023e6:	89 c6                	mov    %eax,%esi
  8023e8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ec:	f7 f1                	div    %ecx
  8023ee:	89 f2                	mov    %esi,%edx
  8023f0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8023f4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8023f8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	c3                   	ret    
  802400:	31 d2                	xor    %edx,%edx
  802402:	31 c0                	xor    %eax,%eax
  802404:	39 f7                	cmp    %esi,%edi
  802406:	77 e8                	ja     8023f0 <__udivdi3+0x50>
  802408:	0f bd cf             	bsr    %edi,%ecx
  80240b:	83 f1 1f             	xor    $0x1f,%ecx
  80240e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802412:	75 2c                	jne    802440 <__udivdi3+0xa0>
  802414:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802418:	76 04                	jbe    80241e <__udivdi3+0x7e>
  80241a:	39 f7                	cmp    %esi,%edi
  80241c:	73 d2                	jae    8023f0 <__udivdi3+0x50>
  80241e:	31 d2                	xor    %edx,%edx
  802420:	b8 01 00 00 00       	mov    $0x1,%eax
  802425:	eb c9                	jmp    8023f0 <__udivdi3+0x50>
  802427:	90                   	nop
  802428:	89 f2                	mov    %esi,%edx
  80242a:	f7 f1                	div    %ecx
  80242c:	31 d2                	xor    %edx,%edx
  80242e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802432:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802436:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80243a:	83 c4 1c             	add    $0x1c,%esp
  80243d:	c3                   	ret    
  80243e:	66 90                	xchg   %ax,%ax
  802440:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802445:	b8 20 00 00 00       	mov    $0x20,%eax
  80244a:	89 ea                	mov    %ebp,%edx
  80244c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802450:	d3 e7                	shl    %cl,%edi
  802452:	89 c1                	mov    %eax,%ecx
  802454:	d3 ea                	shr    %cl,%edx
  802456:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80245b:	09 fa                	or     %edi,%edx
  80245d:	89 f7                	mov    %esi,%edi
  80245f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802463:	89 f2                	mov    %esi,%edx
  802465:	8b 74 24 08          	mov    0x8(%esp),%esi
  802469:	d3 e5                	shl    %cl,%ebp
  80246b:	89 c1                	mov    %eax,%ecx
  80246d:	d3 ef                	shr    %cl,%edi
  80246f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802474:	d3 e2                	shl    %cl,%edx
  802476:	89 c1                	mov    %eax,%ecx
  802478:	d3 ee                	shr    %cl,%esi
  80247a:	09 d6                	or     %edx,%esi
  80247c:	89 fa                	mov    %edi,%edx
  80247e:	89 f0                	mov    %esi,%eax
  802480:	f7 74 24 0c          	divl   0xc(%esp)
  802484:	89 d7                	mov    %edx,%edi
  802486:	89 c6                	mov    %eax,%esi
  802488:	f7 e5                	mul    %ebp
  80248a:	39 d7                	cmp    %edx,%edi
  80248c:	72 22                	jb     8024b0 <__udivdi3+0x110>
  80248e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802492:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802497:	d3 e5                	shl    %cl,%ebp
  802499:	39 c5                	cmp    %eax,%ebp
  80249b:	73 04                	jae    8024a1 <__udivdi3+0x101>
  80249d:	39 d7                	cmp    %edx,%edi
  80249f:	74 0f                	je     8024b0 <__udivdi3+0x110>
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	e9 46 ff ff ff       	jmp    8023f0 <__udivdi3+0x50>
  8024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024b9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024bd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024c1:	83 c4 1c             	add    $0x1c,%esp
  8024c4:	c3                   	ret    
	...

008024d0 <__umoddi3>:
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024d7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8024db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8024df:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024e3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024eb:	85 ed                	test   %ebp,%ebp
  8024ed:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8024f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f5:	89 cf                	mov    %ecx,%edi
  8024f7:	89 04 24             	mov    %eax,(%esp)
  8024fa:	89 f2                	mov    %esi,%edx
  8024fc:	75 1a                	jne    802518 <__umoddi3+0x48>
  8024fe:	39 f1                	cmp    %esi,%ecx
  802500:	76 4e                	jbe    802550 <__umoddi3+0x80>
  802502:	f7 f1                	div    %ecx
  802504:	89 d0                	mov    %edx,%eax
  802506:	31 d2                	xor    %edx,%edx
  802508:	8b 74 24 10          	mov    0x10(%esp),%esi
  80250c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802510:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802514:	83 c4 1c             	add    $0x1c,%esp
  802517:	c3                   	ret    
  802518:	39 f5                	cmp    %esi,%ebp
  80251a:	77 54                	ja     802570 <__umoddi3+0xa0>
  80251c:	0f bd c5             	bsr    %ebp,%eax
  80251f:	83 f0 1f             	xor    $0x1f,%eax
  802522:	89 44 24 04          	mov    %eax,0x4(%esp)
  802526:	75 60                	jne    802588 <__umoddi3+0xb8>
  802528:	3b 0c 24             	cmp    (%esp),%ecx
  80252b:	0f 87 07 01 00 00    	ja     802638 <__umoddi3+0x168>
  802531:	89 f2                	mov    %esi,%edx
  802533:	8b 34 24             	mov    (%esp),%esi
  802536:	29 ce                	sub    %ecx,%esi
  802538:	19 ea                	sbb    %ebp,%edx
  80253a:	89 34 24             	mov    %esi,(%esp)
  80253d:	8b 04 24             	mov    (%esp),%eax
  802540:	8b 74 24 10          	mov    0x10(%esp),%esi
  802544:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802548:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	c3                   	ret    
  802550:	85 c9                	test   %ecx,%ecx
  802552:	75 0b                	jne    80255f <__umoddi3+0x8f>
  802554:	b8 01 00 00 00       	mov    $0x1,%eax
  802559:	31 d2                	xor    %edx,%edx
  80255b:	f7 f1                	div    %ecx
  80255d:	89 c1                	mov    %eax,%ecx
  80255f:	89 f0                	mov    %esi,%eax
  802561:	31 d2                	xor    %edx,%edx
  802563:	f7 f1                	div    %ecx
  802565:	8b 04 24             	mov    (%esp),%eax
  802568:	f7 f1                	div    %ecx
  80256a:	eb 98                	jmp    802504 <__umoddi3+0x34>
  80256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802570:	89 f2                	mov    %esi,%edx
  802572:	8b 74 24 10          	mov    0x10(%esp),%esi
  802576:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80257a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	c3                   	ret    
  802582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802588:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258d:	89 e8                	mov    %ebp,%eax
  80258f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802594:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802598:	89 fa                	mov    %edi,%edx
  80259a:	d3 e0                	shl    %cl,%eax
  80259c:	89 e9                	mov    %ebp,%ecx
  80259e:	d3 ea                	shr    %cl,%edx
  8025a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025a5:	09 c2                	or     %eax,%edx
  8025a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025ab:	89 14 24             	mov    %edx,(%esp)
  8025ae:	89 f2                	mov    %esi,%edx
  8025b0:	d3 e7                	shl    %cl,%edi
  8025b2:	89 e9                	mov    %ebp,%ecx
  8025b4:	d3 ea                	shr    %cl,%edx
  8025b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025bf:	d3 e6                	shl    %cl,%esi
  8025c1:	89 e9                	mov    %ebp,%ecx
  8025c3:	d3 e8                	shr    %cl,%eax
  8025c5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ca:	09 f0                	or     %esi,%eax
  8025cc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8025d0:	f7 34 24             	divl   (%esp)
  8025d3:	d3 e6                	shl    %cl,%esi
  8025d5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025d9:	89 d6                	mov    %edx,%esi
  8025db:	f7 e7                	mul    %edi
  8025dd:	39 d6                	cmp    %edx,%esi
  8025df:	89 c1                	mov    %eax,%ecx
  8025e1:	89 d7                	mov    %edx,%edi
  8025e3:	72 3f                	jb     802624 <__umoddi3+0x154>
  8025e5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8025e9:	72 35                	jb     802620 <__umoddi3+0x150>
  8025eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025ef:	29 c8                	sub    %ecx,%eax
  8025f1:	19 fe                	sbb    %edi,%esi
  8025f3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025f8:	89 f2                	mov    %esi,%edx
  8025fa:	d3 e8                	shr    %cl,%eax
  8025fc:	89 e9                	mov    %ebp,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802605:	09 d0                	or     %edx,%eax
  802607:	89 f2                	mov    %esi,%edx
  802609:	d3 ea                	shr    %cl,%edx
  80260b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80260f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802613:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802617:	83 c4 1c             	add    $0x1c,%esp
  80261a:	c3                   	ret    
  80261b:	90                   	nop
  80261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802620:	39 d6                	cmp    %edx,%esi
  802622:	75 c7                	jne    8025eb <__umoddi3+0x11b>
  802624:	89 d7                	mov    %edx,%edi
  802626:	89 c1                	mov    %eax,%ecx
  802628:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80262c:	1b 3c 24             	sbb    (%esp),%edi
  80262f:	eb ba                	jmp    8025eb <__umoddi3+0x11b>
  802631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802638:	39 f5                	cmp    %esi,%ebp
  80263a:	0f 82 f1 fe ff ff    	jb     802531 <__umoddi3+0x61>
  802640:	e9 f8 fe ff ff       	jmp    80253d <__umoddi3+0x6d>
