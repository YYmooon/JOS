
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 cb 00 00 00       	call   8000fc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003e:	e8 89 0c 00 00       	call   800ccc <sys_getenvid>
  800043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004b:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  800052:	e8 b4 01 00 00       	call   80020b <cprintf>

	forkchild(cur, '0');
  800057:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005e:	00 
  80005f:	89 1c 24             	mov    %ebx,(%esp)
  800062:	e8 16 00 00 00       	call   80007d <forkchild>
	forkchild(cur, '1');
  800067:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80006e:	00 
  80006f:	89 1c 24             	mov    %ebx,(%esp)
  800072:	e8 06 00 00 00       	call   80007d <forkchild>
}
  800077:	83 c4 14             	add    $0x14,%esp
  80007a:	5b                   	pop    %ebx
  80007b:	5d                   	pop    %ebp
  80007c:	c3                   	ret    

0080007d <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80007d:	55                   	push   %ebp
  80007e:	89 e5                	mov    %esp,%ebp
  800080:	83 ec 38             	sub    $0x38,%esp
  800083:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800086:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800089:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80008c:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800090:	89 1c 24             	mov    %ebx,(%esp)
  800093:	e8 48 07 00 00       	call   8007e0 <strlen>
  800098:	83 f8 02             	cmp    $0x2,%eax
  80009b:	7f 41                	jg     8000de <forkchild+0x61>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80009d:	89 f0                	mov    %esi,%eax
  80009f:	0f be f0             	movsbl %al,%esi
  8000a2:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000a6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000aa:	c7 44 24 08 b1 26 80 	movl   $0x8026b1,0x8(%esp)
  8000b1:	00 
  8000b2:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000b9:	00 
  8000ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000bd:	89 04 24             	mov    %eax,(%esp)
  8000c0:	e8 e7 06 00 00       	call   8007ac <snprintf>
	if (fork() == 0) {
  8000c5:	e8 29 10 00 00       	call   8010f3 <fork>
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	75 10                	jne    8000de <forkchild+0x61>
		forktree(nxt);
  8000ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000d1:	89 04 24             	mov    %eax,(%esp)
  8000d4:	e8 5b ff ff ff       	call   800034 <forktree>
		exit();
  8000d9:	e8 6e 00 00 00       	call   80014c <exit>
	}
}
  8000de:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000e1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000e4:	89 ec                	mov    %ebp,%esp
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    

008000e8 <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000ee:	c7 04 24 b0 26 80 00 	movl   $0x8026b0,(%esp)
  8000f5:	e8 3a ff ff ff       	call   800034 <forktree>
}
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    

008000fc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	83 ec 18             	sub    $0x18,%esp
  800102:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800105:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800108:	8b 75 08             	mov    0x8(%ebp),%esi
  80010b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80010e:	e8 b9 0b 00 00       	call   800ccc <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 f6                	test   %esi,%esi
  800127:	7e 07                	jle    800130 <libmain+0x34>
		binaryname = argv[0];
  800129:	8b 03                	mov    (%ebx),%eax
  80012b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800134:	89 34 24             	mov    %esi,(%esp)
  800137:	e8 ac ff ff ff       	call   8000e8 <umain>

	// exit gracefully
	exit();
  80013c:	e8 0b 00 00 00       	call   80014c <exit>
}
  800141:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800144:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800147:	89 ec                	mov    %ebp,%esp
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    
	...

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800152:	e8 67 14 00 00       	call   8015be <close_all>
	sys_env_destroy(0);
  800157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015e:	e8 0c 0b 00 00       	call   800c6f <sys_env_destroy>
}
  800163:	c9                   	leave  
  800164:	c3                   	ret    
  800165:	00 00                	add    %al,(%eax)
	...

00800168 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	53                   	push   %ebx
  80016c:	83 ec 14             	sub    $0x14,%esp
  80016f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800172:	8b 03                	mov    (%ebx),%eax
  800174:	8b 55 08             	mov    0x8(%ebp),%edx
  800177:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80017b:	83 c0 01             	add    $0x1,%eax
  80017e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	75 19                	jne    8001a0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800187:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80018e:	00 
  80018f:	8d 43 08             	lea    0x8(%ebx),%eax
  800192:	89 04 24             	mov    %eax,(%esp)
  800195:	e8 76 0a 00 00       	call   800c10 <sys_cputs>
		b->idx = 0;
  80019a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001a0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a4:	83 c4 14             	add    $0x14,%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    

008001aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ba:	00 00 00 
	b.cnt = 0;
  8001bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	c7 04 24 68 01 80 00 	movl   $0x800168,(%esp)
  8001e6:	e8 9f 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001eb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 0d 0a 00 00       	call   800c10 <sys_cputs>

	return b.cnt;
}
  800203:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800211:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800214:	89 44 24 04          	mov    %eax,0x4(%esp)
  800218:	8b 45 08             	mov    0x8(%ebp),%eax
  80021b:	89 04 24             	mov    %eax,(%esp)
  80021e:	e8 87 ff ff ff       	call   8001aa <vcprintf>
	va_end(ap);

	return cnt;
}
  800223:	c9                   	leave  
  800224:	c3                   	ret    
	...

00800230 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 3c             	sub    $0x3c,%esp
  800239:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80023c:	89 d7                	mov    %edx,%edi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80024d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800250:	b8 00 00 00 00       	mov    $0x0,%eax
  800255:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800258:	72 11                	jb     80026b <printnum+0x3b>
  80025a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800260:	76 09                	jbe    80026b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 eb 01             	sub    $0x1,%ebx
  800265:	85 db                	test   %ebx,%ebx
  800267:	7f 51                	jg     8002ba <printnum+0x8a>
  800269:	eb 5e                	jmp    8002c9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800276:	8b 45 10             	mov    0x10(%ebp),%eax
  800279:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800281:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800285:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80028c:	00 
  80028d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800290:	89 04 24             	mov    %eax,(%esp)
  800293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029a:	e8 41 21 00 00       	call   8023e0 <__udivdi3>
  80029f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a7:	89 04 24             	mov    %eax,(%esp)
  8002aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ae:	89 fa                	mov    %edi,%edx
  8002b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b3:	e8 78 ff ff ff       	call   800230 <printnum>
  8002b8:	eb 0f                	jmp    8002c9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002be:	89 34 24             	mov    %esi,(%esp)
  8002c1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c4:	83 eb 01             	sub    $0x1,%ebx
  8002c7:	75 f1                	jne    8002ba <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002cd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002df:	00 
  8002e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e3:	89 04 24             	mov    %eax,(%esp)
  8002e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ed:	e8 1e 22 00 00       	call   802510 <__umoddi3>
  8002f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f6:	0f be 80 c0 26 80 00 	movsbl 0x8026c0(%eax),%eax
  8002fd:	89 04 24             	mov    %eax,(%esp)
  800300:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800303:	83 c4 3c             	add    $0x3c,%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80030e:	83 fa 01             	cmp    $0x1,%edx
  800311:	7e 0e                	jle    800321 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800313:	8b 10                	mov    (%eax),%edx
  800315:	8d 4a 08             	lea    0x8(%edx),%ecx
  800318:	89 08                	mov    %ecx,(%eax)
  80031a:	8b 02                	mov    (%edx),%eax
  80031c:	8b 52 04             	mov    0x4(%edx),%edx
  80031f:	eb 22                	jmp    800343 <getuint+0x38>
	else if (lflag)
  800321:	85 d2                	test   %edx,%edx
  800323:	74 10                	je     800335 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800325:	8b 10                	mov    (%eax),%edx
  800327:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032a:	89 08                	mov    %ecx,(%eax)
  80032c:	8b 02                	mov    (%edx),%eax
  80032e:	ba 00 00 00 00       	mov    $0x0,%edx
  800333:	eb 0e                	jmp    800343 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800335:	8b 10                	mov    (%eax),%edx
  800337:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033a:	89 08                	mov    %ecx,(%eax)
  80033c:	8b 02                	mov    (%edx),%eax
  80033e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80034f:	8b 10                	mov    (%eax),%edx
  800351:	3b 50 04             	cmp    0x4(%eax),%edx
  800354:	73 0a                	jae    800360 <sprintputch+0x1b>
		*b->buf++ = ch;
  800356:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800359:	88 0a                	mov    %cl,(%edx)
  80035b:	83 c2 01             	add    $0x1,%edx
  80035e:	89 10                	mov    %edx,(%eax)
}
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    

