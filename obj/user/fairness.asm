
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003c:	e8 4b 0c 00 00       	call   800c8c <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800043:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  80004a:	00 c0 ee 
  80004d:	75 34                	jne    800083 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800052:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800059:	00 
  80005a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800061:	00 
  800062:	89 34 24             	mov    %esi,(%esp)
  800065:	e8 56 0f 00 00       	call   800fc0 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800071:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800075:	c7 04 24 20 22 80 00 	movl   $0x802220,(%esp)
  80007c:	e8 52 01 00 00       	call   8001d3 <cprintf>
  800081:	eb cf                	jmp    800052 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800083:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800088:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800090:	c7 04 24 31 22 80 00 	movl   $0x802231,(%esp)
  800097:	e8 37 01 00 00       	call   8001d3 <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009c:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  8000a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000a8:	00 
  8000a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b8:	00 
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 51 0f 00 00       	call   801012 <ipc_send>
  8000c1:	eb d9                	jmp    80009c <umain+0x68>
	...

008000c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	83 ec 18             	sub    $0x18,%esp
  8000ca:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000cd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000d6:	e8 b1 0b 00 00       	call   800c8c <sys_getenvid>
  8000db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e8:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ed:	85 f6                	test   %esi,%esi
  8000ef:	7e 07                	jle    8000f8 <libmain+0x34>
		binaryname = argv[0];
  8000f1:	8b 03                	mov    (%ebx),%eax
  8000f3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000fc:	89 34 24             	mov    %esi,(%esp)
  8000ff:	e8 30 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800104:	e8 0b 00 00 00       	call   800114 <exit>
}
  800109:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80010c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80010f:	89 ec                	mov    %ebp,%esp
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    
	...

00800114 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80011a:	e8 df 11 00 00       	call   8012fe <close_all>
	sys_env_destroy(0);
  80011f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800126:	e8 04 0b 00 00       	call   800c2f <sys_env_destroy>
}
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    
  80012d:	00 00                	add    %al,(%eax)
	...

00800130 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	53                   	push   %ebx
  800134:	83 ec 14             	sub    $0x14,%esp
  800137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013a:	8b 03                	mov    (%ebx),%eax
  80013c:	8b 55 08             	mov    0x8(%ebp),%edx
  80013f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800143:	83 c0 01             	add    $0x1,%eax
  800146:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800148:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014d:	75 19                	jne    800168 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80014f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800156:	00 
  800157:	8d 43 08             	lea    0x8(%ebx),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 6e 0a 00 00       	call   800bd0 <sys_cputs>
		b->idx = 0;
  800162:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800168:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016c:	83 c4 14             	add    $0x14,%esp
  80016f:	5b                   	pop    %ebx
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    

00800172 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80017b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800182:	00 00 00 
	b.cnt = 0;
  800185:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800192:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
  800199:	89 44 24 08          	mov    %eax,0x8(%esp)
  80019d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	c7 04 24 30 01 80 00 	movl   $0x800130,(%esp)
  8001ae:	e8 97 01 00 00       	call   80034a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c3:	89 04 24             	mov    %eax,(%esp)
  8001c6:	e8 05 0a 00 00       	call   800bd0 <sys_cputs>

	return b.cnt;
}
  8001cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e3:	89 04 24             	mov    %eax,(%esp)
  8001e6:	e8 87 ff ff ff       	call   800172 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    
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
  80025a:	e8 11 1d 00 00       	call   801f70 <__udivdi3>
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
  8002ad:	e8 ee 1d 00 00       	call   8020a0 <__umoddi3>
  8002b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b6:	0f be 80 52 22 80 00 	movsbl 0x802252(%eax),%eax
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
  8003de:	ff 24 85 a0 23 80 00 	jmp    *0x8023a0(,%eax,4)
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
  800494:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  80049b:	85 d2                	test   %edx,%edx
  80049d:	75 23                	jne    8004c2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80049f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a3:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
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
  8004c6:	c7 44 24 08 45 26 80 	movl   $0x802645,0x8(%esp)
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
  8004fb:	ba 63 22 80 00       	mov    $0x802263,%edx
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
  800c63:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c72:	00 
  800c73:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800c7a:	e8 51 12 00 00       	call   801ed0 <_panic>

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
  800d22:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800d29:	00 
  800d2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d31:	00 
  800d32:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800d39:	e8 92 11 00 00       	call   801ed0 <_panic>

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
  800d80:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800d87:	00 
  800d88:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8f:	00 
  800d90:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800d97:	e8 34 11 00 00       	call   801ed0 <_panic>

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
  800dde:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800de5:	00 
  800de6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ded:	00 
  800dee:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800df5:	e8 d6 10 00 00       	call   801ed0 <_panic>

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
  800e3c:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800e43:	00 
  800e44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4b:	00 
  800e4c:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800e53:	e8 78 10 00 00       	call   801ed0 <_panic>

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
  800e9a:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800ea1:	00 
  800ea2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea9:	00 
  800eaa:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800eb1:	e8 1a 10 00 00       	call   801ed0 <_panic>

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
  800ef8:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800eff:	00 
  800f00:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f07:	00 
  800f08:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800f0f:	e8 bc 0f 00 00       	call   801ed0 <_panic>

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
  800f89:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800fa0:	e8 2b 0f 00 00       	call   801ed0 <_panic>

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

