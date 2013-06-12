
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ef 00 00 00       	call   800120 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  80003a:	c7 04 24 80 22 80 00 	movl   $0x802280,(%esp)
  800041:	e8 41 02 00 00       	call   800287 <cprintf>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
  800046:	83 3d 20 40 80 00 00 	cmpl   $0x0,0x804020
  80004d:	75 11                	jne    800060 <umain+0x2c>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  80004f:	b8 01 00 00 00       	mov    $0x1,%eax
		if (bigarray[i] != 0)
  800054:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  80005b:	00 
  80005c:	74 27                	je     800085 <umain+0x51>
  80005e:	eb 05                	jmp    800065 <umain+0x31>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
  800065:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800069:	c7 44 24 08 fb 22 80 	movl   $0x8022fb,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 18 23 80 00 	movl   $0x802318,(%esp)
  800080:	e8 07 01 00 00       	call   80018c <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800085:	83 c0 01             	add    $0x1,%eax
  800088:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008d:	75 c5                	jne    800054 <umain+0x20>
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800094:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80009b:	83 c0 01             	add    $0x1,%eax
  80009e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000a3:	75 ef                	jne    800094 <umain+0x60>
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  8000a5:	83 3d 20 40 80 00 00 	cmpl   $0x0,0x804020
  8000ac:	75 10                	jne    8000be <umain+0x8a>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
		if (bigarray[i] != i)
  8000b3:	3b 04 85 20 40 80 00 	cmp    0x804020(,%eax,4),%eax
  8000ba:	74 27                	je     8000e3 <umain+0xaf>
  8000bc:	eb 05                	jmp    8000c3 <umain+0x8f>
  8000be:	b8 00 00 00 00       	mov    $0x0,%eax
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c7:	c7 44 24 08 a0 22 80 	movl   $0x8022a0,0x8(%esp)
  8000ce:	00 
  8000cf:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  8000d6:	00 
  8000d7:	c7 04 24 18 23 80 00 	movl   $0x802318,(%esp)
  8000de:	e8 a9 00 00 00       	call   80018c <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000e3:	83 c0 01             	add    $0x1,%eax
  8000e6:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000eb:	75 c6                	jne    8000b3 <umain+0x7f>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000ed:	c7 04 24 c8 22 80 00 	movl   $0x8022c8,(%esp)
  8000f4:	e8 8e 01 00 00       	call   800287 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000f9:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  800100:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800103:	c7 44 24 08 27 23 80 	movl   $0x802327,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 18 23 80 00 	movl   $0x802318,(%esp)
  80011a:	e8 6d 00 00 00       	call   80018c <_panic>
	...

00800120 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 18             	sub    $0x18,%esp
  800126:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800129:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80012c:	8b 75 08             	mov    0x8(%ebp),%esi
  80012f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800132:	e8 15 0c 00 00       	call   800d4c <sys_getenvid>
  800137:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80013f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800144:	a3 20 40 c0 00       	mov    %eax,0xc04020
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800149:	85 f6                	test   %esi,%esi
  80014b:	7e 07                	jle    800154 <libmain+0x34>
		binaryname = argv[0];
  80014d:	8b 03                	mov    (%ebx),%eax
  80014f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800154:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800158:	89 34 24             	mov    %esi,(%esp)
  80015b:	e8 d4 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800160:	e8 0b 00 00 00       	call   800170 <exit>
}
  800165:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800168:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80016b:	89 ec                	mov    %ebp,%esp
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    
	...

00800170 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800176:	e8 23 11 00 00       	call   80129e <close_all>
	sys_env_destroy(0);
  80017b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800182:	e8 68 0b 00 00       	call   800cef <sys_env_destroy>
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    
  800189:	00 00                	add    %al,(%eax)
	...

0080018c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
  800191:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  80019d:	e8 aa 0b 00 00       	call   800d4c <sys_getenvid>
  8001a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b8:	c7 04 24 48 23 80 00 	movl   $0x802348,(%esp)
  8001bf:	e8 c3 00 00 00       	call   800287 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cb:	89 04 24             	mov    %eax,(%esp)
  8001ce:	e8 53 00 00 00       	call   800226 <vcprintf>
	cprintf("\n");
  8001d3:	c7 04 24 16 23 80 00 	movl   $0x802316,(%esp)
  8001da:	e8 a8 00 00 00       	call   800287 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001df:	cc                   	int3   
  8001e0:	eb fd                	jmp    8001df <_panic+0x53>
	...

008001e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	53                   	push   %ebx
  8001e8:	83 ec 14             	sub    $0x14,%esp
  8001eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ee:	8b 03                	mov    (%ebx),%eax
  8001f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f3:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001f7:	83 c0 01             	add    $0x1,%eax
  8001fa:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800201:	75 19                	jne    80021c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800203:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80020a:	00 
  80020b:	8d 43 08             	lea    0x8(%ebx),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 7a 0a 00 00       	call   800c90 <sys_cputs>
		b->idx = 0;
  800216:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80021c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800220:	83 c4 14             	add    $0x14,%esp
  800223:	5b                   	pop    %ebx
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    

00800226 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80022f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800236:	00 00 00 
	b.cnt = 0;
  800239:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800240:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800243:	8b 45 0c             	mov    0xc(%ebp),%eax
  800246:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80024a:	8b 45 08             	mov    0x8(%ebp),%eax
  80024d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800251:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	c7 04 24 e4 01 80 00 	movl   $0x8001e4,(%esp)
  800262:	e8 a3 01 00 00       	call   80040a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800267:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80026d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800271:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800277:	89 04 24             	mov    %eax,(%esp)
  80027a:	e8 11 0a 00 00       	call   800c90 <sys_cputs>

	return b.cnt;
}
  80027f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800290:	89 44 24 04          	mov    %eax,0x4(%esp)
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	89 04 24             	mov    %eax,(%esp)
  80029a:	e8 87 ff ff ff       	call   800226 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    
	...

008002b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 3c             	sub    $0x3c,%esp
  8002b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002bc:	89 d7                	mov    %edx,%edi
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002cd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002d8:	72 11                	jb     8002eb <printnum+0x3b>
  8002da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002dd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002e0:	76 09                	jbe    8002eb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e2:	83 eb 01             	sub    $0x1,%ebx
  8002e5:	85 db                	test   %ebx,%ebx
  8002e7:	7f 51                	jg     80033a <printnum+0x8a>
  8002e9:	eb 5e                	jmp    800349 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002eb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002ef:	83 eb 01             	sub    $0x1,%ebx
  8002f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002fd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800301:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800305:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80030c:	00 
  80030d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800310:	89 04 24             	mov    %eax,(%esp)
  800313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800316:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031a:	e8 b1 1c 00 00       	call   801fd0 <__udivdi3>
  80031f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800323:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800327:	89 04 24             	mov    %eax,(%esp)
  80032a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80032e:	89 fa                	mov    %edi,%edx
  800330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800333:	e8 78 ff ff ff       	call   8002b0 <printnum>
  800338:	eb 0f                	jmp    800349 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80033e:	89 34 24             	mov    %esi,(%esp)
  800341:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800344:	83 eb 01             	sub    $0x1,%ebx
  800347:	75 f1                	jne    80033a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800349:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800351:	8b 45 10             	mov    0x10(%ebp),%eax
  800354:	89 44 24 08          	mov    %eax,0x8(%esp)
  800358:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035f:	00 
  800360:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	e8 8e 1d 00 00       	call   802100 <__umoddi3>
  800372:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800376:	0f be 80 6b 23 80 00 	movsbl 0x80236b(%eax),%eax
  80037d:	89 04 24             	mov    %eax,(%esp)
  800380:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800383:	83 c4 3c             	add    $0x3c,%esp
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    

0080038b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038e:	83 fa 01             	cmp    $0x1,%edx
  800391:	7e 0e                	jle    8003a1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800393:	8b 10                	mov    (%eax),%edx
  800395:	8d 4a 08             	lea    0x8(%edx),%ecx
  800398:	89 08                	mov    %ecx,(%eax)
  80039a:	8b 02                	mov    (%edx),%eax
  80039c:	8b 52 04             	mov    0x4(%edx),%edx
  80039f:	eb 22                	jmp    8003c3 <getuint+0x38>
	else if (lflag)
  8003a1:	85 d2                	test   %edx,%edx
  8003a3:	74 10                	je     8003b5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003a5:	8b 10                	mov    (%eax),%edx
  8003a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003aa:	89 08                	mov    %ecx,(%eax)
  8003ac:	8b 02                	mov    (%edx),%eax
  8003ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b3:	eb 0e                	jmp    8003c3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ba:	89 08                	mov    %ecx,(%eax)
  8003bc:	8b 02                	mov    (%edx),%eax
  8003be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    