00800362 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800368:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	89 44 24 08          	mov    %eax,0x8(%esp)
  800376:	8b 45 0c             	mov    0xc(%ebp),%eax
  800379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	89 04 24             	mov    %eax,(%esp)
  800383:	e8 02 00 00 00       	call   80038a <vprintfmt>
	va_end(ap);
}
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	57                   	push   %edi
  80038e:	56                   	push   %esi
  80038f:	53                   	push   %ebx
  800390:	83 ec 4c             	sub    $0x4c,%esp
  800393:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800396:	8b 75 10             	mov    0x10(%ebp),%esi
  800399:	eb 12                	jmp    8003ad <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80039b:	85 c0                	test   %eax,%eax
  80039d:	0f 84 a9 03 00 00    	je     80074c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8003a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003a7:	89 04 24             	mov    %eax,(%esp)
  8003aa:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ad:	0f b6 06             	movzbl (%esi),%eax
  8003b0:	83 c6 01             	add    $0x1,%esi
  8003b3:	83 f8 25             	cmp    $0x25,%eax
  8003b6:	75 e3                	jne    80039b <vprintfmt+0x11>
  8003b8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8003c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003d7:	eb 2b                	jmp    800404 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003dc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003e0:	eb 22                	jmp    800404 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003e9:	eb 19                	jmp    800404 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8003ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003f5:	eb 0d                	jmp    800404 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800404:	0f b6 06             	movzbl (%esi),%eax
  800407:	0f b6 d0             	movzbl %al,%edx
  80040a:	8d 7e 01             	lea    0x1(%esi),%edi
  80040d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800410:	83 e8 23             	sub    $0x23,%eax
  800413:	3c 55                	cmp    $0x55,%al
  800415:	0f 87 0b 03 00 00    	ja     800726 <vprintfmt+0x39c>
  80041b:	0f b6 c0             	movzbl %al,%eax
  80041e:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800425:	83 ea 30             	sub    $0x30,%edx
  800428:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80042b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80042f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800435:	83 fa 09             	cmp    $0x9,%edx
  800438:	77 4a                	ja     800484 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80043d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800440:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800443:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800447:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80044a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80044d:	83 fa 09             	cmp    $0x9,%edx
  800450:	76 eb                	jbe    80043d <vprintfmt+0xb3>
  800452:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800455:	eb 2d                	jmp    800484 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8d 50 04             	lea    0x4(%eax),%edx
  80045d:	89 55 14             	mov    %edx,0x14(%ebp)
  800460:	8b 00                	mov    (%eax),%eax
  800462:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800468:	eb 1a                	jmp    800484 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80046d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800471:	79 91                	jns    800404 <vprintfmt+0x7a>
  800473:	e9 73 ff ff ff       	jmp    8003eb <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80047b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800482:	eb 80                	jmp    800404 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800484:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800488:	0f 89 76 ff ff ff    	jns    800404 <vprintfmt+0x7a>
  80048e:	e9 64 ff ff ff       	jmp    8003f7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800493:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800499:	e9 66 ff ff ff       	jmp    800404 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 50 04             	lea    0x4(%eax),%edx
  8004a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 04 24             	mov    %eax,(%esp)
  8004b0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004b6:	e9 f2 fe ff ff       	jmp    8003ad <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 50 04             	lea    0x4(%eax),%edx
  8004c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 c2                	mov    %eax,%edx
  8004c8:	c1 fa 1f             	sar    $0x1f,%edx
  8004cb:	31 d0                	xor    %edx,%eax
  8004cd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cf:	83 f8 0f             	cmp    $0xf,%eax
  8004d2:	7f 0b                	jg     8004df <vprintfmt+0x155>
  8004d4:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  8004db:	85 d2                	test   %edx,%edx
  8004dd:	75 23                	jne    800502 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8004df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e3:	c7 44 24 08 d8 26 80 	movl   $0x8026d8,0x8(%esp)
  8004ea:	00 
  8004eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004f2:	89 3c 24             	mov    %edi,(%esp)
  8004f5:	e8 68 fe ff ff       	call   800362 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004fd:	e9 ab fe ff ff       	jmp    8003ad <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800502:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800506:	c7 44 24 08 31 2c 80 	movl   $0x802c31,0x8(%esp)
  80050d:	00 
  80050e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800512:	8b 7d 08             	mov    0x8(%ebp),%edi
  800515:	89 3c 24             	mov    %edi,(%esp)
  800518:	e8 45 fe ff ff       	call   800362 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800520:	e9 88 fe ff ff       	jmp    8003ad <vprintfmt+0x23>
  800525:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 50 04             	lea    0x4(%eax),%edx
  800534:	89 55 14             	mov    %edx,0x14(%ebp)
  800537:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800539:	85 f6                	test   %esi,%esi
  80053b:	ba d1 26 80 00       	mov    $0x8026d1,%edx
  800540:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800543:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800547:	7e 06                	jle    80054f <vprintfmt+0x1c5>
  800549:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80054d:	75 10                	jne    80055f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054f:	0f be 06             	movsbl (%esi),%eax
  800552:	83 c6 01             	add    $0x1,%esi
  800555:	85 c0                	test   %eax,%eax
  800557:	0f 85 86 00 00 00    	jne    8005e3 <vprintfmt+0x259>
  80055d:	eb 76                	jmp    8005d5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80055f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800563:	89 34 24             	mov    %esi,(%esp)
  800566:	e8 90 02 00 00       	call   8007fb <strnlen>
  80056b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056e:	29 c2                	sub    %eax,%edx
  800570:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800573:	85 d2                	test   %edx,%edx
  800575:	7e d8                	jle    80054f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800577:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80057b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80057e:	89 d6                	mov    %edx,%esi
  800580:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800583:	89 c7                	mov    %eax,%edi
  800585:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800589:	89 3c 24             	mov    %edi,(%esp)
  80058c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058f:	83 ee 01             	sub    $0x1,%esi
  800592:	75 f1                	jne    800585 <vprintfmt+0x1fb>
  800594:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800597:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80059a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80059d:	eb b0                	jmp    80054f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80059f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a3:	74 18                	je     8005bd <vprintfmt+0x233>
  8005a5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005a8:	83 fa 5e             	cmp    $0x5e,%edx
  8005ab:	76 10                	jbe    8005bd <vprintfmt+0x233>
					putch('?', putdat);
  8005ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005b1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b8:	ff 55 08             	call   *0x8(%ebp)
  8005bb:	eb 0a                	jmp    8005c7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8005bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c1:	89 04 24             	mov    %eax,(%esp)
  8005c4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005cb:	0f be 06             	movsbl (%esi),%eax
  8005ce:	83 c6 01             	add    $0x1,%esi
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	75 0e                	jne    8005e3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005dc:	7f 16                	jg     8005f4 <vprintfmt+0x26a>
  8005de:	e9 ca fd ff ff       	jmp    8003ad <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e3:	85 ff                	test   %edi,%edi
  8005e5:	78 b8                	js     80059f <vprintfmt+0x215>
  8005e7:	83 ef 01             	sub    $0x1,%edi
  8005ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8005f0:	79 ad                	jns    80059f <vprintfmt+0x215>
  8005f2:	eb e1                	jmp    8005d5 <vprintfmt+0x24b>
  8005f4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005f7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005fe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800605:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800607:	83 ee 01             	sub    $0x1,%esi
  80060a:	75 ee                	jne    8005fa <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80060f:	e9 99 fd ff ff       	jmp    8003ad <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800614:	83 f9 01             	cmp    $0x1,%ecx
  800617:	7e 10                	jle    800629 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 50 08             	lea    0x8(%eax),%edx
  80061f:	89 55 14             	mov    %edx,0x14(%ebp)
  800622:	8b 30                	mov    (%eax),%esi
  800624:	8b 78 04             	mov    0x4(%eax),%edi
  800627:	eb 26                	jmp    80064f <vprintfmt+0x2c5>
	else if (lflag)
  800629:	85 c9                	test   %ecx,%ecx
  80062b:	74 12                	je     80063f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 50 04             	lea    0x4(%eax),%edx
  800633:	89 55 14             	mov    %edx,0x14(%ebp)
  800636:	8b 30                	mov    (%eax),%esi
  800638:	89 f7                	mov    %esi,%edi
  80063a:	c1 ff 1f             	sar    $0x1f,%edi
  80063d:	eb 10                	jmp    80064f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	89 55 14             	mov    %edx,0x14(%ebp)
  800648:	8b 30                	mov    (%eax),%esi
  80064a:	89 f7                	mov    %esi,%edi
  80064c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80064f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800654:	85 ff                	test   %edi,%edi
  800656:	0f 89 8c 00 00 00    	jns    8006e8 <vprintfmt+0x35e>
				putch('-', putdat);
  80065c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800660:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800667:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80066a:	f7 de                	neg    %esi
  80066c:	83 d7 00             	adc    $0x0,%edi
  80066f:	f7 df                	neg    %edi
			}
			base = 10;
  800671:	b8 0a 00 00 00       	mov    $0xa,%eax
  800676:	eb 70                	jmp    8006e8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800678:	89 ca                	mov    %ecx,%edx
  80067a:	8d 45 14             	lea    0x14(%ebp),%eax
  80067d:	e8 89 fc ff ff       	call   80030b <getuint>
  800682:	89 c6                	mov    %eax,%esi
  800684:	89 d7                	mov    %edx,%edi
			base = 10;
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80068b:	eb 5b                	jmp    8006e8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80068d:	89 ca                	mov    %ecx,%edx
  80068f:	8d 45 14             	lea    0x14(%ebp),%eax
  800692:	e8 74 fc ff ff       	call   80030b <getuint>
  800697:	89 c6                	mov    %eax,%esi
  800699:	89 d7                	mov    %edx,%edi
			base = 8;
  80069b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006a0:	eb 46                	jmp    8006e8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8006a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006ad:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006b4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006bb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 50 04             	lea    0x4(%eax),%edx
  8006c4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006c7:	8b 30                	mov    (%eax),%esi
  8006c9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ce:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006d3:	eb 13                	jmp    8006e8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006d5:	89 ca                	mov    %ecx,%edx
  8006d7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006da:	e8 2c fc ff ff       	call   80030b <getuint>
  8006df:	89 c6                	mov    %eax,%esi
  8006e1:	89 d7                	mov    %edx,%edi
			base = 16;
  8006e3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006e8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8006ec:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006fb:	89 34 24             	mov    %esi,(%esp)
  8006fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800702:	89 da                	mov    %ebx,%edx
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	e8 24 fb ff ff       	call   800230 <printnum>
			break;
  80070c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80070f:	e9 99 fc ff ff       	jmp    8003ad <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800714:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800718:	89 14 24             	mov    %edx,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800721:	e9 87 fc ff ff       	jmp    8003ad <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800726:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80072a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800731:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800734:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800738:	0f 84 6f fc ff ff    	je     8003ad <vprintfmt+0x23>
  80073e:	83 ee 01             	sub    $0x1,%esi
  800741:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800745:	75 f7                	jne    80073e <vprintfmt+0x3b4>
  800747:	e9 61 fc ff ff       	jmp    8003ad <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80074c:	83 c4 4c             	add    $0x4c,%esp
  80074f:	5b                   	pop    %ebx
  800750:	5e                   	pop    %esi
  800751:	5f                   	pop    %edi
  800752:	5d                   	pop    %ebp
  800753:	c3                   	ret    

00800754 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 28             	sub    $0x28,%esp
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800760:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800763:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800767:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800771:	85 c0                	test   %eax,%eax
  800773:	74 30                	je     8007a5 <vsnprintf+0x51>
  800775:	85 d2                	test   %edx,%edx
  800777:	7e 2c                	jle    8007a5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	89 44 24 08          	mov    %eax,0x8(%esp)
  800787:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078e:	c7 04 24 45 03 80 00 	movl   $0x800345,(%esp)
  800795:	e8 f0 fb ff ff       	call   80038a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a3:	eb 05                	jmp    8007aa <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007aa:	c9                   	leave  
  8007ab:	c3                   	ret    

008007ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	89 04 24             	mov    %eax,(%esp)
  8007cd:	e8 82 ff ff ff       	call   800754 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    
	...

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	80 3a 00             	cmpb   $0x0,(%edx)
  8007ee:	74 09                	je     8007f9 <strlen+0x19>
		n++;
  8007f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f7:	75 f7                	jne    8007f0 <strlen+0x10>
		n++;
	return n;
}
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	53                   	push   %ebx
  8007ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800802:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	85 c9                	test   %ecx,%ecx
  80080c:	74 1a                	je     800828 <strnlen+0x2d>
  80080e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800811:	74 15                	je     800828 <strnlen+0x2d>
  800813:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800818:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081a:	39 ca                	cmp    %ecx,%edx
  80081c:	74 0a                	je     800828 <strnlen+0x2d>
  80081e:	83 c2 01             	add    $0x1,%edx
  800821:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800826:	75 f0                	jne    800818 <strnlen+0x1d>
		n++;
	return n;
}
  800828:	5b                   	pop    %ebx
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80083e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800841:	83 c2 01             	add    $0x1,%edx
  800844:	84 c9                	test   %cl,%cl
  800846:	75 f2                	jne    80083a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800848:	5b                   	pop    %ebx
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800855:	89 1c 24             	mov    %ebx,(%esp)
  800858:	e8 83 ff ff ff       	call   8007e0 <strlen>
	strcpy(dst + len, src);
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800860:	89 54 24 04          	mov    %edx,0x4(%esp)
  800864:	01 d8                	add    %ebx,%eax
  800866:	89 04 24             	mov    %eax,(%esp)
  800869:	e8 bd ff ff ff       	call   80082b <strcpy>
	return dst;
}
  80086e:	89 d8                	mov    %ebx,%eax
  800870:	83 c4 08             	add    $0x8,%esp
  800873:	5b                   	pop    %ebx
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800884:	85 f6                	test   %esi,%esi
  800886:	74 18                	je     8008a0 <strncpy+0x2a>
  800888:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80088d:	0f b6 1a             	movzbl (%edx),%ebx
  800890:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800893:	80 3a 01             	cmpb   $0x1,(%edx)
  800896:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800899:	83 c1 01             	add    $0x1,%ecx
  80089c:	39 f1                	cmp    %esi,%ecx
  80089e:	75 ed                	jne    80088d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008a0:	5b                   	pop    %ebx
  8008a1:	5e                   	pop    %esi
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	57                   	push   %edi
  8008a8:	56                   	push   %esi
  8008a9:	53                   	push   %ebx
  8008aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008b0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b3:	89 f8                	mov    %edi,%eax
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	74 2b                	je     8008e4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8008b9:	83 fe 01             	cmp    $0x1,%esi
  8008bc:	74 23                	je     8008e1 <strlcpy+0x3d>
  8008be:	0f b6 0b             	movzbl (%ebx),%ecx
  8008c1:	84 c9                	test   %cl,%cl
  8008c3:	74 1c                	je     8008e1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  8008c5:	83 ee 02             	sub    $0x2,%esi
  8008c8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008cd:	88 08                	mov    %cl,(%eax)
  8008cf:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008d2:	39 f2                	cmp    %esi,%edx
  8008d4:	74 0b                	je     8008e1 <strlcpy+0x3d>
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008dd:	84 c9                	test   %cl,%cl
  8008df:	75 ec                	jne    8008cd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8008e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e4:	29 f8                	sub    %edi,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f4:	0f b6 01             	movzbl (%ecx),%eax
  8008f7:	84 c0                	test   %al,%al
  8008f9:	74 16                	je     800911 <strcmp+0x26>
  8008fb:	3a 02                	cmp    (%edx),%al
  8008fd:	75 12                	jne    800911 <strcmp+0x26>
		p++, q++;
  8008ff:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800902:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800906:	84 c0                	test   %al,%al
  800908:	74 07                	je     800911 <strcmp+0x26>
  80090a:	83 c1 01             	add    $0x1,%ecx
  80090d:	3a 02                	cmp    (%edx),%al
  80090f:	74 ee                	je     8008ff <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800911:	0f b6 c0             	movzbl %al,%eax
  800914:	0f b6 12             	movzbl (%edx),%edx
  800917:	29 d0                	sub    %edx,%eax
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	53                   	push   %ebx
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800925:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80092d:	85 d2                	test   %edx,%edx
  80092f:	74 28                	je     800959 <strncmp+0x3e>
  800931:	0f b6 01             	movzbl (%ecx),%eax
  800934:	84 c0                	test   %al,%al
  800936:	74 24                	je     80095c <strncmp+0x41>
  800938:	3a 03                	cmp    (%ebx),%al
  80093a:	75 20                	jne    80095c <strncmp+0x41>
  80093c:	83 ea 01             	sub    $0x1,%edx
  80093f:	74 13                	je     800954 <strncmp+0x39>
		n--, p++, q++;
  800941:	83 c1 01             	add    $0x1,%ecx
  800944:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800947:	0f b6 01             	movzbl (%ecx),%eax
  80094a:	84 c0                	test   %al,%al
  80094c:	74 0e                	je     80095c <strncmp+0x41>
  80094e:	3a 03                	cmp    (%ebx),%al
  800950:	74 ea                	je     80093c <strncmp+0x21>
  800952:	eb 08                	jmp    80095c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800959:	5b                   	pop    %ebx
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80095c:	0f b6 01             	movzbl (%ecx),%eax
  80095f:	0f b6 13             	movzbl (%ebx),%edx
  800962:	29 d0                	sub    %edx,%eax
  800964:	eb f3                	jmp    800959 <strncmp+0x3e>