00800fc0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 10             	sub    $0x10,%esp
  800fc8:	8b 75 08             	mov    0x8(%ebp),%esi
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  800fd1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  800fd3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800fd8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  800fdb:	89 04 24             	mov    %eax,(%esp)
  800fde:	e8 72 ff ff ff       	call   800f55 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  800fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  800fed:	85 c0                	test   %eax,%eax
  800fef:	78 0e                	js     800fff <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  800ff1:	a1 04 40 80 00       	mov    0x804004,%eax
  800ff6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  800ff9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  800ffc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  800fff:	85 f6                	test   %esi,%esi
  801001:	74 02                	je     801005 <ipc_recv+0x45>
		*from_env_store = sender;
  801003:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801005:	85 db                	test   %ebx,%ebx
  801007:	74 02                	je     80100b <ipc_recv+0x4b>
		*perm_store = perm;
  801009:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	57                   	push   %edi
  801016:	56                   	push   %esi
  801017:	53                   	push   %ebx
  801018:	83 ec 1c             	sub    $0x1c,%esp
  80101b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80101e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801021:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801024:	85 db                	test   %ebx,%ebx
  801026:	75 04                	jne    80102c <ipc_send+0x1a>
  801028:	85 f6                	test   %esi,%esi
  80102a:	75 15                	jne    801041 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80102c:	85 db                	test   %ebx,%ebx
  80102e:	74 16                	je     801046 <ipc_send+0x34>
  801030:	85 f6                	test   %esi,%esi
  801032:	0f 94 c0             	sete   %al
      pg = 0;
  801035:	84 c0                	test   %al,%al
  801037:	b8 00 00 00 00       	mov    $0x0,%eax
  80103c:	0f 45 d8             	cmovne %eax,%ebx
  80103f:	eb 05                	jmp    801046 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801041:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801046:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80104a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80104e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 04 24             	mov    %eax,(%esp)
  801058:	e8 c4 fe ff ff       	call   800f21 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80105d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801060:	75 07                	jne    801069 <ipc_send+0x57>
           sys_yield();
  801062:	e8 55 fc ff ff       	call   800cbc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801067:	eb dd                	jmp    801046 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801069:	85 c0                	test   %eax,%eax
  80106b:	90                   	nop
  80106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801070:	74 1c                	je     80108e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801072:	c7 44 24 08 8a 25 80 	movl   $0x80258a,0x8(%esp)
  801079:	00 
  80107a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801081:	00 
  801082:	c7 04 24 94 25 80 00 	movl   $0x802594,(%esp)
  801089:	e8 42 0e 00 00       	call   801ed0 <_panic>
		}
    }
}
  80108e:	83 c4 1c             	add    $0x1c,%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80109c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8010a1:	39 c8                	cmp    %ecx,%eax
  8010a3:	74 17                	je     8010bc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8010a5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8010aa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8010ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8010b3:	8b 52 50             	mov    0x50(%edx),%edx
  8010b6:	39 ca                	cmp    %ecx,%edx
  8010b8:	75 14                	jne    8010ce <ipc_find_env+0x38>
  8010ba:	eb 05                	jmp    8010c1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8010c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010c4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8010c9:	8b 40 40             	mov    0x40(%eax),%eax
  8010cc:	eb 0e                	jmp    8010dc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8010ce:	83 c0 01             	add    $0x1,%eax
  8010d1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010d6:	75 d2                	jne    8010aa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8010d8:	66 b8 00 00          	mov    $0x0,%ax
}
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    
	...

008010e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	89 04 24             	mov    %eax,(%esp)
  8010fc:	e8 df ff ff ff       	call   8010e0 <fd2num>
  801101:	05 20 00 0d 00       	add    $0xd0020,%eax
  801106:	c1 e0 0c             	shl    $0xc,%eax
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	53                   	push   %ebx
  80110f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801112:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 34                	je     80114f <fd_alloc+0x44>
  80111b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801120:	a8 01                	test   $0x1,%al
  801122:	74 32                	je     801156 <fd_alloc+0x4b>
  801124:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801129:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	c1 ea 16             	shr    $0x16,%edx
  801130:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801137:	f6 c2 01             	test   $0x1,%dl
  80113a:	74 1f                	je     80115b <fd_alloc+0x50>
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	c1 ea 0c             	shr    $0xc,%edx
  801141:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801148:	f6 c2 01             	test   $0x1,%dl
  80114b:	75 17                	jne    801164 <fd_alloc+0x59>
  80114d:	eb 0c                	jmp    80115b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80114f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801154:	eb 05                	jmp    80115b <fd_alloc+0x50>
  801156:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80115b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
  801162:	eb 17                	jmp    80117b <fd_alloc+0x70>
  801164:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801169:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80116e:	75 b9                	jne    801129 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801170:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801176:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80117b:	5b                   	pop    %ebx
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801184:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801189:	83 fa 1f             	cmp    $0x1f,%edx
  80118c:	77 3f                	ja     8011cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80118e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801194:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801197:	89 d0                	mov    %edx,%eax
  801199:	c1 e8 16             	shr    $0x16,%eax
  80119c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a8:	f6 c1 01             	test   $0x1,%cl
  8011ab:	74 20                	je     8011cd <fd_lookup+0x4f>
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	c1 e8 0c             	shr    $0xc,%eax
  8011b2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011be:	f6 c1 01             	test   $0x1,%cl
  8011c1:	74 0a                	je     8011cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	89 10                	mov    %edx,(%eax)
	return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 14             	sub    $0x14,%esp
  8011d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8011e7:	75 17                	jne    801200 <dev_lookup+0x31>
  8011e9:	eb 07                	jmp    8011f2 <dev_lookup+0x23>
  8011eb:	39 0a                	cmp    %ecx,(%edx)
  8011ed:	75 11                	jne    801200 <dev_lookup+0x31>
  8011ef:	90                   	nop
  8011f0:	eb 05                	jmp    8011f7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011f2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011f7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	eb 35                	jmp    801235 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801200:	83 c0 01             	add    $0x1,%eax
  801203:	8b 14 85 1c 26 80 00 	mov    0x80261c(,%eax,4),%edx
  80120a:	85 d2                	test   %edx,%edx
  80120c:	75 dd                	jne    8011eb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120e:	a1 04 40 80 00       	mov    0x804004,%eax
  801213:	8b 40 48             	mov    0x48(%eax),%eax
  801216:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80121a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121e:	c7 04 24 a0 25 80 00 	movl   $0x8025a0,(%esp)
  801225:	e8 a9 ef ff ff       	call   8001d3 <cprintf>
	*dev = 0;
  80122a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801235:	83 c4 14             	add    $0x14,%esp
  801238:	5b                   	pop    %ebx
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 38             	sub    $0x38,%esp
  801241:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801244:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801247:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80124a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80124d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801251:	89 3c 24             	mov    %edi,(%esp)
  801254:	e8 87 fe ff ff       	call   8010e0 <fd2num>
  801259:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80125c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801260:	89 04 24             	mov    %eax,(%esp)
  801263:	e8 16 ff ff ff       	call   80117e <fd_lookup>
  801268:	89 c3                	mov    %eax,%ebx
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 05                	js     801273 <fd_close+0x38>
	    || fd != fd2)
  80126e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801271:	74 0e                	je     801281 <fd_close+0x46>
		return (must_exist ? r : 0);
  801273:	89 f0                	mov    %esi,%eax
  801275:	84 c0                	test   %al,%al
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
  80127c:	0f 44 d8             	cmove  %eax,%ebx
  80127f:	eb 3d                	jmp    8012be <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801281:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	8b 07                	mov    (%edi),%eax
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	e8 3d ff ff ff       	call   8011cf <dev_lookup>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	85 c0                	test   %eax,%eax
  801296:	78 16                	js     8012ae <fd_close+0x73>
		if (dev->dev_close)
  801298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	74 07                	je     8012ae <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8012a7:	89 3c 24             	mov    %edi,(%esp)
  8012aa:	ff d0                	call   *%eax
  8012ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b9:	e8 eb fa ff ff       	call   800da9 <sys_page_unmap>
	return r;
}
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c9:	89 ec                	mov    %ebp,%esp
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	89 04 24             	mov    %eax,(%esp)
  8012e0:	e8 99 fe ff ff       	call   80117e <fd_lookup>
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 13                	js     8012fc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8012e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012f0:	00 
  8012f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f4:	89 04 24             	mov    %eax,(%esp)
  8012f7:	e8 3f ff ff ff       	call   80123b <fd_close>
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <close_all>:

void
close_all(void)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	53                   	push   %ebx
  801302:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801305:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80130a:	89 1c 24             	mov    %ebx,(%esp)
  80130d:	e8 bb ff ff ff       	call   8012cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801312:	83 c3 01             	add    $0x1,%ebx
  801315:	83 fb 20             	cmp    $0x20,%ebx
  801318:	75 f0                	jne    80130a <close_all+0xc>
		close(i);
}
  80131a:	83 c4 14             	add    $0x14,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    

00801320 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 58             	sub    $0x58,%esp
  801326:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801329:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80132c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80132f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801332:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801335:	89 44 24 04          	mov    %eax,0x4(%esp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	89 04 24             	mov    %eax,(%esp)
  80133f:	e8 3a fe ff ff       	call   80117e <fd_lookup>
  801344:	89 c3                	mov    %eax,%ebx
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 88 e1 00 00 00    	js     80142f <dup+0x10f>
		return r;
	close(newfdnum);
  80134e:	89 3c 24             	mov    %edi,(%esp)
  801351:	e8 77 ff ff ff       	call   8012cd <close>

	newfd = INDEX2FD(newfdnum);
  801356:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80135c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80135f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	e8 86 fd ff ff       	call   8010f0 <fd2data>
  80136a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80136c:	89 34 24             	mov    %esi,(%esp)
  80136f:	e8 7c fd ff ff       	call   8010f0 <fd2data>
  801374:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801377:	89 d8                	mov    %ebx,%eax
  801379:	c1 e8 16             	shr    $0x16,%eax
  80137c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801383:	a8 01                	test   $0x1,%al
  801385:	74 46                	je     8013cd <dup+0xad>
  801387:	89 d8                	mov    %ebx,%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
  80138c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801393:	f6 c2 01             	test   $0x1,%dl
  801396:	74 35                	je     8013cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801398:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139f:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b6:	00 
  8013b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c2:	e8 84 f9 ff ff       	call   800d4b <sys_page_map>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 3b                	js     801408 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 0c             	shr    $0xc,%edx
  8013d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013dc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f1:	00 
  8013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fd:	e8 49 f9 ff ff       	call   800d4b <sys_page_map>
  801402:	89 c3                	mov    %eax,%ebx
  801404:	85 c0                	test   %eax,%eax
  801406:	79 25                	jns    80142d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801408:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801413:	e8 91 f9 ff ff       	call   800da9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80141b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801426:	e8 7e f9 ff ff       	call   800da9 <sys_page_unmap>
	return r;
  80142b:	eb 02                	jmp    80142f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80142d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142f:	89 d8                	mov    %ebx,%eax
  801431:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801434:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801437:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80143a:	89 ec                	mov    %ebp,%esp
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	53                   	push   %ebx
  801442:	83 ec 24             	sub    $0x24,%esp
  801445:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801448:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144f:	89 1c 24             	mov    %ebx,(%esp)
  801452:	e8 27 fd ff ff       	call   80117e <fd_lookup>
  801457:	85 c0                	test   %eax,%eax
  801459:	78 6d                	js     8014c8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	89 04 24             	mov    %eax,(%esp)
  80146a:	e8 60 fd ff ff       	call   8011cf <dev_lookup>
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 55                	js     8014c8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	8b 50 08             	mov    0x8(%eax),%edx
  801479:	83 e2 03             	and    $0x3,%edx
  80147c:	83 fa 01             	cmp    $0x1,%edx
  80147f:	75 23                	jne    8014a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801481:	a1 04 40 80 00       	mov    0x804004,%eax
  801486:	8b 40 48             	mov    0x48(%eax),%eax
  801489:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	c7 04 24 e1 25 80 00 	movl   $0x8025e1,(%esp)
  801498:	e8 36 ed ff ff       	call   8001d3 <cprintf>
		return -E_INVAL;
  80149d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a2:	eb 24                	jmp    8014c8 <read+0x8a>
	}
	if (!dev->dev_read)
  8014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a7:	8b 52 08             	mov    0x8(%edx),%edx
  8014aa:	85 d2                	test   %edx,%edx
  8014ac:	74 15                	je     8014c3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014bc:	89 04 24             	mov    %eax,(%esp)
  8014bf:	ff d2                	call   *%edx
  8014c1:	eb 05                	jmp    8014c8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014c8:	83 c4 24             	add    $0x24,%esp
  8014cb:	5b                   	pop    %ebx
  8014cc:	5d                   	pop    %ebp
  8014cd:	c3                   	ret    