008003c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d4:	73 0a                	jae    8003e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d9:	88 0a                	mov    %cl,(%edx)
  8003db:	83 c2 01             	add    $0x1,%edx
  8003de:	89 10                	mov    %edx,(%eax)
}
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	89 04 24             	mov    %eax,(%esp)
  800403:	e8 02 00 00 00       	call   80040a <vprintfmt>
	va_end(ap);
}
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	57                   	push   %edi
  80040e:	56                   	push   %esi
  80040f:	53                   	push   %ebx
  800410:	83 ec 4c             	sub    $0x4c,%esp
  800413:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800416:	8b 75 10             	mov    0x10(%ebp),%esi
  800419:	eb 12                	jmp    80042d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80041b:	85 c0                	test   %eax,%eax
  80041d:	0f 84 a9 03 00 00    	je     8007cc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800423:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042d:	0f b6 06             	movzbl (%esi),%eax
  800430:	83 c6 01             	add    $0x1,%esi
  800433:	83 f8 25             	cmp    $0x25,%eax
  800436:	75 e3                	jne    80041b <vprintfmt+0x11>
  800438:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80043c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800443:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800448:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80044f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800454:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800457:	eb 2b                	jmp    800484 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80045c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800460:	eb 22                	jmp    800484 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800462:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800465:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800469:	eb 19                	jmp    800484 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80046e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800475:	eb 0d                	jmp    800484 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800477:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80047a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800484:	0f b6 06             	movzbl (%esi),%eax
  800487:	0f b6 d0             	movzbl %al,%edx
  80048a:	8d 7e 01             	lea    0x1(%esi),%edi
  80048d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800490:	83 e8 23             	sub    $0x23,%eax
  800493:	3c 55                	cmp    $0x55,%al
  800495:	0f 87 0b 03 00 00    	ja     8007a6 <vprintfmt+0x39c>
  80049b:	0f b6 c0             	movzbl %al,%eax
  80049e:	ff 24 85 a0 24 80 00 	jmp    *0x8024a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a5:	83 ea 30             	sub    $0x30,%edx
  8004a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8004ab:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004af:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8004b5:	83 fa 09             	cmp    $0x9,%edx
  8004b8:	77 4a                	ja     800504 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004bd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004c0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8004c3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8004c7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004ca:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004cd:	83 fa 09             	cmp    $0x9,%edx
  8004d0:	76 eb                	jbe    8004bd <vprintfmt+0xb3>
  8004d2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d5:	eb 2d                	jmp    800504 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e8:	eb 1a                	jmp    800504 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8004ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004f1:	79 91                	jns    800484 <vprintfmt+0x7a>
  8004f3:	e9 73 ff ff ff       	jmp    80046b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800502:	eb 80                	jmp    800484 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800508:	0f 89 76 ff ff ff    	jns    800484 <vprintfmt+0x7a>
  80050e:	e9 64 ff ff ff       	jmp    800477 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800513:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800516:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800519:	e9 66 ff ff ff       	jmp    800484 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 50 04             	lea    0x4(%eax),%edx
  800524:	89 55 14             	mov    %edx,0x14(%ebp)
  800527:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	89 04 24             	mov    %eax,(%esp)
  800530:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800533:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800536:	e9 f2 fe ff ff       	jmp    80042d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 50 04             	lea    0x4(%eax),%edx
  800541:	89 55 14             	mov    %edx,0x14(%ebp)
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 c2                	mov    %eax,%edx
  800548:	c1 fa 1f             	sar    $0x1f,%edx
  80054b:	31 d0                	xor    %edx,%eax
  80054d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054f:	83 f8 0f             	cmp    $0xf,%eax
  800552:	7f 0b                	jg     80055f <vprintfmt+0x155>
  800554:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  80055b:	85 d2                	test   %edx,%edx
  80055d:	75 23                	jne    800582 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80055f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800563:	c7 44 24 08 83 23 80 	movl   $0x802383,0x8(%esp)
  80056a:	00 
  80056b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80056f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800572:	89 3c 24             	mov    %edi,(%esp)
  800575:	e8 68 fe ff ff       	call   8003e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80057d:	e9 ab fe ff ff       	jmp    80042d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800582:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800586:	c7 44 24 08 35 27 80 	movl   $0x802735,0x8(%esp)
  80058d:	00 
  80058e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800592:	8b 7d 08             	mov    0x8(%ebp),%edi
  800595:	89 3c 24             	mov    %edi,(%esp)
  800598:	e8 45 fe ff ff       	call   8003e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005a0:	e9 88 fe ff ff       	jmp    80042d <vprintfmt+0x23>
  8005a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 50 04             	lea    0x4(%eax),%edx
  8005b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005b9:	85 f6                	test   %esi,%esi
  8005bb:	ba 7c 23 80 00       	mov    $0x80237c,%edx
  8005c0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8005c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c7:	7e 06                	jle    8005cf <vprintfmt+0x1c5>
  8005c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005cd:	75 10                	jne    8005df <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005cf:	0f be 06             	movsbl (%esi),%eax
  8005d2:	83 c6 01             	add    $0x1,%esi
  8005d5:	85 c0                	test   %eax,%eax
  8005d7:	0f 85 86 00 00 00    	jne    800663 <vprintfmt+0x259>
  8005dd:	eb 76                	jmp    800655 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e3:	89 34 24             	mov    %esi,(%esp)
  8005e6:	e8 90 02 00 00       	call   80087b <strnlen>
  8005eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ee:	29 c2                	sub    %eax,%edx
  8005f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f3:	85 d2                	test   %edx,%edx
  8005f5:	7e d8                	jle    8005cf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005f7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005fe:	89 d6                	mov    %edx,%esi
  800600:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800603:	89 c7                	mov    %eax,%edi
  800605:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800609:	89 3c 24             	mov    %edi,(%esp)
  80060c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060f:	83 ee 01             	sub    $0x1,%esi
  800612:	75 f1                	jne    800605 <vprintfmt+0x1fb>
  800614:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800617:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80061a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80061d:	eb b0                	jmp    8005cf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80061f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800623:	74 18                	je     80063d <vprintfmt+0x233>
  800625:	8d 50 e0             	lea    -0x20(%eax),%edx
  800628:	83 fa 5e             	cmp    $0x5e,%edx
  80062b:	76 10                	jbe    80063d <vprintfmt+0x233>
					putch('?', putdat);
  80062d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800631:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800638:	ff 55 08             	call   *0x8(%ebp)
  80063b:	eb 0a                	jmp    800647 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80063d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800641:	89 04 24             	mov    %eax,(%esp)
  800644:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800647:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80064b:	0f be 06             	movsbl (%esi),%eax
  80064e:	83 c6 01             	add    $0x1,%esi
  800651:	85 c0                	test   %eax,%eax
  800653:	75 0e                	jne    800663 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800658:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065c:	7f 16                	jg     800674 <vprintfmt+0x26a>
  80065e:	e9 ca fd ff ff       	jmp    80042d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800663:	85 ff                	test   %edi,%edi
  800665:	78 b8                	js     80061f <vprintfmt+0x215>
  800667:	83 ef 01             	sub    $0x1,%edi
  80066a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800670:	79 ad                	jns    80061f <vprintfmt+0x215>
  800672:	eb e1                	jmp    800655 <vprintfmt+0x24b>
  800674:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800677:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80067a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80067e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800685:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800687:	83 ee 01             	sub    $0x1,%esi
  80068a:	75 ee                	jne    80067a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80068f:	e9 99 fd ff ff       	jmp    80042d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800694:	83 f9 01             	cmp    $0x1,%ecx
  800697:	7e 10                	jle    8006a9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 50 08             	lea    0x8(%eax),%edx
  80069f:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a2:	8b 30                	mov    (%eax),%esi
  8006a4:	8b 78 04             	mov    0x4(%eax),%edi
  8006a7:	eb 26                	jmp    8006cf <vprintfmt+0x2c5>
	else if (lflag)
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	74 12                	je     8006bf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 50 04             	lea    0x4(%eax),%edx
  8006b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b6:	8b 30                	mov    (%eax),%esi
  8006b8:	89 f7                	mov    %esi,%edi
  8006ba:	c1 ff 1f             	sar    $0x1f,%edi
  8006bd:	eb 10                	jmp    8006cf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 50 04             	lea    0x4(%eax),%edx
  8006c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c8:	8b 30                	mov    (%eax),%esi
  8006ca:	89 f7                	mov    %esi,%edi
  8006cc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006d4:	85 ff                	test   %edi,%edi
  8006d6:	0f 89 8c 00 00 00    	jns    800768 <vprintfmt+0x35e>
				putch('-', putdat);
  8006dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006e7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ea:	f7 de                	neg    %esi
  8006ec:	83 d7 00             	adc    $0x0,%edi
  8006ef:	f7 df                	neg    %edi
			}
			base = 10;
  8006f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f6:	eb 70                	jmp    800768 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f8:	89 ca                	mov    %ecx,%edx
  8006fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fd:	e8 89 fc ff ff       	call   80038b <getuint>
  800702:	89 c6                	mov    %eax,%esi
  800704:	89 d7                	mov    %edx,%edi
			base = 10;
  800706:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80070b:	eb 5b                	jmp    800768 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80070d:	89 ca                	mov    %ecx,%edx
  80070f:	8d 45 14             	lea    0x14(%ebp),%eax
  800712:	e8 74 fc ff ff       	call   80038b <getuint>
  800717:	89 c6                	mov    %eax,%esi
  800719:	89 d7                	mov    %edx,%edi
			base = 8;
  80071b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800720:	eb 46                	jmp    800768 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800722:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800726:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80072d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800730:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800734:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80073b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800747:	8b 30                	mov    (%eax),%esi
  800749:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80074e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800753:	eb 13                	jmp    800768 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800755:	89 ca                	mov    %ecx,%edx
  800757:	8d 45 14             	lea    0x14(%ebp),%eax
  80075a:	e8 2c fc ff ff       	call   80038b <getuint>
  80075f:	89 c6                	mov    %eax,%esi
  800761:	89 d7                	mov    %edx,%edi
			base = 16;
  800763:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800768:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80076c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800770:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800773:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800777:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077b:	89 34 24             	mov    %esi,(%esp)
  80077e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800782:	89 da                	mov    %ebx,%edx
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	e8 24 fb ff ff       	call   8002b0 <printnum>
			break;
  80078c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80078f:	e9 99 fc ff ff       	jmp    80042d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800794:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800798:	89 14 24             	mov    %edx,(%esp)
  80079b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007a1:	e9 87 fc ff ff       	jmp    80042d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007aa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007b8:	0f 84 6f fc ff ff    	je     80042d <vprintfmt+0x23>
  8007be:	83 ee 01             	sub    $0x1,%esi
  8007c1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007c5:	75 f7                	jne    8007be <vprintfmt+0x3b4>
  8007c7:	e9 61 fc ff ff       	jmp    80042d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8007cc:	83 c4 4c             	add    $0x4c,%esp
  8007cf:	5b                   	pop    %ebx
  8007d0:	5e                   	pop    %esi
  8007d1:	5f                   	pop    %edi
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 28             	sub    $0x28,%esp
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	74 30                	je     800825 <vsnprintf+0x51>
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	7e 2c                	jle    800825 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	89 44 24 08          	mov    %eax,0x8(%esp)
  800807:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080e:	c7 04 24 c5 03 80 00 	movl   $0x8003c5,(%esp)
  800815:	e8 f0 fb ff ff       	call   80040a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800823:	eb 05                	jmp    80082a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800825:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800832:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	89 44 24 04          	mov    %eax,0x4(%esp)
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	89 04 24             	mov    %eax,(%esp)
  80084d:	e8 82 ff ff ff       	call   8007d4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    
	...

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	80 3a 00             	cmpb   $0x0,(%edx)
  80086e:	74 09                	je     800879 <strlen+0x19>
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800873:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800877:	75 f7                	jne    800870 <strlen+0x10>
		n++;
	return n;
}
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	85 c9                	test   %ecx,%ecx
  80088c:	74 1a                	je     8008a8 <strnlen+0x2d>
  80088e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800891:	74 15                	je     8008a8 <strnlen+0x2d>
  800893:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800898:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089a:	39 ca                	cmp    %ecx,%edx
  80089c:	74 0a                	je     8008a8 <strnlen+0x2d>
  80089e:	83 c2 01             	add    $0x1,%edx
  8008a1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008a6:	75 f0                	jne    800898 <strnlen+0x1d>
		n++;
	return n;
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008be:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c1:	83 c2 01             	add    $0x1,%edx
  8008c4:	84 c9                	test   %cl,%cl
  8008c6:	75 f2                	jne    8008ba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d5:	89 1c 24             	mov    %ebx,(%esp)
  8008d8:	e8 83 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e4:	01 d8                	add    %ebx,%eax
  8008e6:	89 04 24             	mov    %eax,(%esp)
  8008e9:	e8 bd ff ff ff       	call   8008ab <strcpy>
	return dst;
}
  8008ee:	89 d8                	mov    %ebx,%eax
  8008f0:	83 c4 08             	add    $0x8,%esp
  8008f3:	5b                   	pop    %ebx
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800901:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800904:	85 f6                	test   %esi,%esi
  800906:	74 18                	je     800920 <strncpy+0x2a>
  800908:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80090d:	0f b6 1a             	movzbl (%edx),%ebx
  800910:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800913:	80 3a 01             	cmpb   $0x1,(%edx)
  800916:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800919:	83 c1 01             	add    $0x1,%ecx
  80091c:	39 f1                	cmp    %esi,%ecx
  80091e:	75 ed                	jne    80090d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	57                   	push   %edi
  800928:	56                   	push   %esi
  800929:	53                   	push   %ebx
  80092a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800930:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800933:	89 f8                	mov    %edi,%eax
  800935:	85 f6                	test   %esi,%esi
  800937:	74 2b                	je     800964 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800939:	83 fe 01             	cmp    $0x1,%esi
  80093c:	74 23                	je     800961 <strlcpy+0x3d>
  80093e:	0f b6 0b             	movzbl (%ebx),%ecx
  800941:	84 c9                	test   %cl,%cl
  800943:	74 1c                	je     800961 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800945:	83 ee 02             	sub    $0x2,%esi
  800948:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80094d:	88 08                	mov    %cl,(%eax)
  80094f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800952:	39 f2                	cmp    %esi,%edx
  800954:	74 0b                	je     800961 <strlcpy+0x3d>
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095d:	84 c9                	test   %cl,%cl
  80095f:	75 ec                	jne    80094d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800961:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800964:	29 f8                	sub    %edi,%eax
}
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5f                   	pop    %edi
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800971:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800974:	0f b6 01             	movzbl (%ecx),%eax
  800977:	84 c0                	test   %al,%al
  800979:	74 16                	je     800991 <strcmp+0x26>
  80097b:	3a 02                	cmp    (%edx),%al
  80097d:	75 12                	jne    800991 <strcmp+0x26>
		p++, q++;
  80097f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800982:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 07                	je     800991 <strcmp+0x26>
  80098a:	83 c1 01             	add    $0x1,%ecx
  80098d:	3a 02                	cmp    (%edx),%al
  80098f:	74 ee                	je     80097f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800991:	0f b6 c0             	movzbl %al,%eax
  800994:	0f b6 12             	movzbl (%edx),%edx
  800997:	29 d0                	sub    %edx,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009a5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ad:	85 d2                	test   %edx,%edx
  8009af:	74 28                	je     8009d9 <strncmp+0x3e>
  8009b1:	0f b6 01             	movzbl (%ecx),%eax
  8009b4:	84 c0                	test   %al,%al
  8009b6:	74 24                	je     8009dc <strncmp+0x41>
  8009b8:	3a 03                	cmp    (%ebx),%al
  8009ba:	75 20                	jne    8009dc <strncmp+0x41>
  8009bc:	83 ea 01             	sub    $0x1,%edx
  8009bf:	74 13                	je     8009d4 <strncmp+0x39>
		n--, p++, q++;
  8009c1:	83 c1 01             	add    $0x1,%ecx
  8009c4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c7:	0f b6 01             	movzbl (%ecx),%eax
  8009ca:	84 c0                	test   %al,%al
  8009cc:	74 0e                	je     8009dc <strncmp+0x41>
  8009ce:	3a 03                	cmp    (%ebx),%al
  8009d0:	74 ea                	je     8009bc <strncmp+0x21>
  8009d2:	eb 08                	jmp    8009dc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d9:	5b                   	pop    %ebx
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dc:	0f b6 01             	movzbl (%ecx),%eax
  8009df:	0f b6 13             	movzbl (%ebx),%edx
  8009e2:	29 d0                	sub    %edx,%eax
  8009e4:	eb f3                	jmp    8009d9 <strncmp+0x3e>

