
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 1b 01 00 00       	call   80014c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 4c             	sub    $0x4c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003d:	e8 80 13 00 00       	call   8013c2 <sfork>
  800042:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	74 5e                	je     8000a7 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800049:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80004f:	e8 c8 0c 00 00       	call   800d1c <sys_getenvid>
  800054:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  800063:	e8 f3 01 00 00       	call   80025b <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800068:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006b:	e8 ac 0c 00 00       	call   800d1c <sys_getenvid>
  800070:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800074:	89 44 24 04          	mov    %eax,0x4(%esp)
  800078:	c7 04 24 fa 26 80 00 	movl   $0x8026fa,(%esp)
  80007f:	e8 d7 01 00 00       	call   80025b <cprintf>
		ipc_send(who, 0, 0, 0);
  800084:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008b:	00 
  80008c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009b:	00 
  80009c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009f:	89 04 24             	mov    %eax,(%esp)
  8000a2:	e8 9b 13 00 00       	call   801442 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000ba:	89 04 24             	mov    %eax,(%esp)
  8000bd:	e8 2e 13 00 00       	call   8013f0 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c2:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c8:	8b 73 48             	mov    0x48(%ebx),%esi
  8000cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000ce:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8000d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8000d7:	e8 40 0c 00 00       	call   800d1c <sys_getenvid>
  8000dc:	89 74 24 14          	mov    %esi,0x14(%esp)
  8000e0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f3:	c7 04 24 10 27 80 00 	movl   $0x802710,(%esp)
  8000fa:	e8 5c 01 00 00       	call   80025b <cprintf>
		if (val == 10)
  8000ff:	a1 04 40 80 00       	mov    0x804004,%eax
  800104:	83 f8 0a             	cmp    $0xa,%eax
  800107:	74 38                	je     800141 <umain+0x10d>
			return;
		++val;
  800109:	83 c0 01             	add    $0x1,%eax
  80010c:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  800111:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800118:	00 
  800119:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800120:	00 
  800121:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800128:	00 
  800129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012c:	89 04 24             	mov    %eax,(%esp)
  80012f:	e8 0e 13 00 00       	call   801442 <ipc_send>
		if (val == 10)
  800134:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  80013b:	0f 85 66 ff ff ff    	jne    8000a7 <umain+0x73>
			return;
	}

}
  800141:	83 c4 4c             	add    $0x4c,%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    
  800149:	00 00                	add    %al,(%eax)
	...

0080014c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 18             	sub    $0x18,%esp
  800152:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800155:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800158:	8b 75 08             	mov    0x8(%ebp),%esi
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80015e:	e8 b9 0b 00 00       	call   800d1c <sys_getenvid>
  800163:	25 ff 03 00 00       	and    $0x3ff,%eax
  800168:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 08 40 80 00       	mov    %eax,0x804008
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800175:	85 f6                	test   %esi,%esi
  800177:	7e 07                	jle    800180 <libmain+0x34>
		binaryname = argv[0];
  800179:	8b 03                	mov    (%ebx),%eax
  80017b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 a8 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80018c:	e8 0b 00 00 00       	call   80019c <exit>
}
  800191:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800194:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800197:	89 ec                	mov    %ebp,%esp
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    
	...

0080019c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a2:	e8 87 15 00 00       	call   80172e <close_all>
	sys_env_destroy(0);
  8001a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ae:	e8 0c 0b 00 00       	call   800cbf <sys_env_destroy>
}
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    
  8001b5:	00 00                	add    %al,(%eax)
	...

008001b8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 14             	sub    $0x14,%esp
  8001bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c2:	8b 03                	mov    (%ebx),%eax
  8001c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001cb:	83 c0 01             	add    $0x1,%eax
  8001ce:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d5:	75 19                	jne    8001f0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001d7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001de:	00 
  8001df:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e2:	89 04 24             	mov    %eax,(%esp)
  8001e5:	e8 76 0a 00 00       	call   800c60 <sys_cputs>
		b->idx = 0;
  8001ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001f0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f4:	83 c4 14             	add    $0x14,%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5d                   	pop    %ebp
  8001f9:	c3                   	ret    

008001fa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800203:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020a:	00 00 00 
	b.cnt = 0;
  80020d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800214:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 44 24 08          	mov    %eax,0x8(%esp)
  800225:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022f:	c7 04 24 b8 01 80 00 	movl   $0x8001b8,(%esp)
  800236:	e8 9f 01 00 00       	call   8003da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80023b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800241:	89 44 24 04          	mov    %eax,0x4(%esp)
  800245:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80024b:	89 04 24             	mov    %eax,(%esp)
  80024e:	e8 0d 0a 00 00       	call   800c60 <sys_cputs>

	return b.cnt;
}
  800253:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800261:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800264:	89 44 24 04          	mov    %eax,0x4(%esp)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	e8 87 ff ff ff       	call   8001fa <vcprintf>
	va_end(ap);

	return cnt;
}
  800273:	c9                   	leave  
  800274:	c3                   	ret    
	...

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80029a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80029d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a8:	72 11                	jb     8002bb <printnum+0x3b>
  8002aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ad:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b0:	76 09                	jbe    8002bb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7f 51                	jg     80030a <printnum+0x8a>
  8002b9:	eb 5e                	jmp    800319 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002bb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002bf:	83 eb 01             	sub    $0x1,%ebx
  8002c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8002d1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8002d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002dc:	00 
  8002dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e0:	89 04 24             	mov    %eax,(%esp)
  8002e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ea:	e8 41 21 00 00       	call   802430 <__udivdi3>
  8002ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002f7:	89 04 24             	mov    %eax,(%esp)
  8002fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fe:	89 fa                	mov    %edi,%edx
  800300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800303:	e8 78 ff ff ff       	call   800280 <printnum>
  800308:	eb 0f                	jmp    800319 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030e:	89 34 24             	mov    %esi,(%esp)
  800311:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800314:	83 eb 01             	sub    $0x1,%ebx
  800317:	75 f1                	jne    80030a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800319:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800321:	8b 45 10             	mov    0x10(%ebp),%eax
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80032f:	00 
  800330:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800333:	89 04 24             	mov    %eax,(%esp)
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033d:	e8 1e 22 00 00       	call   802560 <__umoddi3>
  800342:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800346:	0f be 80 40 27 80 00 	movsbl 0x802740(%eax),%eax
  80034d:	89 04 24             	mov    %eax,(%esp)
  800350:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800353:	83 c4 3c             	add    $0x3c,%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035e:	83 fa 01             	cmp    $0x1,%edx
  800361:	7e 0e                	jle    800371 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800363:	8b 10                	mov    (%eax),%edx
  800365:	8d 4a 08             	lea    0x8(%edx),%ecx
  800368:	89 08                	mov    %ecx,(%eax)
  80036a:	8b 02                	mov    (%edx),%eax
  80036c:	8b 52 04             	mov    0x4(%edx),%edx
  80036f:	eb 22                	jmp    800393 <getuint+0x38>
	else if (lflag)
  800371:	85 d2                	test   %edx,%edx
  800373:	74 10                	je     800385 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800375:	8b 10                	mov    (%eax),%edx
  800377:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 02                	mov    (%edx),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	eb 0e                	jmp    800393 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800385:	8b 10                	mov    (%eax),%edx
  800387:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038a:	89 08                	mov    %ecx,(%eax)
  80038c:	8b 02                	mov    (%edx),%eax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039f:	8b 10                	mov    (%eax),%edx
  8003a1:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a4:	73 0a                	jae    8003b0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a9:	88 0a                	mov    %cl,(%edx)
  8003ab:	83 c2 01             	add    $0x1,%edx
  8003ae:	89 10                	mov    %edx,(%eax)
}
  8003b0:	5d                   	pop    %ebp
  8003b1:	c3                   	ret    