00800966 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800970:	0f b6 10             	movzbl (%eax),%edx
  800973:	84 d2                	test   %dl,%dl
  800975:	74 1c                	je     800993 <strchr+0x2d>
		if (*s == c)
  800977:	38 ca                	cmp    %cl,%dl
  800979:	75 09                	jne    800984 <strchr+0x1e>
  80097b:	eb 1b                	jmp    800998 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80097d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800980:	38 ca                	cmp    %cl,%dl
  800982:	74 14                	je     800998 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800984:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800988:	84 d2                	test   %dl,%dl
  80098a:	75 f1                	jne    80097d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80098c:	b8 00 00 00 00       	mov    $0x0,%eax
  800991:	eb 05                	jmp    800998 <strchr+0x32>
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a4:	0f b6 10             	movzbl (%eax),%edx
  8009a7:	84 d2                	test   %dl,%dl
  8009a9:	74 14                	je     8009bf <strfind+0x25>
		if (*s == c)
  8009ab:	38 ca                	cmp    %cl,%dl
  8009ad:	75 06                	jne    8009b5 <strfind+0x1b>
  8009af:	eb 0e                	jmp    8009bf <strfind+0x25>
  8009b1:	38 ca                	cmp    %cl,%dl
  8009b3:	74 0a                	je     8009bf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	0f b6 10             	movzbl (%eax),%edx
  8009bb:	84 d2                	test   %dl,%dl
  8009bd:	75 f2                	jne    8009b1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 0c             	sub    $0xc,%esp
  8009c7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009ca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009cd:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8009d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d9:	85 c9                	test   %ecx,%ecx
  8009db:	74 30                	je     800a0d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009dd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e3:	75 25                	jne    800a0a <memset+0x49>
  8009e5:	f6 c1 03             	test   $0x3,%cl
  8009e8:	75 20                	jne    800a0a <memset+0x49>
		c &= 0xFF;
  8009ea:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ed:	89 d3                	mov    %edx,%ebx
  8009ef:	c1 e3 08             	shl    $0x8,%ebx
  8009f2:	89 d6                	mov    %edx,%esi
  8009f4:	c1 e6 18             	shl    $0x18,%esi
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	c1 e0 10             	shl    $0x10,%eax
  8009fc:	09 f0                	or     %esi,%eax
  8009fe:	09 d0                	or     %edx,%eax
  800a00:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a02:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a05:	fc                   	cld    
  800a06:	f3 ab                	rep stos %eax,%es:(%edi)
  800a08:	eb 03                	jmp    800a0d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a18:	89 ec                	mov    %ebp,%esp
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a25:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a31:	39 c6                	cmp    %eax,%esi
  800a33:	73 36                	jae    800a6b <memmove+0x4f>
  800a35:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a38:	39 d0                	cmp    %edx,%eax
  800a3a:	73 2f                	jae    800a6b <memmove+0x4f>
		s += n;
		d += n;
  800a3c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3f:	f6 c2 03             	test   $0x3,%dl
  800a42:	75 1b                	jne    800a5f <memmove+0x43>
  800a44:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4a:	75 13                	jne    800a5f <memmove+0x43>
  800a4c:	f6 c1 03             	test   $0x3,%cl
  800a4f:	75 0e                	jne    800a5f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a51:	83 ef 04             	sub    $0x4,%edi
  800a54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a5a:	fd                   	std    
  800a5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5d:	eb 09                	jmp    800a68 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a65:	fd                   	std    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a68:	fc                   	cld    
  800a69:	eb 20                	jmp    800a8b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a71:	75 13                	jne    800a86 <memmove+0x6a>
  800a73:	a8 03                	test   $0x3,%al
  800a75:	75 0f                	jne    800a86 <memmove+0x6a>
  800a77:	f6 c1 03             	test   $0x3,%cl
  800a7a:	75 0a                	jne    800a86 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a7f:	89 c7                	mov    %eax,%edi
  800a81:	fc                   	cld    
  800a82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a84:	eb 05                	jmp    800a8b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a86:	89 c7                	mov    %eax,%edi
  800a88:	fc                   	cld    
  800a89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a8b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a8e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a91:	89 ec                	mov    %ebp,%esp
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	89 04 24             	mov    %eax,(%esp)
  800aaf:	e8 68 ff ff ff       	call   800a1c <memmove>
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800abf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aca:	85 ff                	test   %edi,%edi
  800acc:	74 37                	je     800b05 <memcmp+0x4f>
		if (*s1 != *s2)
  800ace:	0f b6 03             	movzbl (%ebx),%eax
  800ad1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800adc:	38 c8                	cmp    %cl,%al
  800ade:	74 1c                	je     800afc <memcmp+0x46>
  800ae0:	eb 10                	jmp    800af2 <memcmp+0x3c>
  800ae2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ae7:	83 c2 01             	add    $0x1,%edx
  800aea:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800aee:	38 c8                	cmp    %cl,%al
  800af0:	74 0a                	je     800afc <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800af2:	0f b6 c0             	movzbl %al,%eax
  800af5:	0f b6 c9             	movzbl %cl,%ecx
  800af8:	29 c8                	sub    %ecx,%eax
  800afa:	eb 09                	jmp    800b05 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afc:	39 fa                	cmp    %edi,%edx
  800afe:	75 e2                	jne    800ae2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b10:	89 c2                	mov    %eax,%edx
  800b12:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b15:	39 d0                	cmp    %edx,%eax
  800b17:	73 19                	jae    800b32 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b1d:	38 08                	cmp    %cl,(%eax)
  800b1f:	75 06                	jne    800b27 <memfind+0x1d>
  800b21:	eb 0f                	jmp    800b32 <memfind+0x28>
  800b23:	38 08                	cmp    %cl,(%eax)
  800b25:	74 0b                	je     800b32 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b27:	83 c0 01             	add    $0x1,%eax
  800b2a:	39 d0                	cmp    %edx,%eax
  800b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b30:	75 f1                	jne    800b23 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b40:	0f b6 02             	movzbl (%edx),%eax
  800b43:	3c 20                	cmp    $0x20,%al
  800b45:	74 04                	je     800b4b <strtol+0x17>
  800b47:	3c 09                	cmp    $0x9,%al
  800b49:	75 0e                	jne    800b59 <strtol+0x25>
		s++;
  800b4b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4e:	0f b6 02             	movzbl (%edx),%eax
  800b51:	3c 20                	cmp    $0x20,%al
  800b53:	74 f6                	je     800b4b <strtol+0x17>
  800b55:	3c 09                	cmp    $0x9,%al
  800b57:	74 f2                	je     800b4b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b59:	3c 2b                	cmp    $0x2b,%al
  800b5b:	75 0a                	jne    800b67 <strtol+0x33>
		s++;
  800b5d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b60:	bf 00 00 00 00       	mov    $0x0,%edi
  800b65:	eb 10                	jmp    800b77 <strtol+0x43>
  800b67:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b6c:	3c 2d                	cmp    $0x2d,%al
  800b6e:	75 07                	jne    800b77 <strtol+0x43>
		s++, neg = 1;
  800b70:	83 c2 01             	add    $0x1,%edx
  800b73:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b77:	85 db                	test   %ebx,%ebx
  800b79:	0f 94 c0             	sete   %al
  800b7c:	74 05                	je     800b83 <strtol+0x4f>
  800b7e:	83 fb 10             	cmp    $0x10,%ebx
  800b81:	75 15                	jne    800b98 <strtol+0x64>
  800b83:	80 3a 30             	cmpb   $0x30,(%edx)
  800b86:	75 10                	jne    800b98 <strtol+0x64>
  800b88:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b8c:	75 0a                	jne    800b98 <strtol+0x64>
		s += 2, base = 16;
  800b8e:	83 c2 02             	add    $0x2,%edx
  800b91:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b96:	eb 13                	jmp    800bab <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800b98:	84 c0                	test   %al,%al
  800b9a:	74 0f                	je     800bab <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba1:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba4:	75 05                	jne    800bab <strtol+0x77>
		s++, base = 8;
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb2:	0f b6 0a             	movzbl (%edx),%ecx
  800bb5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bb8:	80 fb 09             	cmp    $0x9,%bl
  800bbb:	77 08                	ja     800bc5 <strtol+0x91>
			dig = *s - '0';
  800bbd:	0f be c9             	movsbl %cl,%ecx
  800bc0:	83 e9 30             	sub    $0x30,%ecx
  800bc3:	eb 1e                	jmp    800be3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800bc5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 08                	ja     800bd5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800bcd:	0f be c9             	movsbl %cl,%ecx
  800bd0:	83 e9 57             	sub    $0x57,%ecx
  800bd3:	eb 0e                	jmp    800be3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800bd5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800bd8:	80 fb 19             	cmp    $0x19,%bl
  800bdb:	77 14                	ja     800bf1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800bdd:	0f be c9             	movsbl %cl,%ecx
  800be0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800be3:	39 f1                	cmp    %esi,%ecx
  800be5:	7d 0e                	jge    800bf5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be7:	83 c2 01             	add    $0x1,%edx
  800bea:	0f af c6             	imul   %esi,%eax
  800bed:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800bef:	eb c1                	jmp    800bb2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800bf1:	89 c1                	mov    %eax,%ecx
  800bf3:	eb 02                	jmp    800bf7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfb:	74 05                	je     800c02 <strtol+0xce>
		*endptr = (char *) s;
  800bfd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c00:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c02:	89 ca                	mov    %ecx,%edx
  800c04:	f7 da                	neg    %edx
  800c06:	85 ff                	test   %edi,%edi
  800c08:	0f 45 c2             	cmovne %edx,%eax
}
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	89 c3                	mov    %eax,%ebx
  800c2c:	89 c7                	mov    %eax,%edi
  800c2e:	89 c6                	mov    %eax,%esi
  800c30:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c32:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c35:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c38:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c3b:	89 ec                	mov    %ebp,%esp
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 0c             	sub    $0xc,%esp
  800c45:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c48:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c4b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	b8 01 00 00 00       	mov    $0x1,%eax
  800c58:	89 d1                	mov    %edx,%ecx
  800c5a:	89 d3                	mov    %edx,%ebx
  800c5c:	89 d7                	mov    %edx,%edi
  800c5e:	89 d6                	mov    %edx,%esi
  800c60:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c62:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c65:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c68:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c6b:	89 ec                	mov    %ebp,%esp
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 38             	sub    $0x38,%esp
  800c75:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c78:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c7b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c83:	b8 03 00 00 00       	mov    $0x3,%eax
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	89 cb                	mov    %ecx,%ebx
  800c8d:	89 cf                	mov    %ecx,%edi
  800c8f:	89 ce                	mov    %ecx,%esi
  800c91:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c93:	85 c0                	test   %eax,%eax
  800c95:	7e 28                	jle    800cbf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c9b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca2:	00 
  800ca3:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800caa:	00 
  800cab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb2:	00 
  800cb3:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800cba:	e8 d1 14 00 00       	call   802190 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cc2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cc5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cc8:	89 ec                	mov    %ebp,%esp
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 0c             	sub    $0xc,%esp
  800cd2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cd5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cd8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	89 d3                	mov    %edx,%ebx
  800ce9:	89 d7                	mov    %edx,%edi
  800ceb:	89 d6                	mov    %edx,%esi
  800ced:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cf2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cf5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cf8:	89 ec                	mov    %ebp,%esp
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_yield>:

void
sys_yield(void)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d05:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d08:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d28:	89 ec                	mov    %ebp,%esp
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 38             	sub    $0x38,%esp
  800d32:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d35:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d38:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3b:	be 00 00 00 00       	mov    $0x0,%esi
  800d40:	b8 04 00 00 00       	mov    $0x4,%eax
  800d45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	89 f7                	mov    %esi,%edi
  800d50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7e 28                	jle    800d7e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d61:	00 
  800d62:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800d69:	00 
  800d6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d71:	00 
  800d72:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800d79:	e8 12 14 00 00       	call   802190 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d81:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d84:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d87:	89 ec                	mov    %ebp,%esp
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 38             	sub    $0x38,%esp
  800d91:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d94:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d97:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9f:	8b 75 18             	mov    0x18(%ebp),%esi
  800da2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	7e 28                	jle    800ddc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dbf:	00 
  800dc0:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800dc7:	00 
  800dc8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcf:	00 
  800dd0:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800dd7:	e8 b4 13 00 00       	call   802190 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ddf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de5:	89 ec                	mov    %ebp,%esp
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 38             	sub    $0x38,%esp
  800def:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7e 28                	jle    800e3a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e16:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800e25:	00 
  800e26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2d:	00 
  800e2e:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800e35:	e8 56 13 00 00       	call   802190 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e3a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e40:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e43:	89 ec                	mov    %ebp,%esp
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 38             	sub    $0x38,%esp
  800e4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e53:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7e 28                	jle    800e98 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e74:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800e83:	00 
  800e84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8b:	00 
  800e8c:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800e93:	e8 f8 12 00 00       	call   802190 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e98:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea1:	89 ec                	mov    %ebp,%esp
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 38             	sub    $0x38,%esp
  800eab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	b8 09 00 00 00       	mov    $0x9,%eax
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7e 28                	jle    800ef6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ece:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ed9:	00 
  800eda:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee9:	00 
  800eea:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800ef1:	e8 9a 12 00 00       	call   802190 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eff:	89 ec                	mov    %ebp,%esp
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 38             	sub    $0x38,%esp
  800f09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7e 28                	jle    800f54 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f30:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f37:	00 
  800f38:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800f3f:	00 
  800f40:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f47:	00 
  800f48:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800f4f:	e8 3c 12 00 00       	call   802190 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f54:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f57:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5d:	89 ec                	mov    %ebp,%esp
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f70:	be 00 00 00 00       	mov    $0x0,%esi
  800f75:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f88:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f91:	89 ec                	mov    %ebp,%esp
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 38             	sub    $0x38,%esp
  800f9b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	89 cb                	mov    %ecx,%ebx
  800fb3:	89 cf                	mov    %ecx,%edi
  800fb5:	89 ce                	mov    %ecx,%esi
  800fb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7e 28                	jle    800fe5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd8:	00 
  800fd9:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800fe0:	e8 ab 11 00 00       	call   802190 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800feb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fee:	89 ec                	mov    %ebp,%esp
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
	...