008009e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f0:	0f b6 10             	movzbl (%eax),%edx
  8009f3:	84 d2                	test   %dl,%dl
  8009f5:	74 1c                	je     800a13 <strchr+0x2d>
		if (*s == c)
  8009f7:	38 ca                	cmp    %cl,%dl
  8009f9:	75 09                	jne    800a04 <strchr+0x1e>
  8009fb:	eb 1b                	jmp    800a18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800a00:	38 ca                	cmp    %cl,%dl
  800a02:	74 14                	je     800a18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a04:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800a08:	84 d2                	test   %dl,%dl
  800a0a:	75 f1                	jne    8009fd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb 05                	jmp    800a18 <strchr+0x32>
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a24:	0f b6 10             	movzbl (%eax),%edx
  800a27:	84 d2                	test   %dl,%dl
  800a29:	74 14                	je     800a3f <strfind+0x25>
		if (*s == c)
  800a2b:	38 ca                	cmp    %cl,%dl
  800a2d:	75 06                	jne    800a35 <strfind+0x1b>
  800a2f:	eb 0e                	jmp    800a3f <strfind+0x25>
  800a31:	38 ca                	cmp    %cl,%dl
  800a33:	74 0a                	je     800a3f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	0f b6 10             	movzbl (%eax),%edx
  800a3b:	84 d2                	test   %dl,%dl
  800a3d:	75 f2                	jne    800a31 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a4a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a4d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a50:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a59:	85 c9                	test   %ecx,%ecx
  800a5b:	74 30                	je     800a8d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a5d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a63:	75 25                	jne    800a8a <memset+0x49>
  800a65:	f6 c1 03             	test   $0x3,%cl
  800a68:	75 20                	jne    800a8a <memset+0x49>
		c &= 0xFF;
  800a6a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6d:	89 d3                	mov    %edx,%ebx
  800a6f:	c1 e3 08             	shl    $0x8,%ebx
  800a72:	89 d6                	mov    %edx,%esi
  800a74:	c1 e6 18             	shl    $0x18,%esi
  800a77:	89 d0                	mov    %edx,%eax
  800a79:	c1 e0 10             	shl    $0x10,%eax
  800a7c:	09 f0                	or     %esi,%eax
  800a7e:	09 d0                	or     %edx,%eax
  800a80:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a82:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a85:	fc                   	cld    
  800a86:	f3 ab                	rep stos %eax,%es:(%edi)
  800a88:	eb 03                	jmp    800a8d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8a:	fc                   	cld    
  800a8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a8d:	89 f8                	mov    %edi,%eax
  800a8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a98:	89 ec                	mov    %ebp,%esp
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800aa5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab1:	39 c6                	cmp    %eax,%esi
  800ab3:	73 36                	jae    800aeb <memmove+0x4f>
  800ab5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab8:	39 d0                	cmp    %edx,%eax
  800aba:	73 2f                	jae    800aeb <memmove+0x4f>
		s += n;
		d += n;
  800abc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 1b                	jne    800adf <memmove+0x43>
  800ac4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aca:	75 13                	jne    800adf <memmove+0x43>
  800acc:	f6 c1 03             	test   $0x3,%cl
  800acf:	75 0e                	jne    800adf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad1:	83 ef 04             	sub    $0x4,%edi
  800ad4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800ada:	fd                   	std    
  800adb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800add:	eb 09                	jmp    800ae8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adf:	83 ef 01             	sub    $0x1,%edi
  800ae2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae8:	fc                   	cld    
  800ae9:	eb 20                	jmp    800b0b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af1:	75 13                	jne    800b06 <memmove+0x6a>
  800af3:	a8 03                	test   $0x3,%al
  800af5:	75 0f                	jne    800b06 <memmove+0x6a>
  800af7:	f6 c1 03             	test   $0x3,%cl
  800afa:	75 0a                	jne    800b06 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800aff:	89 c7                	mov    %eax,%edi
  800b01:	fc                   	cld    
  800b02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b04:	eb 05                	jmp    800b0b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b06:	89 c7                	mov    %eax,%edi
  800b08:	fc                   	cld    
  800b09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b11:	89 ec                	mov    %ebp,%esp
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	89 04 24             	mov    %eax,(%esp)
  800b2f:	e8 68 ff ff ff       	call   800a9c <memmove>
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b42:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4a:	85 ff                	test   %edi,%edi
  800b4c:	74 37                	je     800b85 <memcmp+0x4f>
		if (*s1 != *s2)
  800b4e:	0f b6 03             	movzbl (%ebx),%eax
  800b51:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b54:	83 ef 01             	sub    $0x1,%edi
  800b57:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b5c:	38 c8                	cmp    %cl,%al
  800b5e:	74 1c                	je     800b7c <memcmp+0x46>
  800b60:	eb 10                	jmp    800b72 <memcmp+0x3c>
  800b62:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b67:	83 c2 01             	add    $0x1,%edx
  800b6a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b6e:	38 c8                	cmp    %cl,%al
  800b70:	74 0a                	je     800b7c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800b72:	0f b6 c0             	movzbl %al,%eax
  800b75:	0f b6 c9             	movzbl %cl,%ecx
  800b78:	29 c8                	sub    %ecx,%eax
  800b7a:	eb 09                	jmp    800b85 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7c:	39 fa                	cmp    %edi,%edx
  800b7e:	75 e2                	jne    800b62 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b95:	39 d0                	cmp    %edx,%eax
  800b97:	73 19                	jae    800bb2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b9d:	38 08                	cmp    %cl,(%eax)
  800b9f:	75 06                	jne    800ba7 <memfind+0x1d>
  800ba1:	eb 0f                	jmp    800bb2 <memfind+0x28>
  800ba3:	38 08                	cmp    %cl,(%eax)
  800ba5:	74 0b                	je     800bb2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ba7:	83 c0 01             	add    $0x1,%eax
  800baa:	39 d0                	cmp    %edx,%eax
  800bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bb0:	75 f1                	jne    800ba3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc0:	0f b6 02             	movzbl (%edx),%eax
  800bc3:	3c 20                	cmp    $0x20,%al
  800bc5:	74 04                	je     800bcb <strtol+0x17>
  800bc7:	3c 09                	cmp    $0x9,%al
  800bc9:	75 0e                	jne    800bd9 <strtol+0x25>
		s++;
  800bcb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bce:	0f b6 02             	movzbl (%edx),%eax
  800bd1:	3c 20                	cmp    $0x20,%al
  800bd3:	74 f6                	je     800bcb <strtol+0x17>
  800bd5:	3c 09                	cmp    $0x9,%al
  800bd7:	74 f2                	je     800bcb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd9:	3c 2b                	cmp    $0x2b,%al
  800bdb:	75 0a                	jne    800be7 <strtol+0x33>
		s++;
  800bdd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800be0:	bf 00 00 00 00       	mov    $0x0,%edi
  800be5:	eb 10                	jmp    800bf7 <strtol+0x43>
  800be7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bec:	3c 2d                	cmp    $0x2d,%al
  800bee:	75 07                	jne    800bf7 <strtol+0x43>
		s++, neg = 1;
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf7:	85 db                	test   %ebx,%ebx
  800bf9:	0f 94 c0             	sete   %al
  800bfc:	74 05                	je     800c03 <strtol+0x4f>
  800bfe:	83 fb 10             	cmp    $0x10,%ebx
  800c01:	75 15                	jne    800c18 <strtol+0x64>
  800c03:	80 3a 30             	cmpb   $0x30,(%edx)
  800c06:	75 10                	jne    800c18 <strtol+0x64>
  800c08:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c0c:	75 0a                	jne    800c18 <strtol+0x64>
		s += 2, base = 16;
  800c0e:	83 c2 02             	add    $0x2,%edx
  800c11:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c16:	eb 13                	jmp    800c2b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800c18:	84 c0                	test   %al,%al
  800c1a:	74 0f                	je     800c2b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c1c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c21:	80 3a 30             	cmpb   $0x30,(%edx)
  800c24:	75 05                	jne    800c2b <strtol+0x77>
		s++, base = 8;
  800c26:	83 c2 01             	add    $0x1,%edx
  800c29:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c32:	0f b6 0a             	movzbl (%edx),%ecx
  800c35:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c38:	80 fb 09             	cmp    $0x9,%bl
  800c3b:	77 08                	ja     800c45 <strtol+0x91>
			dig = *s - '0';
  800c3d:	0f be c9             	movsbl %cl,%ecx
  800c40:	83 e9 30             	sub    $0x30,%ecx
  800c43:	eb 1e                	jmp    800c63 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c45:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c48:	80 fb 19             	cmp    $0x19,%bl
  800c4b:	77 08                	ja     800c55 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c4d:	0f be c9             	movsbl %cl,%ecx
  800c50:	83 e9 57             	sub    $0x57,%ecx
  800c53:	eb 0e                	jmp    800c63 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c55:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c58:	80 fb 19             	cmp    $0x19,%bl
  800c5b:	77 14                	ja     800c71 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c5d:	0f be c9             	movsbl %cl,%ecx
  800c60:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c63:	39 f1                	cmp    %esi,%ecx
  800c65:	7d 0e                	jge    800c75 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	0f af c6             	imul   %esi,%eax
  800c6d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c6f:	eb c1                	jmp    800c32 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c71:	89 c1                	mov    %eax,%ecx
  800c73:	eb 02                	jmp    800c77 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c75:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7b:	74 05                	je     800c82 <strtol+0xce>
		*endptr = (char *) s;
  800c7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c80:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c82:	89 ca                	mov    %ecx,%edx
  800c84:	f7 da                	neg    %edx
  800c86:	85 ff                	test   %edi,%edi
  800c88:	0f 45 c2             	cmovne %edx,%eax
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	89 c3                	mov    %eax,%ebx
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	89 c6                	mov    %eax,%esi
  800cb0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cbb:	89 ec                	mov    %ebp,%esp
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 0c             	sub    $0xc,%esp
  800cc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ccb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cce:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd8:	89 d1                	mov    %edx,%ecx
  800cda:	89 d3                	mov    %edx,%ebx
  800cdc:	89 d7                	mov    %edx,%edi
  800cde:	89 d6                	mov    %edx,%esi
  800ce0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ceb:	89 ec                	mov    %ebp,%esp
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 38             	sub    $0x38,%esp
  800cf5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cfb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d03:	b8 03 00 00 00       	mov    $0x3,%eax
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	89 cb                	mov    %ecx,%ebx
  800d0d:	89 cf                	mov    %ecx,%edi
  800d0f:	89 ce                	mov    %ecx,%esi
  800d11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800d3a:	e8 4d f4 ff ff       	call   80018c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d48:	89 ec                	mov    %ebp,%esp
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800d60:	b8 02 00 00 00       	mov    $0x2,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d78:	89 ec                	mov    %ebp,%esp
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_yield>:

void
sys_yield(void)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da8:	89 ec                	mov    %ebp,%esp
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 38             	sub    $0x38,%esp
  800db2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbb:	be 00 00 00 00       	mov    $0x0,%esi
  800dc0:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	89 f7                	mov    %esi,%edi
  800dd0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7e 28                	jle    800dfe <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dda:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800de1:	00 
  800de2:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800df9:	e8 8e f3 ff ff       	call   80018c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e01:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e04:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e07:	89 ec                	mov    %ebp,%esp
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 38             	sub    $0x38,%esp
  800e11:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e14:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e17:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e1f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e30:	85 c0                	test   %eax,%eax
  800e32:	7e 28                	jle    800e5c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e38:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e3f:	00 
  800e40:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800e47:	00 
  800e48:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4f:	00 
  800e50:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800e57:	e8 30 f3 ff ff       	call   80018c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e5f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e62:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e65:	89 ec                	mov    %ebp,%esp
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 38             	sub    $0x38,%esp
  800e6f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e75:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	89 df                	mov    %ebx,%edi
  800e8a:	89 de                	mov    %ebx,%esi
  800e8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	7e 28                	jle    800eba <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e96:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e9d:	00 
  800e9e:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800ea5:	00 
  800ea6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ead:	00 
  800eae:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800eb5:	e8 d2 f2 ff ff       	call   80018c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eba:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ebd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec3:	89 ec                	mov    %ebp,%esp
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 38             	sub    $0x38,%esp
  800ecd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7e 28                	jle    800f18 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800efb:	00 
  800efc:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800f03:	00 
  800f04:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0b:	00 
  800f0c:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800f13:	e8 74 f2 ff ff       	call   80018c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f18:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f21:	89 ec                	mov    %ebp,%esp
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f39:	b8 09 00 00 00       	mov    $0x9,%eax
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
  800f44:	89 df                	mov    %ebx,%edi
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	7e 28                	jle    800f76 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f52:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f59:	00 
  800f5a:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800f61:	00 
  800f62:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f69:	00 
  800f6a:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800f71:	e8 16 f2 ff ff       	call   80018c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f76:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f79:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f7c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f7f:	89 ec                	mov    %ebp,%esp
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 38             	sub    $0x38,%esp
  800f89:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	89 df                	mov    %ebx,%edi
  800fa4:	89 de                	mov    %ebx,%esi
  800fa6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	7e 28                	jle    800fd4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fac:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fb7:	00 
  800fb8:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  800fbf:	00 
  800fc0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc7:	00 
  800fc8:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800fcf:	e8 b8 f1 ff ff       	call   80018c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fda:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fdd:	89 ec                	mov    %ebp,%esp
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 0c             	sub    $0xc,%esp
  800fe7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fed:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff0:	be 00 00 00 00       	mov    $0x0,%esi
  800ff5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ffa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ffd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801008:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801011:	89 ec                	mov    %ebp,%esp
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 38             	sub    $0x38,%esp
  80101b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801021:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	b9 00 00 00 00       	mov    $0x0,%ecx
  801029:	b8 0d 00 00 00       	mov    $0xd,%eax
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	89 cb                	mov    %ecx,%ebx
  801033:	89 cf                	mov    %ecx,%edi
  801035:	89 ce                	mov    %ecx,%esi
  801037:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801039:	85 c0                	test   %eax,%eax
  80103b:	7e 28                	jle    801065 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801041:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801048:	00 
  801049:	c7 44 24 08 5f 26 80 	movl   $0x80265f,0x8(%esp)
  801050:	00 
  801051:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801058:	00 
  801059:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  801060:	e8 27 f1 ff ff       	call   80018c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801065:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801068:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106e:	89 ec                	mov    %ebp,%esp
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
	...

