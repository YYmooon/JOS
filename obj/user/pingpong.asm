
obj/user/pingpong.debug:     file format elf32-i386


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

00800034 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003d:	e8 b1 10 00 00       	call   8010f3 <fork>
  800042:	89 c3                	mov    %eax,%ebx
  800044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800047:	85 c0                	test   %eax,%eax
  800049:	74 3c                	je     800087 <umain+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004b:	e8 7c 0c 00 00       	call   800ccc <sys_getenvid>
  800050:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  80005f:	e8 a3 01 00 00       	call   800207 <cprintf>
		ipc_send(who, 0, 0, 0);
  800064:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006b:	00 
  80006c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800073:	00 
  800074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007b:	00 
  80007c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 6b 13 00 00       	call   8013f2 <ipc_send>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800087:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800099:	00 
  80009a:	89 3c 24             	mov    %edi,(%esp)
  80009d:	e8 fe 12 00 00       	call   8013a0 <ipc_recv>
  8000a2:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a7:	e8 20 0c 00 00       	call   800ccc <sys_getenvid>
  8000ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b8:	c7 04 24 b6 26 80 00 	movl   $0x8026b6,(%esp)
  8000bf:	e8 43 01 00 00       	call   800207 <cprintf>
		if (i == 10)
  8000c4:	83 fb 0a             	cmp    $0xa,%ebx
  8000c7:	74 27                	je     8000f0 <umain+0xbc>
			return;
		i++;
  8000c9:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d3:	00 
  8000d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e3:	89 04 24             	mov    %eax,(%esp)
  8000e6:	e8 07 13 00 00       	call   8013f2 <ipc_send>
		if (i == 10)
  8000eb:	83 fb 0a             	cmp    $0xa,%ebx
  8000ee:	75 9a                	jne    80008a <umain+0x56>
			return;
	}

}
  8000f0:	83 c4 2c             	add    $0x2c,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

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
  80010a:	e8 bd 0b 00 00       	call   800ccc <sys_getenvid>
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
  800133:	e8 fc fe ff ff       	call   800034 <umain>

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
  80014e:	e8 8b 15 00 00       	call   8016de <close_all>
	sys_env_destroy(0);
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 10 0b 00 00       	call   800c6f <sys_env_destroy>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    
  800161:	00 00                	add    %al,(%eax)
	...