008003b2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	89 04 24             	mov    %eax,(%esp)
  8003d3:	e8 02 00 00 00       	call   8003da <vprintfmt>
	va_end(ap);
}
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 4c             	sub    $0x4c,%esp
  8003e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e6:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e9:	eb 12                	jmp    8003fd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	0f 84 a9 03 00 00    	je     80079c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8003f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003f7:	89 04 24             	mov    %eax,(%esp)
  8003fa:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003fd:	0f b6 06             	movzbl (%esi),%eax
  800400:	83 c6 01             	add    $0x1,%esi
  800403:	83 f8 25             	cmp    $0x25,%eax
  800406:	75 e3                	jne    8003eb <vprintfmt+0x11>
  800408:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80040c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800413:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800418:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80041f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800424:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800427:	eb 2b                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800429:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80042c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800430:	eb 22                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800435:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800439:	eb 19                	jmp    800454 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80043e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800445:	eb 0d                	jmp    800454 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800447:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80044a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800454:	0f b6 06             	movzbl (%esi),%eax
  800457:	0f b6 d0             	movzbl %al,%edx
  80045a:	8d 7e 01             	lea    0x1(%esi),%edi
  80045d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800460:	83 e8 23             	sub    $0x23,%eax
  800463:	3c 55                	cmp    $0x55,%al
  800465:	0f 87 0b 03 00 00    	ja     800776 <vprintfmt+0x39c>
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800475:	83 ea 30             	sub    $0x30,%edx
  800478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80047b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80047f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800485:	83 fa 09             	cmp    $0x9,%edx
  800488:	77 4a                	ja     8004d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80048d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800490:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800493:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800497:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80049d:	83 fa 09             	cmp    $0x9,%edx
  8004a0:	76 eb                	jbe    80048d <vprintfmt+0xb3>
  8004a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a5:	eb 2d                	jmp    8004d4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 1a                	jmp    8004d4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8004bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c1:	79 91                	jns    800454 <vprintfmt+0x7a>
  8004c3:	e9 73 ff ff ff       	jmp    80043b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004d2:	eb 80                	jmp    800454 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8004d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d8:	0f 89 76 ff ff ff    	jns    800454 <vprintfmt+0x7a>
  8004de:	e9 64 ff ff ff       	jmp    800447 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004e9:	e9 66 ff ff ff       	jmp    800454 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	8d 50 04             	lea    0x4(%eax),%edx
  8004f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800503:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800506:	e9 f2 fe ff ff       	jmp    8003fd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 c2                	mov    %eax,%edx
  800518:	c1 fa 1f             	sar    $0x1f,%edx
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 0f             	cmp    $0xf,%eax
  800522:	7f 0b                	jg     80052f <vprintfmt+0x155>
  800524:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  80052b:	85 d2                	test   %edx,%edx
  80052d:	75 23                	jne    800552 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80052f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800533:	c7 44 24 08 58 27 80 	movl   $0x802758,0x8(%esp)
  80053a:	00 
  80053b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80053f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800542:	89 3c 24             	mov    %edi,(%esp)
  800545:	e8 68 fe ff ff       	call   8003b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80054d:	e9 ab fe ff ff       	jmp    8003fd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800552:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800556:	c7 44 24 08 c5 2c 80 	movl   $0x802cc5,0x8(%esp)
  80055d:	00 
  80055e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800562:	8b 7d 08             	mov    0x8(%ebp),%edi
  800565:	89 3c 24             	mov    %edi,(%esp)
  800568:	e8 45 fe ff ff       	call   8003b2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800570:	e9 88 fe ff ff       	jmp    8003fd <vprintfmt+0x23>
  800575:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80057b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8d 50 04             	lea    0x4(%eax),%edx
  800584:	89 55 14             	mov    %edx,0x14(%ebp)
  800587:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800589:	85 f6                	test   %esi,%esi
  80058b:	ba 51 27 80 00       	mov    $0x802751,%edx
  800590:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800593:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x1c5>
  800599:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80059d:	75 10                	jne    8005af <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059f:	0f be 06             	movsbl (%esi),%eax
  8005a2:	83 c6 01             	add    $0x1,%esi
  8005a5:	85 c0                	test   %eax,%eax
  8005a7:	0f 85 86 00 00 00    	jne    800633 <vprintfmt+0x259>
  8005ad:	eb 76                	jmp    800625 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005af:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b3:	89 34 24             	mov    %esi,(%esp)
  8005b6:	e8 90 02 00 00       	call   80084b <strnlen>
  8005bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c3:	85 d2                	test   %edx,%edx
  8005c5:	7e d8                	jle    80059f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005ce:	89 d6                	mov    %edx,%esi
  8005d0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8005d3:	89 c7                	mov    %eax,%edi
  8005d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d9:	89 3c 24             	mov    %edi,(%esp)
  8005dc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 ee 01             	sub    $0x1,%esi
  8005e2:	75 f1                	jne    8005d5 <vprintfmt+0x1fb>
  8005e4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005e7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8005ea:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8005ed:	eb b0                	jmp    80059f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	74 18                	je     80060d <vprintfmt+0x233>
  8005f5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005f8:	83 fa 5e             	cmp    $0x5e,%edx
  8005fb:	76 10                	jbe    80060d <vprintfmt+0x233>
					putch('?', putdat);
  8005fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800601:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800608:	ff 55 08             	call   *0x8(%ebp)
  80060b:	eb 0a                	jmp    800617 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80060d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800611:	89 04 24             	mov    %eax,(%esp)
  800614:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800617:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80061b:	0f be 06             	movsbl (%esi),%eax
  80061e:	83 c6 01             	add    $0x1,%esi
  800621:	85 c0                	test   %eax,%eax
  800623:	75 0e                	jne    800633 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800628:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062c:	7f 16                	jg     800644 <vprintfmt+0x26a>
  80062e:	e9 ca fd ff ff       	jmp    8003fd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800633:	85 ff                	test   %edi,%edi
  800635:	78 b8                	js     8005ef <vprintfmt+0x215>
  800637:	83 ef 01             	sub    $0x1,%edi
  80063a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800640:	79 ad                	jns    8005ef <vprintfmt+0x215>
  800642:	eb e1                	jmp    800625 <vprintfmt+0x24b>
  800644:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800647:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80064a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80064e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800655:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800657:	83 ee 01             	sub    $0x1,%esi
  80065a:	75 ee                	jne    80064a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80065f:	e9 99 fd ff ff       	jmp    8003fd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800664:	83 f9 01             	cmp    $0x1,%ecx
  800667:	7e 10                	jle    800679 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 50 08             	lea    0x8(%eax),%edx
  80066f:	89 55 14             	mov    %edx,0x14(%ebp)
  800672:	8b 30                	mov    (%eax),%esi
  800674:	8b 78 04             	mov    0x4(%eax),%edi
  800677:	eb 26                	jmp    80069f <vprintfmt+0x2c5>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	74 12                	je     80068f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)
  800686:	8b 30                	mov    (%eax),%esi
  800688:	89 f7                	mov    %esi,%edi
  80068a:	c1 ff 1f             	sar    $0x1f,%edi
  80068d:	eb 10                	jmp    80069f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 30                	mov    (%eax),%esi
  80069a:	89 f7                	mov    %esi,%edi
  80069c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006a4:	85 ff                	test   %edi,%edi
  8006a6:	0f 89 8c 00 00 00    	jns    800738 <vprintfmt+0x35e>
				putch('-', putdat);
  8006ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006b7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ba:	f7 de                	neg    %esi
  8006bc:	83 d7 00             	adc    $0x0,%edi
  8006bf:	f7 df                	neg    %edi
			}
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	eb 70                	jmp    800738 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006c8:	89 ca                	mov    %ecx,%edx
  8006ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8006cd:	e8 89 fc ff ff       	call   80035b <getuint>
  8006d2:	89 c6                	mov    %eax,%esi
  8006d4:	89 d7                	mov    %edx,%edi
			base = 10;
  8006d6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006db:	eb 5b                	jmp    800738 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006dd:	89 ca                	mov    %ecx,%edx
  8006df:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e2:	e8 74 fc ff ff       	call   80035b <getuint>
  8006e7:	89 c6                	mov    %eax,%esi
  8006e9:	89 d7                	mov    %edx,%edi
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006f0:	eb 46                	jmp    800738 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8006f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800700:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800704:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800717:	8b 30                	mov    (%eax),%esi
  800719:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80071e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800723:	eb 13                	jmp    800738 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800725:	89 ca                	mov    %ecx,%edx
  800727:	8d 45 14             	lea    0x14(%ebp),%eax
  80072a:	e8 2c fc ff ff       	call   80035b <getuint>
  80072f:	89 c6                	mov    %eax,%esi
  800731:	89 d7                	mov    %edx,%edi
			base = 16;
  800733:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800738:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80073c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800743:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800747:	89 44 24 08          	mov    %eax,0x8(%esp)
  80074b:	89 34 24             	mov    %esi,(%esp)
  80074e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800752:	89 da                	mov    %ebx,%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	e8 24 fb ff ff       	call   800280 <printnum>
			break;
  80075c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80075f:	e9 99 fc ff ff       	jmp    8003fd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800764:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800768:	89 14 24             	mov    %edx,(%esp)
  80076b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800771:	e9 87 fc ff ff       	jmp    8003fd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800776:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80077a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800781:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800784:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800788:	0f 84 6f fc ff ff    	je     8003fd <vprintfmt+0x23>
  80078e:	83 ee 01             	sub    $0x1,%esi
  800791:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800795:	75 f7                	jne    80078e <vprintfmt+0x3b4>
  800797:	e9 61 fc ff ff       	jmp    8003fd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80079c:	83 c4 4c             	add    $0x4c,%esp
  80079f:	5b                   	pop    %ebx
  8007a0:	5e                   	pop    %esi
  8007a1:	5f                   	pop    %edi
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 28             	sub    $0x28,%esp
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c1:	85 c0                	test   %eax,%eax
  8007c3:	74 30                	je     8007f5 <vsnprintf+0x51>
  8007c5:	85 d2                	test   %edx,%edx
  8007c7:	7e 2c                	jle    8007f5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007de:	c7 04 24 95 03 80 00 	movl   $0x800395,(%esp)
  8007e5:	e8 f0 fb ff ff       	call   8003da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f3:	eb 05                	jmp    8007fa <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800805:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
  80080c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800810:	8b 45 0c             	mov    0xc(%ebp),%eax
  800813:	89 44 24 04          	mov    %eax,0x4(%esp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	89 04 24             	mov    %eax,(%esp)
  80081d:	e8 82 ff ff ff       	call   8007a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800822:	c9                   	leave  
  800823:	c3                   	ret    
	...

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	80 3a 00             	cmpb   $0x0,(%edx)
  80083e:	74 09                	je     800849 <strlen+0x19>
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <strlen+0x10>
		n++;
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	85 c9                	test   %ecx,%ecx
  80085c:	74 1a                	je     800878 <strnlen+0x2d>
  80085e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800861:	74 15                	je     800878 <strnlen+0x2d>
  800863:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800868:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086a:	39 ca                	cmp    %ecx,%edx
  80086c:	74 0a                	je     800878 <strnlen+0x2d>
  80086e:	83 c2 01             	add    $0x1,%edx
  800871:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800876:	75 f0                	jne    800868 <strnlen+0x1d>
		n++;
	return n;
}
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800885:	ba 00 00 00 00       	mov    $0x0,%edx
  80088a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80088e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800891:	83 c2 01             	add    $0x1,%edx
  800894:	84 c9                	test   %cl,%cl
  800896:	75 f2                	jne    80088a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800898:	5b                   	pop    %ebx
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	53                   	push   %ebx
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a5:	89 1c 24             	mov    %ebx,(%esp)
  8008a8:	e8 83 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	89 04 24             	mov    %eax,(%esp)
  8008b9:	e8 bd ff ff ff       	call   80087b <strcpy>
	return dst;
}
  8008be:	89 d8                	mov    %ebx,%eax
  8008c0:	83 c4 08             	add    $0x8,%esp
  8008c3:	5b                   	pop    %ebx
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d4:	85 f6                	test   %esi,%esi
  8008d6:	74 18                	je     8008f0 <strncpy+0x2a>
  8008d8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008dd:	0f b6 1a             	movzbl (%edx),%ebx
  8008e0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e3:	80 3a 01             	cmpb   $0x1,(%edx)
  8008e6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	39 f1                	cmp    %esi,%ecx
  8008ee:	75 ed                	jne    8008dd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	57                   	push   %edi
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800900:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	89 f8                	mov    %edi,%eax
  800905:	85 f6                	test   %esi,%esi
  800907:	74 2b                	je     800934 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800909:	83 fe 01             	cmp    $0x1,%esi
  80090c:	74 23                	je     800931 <strlcpy+0x3d>
  80090e:	0f b6 0b             	movzbl (%ebx),%ecx
  800911:	84 c9                	test   %cl,%cl
  800913:	74 1c                	je     800931 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800915:	83 ee 02             	sub    $0x2,%esi
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80091d:	88 08                	mov    %cl,(%eax)
  80091f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800922:	39 f2                	cmp    %esi,%edx
  800924:	74 0b                	je     800931 <strlcpy+0x3d>
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80092d:	84 c9                	test   %cl,%cl
  80092f:	75 ec                	jne    80091d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800931:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800934:	29 f8                	sub    %edi,%eax
}
  800936:	5b                   	pop    %ebx
  800937:	5e                   	pop    %esi
  800938:	5f                   	pop    %edi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800944:	0f b6 01             	movzbl (%ecx),%eax
  800947:	84 c0                	test   %al,%al
  800949:	74 16                	je     800961 <strcmp+0x26>
  80094b:	3a 02                	cmp    (%edx),%al
  80094d:	75 12                	jne    800961 <strcmp+0x26>
		p++, q++;
  80094f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800952:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800956:	84 c0                	test   %al,%al
  800958:	74 07                	je     800961 <strcmp+0x26>
  80095a:	83 c1 01             	add    $0x1,%ecx
  80095d:	3a 02                	cmp    (%edx),%al
  80095f:	74 ee                	je     80094f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800961:	0f b6 c0             	movzbl %al,%eax
  800964:	0f b6 12             	movzbl (%edx),%edx
  800967:	29 d0                	sub    %edx,%eax
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800975:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80097d:	85 d2                	test   %edx,%edx
  80097f:	74 28                	je     8009a9 <strncmp+0x3e>
  800981:	0f b6 01             	movzbl (%ecx),%eax
  800984:	84 c0                	test   %al,%al
  800986:	74 24                	je     8009ac <strncmp+0x41>
  800988:	3a 03                	cmp    (%ebx),%al
  80098a:	75 20                	jne    8009ac <strncmp+0x41>
  80098c:	83 ea 01             	sub    $0x1,%edx
  80098f:	74 13                	je     8009a4 <strncmp+0x39>
		n--, p++, q++;
  800991:	83 c1 01             	add    $0x1,%ecx
  800994:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800997:	0f b6 01             	movzbl (%ecx),%eax
  80099a:	84 c0                	test   %al,%al
  80099c:	74 0e                	je     8009ac <strncmp+0x41>
  80099e:	3a 03                	cmp    (%ebx),%al
  8009a0:	74 ea                	je     80098c <strncmp+0x21>
  8009a2:	eb 08                	jmp    8009ac <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ac:	0f b6 01             	movzbl (%ecx),%eax
  8009af:	0f b6 13             	movzbl (%ebx),%edx
  8009b2:	29 d0                	sub    %edx,%eax
  8009b4:	eb f3                	jmp    8009a9 <strncmp+0x3e>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c0:	0f b6 10             	movzbl (%eax),%edx
  8009c3:	84 d2                	test   %dl,%dl
  8009c5:	74 1c                	je     8009e3 <strchr+0x2d>
		if (*s == c)
  8009c7:	38 ca                	cmp    %cl,%dl
  8009c9:	75 09                	jne    8009d4 <strchr+0x1e>
  8009cb:	eb 1b                	jmp    8009e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009cd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8009d0:	38 ca                	cmp    %cl,%dl
  8009d2:	74 14                	je     8009e8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009d4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8009d8:	84 d2                	test   %dl,%dl
  8009da:	75 f1                	jne    8009cd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	eb 05                	jmp    8009e8 <strchr+0x32>
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	0f b6 10             	movzbl (%eax),%edx
  8009f7:	84 d2                	test   %dl,%dl
  8009f9:	74 14                	je     800a0f <strfind+0x25>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	75 06                	jne    800a05 <strfind+0x1b>
  8009ff:	eb 0e                	jmp    800a0f <strfind+0x25>
  800a01:	38 ca                	cmp    %cl,%dl
  800a03:	74 0a                	je     800a0f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	0f b6 10             	movzbl (%eax),%edx
  800a0b:	84 d2                	test   %dl,%dl
  800a0d:	75 f2                	jne    800a01 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 0c             	sub    $0xc,%esp
  800a17:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a1a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a1d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a20:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	74 30                	je     800a5d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a33:	75 25                	jne    800a5a <memset+0x49>
  800a35:	f6 c1 03             	test   $0x3,%cl
  800a38:	75 20                	jne    800a5a <memset+0x49>
		c &= 0xFF;
  800a3a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a3d:	89 d3                	mov    %edx,%ebx
  800a3f:	c1 e3 08             	shl    $0x8,%ebx
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	c1 e6 18             	shl    $0x18,%esi
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	c1 e0 10             	shl    $0x10,%eax
  800a4c:	09 f0                	or     %esi,%eax
  800a4e:	09 d0                	or     %edx,%eax
  800a50:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a52:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a55:	fc                   	cld    
  800a56:	f3 ab                	rep stos %eax,%es:(%edi)
  800a58:	eb 03                	jmp    800a5d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a68:	89 ec                	mov    %ebp,%esp
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a75:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a81:	39 c6                	cmp    %eax,%esi
  800a83:	73 36                	jae    800abb <memmove+0x4f>
  800a85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a88:	39 d0                	cmp    %edx,%eax
  800a8a:	73 2f                	jae    800abb <memmove+0x4f>
		s += n;
		d += n;
  800a8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f6 c2 03             	test   $0x3,%dl
  800a92:	75 1b                	jne    800aaf <memmove+0x43>
  800a94:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9a:	75 13                	jne    800aaf <memmove+0x43>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 20                	jmp    800adb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac1:	75 13                	jne    800ad6 <memmove+0x6a>
  800ac3:	a8 03                	test   $0x3,%al
  800ac5:	75 0f                	jne    800ad6 <memmove+0x6a>
  800ac7:	f6 c1 03             	test   $0x3,%cl
  800aca:	75 0a                	jne    800ad6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800acc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acf:	89 c7                	mov    %eax,%edi
  800ad1:	fc                   	cld    
  800ad2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad4:	eb 05                	jmp    800adb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad6:	89 c7                	mov    %eax,%edi
  800ad8:	fc                   	cld    
  800ad9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800adb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ade:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ae1:	89 ec                	mov    %ebp,%esp
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	89 04 24             	mov    %eax,(%esp)
  800aff:	e8 68 ff ff ff       	call   800a6c <memmove>
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b12:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1a:	85 ff                	test   %edi,%edi
  800b1c:	74 37                	je     800b55 <memcmp+0x4f>
		if (*s1 != *s2)
  800b1e:	0f b6 03             	movzbl (%ebx),%eax
  800b21:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b24:	83 ef 01             	sub    $0x1,%edi
  800b27:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b2c:	38 c8                	cmp    %cl,%al
  800b2e:	74 1c                	je     800b4c <memcmp+0x46>
  800b30:	eb 10                	jmp    800b42 <memcmp+0x3c>
  800b32:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b3e:	38 c8                	cmp    %cl,%al
  800b40:	74 0a                	je     800b4c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800b42:	0f b6 c0             	movzbl %al,%eax
  800b45:	0f b6 c9             	movzbl %cl,%ecx
  800b48:	29 c8                	sub    %ecx,%eax
  800b4a:	eb 09                	jmp    800b55 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4c:	39 fa                	cmp    %edi,%edx
  800b4e:	75 e2                	jne    800b32 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b65:	39 d0                	cmp    %edx,%eax
  800b67:	73 19                	jae    800b82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b6d:	38 08                	cmp    %cl,(%eax)
  800b6f:	75 06                	jne    800b77 <memfind+0x1d>
  800b71:	eb 0f                	jmp    800b82 <memfind+0x28>
  800b73:	38 08                	cmp    %cl,(%eax)
  800b75:	74 0b                	je     800b82 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b77:	83 c0 01             	add    $0x1,%eax
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b80:	75 f1                	jne    800b73 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b90:	0f b6 02             	movzbl (%edx),%eax
  800b93:	3c 20                	cmp    $0x20,%al
  800b95:	74 04                	je     800b9b <strtol+0x17>
  800b97:	3c 09                	cmp    $0x9,%al
  800b99:	75 0e                	jne    800ba9 <strtol+0x25>
		s++;
  800b9b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 02             	movzbl (%edx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0x17>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	75 0a                	jne    800bb7 <strtol+0x33>
		s++;
  800bad:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb5:	eb 10                	jmp    800bc7 <strtol+0x43>
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bbc:	3c 2d                	cmp    $0x2d,%al
  800bbe:	75 07                	jne    800bc7 <strtol+0x43>
		s++, neg = 1;
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	0f 94 c0             	sete   %al
  800bcc:	74 05                	je     800bd3 <strtol+0x4f>
  800bce:	83 fb 10             	cmp    $0x10,%ebx
  800bd1:	75 15                	jne    800be8 <strtol+0x64>
  800bd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd6:	75 10                	jne    800be8 <strtol+0x64>
  800bd8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bdc:	75 0a                	jne    800be8 <strtol+0x64>
		s += 2, base = 16;
  800bde:	83 c2 02             	add    $0x2,%edx
  800be1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be6:	eb 13                	jmp    800bfb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800be8:	84 c0                	test   %al,%al
  800bea:	74 0f                	je     800bfb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bec:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf1:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf4:	75 05                	jne    800bfb <strtol+0x77>
		s++, base = 8;
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c02:	0f b6 0a             	movzbl (%edx),%ecx
  800c05:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c08:	80 fb 09             	cmp    $0x9,%bl
  800c0b:	77 08                	ja     800c15 <strtol+0x91>
			dig = *s - '0';
  800c0d:	0f be c9             	movsbl %cl,%ecx
  800c10:	83 e9 30             	sub    $0x30,%ecx
  800c13:	eb 1e                	jmp    800c33 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c15:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 08                	ja     800c25 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c1d:	0f be c9             	movsbl %cl,%ecx
  800c20:	83 e9 57             	sub    $0x57,%ecx
  800c23:	eb 0e                	jmp    800c33 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c25:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c28:	80 fb 19             	cmp    $0x19,%bl
  800c2b:	77 14                	ja     800c41 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c2d:	0f be c9             	movsbl %cl,%ecx
  800c30:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c33:	39 f1                	cmp    %esi,%ecx
  800c35:	7d 0e                	jge    800c45 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c37:	83 c2 01             	add    $0x1,%edx
  800c3a:	0f af c6             	imul   %esi,%eax
  800c3d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c3f:	eb c1                	jmp    800c02 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c41:	89 c1                	mov    %eax,%ecx
  800c43:	eb 02                	jmp    800c47 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c45:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4b:	74 05                	je     800c52 <strtol+0xce>
		*endptr = (char *) s;
  800c4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c50:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c52:	89 ca                	mov    %ecx,%edx
  800c54:	f7 da                	neg    %edx
  800c56:	85 ff                	test   %edi,%edi
  800c58:	0f 45 c2             	cmovne %edx,%eax
}
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	89 c3                	mov    %eax,%ebx
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	89 c6                	mov    %eax,%esi
  800c80:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c8b:	89 ec                	mov    %ebp,%esp
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca8:	89 d1                	mov    %edx,%ecx
  800caa:	89 d3                	mov    %edx,%ebx
  800cac:	89 d7                	mov    %edx,%edi
  800cae:	89 d6                	mov    %edx,%esi
  800cb0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cbb:	89 ec                	mov    %ebp,%esp
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 38             	sub    $0x38,%esp
  800cc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ccb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	89 cb                	mov    %ecx,%ebx
  800cdd:	89 cf                	mov    %ecx,%edi
  800cdf:	89 ce                	mov    %ecx,%esi
  800ce1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7e 28                	jle    800d0f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ceb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800d0a:	e8 f1 15 00 00       	call   802300 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d18:	89 ec                	mov    %ebp,%esp
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d48:	89 ec                	mov    %ebp,%esp
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_yield>:

void
sys_yield(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d78:	89 ec                	mov    %ebp,%esp
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 38             	sub    $0x38,%esp
  800d82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	be 00 00 00 00       	mov    $0x0,%esi
  800d90:	b8 04 00 00 00       	mov    $0x4,%eax
  800d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	89 f7                	mov    %esi,%edi
  800da0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800dc9:	e8 32 15 00 00       	call   802300 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd7:	89 ec                	mov    %ebp,%esp
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	83 ec 38             	sub    $0x38,%esp
  800de1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dea:	b8 05 00 00 00       	mov    $0x5,%eax
  800def:	8b 75 18             	mov    0x18(%ebp),%esi
  800df2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e00:	85 c0                	test   %eax,%eax
  800e02:	7e 28                	jle    800e2c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e08:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e0f:	00 
  800e10:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800e17:	00 
  800e18:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1f:	00 
  800e20:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800e27:	e8 d4 14 00 00       	call   802300 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e2c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e2f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e32:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e35:	89 ec                	mov    %ebp,%esp
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 38             	sub    $0x38,%esp
  800e3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e45:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7e 28                	jle    800e8a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e66:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e6d:	00 
  800e6e:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800e75:	00 
  800e76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7d:	00 
  800e7e:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800e85:	e8 76 14 00 00       	call   802300 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e93:	89 ec                	mov    %ebp,%esp
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 38             	sub    $0x38,%esp
  800e9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7e 28                	jle    800ee8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ecb:	00 
  800ecc:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edb:	00 
  800edc:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800ee3:	e8 18 14 00 00       	call   802300 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eeb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef1:	89 ec                	mov    %ebp,%esp
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f09:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	89 df                	mov    %ebx,%edi
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	7e 28                	jle    800f46 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f22:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f29:	00 
  800f2a:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f31:	00 
  800f32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f39:	00 
  800f3a:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800f41:	e8 ba 13 00 00       	call   802300 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4f:	89 ec                	mov    %ebp,%esp
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 38             	sub    $0x38,%esp
  800f59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 df                	mov    %ebx,%edi
  800f74:	89 de                	mov    %ebx,%esi
  800f76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7e 28                	jle    800fa4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f80:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f87:	00 
  800f88:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800f9f:	e8 5c 13 00 00       	call   802300 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800faa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fad:	89 ec                	mov    %ebp,%esp
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc0:	be 00 00 00 00       	mov    $0x0,%esi
  800fc5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fdb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fde:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe1:	89 ec                	mov    %ebp,%esp
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 38             	sub    $0x38,%esp
  800feb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  801001:	89 cb                	mov    %ecx,%ebx
  801003:	89 cf                	mov    %ecx,%edi
  801005:	89 ce                	mov    %ecx,%esi
  801007:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7e 28                	jle    801035 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801011:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801018:	00 
  801019:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  801020:	00 
  801021:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801028:	00 
  801029:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  801030:	e8 cb 12 00 00       	call   802300 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801035:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801038:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80103b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80103e:	89 ec                	mov    %ebp,%esp
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    
	...

00801044 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	53                   	push   %ebx
  801048:	83 ec 24             	sub    $0x24,%esp
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80104e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801050:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801054:	74 21                	je     801077 <pgfault+0x33>
  801056:	89 d8                	mov    %ebx,%eax
  801058:	c1 e8 16             	shr    $0x16,%eax
  80105b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801062:	a8 01                	test   $0x1,%al
  801064:	74 11                	je     801077 <pgfault+0x33>
  801066:	89 d8                	mov    %ebx,%eax
  801068:	c1 e8 0c             	shr    $0xc,%eax
  80106b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801072:	f6 c4 08             	test   $0x8,%ah
  801075:	75 1c                	jne    801093 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801077:	c7 44 24 08 6c 2a 80 	movl   $0x802a6c,0x8(%esp)
  80107e:	00 
  80107f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801086:	00 
  801087:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80108e:	e8 6d 12 00 00       	call   802300 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801093:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80109a:	00 
  80109b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010a2:	00 
  8010a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010aa:	e8 cd fc ff ff       	call   800d7c <sys_page_alloc>
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	79 20                	jns    8010d3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8010b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010b7:	c7 44 24 08 a8 2a 80 	movl   $0x802aa8,0x8(%esp)
  8010be:	00 
  8010bf:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8010c6:	00 
  8010c7:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8010ce:	e8 2d 12 00 00       	call   802300 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  8010d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  8010d9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010e0:	00 
  8010e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010e5:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010ec:	e8 7b f9 ff ff       	call   800a6c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8010f1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010f8:	00 
  8010f9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801104:	00 
  801105:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80110c:	00 
  80110d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801114:	e8 c2 fc ff ff       	call   800ddb <sys_page_map>
  801119:	85 c0                	test   %eax,%eax
  80111b:	79 20                	jns    80113d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80111d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801121:	c7 44 24 08 d0 2a 80 	movl   $0x802ad0,0x8(%esp)
  801128:	00 
  801129:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801130:	00 
  801131:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801138:	e8 c3 11 00 00       	call   802300 <_panic>
	//panic("pgfault not implemented");
}
  80113d:	83 c4 24             	add    $0x24,%esp
  801140:	5b                   	pop    %ebx
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80114c:	c7 04 24 44 10 80 00 	movl   $0x801044,(%esp)
  801153:	e8 00 12 00 00       	call   802358 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801158:	ba 07 00 00 00       	mov    $0x7,%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	cd 30                	int    $0x30
  801161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801164:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801166:	85 c0                	test   %eax,%eax
  801168:	79 20                	jns    80118a <fork+0x47>
		panic("sys_exofork: %e", envid);
  80116a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80116e:	c7 44 24 08 ce 2b 80 	movl   $0x802bce,0x8(%esp)
  801175:	00 
  801176:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80117d:	00 
  80117e:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801185:	e8 76 11 00 00       	call   802300 <_panic>
	if (envid == 0) {
  80118a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80118f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801193:	75 1c                	jne    8011b1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801195:	e8 82 fb ff ff       	call   800d1c <sys_getenvid>
  80119a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80119f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011a7:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8011ac:	e9 06 02 00 00       	jmp    8013b7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8011b1:	89 d8                	mov    %ebx,%eax
  8011b3:	c1 e8 16             	shr    $0x16,%eax
  8011b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011bd:	a8 01                	test   $0x1,%al
  8011bf:	0f 84 57 01 00 00    	je     80131c <fork+0x1d9>
  8011c5:	89 de                	mov    %ebx,%esi
  8011c7:	c1 ee 0c             	shr    $0xc,%esi
  8011ca:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011d1:	a8 01                	test   $0x1,%al
  8011d3:	0f 84 43 01 00 00    	je     80131c <fork+0x1d9>
  8011d9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011e0:	a8 04                	test   $0x4,%al
  8011e2:	0f 84 34 01 00 00    	je     80131c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  8011e8:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  8011eb:	89 f0                	mov    %esi,%eax
  8011ed:	c1 e8 0c             	shr    $0xc,%eax
  8011f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  8011f7:	f6 c4 04             	test   $0x4,%ah
  8011fa:	74 45                	je     801241 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  8011fc:	25 07 0e 00 00       	and    $0xe07,%eax
  801201:	89 44 24 10          	mov    %eax,0x10(%esp)
  801205:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801209:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80120d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801218:	e8 be fb ff ff       	call   800ddb <sys_page_map>
  80121d:	85 c0                	test   %eax,%eax
  80121f:	0f 89 f7 00 00 00    	jns    80131c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801225:	c7 44 24 08 de 2b 80 	movl   $0x802bde,0x8(%esp)
  80122c:	00 
  80122d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801234:	00 
  801235:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80123c:	e8 bf 10 00 00       	call   802300 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801241:	a9 02 08 00 00       	test   $0x802,%eax
  801246:	0f 84 8c 00 00 00    	je     8012d8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80124c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801253:	00 
  801254:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801258:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80125c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801267:	e8 6f fb ff ff       	call   800ddb <sys_page_map>
  80126c:	85 c0                	test   %eax,%eax
  80126e:	79 20                	jns    801290 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801270:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801274:	c7 44 24 08 f4 2a 80 	movl   $0x802af4,0x8(%esp)
  80127b:	00 
  80127c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801283:	00 
  801284:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80128b:	e8 70 10 00 00       	call   802300 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801290:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801297:	00 
  801298:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80129c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a3:	00 
  8012a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012af:	e8 27 fb ff ff       	call   800ddb <sys_page_map>
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	79 64                	jns    80131c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8012b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012bc:	c7 44 24 08 20 2b 80 	movl   $0x802b20,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8012d3:	e8 28 10 00 00       	call   802300 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8012d8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8012df:	00 
  8012e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012e4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f3:	e8 e3 fa ff ff       	call   800ddb <sys_page_map>
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	79 20                	jns    80131c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  8012fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801300:	c7 44 24 08 4c 2b 80 	movl   $0x802b4c,0x8(%esp)
  801307:	00 
  801308:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80130f:	00 
  801310:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801317:	e8 e4 0f 00 00       	call   802300 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80131c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801322:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801328:	0f 85 83 fe ff ff    	jne    8011b1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80132e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801335:	00 
  801336:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80133d:	ee 
  80133e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801341:	89 04 24             	mov    %eax,(%esp)
  801344:	e8 33 fa ff ff       	call   800d7c <sys_page_alloc>
  801349:	85 c0                	test   %eax,%eax
  80134b:	79 20                	jns    80136d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80134d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801351:	c7 44 24 08 78 2b 80 	movl   $0x802b78,0x8(%esp)
  801358:	00 
  801359:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801360:	00 
  801361:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801368:	e8 93 0f 00 00       	call   802300 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80136d:	c7 44 24 04 c8 23 80 	movl   $0x8023c8,0x4(%esp)
  801374:	00 
  801375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801378:	89 04 24             	mov    %eax,(%esp)
  80137b:	e8 d3 fb ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801380:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801387:	00 
  801388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	e8 04 fb ff ff       	call   800e97 <sys_env_set_status>
  801393:	85 c0                	test   %eax,%eax
  801395:	79 20                	jns    8013b7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801397:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80139b:	c7 44 24 08 9c 2b 80 	movl   $0x802b9c,0x8(%esp)
  8013a2:	00 
  8013a3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8013aa:	00 
  8013ab:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8013b2:	e8 49 0f 00 00       	call   802300 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8013b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ba:	83 c4 3c             	add    $0x3c,%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5f                   	pop    %edi
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <sfork>:

// Challenge!
int
sfork(void)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013c8:	c7 44 24 08 f5 2b 80 	movl   $0x802bf5,0x8(%esp)
  8013cf:	00 
  8013d0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8013d7:	00 
  8013d8:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8013df:	e8 1c 0f 00 00       	call   802300 <_panic>
	...

008013f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	56                   	push   %esi
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 10             	sub    $0x10,%esp
  8013f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801401:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801403:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801408:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80140b:	89 04 24             	mov    %eax,(%esp)
  80140e:	e8 d2 fb ff ff       	call   800fe5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801418:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 0e                	js     80142f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801421:	a1 08 40 80 00       	mov    0x804008,%eax
  801426:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801429:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80142c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80142f:	85 f6                	test   %esi,%esi
  801431:	74 02                	je     801435 <ipc_recv+0x45>
		*from_env_store = sender;
  801433:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801435:	85 db                	test   %ebx,%ebx
  801437:	74 02                	je     80143b <ipc_recv+0x4b>
		*perm_store = perm;
  801439:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	5b                   	pop    %ebx
  80143f:	5e                   	pop    %esi
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	57                   	push   %edi
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
  801448:	83 ec 1c             	sub    $0x1c,%esp
  80144b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80144e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801451:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801454:	85 db                	test   %ebx,%ebx
  801456:	75 04                	jne    80145c <ipc_send+0x1a>
  801458:	85 f6                	test   %esi,%esi
  80145a:	75 15                	jne    801471 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80145c:	85 db                	test   %ebx,%ebx
  80145e:	74 16                	je     801476 <ipc_send+0x34>
  801460:	85 f6                	test   %esi,%esi
  801462:	0f 94 c0             	sete   %al
      pg = 0;
  801465:	84 c0                	test   %al,%al
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	0f 45 d8             	cmovne %eax,%ebx
  80146f:	eb 05                	jmp    801476 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801471:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801476:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80147a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	89 04 24             	mov    %eax,(%esp)
  801488:	e8 24 fb ff ff       	call   800fb1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80148d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801490:	75 07                	jne    801499 <ipc_send+0x57>
           sys_yield();
  801492:	e8 b5 f8 ff ff       	call   800d4c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801497:	eb dd                	jmp    801476 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801499:	85 c0                	test   %eax,%eax
  80149b:	90                   	nop
  80149c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014a0:	74 1c                	je     8014be <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8014a2:	c7 44 24 08 0b 2c 80 	movl   $0x802c0b,0x8(%esp)
  8014a9:	00 
  8014aa:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8014b1:	00 
  8014b2:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  8014b9:	e8 42 0e 00 00       	call   802300 <_panic>
		}
    }
}
  8014be:	83 c4 1c             	add    $0x1c,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8014cc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8014d1:	39 c8                	cmp    %ecx,%eax
  8014d3:	74 17                	je     8014ec <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014d5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8014da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8014dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8014e3:	8b 52 50             	mov    0x50(%edx),%edx
  8014e6:	39 ca                	cmp    %ecx,%edx
  8014e8:	75 14                	jne    8014fe <ipc_find_env+0x38>
  8014ea:	eb 05                	jmp    8014f1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8014f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014f4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8014f9:	8b 40 40             	mov    0x40(%eax),%eax
  8014fc:	eb 0e                	jmp    80150c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014fe:	83 c0 01             	add    $0x1,%eax
  801501:	3d 00 04 00 00       	cmp    $0x400,%eax
  801506:	75 d2                	jne    8014da <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801508:	66 b8 00 00          	mov    $0x0,%ax
}
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    
	...

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 04 24             	mov    %eax,(%esp)
  80152c:	e8 df ff ff ff       	call   801510 <fd2num>
  801531:	05 20 00 0d 00       	add    $0xd0020,%eax
  801536:	c1 e0 0c             	shl    $0xc,%eax
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	53                   	push   %ebx
  80153f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801547:	a8 01                	test   $0x1,%al
  801549:	74 34                	je     80157f <fd_alloc+0x44>
  80154b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801550:	a8 01                	test   $0x1,%al
  801552:	74 32                	je     801586 <fd_alloc+0x4b>
  801554:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801559:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80155b:	89 c2                	mov    %eax,%edx
  80155d:	c1 ea 16             	shr    $0x16,%edx
  801560:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801567:	f6 c2 01             	test   $0x1,%dl
  80156a:	74 1f                	je     80158b <fd_alloc+0x50>
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	c1 ea 0c             	shr    $0xc,%edx
  801571:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801578:	f6 c2 01             	test   $0x1,%dl
  80157b:	75 17                	jne    801594 <fd_alloc+0x59>
  80157d:	eb 0c                	jmp    80158b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80157f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801584:	eb 05                	jmp    80158b <fd_alloc+0x50>
  801586:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80158b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
  801592:	eb 17                	jmp    8015ab <fd_alloc+0x70>
  801594:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801599:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80159e:	75 b9                	jne    801559 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8015a6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015ab:	5b                   	pop    %ebx
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015b9:	83 fa 1f             	cmp    $0x1f,%edx
  8015bc:	77 3f                	ja     8015fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015be:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8015c4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015c7:	89 d0                	mov    %edx,%eax
  8015c9:	c1 e8 16             	shr    $0x16,%eax
  8015cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015d8:	f6 c1 01             	test   $0x1,%cl
  8015db:	74 20                	je     8015fd <fd_lookup+0x4f>
  8015dd:	89 d0                	mov    %edx,%eax
  8015df:	c1 e8 0c             	shr    $0xc,%eax
  8015e2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015ee:	f6 c1 01             	test   $0x1,%cl
  8015f1:	74 0a                	je     8015fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	89 10                	mov    %edx,(%eax)
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	53                   	push   %ebx
  801603:	83 ec 14             	sub    $0x14,%esp
  801606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801611:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801617:	75 17                	jne    801630 <dev_lookup+0x31>
  801619:	eb 07                	jmp    801622 <dev_lookup+0x23>
  80161b:	39 0a                	cmp    %ecx,(%edx)
  80161d:	75 11                	jne    801630 <dev_lookup+0x31>
  80161f:	90                   	nop
  801620:	eb 05                	jmp    801627 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801622:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801627:	89 13                	mov    %edx,(%ebx)
			return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 35                	jmp    801665 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801630:	83 c0 01             	add    $0x1,%eax
  801633:	8b 14 85 9c 2c 80 00 	mov    0x802c9c(,%eax,4),%edx
  80163a:	85 d2                	test   %edx,%edx
  80163c:	75 dd                	jne    80161b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80163e:	a1 08 40 80 00       	mov    0x804008,%eax
  801643:	8b 40 48             	mov    0x48(%eax),%eax
  801646:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80164a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164e:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  801655:	e8 01 ec ff ff       	call   80025b <cprintf>
	*dev = 0;
  80165a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801660:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801665:	83 c4 14             	add    $0x14,%esp
  801668:	5b                   	pop    %ebx
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    