00801080 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
  80108b:	c1 e8 0c             	shr    $0xc,%eax
}
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	89 04 24             	mov    %eax,(%esp)
  80109c:	e8 df ff ff ff       	call   801080 <fd2num>
  8010a1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8010a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	53                   	push   %ebx
  8010af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010b7:	a8 01                	test   $0x1,%al
  8010b9:	74 34                	je     8010ef <fd_alloc+0x44>
  8010bb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010c0:	a8 01                	test   $0x1,%al
  8010c2:	74 32                	je     8010f6 <fd_alloc+0x4b>
  8010c4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010c9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010cb:	89 c2                	mov    %eax,%edx
  8010cd:	c1 ea 16             	shr    $0x16,%edx
  8010d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d7:	f6 c2 01             	test   $0x1,%dl
  8010da:	74 1f                	je     8010fb <fd_alloc+0x50>
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	c1 ea 0c             	shr    $0xc,%edx
  8010e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e8:	f6 c2 01             	test   $0x1,%dl
  8010eb:	75 17                	jne    801104 <fd_alloc+0x59>
  8010ed:	eb 0c                	jmp    8010fb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010ef:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8010f4:	eb 05                	jmp    8010fb <fd_alloc+0x50>
  8010f6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8010fb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8010fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801102:	eb 17                	jmp    80111b <fd_alloc+0x70>
  801104:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801109:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110e:	75 b9                	jne    8010c9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801110:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801116:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80111b:	5b                   	pop    %ebx
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801124:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801129:	83 fa 1f             	cmp    $0x1f,%edx
  80112c:	77 3f                	ja     80116d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80112e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801134:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801137:	89 d0                	mov    %edx,%eax
  801139:	c1 e8 16             	shr    $0x16,%eax
  80113c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801143:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801148:	f6 c1 01             	test   $0x1,%cl
  80114b:	74 20                	je     80116d <fd_lookup+0x4f>
  80114d:	89 d0                	mov    %edx,%eax
  80114f:	c1 e8 0c             	shr    $0xc,%eax
  801152:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801159:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115e:	f6 c1 01             	test   $0x1,%cl
  801161:	74 0a                	je     80116d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	89 10                	mov    %edx,(%eax)
	return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	53                   	push   %ebx
  801173:	83 ec 14             	sub    $0x14,%esp
  801176:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801179:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801181:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801187:	75 17                	jne    8011a0 <dev_lookup+0x31>
  801189:	eb 07                	jmp    801192 <dev_lookup+0x23>
  80118b:	39 0a                	cmp    %ecx,(%edx)
  80118d:	75 11                	jne    8011a0 <dev_lookup+0x31>
  80118f:	90                   	nop
  801190:	eb 05                	jmp    801197 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801192:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801197:	89 13                	mov    %edx,(%ebx)
			return 0;
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
  80119e:	eb 35                	jmp    8011d5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011a0:	83 c0 01             	add    $0x1,%eax
  8011a3:	8b 14 85 0c 27 80 00 	mov    0x80270c(,%eax,4),%edx
  8011aa:	85 d2                	test   %edx,%edx
  8011ac:	75 dd                	jne    80118b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ae:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011b3:	8b 40 48             	mov    0x48(%eax),%eax
  8011b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011be:	c7 04 24 8c 26 80 00 	movl   $0x80268c,(%esp)
  8011c5:	e8 bd f0 ff ff       	call   800287 <cprintf>
	*dev = 0;
  8011ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8011d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d5:	83 c4 14             	add    $0x14,%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 38             	sub    $0x38,%esp
  8011e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8011ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011ed:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f1:	89 3c 24             	mov    %edi,(%esp)
  8011f4:	e8 87 fe ff ff       	call   801080 <fd2num>
  8011f9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8011fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801200:	89 04 24             	mov    %eax,(%esp)
  801203:	e8 16 ff ff ff       	call   80111e <fd_lookup>
  801208:	89 c3                	mov    %eax,%ebx
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 05                	js     801213 <fd_close+0x38>
	    || fd != fd2)
  80120e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801211:	74 0e                	je     801221 <fd_close+0x46>
		return (must_exist ? r : 0);
  801213:	89 f0                	mov    %esi,%eax
  801215:	84 c0                	test   %al,%al
  801217:	b8 00 00 00 00       	mov    $0x0,%eax
  80121c:	0f 44 d8             	cmove  %eax,%ebx
  80121f:	eb 3d                	jmp    80125e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801221:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801224:	89 44 24 04          	mov    %eax,0x4(%esp)
  801228:	8b 07                	mov    (%edi),%eax
  80122a:	89 04 24             	mov    %eax,(%esp)
  80122d:	e8 3d ff ff ff       	call   80116f <dev_lookup>
  801232:	89 c3                	mov    %eax,%ebx
  801234:	85 c0                	test   %eax,%eax
  801236:	78 16                	js     80124e <fd_close+0x73>
		if (dev->dev_close)
  801238:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801243:	85 c0                	test   %eax,%eax
  801245:	74 07                	je     80124e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801247:	89 3c 24             	mov    %edi,(%esp)
  80124a:	ff d0                	call   *%eax
  80124c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80124e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801252:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801259:	e8 0b fc ff ff       	call   800e69 <sys_page_unmap>
	return r;
}
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801263:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801266:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801269:	89 ec                	mov    %ebp,%esp
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801273:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	89 04 24             	mov    %eax,(%esp)
  801280:	e8 99 fe ff ff       	call   80111e <fd_lookup>
  801285:	85 c0                	test   %eax,%eax
  801287:	78 13                	js     80129c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801289:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801290:	00 
  801291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801294:	89 04 24             	mov    %eax,(%esp)
  801297:	e8 3f ff ff ff       	call   8011db <fd_close>
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <close_all>:

void
close_all(void)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012aa:	89 1c 24             	mov    %ebx,(%esp)
  8012ad:	e8 bb ff ff ff       	call   80126d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012b2:	83 c3 01             	add    $0x1,%ebx
  8012b5:	83 fb 20             	cmp    $0x20,%ebx
  8012b8:	75 f0                	jne    8012aa <close_all+0xc>
		close(i);
}
  8012ba:	83 c4 14             	add    $0x14,%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 58             	sub    $0x58,%esp
  8012c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012c9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012cc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8012cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	89 04 24             	mov    %eax,(%esp)
  8012df:	e8 3a fe ff ff       	call   80111e <fd_lookup>
  8012e4:	89 c3                	mov    %eax,%ebx
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	0f 88 e1 00 00 00    	js     8013cf <dup+0x10f>
		return r;
	close(newfdnum);
  8012ee:	89 3c 24             	mov    %edi,(%esp)
  8012f1:	e8 77 ff ff ff       	call   80126d <close>

	newfd = INDEX2FD(newfdnum);
  8012f6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8012fc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8012ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 86 fd ff ff       	call   801090 <fd2data>
  80130a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80130c:	89 34 24             	mov    %esi,(%esp)
  80130f:	e8 7c fd ff ff       	call   801090 <fd2data>
  801314:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801317:	89 d8                	mov    %ebx,%eax
  801319:	c1 e8 16             	shr    $0x16,%eax
  80131c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801323:	a8 01                	test   $0x1,%al
  801325:	74 46                	je     80136d <dup+0xad>
  801327:	89 d8                	mov    %ebx,%eax
  801329:	c1 e8 0c             	shr    $0xc,%eax
  80132c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801333:	f6 c2 01             	test   $0x1,%dl
  801336:	74 35                	je     80136d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801338:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80133f:	25 07 0e 00 00       	and    $0xe07,%eax
  801344:	89 44 24 10          	mov    %eax,0x10(%esp)
  801348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80134b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801356:	00 
  801357:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80135b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801362:	e8 a4 fa ff ff       	call   800e0b <sys_page_map>
  801367:	89 c3                	mov    %eax,%ebx
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 3b                	js     8013a8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80136d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801370:	89 c2                	mov    %eax,%edx
  801372:	c1 ea 0c             	shr    $0xc,%edx
  801375:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801382:	89 54 24 10          	mov    %edx,0x10(%esp)
  801386:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80138a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801391:	00 
  801392:	89 44 24 04          	mov    %eax,0x4(%esp)
  801396:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139d:	e8 69 fa ff ff       	call   800e0b <sys_page_map>
  8013a2:	89 c3                	mov    %eax,%ebx
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	79 25                	jns    8013cd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b3:	e8 b1 fa ff ff       	call   800e69 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c6:	e8 9e fa ff ff       	call   800e69 <sys_page_unmap>
	return r;
  8013cb:	eb 02                	jmp    8013cf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8013cd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013cf:	89 d8                	mov    %ebx,%eax
  8013d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013da:	89 ec                	mov    %ebp,%esp
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  8013f2:	e8 27 fd ff ff       	call   80111e <fd_lookup>
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 6d                	js     801468 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	89 04 24             	mov    %eax,(%esp)
  80140a:	e8 60 fd ff ff       	call   80116f <dev_lookup>
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 55                	js     801468 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	8b 50 08             	mov    0x8(%eax),%edx
  801419:	83 e2 03             	and    $0x3,%edx
  80141c:	83 fa 01             	cmp    $0x1,%edx
  80141f:	75 23                	jne    801444 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801421:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801426:	8b 40 48             	mov    0x48(%eax),%eax
  801429:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801431:	c7 04 24 d0 26 80 00 	movl   $0x8026d0,(%esp)
  801438:	e8 4a ee ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801442:	eb 24                	jmp    801468 <read+0x8a>
	}
	if (!dev->dev_read)
  801444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801447:	8b 52 08             	mov    0x8(%edx),%edx
  80144a:	85 d2                	test   %edx,%edx
  80144c:	74 15                	je     801463 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80144e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801451:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801455:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801458:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80145c:	89 04 24             	mov    %eax,(%esp)
  80145f:	ff d2                	call   *%edx
  801461:	eb 05                	jmp    801468 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801463:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801468:	83 c4 24             	add    $0x24,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
  801474:	83 ec 1c             	sub    $0x1c,%esp
  801477:	8b 7d 08             	mov    0x8(%ebp),%edi
  80147a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
  801482:	85 f6                	test   %esi,%esi
  801484:	74 30                	je     8014b6 <readn+0x48>
  801486:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80148b:	89 f2                	mov    %esi,%edx
  80148d:	29 c2                	sub    %eax,%edx
  80148f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801493:	03 45 0c             	add    0xc(%ebp),%eax
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	89 3c 24             	mov    %edi,(%esp)
  80149d:	e8 3c ff ff ff       	call   8013de <read>
		if (m < 0)
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 10                	js     8014b6 <readn+0x48>
			return m;
		if (m == 0)
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 0a                	je     8014b4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014aa:	01 c3                	add    %eax,%ebx
  8014ac:	89 d8                	mov    %ebx,%eax
  8014ae:	39 f3                	cmp    %esi,%ebx
  8014b0:	72 d9                	jb     80148b <readn+0x1d>
  8014b2:	eb 02                	jmp    8014b6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8014b4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8014b6:	83 c4 1c             	add    $0x1c,%esp
  8014b9:	5b                   	pop    %ebx
  8014ba:	5e                   	pop    %esi
  8014bb:	5f                   	pop    %edi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 24             	sub    $0x24,%esp
  8014c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cf:	89 1c 24             	mov    %ebx,(%esp)
  8014d2:	e8 47 fc ff ff       	call   80111e <fd_lookup>
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	78 68                	js     801543 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	8b 00                	mov    (%eax),%eax
  8014e7:	89 04 24             	mov    %eax,(%esp)
  8014ea:	e8 80 fc ff ff       	call   80116f <dev_lookup>
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 50                	js     801543 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fa:	75 23                	jne    80151f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014fc:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801501:	8b 40 48             	mov    0x48(%eax),%eax
  801504:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150c:	c7 04 24 ec 26 80 00 	movl   $0x8026ec,(%esp)
  801513:	e8 6f ed ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  801518:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151d:	eb 24                	jmp    801543 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	8b 52 0c             	mov    0xc(%edx),%edx
  801525:	85 d2                	test   %edx,%edx
  801527:	74 15                	je     80153e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801529:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80152c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801533:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	ff d2                	call   *%edx
  80153c:	eb 05                	jmp    801543 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80153e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801543:	83 c4 24             	add    $0x24,%esp
  801546:	5b                   	pop    %ebx
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    

00801549 <seek>:

int
seek(int fdnum, off_t offset)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801552:	89 44 24 04          	mov    %eax,0x4(%esp)
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	89 04 24             	mov    %eax,(%esp)
  80155c:	e8 bd fb ff ff       	call   80111e <fd_lookup>
  801561:	85 c0                	test   %eax,%eax
  801563:	78 0e                	js     801573 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80156e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	53                   	push   %ebx
  801579:	83 ec 24             	sub    $0x24,%esp
  80157c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801582:	89 44 24 04          	mov    %eax,0x4(%esp)
  801586:	89 1c 24             	mov    %ebx,(%esp)
  801589:	e8 90 fb ff ff       	call   80111e <fd_lookup>
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 61                	js     8015f3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	8b 00                	mov    (%eax),%eax
  80159e:	89 04 24             	mov    %eax,(%esp)
  8015a1:	e8 c9 fb ff ff       	call   80116f <dev_lookup>
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	78 49                	js     8015f3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b1:	75 23                	jne    8015d6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015b3:	a1 20 40 c0 00       	mov    0xc04020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b8:	8b 40 48             	mov    0x48(%eax),%eax
  8015bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c3:	c7 04 24 ac 26 80 00 	movl   $0x8026ac,(%esp)
  8015ca:	e8 b8 ec ff ff       	call   800287 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d4:	eb 1d                	jmp    8015f3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8015d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d9:	8b 52 18             	mov    0x18(%edx),%edx
  8015dc:	85 d2                	test   %edx,%edx
  8015de:	74 0e                	je     8015ee <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	ff d2                	call   *%edx
  8015ec:	eb 05                	jmp    8015f3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015f3:	83 c4 24             	add    $0x24,%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 24             	sub    $0x24,%esp
  801600:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801603:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	89 04 24             	mov    %eax,(%esp)
  801610:	e8 09 fb ff ff       	call   80111e <fd_lookup>
  801615:	85 c0                	test   %eax,%eax
  801617:	78 52                	js     80166b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	8b 00                	mov    (%eax),%eax
  801625:	89 04 24             	mov    %eax,(%esp)
  801628:	e8 42 fb ff ff       	call   80116f <dev_lookup>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 3a                	js     80166b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801634:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801638:	74 2c                	je     801666 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80163a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80163d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801644:	00 00 00 
	stat->st_isdir = 0;
  801647:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80164e:	00 00 00 
	stat->st_dev = dev;
  801651:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801657:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80165b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165e:	89 14 24             	mov    %edx,(%esp)
  801661:	ff 50 14             	call   *0x14(%eax)
  801664:	eb 05                	jmp    80166b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801666:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80166b:	83 c4 24             	add    $0x24,%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    

00801671 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 18             	sub    $0x18,%esp
  801677:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80167a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80167d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801684:	00 
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	89 04 24             	mov    %eax,(%esp)
  80168b:	e8 bc 01 00 00       	call   80184c <open>
  801690:	89 c3                	mov    %eax,%ebx
  801692:	85 c0                	test   %eax,%eax
  801694:	78 1b                	js     8016b1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169d:	89 1c 24             	mov    %ebx,(%esp)
  8016a0:	e8 54 ff ff ff       	call   8015f9 <fstat>
  8016a5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a7:	89 1c 24             	mov    %ebx,(%esp)
  8016aa:	e8 be fb ff ff       	call   80126d <close>
	return r;
  8016af:	89 f3                	mov    %esi,%ebx
}
  8016b1:	89 d8                	mov    %ebx,%eax
  8016b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016b6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016b9:	89 ec                	mov    %ebp,%esp
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    
  8016bd:	00 00                	add    %al,(%eax)
	...