00800ff4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 24             	sub    $0x24,%esp
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffe:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801000:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801004:	74 21                	je     801027 <pgfault+0x33>
  801006:	89 d8                	mov    %ebx,%eax
  801008:	c1 e8 16             	shr    $0x16,%eax
  80100b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801012:	a8 01                	test   $0x1,%al
  801014:	74 11                	je     801027 <pgfault+0x33>
  801016:	89 d8                	mov    %ebx,%eax
  801018:	c1 e8 0c             	shr    $0xc,%eax
  80101b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801022:	f6 c4 08             	test   $0x8,%ah
  801025:	75 1c                	jne    801043 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801027:	c7 44 24 08 ec 29 80 	movl   $0x8029ec,0x8(%esp)
  80102e:	00 
  80102f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801036:	00 
  801037:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  80103e:	e8 4d 11 00 00       	call   802190 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801043:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80104a:	00 
  80104b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801052:	00 
  801053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80105a:	e8 cd fc ff ff       	call   800d2c <sys_page_alloc>
  80105f:	85 c0                	test   %eax,%eax
  801061:	79 20                	jns    801083 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801067:	c7 44 24 08 28 2a 80 	movl   $0x802a28,0x8(%esp)
  80106e:	00 
  80106f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801076:	00 
  801077:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  80107e:	e8 0d 11 00 00       	call   802190 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801083:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801089:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801090:	00 
  801091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801095:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80109c:	e8 7b f9 ff ff       	call   800a1c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8010a1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010a8:	00 
  8010a9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010b4:	00 
  8010b5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010bc:	00 
  8010bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010c4:	e8 c2 fc ff ff       	call   800d8b <sys_page_map>
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	79 20                	jns    8010ed <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  8010cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010d1:	c7 44 24 08 50 2a 80 	movl   $0x802a50,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  8010e8:	e8 a3 10 00 00       	call   802190 <_panic>
	//panic("pgfault not implemented");
}
  8010ed:	83 c4 24             	add    $0x24,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  8010fc:	c7 04 24 f4 0f 80 00 	movl   $0x800ff4,(%esp)
  801103:	e8 e0 10 00 00       	call   8021e8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801108:	ba 07 00 00 00       	mov    $0x7,%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	cd 30                	int    $0x30
  801111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801114:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801116:	85 c0                	test   %eax,%eax
  801118:	79 20                	jns    80113a <fork+0x47>
		panic("sys_exofork: %e", envid);
  80111a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80111e:	c7 44 24 08 4e 2b 80 	movl   $0x802b4e,0x8(%esp)
  801125:	00 
  801126:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80112d:	00 
  80112e:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  801135:	e8 56 10 00 00       	call   802190 <_panic>
	if (envid == 0) {
  80113a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80113f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801143:	75 1c                	jne    801161 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801145:	e8 82 fb ff ff       	call   800ccc <sys_getenvid>
  80114a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801152:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801157:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80115c:	e9 06 02 00 00       	jmp    801367 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801161:	89 d8                	mov    %ebx,%eax
  801163:	c1 e8 16             	shr    $0x16,%eax
  801166:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80116d:	a8 01                	test   $0x1,%al
  80116f:	0f 84 57 01 00 00    	je     8012cc <fork+0x1d9>
  801175:	89 de                	mov    %ebx,%esi
  801177:	c1 ee 0c             	shr    $0xc,%esi
  80117a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801181:	a8 01                	test   $0x1,%al
  801183:	0f 84 43 01 00 00    	je     8012cc <fork+0x1d9>
  801189:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801190:	a8 04                	test   $0x4,%al
  801192:	0f 84 34 01 00 00    	je     8012cc <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801198:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80119b:	89 f0                	mov    %esi,%eax
  80119d:	c1 e8 0c             	shr    $0xc,%eax
  8011a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  8011a7:	f6 c4 04             	test   $0x4,%ah
  8011aa:	74 45                	je     8011f1 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  8011ac:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c8:	e8 be fb ff ff       	call   800d8b <sys_page_map>
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	0f 89 f7 00 00 00    	jns    8012cc <fork+0x1d9>
			panic ("duppage: error at lab5");
  8011d5:	c7 44 24 08 5e 2b 80 	movl   $0x802b5e,0x8(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  8011e4:	00 
  8011e5:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  8011ec:	e8 9f 0f 00 00       	call   802190 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  8011f1:	a9 02 08 00 00       	test   $0x802,%eax
  8011f6:	0f 84 8c 00 00 00    	je     801288 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8011fc:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801203:	00 
  801204:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801208:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80120c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801217:	e8 6f fb ff ff       	call   800d8b <sys_page_map>
  80121c:	85 c0                	test   %eax,%eax
  80121e:	79 20                	jns    801240 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801224:	c7 44 24 08 74 2a 80 	movl   $0x802a74,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  80123b:	e8 50 0f 00 00       	call   802190 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801240:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801247:	00 
  801248:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80124c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801253:	00 
  801254:	89 74 24 04          	mov    %esi,0x4(%esp)
  801258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125f:	e8 27 fb ff ff       	call   800d8b <sys_page_map>
  801264:	85 c0                	test   %eax,%eax
  801266:	79 64                	jns    8012cc <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126c:	c7 44 24 08 a0 2a 80 	movl   $0x802aa0,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  801283:	e8 08 0f 00 00       	call   802190 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801288:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80128f:	00 
  801290:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801294:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801298:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a3:	e8 e3 fa ff ff       	call   800d8b <sys_page_map>
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	79 20                	jns    8012cc <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  8012ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b0:	c7 44 24 08 cc 2a 80 	movl   $0x802acc,0x8(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8012bf:	00 
  8012c0:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  8012c7:	e8 c4 0e 00 00       	call   802190 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  8012cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012d2:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012d8:	0f 85 83 fe ff ff    	jne    801161 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  8012de:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012e5:	00 
  8012e6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012ed:	ee 
  8012ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f1:	89 04 24             	mov    %eax,(%esp)
  8012f4:	e8 33 fa ff ff       	call   800d2c <sys_page_alloc>
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	79 20                	jns    80131d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  8012fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801301:	c7 44 24 08 f8 2a 80 	movl   $0x802af8,0x8(%esp)
  801308:	00 
  801309:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801310:	00 
  801311:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  801318:	e8 73 0e 00 00       	call   802190 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80131d:	c7 44 24 04 58 22 80 	movl   $0x802258,0x4(%esp)
  801324:	00 
  801325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801328:	89 04 24             	mov    %eax,(%esp)
  80132b:	e8 d3 fb ff ff       	call   800f03 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801330:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801337:	00 
  801338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133b:	89 04 24             	mov    %eax,(%esp)
  80133e:	e8 04 fb ff ff       	call   800e47 <sys_env_set_status>
  801343:	85 c0                	test   %eax,%eax
  801345:	79 20                	jns    801367 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801347:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134b:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  801352:	00 
  801353:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80135a:	00 
  80135b:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  801362:	e8 29 0e 00 00       	call   802190 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136a:	83 c4 3c             	add    $0x3c,%esp
  80136d:	5b                   	pop    %ebx
  80136e:	5e                   	pop    %esi
  80136f:	5f                   	pop    %edi
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <sfork>:

// Challenge!
int
sfork(void)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801378:	c7 44 24 08 75 2b 80 	movl   $0x802b75,0x8(%esp)
  80137f:	00 
  801380:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801387:	00 
  801388:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  80138f:	e8 fc 0d 00 00       	call   802190 <_panic>
	...

008013a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	89 04 24             	mov    %eax,(%esp)
  8013bc:	e8 df ff ff ff       	call   8013a0 <fd2num>
  8013c1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8013c6:	c1 e0 0c             	shl    $0xc,%eax
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013d2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8013d7:	a8 01                	test   $0x1,%al
  8013d9:	74 34                	je     80140f <fd_alloc+0x44>
  8013db:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013e0:	a8 01                	test   $0x1,%al
  8013e2:	74 32                	je     801416 <fd_alloc+0x4b>
  8013e4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013e9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	c1 ea 16             	shr    $0x16,%edx
  8013f0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f7:	f6 c2 01             	test   $0x1,%dl
  8013fa:	74 1f                	je     80141b <fd_alloc+0x50>
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	c1 ea 0c             	shr    $0xc,%edx
  801401:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801408:	f6 c2 01             	test   $0x1,%dl
  80140b:	75 17                	jne    801424 <fd_alloc+0x59>
  80140d:	eb 0c                	jmp    80141b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80140f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801414:	eb 05                	jmp    80141b <fd_alloc+0x50>
  801416:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80141b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
  801422:	eb 17                	jmp    80143b <fd_alloc+0x70>
  801424:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801429:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80142e:	75 b9                	jne    8013e9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801430:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801436:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80143b:	5b                   	pop    %ebx
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801449:	83 fa 1f             	cmp    $0x1f,%edx
  80144c:	77 3f                	ja     80148d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80144e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801454:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801457:	89 d0                	mov    %edx,%eax
  801459:	c1 e8 16             	shr    $0x16,%eax
  80145c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801468:	f6 c1 01             	test   $0x1,%cl
  80146b:	74 20                	je     80148d <fd_lookup+0x4f>
  80146d:	89 d0                	mov    %edx,%eax
  80146f:	c1 e8 0c             	shr    $0xc,%eax
  801472:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80147e:	f6 c1 01             	test   $0x1,%cl
  801481:	74 0a                	je     80148d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	89 10                	mov    %edx,(%eax)
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	83 ec 14             	sub    $0x14,%esp
  801496:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801499:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014a1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8014a7:	75 17                	jne    8014c0 <dev_lookup+0x31>
  8014a9:	eb 07                	jmp    8014b2 <dev_lookup+0x23>
  8014ab:	39 0a                	cmp    %ecx,(%edx)
  8014ad:	75 11                	jne    8014c0 <dev_lookup+0x31>
  8014af:	90                   	nop
  8014b0:	eb 05                	jmp    8014b7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014b2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8014b7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014be:	eb 35                	jmp    8014f5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014c0:	83 c0 01             	add    $0x1,%eax
  8014c3:	8b 14 85 08 2c 80 00 	mov    0x802c08(,%eax,4),%edx
  8014ca:	85 d2                	test   %edx,%edx
  8014cc:	75 dd                	jne    8014ab <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d3:	8b 40 48             	mov    0x48(%eax),%eax
  8014d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014de:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  8014e5:	e8 21 ed ff ff       	call   80020b <cprintf>
	*dev = 0;
  8014ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f5:	83 c4 14             	add    $0x14,%esp
  8014f8:	5b                   	pop    %ebx
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 38             	sub    $0x38,%esp
  801501:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801504:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801507:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80150a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80150d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801511:	89 3c 24             	mov    %edi,(%esp)
  801514:	e8 87 fe ff ff       	call   8013a0 <fd2num>
  801519:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80151c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801520:	89 04 24             	mov    %eax,(%esp)
  801523:	e8 16 ff ff ff       	call   80143e <fd_lookup>
  801528:	89 c3                	mov    %eax,%ebx
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 05                	js     801533 <fd_close+0x38>
	    || fd != fd2)
  80152e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801531:	74 0e                	je     801541 <fd_close+0x46>
		return (must_exist ? r : 0);
  801533:	89 f0                	mov    %esi,%eax
  801535:	84 c0                	test   %al,%al
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
  80153c:	0f 44 d8             	cmove  %eax,%ebx
  80153f:	eb 3d                	jmp    80157e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801541:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801544:	89 44 24 04          	mov    %eax,0x4(%esp)
  801548:	8b 07                	mov    (%edi),%eax
  80154a:	89 04 24             	mov    %eax,(%esp)
  80154d:	e8 3d ff ff ff       	call   80148f <dev_lookup>
  801552:	89 c3                	mov    %eax,%ebx
  801554:	85 c0                	test   %eax,%eax
  801556:	78 16                	js     80156e <fd_close+0x73>
		if (dev->dev_close)
  801558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80155e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801563:	85 c0                	test   %eax,%eax
  801565:	74 07                	je     80156e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801567:	89 3c 24             	mov    %edi,(%esp)
  80156a:	ff d0                	call   *%eax
  80156c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80156e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801572:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801579:	e8 6b f8 ff ff       	call   800de9 <sys_page_unmap>
	return r;
}
  80157e:	89 d8                	mov    %ebx,%eax
  801580:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801583:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801586:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801589:	89 ec                	mov    %ebp,%esp
  80158b:	5d                   	pop    %ebp
  80158c:	c3                   	ret    

0080158d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801593:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	89 04 24             	mov    %eax,(%esp)
  8015a0:	e8 99 fe ff ff       	call   80143e <fd_lookup>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 13                	js     8015bc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015b0:	00 
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 3f ff ff ff       	call   8014fb <fd_close>
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <close_all>:

void
close_all(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015ca:	89 1c 24             	mov    %ebx,(%esp)
  8015cd:	e8 bb ff ff ff       	call   80158d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015d2:	83 c3 01             	add    $0x1,%ebx
  8015d5:	83 fb 20             	cmp    $0x20,%ebx
  8015d8:	75 f0                	jne    8015ca <close_all+0xc>
		close(i);
}
  8015da:	83 c4 14             	add    $0x14,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 58             	sub    $0x58,%esp
  8015e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	89 04 24             	mov    %eax,(%esp)
  8015ff:	e8 3a fe ff ff       	call   80143e <fd_lookup>
  801604:	89 c3                	mov    %eax,%ebx
  801606:	85 c0                	test   %eax,%eax
  801608:	0f 88 e1 00 00 00    	js     8016ef <dup+0x10f>
		return r;
	close(newfdnum);
  80160e:	89 3c 24             	mov    %edi,(%esp)
  801611:	e8 77 ff ff ff       	call   80158d <close>

	newfd = INDEX2FD(newfdnum);
  801616:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80161c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80161f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801622:	89 04 24             	mov    %eax,(%esp)
  801625:	e8 86 fd ff ff       	call   8013b0 <fd2data>
  80162a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80162c:	89 34 24             	mov    %esi,(%esp)
  80162f:	e8 7c fd ff ff       	call   8013b0 <fd2data>
  801634:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801637:	89 d8                	mov    %ebx,%eax
  801639:	c1 e8 16             	shr    $0x16,%eax
  80163c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801643:	a8 01                	test   $0x1,%al
  801645:	74 46                	je     80168d <dup+0xad>
  801647:	89 d8                	mov    %ebx,%eax
  801649:	c1 e8 0c             	shr    $0xc,%eax
  80164c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801653:	f6 c2 01             	test   $0x1,%dl
  801656:	74 35                	je     80168d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801658:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80165f:	25 07 0e 00 00       	and    $0xe07,%eax
  801664:	89 44 24 10          	mov    %eax,0x10(%esp)
  801668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80166b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80166f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801676:	00 
  801677:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80167b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801682:	e8 04 f7 ff ff       	call   800d8b <sys_page_map>
  801687:	89 c3                	mov    %eax,%ebx
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 3b                	js     8016c8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80168d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801690:	89 c2                	mov    %eax,%edx
  801692:	c1 ea 0c             	shr    $0xc,%edx
  801695:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80169c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b1:	00 
  8016b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bd:	e8 c9 f6 ff ff       	call   800d8b <sys_page_map>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	79 25                	jns    8016ed <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d3:	e8 11 f7 ff ff       	call   800de9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e6:	e8 fe f6 ff ff       	call   800de9 <sys_page_unmap>
	return r;
  8016eb:	eb 02                	jmp    8016ef <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8016ed:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016fa:	89 ec                	mov    %ebp,%esp
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	53                   	push   %ebx
  801702:	83 ec 24             	sub    $0x24,%esp
  801705:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801708:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170f:	89 1c 24             	mov    %ebx,(%esp)
  801712:	e8 27 fd ff ff       	call   80143e <fd_lookup>
  801717:	85 c0                	test   %eax,%eax
  801719:	78 6d                	js     801788 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 60 fd ff ff       	call   80148f <dev_lookup>
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 55                	js     801788 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	8b 50 08             	mov    0x8(%eax),%edx
  801739:	83 e2 03             	and    $0x3,%edx
  80173c:	83 fa 01             	cmp    $0x1,%edx
  80173f:	75 23                	jne    801764 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801741:	a1 04 40 80 00       	mov    0x804004,%eax
  801746:	8b 40 48             	mov    0x48(%eax),%eax
  801749:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80174d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801751:	c7 04 24 cd 2b 80 00 	movl   $0x802bcd,(%esp)
  801758:	e8 ae ea ff ff       	call   80020b <cprintf>
		return -E_INVAL;
  80175d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801762:	eb 24                	jmp    801788 <read+0x8a>
	}
	if (!dev->dev_read)
  801764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801767:	8b 52 08             	mov    0x8(%edx),%edx
  80176a:	85 d2                	test   %edx,%edx
  80176c:	74 15                	je     801783 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80176e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801771:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801775:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801778:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80177c:	89 04 24             	mov    %eax,(%esp)
  80177f:	ff d2                	call   *%edx
  801781:	eb 05                	jmp    801788 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801783:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801788:	83 c4 24             	add    $0x24,%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    

0080178e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	57                   	push   %edi
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 1c             	sub    $0x1c,%esp
  801797:	8b 7d 08             	mov    0x8(%ebp),%edi
  80179a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a2:	85 f6                	test   %esi,%esi
  8017a4:	74 30                	je     8017d6 <readn+0x48>
  8017a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017ab:	89 f2                	mov    %esi,%edx
  8017ad:	29 c2                	sub    %eax,%edx
  8017af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017b3:	03 45 0c             	add    0xc(%ebp),%eax
  8017b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ba:	89 3c 24             	mov    %edi,(%esp)
  8017bd:	e8 3c ff ff ff       	call   8016fe <read>
		if (m < 0)
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 10                	js     8017d6 <readn+0x48>
			return m;
		if (m == 0)
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 0a                	je     8017d4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017ca:	01 c3                	add    %eax,%ebx
  8017cc:	89 d8                	mov    %ebx,%eax
  8017ce:	39 f3                	cmp    %esi,%ebx
  8017d0:	72 d9                	jb     8017ab <readn+0x1d>
  8017d2:	eb 02                	jmp    8017d6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8017d4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8017d6:	83 c4 1c             	add    $0x1c,%esp
  8017d9:	5b                   	pop    %ebx
  8017da:	5e                   	pop    %esi
  8017db:	5f                   	pop    %edi
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 24             	sub    $0x24,%esp
  8017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	89 1c 24             	mov    %ebx,(%esp)
  8017f2:	e8 47 fc ff ff       	call   80143e <fd_lookup>
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 68                	js     801863 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 80 fc ff ff       	call   80148f <dev_lookup>
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 50                	js     801863 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181a:	75 23                	jne    80183f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80181c:	a1 04 40 80 00       	mov    0x804004,%eax
  801821:	8b 40 48             	mov    0x48(%eax),%eax
  801824:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182c:	c7 04 24 e9 2b 80 00 	movl   $0x802be9,(%esp)
  801833:	e8 d3 e9 ff ff       	call   80020b <cprintf>
		return -E_INVAL;
  801838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183d:	eb 24                	jmp    801863 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80183f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801842:	8b 52 0c             	mov    0xc(%edx),%edx
  801845:	85 d2                	test   %edx,%edx
  801847:	74 15                	je     80185e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801849:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801850:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801853:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801857:	89 04 24             	mov    %eax,(%esp)
  80185a:	ff d2                	call   *%edx
  80185c:	eb 05                	jmp    801863 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80185e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801863:	83 c4 24             	add    $0x24,%esp
  801866:	5b                   	pop    %ebx
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <seek>:

int
seek(int fdnum, off_t offset)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801872:	89 44 24 04          	mov    %eax,0x4(%esp)
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	89 04 24             	mov    %eax,(%esp)
  80187c:	e8 bd fb ff ff       	call   80143e <fd_lookup>
  801881:	85 c0                	test   %eax,%eax
  801883:	78 0e                	js     801893 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	53                   	push   %ebx
  801899:	83 ec 24             	sub    $0x24,%esp
  80189c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a6:	89 1c 24             	mov    %ebx,(%esp)
  8018a9:	e8 90 fb ff ff       	call   80143e <fd_lookup>
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 61                	js     801913 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bc:	8b 00                	mov    (%eax),%eax
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 c9 fb ff ff       	call   80148f <dev_lookup>
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 49                	js     801913 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018d1:	75 23                	jne    8018f6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018d3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018d8:	8b 40 48             	mov    0x48(%eax),%eax
  8018db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	c7 04 24 ac 2b 80 00 	movl   $0x802bac,(%esp)
  8018ea:	e8 1c e9 ff ff       	call   80020b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f4:	eb 1d                	jmp    801913 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8018f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f9:	8b 52 18             	mov    0x18(%edx),%edx
  8018fc:	85 d2                	test   %edx,%edx
  8018fe:	74 0e                	je     80190e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801900:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801903:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801907:	89 04 24             	mov    %eax,(%esp)
  80190a:	ff d2                	call   *%edx
  80190c:	eb 05                	jmp    801913 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80190e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801913:	83 c4 24             	add    $0x24,%esp
  801916:	5b                   	pop    %ebx
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
  80191d:	83 ec 24             	sub    $0x24,%esp
  801920:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801923:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	89 04 24             	mov    %eax,(%esp)
  801930:	e8 09 fb ff ff       	call   80143e <fd_lookup>
  801935:	85 c0                	test   %eax,%eax
  801937:	78 52                	js     80198b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 00                	mov    (%eax),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	e8 42 fb ff ff       	call   80148f <dev_lookup>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 3a                	js     80198b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801958:	74 2c                	je     801986 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80195a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80195d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801964:	00 00 00 
	stat->st_isdir = 0;
  801967:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80196e:	00 00 00 
	stat->st_dev = dev;
  801971:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801977:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80197b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197e:	89 14 24             	mov    %edx,(%esp)
  801981:	ff 50 14             	call   *0x14(%eax)
  801984:	eb 05                	jmp    80198b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801986:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80198b:	83 c4 24             	add    $0x24,%esp
  80198e:	5b                   	pop    %ebx
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    

00801991 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 18             	sub    $0x18,%esp
  801997:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80199a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80199d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019a4:	00 
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	89 04 24             	mov    %eax,(%esp)
  8019ab:	e8 bc 01 00 00       	call   801b6c <open>
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 1b                	js     8019d1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bd:	89 1c 24             	mov    %ebx,(%esp)
  8019c0:	e8 54 ff ff ff       	call   801919 <fstat>
  8019c5:	89 c6                	mov    %eax,%esi
	close(fd);
  8019c7:	89 1c 24             	mov    %ebx,(%esp)
  8019ca:	e8 be fb ff ff       	call   80158d <close>
	return r;
  8019cf:	89 f3                	mov    %esi,%ebx
}
  8019d1:	89 d8                	mov    %ebx,%eax
  8019d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019d9:	89 ec                	mov    %ebp,%esp
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    
  8019dd:	00 00                	add    %al,(%eax)
	...

008019e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 18             	sub    $0x18,%esp
  8019e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8019ec:	89 c3                	mov    %eax,%ebx
  8019ee:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8019f0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019f7:	75 11                	jne    801a0a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a00:	e8 51 09 00 00       	call   802356 <ipc_find_env>
  801a05:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a0a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a11:	00 
  801a12:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801a19:	00 
  801a1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a1e:	a1 00 40 80 00       	mov    0x804000,%eax
  801a23:	89 04 24             	mov    %eax,(%esp)
  801a26:	e8 a7 08 00 00       	call   8022d2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a32:	00 
  801a33:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3e:	e8 3d 08 00 00       	call   802280 <ipc_recv>
}
  801a43:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a46:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a49:	89 ec                	mov    %ebp,%esp
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	53                   	push   %ebx
  801a51:	83 ec 14             	sub    $0x14,%esp
  801a54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 05 00 00 00       	mov    $0x5,%eax
  801a6c:	e8 6f ff ff ff       	call   8019e0 <fsipc>
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 2b                	js     801aa0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a75:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a7c:	00 
  801a7d:	89 1c 24             	mov    %ebx,(%esp)
  801a80:	e8 a6 ed ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a85:	a1 80 50 80 00       	mov    0x805080,%eax
  801a8a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a90:	a1 84 50 80 00       	mov    0x805084,%eax
  801a95:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa0:	83 c4 14             	add    $0x14,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    

00801aa6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  801abc:	b8 06 00 00 00       	mov    $0x6,%eax
  801ac1:	e8 1a ff ff ff       	call   8019e0 <fsipc>
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	56                   	push   %esi
  801acc:	53                   	push   %ebx
  801acd:	83 ec 10             	sub    $0x10,%esp
  801ad0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ade:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae9:	b8 03 00 00 00       	mov    $0x3,%eax
  801aee:	e8 ed fe ff ff       	call   8019e0 <fsipc>
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	85 c0                	test   %eax,%eax
  801af7:	78 6a                	js     801b63 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801af9:	39 c6                	cmp    %eax,%esi
  801afb:	73 24                	jae    801b21 <devfile_read+0x59>
  801afd:	c7 44 24 0c 18 2c 80 	movl   $0x802c18,0xc(%esp)
  801b04:	00 
  801b05:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  801b0c:	00 
  801b0d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b14:	00 
  801b15:	c7 04 24 34 2c 80 00 	movl   $0x802c34,(%esp)
  801b1c:	e8 6f 06 00 00       	call   802190 <_panic>
	assert(r <= PGSIZE);
  801b21:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b26:	7e 24                	jle    801b4c <devfile_read+0x84>
  801b28:	c7 44 24 0c 3f 2c 80 	movl   $0x802c3f,0xc(%esp)
  801b2f:	00 
  801b30:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  801b37:	00 
  801b38:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801b3f:	00 
  801b40:	c7 04 24 34 2c 80 00 	movl   $0x802c34,(%esp)
  801b47:	e8 44 06 00 00       	call   802190 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b50:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b57:	00 
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	89 04 24             	mov    %eax,(%esp)
  801b5e:	e8 b9 ee ff ff       	call   800a1c <memmove>
	return r;
}
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    

00801b6c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	56                   	push   %esi
  801b70:	53                   	push   %ebx
  801b71:	83 ec 20             	sub    $0x20,%esp
  801b74:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b77:	89 34 24             	mov    %esi,(%esp)
  801b7a:	e8 61 ec ff ff       	call   8007e0 <strlen>
		return -E_BAD_PATH;
  801b7f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b84:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b89:	7f 5e                	jg     801be9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 35 f8 ff ff       	call   8013cb <fd_alloc>
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 4d                	js     801be9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801ba7:	e8 7f ec ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	e8 1f fe ff ff       	call   8019e0 <fsipc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	79 15                	jns    801bdc <open+0x70>
		fd_close(fd, 0);
  801bc7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bce:	00 
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	89 04 24             	mov    %eax,(%esp)
  801bd5:	e8 21 f9 ff ff       	call   8014fb <fd_close>
		return r;
  801bda:	eb 0d                	jmp    801be9 <open+0x7d>
	}

	return fd2num(fd);
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 b9 f7 ff ff       	call   8013a0 <fd2num>
  801be7:	89 c3                	mov    %eax,%ebx
}
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	83 c4 20             	add    $0x20,%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5d                   	pop    %ebp
  801bf1:	c3                   	ret    
	...

00801c00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 18             	sub    $0x18,%esp
  801c06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 96 f7 ff ff       	call   8013b0 <fd2data>
  801c1a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801c1c:	c7 44 24 04 4b 2c 80 	movl   $0x802c4b,0x4(%esp)
  801c23:	00 
  801c24:	89 34 24             	mov    %esi,(%esp)
  801c27:	e8 ff eb ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c2c:	8b 43 04             	mov    0x4(%ebx),%eax
  801c2f:	2b 03                	sub    (%ebx),%eax
  801c31:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801c37:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801c3e:	00 00 00 
	stat->st_dev = &devpipe;
  801c41:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801c48:	30 80 00 
	return 0;
}
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c53:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c56:	89 ec                	mov    %ebp,%esp
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 14             	sub    $0x14,%esp
  801c61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6f:	e8 75 f1 ff ff       	call   800de9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c74:	89 1c 24             	mov    %ebx,(%esp)
  801c77:	e8 34 f7 ff ff       	call   8013b0 <fd2data>
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c87:	e8 5d f1 ff ff       	call   800de9 <sys_page_unmap>
}
  801c8c:	83 c4 14             	add    $0x14,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    

00801c92 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	57                   	push   %edi
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 2c             	sub    $0x2c,%esp
  801c9b:	89 c7                	mov    %eax,%edi
  801c9d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ca0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ca8:	89 3c 24             	mov    %edi,(%esp)
  801cab:	e8 f0 06 00 00       	call   8023a0 <pageref>
  801cb0:	89 c6                	mov    %eax,%esi
  801cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb5:	89 04 24             	mov    %eax,(%esp)
  801cb8:	e8 e3 06 00 00       	call   8023a0 <pageref>
  801cbd:	39 c6                	cmp    %eax,%esi
  801cbf:	0f 94 c0             	sete   %al
  801cc2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801cc5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ccb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cce:	39 cb                	cmp    %ecx,%ebx
  801cd0:	75 08                	jne    801cda <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801cd2:	83 c4 2c             	add    $0x2c,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801cda:	83 f8 01             	cmp    $0x1,%eax
  801cdd:	75 c1                	jne    801ca0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cdf:	8b 52 58             	mov    0x58(%edx),%edx
  801ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cee:	c7 04 24 52 2c 80 00 	movl   $0x802c52,(%esp)
  801cf5:	e8 11 e5 ff ff       	call   80020b <cprintf>
  801cfa:	eb a4                	jmp    801ca0 <_pipeisclosed+0xe>

00801cfc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	57                   	push   %edi
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	83 ec 2c             	sub    $0x2c,%esp
  801d05:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801d08:	89 34 24             	mov    %esi,(%esp)
  801d0b:	e8 a0 f6 ff ff       	call   8013b0 <fd2data>
  801d10:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d12:	bf 00 00 00 00       	mov    $0x0,%edi
  801d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d1b:	75 50                	jne    801d6d <devpipe_write+0x71>
  801d1d:	eb 5c                	jmp    801d7b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801d1f:	89 da                	mov    %ebx,%edx
  801d21:	89 f0                	mov    %esi,%eax
  801d23:	e8 6a ff ff ff       	call   801c92 <_pipeisclosed>
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	75 53                	jne    801d7f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801d2c:	e8 cb ef ff ff       	call   800cfc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d31:	8b 43 04             	mov    0x4(%ebx),%eax
  801d34:	8b 13                	mov    (%ebx),%edx
  801d36:	83 c2 20             	add    $0x20,%edx
  801d39:	39 d0                	cmp    %edx,%eax
  801d3b:	73 e2                	jae    801d1f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801d44:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801d47:	89 c2                	mov    %eax,%edx
  801d49:	c1 fa 1f             	sar    $0x1f,%edx
  801d4c:	c1 ea 1b             	shr    $0x1b,%edx
  801d4f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801d52:	83 e1 1f             	and    $0x1f,%ecx
  801d55:	29 d1                	sub    %edx,%ecx
  801d57:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801d5b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801d5f:	83 c0 01             	add    $0x1,%eax
  801d62:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d65:	83 c7 01             	add    $0x1,%edi
  801d68:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d6b:	74 0e                	je     801d7b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d6d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d70:	8b 13                	mov    (%ebx),%edx
  801d72:	83 c2 20             	add    $0x20,%edx
  801d75:	39 d0                	cmp    %edx,%eax
  801d77:	73 a6                	jae    801d1f <devpipe_write+0x23>
  801d79:	eb c2                	jmp    801d3d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801d7b:	89 f8                	mov    %edi,%eax
  801d7d:	eb 05                	jmp    801d84 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d84:	83 c4 2c             	add    $0x2c,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    