00800164 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	53                   	push   %ebx
  800168:	83 ec 14             	sub    $0x14,%esp
  80016b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016e:	8b 03                	mov    (%ebx),%eax
  800170:	8b 55 08             	mov    0x8(%ebp),%edx
  800173:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800177:	83 c0 01             	add    $0x1,%eax
  80017a:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80017c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800181:	75 19                	jne    80019c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800183:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80018a:	00 
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 7a 0a 00 00       	call   800c10 <sys_cputs>
		b->idx = 0;
  800196:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80019c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a0:	83 c4 14             	add    $0x14,%esp
  8001a3:	5b                   	pop    %ebx
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b6:	00 00 00 
	b.cnt = 0;
  8001b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001db:	c7 04 24 64 01 80 00 	movl   $0x800164,(%esp)
  8001e2:	e8 a3 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f7:	89 04 24             	mov    %eax,(%esp)
  8001fa:	e8 11 0a 00 00       	call   800c10 <sys_cputs>

	return b.cnt;
}
  8001ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	8b 45 08             	mov    0x8(%ebp),%eax
  800217:	89 04 24             	mov    %eax,(%esp)
  80021a:	e8 87 ff ff ff       	call   8001a6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    
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
  8002f6:	0f be 80 d3 26 80 00 	movsbl 0x8026d3(%eax),%eax
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
  80041e:	ff 24 85 20 28 80 00 	jmp    *0x802820(,%eax,4)
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
  8004d4:	8b 14 85 80 29 80 00 	mov    0x802980(,%eax,4),%edx
  8004db:	85 d2                	test   %edx,%edx
  8004dd:	75 23                	jne    800502 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8004df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e3:	c7 44 24 08 eb 26 80 	movl   $0x8026eb,0x8(%esp)
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
  800506:	c7 44 24 08 65 2c 80 	movl   $0x802c65,0x8(%esp)
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
  80053b:	ba e4 26 80 00       	mov    $0x8026e4,%edx
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
  800ca3:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800caa:	00 
  800cab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb2:	00 
  800cb3:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800cba:	e8 f1 15 00 00       	call   8022b0 <_panic>

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
  800d62:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800d69:	00 
  800d6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d71:	00 
  800d72:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800d79:	e8 32 15 00 00       	call   8022b0 <_panic>

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
  800dc0:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800dc7:	00 
  800dc8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcf:	00 
  800dd0:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800dd7:	e8 d4 14 00 00       	call   8022b0 <_panic>

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
  800e1e:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800e25:	00 
  800e26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2d:	00 
  800e2e:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800e35:	e8 76 14 00 00       	call   8022b0 <_panic>

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
  800e7c:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800e83:	00 
  800e84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8b:	00 
  800e8c:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800e93:	e8 18 14 00 00       	call   8022b0 <_panic>

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
  800eda:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee9:	00 
  800eea:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800ef1:	e8 ba 13 00 00       	call   8022b0 <_panic>

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
  800f38:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800f3f:	00 
  800f40:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f47:	00 
  800f48:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800f4f:	e8 5c 13 00 00       	call   8022b0 <_panic>

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
  800fc9:	c7 44 24 08 df 29 80 	movl   $0x8029df,0x8(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd8:	00 
  800fd9:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  800fe0:	e8 cb 12 00 00       	call   8022b0 <_panic>

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
  801027:	c7 44 24 08 0c 2a 80 	movl   $0x802a0c,0x8(%esp)
  80102e:	00 
  80102f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801036:	00 
  801037:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  80103e:	e8 6d 12 00 00       	call   8022b0 <_panic>
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
  801067:	c7 44 24 08 48 2a 80 	movl   $0x802a48,0x8(%esp)
  80106e:	00 
  80106f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801076:	00 
  801077:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  80107e:	e8 2d 12 00 00       	call   8022b0 <_panic>
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
  8010d1:	c7 44 24 08 70 2a 80 	movl   $0x802a70,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  8010e8:	e8 c3 11 00 00       	call   8022b0 <_panic>
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
  801103:	e8 00 12 00 00       	call   802308 <set_pgfault_handler>
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
  80111e:	c7 44 24 08 6e 2b 80 	movl   $0x802b6e,0x8(%esp)
  801125:	00 
  801126:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80112d:	00 
  80112e:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  801135:	e8 76 11 00 00       	call   8022b0 <_panic>
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
  8011d5:	c7 44 24 08 7e 2b 80 	movl   $0x802b7e,0x8(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  8011e4:	00 
  8011e5:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  8011ec:	e8 bf 10 00 00       	call   8022b0 <_panic>
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
  801224:	c7 44 24 08 94 2a 80 	movl   $0x802a94,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  80123b:	e8 70 10 00 00       	call   8022b0 <_panic>
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
  80126c:	c7 44 24 08 c0 2a 80 	movl   $0x802ac0,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  801283:	e8 28 10 00 00       	call   8022b0 <_panic>
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
  8012b0:	c7 44 24 08 ec 2a 80 	movl   $0x802aec,0x8(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8012bf:	00 
  8012c0:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  8012c7:	e8 e4 0f 00 00       	call   8022b0 <_panic>
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
  801301:	c7 44 24 08 18 2b 80 	movl   $0x802b18,0x8(%esp)
  801308:	00 
  801309:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801310:	00 
  801311:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  801318:	e8 93 0f 00 00       	call   8022b0 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80131d:	c7 44 24 04 78 23 80 	movl   $0x802378,0x4(%esp)
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
  80134b:	c7 44 24 08 3c 2b 80 	movl   $0x802b3c,0x8(%esp)
  801352:	00 
  801353:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80135a:	00 
  80135b:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  801362:	e8 49 0f 00 00       	call   8022b0 <_panic>
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
  801378:	c7 44 24 08 95 2b 80 	movl   $0x802b95,0x8(%esp)
  80137f:	00 
  801380:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801387:	00 
  801388:	c7 04 24 63 2b 80 00 	movl   $0x802b63,(%esp)
  80138f:	e8 1c 0f 00 00       	call   8022b0 <_panic>
	...

008013a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 10             	sub    $0x10,%esp
  8013a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  8013b1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  8013b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8013b8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	e8 d2 fb ff ff       	call   800f95 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8013c3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8013c8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 0e                	js     8013df <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8013d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8013d9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8013dc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8013df:	85 f6                	test   %esi,%esi
  8013e1:	74 02                	je     8013e5 <ipc_recv+0x45>
		*from_env_store = sender;
  8013e3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8013e5:	85 db                	test   %ebx,%ebx
  8013e7:	74 02                	je     8013eb <ipc_recv+0x4b>
		*perm_store = perm;
  8013e9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	5b                   	pop    %ebx
  8013ef:	5e                   	pop    %esi
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    

008013f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	57                   	push   %edi
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 1c             	sub    $0x1c,%esp
  8013fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8013fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801401:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801404:	85 db                	test   %ebx,%ebx
  801406:	75 04                	jne    80140c <ipc_send+0x1a>
  801408:	85 f6                	test   %esi,%esi
  80140a:	75 15                	jne    801421 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80140c:	85 db                	test   %ebx,%ebx
  80140e:	74 16                	je     801426 <ipc_send+0x34>
  801410:	85 f6                	test   %esi,%esi
  801412:	0f 94 c0             	sete   %al
      pg = 0;
  801415:	84 c0                	test   %al,%al
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
  80141c:	0f 45 d8             	cmovne %eax,%ebx
  80141f:	eb 05                	jmp    801426 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801421:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801426:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80142a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	89 04 24             	mov    %eax,(%esp)
  801438:	e8 24 fb ff ff       	call   800f61 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80143d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801440:	75 07                	jne    801449 <ipc_send+0x57>
           sys_yield();
  801442:	e8 b5 f8 ff ff       	call   800cfc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801447:	eb dd                	jmp    801426 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801449:	85 c0                	test   %eax,%eax
  80144b:	90                   	nop
  80144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801450:	74 1c                	je     80146e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801452:	c7 44 24 08 ab 2b 80 	movl   $0x802bab,0x8(%esp)
  801459:	00 
  80145a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801461:	00 
  801462:	c7 04 24 b5 2b 80 00 	movl   $0x802bb5,(%esp)
  801469:	e8 42 0e 00 00       	call   8022b0 <_panic>
		}
    }
}
  80146e:	83 c4 1c             	add    $0x1c,%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80147c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801481:	39 c8                	cmp    %ecx,%eax
  801483:	74 17                	je     80149c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801485:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80148a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80148d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801493:	8b 52 50             	mov    0x50(%edx),%edx
  801496:	39 ca                	cmp    %ecx,%edx
  801498:	75 14                	jne    8014ae <ipc_find_env+0x38>
  80149a:	eb 05                	jmp    8014a1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8014a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014a4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8014a9:	8b 40 40             	mov    0x40(%eax),%eax
  8014ac:	eb 0e                	jmp    8014bc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014ae:	83 c0 01             	add    $0x1,%eax
  8014b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014b6:	75 d2                	jne    80148a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8014b8:	66 b8 00 00          	mov    $0x0,%ax
}
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    
	...