008016c0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 18             	sub    $0x18,%esp
  8016c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8016cc:	89 c3                	mov    %eax,%ebx
  8016ce:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8016d0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d7:	75 11                	jne    8016ea <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016e0:	e8 61 08 00 00       	call   801f46 <ipc_find_env>
  8016e5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ea:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016f1:	00 
  8016f2:	c7 44 24 08 00 50 c0 	movl   $0xc05000,0x8(%esp)
  8016f9:	00 
  8016fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016fe:	a1 00 40 80 00       	mov    0x804000,%eax
  801703:	89 04 24             	mov    %eax,(%esp)
  801706:	e8 b7 07 00 00       	call   801ec2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80170b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801712:	00 
  801713:	89 74 24 04          	mov    %esi,0x4(%esp)
  801717:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171e:	e8 4d 07 00 00       	call   801e70 <ipc_recv>
}
  801723:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801726:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801729:	89 ec                	mov    %ebp,%esp
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
  801731:	83 ec 14             	sub    $0x14,%esp
  801734:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8b 40 0c             	mov    0xc(%eax),%eax
  80173d:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 05 00 00 00       	mov    $0x5,%eax
  80174c:	e8 6f ff ff ff       	call   8016c0 <fsipc>
  801751:	85 c0                	test   %eax,%eax
  801753:	78 2b                	js     801780 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801755:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  80175c:	00 
  80175d:	89 1c 24             	mov    %ebx,(%esp)
  801760:	e8 46 f1 ff ff       	call   8008ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801765:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80176a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801770:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801775:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	83 c4 14             	add    $0x14,%esp
  801783:	5b                   	pop    %ebx
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8b 40 0c             	mov    0xc(%eax),%eax
  801792:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a1:	e8 1a ff ff ff       	call   8016c0 <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 10             	sub    $0x10,%esp
  8017b0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b9:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8017be:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ce:	e8 ed fe ff ff       	call   8016c0 <fsipc>
  8017d3:	89 c3                	mov    %eax,%ebx
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 6a                	js     801843 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017d9:	39 c6                	cmp    %eax,%esi
  8017db:	73 24                	jae    801801 <devfile_read+0x59>
  8017dd:	c7 44 24 0c 1c 27 80 	movl   $0x80271c,0xc(%esp)
  8017e4:	00 
  8017e5:	c7 44 24 08 23 27 80 	movl   $0x802723,0x8(%esp)
  8017ec:	00 
  8017ed:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8017f4:	00 
  8017f5:	c7 04 24 38 27 80 00 	movl   $0x802738,(%esp)
  8017fc:	e8 8b e9 ff ff       	call   80018c <_panic>
	assert(r <= PGSIZE);
  801801:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801806:	7e 24                	jle    80182c <devfile_read+0x84>
  801808:	c7 44 24 0c 43 27 80 	movl   $0x802743,0xc(%esp)
  80180f:	00 
  801810:	c7 44 24 08 23 27 80 	movl   $0x802723,0x8(%esp)
  801817:	00 
  801818:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80181f:	00 
  801820:	c7 04 24 38 27 80 00 	movl   $0x802738,(%esp)
  801827:	e8 60 e9 ff ff       	call   80018c <_panic>
	memmove(buf, &fsipcbuf, r);
  80182c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801830:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  801837:	00 
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	89 04 24             	mov    %eax,(%esp)
  80183e:	e8 59 f2 ff ff       	call   800a9c <memmove>
	return r;
}
  801843:	89 d8                	mov    %ebx,%eax
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 20             	sub    $0x20,%esp
  801854:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801857:	89 34 24             	mov    %esi,(%esp)
  80185a:	e8 01 f0 ff ff       	call   800860 <strlen>
		return -E_BAD_PATH;
  80185f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801864:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801869:	7f 5e                	jg     8018c9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80186b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 35 f8 ff ff       	call   8010ab <fd_alloc>
  801876:	89 c3                	mov    %eax,%ebx
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 4d                	js     8018c9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80187c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801880:	c7 04 24 00 50 c0 00 	movl   $0xc05000,(%esp)
  801887:	e8 1f f0 ff ff       	call   8008ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  80188c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188f:	a3 00 54 c0 00       	mov    %eax,0xc05400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801897:	b8 01 00 00 00       	mov    $0x1,%eax
  80189c:	e8 1f fe ff ff       	call   8016c0 <fsipc>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	79 15                	jns    8018bc <open+0x70>
		fd_close(fd, 0);
  8018a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ae:	00 
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	e8 21 f9 ff ff       	call   8011db <fd_close>
		return r;
  8018ba:	eb 0d                	jmp    8018c9 <open+0x7d>
	}

	return fd2num(fd);
  8018bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bf:	89 04 24             	mov    %eax,(%esp)
  8018c2:	e8 b9 f7 ff ff       	call   801080 <fd2num>
  8018c7:	89 c3                	mov    %eax,%ebx
}
  8018c9:	89 d8                	mov    %ebx,%eax
  8018cb:	83 c4 20             	add    $0x20,%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    
	...

008018e0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
  8018e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8018ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	89 04 24             	mov    %eax,(%esp)
  8018f5:	e8 96 f7 ff ff       	call   801090 <fd2data>
  8018fa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8018fc:	c7 44 24 04 4f 27 80 	movl   $0x80274f,0x4(%esp)
  801903:	00 
  801904:	89 34 24             	mov    %esi,(%esp)
  801907:	e8 9f ef ff ff       	call   8008ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80190c:	8b 43 04             	mov    0x4(%ebx),%eax
  80190f:	2b 03                	sub    (%ebx),%eax
  801911:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801917:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80191e:	00 00 00 
	stat->st_dev = &devpipe;
  801921:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801928:	30 80 00 
	return 0;
}
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801933:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801936:	89 ec                	mov    %ebp,%esp
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
  80193e:	83 ec 14             	sub    $0x14,%esp
  801941:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801944:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801948:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80194f:	e8 15 f5 ff ff       	call   800e69 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801954:	89 1c 24             	mov    %ebx,(%esp)
  801957:	e8 34 f7 ff ff       	call   801090 <fd2data>
  80195c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801960:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801967:	e8 fd f4 ff ff       	call   800e69 <sys_page_unmap>
}
  80196c:	83 c4 14             	add    $0x14,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 2c             	sub    $0x2c,%esp
  80197b:	89 c7                	mov    %eax,%edi
  80197d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801980:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801985:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801988:	89 3c 24             	mov    %edi,(%esp)
  80198b:	e8 00 06 00 00       	call   801f90 <pageref>
  801990:	89 c6                	mov    %eax,%esi
  801992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801995:	89 04 24             	mov    %eax,(%esp)
  801998:	e8 f3 05 00 00       	call   801f90 <pageref>
  80199d:	39 c6                	cmp    %eax,%esi
  80199f:	0f 94 c0             	sete   %al
  8019a2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8019a5:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  8019ab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019ae:	39 cb                	cmp    %ecx,%ebx
  8019b0:	75 08                	jne    8019ba <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8019b2:	83 c4 2c             	add    $0x2c,%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5f                   	pop    %edi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8019ba:	83 f8 01             	cmp    $0x1,%eax
  8019bd:	75 c1                	jne    801980 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019bf:	8b 52 58             	mov    0x58(%edx),%edx
  8019c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ce:	c7 04 24 56 27 80 00 	movl   $0x802756,(%esp)
  8019d5:	e8 ad e8 ff ff       	call   800287 <cprintf>
  8019da:	eb a4                	jmp    801980 <_pipeisclosed+0xe>