0080166b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 38             	sub    $0x38,%esp
  801671:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801674:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801677:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80167a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801681:	89 3c 24             	mov    %edi,(%esp)
  801684:	e8 87 fe ff ff       	call   801510 <fd2num>
  801689:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80168c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 16 ff ff ff       	call   8015ae <fd_lookup>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 05                	js     8016a3 <fd_close+0x38>
	    || fd != fd2)
  80169e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8016a1:	74 0e                	je     8016b1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016a3:	89 f0                	mov    %esi,%eax
  8016a5:	84 c0                	test   %al,%al
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	0f 44 d8             	cmove  %eax,%ebx
  8016af:	eb 3d                	jmp    8016ee <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b8:	8b 07                	mov    (%edi),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 3d ff ff ff       	call   8015ff <dev_lookup>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 16                	js     8016de <fd_close+0x73>
		if (dev->dev_close)
  8016c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 07                	je     8016de <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8016d7:	89 3c 24             	mov    %edi,(%esp)
  8016da:	ff d0                	call   *%eax
  8016dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e9:	e8 4b f7 ff ff       	call   800e39 <sys_page_unmap>
	return r;
}
  8016ee:	89 d8                	mov    %ebx,%eax
  8016f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016f9:	89 ec                	mov    %ebp,%esp
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    