008014c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	89 04 24             	mov    %eax,(%esp)
  8014dc:	e8 df ff ff ff       	call   8014c0 <fd2num>
  8014e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	53                   	push   %ebx
  8014ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014f2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014f7:	a8 01                	test   $0x1,%al
  8014f9:	74 34                	je     80152f <fd_alloc+0x44>
  8014fb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801500:	a8 01                	test   $0x1,%al
  801502:	74 32                	je     801536 <fd_alloc+0x4b>
  801504:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801509:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80150b:	89 c2                	mov    %eax,%edx
  80150d:	c1 ea 16             	shr    $0x16,%edx
  801510:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801517:	f6 c2 01             	test   $0x1,%dl
  80151a:	74 1f                	je     80153b <fd_alloc+0x50>
  80151c:	89 c2                	mov    %eax,%edx
  80151e:	c1 ea 0c             	shr    $0xc,%edx
  801521:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801528:	f6 c2 01             	test   $0x1,%dl
  80152b:	75 17                	jne    801544 <fd_alloc+0x59>
  80152d:	eb 0c                	jmp    80153b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80152f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801534:	eb 05                	jmp    80153b <fd_alloc+0x50>
  801536:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80153b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	eb 17                	jmp    80155b <fd_alloc+0x70>
  801544:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801549:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80154e:	75 b9                	jne    801509 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801550:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801556:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80155b:	5b                   	pop    %ebx
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801564:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801569:	83 fa 1f             	cmp    $0x1f,%edx
  80156c:	77 3f                	ja     8015ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80156e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801574:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801577:	89 d0                	mov    %edx,%eax
  801579:	c1 e8 16             	shr    $0x16,%eax
  80157c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801588:	f6 c1 01             	test   $0x1,%cl
  80158b:	74 20                	je     8015ad <fd_lookup+0x4f>
  80158d:	89 d0                	mov    %edx,%eax
  80158f:	c1 e8 0c             	shr    $0xc,%eax
  801592:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801599:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80159e:	f6 c1 01             	test   $0x1,%cl
  8015a1:	74 0a                	je     8015ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	89 10                	mov    %edx,(%eax)
	return 0;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    

008015af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	53                   	push   %ebx
  8015b3:	83 ec 14             	sub    $0x14,%esp
  8015b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015c1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8015c7:	75 17                	jne    8015e0 <dev_lookup+0x31>
  8015c9:	eb 07                	jmp    8015d2 <dev_lookup+0x23>
  8015cb:	39 0a                	cmp    %ecx,(%edx)
  8015cd:	75 11                	jne    8015e0 <dev_lookup+0x31>
  8015cf:	90                   	nop
  8015d0:	eb 05                	jmp    8015d7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015d2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8015d7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015de:	eb 35                	jmp    801615 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015e0:	83 c0 01             	add    $0x1,%eax
  8015e3:	8b 14 85 3c 2c 80 00 	mov    0x802c3c(,%eax,4),%edx
  8015ea:	85 d2                	test   %edx,%edx
  8015ec:	75 dd                	jne    8015cb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8015f3:	8b 40 48             	mov    0x48(%eax),%eax
  8015f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fe:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  801605:	e8 fd eb ff ff       	call   800207 <cprintf>
	*dev = 0;
  80160a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801610:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801615:	83 c4 14             	add    $0x14,%esp
  801618:	5b                   	pop    %ebx
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 38             	sub    $0x38,%esp
  801621:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801624:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801627:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80162a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80162d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801631:	89 3c 24             	mov    %edi,(%esp)
  801634:	e8 87 fe ff ff       	call   8014c0 <fd2num>
  801639:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80163c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801640:	89 04 24             	mov    %eax,(%esp)
  801643:	e8 16 ff ff ff       	call   80155e <fd_lookup>
  801648:	89 c3                	mov    %eax,%ebx
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 05                	js     801653 <fd_close+0x38>
	    || fd != fd2)
  80164e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801651:	74 0e                	je     801661 <fd_close+0x46>
		return (must_exist ? r : 0);
  801653:	89 f0                	mov    %esi,%eax
  801655:	84 c0                	test   %al,%al
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	0f 44 d8             	cmove  %eax,%ebx
  80165f:	eb 3d                	jmp    80169e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801661:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	8b 07                	mov    (%edi),%eax
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	e8 3d ff ff ff       	call   8015af <dev_lookup>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	85 c0                	test   %eax,%eax
  801676:	78 16                	js     80168e <fd_close+0x73>
		if (dev->dev_close)
  801678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80167e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801683:	85 c0                	test   %eax,%eax
  801685:	74 07                	je     80168e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801687:	89 3c 24             	mov    %edi,(%esp)
  80168a:	ff d0                	call   *%eax
  80168c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80168e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801699:	e8 4b f7 ff ff       	call   800de9 <sys_page_unmap>
	return r;
}
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016a9:	89 ec                	mov    %ebp,%esp
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    

008016ad <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	89 04 24             	mov    %eax,(%esp)
  8016c0:	e8 99 fe ff ff       	call   80155e <fd_lookup>
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 13                	js     8016dc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016d0:	00 
  8016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d4:	89 04 24             	mov    %eax,(%esp)
  8016d7:	e8 3f ff ff ff       	call   80161b <fd_close>
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <close_all>:

void
close_all(void)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016ea:	89 1c 24             	mov    %ebx,(%esp)
  8016ed:	e8 bb ff ff ff       	call   8016ad <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016f2:	83 c3 01             	add    $0x1,%ebx
  8016f5:	83 fb 20             	cmp    $0x20,%ebx
  8016f8:	75 f0                	jne    8016ea <close_all+0xc>
		close(i);
}
  8016fa:	83 c4 14             	add    $0x14,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 58             	sub    $0x58,%esp
  801706:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801709:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80170c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80170f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801712:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801715:	89 44 24 04          	mov    %eax,0x4(%esp)
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 04 24             	mov    %eax,(%esp)
  80171f:	e8 3a fe ff ff       	call   80155e <fd_lookup>
  801724:	89 c3                	mov    %eax,%ebx
  801726:	85 c0                	test   %eax,%eax
  801728:	0f 88 e1 00 00 00    	js     80180f <dup+0x10f>
		return r;
	close(newfdnum);
  80172e:	89 3c 24             	mov    %edi,(%esp)
  801731:	e8 77 ff ff ff       	call   8016ad <close>

	newfd = INDEX2FD(newfdnum);
  801736:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80173c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80173f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801742:	89 04 24             	mov    %eax,(%esp)
  801745:	e8 86 fd ff ff       	call   8014d0 <fd2data>
  80174a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80174c:	89 34 24             	mov    %esi,(%esp)
  80174f:	e8 7c fd ff ff       	call   8014d0 <fd2data>
  801754:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801757:	89 d8                	mov    %ebx,%eax
  801759:	c1 e8 16             	shr    $0x16,%eax
  80175c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801763:	a8 01                	test   $0x1,%al
  801765:	74 46                	je     8017ad <dup+0xad>
  801767:	89 d8                	mov    %ebx,%eax
  801769:	c1 e8 0c             	shr    $0xc,%eax
  80176c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801773:	f6 c2 01             	test   $0x1,%dl
  801776:	74 35                	je     8017ad <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801778:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80177f:	25 07 0e 00 00       	and    $0xe07,%eax
  801784:	89 44 24 10          	mov    %eax,0x10(%esp)
  801788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80178b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80178f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801796:	00 
  801797:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80179b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a2:	e8 e4 f5 ff ff       	call   800d8b <sys_page_map>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 3b                	js     8017e8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	c1 ea 0c             	shr    $0xc,%edx
  8017b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017bc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017d1:	00 
  8017d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017dd:	e8 a9 f5 ff ff       	call   800d8b <sys_page_map>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	79 25                	jns    80180d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f3:	e8 f1 f5 ff ff       	call   800de9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801806:	e8 de f5 ff ff       	call   800de9 <sys_page_unmap>
	return r;
  80180b:	eb 02                	jmp    80180f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80180d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80180f:	89 d8                	mov    %ebx,%eax
  801811:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801814:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801817:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80181a:	89 ec                	mov    %ebp,%esp
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	53                   	push   %ebx
  801822:	83 ec 24             	sub    $0x24,%esp
  801825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801828:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	89 1c 24             	mov    %ebx,(%esp)
  801832:	e8 27 fd ff ff       	call   80155e <fd_lookup>
  801837:	85 c0                	test   %eax,%eax
  801839:	78 6d                	js     8018a8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 60 fd ff ff       	call   8015af <dev_lookup>
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 55                	js     8018a8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801856:	8b 50 08             	mov    0x8(%eax),%edx
  801859:	83 e2 03             	and    $0x3,%edx
  80185c:	83 fa 01             	cmp    $0x1,%edx
  80185f:	75 23                	jne    801884 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801861:	a1 04 40 80 00       	mov    0x804004,%eax
  801866:	8b 40 48             	mov    0x48(%eax),%eax
  801869:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801871:	c7 04 24 01 2c 80 00 	movl   $0x802c01,(%esp)
  801878:	e8 8a e9 ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  80187d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801882:	eb 24                	jmp    8018a8 <read+0x8a>
	}
	if (!dev->dev_read)
  801884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801887:	8b 52 08             	mov    0x8(%edx),%edx
  80188a:	85 d2                	test   %edx,%edx
  80188c:	74 15                	je     8018a3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801895:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801898:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80189c:	89 04 24             	mov    %eax,(%esp)
  80189f:	ff d2                	call   *%edx
  8018a1:	eb 05                	jmp    8018a8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018a8:	83 c4 24             	add    $0x24,%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    

008018ae <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 1c             	sub    $0x1c,%esp
  8018b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c2:	85 f6                	test   %esi,%esi
  8018c4:	74 30                	je     8018f6 <readn+0x48>
  8018c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018cb:	89 f2                	mov    %esi,%edx
  8018cd:	29 c2                	sub    %eax,%edx
  8018cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018d3:	03 45 0c             	add    0xc(%ebp),%eax
  8018d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018da:	89 3c 24             	mov    %edi,(%esp)
  8018dd:	e8 3c ff ff ff       	call   80181e <read>
		if (m < 0)
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 10                	js     8018f6 <readn+0x48>
			return m;
		if (m == 0)
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	74 0a                	je     8018f4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ea:	01 c3                	add    %eax,%ebx
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	39 f3                	cmp    %esi,%ebx
  8018f0:	72 d9                	jb     8018cb <readn+0x1d>
  8018f2:	eb 02                	jmp    8018f6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8018f4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8018f6:	83 c4 1c             	add    $0x1c,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5f                   	pop    %edi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	53                   	push   %ebx
  801902:	83 ec 24             	sub    $0x24,%esp
  801905:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801908:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190f:	89 1c 24             	mov    %ebx,(%esp)
  801912:	e8 47 fc ff ff       	call   80155e <fd_lookup>
  801917:	85 c0                	test   %eax,%eax
  801919:	78 68                	js     801983 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	8b 00                	mov    (%eax),%eax
  801927:	89 04 24             	mov    %eax,(%esp)
  80192a:	e8 80 fc ff ff       	call   8015af <dev_lookup>
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 50                	js     801983 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801936:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193a:	75 23                	jne    80195f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80193c:	a1 04 40 80 00       	mov    0x804004,%eax
  801941:	8b 40 48             	mov    0x48(%eax),%eax
  801944:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194c:	c7 04 24 1d 2c 80 00 	movl   $0x802c1d,(%esp)
  801953:	e8 af e8 ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  801958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195d:	eb 24                	jmp    801983 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80195f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801962:	8b 52 0c             	mov    0xc(%edx),%edx
  801965:	85 d2                	test   %edx,%edx
  801967:	74 15                	je     80197e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801973:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801977:	89 04 24             	mov    %eax,(%esp)
  80197a:	ff d2                	call   *%edx
  80197c:	eb 05                	jmp    801983 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80197e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801983:	83 c4 24             	add    $0x24,%esp
  801986:	5b                   	pop    %ebx
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <seek>:

int
seek(int fdnum, off_t offset)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801992:	89 44 24 04          	mov    %eax,0x4(%esp)
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	89 04 24             	mov    %eax,(%esp)
  80199c:	e8 bd fb ff ff       	call   80155e <fd_lookup>
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 0e                	js     8019b3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 24             	sub    $0x24,%esp
  8019bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 90 fb ff ff       	call   80155e <fd_lookup>
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 61                	js     801a33 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	e8 c9 fb ff ff       	call   8015af <dev_lookup>
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 49                	js     801a33 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019f1:	75 23                	jne    801a16 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019f3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019f8:	8b 40 48             	mov    0x48(%eax),%eax
  8019fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a03:	c7 04 24 e0 2b 80 00 	movl   $0x802be0,(%esp)
  801a0a:	e8 f8 e7 ff ff       	call   800207 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a14:	eb 1d                	jmp    801a33 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a19:	8b 52 18             	mov    0x18(%edx),%edx
  801a1c:	85 d2                	test   %edx,%edx
  801a1e:	74 0e                	je     801a2e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a27:	89 04 24             	mov    %eax,(%esp)
  801a2a:	ff d2                	call   *%edx
  801a2c:	eb 05                	jmp    801a33 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a33:	83 c4 24             	add    $0x24,%esp
  801a36:	5b                   	pop    %ebx
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	53                   	push   %ebx
  801a3d:	83 ec 24             	sub    $0x24,%esp
  801a40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 04 24             	mov    %eax,(%esp)
  801a50:	e8 09 fb ff ff       	call   80155e <fd_lookup>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 52                	js     801aab <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a63:	8b 00                	mov    (%eax),%eax
  801a65:	89 04 24             	mov    %eax,(%esp)
  801a68:	e8 42 fb ff ff       	call   8015af <dev_lookup>
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 3a                	js     801aab <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a74:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a78:	74 2c                	je     801aa6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a7a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a7d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a84:	00 00 00 
	stat->st_isdir = 0;
  801a87:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a8e:	00 00 00 
	stat->st_dev = dev;
  801a91:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9e:	89 14 24             	mov    %edx,(%esp)
  801aa1:	ff 50 14             	call   *0x14(%eax)
  801aa4:	eb 05                	jmp    801aab <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801aa6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aab:	83 c4 24             	add    $0x24,%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
  801ab7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801aba:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801abd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ac4:	00 
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	89 04 24             	mov    %eax,(%esp)
  801acb:	e8 bc 01 00 00       	call   801c8c <open>
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 1b                	js     801af1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801add:	89 1c 24             	mov    %ebx,(%esp)
  801ae0:	e8 54 ff ff ff       	call   801a39 <fstat>
  801ae5:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae7:	89 1c 24             	mov    %ebx,(%esp)
  801aea:	e8 be fb ff ff       	call   8016ad <close>
	return r;
  801aef:	89 f3                	mov    %esi,%ebx
}
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801af6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801af9:	89 ec                	mov    %ebp,%esp
  801afb:	5d                   	pop    %ebp
  801afc:	c3                   	ret    
  801afd:	00 00                	add    %al,(%eax)
	...

00801b00 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 18             	sub    $0x18,%esp
  801b06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b0c:	89 c3                	mov    %eax,%ebx
  801b0e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b10:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b17:	75 11                	jne    801b2a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b20:	e8 51 f9 ff ff       	call   801476 <ipc_find_env>
  801b25:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b2a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b31:	00 
  801b32:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b39:	00 
  801b3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b3e:	a1 00 40 80 00       	mov    0x804000,%eax
  801b43:	89 04 24             	mov    %eax,(%esp)
  801b46:	e8 a7 f8 ff ff       	call   8013f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b52:	00 
  801b53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5e:	e8 3d f8 ff ff       	call   8013a0 <ipc_recv>
}
  801b63:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b66:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b69:	89 ec                	mov    %ebp,%esp
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	53                   	push   %ebx
  801b71:	83 ec 14             	sub    $0x14,%esp
  801b74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b82:	ba 00 00 00 00       	mov    $0x0,%edx
  801b87:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8c:	e8 6f ff ff ff       	call   801b00 <fsipc>
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 2b                	js     801bc0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b95:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b9c:	00 
  801b9d:	89 1c 24             	mov    %ebx,(%esp)
  801ba0:	e8 86 ec ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ba5:	a1 80 50 80 00       	mov    0x805080,%eax
  801baa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bb0:	a1 84 50 80 00       	mov    0x805084,%eax
  801bb5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc0:	83 c4 14             	add    $0x14,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    