00801d8c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 28             	sub    $0x28,%esp
  801d92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d98:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d9b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d9e:	89 3c 24             	mov    %edi,(%esp)
  801da1:	e8 0a f6 ff ff       	call   8013b0 <fd2data>
  801da6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801da8:	be 00 00 00 00       	mov    $0x0,%esi
  801dad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db1:	75 47                	jne    801dfa <devpipe_read+0x6e>
  801db3:	eb 52                	jmp    801e07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	eb 5e                	jmp    801e17 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801db9:	89 da                	mov    %ebx,%edx
  801dbb:	89 f8                	mov    %edi,%eax
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	e8 cd fe ff ff       	call   801c92 <_pipeisclosed>
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	75 49                	jne    801e12 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801dc9:	e8 2e ef ff ff       	call   800cfc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801dce:	8b 03                	mov    (%ebx),%eax
  801dd0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd3:	74 e4                	je     801db9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd5:	89 c2                	mov    %eax,%edx
  801dd7:	c1 fa 1f             	sar    $0x1f,%edx
  801dda:	c1 ea 1b             	shr    $0x1b,%edx
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	83 e0 1f             	and    $0x1f,%eax
  801de2:	29 d0                	sub    %edx,%eax
  801de4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dec:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801def:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801df2:	83 c6 01             	add    $0x1,%esi
  801df5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801df8:	74 0d                	je     801e07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801dfa:	8b 03                	mov    (%ebx),%eax
  801dfc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dff:	75 d4                	jne    801dd5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e01:	85 f6                	test   %esi,%esi
  801e03:	75 b0                	jne    801db5 <devpipe_read+0x29>
  801e05:	eb b2                	jmp    801db9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e07:	89 f0                	mov    %esi,%eax
  801e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e10:	eb 05                	jmp    801e17 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e17:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e1a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e1d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e20:	89 ec                	mov    %ebp,%esp
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 48             	sub    $0x48,%esp
  801e2a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801e2d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801e30:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801e33:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e39:	89 04 24             	mov    %eax,(%esp)
  801e3c:	e8 8a f5 ff ff       	call   8013cb <fd_alloc>
  801e41:	89 c3                	mov    %eax,%ebx
  801e43:	85 c0                	test   %eax,%eax
  801e45:	0f 88 45 01 00 00    	js     801f90 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e52:	00 
  801e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e61:	e8 c6 ee ff ff       	call   800d2c <sys_page_alloc>
  801e66:	89 c3                	mov    %eax,%ebx
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	0f 88 20 01 00 00    	js     801f90 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e70:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e73:	89 04 24             	mov    %eax,(%esp)
  801e76:	e8 50 f5 ff ff       	call   8013cb <fd_alloc>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	0f 88 f8 00 00 00    	js     801f7d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e85:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e8c:	00 
  801e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9b:	e8 8c ee ff ff       	call   800d2c <sys_page_alloc>
  801ea0:	89 c3                	mov    %eax,%ebx
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	0f 88 d3 00 00 00    	js     801f7d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ead:	89 04 24             	mov    %eax,(%esp)
  801eb0:	e8 fb f4 ff ff       	call   8013b0 <fd2data>
  801eb5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ebe:	00 
  801ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eca:	e8 5d ee ff ff       	call   800d2c <sys_page_alloc>
  801ecf:	89 c3                	mov    %eax,%ebx
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	0f 88 91 00 00 00    	js     801f6a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801edc:	89 04 24             	mov    %eax,(%esp)
  801edf:	e8 cc f4 ff ff       	call   8013b0 <fd2data>
  801ee4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801eeb:	00 
  801eec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ef7:	00 
  801ef8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801efc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f03:	e8 83 ee ff ff       	call   800d8b <sys_page_map>
  801f08:	89 c3                	mov    %eax,%ebx
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 4c                	js     801f5a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f0e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f17:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f23:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f2c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f31:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3b:	89 04 24             	mov    %eax,(%esp)
  801f3e:	e8 5d f4 ff ff       	call   8013a0 <fd2num>
  801f43:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f48:	89 04 24             	mov    %eax,(%esp)
  801f4b:	e8 50 f4 ff ff       	call   8013a0 <fd2num>
  801f50:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f58:	eb 36                	jmp    801f90 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801f5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f65:	e8 7f ee ff ff       	call   800de9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f78:	e8 6c ee ff ff       	call   800de9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8b:	e8 59 ee ff ff       	call   800de9 <sys_page_unmap>
    err:
	return r;
}
  801f90:	89 d8                	mov    %ebx,%eax
  801f92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f95:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f98:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f9b:	89 ec                	mov    %ebp,%esp
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 87 f4 ff ff       	call   80143e <fd_lookup>
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	78 15                	js     801fd0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	89 04 24             	mov    %eax,(%esp)
  801fc1:	e8 ea f3 ff ff       	call   8013b0 <fd2data>
	return _pipeisclosed(fd, p);
  801fc6:	89 c2                	mov    %eax,%edx
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	e8 c2 fc ff ff       	call   801c92 <_pipeisclosed>
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    
	...

00801fe0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    

00801fea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ff0:	c7 44 24 04 6a 2c 80 	movl   $0x802c6a,0x4(%esp)
  801ff7:	00 
  801ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffb:	89 04 24             	mov    %eax,(%esp)
  801ffe:	e8 28 e8 ff ff       	call   80082b <strcpy>
	return 0;
}
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	57                   	push   %edi
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
  802010:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802016:	be 00 00 00 00       	mov    $0x0,%esi
  80201b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201f:	74 43                	je     802064 <devcons_write+0x5a>
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802026:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80202c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80202f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802031:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802034:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802039:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80203c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802040:	03 45 0c             	add    0xc(%ebp),%eax
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
  802047:	89 3c 24             	mov    %edi,(%esp)
  80204a:	e8 cd e9 ff ff       	call   800a1c <memmove>
		sys_cputs(buf, m);
  80204f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802053:	89 3c 24             	mov    %edi,(%esp)
  802056:	e8 b5 eb ff ff       	call   800c10 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80205b:	01 de                	add    %ebx,%esi
  80205d:	89 f0                	mov    %esi,%eax
  80205f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802062:	72 c8                	jb     80202c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802064:	89 f0                	mov    %esi,%eax
  802066:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80206c:	5b                   	pop    %ebx
  80206d:	5e                   	pop    %esi
  80206e:	5f                   	pop    %edi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80207c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802080:	75 07                	jne    802089 <devcons_read+0x18>
  802082:	eb 31                	jmp    8020b5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802084:	e8 73 ec ff ff       	call   800cfc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802090:	e8 aa eb ff ff       	call   800c3f <sys_cgetc>
  802095:	85 c0                	test   %eax,%eax
  802097:	74 eb                	je     802084 <devcons_read+0x13>
  802099:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 16                	js     8020b5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80209f:	83 f8 04             	cmp    $0x4,%eax
  8020a2:	74 0c                	je     8020b0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	88 10                	mov    %dl,(%eax)
	return 1;
  8020a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ae:	eb 05                	jmp    8020b5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8020c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8020ca:	00 
  8020cb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 3a eb ff ff       	call   800c10 <sys_cputs>
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <getchar>:

int
getchar(void)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8020de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8020e5:	00 
  8020e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f4:	e8 05 f6 ff ff       	call   8016fe <read>
	if (r < 0)
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 0f                	js     80210c <getchar+0x34>
		return r;
	if (r < 1)
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	7e 06                	jle    802107 <getchar+0x2f>
		return -E_EOF;
	return c;
  802101:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802105:	eb 05                	jmp    80210c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802107:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802114:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 18 f3 ff ff       	call   80143e <fd_lookup>
  802126:	85 c0                	test   %eax,%eax
  802128:	78 11                	js     80213b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802133:	39 10                	cmp    %edx,(%eax)
  802135:	0f 94 c0             	sete   %al
  802138:	0f b6 c0             	movzbl %al,%eax
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <opencons>:

int
opencons(void)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 7d f2 ff ff       	call   8013cb <fd_alloc>
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 3c                	js     80218e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802152:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802159:	00 
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802161:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802168:	e8 bf eb ff ff       	call   800d2c <sys_page_alloc>
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 1d                	js     80218e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802171:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802186:	89 04 24             	mov    %eax,(%esp)
  802189:	e8 12 f2 ff ff       	call   8013a0 <fd2num>
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	56                   	push   %esi
  802194:	53                   	push   %ebx
  802195:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802198:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80219b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8021a1:	e8 26 eb ff ff       	call   800ccc <sys_getenvid>
  8021a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	c7 04 24 78 2c 80 00 	movl   $0x802c78,(%esp)
  8021c3:	e8 43 e0 ff ff       	call   80020b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cf:	89 04 24             	mov    %eax,(%esp)
  8021d2:	e8 d3 df ff ff       	call   8001aa <vcprintf>
	cprintf("\n");
  8021d7:	c7 04 24 af 26 80 00 	movl   $0x8026af,(%esp)
  8021de:	e8 28 e0 ff ff       	call   80020b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e3:	cc                   	int3   
  8021e4:	eb fd                	jmp    8021e3 <_panic+0x53>
	...

008021e8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021ee:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021f5:	75 54                	jne    80224b <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8021f7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021fe:	00 
  8021ff:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802206:	ee 
  802207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220e:	e8 19 eb ff ff       	call   800d2c <sys_page_alloc>
  802213:	85 c0                	test   %eax,%eax
  802215:	79 20                	jns    802237 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  802217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221b:	c7 44 24 08 9c 2c 80 	movl   $0x802c9c,0x8(%esp)
  802222:	00 
  802223:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80222a:	00 
  80222b:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  802232:	e8 59 ff ff ff       	call   802190 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802237:	c7 44 24 04 58 22 80 	movl   $0x802258,0x4(%esp)
  80223e:	00 
  80223f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802246:	e8 b8 ec ff ff       	call   800f03 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    
  802255:	00 00                	add    %al,(%eax)
	...

00802258 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802258:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802259:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80225e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802260:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  802263:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802267:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  80226a:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  80226e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802272:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802274:	83 c4 08             	add    $0x8,%esp
	popal
  802277:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802278:	83 c4 04             	add    $0x4,%esp
	popfl
  80227b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80227c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80227d:	c3                   	ret    
	...

00802280 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	56                   	push   %esi
  802284:	53                   	push   %ebx
  802285:	83 ec 10             	sub    $0x10,%esp
  802288:	8b 75 08             	mov    0x8(%ebp),%esi
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802291:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802293:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802298:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80229b:	89 04 24             	mov    %eax,(%esp)
  80229e:	e8 f2 ec ff ff       	call   800f95 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8022a3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8022a8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	78 0e                	js     8022bf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8022b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8022b6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8022b9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8022bc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8022bf:	85 f6                	test   %esi,%esi
  8022c1:	74 02                	je     8022c5 <ipc_recv+0x45>
		*from_env_store = sender;
  8022c3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8022c5:	85 db                	test   %ebx,%ebx
  8022c7:	74 02                	je     8022cb <ipc_recv+0x4b>
		*perm_store = perm;
  8022c9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    

008022d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022e1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8022e4:	85 db                	test   %ebx,%ebx
  8022e6:	75 04                	jne    8022ec <ipc_send+0x1a>
  8022e8:	85 f6                	test   %esi,%esi
  8022ea:	75 15                	jne    802301 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8022ec:	85 db                	test   %ebx,%ebx
  8022ee:	74 16                	je     802306 <ipc_send+0x34>
  8022f0:	85 f6                	test   %esi,%esi
  8022f2:	0f 94 c0             	sete   %al
      pg = 0;
  8022f5:	84 c0                	test   %al,%al
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	0f 45 d8             	cmovne %eax,%ebx
  8022ff:	eb 05                	jmp    802306 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802301:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802306:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80230a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80230e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	89 04 24             	mov    %eax,(%esp)
  802318:	e8 44 ec ff ff       	call   800f61 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80231d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802320:	75 07                	jne    802329 <ipc_send+0x57>
           sys_yield();
  802322:	e8 d5 e9 ff ff       	call   800cfc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802327:	eb dd                	jmp    802306 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802329:	85 c0                	test   %eax,%eax
  80232b:	90                   	nop
  80232c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802330:	74 1c                	je     80234e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802332:	c7 44 24 08 c2 2c 80 	movl   $0x802cc2,0x8(%esp)
  802339:	00 
  80233a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802341:	00 
  802342:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  802349:	e8 42 fe ff ff       	call   802190 <_panic>
		}
    }
}
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80235c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802361:	39 c8                	cmp    %ecx,%eax
  802363:	74 17                	je     80237c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802365:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80236a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80236d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802373:	8b 52 50             	mov    0x50(%edx),%edx
  802376:	39 ca                	cmp    %ecx,%edx
  802378:	75 14                	jne    80238e <ipc_find_env+0x38>
  80237a:	eb 05                	jmp    802381 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802381:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802384:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802389:	8b 40 40             	mov    0x40(%eax),%eax
  80238c:	eb 0e                	jmp    80239c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80238e:	83 c0 01             	add    $0x1,%eax
  802391:	3d 00 04 00 00       	cmp    $0x400,%eax
  802396:	75 d2                	jne    80236a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802398:	66 b8 00 00          	mov    $0x0,%ax
}
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    
	...