008014ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	57                   	push   %edi
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 1c             	sub    $0x1c,%esp
  8014d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	85 f6                	test   %esi,%esi
  8014e4:	74 30                	je     801516 <readn+0x48>
  8014e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014eb:	89 f2                	mov    %esi,%edx
  8014ed:	29 c2                	sub    %eax,%edx
  8014ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014f3:	03 45 0c             	add    0xc(%ebp),%eax
  8014f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fa:	89 3c 24             	mov    %edi,(%esp)
  8014fd:	e8 3c ff ff ff       	call   80143e <read>
		if (m < 0)
  801502:	85 c0                	test   %eax,%eax
  801504:	78 10                	js     801516 <readn+0x48>
			return m;
		if (m == 0)
  801506:	85 c0                	test   %eax,%eax
  801508:	74 0a                	je     801514 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150a:	01 c3                	add    %eax,%ebx
  80150c:	89 d8                	mov    %ebx,%eax
  80150e:	39 f3                	cmp    %esi,%ebx
  801510:	72 d9                	jb     8014eb <readn+0x1d>
  801512:	eb 02                	jmp    801516 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801514:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801516:	83 c4 1c             	add    $0x1c,%esp
  801519:	5b                   	pop    %ebx
  80151a:	5e                   	pop    %esi
  80151b:	5f                   	pop    %edi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 24             	sub    $0x24,%esp
  801525:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801528:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152f:	89 1c 24             	mov    %ebx,(%esp)
  801532:	e8 47 fc ff ff       	call   80117e <fd_lookup>
  801537:	85 c0                	test   %eax,%eax
  801539:	78 68                	js     8015a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 80 fc ff ff       	call   8011cf <dev_lookup>
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 50                	js     8015a3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155a:	75 23                	jne    80157f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80155c:	a1 04 40 80 00       	mov    0x804004,%eax
  801561:	8b 40 48             	mov    0x48(%eax),%eax
  801564:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156c:	c7 04 24 fd 25 80 00 	movl   $0x8025fd,(%esp)
  801573:	e8 5b ec ff ff       	call   8001d3 <cprintf>
		return -E_INVAL;
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb 24                	jmp    8015a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	8b 52 0c             	mov    0xc(%edx),%edx
  801585:	85 d2                	test   %edx,%edx
  801587:	74 15                	je     80159e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801589:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801590:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801593:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801597:	89 04 24             	mov    %eax,(%esp)
  80159a:	ff d2                	call   *%edx
  80159c:	eb 05                	jmp    8015a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80159e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015a3:	83 c4 24             	add    $0x24,%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 04 24             	mov    %eax,(%esp)
  8015bc:	e8 bd fb ff ff       	call   80117e <fd_lookup>
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 0e                	js     8015d3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 24             	sub    $0x24,%esp
  8015dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e6:	89 1c 24             	mov    %ebx,(%esp)
  8015e9:	e8 90 fb ff ff       	call   80117e <fd_lookup>
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 61                	js     801653 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 c9 fb ff ff       	call   8011cf <dev_lookup>
  801606:	85 c0                	test   %eax,%eax
  801608:	78 49                	js     801653 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801611:	75 23                	jne    801636 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801613:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801618:	8b 40 48             	mov    0x48(%eax),%eax
  80161b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80161f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801623:	c7 04 24 c0 25 80 00 	movl   $0x8025c0,(%esp)
  80162a:	e8 a4 eb ff ff       	call   8001d3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80162f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801634:	eb 1d                	jmp    801653 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801639:	8b 52 18             	mov    0x18(%edx),%edx
  80163c:	85 d2                	test   %edx,%edx
  80163e:	74 0e                	je     80164e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	ff d2                	call   *%edx
  80164c:	eb 05                	jmp    801653 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80164e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801653:	83 c4 24             	add    $0x24,%esp
  801656:	5b                   	pop    %ebx
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
  80165d:	83 ec 24             	sub    $0x24,%esp
  801660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	89 04 24             	mov    %eax,(%esp)
  801670:	e8 09 fb ff ff       	call   80117e <fd_lookup>
  801675:	85 c0                	test   %eax,%eax
  801677:	78 52                	js     8016cb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 42 fb ff ff       	call   8011cf <dev_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 3a                	js     8016cb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801698:	74 2c                	je     8016c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a4:	00 00 00 
	stat->st_isdir = 0;
  8016a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ae:	00 00 00 
	stat->st_dev = dev;
  8016b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016be:	89 14 24             	mov    %edx,(%esp)
  8016c1:	ff 50 14             	call   *0x14(%eax)
  8016c4:	eb 05                	jmp    8016cb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016cb:	83 c4 24             	add    $0x24,%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 18             	sub    $0x18,%esp
  8016d7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016da:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016e4:	00 
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	89 04 24             	mov    %eax,(%esp)
  8016eb:	e8 bc 01 00 00       	call   8018ac <open>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 1b                	js     801711 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fd:	89 1c 24             	mov    %ebx,(%esp)
  801700:	e8 54 ff ff ff       	call   801659 <fstat>
  801705:	89 c6                	mov    %eax,%esi
	close(fd);
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 be fb ff ff       	call   8012cd <close>
	return r;
  80170f:	89 f3                	mov    %esi,%ebx
}
  801711:	89 d8                	mov    %ebx,%eax
  801713:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801716:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801719:	89 ec                	mov    %ebp,%esp
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    
  80171d:	00 00                	add    %al,(%eax)
	...

00801720 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 18             	sub    $0x18,%esp
  801726:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801729:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801730:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801737:	75 11                	jne    80174a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801740:	e8 51 f9 ff ff       	call   801096 <ipc_find_env>
  801745:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801751:	00 
  801752:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801759:	00 
  80175a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80175e:	a1 00 40 80 00       	mov    0x804000,%eax
  801763:	89 04 24             	mov    %eax,(%esp)
  801766:	e8 a7 f8 ff ff       	call   801012 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80176b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801772:	00 
  801773:	89 74 24 04          	mov    %esi,0x4(%esp)
  801777:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177e:	e8 3d f8 ff ff       	call   800fc0 <ipc_recv>
}
  801783:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801786:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801789:	89 ec                	mov    %ebp,%esp
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	53                   	push   %ebx
  801791:	83 ec 14             	sub    $0x14,%esp
  801794:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ac:	e8 6f ff ff ff       	call   801720 <fsipc>
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 2b                	js     8017e0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017b5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017bc:	00 
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 26 f0 ff ff       	call   8007eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017c5:	a1 80 50 80 00       	mov    0x805080,%eax
  8017ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017d0:	a1 84 50 80 00       	mov    0x805084,%eax
  8017d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e0:	83 c4 14             	add    $0x14,%esp
  8017e3:	5b                   	pop    %ebx
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 06 00 00 00       	mov    $0x6,%eax
  801801:	e8 1a ff ff ff       	call   801720 <fsipc>
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 10             	sub    $0x10,%esp
  801810:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8b 40 0c             	mov    0xc(%eax),%eax
  801819:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80181e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801824:	ba 00 00 00 00       	mov    $0x0,%edx
  801829:	b8 03 00 00 00       	mov    $0x3,%eax
  80182e:	e8 ed fe ff ff       	call   801720 <fsipc>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	85 c0                	test   %eax,%eax
  801837:	78 6a                	js     8018a3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801839:	39 c6                	cmp    %eax,%esi
  80183b:	73 24                	jae    801861 <devfile_read+0x59>
  80183d:	c7 44 24 0c 2c 26 80 	movl   $0x80262c,0xc(%esp)
  801844:	00 
  801845:	c7 44 24 08 33 26 80 	movl   $0x802633,0x8(%esp)
  80184c:	00 
  80184d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801854:	00 
  801855:	c7 04 24 48 26 80 00 	movl   $0x802648,(%esp)
  80185c:	e8 6f 06 00 00       	call   801ed0 <_panic>
	assert(r <= PGSIZE);
  801861:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801866:	7e 24                	jle    80188c <devfile_read+0x84>
  801868:	c7 44 24 0c 53 26 80 	movl   $0x802653,0xc(%esp)
  80186f:	00 
  801870:	c7 44 24 08 33 26 80 	movl   $0x802633,0x8(%esp)
  801877:	00 
  801878:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80187f:	00 
  801880:	c7 04 24 48 26 80 00 	movl   $0x802648,(%esp)
  801887:	e8 44 06 00 00       	call   801ed0 <_panic>
	memmove(buf, &fsipcbuf, r);
  80188c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801890:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801897:	00 
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 39 f1 ff ff       	call   8009dc <memmove>
	return r;
}
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 20             	sub    $0x20,%esp
  8018b4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018b7:	89 34 24             	mov    %esi,(%esp)
  8018ba:	e8 e1 ee ff ff       	call   8007a0 <strlen>
		return -E_BAD_PATH;
  8018bf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c9:	7f 5e                	jg     801929 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 35 f8 ff ff       	call   80110b <fd_alloc>
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 4d                	js     801929 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018e7:	e8 ff ee ff ff       	call   8007eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ef:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fc:	e8 1f fe ff ff       	call   801720 <fsipc>
  801901:	89 c3                	mov    %eax,%ebx
  801903:	85 c0                	test   %eax,%eax
  801905:	79 15                	jns    80191c <open+0x70>
		fd_close(fd, 0);
  801907:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190e:	00 
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 21 f9 ff ff       	call   80123b <fd_close>
		return r;
  80191a:	eb 0d                	jmp    801929 <open+0x7d>
	}

	return fd2num(fd);
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 b9 f7 ff ff       	call   8010e0 <fd2num>
  801927:	89 c3                	mov    %eax,%ebx
}
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	83 c4 20             	add    $0x20,%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    
	...