00801bc6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdc:	b8 06 00 00 00       	mov    $0x6,%eax
  801be1:	e8 1a ff ff ff       	call   801b00 <fsipc>
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 10             	sub    $0x10,%esp
  801bf0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801bfe:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c04:	ba 00 00 00 00       	mov    $0x0,%edx
  801c09:	b8 03 00 00 00       	mov    $0x3,%eax
  801c0e:	e8 ed fe ff ff       	call   801b00 <fsipc>
  801c13:	89 c3                	mov    %eax,%ebx
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 6a                	js     801c83 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c19:	39 c6                	cmp    %eax,%esi
  801c1b:	73 24                	jae    801c41 <devfile_read+0x59>
  801c1d:	c7 44 24 0c 4c 2c 80 	movl   $0x802c4c,0xc(%esp)
  801c24:	00 
  801c25:	c7 44 24 08 53 2c 80 	movl   $0x802c53,0x8(%esp)
  801c2c:	00 
  801c2d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c34:	00 
  801c35:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  801c3c:	e8 6f 06 00 00       	call   8022b0 <_panic>
	assert(r <= PGSIZE);
  801c41:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c46:	7e 24                	jle    801c6c <devfile_read+0x84>
  801c48:	c7 44 24 0c 73 2c 80 	movl   $0x802c73,0xc(%esp)
  801c4f:	00 
  801c50:	c7 44 24 08 53 2c 80 	movl   $0x802c53,0x8(%esp)
  801c57:	00 
  801c58:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801c5f:	00 
  801c60:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  801c67:	e8 44 06 00 00       	call   8022b0 <_panic>
	memmove(buf, &fsipcbuf, r);
  801c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c70:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c77:	00 
  801c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 99 ed ff ff       	call   800a1c <memmove>
	return r;
}
  801c83:	89 d8                	mov    %ebx,%eax
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	83 ec 20             	sub    $0x20,%esp
  801c94:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c97:	89 34 24             	mov    %esi,(%esp)
  801c9a:	e8 41 eb ff ff       	call   8007e0 <strlen>
		return -E_BAD_PATH;
  801c9f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ca4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca9:	7f 5e                	jg     801d09 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 35 f8 ff ff       	call   8014eb <fd_alloc>
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 4d                	js     801d09 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cc0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801cc7:	e8 5f eb ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdc:	e8 1f fe ff ff       	call   801b00 <fsipc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	79 15                	jns    801cfc <open+0x70>
		fd_close(fd, 0);
  801ce7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cee:	00 
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	89 04 24             	mov    %eax,(%esp)
  801cf5:	e8 21 f9 ff ff       	call   80161b <fd_close>
		return r;
  801cfa:	eb 0d                	jmp    801d09 <open+0x7d>
	}

	return fd2num(fd);
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 b9 f7 ff ff       	call   8014c0 <fd2num>
  801d07:	89 c3                	mov    %eax,%ebx
}
  801d09:	89 d8                	mov    %ebx,%eax
  801d0b:	83 c4 20             	add    $0x20,%esp
  801d0e:	5b                   	pop    %ebx
  801d0f:	5e                   	pop    %esi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    
	...

00801d20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 18             	sub    $0x18,%esp
  801d26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	89 04 24             	mov    %eax,(%esp)
  801d35:	e8 96 f7 ff ff       	call   8014d0 <fd2data>
  801d3a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d3c:	c7 44 24 04 7f 2c 80 	movl   $0x802c7f,0x4(%esp)
  801d43:	00 
  801d44:	89 34 24             	mov    %esi,(%esp)
  801d47:	e8 df ea ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d4c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d4f:	2b 03                	sub    (%ebx),%eax
  801d51:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801d57:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801d5e:	00 00 00 
	stat->st_dev = &devpipe;
  801d61:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801d68:	30 80 00 
	return 0;
}
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d73:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d76:	89 ec                	mov    %ebp,%esp
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 14             	sub    $0x14,%esp
  801d81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8f:	e8 55 f0 ff ff       	call   800de9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d94:	89 1c 24             	mov    %ebx,(%esp)
  801d97:	e8 34 f7 ff ff       	call   8014d0 <fd2data>
  801d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da7:	e8 3d f0 ff ff       	call   800de9 <sys_page_unmap>
}
  801dac:	83 c4 14             	add    $0x14,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 2c             	sub    $0x2c,%esp
  801dbb:	89 c7                	mov    %eax,%edi
  801dbd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801dc0:	a1 04 40 80 00       	mov    0x804004,%eax
  801dc5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc8:	89 3c 24             	mov    %edi,(%esp)
  801dcb:	e8 d0 05 00 00       	call   8023a0 <pageref>
  801dd0:	89 c6                	mov    %eax,%esi
  801dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd5:	89 04 24             	mov    %eax,(%esp)
  801dd8:	e8 c3 05 00 00       	call   8023a0 <pageref>
  801ddd:	39 c6                	cmp    %eax,%esi
  801ddf:	0f 94 c0             	sete   %al
  801de2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801de5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801deb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dee:	39 cb                	cmp    %ecx,%ebx
  801df0:	75 08                	jne    801dfa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801df2:	83 c4 2c             	add    $0x2c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801dfa:	83 f8 01             	cmp    $0x1,%eax
  801dfd:	75 c1                	jne    801dc0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dff:	8b 52 58             	mov    0x58(%edx),%edx
  801e02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e06:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e0e:	c7 04 24 86 2c 80 00 	movl   $0x802c86,(%esp)
  801e15:	e8 ed e3 ff ff       	call   800207 <cprintf>
  801e1a:	eb a4                	jmp    801dc0 <_pipeisclosed+0xe>