008023a0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a6:	89 d0                	mov    %edx,%eax
  8023a8:	c1 e8 16             	shr    $0x16,%eax
  8023ab:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023b7:	f6 c1 01             	test   $0x1,%cl
  8023ba:	74 1d                	je     8023d9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023bc:	c1 ea 0c             	shr    $0xc,%edx
  8023bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023c6:	f6 c2 01             	test   $0x1,%dl
  8023c9:	74 0e                	je     8023d9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023cb:	c1 ea 0c             	shr    $0xc,%edx
  8023ce:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023d5:	ef 
  8023d6:	0f b7 c0             	movzwl %ax,%eax
}
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    
  8023db:	00 00                	add    %al,(%eax)
  8023dd:	00 00                	add    %al,(%eax)
	...

008023e0 <__udivdi3>:
  8023e0:	83 ec 1c             	sub    $0x1c,%esp
  8023e3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8023e7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8023eb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8023ef:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8023f3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8023f7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8023fb:	85 ff                	test   %edi,%edi
  8023fd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802401:	89 44 24 08          	mov    %eax,0x8(%esp)
  802405:	89 cd                	mov    %ecx,%ebp
  802407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240b:	75 33                	jne    802440 <__udivdi3+0x60>
  80240d:	39 f1                	cmp    %esi,%ecx
  80240f:	77 57                	ja     802468 <__udivdi3+0x88>
  802411:	85 c9                	test   %ecx,%ecx
  802413:	75 0b                	jne    802420 <__udivdi3+0x40>
  802415:	b8 01 00 00 00       	mov    $0x1,%eax
  80241a:	31 d2                	xor    %edx,%edx
  80241c:	f7 f1                	div    %ecx
  80241e:	89 c1                	mov    %eax,%ecx
  802420:	89 f0                	mov    %esi,%eax
  802422:	31 d2                	xor    %edx,%edx
  802424:	f7 f1                	div    %ecx
  802426:	89 c6                	mov    %eax,%esi
  802428:	8b 44 24 04          	mov    0x4(%esp),%eax
  80242c:	f7 f1                	div    %ecx
  80242e:	89 f2                	mov    %esi,%edx
  802430:	8b 74 24 10          	mov    0x10(%esp),%esi
  802434:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802438:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80243c:	83 c4 1c             	add    $0x1c,%esp
  80243f:	c3                   	ret    
  802440:	31 d2                	xor    %edx,%edx
  802442:	31 c0                	xor    %eax,%eax
  802444:	39 f7                	cmp    %esi,%edi
  802446:	77 e8                	ja     802430 <__udivdi3+0x50>
  802448:	0f bd cf             	bsr    %edi,%ecx
  80244b:	83 f1 1f             	xor    $0x1f,%ecx
  80244e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802452:	75 2c                	jne    802480 <__udivdi3+0xa0>
  802454:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802458:	76 04                	jbe    80245e <__udivdi3+0x7e>
  80245a:	39 f7                	cmp    %esi,%edi
  80245c:	73 d2                	jae    802430 <__udivdi3+0x50>
  80245e:	31 d2                	xor    %edx,%edx
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
  802465:	eb c9                	jmp    802430 <__udivdi3+0x50>
  802467:	90                   	nop
  802468:	89 f2                	mov    %esi,%edx
  80246a:	f7 f1                	div    %ecx
  80246c:	31 d2                	xor    %edx,%edx
  80246e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802472:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802476:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80247a:	83 c4 1c             	add    $0x1c,%esp
  80247d:	c3                   	ret    
  80247e:	66 90                	xchg   %ax,%ax
  802480:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802485:	b8 20 00 00 00       	mov    $0x20,%eax
  80248a:	89 ea                	mov    %ebp,%edx
  80248c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802490:	d3 e7                	shl    %cl,%edi
  802492:	89 c1                	mov    %eax,%ecx
  802494:	d3 ea                	shr    %cl,%edx
  802496:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80249b:	09 fa                	or     %edi,%edx
  80249d:	89 f7                	mov    %esi,%edi
  80249f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024a3:	89 f2                	mov    %esi,%edx
  8024a5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8024a9:	d3 e5                	shl    %cl,%ebp
  8024ab:	89 c1                	mov    %eax,%ecx
  8024ad:	d3 ef                	shr    %cl,%edi
  8024af:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024b4:	d3 e2                	shl    %cl,%edx
  8024b6:	89 c1                	mov    %eax,%ecx
  8024b8:	d3 ee                	shr    %cl,%esi
  8024ba:	09 d6                	or     %edx,%esi
  8024bc:	89 fa                	mov    %edi,%edx
  8024be:	89 f0                	mov    %esi,%eax
  8024c0:	f7 74 24 0c          	divl   0xc(%esp)
  8024c4:	89 d7                	mov    %edx,%edi
  8024c6:	89 c6                	mov    %eax,%esi
  8024c8:	f7 e5                	mul    %ebp
  8024ca:	39 d7                	cmp    %edx,%edi
  8024cc:	72 22                	jb     8024f0 <__udivdi3+0x110>
  8024ce:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8024d2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024d7:	d3 e5                	shl    %cl,%ebp
  8024d9:	39 c5                	cmp    %eax,%ebp
  8024db:	73 04                	jae    8024e1 <__udivdi3+0x101>
  8024dd:	39 d7                	cmp    %edx,%edi
  8024df:	74 0f                	je     8024f0 <__udivdi3+0x110>
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	31 d2                	xor    %edx,%edx
  8024e5:	e9 46 ff ff ff       	jmp    802430 <__udivdi3+0x50>
  8024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024f9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024fd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802501:	83 c4 1c             	add    $0x1c,%esp
  802504:	c3                   	ret    
	...

00802510 <__umoddi3>:
  802510:	83 ec 1c             	sub    $0x1c,%esp
  802513:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802517:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80251b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80251f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802523:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802527:	8b 74 24 24          	mov    0x24(%esp),%esi
  80252b:	85 ed                	test   %ebp,%ebp
  80252d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802531:	89 44 24 08          	mov    %eax,0x8(%esp)
  802535:	89 cf                	mov    %ecx,%edi
  802537:	89 04 24             	mov    %eax,(%esp)
  80253a:	89 f2                	mov    %esi,%edx
  80253c:	75 1a                	jne    802558 <__umoddi3+0x48>
  80253e:	39 f1                	cmp    %esi,%ecx
  802540:	76 4e                	jbe    802590 <__umoddi3+0x80>
  802542:	f7 f1                	div    %ecx
  802544:	89 d0                	mov    %edx,%eax
  802546:	31 d2                	xor    %edx,%edx
  802548:	8b 74 24 10          	mov    0x10(%esp),%esi
  80254c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802550:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802554:	83 c4 1c             	add    $0x1c,%esp
  802557:	c3                   	ret    
  802558:	39 f5                	cmp    %esi,%ebp
  80255a:	77 54                	ja     8025b0 <__umoddi3+0xa0>
  80255c:	0f bd c5             	bsr    %ebp,%eax
  80255f:	83 f0 1f             	xor    $0x1f,%eax
  802562:	89 44 24 04          	mov    %eax,0x4(%esp)
  802566:	75 60                	jne    8025c8 <__umoddi3+0xb8>
  802568:	3b 0c 24             	cmp    (%esp),%ecx
  80256b:	0f 87 07 01 00 00    	ja     802678 <__umoddi3+0x168>
  802571:	89 f2                	mov    %esi,%edx
  802573:	8b 34 24             	mov    (%esp),%esi
  802576:	29 ce                	sub    %ecx,%esi
  802578:	19 ea                	sbb    %ebp,%edx
  80257a:	89 34 24             	mov    %esi,(%esp)
  80257d:	8b 04 24             	mov    (%esp),%eax
  802580:	8b 74 24 10          	mov    0x10(%esp),%esi
  802584:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802588:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80258c:	83 c4 1c             	add    $0x1c,%esp
  80258f:	c3                   	ret    
  802590:	85 c9                	test   %ecx,%ecx
  802592:	75 0b                	jne    80259f <__umoddi3+0x8f>
  802594:	b8 01 00 00 00       	mov    $0x1,%eax
  802599:	31 d2                	xor    %edx,%edx
  80259b:	f7 f1                	div    %ecx
  80259d:	89 c1                	mov    %eax,%ecx
  80259f:	89 f0                	mov    %esi,%eax
  8025a1:	31 d2                	xor    %edx,%edx
  8025a3:	f7 f1                	div    %ecx
  8025a5:	8b 04 24             	mov    (%esp),%eax
  8025a8:	f7 f1                	div    %ecx
  8025aa:	eb 98                	jmp    802544 <__umoddi3+0x34>
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	89 f2                	mov    %esi,%edx
  8025b2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025b6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ba:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025be:	83 c4 1c             	add    $0x1c,%esp
  8025c1:	c3                   	ret    
  8025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025cd:	89 e8                	mov    %ebp,%eax
  8025cf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025d4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8025d8:	89 fa                	mov    %edi,%edx
  8025da:	d3 e0                	shl    %cl,%eax
  8025dc:	89 e9                	mov    %ebp,%ecx
  8025de:	d3 ea                	shr    %cl,%edx
  8025e0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025e5:	09 c2                	or     %eax,%edx
  8025e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025eb:	89 14 24             	mov    %edx,(%esp)
  8025ee:	89 f2                	mov    %esi,%edx
  8025f0:	d3 e7                	shl    %cl,%edi
  8025f2:	89 e9                	mov    %ebp,%ecx
  8025f4:	d3 ea                	shr    %cl,%edx
  8025f6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ff:	d3 e6                	shl    %cl,%esi
  802601:	89 e9                	mov    %ebp,%ecx
  802603:	d3 e8                	shr    %cl,%eax
  802605:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80260a:	09 f0                	or     %esi,%eax
  80260c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802610:	f7 34 24             	divl   (%esp)
  802613:	d3 e6                	shl    %cl,%esi
  802615:	89 74 24 08          	mov    %esi,0x8(%esp)
  802619:	89 d6                	mov    %edx,%esi
  80261b:	f7 e7                	mul    %edi
  80261d:	39 d6                	cmp    %edx,%esi
  80261f:	89 c1                	mov    %eax,%ecx
  802621:	89 d7                	mov    %edx,%edi
  802623:	72 3f                	jb     802664 <__umoddi3+0x154>
  802625:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802629:	72 35                	jb     802660 <__umoddi3+0x150>
  80262b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80262f:	29 c8                	sub    %ecx,%eax
  802631:	19 fe                	sbb    %edi,%esi
  802633:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802638:	89 f2                	mov    %esi,%edx
  80263a:	d3 e8                	shr    %cl,%eax
  80263c:	89 e9                	mov    %ebp,%ecx
  80263e:	d3 e2                	shl    %cl,%edx
  802640:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802645:	09 d0                	or     %edx,%eax
  802647:	89 f2                	mov    %esi,%edx
  802649:	d3 ea                	shr    %cl,%edx
  80264b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80264f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802653:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802657:	83 c4 1c             	add    $0x1c,%esp
  80265a:	c3                   	ret    
  80265b:	90                   	nop
  80265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802660:	39 d6                	cmp    %edx,%esi
  802662:	75 c7                	jne    80262b <__umoddi3+0x11b>
  802664:	89 d7                	mov    %edx,%edi
  802666:	89 c1                	mov    %eax,%ecx
  802668:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80266c:	1b 3c 24             	sbb    (%esp),%edi
  80266f:	eb ba                	jmp    80262b <__umoddi3+0x11b>
  802671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802678:	39 f5                	cmp    %esi,%ebp
  80267a:	0f 82 f1 fe ff ff    	jb     802571 <__umoddi3+0x61>
  802680:	e9 f8 fe ff ff       	jmp    80257d <__umoddi3+0x6d>