008016fd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	89 04 24             	mov    %eax,(%esp)
  801710:	e8 99 fe ff ff       	call   8015ae <fd_lookup>
  801715:	85 c0                	test   %eax,%eax
  801717:	78 13                	js     80172c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801719:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801720:	00 
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 3f ff ff ff       	call   80166b <fd_close>
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <close_all>:

void
close_all(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801735:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80173a:	89 1c 24             	mov    %ebx,(%esp)
  80173d:	e8 bb ff ff ff       	call   8016fd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801742:	83 c3 01             	add    $0x1,%ebx
  801745:	83 fb 20             	cmp    $0x20,%ebx
  801748:	75 f0                	jne    80173a <close_all+0xc>
		close(i);
}
  80174a:	83 c4 14             	add    $0x14,%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 58             	sub    $0x58,%esp
  801756:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801759:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80175c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80175f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801762:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801765:	89 44 24 04          	mov    %eax,0x4(%esp)
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	89 04 24             	mov    %eax,(%esp)
  80176f:	e8 3a fe ff ff       	call   8015ae <fd_lookup>
  801774:	89 c3                	mov    %eax,%ebx
  801776:	85 c0                	test   %eax,%eax
  801778:	0f 88 e1 00 00 00    	js     80185f <dup+0x10f>
		return r;
	close(newfdnum);
  80177e:	89 3c 24             	mov    %edi,(%esp)
  801781:	e8 77 ff ff ff       	call   8016fd <close>

	newfd = INDEX2FD(newfdnum);
  801786:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80178c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80178f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801792:	89 04 24             	mov    %eax,(%esp)
  801795:	e8 86 fd ff ff       	call   801520 <fd2data>
  80179a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80179c:	89 34 24             	mov    %esi,(%esp)
  80179f:	e8 7c fd ff ff       	call   801520 <fd2data>
  8017a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	c1 e8 16             	shr    $0x16,%eax
  8017ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017b3:	a8 01                	test   $0x1,%al
  8017b5:	74 46                	je     8017fd <dup+0xad>
  8017b7:	89 d8                	mov    %ebx,%eax
  8017b9:	c1 e8 0c             	shr    $0xc,%eax
  8017bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017c3:	f6 c2 01             	test   $0x1,%dl
  8017c6:	74 35                	je     8017fd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8017d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017e6:	00 
  8017e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f2:	e8 e4 f5 ff ff       	call   800ddb <sys_page_map>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 3b                	js     801838 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801800:	89 c2                	mov    %eax,%edx
  801802:	c1 ea 0c             	shr    $0xc,%edx
  801805:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80180c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801812:	89 54 24 10          	mov    %edx,0x10(%esp)
  801816:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80181a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801821:	00 
  801822:	89 44 24 04          	mov    %eax,0x4(%esp)
  801826:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80182d:	e8 a9 f5 ff ff       	call   800ddb <sys_page_map>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	85 c0                	test   %eax,%eax
  801836:	79 25                	jns    80185d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801838:	89 74 24 04          	mov    %esi,0x4(%esp)
  80183c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801843:	e8 f1 f5 ff ff       	call   800e39 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801856:	e8 de f5 ff ff       	call   800e39 <sys_page_unmap>
	return r;
  80185b:	eb 02                	jmp    80185f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80185d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801864:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801867:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80186a:	89 ec                	mov    %ebp,%esp
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    