00801e1c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	57                   	push   %edi
  801e20:	56                   	push   %esi
  801e21:	53                   	push   %ebx
  801e22:	83 ec 2c             	sub    $0x2c,%esp
  801e25:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e28:	89 34 24             	mov    %esi,(%esp)
  801e2b:	e8 a0 f6 ff ff       	call   8014d0 <fd2data>
  801e30:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e32:	bf 00 00 00 00       	mov    $0x0,%edi
  801e37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3b:	75 50                	jne    801e8d <devpipe_write+0x71>
  801e3d:	eb 5c                	jmp    801e9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e3f:	89 da                	mov    %ebx,%edx
  801e41:	89 f0                	mov    %esi,%eax
  801e43:	e8 6a ff ff ff       	call   801db2 <_pipeisclosed>
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	75 53                	jne    801e9f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e4c:	e8 ab ee ff ff       	call   800cfc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e51:	8b 43 04             	mov    0x4(%ebx),%eax
  801e54:	8b 13                	mov    (%ebx),%edx
  801e56:	83 c2 20             	add    $0x20,%edx
  801e59:	39 d0                	cmp    %edx,%eax
  801e5b:	73 e2                	jae    801e3f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801e64:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801e67:	89 c2                	mov    %eax,%edx
  801e69:	c1 fa 1f             	sar    $0x1f,%edx
  801e6c:	c1 ea 1b             	shr    $0x1b,%edx
  801e6f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e72:	83 e1 1f             	and    $0x1f,%ecx
  801e75:	29 d1                	sub    %edx,%ecx
  801e77:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e7b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e7f:	83 c0 01             	add    $0x1,%eax
  801e82:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e85:	83 c7 01             	add    $0x1,%edi
  801e88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e8b:	74 0e                	je     801e9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e90:	8b 13                	mov    (%ebx),%edx
  801e92:	83 c2 20             	add    $0x20,%edx
  801e95:	39 d0                	cmp    %edx,%eax
  801e97:	73 a6                	jae    801e3f <devpipe_write+0x23>
  801e99:	eb c2                	jmp    801e5d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e9b:	89 f8                	mov    %edi,%eax
  801e9d:	eb 05                	jmp    801ea4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ea4:	83 c4 2c             	add    $0x2c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    

00801eac <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 28             	sub    $0x28,%esp
  801eb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801eb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801eb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ebb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ebe:	89 3c 24             	mov    %edi,(%esp)
  801ec1:	e8 0a f6 ff ff       	call   8014d0 <fd2data>
  801ec6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ec8:	be 00 00 00 00       	mov    $0x0,%esi
  801ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed1:	75 47                	jne    801f1a <devpipe_read+0x6e>
  801ed3:	eb 52                	jmp    801f27 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ed5:	89 f0                	mov    %esi,%eax
  801ed7:	eb 5e                	jmp    801f37 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ed9:	89 da                	mov    %ebx,%edx
  801edb:	89 f8                	mov    %edi,%eax
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	e8 cd fe ff ff       	call   801db2 <_pipeisclosed>
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	75 49                	jne    801f32 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ee9:	e8 0e ee ff ff       	call   800cfc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801eee:	8b 03                	mov    (%ebx),%eax
  801ef0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ef3:	74 e4                	je     801ed9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef5:	89 c2                	mov    %eax,%edx
  801ef7:	c1 fa 1f             	sar    $0x1f,%edx
  801efa:	c1 ea 1b             	shr    $0x1b,%edx
  801efd:	01 d0                	add    %edx,%eax
  801eff:	83 e0 1f             	and    $0x1f,%eax
  801f02:	29 d0                	sub    %edx,%eax
  801f04:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f0f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f12:	83 c6 01             	add    $0x1,%esi
  801f15:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f18:	74 0d                	je     801f27 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801f1a:	8b 03                	mov    (%ebx),%eax
  801f1c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f1f:	75 d4                	jne    801ef5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f21:	85 f6                	test   %esi,%esi
  801f23:	75 b0                	jne    801ed5 <devpipe_read+0x29>
  801f25:	eb b2                	jmp    801ed9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f27:	89 f0                	mov    %esi,%eax
  801f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f30:	eb 05                	jmp    801f37 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f37:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f3a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f3d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f40:	89 ec                	mov    %ebp,%esp
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 48             	sub    $0x48,%esp
  801f4a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f4d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f50:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f53:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f56:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f59:	89 04 24             	mov    %eax,(%esp)
  801f5c:	e8 8a f5 ff ff       	call   8014eb <fd_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	85 c0                	test   %eax,%eax
  801f65:	0f 88 45 01 00 00    	js     8020b0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f72:	00 
  801f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f81:	e8 a6 ed ff ff       	call   800d2c <sys_page_alloc>
  801f86:	89 c3                	mov    %eax,%ebx
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	0f 88 20 01 00 00    	js     8020b0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f90:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f93:	89 04 24             	mov    %eax,(%esp)
  801f96:	e8 50 f5 ff ff       	call   8014eb <fd_alloc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 f8 00 00 00    	js     80209d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fac:	00 
  801fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fbb:	e8 6c ed ff ff       	call   800d2c <sys_page_alloc>
  801fc0:	89 c3                	mov    %eax,%ebx
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	0f 88 d3 00 00 00    	js     80209d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcd:	89 04 24             	mov    %eax,(%esp)
  801fd0:	e8 fb f4 ff ff       	call   8014d0 <fd2data>
  801fd5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fde:	00 
  801fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fea:	e8 3d ed ff ff       	call   800d2c <sys_page_alloc>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	0f 88 91 00 00 00    	js     80208a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffc:	89 04 24             	mov    %eax,(%esp)
  801fff:	e8 cc f4 ff ff       	call   8014d0 <fd2data>
  802004:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80200b:	00 
  80200c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802010:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802017:	00 
  802018:	89 74 24 04          	mov    %esi,0x4(%esp)
  80201c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802023:	e8 63 ed ff ff       	call   800d8b <sys_page_map>
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 4c                	js     80207a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80202e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802037:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802043:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80204e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802051:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80205b:	89 04 24             	mov    %eax,(%esp)
  80205e:	e8 5d f4 ff ff       	call   8014c0 <fd2num>
  802063:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802068:	89 04 24             	mov    %eax,(%esp)
  80206b:	e8 50 f4 ff ff       	call   8014c0 <fd2num>
  802070:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802073:	bb 00 00 00 00       	mov    $0x0,%ebx
  802078:	eb 36                	jmp    8020b0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80207a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80207e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802085:	e8 5f ed ff ff       	call   800de9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80208a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802098:	e8 4c ed ff ff       	call   800de9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80209d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ab:	e8 39 ed ff ff       	call   800de9 <sys_page_unmap>
    err:
	return r;
}
  8020b0:	89 d8                	mov    %ebx,%eax
  8020b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020bb:	89 ec                	mov    %ebp,%esp
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 87 f4 ff ff       	call   80155e <fd_lookup>
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	78 15                	js     8020f0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 ea f3 ff ff       	call   8014d0 <fd2data>
	return _pipeisclosed(fd, p);
  8020e6:	89 c2                	mov    %eax,%edx
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	e8 c2 fc ff ff       	call   801db2 <_pipeisclosed>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    
	...