008019dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	57                   	push   %edi
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 2c             	sub    $0x2c,%esp
  8019e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019e8:	89 34 24             	mov    %esi,(%esp)
  8019eb:	e8 a0 f6 ff ff       	call   801090 <fd2data>
  8019f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019fb:	75 50                	jne    801a4d <devpipe_write+0x71>
  8019fd:	eb 5c                	jmp    801a5b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019ff:	89 da                	mov    %ebx,%edx
  801a01:	89 f0                	mov    %esi,%eax
  801a03:	e8 6a ff ff ff       	call   801972 <_pipeisclosed>
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	75 53                	jne    801a5f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a0c:	e8 6b f3 ff ff       	call   800d7c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a11:	8b 43 04             	mov    0x4(%ebx),%eax
  801a14:	8b 13                	mov    (%ebx),%edx
  801a16:	83 c2 20             	add    $0x20,%edx
  801a19:	39 d0                	cmp    %edx,%eax
  801a1b:	73 e2                	jae    8019ff <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801a24:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801a27:	89 c2                	mov    %eax,%edx
  801a29:	c1 fa 1f             	sar    $0x1f,%edx
  801a2c:	c1 ea 1b             	shr    $0x1b,%edx
  801a2f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a32:	83 e1 1f             	and    $0x1f,%ecx
  801a35:	29 d1                	sub    %edx,%ecx
  801a37:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a3b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a3f:	83 c0 01             	add    $0x1,%eax
  801a42:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a45:	83 c7 01             	add    $0x1,%edi
  801a48:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a4b:	74 0e                	je     801a5b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a4d:	8b 43 04             	mov    0x4(%ebx),%eax
  801a50:	8b 13                	mov    (%ebx),%edx
  801a52:	83 c2 20             	add    $0x20,%edx
  801a55:	39 d0                	cmp    %edx,%eax
  801a57:	73 a6                	jae    8019ff <devpipe_write+0x23>
  801a59:	eb c2                	jmp    801a1d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a5b:	89 f8                	mov    %edi,%eax
  801a5d:	eb 05                	jmp    801a64 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a64:	83 c4 2c             	add    $0x2c,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5f                   	pop    %edi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 28             	sub    $0x28,%esp
  801a72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a78:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a7e:	89 3c 24             	mov    %edi,(%esp)
  801a81:	e8 0a f6 ff ff       	call   801090 <fd2data>
  801a86:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a88:	be 00 00 00 00       	mov    $0x0,%esi
  801a8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a91:	75 47                	jne    801ada <devpipe_read+0x6e>
  801a93:	eb 52                	jmp    801ae7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a95:	89 f0                	mov    %esi,%eax
  801a97:	eb 5e                	jmp    801af7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a99:	89 da                	mov    %ebx,%edx
  801a9b:	89 f8                	mov    %edi,%eax
  801a9d:	8d 76 00             	lea    0x0(%esi),%esi
  801aa0:	e8 cd fe ff ff       	call   801972 <_pipeisclosed>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	75 49                	jne    801af2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801aa9:	e8 ce f2 ff ff       	call   800d7c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801aae:	8b 03                	mov    (%ebx),%eax
  801ab0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ab3:	74 e4                	je     801a99 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ab5:	89 c2                	mov    %eax,%edx
  801ab7:	c1 fa 1f             	sar    $0x1f,%edx
  801aba:	c1 ea 1b             	shr    $0x1b,%edx
  801abd:	01 d0                	add    %edx,%eax
  801abf:	83 e0 1f             	and    $0x1f,%eax
  801ac2:	29 d0                	sub    %edx,%eax
  801ac4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801acf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ad2:	83 c6 01             	add    $0x1,%esi
  801ad5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ad8:	74 0d                	je     801ae7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801ada:	8b 03                	mov    (%ebx),%eax
  801adc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801adf:	75 d4                	jne    801ab5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ae1:	85 f6                	test   %esi,%esi
  801ae3:	75 b0                	jne    801a95 <devpipe_read+0x29>
  801ae5:	eb b2                	jmp    801a99 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ae7:	89 f0                	mov    %esi,%eax
  801ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801af0:	eb 05                	jmp    801af7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801af7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801afa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801afd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b00:	89 ec                	mov    %ebp,%esp
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    

00801b04 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 48             	sub    $0x48,%esp
  801b0a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b0d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b10:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b13:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b16:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b19:	89 04 24             	mov    %eax,(%esp)
  801b1c:	e8 8a f5 ff ff       	call   8010ab <fd_alloc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	85 c0                	test   %eax,%eax
  801b25:	0f 88 45 01 00 00    	js     801c70 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b2b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b32:	00 
  801b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b41:	e8 66 f2 ff ff       	call   800dac <sys_page_alloc>
  801b46:	89 c3                	mov    %eax,%ebx
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	0f 88 20 01 00 00    	js     801c70 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b50:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 50 f5 ff ff       	call   8010ab <fd_alloc>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	0f 88 f8 00 00 00    	js     801c5d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b65:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b6c:	00 
  801b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7b:	e8 2c f2 ff ff       	call   800dac <sys_page_alloc>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	85 c0                	test   %eax,%eax
  801b84:	0f 88 d3 00 00 00    	js     801c5d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b8d:	89 04 24             	mov    %eax,(%esp)
  801b90:	e8 fb f4 ff ff       	call   801090 <fd2data>
  801b95:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b97:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b9e:	00 
  801b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801baa:	e8 fd f1 ff ff       	call   800dac <sys_page_alloc>
  801baf:	89 c3                	mov    %eax,%ebx
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	0f 88 91 00 00 00    	js     801c4a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbc:	89 04 24             	mov    %eax,(%esp)
  801bbf:	e8 cc f4 ff ff       	call   801090 <fd2data>
  801bc4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801bcb:	00 
  801bcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd7:	00 
  801bd8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bdc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be3:	e8 23 f2 ff ff       	call   800e0b <sys_page_map>
  801be8:	89 c3                	mov    %eax,%ebx
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 4c                	js     801c3a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801bee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c03:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c11:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 5d f4 ff ff       	call   801080 <fd2num>
  801c23:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c28:	89 04 24             	mov    %eax,(%esp)
  801c2b:	e8 50 f4 ff ff       	call   801080 <fd2num>
  801c30:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801c33:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c38:	eb 36                	jmp    801c70 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801c3a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c45:	e8 1f f2 ff ff       	call   800e69 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c58:	e8 0c f2 ff ff       	call   800e69 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6b:	e8 f9 f1 ff ff       	call   800e69 <sys_page_unmap>
    err:
	return r;
}
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c7b:	89 ec                	mov    %ebp,%esp
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    

00801c7f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	89 04 24             	mov    %eax,(%esp)
  801c92:	e8 87 f4 ff ff       	call   80111e <fd_lookup>
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 15                	js     801cb0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 ea f3 ff ff       	call   801090 <fd2data>
	return _pipeisclosed(fd, p);
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	e8 c2 fc ff ff       	call   801972 <_pipeisclosed>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    
	...

00801cc0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801cd0:	c7 44 24 04 6e 27 80 	movl   $0x80276e,0x4(%esp)
  801cd7:	00 
  801cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdb:	89 04 24             	mov    %eax,(%esp)
  801cde:	e8 c8 eb ff ff       	call   8008ab <strcpy>
	return 0;
}
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	57                   	push   %edi
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cf6:	be 00 00 00 00       	mov    $0x0,%esi
  801cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cff:	74 43                	je     801d44 <devcons_write+0x5a>
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d06:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d0f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801d11:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d14:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d19:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d1c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d20:	03 45 0c             	add    0xc(%ebp),%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	89 3c 24             	mov    %edi,(%esp)
  801d2a:	e8 6d ed ff ff       	call   800a9c <memmove>
		sys_cputs(buf, m);
  801d2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d33:	89 3c 24             	mov    %edi,(%esp)
  801d36:	e8 55 ef ff ff       	call   800c90 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d3b:	01 de                	add    %ebx,%esi
  801d3d:	89 f0                	mov    %esi,%eax
  801d3f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d42:	72 c8                	jb     801d0c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d44:	89 f0                	mov    %esi,%eax
  801d46:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5f                   	pop    %edi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801d5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d60:	75 07                	jne    801d69 <devcons_read+0x18>
  801d62:	eb 31                	jmp    801d95 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d64:	e8 13 f0 ff ff       	call   800d7c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d70:	e8 4a ef ff ff       	call   800cbf <sys_cgetc>
  801d75:	85 c0                	test   %eax,%eax
  801d77:	74 eb                	je     801d64 <devcons_read+0x13>
  801d79:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 16                	js     801d95 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d7f:	83 f8 04             	cmp    $0x4,%eax
  801d82:	74 0c                	je     801d90 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d87:	88 10                	mov    %dl,(%eax)
	return 1;
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	eb 05                	jmp    801d95 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801da3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801daa:	00 
  801dab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 da ee ff ff       	call   800c90 <sys_cputs>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <getchar>:

int
getchar(void)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801dbe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801dc5:	00 
  801dc6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd4:	e8 05 f6 ff ff       	call   8013de <read>
	if (r < 0)
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 0f                	js     801dec <getchar+0x34>
		return r;
	if (r < 1)
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	7e 06                	jle    801de7 <getchar+0x2f>
		return -E_EOF;
	return c;
  801de1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801de5:	eb 05                	jmp    801dec <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801de7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 18 f3 ff ff       	call   80111e <fd_lookup>
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 11                	js     801e1b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e13:	39 10                	cmp    %edx,(%eax)
  801e15:	0f 94 c0             	sete   %al
  801e18:	0f b6 c0             	movzbl %al,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <opencons>:

int
opencons(void)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 7d f2 ff ff       	call   8010ab <fd_alloc>
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 3c                	js     801e6e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e32:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e39:	00 
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e48:	e8 5f ef ff ff       	call   800dac <sys_page_alloc>
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 1d                	js     801e6e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e51:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 12 f2 ff ff       	call   801080 <fd2num>
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

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
  801e8e:	e8 82 f1 ff ff       	call   801015 <sys_ipc_recv>
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
  801ea1:	a1 20 40 c0 00       	mov    0xc04020,%eax
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
  801f08:	e8 d4 f0 ff ff       	call   800fe1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801f0d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f10:	75 07                	jne    801f19 <ipc_send+0x57>
           sys_yield();
  801f12:	e8 65 ee ff ff       	call   800d7c <sys_yield>
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
  801f22:	c7 44 24 08 7a 27 80 	movl   $0x80277a,0x8(%esp)
  801f29:	00 
  801f2a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f31:	00 
  801f32:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  801f39:	e8 4e e2 ff ff       	call   80018c <_panic>
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