0080186e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
  801872:	83 ec 24             	sub    $0x24,%esp
  801875:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801878:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187f:	89 1c 24             	mov    %ebx,(%esp)
  801882:	e8 27 fd ff ff       	call   8015ae <fd_lookup>
  801887:	85 c0                	test   %eax,%eax
  801889:	78 6d                	js     8018f8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	e8 60 fd ff ff       	call   8015ff <dev_lookup>
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 55                	js     8018f8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	8b 50 08             	mov    0x8(%eax),%edx
  8018a9:	83 e2 03             	and    $0x3,%edx
  8018ac:	83 fa 01             	cmp    $0x1,%edx
  8018af:	75 23                	jne    8018d4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8018b6:	8b 40 48             	mov    0x48(%eax),%eax
  8018b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c1:	c7 04 24 61 2c 80 00 	movl   $0x802c61,(%esp)
  8018c8:	e8 8e e9 ff ff       	call   80025b <cprintf>
		return -E_INVAL;
  8018cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d2:	eb 24                	jmp    8018f8 <read+0x8a>
	}
	if (!dev->dev_read)
  8018d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d7:	8b 52 08             	mov    0x8(%edx),%edx
  8018da:	85 d2                	test   %edx,%edx
  8018dc:	74 15                	je     8018f3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ec:	89 04 24             	mov    %eax,(%esp)
  8018ef:	ff d2                	call   *%edx
  8018f1:	eb 05                	jmp    8018f8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018f8:	83 c4 24             	add    $0x24,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	8b 7d 08             	mov    0x8(%ebp),%edi
  80190a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	85 f6                	test   %esi,%esi
  801914:	74 30                	je     801946 <readn+0x48>
  801916:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80191b:	89 f2                	mov    %esi,%edx
  80191d:	29 c2                	sub    %eax,%edx
  80191f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801923:	03 45 0c             	add    0xc(%ebp),%eax
  801926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192a:	89 3c 24             	mov    %edi,(%esp)
  80192d:	e8 3c ff ff ff       	call   80186e <read>
		if (m < 0)
  801932:	85 c0                	test   %eax,%eax
  801934:	78 10                	js     801946 <readn+0x48>
			return m;
		if (m == 0)
  801936:	85 c0                	test   %eax,%eax
  801938:	74 0a                	je     801944 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80193a:	01 c3                	add    %eax,%ebx
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	39 f3                	cmp    %esi,%ebx
  801940:	72 d9                	jb     80191b <readn+0x1d>
  801942:	eb 02                	jmp    801946 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801944:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	53                   	push   %ebx
  801952:	83 ec 24             	sub    $0x24,%esp
  801955:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801958:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	89 1c 24             	mov    %ebx,(%esp)
  801962:	e8 47 fc ff ff       	call   8015ae <fd_lookup>
  801967:	85 c0                	test   %eax,%eax
  801969:	78 68                	js     8019d3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	8b 00                	mov    (%eax),%eax
  801977:	89 04 24             	mov    %eax,(%esp)
  80197a:	e8 80 fc ff ff       	call   8015ff <dev_lookup>
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 50                	js     8019d3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198a:	75 23                	jne    8019af <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80198c:	a1 08 40 80 00       	mov    0x804008,%eax
  801991:	8b 40 48             	mov    0x48(%eax),%eax
  801994:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	c7 04 24 7d 2c 80 00 	movl   $0x802c7d,(%esp)
  8019a3:	e8 b3 e8 ff ff       	call   80025b <cprintf>
		return -E_INVAL;
  8019a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ad:	eb 24                	jmp    8019d3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b5:	85 d2                	test   %edx,%edx
  8019b7:	74 15                	je     8019ce <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	ff d2                	call   *%edx
  8019cc:	eb 05                	jmp    8019d3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019d3:	83 c4 24             	add    $0x24,%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019df:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	89 04 24             	mov    %eax,(%esp)
  8019ec:	e8 bd fb ff ff       	call   8015ae <fd_lookup>
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 0e                	js     801a03 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	53                   	push   %ebx
  801a09:	83 ec 24             	sub    $0x24,%esp
  801a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	89 1c 24             	mov    %ebx,(%esp)
  801a19:	e8 90 fb ff ff       	call   8015ae <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 61                	js     801a83 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	89 04 24             	mov    %eax,(%esp)
  801a31:	e8 c9 fb ff ff       	call   8015ff <dev_lookup>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 49                	js     801a83 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a41:	75 23                	jne    801a66 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a43:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a48:	8b 40 48             	mov    0x48(%eax),%eax
  801a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a53:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  801a5a:	e8 fc e7 ff ff       	call   80025b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a64:	eb 1d                	jmp    801a83 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a69:	8b 52 18             	mov    0x18(%edx),%edx
  801a6c:	85 d2                	test   %edx,%edx
  801a6e:	74 0e                	je     801a7e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	ff d2                	call   *%edx
  801a7c:	eb 05                	jmp    801a83 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a83:	83 c4 24             	add    $0x24,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 24             	sub    $0x24,%esp
  801a90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a93:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	89 04 24             	mov    %eax,(%esp)
  801aa0:	e8 09 fb ff ff       	call   8015ae <fd_lookup>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 52                	js     801afb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	89 04 24             	mov    %eax,(%esp)
  801ab8:	e8 42 fb ff ff       	call   8015ff <dev_lookup>
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 3a                	js     801afb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ac8:	74 2c                	je     801af6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aca:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801acd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ad4:	00 00 00 
	stat->st_isdir = 0;
  801ad7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ade:	00 00 00 
	stat->st_dev = dev;
  801ae1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ae7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aee:	89 14 24             	mov    %edx,(%esp)
  801af1:	ff 50 14             	call   *0x14(%eax)
  801af4:	eb 05                	jmp    801afb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801af6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801afb:	83 c4 24             	add    $0x24,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
  801b07:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b0a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b14:	00 
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	e8 bc 01 00 00       	call   801cdc <open>
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 1b                	js     801b41 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2d:	89 1c 24             	mov    %ebx,(%esp)
  801b30:	e8 54 ff ff ff       	call   801a89 <fstat>
  801b35:	89 c6                	mov    %eax,%esi
	close(fd);
  801b37:	89 1c 24             	mov    %ebx,(%esp)
  801b3a:	e8 be fb ff ff       	call   8016fd <close>
	return r;
  801b3f:	89 f3                	mov    %esi,%ebx
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b46:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b49:	89 ec                	mov    %ebp,%esp
  801b4b:	5d                   	pop    %ebp
  801b4c:	c3                   	ret    
  801b4d:	00 00                	add    %al,(%eax)
	...

00801b50 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
  801b56:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b59:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b60:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b67:	75 11                	jne    801b7a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b70:	e8 51 f9 ff ff       	call   8014c6 <ipc_find_env>
  801b75:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b7a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b81:	00 
  801b82:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b89:	00 
  801b8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b8e:	a1 00 40 80 00       	mov    0x804000,%eax
  801b93:	89 04 24             	mov    %eax,(%esp)
  801b96:	e8 a7 f8 ff ff       	call   801442 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ba2:	00 
  801ba3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bae:	e8 3d f8 ff ff       	call   8013f0 <ipc_recv>
}
  801bb3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bb6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bb9:	89 ec                	mov    %ebp,%esp
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 14             	sub    $0x14,%esp
  801bc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 05 00 00 00       	mov    $0x5,%eax
  801bdc:	e8 6f ff ff ff       	call   801b50 <fsipc>
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 2b                	js     801c10 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801be5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801bec:	00 
  801bed:	89 1c 24             	mov    %ebx,(%esp)
  801bf0:	e8 86 ec ff ff       	call   80087b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf5:	a1 80 50 80 00       	mov    0x805080,%eax
  801bfa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c00:	a1 84 50 80 00       	mov    0x805084,%eax
  801c05:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	83 c4 14             	add    $0x14,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c22:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c27:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2c:	b8 06 00 00 00       	mov    $0x6,%eax
  801c31:	e8 1a ff ff ff       	call   801b50 <fsipc>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	83 ec 10             	sub    $0x10,%esp
  801c40:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8b 40 0c             	mov    0xc(%eax),%eax
  801c49:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c4e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c54:	ba 00 00 00 00       	mov    $0x0,%edx
  801c59:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5e:	e8 ed fe ff ff       	call   801b50 <fsipc>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 6a                	js     801cd3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c69:	39 c6                	cmp    %eax,%esi
  801c6b:	73 24                	jae    801c91 <devfile_read+0x59>
  801c6d:	c7 44 24 0c ac 2c 80 	movl   $0x802cac,0xc(%esp)
  801c74:	00 
  801c75:	c7 44 24 08 b3 2c 80 	movl   $0x802cb3,0x8(%esp)
  801c7c:	00 
  801c7d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c84:	00 
  801c85:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  801c8c:	e8 6f 06 00 00       	call   802300 <_panic>
	assert(r <= PGSIZE);
  801c91:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c96:	7e 24                	jle    801cbc <devfile_read+0x84>
  801c98:	c7 44 24 0c d3 2c 80 	movl   $0x802cd3,0xc(%esp)
  801c9f:	00 
  801ca0:	c7 44 24 08 b3 2c 80 	movl   $0x802cb3,0x8(%esp)
  801ca7:	00 
  801ca8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801caf:	00 
  801cb0:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  801cb7:	e8 44 06 00 00       	call   802300 <_panic>
	memmove(buf, &fsipcbuf, r);
  801cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801cc7:	00 
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	89 04 24             	mov    %eax,(%esp)
  801cce:	e8 99 ed ff ff       	call   800a6c <memmove>
	return r;
}
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    

00801cdc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 20             	sub    $0x20,%esp
  801ce4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ce7:	89 34 24             	mov    %esi,(%esp)
  801cea:	e8 41 eb ff ff       	call   800830 <strlen>
		return -E_BAD_PATH;
  801cef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cf4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf9:	7f 5e                	jg     801d59 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 35 f8 ff ff       	call   80153b <fd_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 4d                	js     801d59 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d10:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d17:	e8 5f eb ff ff       	call   80087b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2c:	e8 1f fe ff ff       	call   801b50 <fsipc>
  801d31:	89 c3                	mov    %eax,%ebx
  801d33:	85 c0                	test   %eax,%eax
  801d35:	79 15                	jns    801d4c <open+0x70>
		fd_close(fd, 0);
  801d37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3e:	00 
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 21 f9 ff ff       	call   80166b <fd_close>
		return r;
  801d4a:	eb 0d                	jmp    801d59 <open+0x7d>
	}

	return fd2num(fd);
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 b9 f7 ff ff       	call   801510 <fd2num>
  801d57:	89 c3                	mov    %eax,%ebx
}
  801d59:	89 d8                	mov    %ebx,%eax
  801d5b:	83 c4 20             	add    $0x20,%esp
  801d5e:	5b                   	pop    %ebx
  801d5f:	5e                   	pop    %esi
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    
	...

00801d70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
  801d76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d79:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 04 24             	mov    %eax,(%esp)
  801d85:	e8 96 f7 ff ff       	call   801520 <fd2data>
  801d8a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d8c:	c7 44 24 04 df 2c 80 	movl   $0x802cdf,0x4(%esp)
  801d93:	00 
  801d94:	89 34 24             	mov    %esi,(%esp)
  801d97:	e8 df ea ff ff       	call   80087b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d9f:	2b 03                	sub    (%ebx),%eax
  801da1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801da7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801dae:	00 00 00 
	stat->st_dev = &devpipe;
  801db1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801db8:	30 80 00 
	return 0;
}
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dc3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dc6:	89 ec                	mov    %ebp,%esp
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 14             	sub    $0x14,%esp
  801dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddf:	e8 55 f0 ff ff       	call   800e39 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801de4:	89 1c 24             	mov    %ebx,(%esp)
  801de7:	e8 34 f7 ff ff       	call   801520 <fd2data>
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df7:	e8 3d f0 ff ff       	call   800e39 <sys_page_unmap>
}
  801dfc:	83 c4 14             	add    $0x14,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 2c             	sub    $0x2c,%esp
  801e0b:	89 c7                	mov    %eax,%edi
  801e0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e10:	a1 08 40 80 00       	mov    0x804008,%eax
  801e15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e18:	89 3c 24             	mov    %edi,(%esp)
  801e1b:	e8 d0 05 00 00       	call   8023f0 <pageref>
  801e20:	89 c6                	mov    %eax,%esi
  801e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 c3 05 00 00       	call   8023f0 <pageref>
  801e2d:	39 c6                	cmp    %eax,%esi
  801e2f:	0f 94 c0             	sete   %al
  801e32:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801e35:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e3e:	39 cb                	cmp    %ecx,%ebx
  801e40:	75 08                	jne    801e4a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e42:	83 c4 2c             	add    $0x2c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e4a:	83 f8 01             	cmp    $0x1,%eax
  801e4d:	75 c1                	jne    801e10 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e4f:	8b 52 58             	mov    0x58(%edx),%edx
  801e52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e5e:	c7 04 24 e6 2c 80 00 	movl   $0x802ce6,(%esp)
  801e65:	e8 f1 e3 ff ff       	call   80025b <cprintf>
  801e6a:	eb a4                	jmp    801e10 <_pipeisclosed+0xe>