00801940 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 18             	sub    $0x18,%esp
  801946:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801949:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80194c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	e8 96 f7 ff ff       	call   8010f0 <fd2data>
  80195a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80195c:	c7 44 24 04 5f 26 80 	movl   $0x80265f,0x4(%esp)
  801963:	00 
  801964:	89 34 24             	mov    %esi,(%esp)
  801967:	e8 7f ee ff ff       	call   8007eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80196c:	8b 43 04             	mov    0x4(%ebx),%eax
  80196f:	2b 03                	sub    (%ebx),%eax
  801971:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801977:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80197e:	00 00 00 
	stat->st_dev = &devpipe;
  801981:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801988:	30 80 00 
	return 0;
}
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801993:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801996:	89 ec                	mov    %ebp,%esp
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 14             	sub    $0x14,%esp
  8019a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019af:	e8 f5 f3 ff ff       	call   800da9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019b4:	89 1c 24             	mov    %ebx,(%esp)
  8019b7:	e8 34 f7 ff ff       	call   8010f0 <fd2data>
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c7:	e8 dd f3 ff ff       	call   800da9 <sys_page_unmap>
}
  8019cc:	83 c4 14             	add    $0x14,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 2c             	sub    $0x2c,%esp
  8019db:	89 c7                	mov    %eax,%edi
  8019dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019e8:	89 3c 24             	mov    %edi,(%esp)
  8019eb:	e8 38 05 00 00       	call   801f28 <pageref>
  8019f0:	89 c6                	mov    %eax,%esi
  8019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f5:	89 04 24             	mov    %eax,(%esp)
  8019f8:	e8 2b 05 00 00       	call   801f28 <pageref>
  8019fd:	39 c6                	cmp    %eax,%esi
  8019ff:	0f 94 c0             	sete   %al
  801a02:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801a05:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a0b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a0e:	39 cb                	cmp    %ecx,%ebx
  801a10:	75 08                	jne    801a1a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801a12:	83 c4 2c             	add    $0x2c,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801a1a:	83 f8 01             	cmp    $0x1,%eax
  801a1d:	75 c1                	jne    8019e0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a1f:	8b 52 58             	mov    0x58(%edx),%edx
  801a22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a2e:	c7 04 24 66 26 80 00 	movl   $0x802666,(%esp)
  801a35:	e8 99 e7 ff ff       	call   8001d3 <cprintf>
  801a3a:	eb a4                	jmp    8019e0 <_pipeisclosed+0xe>