00802100 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    

0080210a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802110:	c7 44 24 04 9e 2c 80 	movl   $0x802c9e,0x4(%esp)
  802117:	00 
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 08 e7 ff ff       	call   80082b <strcpy>
	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802136:	be 00 00 00 00       	mov    $0x0,%esi
  80213b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213f:	74 43                	je     802184 <devcons_write+0x5a>
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802146:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80214c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80214f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802151:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802154:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802159:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80215c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802160:	03 45 0c             	add    0xc(%ebp),%eax
  802163:	89 44 24 04          	mov    %eax,0x4(%esp)
  802167:	89 3c 24             	mov    %edi,(%esp)
  80216a:	e8 ad e8 ff ff       	call   800a1c <memmove>
		sys_cputs(buf, m);
  80216f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802173:	89 3c 24             	mov    %edi,(%esp)
  802176:	e8 95 ea ff ff       	call   800c10 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80217b:	01 de                	add    %ebx,%esi
  80217d:	89 f0                	mov    %esi,%eax
  80217f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802182:	72 c8                	jb     80214c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802184:	89 f0                	mov    %esi,%eax
  802186:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    

00802191 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80219c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a0:	75 07                	jne    8021a9 <devcons_read+0x18>
  8021a2:	eb 31                	jmp    8021d5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021a4:	e8 53 eb ff ff       	call   800cfc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	e8 8a ea ff ff       	call   800c3f <sys_cgetc>
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 eb                	je     8021a4 <devcons_read+0x13>
  8021b9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 16                	js     8021d5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021bf:	83 f8 04             	cmp    $0x4,%eax
  8021c2:	74 0c                	je     8021d0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8021c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c7:	88 10                	mov    %dl,(%eax)
	return 1;
  8021c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ce:	eb 05                	jmp    8021d5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021d0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021ea:	00 
  8021eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ee:	89 04 24             	mov    %eax,(%esp)
  8021f1:	e8 1a ea ff ff       	call   800c10 <sys_cputs>
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <getchar>:

int
getchar(void)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802205:	00 
  802206:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802214:	e8 05 f6 ff ff       	call   80181e <read>
	if (r < 0)
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 0f                	js     80222c <getchar+0x34>
		return r;
	if (r < 1)
  80221d:	85 c0                	test   %eax,%eax
  80221f:	7e 06                	jle    802227 <getchar+0x2f>
		return -E_EOF;
	return c;
  802221:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802225:	eb 05                	jmp    80222c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802227:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 18 f3 ff ff       	call   80155e <fd_lookup>
  802246:	85 c0                	test   %eax,%eax
  802248:	78 11                	js     80225b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802253:	39 10                	cmp    %edx,(%eax)
  802255:	0f 94 c0             	sete   %al
  802258:	0f b6 c0             	movzbl %al,%eax
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <opencons>:

int
opencons(void)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 7d f2 ff ff       	call   8014eb <fd_alloc>
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 3c                	js     8022ae <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802272:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802279:	00 
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802281:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802288:	e8 9f ea ff ff       	call   800d2c <sys_page_alloc>
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 1d                	js     8022ae <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802291:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022a6:	89 04 24             	mov    %eax,(%esp)
  8022a9:	e8 12 f2 ff ff       	call   8014c0 <fd2num>
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8022b8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022bb:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8022c1:	e8 06 ea ff ff       	call   800ccc <sys_getenvid>
  8022c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022dc:	c7 04 24 ac 2c 80 00 	movl   $0x802cac,(%esp)
  8022e3:	e8 1f df ff ff       	call   800207 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ef:	89 04 24             	mov    %eax,(%esp)
  8022f2:	e8 af de ff ff       	call   8001a6 <vcprintf>
	cprintf("\n");
  8022f7:	c7 04 24 97 2c 80 00 	movl   $0x802c97,(%esp)
  8022fe:	e8 04 df ff ff       	call   800207 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802303:	cc                   	int3   
  802304:	eb fd                	jmp    802303 <_panic+0x53>
	...

00802308 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80230e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802315:	75 54                	jne    80236b <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  802317:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80231e:	00 
  80231f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802326:	ee 
  802327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232e:	e8 f9 e9 ff ff       	call   800d2c <sys_page_alloc>
  802333:	85 c0                	test   %eax,%eax
  802335:	79 20                	jns    802357 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  802337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80233b:	c7 44 24 08 d0 2c 80 	movl   $0x802cd0,0x8(%esp)
  802342:	00 
  802343:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80234a:	00 
  80234b:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  802352:	e8 59 ff ff ff       	call   8022b0 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802357:	c7 44 24 04 78 23 80 	movl   $0x802378,0x4(%esp)
  80235e:	00 
  80235f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802366:	e8 98 eb ff ff       	call   800f03 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    
  802375:	00 00                	add    %al,(%eax)
	...

00802378 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802378:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802379:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80237e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802380:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  802383:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802387:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  80238a:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  80238e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802392:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802394:	83 c4 08             	add    $0x8,%esp
	popal
  802397:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802398:	83 c4 04             	add    $0x4,%esp
	popfl
  80239b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80239c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
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