00801e6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 2c             	sub    $0x2c,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e78:	89 34 24             	mov    %esi,(%esp)
  801e7b:	e8 a0 f6 ff ff       	call   801520 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e82:	bf 00 00 00 00       	mov    $0x0,%edi
  801e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8b:	75 50                	jne    801edd <devpipe_write+0x71>
  801e8d:	eb 5c                	jmp    801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e8f:	89 da                	mov    %ebx,%edx
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	e8 6a ff ff ff       	call   801e02 <_pipeisclosed>
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	75 53                	jne    801eef <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e9c:	e8 ab ee ff ff       	call   800d4c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea4:	8b 13                	mov    (%ebx),%edx
  801ea6:	83 c2 20             	add    $0x20,%edx
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	73 e2                	jae    801e8f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801eb4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	c1 fa 1f             	sar    $0x1f,%edx
  801ebc:	c1 ea 1b             	shr    $0x1b,%edx
  801ebf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ec2:	83 e1 1f             	and    $0x1f,%ecx
  801ec5:	29 d1                	sub    %edx,%ecx
  801ec7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ecb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ecf:	83 c0 01             	add    $0x1,%eax
  801ed2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ed5:	83 c7 01             	add    $0x1,%edi
  801ed8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801edb:	74 0e                	je     801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801edd:	8b 43 04             	mov    0x4(%ebx),%eax
  801ee0:	8b 13                	mov    (%ebx),%edx
  801ee2:	83 c2 20             	add    $0x20,%edx
  801ee5:	39 d0                	cmp    %edx,%eax
  801ee7:	73 a6                	jae    801e8f <devpipe_write+0x23>
  801ee9:	eb c2                	jmp    801ead <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801eeb:	89 f8                	mov    %edi,%eax
  801eed:	eb 05                	jmp    801ef4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ef4:	83 c4 2c             	add    $0x2c,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 28             	sub    $0x28,%esp
  801f02:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f05:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f08:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f0b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f0e:	89 3c 24             	mov    %edi,(%esp)
  801f11:	e8 0a f6 ff ff       	call   801520 <fd2data>
  801f16:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f18:	be 00 00 00 00       	mov    $0x0,%esi
  801f1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f21:	75 47                	jne    801f6a <devpipe_read+0x6e>
  801f23:	eb 52                	jmp    801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	eb 5e                	jmp    801f87 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f29:	89 da                	mov    %ebx,%edx
  801f2b:	89 f8                	mov    %edi,%eax
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	e8 cd fe ff ff       	call   801e02 <_pipeisclosed>
  801f35:	85 c0                	test   %eax,%eax
  801f37:	75 49                	jne    801f82 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f39:	e8 0e ee ff ff       	call   800d4c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f3e:	8b 03                	mov    (%ebx),%eax
  801f40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f43:	74 e4                	je     801f29 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f45:	89 c2                	mov    %eax,%edx
  801f47:	c1 fa 1f             	sar    $0x1f,%edx
  801f4a:	c1 ea 1b             	shr    $0x1b,%edx
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	83 e0 1f             	and    $0x1f,%eax
  801f52:	29 d0                	sub    %edx,%eax
  801f54:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f5f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f62:	83 c6 01             	add    $0x1,%esi
  801f65:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f68:	74 0d                	je     801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801f6a:	8b 03                	mov    (%ebx),%eax
  801f6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6f:	75 d4                	jne    801f45 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f71:	85 f6                	test   %esi,%esi
  801f73:	75 b0                	jne    801f25 <devpipe_read+0x29>
  801f75:	eb b2                	jmp    801f29 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f77:	89 f0                	mov    %esi,%eax
  801f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f80:	eb 05                	jmp    801f87 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f87:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f8a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f8d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f90:	89 ec                	mov    %ebp,%esp
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 48             	sub    $0x48,%esp
  801f9a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f9d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fa0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fa3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fa6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fa9:	89 04 24             	mov    %eax,(%esp)
  801fac:	e8 8a f5 ff ff       	call   80153b <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 88 45 01 00 00    	js     802100 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc2:	00 
  801fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd1:	e8 a6 ed ff ff       	call   800d7c <sys_page_alloc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 20 01 00 00    	js     802100 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fe0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fe3:	89 04 24             	mov    %eax,(%esp)
  801fe6:	e8 50 f5 ff ff       	call   80153b <fd_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	85 c0                	test   %eax,%eax
  801fef:	0f 88 f8 00 00 00    	js     8020ed <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ffc:	00 
  801ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200b:	e8 6c ed ff ff       	call   800d7c <sys_page_alloc>
  802010:	89 c3                	mov    %eax,%ebx
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 d3 00 00 00    	js     8020ed <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80201a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80201d:	89 04 24             	mov    %eax,(%esp)
  802020:	e8 fb f4 ff ff       	call   801520 <fd2data>
  802025:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802027:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80202e:	00 
  80202f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802033:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203a:	e8 3d ed ff ff       	call   800d7c <sys_page_alloc>
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 91 00 00 00    	js     8020da <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 cc f4 ff ff       	call   801520 <fd2data>
  802054:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80205b:	00 
  80205c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802060:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802067:	00 
  802068:	89 74 24 04          	mov    %esi,0x4(%esp)
  80206c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802073:	e8 63 ed ff ff       	call   800ddb <sys_page_map>
  802078:	89 c3                	mov    %eax,%ebx
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 4c                	js     8020ca <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80207e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802087:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802093:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80209e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 5d f4 ff ff       	call   801510 <fd2num>
  8020b3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8020b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 50 f4 ff ff       	call   801510 <fd2num>
  8020c0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8020c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020c8:	eb 36                	jmp    802100 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8020ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d5:	e8 5f ed ff ff       	call   800e39 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e8:	e8 4c ed ff ff       	call   800e39 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fb:	e8 39 ed ff ff       	call   800e39 <sys_page_unmap>
    err:
	return r;
}
  802100:	89 d8                	mov    %ebx,%eax
  802102:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802105:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802108:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80210b:	89 ec                	mov    %ebp,%esp
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 87 f4 ff ff       	call   8015ae <fd_lookup>
  802127:	85 c0                	test   %eax,%eax
  802129:	78 15                	js     802140 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	89 04 24             	mov    %eax,(%esp)
  802131:	e8 ea f3 ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  802136:	89 c2                	mov    %eax,%edx
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	e8 c2 fc ff ff       	call   801e02 <_pipeisclosed>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    
	...

00802150 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802160:	c7 44 24 04 fe 2c 80 	movl   $0x802cfe,0x4(%esp)
  802167:	00 
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	89 04 24             	mov    %eax,(%esp)
  80216e:	e8 08 e7 ff ff       	call   80087b <strcpy>
	return 0;
}
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	57                   	push   %edi
  80217e:	56                   	push   %esi
  80217f:	53                   	push   %ebx
  802180:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802186:	be 00 00 00 00       	mov    $0x0,%esi
  80218b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218f:	74 43                	je     8021d4 <devcons_write+0x5a>
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802196:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80219c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80219f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8021a1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021a4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021a9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b0:	03 45 0c             	add    0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	89 3c 24             	mov    %edi,(%esp)
  8021ba:	e8 ad e8 ff ff       	call   800a6c <memmove>
		sys_cputs(buf, m);
  8021bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021c3:	89 3c 24             	mov    %edi,(%esp)
  8021c6:	e8 95 ea ff ff       	call   800c60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021cb:	01 de                	add    %ebx,%esi
  8021cd:	89 f0                	mov    %esi,%eax
  8021cf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021d2:	72 c8                	jb     80219c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021d4:	89 f0                	mov    %esi,%eax
  8021d6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021dc:	5b                   	pop    %ebx
  8021dd:	5e                   	pop    %esi
  8021de:	5f                   	pop    %edi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    

008021e1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f0:	75 07                	jne    8021f9 <devcons_read+0x18>
  8021f2:	eb 31                	jmp    802225 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021f4:	e8 53 eb ff ff       	call   800d4c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	e8 8a ea ff ff       	call   800c8f <sys_cgetc>
  802205:	85 c0                	test   %eax,%eax
  802207:	74 eb                	je     8021f4 <devcons_read+0x13>
  802209:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80220b:	85 c0                	test   %eax,%eax
  80220d:	78 16                	js     802225 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80220f:	83 f8 04             	cmp    $0x4,%eax
  802212:	74 0c                	je     802220 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802214:	8b 45 0c             	mov    0xc(%ebp),%eax
  802217:	88 10                	mov    %dl,(%eax)
	return 1;
  802219:	b8 01 00 00 00       	mov    $0x1,%eax
  80221e:	eb 05                	jmp    802225 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802233:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80223a:	00 
  80223b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 1a ea ff ff       	call   800c60 <sys_cputs>
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <getchar>:

int
getchar(void)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80224e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802255:	00 
  802256:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802264:	e8 05 f6 ff ff       	call   80186e <read>
	if (r < 0)
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 0f                	js     80227c <getchar+0x34>
		return r;
	if (r < 1)
  80226d:	85 c0                	test   %eax,%eax
  80226f:	7e 06                	jle    802277 <getchar+0x2f>
		return -E_EOF;
	return c;
  802271:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802275:	eb 05                	jmp    80227c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802277:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802284:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 18 f3 ff ff       	call   8015ae <fd_lookup>
  802296:	85 c0                	test   %eax,%eax
  802298:	78 11                	js     8022ab <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022a3:	39 10                	cmp    %edx,(%eax)
  8022a5:	0f 94 c0             	sete   %al
  8022a8:	0f b6 c0             	movzbl %al,%eax
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <opencons>:

int
opencons(void)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b6:	89 04 24             	mov    %eax,(%esp)
  8022b9:	e8 7d f2 ff ff       	call   80153b <fd_alloc>
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 3c                	js     8022fe <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c9:	00 
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d8:	e8 9f ea ff ff       	call   800d7c <sys_page_alloc>
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 1d                	js     8022fe <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022e1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 12 f2 ff ff       	call   801510 <fd2num>
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802308:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80230b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  802311:	e8 06 ea ff ff       	call   800d1c <sys_getenvid>
  802316:	8b 55 0c             	mov    0xc(%ebp),%edx
  802319:	89 54 24 10          	mov    %edx,0x10(%esp)
  80231d:	8b 55 08             	mov    0x8(%ebp),%edx
  802320:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802324:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232c:	c7 04 24 0c 2d 80 00 	movl   $0x802d0c,(%esp)
  802333:	e8 23 df ff ff       	call   80025b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802338:	89 74 24 04          	mov    %esi,0x4(%esp)
  80233c:	8b 45 10             	mov    0x10(%ebp),%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 b3 de ff ff       	call   8001fa <vcprintf>
	cprintf("\n");
  802347:	c7 04 24 f7 2c 80 00 	movl   $0x802cf7,(%esp)
  80234e:	e8 08 df ff ff       	call   80025b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802353:	cc                   	int3   
  802354:	eb fd                	jmp    802353 <_panic+0x53>
	...

00802358 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80235e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802365:	75 54                	jne    8023bb <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  802367:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80236e:	00 
  80236f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802376:	ee 
  802377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80237e:	e8 f9 e9 ff ff       	call   800d7c <sys_page_alloc>
  802383:	85 c0                	test   %eax,%eax
  802385:	79 20                	jns    8023a7 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  802387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238b:	c7 44 24 08 30 2d 80 	movl   $0x802d30,0x8(%esp)
  802392:	00 
  802393:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80239a:	00 
  80239b:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  8023a2:	e8 59 ff ff ff       	call   802300 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023a7:	c7 44 24 04 c8 23 80 	movl   $0x8023c8,0x4(%esp)
  8023ae:	00 
  8023af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b6:	e8 98 eb ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    
  8023c5:	00 00                	add    %al,(%eax)
	...

008023c8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023c8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023c9:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023ce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023d0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8023d3:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8023d7:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8023da:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8023de:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8023e2:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8023e4:	83 c4 08             	add    $0x8,%esp
	popal
  8023e7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8023e8:	83 c4 04             	add    $0x4,%esp
	popfl
  8023eb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023ec:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8023ed:	c3                   	ret    
	...