00801a3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	57                   	push   %edi
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 2c             	sub    $0x2c,%esp
  801a45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a48:	89 34 24             	mov    %esi,(%esp)
  801a4b:	e8 a0 f6 ff ff       	call   8010f0 <fd2data>
  801a50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a52:	bf 00 00 00 00       	mov    $0x0,%edi
  801a57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5b:	75 50                	jne    801aad <devpipe_write+0x71>
  801a5d:	eb 5c                	jmp    801abb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a5f:	89 da                	mov    %ebx,%edx
  801a61:	89 f0                	mov    %esi,%eax
  801a63:	e8 6a ff ff ff       	call   8019d2 <_pipeisclosed>
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	75 53                	jne    801abf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a6c:	e8 4b f2 ff ff       	call   800cbc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a71:	8b 43 04             	mov    0x4(%ebx),%eax
  801a74:	8b 13                	mov    (%ebx),%edx
  801a76:	83 c2 20             	add    $0x20,%edx
  801a79:	39 d0                	cmp    %edx,%eax
  801a7b:	73 e2                	jae    801a5f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801a84:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801a87:	89 c2                	mov    %eax,%edx
  801a89:	c1 fa 1f             	sar    $0x1f,%edx
  801a8c:	c1 ea 1b             	shr    $0x1b,%edx
  801a8f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a92:	83 e1 1f             	and    $0x1f,%ecx
  801a95:	29 d1                	sub    %edx,%ecx
  801a97:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a9b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a9f:	83 c0 01             	add    $0x1,%eax
  801aa2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801aa5:	83 c7 01             	add    $0x1,%edi
  801aa8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801aab:	74 0e                	je     801abb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aad:	8b 43 04             	mov    0x4(%ebx),%eax
  801ab0:	8b 13                	mov    (%ebx),%edx
  801ab2:	83 c2 20             	add    $0x20,%edx
  801ab5:	39 d0                	cmp    %edx,%eax
  801ab7:	73 a6                	jae    801a5f <devpipe_write+0x23>
  801ab9:	eb c2                	jmp    801a7d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801abb:	89 f8                	mov    %edi,%eax
  801abd:	eb 05                	jmp    801ac4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ac4:	83 c4 2c             	add    $0x2c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 28             	sub    $0x28,%esp
  801ad2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ad5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ad8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801adb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ade:	89 3c 24             	mov    %edi,(%esp)
  801ae1:	e8 0a f6 ff ff       	call   8010f0 <fd2data>
  801ae6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ae8:	be 00 00 00 00       	mov    $0x0,%esi
  801aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801af1:	75 47                	jne    801b3a <devpipe_read+0x6e>
  801af3:	eb 52                	jmp    801b47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801af5:	89 f0                	mov    %esi,%eax
  801af7:	eb 5e                	jmp    801b57 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801af9:	89 da                	mov    %ebx,%edx
  801afb:	89 f8                	mov    %edi,%eax
  801afd:	8d 76 00             	lea    0x0(%esi),%esi
  801b00:	e8 cd fe ff ff       	call   8019d2 <_pipeisclosed>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	75 49                	jne    801b52 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b09:	e8 ae f1 ff ff       	call   800cbc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b0e:	8b 03                	mov    (%ebx),%eax
  801b10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b13:	74 e4                	je     801af9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b15:	89 c2                	mov    %eax,%edx
  801b17:	c1 fa 1f             	sar    $0x1f,%edx
  801b1a:	c1 ea 1b             	shr    $0x1b,%edx
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	83 e0 1f             	and    $0x1f,%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801b2f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b32:	83 c6 01             	add    $0x1,%esi
  801b35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b38:	74 0d                	je     801b47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801b3a:	8b 03                	mov    (%ebx),%eax
  801b3c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b3f:	75 d4                	jne    801b15 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b41:	85 f6                	test   %esi,%esi
  801b43:	75 b0                	jne    801af5 <devpipe_read+0x29>
  801b45:	eb b2                	jmp    801af9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b47:	89 f0                	mov    %esi,%eax
  801b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b50:	eb 05                	jmp    801b57 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b60:	89 ec                	mov    %ebp,%esp
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 48             	sub    $0x48,%esp
  801b6a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b6d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b70:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b73:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b79:	89 04 24             	mov    %eax,(%esp)
  801b7c:	e8 8a f5 ff ff       	call   80110b <fd_alloc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	0f 88 45 01 00 00    	js     801cd0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b92:	00 
  801b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba1:	e8 46 f1 ff ff       	call   800cec <sys_page_alloc>
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 88 20 01 00 00    	js     801cd0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801bb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 50 f5 ff ff       	call   80110b <fd_alloc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	0f 88 f8 00 00 00    	js     801cbd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bcc:	00 
  801bcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdb:	e8 0c f1 ff ff       	call   800cec <sys_page_alloc>
  801be0:	89 c3                	mov    %eax,%ebx
  801be2:	85 c0                	test   %eax,%eax
  801be4:	0f 88 d3 00 00 00    	js     801cbd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bed:	89 04 24             	mov    %eax,(%esp)
  801bf0:	e8 fb f4 ff ff       	call   8010f0 <fd2data>
  801bf5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bfe:	00 
  801bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0a:	e8 dd f0 ff ff       	call   800cec <sys_page_alloc>
  801c0f:	89 c3                	mov    %eax,%ebx
  801c11:	85 c0                	test   %eax,%eax
  801c13:	0f 88 91 00 00 00    	js     801caa <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 cc f4 ff ff       	call   8010f0 <fd2data>
  801c24:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801c2b:	00 
  801c2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c37:	00 
  801c38:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c43:	e8 03 f1 ff ff       	call   800d4b <sys_page_map>
  801c48:	89 c3                	mov    %eax,%ebx
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 4c                	js     801c9a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c57:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c71:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 5d f4 ff ff       	call   8010e0 <fd2num>
  801c83:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c88:	89 04 24             	mov    %eax,(%esp)
  801c8b:	e8 50 f4 ff ff       	call   8010e0 <fd2num>
  801c90:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c98:	eb 36                	jmp    801cd0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801c9a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca5:	e8 ff f0 ff ff       	call   800da9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb8:	e8 ec f0 ff ff       	call   800da9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccb:	e8 d9 f0 ff ff       	call   800da9 <sys_page_unmap>
    err:
	return r;
}
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cdb:	89 ec                	mov    %ebp,%esp
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 87 f4 ff ff       	call   80117e <fd_lookup>
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 15                	js     801d10 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 ea f3 ff ff       	call   8010f0 <fd2data>
	return _pipeisclosed(fd, p);
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0b:	e8 c2 fc ff ff       	call   8019d2 <_pipeisclosed>
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    
	...

00801d20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801d30:	c7 44 24 04 7e 26 80 	movl   $0x80267e,0x4(%esp)
  801d37:	00 
  801d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 a8 ea ff ff       	call   8007eb <strcpy>
	return 0;
}
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	57                   	push   %edi
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d56:	be 00 00 00 00       	mov    $0x0,%esi
  801d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d5f:	74 43                	je     801da4 <devcons_write+0x5a>
  801d61:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d66:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801d71:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d74:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d79:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d80:	03 45 0c             	add    0xc(%ebp),%eax
  801d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d87:	89 3c 24             	mov    %edi,(%esp)
  801d8a:	e8 4d ec ff ff       	call   8009dc <memmove>
		sys_cputs(buf, m);
  801d8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d93:	89 3c 24             	mov    %edi,(%esp)
  801d96:	e8 35 ee ff ff       	call   800bd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d9b:	01 de                	add    %ebx,%esi
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da2:	72 c8                	jb     801d6c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801da4:	89 f0                	mov    %esi,%eax
  801da6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dc0:	75 07                	jne    801dc9 <devcons_read+0x18>
  801dc2:	eb 31                	jmp    801df5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801dc4:	e8 f3 ee ff ff       	call   800cbc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	e8 2a ee ff ff       	call   800bff <sys_cgetc>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 eb                	je     801dc4 <devcons_read+0x13>
  801dd9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	78 16                	js     801df5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ddf:	83 f8 04             	cmp    $0x4,%eax
  801de2:	74 0c                	je     801df0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de7:	88 10                	mov    %dl,(%eax)
	return 1;
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dee:	eb 05                	jmp    801df5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e0a:	00 
  801e0b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 ba ed ff ff       	call   800bd0 <sys_cputs>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <getchar>:

int
getchar(void)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e1e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e25:	00 
  801e26:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e34:	e8 05 f6 ff ff       	call   80143e <read>
	if (r < 0)
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	78 0f                	js     801e4c <getchar+0x34>
		return r;
	if (r < 1)
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	7e 06                	jle    801e47 <getchar+0x2f>
		return -E_EOF;
	return c;
  801e41:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e45:	eb 05                	jmp    801e4c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e47:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	e8 18 f3 ff ff       	call   80117e <fd_lookup>
  801e66:	85 c0                	test   %eax,%eax
  801e68:	78 11                	js     801e7b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e73:	39 10                	cmp    %edx,(%eax)
  801e75:	0f 94 c0             	sete   %al
  801e78:	0f b6 c0             	movzbl %al,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <opencons>:

int
opencons(void)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 7d f2 ff ff       	call   80110b <fd_alloc>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 3c                	js     801ece <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e99:	00 
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea8:	e8 3f ee ff ff       	call   800cec <sys_page_alloc>
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 1d                	js     801ece <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801eb1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 12 f2 ff ff       	call   8010e0 <fd2num>
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801ed8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801edb:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801ee1:	e8 a6 ed ff ff       	call   800c8c <sys_getenvid>
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	89 54 24 10          	mov    %edx,0x10(%esp)
  801eed:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ef4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efc:	c7 04 24 8c 26 80 00 	movl   $0x80268c,(%esp)
  801f03:	e8 cb e2 ff ff       	call   8001d3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f08:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	89 04 24             	mov    %eax,(%esp)
  801f12:	e8 5b e2 ff ff       	call   800172 <vcprintf>
	cprintf("\n");
  801f17:	c7 04 24 77 26 80 00 	movl   $0x802677,(%esp)
  801f1e:	e8 b0 e2 ff ff       	call   8001d3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f23:	cc                   	int3   
  801f24:	eb fd                	jmp    801f23 <_panic+0x53>
	...

00801f28 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f2e:	89 d0                	mov    %edx,%eax
  801f30:	c1 e8 16             	shr    $0x16,%eax
  801f33:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f3f:	f6 c1 01             	test   $0x1,%cl
  801f42:	74 1d                	je     801f61 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f44:	c1 ea 0c             	shr    $0xc,%edx
  801f47:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f4e:	f6 c2 01             	test   $0x1,%dl
  801f51:	74 0e                	je     801f61 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f53:	c1 ea 0c             	shr    $0xc,%edx
  801f56:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f5d:	ef 
  801f5e:	0f b7 c0             	movzwl %ax,%eax
}
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    
	...

00801f70 <__udivdi3>:
  801f70:	83 ec 1c             	sub    $0x1c,%esp
  801f73:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f77:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f7b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f7f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f83:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f87:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f8b:	85 ff                	test   %edi,%edi
  801f8d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f91:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f95:	89 cd                	mov    %ecx,%ebp
  801f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9b:	75 33                	jne    801fd0 <__udivdi3+0x60>
  801f9d:	39 f1                	cmp    %esi,%ecx
  801f9f:	77 57                	ja     801ff8 <__udivdi3+0x88>
  801fa1:	85 c9                	test   %ecx,%ecx
  801fa3:	75 0b                	jne    801fb0 <__udivdi3+0x40>
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  801faa:	31 d2                	xor    %edx,%edx
  801fac:	f7 f1                	div    %ecx
  801fae:	89 c1                	mov    %eax,%ecx
  801fb0:	89 f0                	mov    %esi,%eax
  801fb2:	31 d2                	xor    %edx,%edx
  801fb4:	f7 f1                	div    %ecx
  801fb6:	89 c6                	mov    %eax,%esi
  801fb8:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fbc:	f7 f1                	div    %ecx
  801fbe:	89 f2                	mov    %esi,%edx
  801fc0:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fc4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fc8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801fcc:	83 c4 1c             	add    $0x1c,%esp
  801fcf:	c3                   	ret    
  801fd0:	31 d2                	xor    %edx,%edx
  801fd2:	31 c0                	xor    %eax,%eax
  801fd4:	39 f7                	cmp    %esi,%edi
  801fd6:	77 e8                	ja     801fc0 <__udivdi3+0x50>
  801fd8:	0f bd cf             	bsr    %edi,%ecx
  801fdb:	83 f1 1f             	xor    $0x1f,%ecx
  801fde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fe2:	75 2c                	jne    802010 <__udivdi3+0xa0>
  801fe4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801fe8:	76 04                	jbe    801fee <__udivdi3+0x7e>
  801fea:	39 f7                	cmp    %esi,%edi
  801fec:	73 d2                	jae    801fc0 <__udivdi3+0x50>
  801fee:	31 d2                	xor    %edx,%edx
  801ff0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff5:	eb c9                	jmp    801fc0 <__udivdi3+0x50>
  801ff7:	90                   	nop
  801ff8:	89 f2                	mov    %esi,%edx
  801ffa:	f7 f1                	div    %ecx
  801ffc:	31 d2                	xor    %edx,%edx
  801ffe:	8b 74 24 10          	mov    0x10(%esp),%esi
  802002:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802006:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80200a:	83 c4 1c             	add    $0x1c,%esp
  80200d:	c3                   	ret    
  80200e:	66 90                	xchg   %ax,%ax
  802010:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802015:	b8 20 00 00 00       	mov    $0x20,%eax
  80201a:	89 ea                	mov    %ebp,%edx
  80201c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802020:	d3 e7                	shl    %cl,%edi
  802022:	89 c1                	mov    %eax,%ecx
  802024:	d3 ea                	shr    %cl,%edx
  802026:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80202b:	09 fa                	or     %edi,%edx
  80202d:	89 f7                	mov    %esi,%edi
  80202f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802033:	89 f2                	mov    %esi,%edx
  802035:	8b 74 24 08          	mov    0x8(%esp),%esi
  802039:	d3 e5                	shl    %cl,%ebp
  80203b:	89 c1                	mov    %eax,%ecx
  80203d:	d3 ef                	shr    %cl,%edi
  80203f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802044:	d3 e2                	shl    %cl,%edx
  802046:	89 c1                	mov    %eax,%ecx
  802048:	d3 ee                	shr    %cl,%esi
  80204a:	09 d6                	or     %edx,%esi
  80204c:	89 fa                	mov    %edi,%edx
  80204e:	89 f0                	mov    %esi,%eax
  802050:	f7 74 24 0c          	divl   0xc(%esp)
  802054:	89 d7                	mov    %edx,%edi
  802056:	89 c6                	mov    %eax,%esi
  802058:	f7 e5                	mul    %ebp
  80205a:	39 d7                	cmp    %edx,%edi
  80205c:	72 22                	jb     802080 <__udivdi3+0x110>
  80205e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802062:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802067:	d3 e5                	shl    %cl,%ebp
  802069:	39 c5                	cmp    %eax,%ebp
  80206b:	73 04                	jae    802071 <__udivdi3+0x101>
  80206d:	39 d7                	cmp    %edx,%edi
  80206f:	74 0f                	je     802080 <__udivdi3+0x110>
  802071:	89 f0                	mov    %esi,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	e9 46 ff ff ff       	jmp    801fc0 <__udivdi3+0x50>
  80207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802080:	8d 46 ff             	lea    -0x1(%esi),%eax
  802083:	31 d2                	xor    %edx,%edx
  802085:	8b 74 24 10          	mov    0x10(%esp),%esi
  802089:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80208d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802091:	83 c4 1c             	add    $0x1c,%esp
  802094:	c3                   	ret    
	...