008023f0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f6:	89 d0                	mov    %edx,%eax
  8023f8:	c1 e8 16             	shr    $0x16,%eax
  8023fb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802407:	f6 c1 01             	test   $0x1,%cl
  80240a:	74 1d                	je     802429 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80240c:	c1 ea 0c             	shr    $0xc,%edx
  80240f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802416:	f6 c2 01             	test   $0x1,%dl
  802419:	74 0e                	je     802429 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80241b:	c1 ea 0c             	shr    $0xc,%edx
  80241e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802425:	ef 
  802426:	0f b7 c0             	movzwl %ax,%eax
}
  802429:	5d                   	pop    %ebp
  80242a:	c3                   	ret    
  80242b:	00 00                	add    %al,(%eax)
  80242d:	00 00                	add    %al,(%eax)
	...

00802430 <__udivdi3>:
  802430:	83 ec 1c             	sub    $0x1c,%esp
  802433:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802437:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80243b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80243f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802443:	89 74 24 10          	mov    %esi,0x10(%esp)
  802447:	8b 74 24 24          	mov    0x24(%esp),%esi
  80244b:	85 ff                	test   %edi,%edi
  80244d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802451:	89 44 24 08          	mov    %eax,0x8(%esp)
  802455:	89 cd                	mov    %ecx,%ebp
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	75 33                	jne    802490 <__udivdi3+0x60>
  80245d:	39 f1                	cmp    %esi,%ecx
  80245f:	77 57                	ja     8024b8 <__udivdi3+0x88>
  802461:	85 c9                	test   %ecx,%ecx
  802463:	75 0b                	jne    802470 <__udivdi3+0x40>
  802465:	b8 01 00 00 00       	mov    $0x1,%eax
  80246a:	31 d2                	xor    %edx,%edx
  80246c:	f7 f1                	div    %ecx
  80246e:	89 c1                	mov    %eax,%ecx
  802470:	89 f0                	mov    %esi,%eax
  802472:	31 d2                	xor    %edx,%edx
  802474:	f7 f1                	div    %ecx
  802476:	89 c6                	mov    %eax,%esi
  802478:	8b 44 24 04          	mov    0x4(%esp),%eax
  80247c:	f7 f1                	div    %ecx
  80247e:	89 f2                	mov    %esi,%edx
  802480:	8b 74 24 10          	mov    0x10(%esp),%esi
  802484:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802488:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	c3                   	ret    
  802490:	31 d2                	xor    %edx,%edx
  802492:	31 c0                	xor    %eax,%eax
  802494:	39 f7                	cmp    %esi,%edi
  802496:	77 e8                	ja     802480 <__udivdi3+0x50>
  802498:	0f bd cf             	bsr    %edi,%ecx
  80249b:	83 f1 1f             	xor    $0x1f,%ecx
  80249e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024a2:	75 2c                	jne    8024d0 <__udivdi3+0xa0>
  8024a4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8024a8:	76 04                	jbe    8024ae <__udivdi3+0x7e>
  8024aa:	39 f7                	cmp    %esi,%edi
  8024ac:	73 d2                	jae    802480 <__udivdi3+0x50>
  8024ae:	31 d2                	xor    %edx,%edx
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b5:	eb c9                	jmp    802480 <__udivdi3+0x50>
  8024b7:	90                   	nop
  8024b8:	89 f2                	mov    %esi,%edx
  8024ba:	f7 f1                	div    %ecx
  8024bc:	31 d2                	xor    %edx,%edx
  8024be:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024c2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024c6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	c3                   	ret    
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024d5:	b8 20 00 00 00       	mov    $0x20,%eax
  8024da:	89 ea                	mov    %ebp,%edx
  8024dc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024e0:	d3 e7                	shl    %cl,%edi
  8024e2:	89 c1                	mov    %eax,%ecx
  8024e4:	d3 ea                	shr    %cl,%edx
  8024e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024eb:	09 fa                	or     %edi,%edx
  8024ed:	89 f7                	mov    %esi,%edi
  8024ef:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024f3:	89 f2                	mov    %esi,%edx
  8024f5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8024f9:	d3 e5                	shl    %cl,%ebp
  8024fb:	89 c1                	mov    %eax,%ecx
  8024fd:	d3 ef                	shr    %cl,%edi
  8024ff:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802504:	d3 e2                	shl    %cl,%edx
  802506:	89 c1                	mov    %eax,%ecx
  802508:	d3 ee                	shr    %cl,%esi
  80250a:	09 d6                	or     %edx,%esi
  80250c:	89 fa                	mov    %edi,%edx
  80250e:	89 f0                	mov    %esi,%eax
  802510:	f7 74 24 0c          	divl   0xc(%esp)
  802514:	89 d7                	mov    %edx,%edi
  802516:	89 c6                	mov    %eax,%esi
  802518:	f7 e5                	mul    %ebp
  80251a:	39 d7                	cmp    %edx,%edi
  80251c:	72 22                	jb     802540 <__udivdi3+0x110>
  80251e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802522:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802527:	d3 e5                	shl    %cl,%ebp
  802529:	39 c5                	cmp    %eax,%ebp
  80252b:	73 04                	jae    802531 <__udivdi3+0x101>
  80252d:	39 d7                	cmp    %edx,%edi
  80252f:	74 0f                	je     802540 <__udivdi3+0x110>
  802531:	89 f0                	mov    %esi,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	e9 46 ff ff ff       	jmp    802480 <__udivdi3+0x50>
  80253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802540:	8d 46 ff             	lea    -0x1(%esi),%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	8b 74 24 10          	mov    0x10(%esp),%esi
  802549:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80254d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802551:	83 c4 1c             	add    $0x1c,%esp
  802554:	c3                   	ret    
	...

00802560 <__umoddi3>:
  802560:	83 ec 1c             	sub    $0x1c,%esp
  802563:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802567:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80256b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80256f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802573:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802577:	8b 74 24 24          	mov    0x24(%esp),%esi
  80257b:	85 ed                	test   %ebp,%ebp
  80257d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802581:	89 44 24 08          	mov    %eax,0x8(%esp)
  802585:	89 cf                	mov    %ecx,%edi
  802587:	89 04 24             	mov    %eax,(%esp)
  80258a:	89 f2                	mov    %esi,%edx
  80258c:	75 1a                	jne    8025a8 <__umoddi3+0x48>
  80258e:	39 f1                	cmp    %esi,%ecx
  802590:	76 4e                	jbe    8025e0 <__umoddi3+0x80>
  802592:	f7 f1                	div    %ecx
  802594:	89 d0                	mov    %edx,%eax
  802596:	31 d2                	xor    %edx,%edx
  802598:	8b 74 24 10          	mov    0x10(%esp),%esi
  80259c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025a0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025a4:	83 c4 1c             	add    $0x1c,%esp
  8025a7:	c3                   	ret    
  8025a8:	39 f5                	cmp    %esi,%ebp
  8025aa:	77 54                	ja     802600 <__umoddi3+0xa0>
  8025ac:	0f bd c5             	bsr    %ebp,%eax
  8025af:	83 f0 1f             	xor    $0x1f,%eax
  8025b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b6:	75 60                	jne    802618 <__umoddi3+0xb8>
  8025b8:	3b 0c 24             	cmp    (%esp),%ecx
  8025bb:	0f 87 07 01 00 00    	ja     8026c8 <__umoddi3+0x168>
  8025c1:	89 f2                	mov    %esi,%edx
  8025c3:	8b 34 24             	mov    (%esp),%esi
  8025c6:	29 ce                	sub    %ecx,%esi
  8025c8:	19 ea                	sbb    %ebp,%edx
  8025ca:	89 34 24             	mov    %esi,(%esp)
  8025cd:	8b 04 24             	mov    (%esp),%eax
  8025d0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025d4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025d8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025dc:	83 c4 1c             	add    $0x1c,%esp
  8025df:	c3                   	ret    
  8025e0:	85 c9                	test   %ecx,%ecx
  8025e2:	75 0b                	jne    8025ef <__umoddi3+0x8f>
  8025e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e9:	31 d2                	xor    %edx,%edx
  8025eb:	f7 f1                	div    %ecx
  8025ed:	89 c1                	mov    %eax,%ecx
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	31 d2                	xor    %edx,%edx
  8025f3:	f7 f1                	div    %ecx
  8025f5:	8b 04 24             	mov    (%esp),%eax
  8025f8:	f7 f1                	div    %ecx
  8025fa:	eb 98                	jmp    802594 <__umoddi3+0x34>
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	89 f2                	mov    %esi,%edx
  802602:	8b 74 24 10          	mov    0x10(%esp),%esi
  802606:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80260a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	c3                   	ret    
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261d:	89 e8                	mov    %ebp,%eax
  80261f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802624:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802628:	89 fa                	mov    %edi,%edx
  80262a:	d3 e0                	shl    %cl,%eax
  80262c:	89 e9                	mov    %ebp,%ecx
  80262e:	d3 ea                	shr    %cl,%edx
  802630:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802635:	09 c2                	or     %eax,%edx
  802637:	8b 44 24 08          	mov    0x8(%esp),%eax
  80263b:	89 14 24             	mov    %edx,(%esp)
  80263e:	89 f2                	mov    %esi,%edx
  802640:	d3 e7                	shl    %cl,%edi
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	d3 ea                	shr    %cl,%edx
  802646:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80264b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80264f:	d3 e6                	shl    %cl,%esi
  802651:	89 e9                	mov    %ebp,%ecx
  802653:	d3 e8                	shr    %cl,%eax
  802655:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265a:	09 f0                	or     %esi,%eax
  80265c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802660:	f7 34 24             	divl   (%esp)
  802663:	d3 e6                	shl    %cl,%esi
  802665:	89 74 24 08          	mov    %esi,0x8(%esp)
  802669:	89 d6                	mov    %edx,%esi
  80266b:	f7 e7                	mul    %edi
  80266d:	39 d6                	cmp    %edx,%esi
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 d7                	mov    %edx,%edi
  802673:	72 3f                	jb     8026b4 <__umoddi3+0x154>
  802675:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802679:	72 35                	jb     8026b0 <__umoddi3+0x150>
  80267b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80267f:	29 c8                	sub    %ecx,%eax
  802681:	19 fe                	sbb    %edi,%esi
  802683:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802688:	89 f2                	mov    %esi,%edx
  80268a:	d3 e8                	shr    %cl,%eax
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802695:	09 d0                	or     %edx,%eax
  802697:	89 f2                	mov    %esi,%edx
  802699:	d3 ea                	shr    %cl,%edx
  80269b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80269f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026a3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026a7:	83 c4 1c             	add    $0x1c,%esp
  8026aa:	c3                   	ret    
  8026ab:	90                   	nop
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	39 d6                	cmp    %edx,%esi
  8026b2:	75 c7                	jne    80267b <__umoddi3+0x11b>
  8026b4:	89 d7                	mov    %edx,%edi
  8026b6:	89 c1                	mov    %eax,%ecx
  8026b8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8026bc:	1b 3c 24             	sbb    (%esp),%edi
  8026bf:	eb ba                	jmp    80267b <__umoddi3+0x11b>
  8026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	39 f5                	cmp    %esi,%ebp
  8026ca:	0f 82 f1 fe ff ff    	jb     8025c1 <__umoddi3+0x61>
  8026d0:	e9 f8 fe ff ff       	jmp    8025cd <__umoddi3+0x6d>