008020a0 <__umoddi3>:
  8020a0:	83 ec 1c             	sub    $0x1c,%esp
  8020a3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8020a7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8020ab:	8b 44 24 20          	mov    0x20(%esp),%eax
  8020af:	89 74 24 10          	mov    %esi,0x10(%esp)
  8020b3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8020b7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8020bb:	85 ed                	test   %ebp,%ebp
  8020bd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8020c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c5:	89 cf                	mov    %ecx,%edi
  8020c7:	89 04 24             	mov    %eax,(%esp)
  8020ca:	89 f2                	mov    %esi,%edx
  8020cc:	75 1a                	jne    8020e8 <__umoddi3+0x48>
  8020ce:	39 f1                	cmp    %esi,%ecx
  8020d0:	76 4e                	jbe    802120 <__umoddi3+0x80>
  8020d2:	f7 f1                	div    %ecx
  8020d4:	89 d0                	mov    %edx,%eax
  8020d6:	31 d2                	xor    %edx,%edx
  8020d8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020dc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020e0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	c3                   	ret    
  8020e8:	39 f5                	cmp    %esi,%ebp
  8020ea:	77 54                	ja     802140 <__umoddi3+0xa0>
  8020ec:	0f bd c5             	bsr    %ebp,%eax
  8020ef:	83 f0 1f             	xor    $0x1f,%eax
  8020f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f6:	75 60                	jne    802158 <__umoddi3+0xb8>
  8020f8:	3b 0c 24             	cmp    (%esp),%ecx
  8020fb:	0f 87 07 01 00 00    	ja     802208 <__umoddi3+0x168>
  802101:	89 f2                	mov    %esi,%edx
  802103:	8b 34 24             	mov    (%esp),%esi
  802106:	29 ce                	sub    %ecx,%esi
  802108:	19 ea                	sbb    %ebp,%edx
  80210a:	89 34 24             	mov    %esi,(%esp)
  80210d:	8b 04 24             	mov    (%esp),%eax
  802110:	8b 74 24 10          	mov    0x10(%esp),%esi
  802114:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802118:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80211c:	83 c4 1c             	add    $0x1c,%esp
  80211f:	c3                   	ret    
  802120:	85 c9                	test   %ecx,%ecx
  802122:	75 0b                	jne    80212f <__umoddi3+0x8f>
  802124:	b8 01 00 00 00       	mov    $0x1,%eax
  802129:	31 d2                	xor    %edx,%edx
  80212b:	f7 f1                	div    %ecx
  80212d:	89 c1                	mov    %eax,%ecx
  80212f:	89 f0                	mov    %esi,%eax
  802131:	31 d2                	xor    %edx,%edx
  802133:	f7 f1                	div    %ecx
  802135:	8b 04 24             	mov    (%esp),%eax
  802138:	f7 f1                	div    %ecx
  80213a:	eb 98                	jmp    8020d4 <__umoddi3+0x34>
  80213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 f2                	mov    %esi,%edx
  802142:	8b 74 24 10          	mov    0x10(%esp),%esi
  802146:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80214a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80215d:	89 e8                	mov    %ebp,%eax
  80215f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802164:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802168:	89 fa                	mov    %edi,%edx
  80216a:	d3 e0                	shl    %cl,%eax
  80216c:	89 e9                	mov    %ebp,%ecx
  80216e:	d3 ea                	shr    %cl,%edx
  802170:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802175:	09 c2                	or     %eax,%edx
  802177:	8b 44 24 08          	mov    0x8(%esp),%eax
  80217b:	89 14 24             	mov    %edx,(%esp)
  80217e:	89 f2                	mov    %esi,%edx
  802180:	d3 e7                	shl    %cl,%edi
  802182:	89 e9                	mov    %ebp,%ecx
  802184:	d3 ea                	shr    %cl,%edx
  802186:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80218b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80218f:	d3 e6                	shl    %cl,%esi
  802191:	89 e9                	mov    %ebp,%ecx
  802193:	d3 e8                	shr    %cl,%eax
  802195:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80219a:	09 f0                	or     %esi,%eax
  80219c:	8b 74 24 08          	mov    0x8(%esp),%esi
  8021a0:	f7 34 24             	divl   (%esp)
  8021a3:	d3 e6                	shl    %cl,%esi
  8021a5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021a9:	89 d6                	mov    %edx,%esi
  8021ab:	f7 e7                	mul    %edi
  8021ad:	39 d6                	cmp    %edx,%esi
  8021af:	89 c1                	mov    %eax,%ecx
  8021b1:	89 d7                	mov    %edx,%edi
  8021b3:	72 3f                	jb     8021f4 <__umoddi3+0x154>
  8021b5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8021b9:	72 35                	jb     8021f0 <__umoddi3+0x150>
  8021bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021bf:	29 c8                	sub    %ecx,%eax
  8021c1:	19 fe                	sbb    %edi,%esi
  8021c3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021c8:	89 f2                	mov    %esi,%edx
  8021ca:	d3 e8                	shr    %cl,%eax
  8021cc:	89 e9                	mov    %ebp,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021d5:	09 d0                	or     %edx,%eax
  8021d7:	89 f2                	mov    %esi,%edx
  8021d9:	d3 ea                	shr    %cl,%edx
  8021db:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021df:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021e3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021e7:	83 c4 1c             	add    $0x1c,%esp
  8021ea:	c3                   	ret    
  8021eb:	90                   	nop
  8021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	39 d6                	cmp    %edx,%esi
  8021f2:	75 c7                	jne    8021bb <__umoddi3+0x11b>
  8021f4:	89 d7                	mov    %edx,%edi
  8021f6:	89 c1                	mov    %eax,%ecx
  8021f8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8021fc:	1b 3c 24             	sbb    (%esp),%edi
  8021ff:	eb ba                	jmp    8021bb <__umoddi3+0x11b>
  802201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802208:	39 f5                	cmp    %esi,%ebp
  80220a:	0f 82 f1 fe ff ff    	jb     802101 <__umoddi3+0x61>
  802210:	e9 f8 fe ff ff       	jmp    80210d <__umoddi3+0x6d>
