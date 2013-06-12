
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 1f 01 00 00       	call   800150 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800040:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800047:	00 
  800048:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004f:	00 
  800050:	89 34 24             	mov    %esi,(%esp)
  800053:	e8 f8 13 00 00       	call   801450 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80005a:	a1 04 40 80 00       	mov    0x804004,%eax
  80005f:	8b 40 5c             	mov    0x5c(%eax),%eax
  800062:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800066:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006a:	c7 04 24 00 27 80 00 	movl   $0x802700,(%esp)
  800071:	e8 41 02 00 00       	call   8002b7 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800076:	e8 28 11 00 00       	call   8011a3 <fork>
  80007b:	89 c7                	mov    %eax,%edi
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <primeproc+0x6d>
		panic("fork: %e", id);
  800081:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800085:	c7 44 24 08 d5 2b 80 	movl   $0x802bd5,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 0c 27 80 00 	movl   $0x80270c,(%esp)
  80009c:	e8 1b 01 00 00       	call   8001bc <_panic>
	if (id == 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	74 9b                	je     800040 <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a5:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 34 24             	mov    %esi,(%esp)
  8000bb:	e8 90 13 00 00       	call   801450 <ipc_recv>
  8000c0:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c2:	89 c2                	mov    %eax,%edx
  8000c4:	c1 fa 1f             	sar    $0x1f,%edx
  8000c7:	f7 fb                	idiv   %ebx
  8000c9:	85 d2                	test   %edx,%edx
  8000cb:	74 db                	je     8000a8 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d4:	00 
  8000d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000dc:	00 
  8000dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000e1:	89 3c 24             	mov    %edi,(%esp)
  8000e4:	e8 b9 13 00 00       	call   8014a2 <ipc_send>
  8000e9:	eb bd                	jmp    8000a8 <primeproc+0x74>

008000eb <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000f3:	e8 ab 10 00 00       	call   8011a3 <fork>
  8000f8:	89 c6                	mov    %eax,%esi
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <umain+0x33>
		panic("fork: %e", id);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 d5 2b 80 	movl   $0x802bd5,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 0c 27 80 00 	movl   $0x80270c,(%esp)
  800119:	e8 9e 00 00 00       	call   8001bc <_panic>
	if (id == 0)
  80011e:	bb 02 00 00 00       	mov    $0x2,%ebx
  800123:	85 c0                	test   %eax,%eax
  800125:	75 05                	jne    80012c <umain+0x41>
		primeproc();
  800127:	e8 08 ff ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80013b:	00 
  80013c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800140:	89 34 24             	mov    %esi,(%esp)
  800143:	e8 5a 13 00 00       	call   8014a2 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800148:	83 c3 01             	add    $0x1,%ebx
  80014b:	eb df                	jmp    80012c <umain+0x41>
  80014d:	00 00                	add    %al,(%eax)
	...

00800150 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 18             	sub    $0x18,%esp
  800156:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800159:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80015c:	8b 75 08             	mov    0x8(%ebp),%esi
  80015f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800162:	e8 15 0c 00 00       	call   800d7c <sys_getenvid>
  800167:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800174:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800179:	85 f6                	test   %esi,%esi
  80017b:	7e 07                	jle    800184 <libmain+0x34>
		binaryname = argv[0];
  80017d:	8b 03                	mov    (%ebx),%eax
  80017f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800184:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800188:	89 34 24             	mov    %esi,(%esp)
  80018b:	e8 5b ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  800190:	e8 0b 00 00 00       	call   8001a0 <exit>
}
  800195:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800198:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80019b:	89 ec                	mov    %ebp,%esp
  80019d:	5d                   	pop    %ebp
  80019e:	c3                   	ret    
	...

008001a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a6:	e8 e3 15 00 00       	call   80178e <close_all>
	sys_env_destroy(0);
  8001ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b2:	e8 68 0b 00 00       	call   800d1f <sys_env_destroy>
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    
  8001b9:	00 00                	add    %al,(%eax)
	...

008001bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	56                   	push   %esi
  8001c0:	53                   	push   %ebx
  8001c1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001c4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c7:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001cd:	e8 aa 0b 00 00       	call   800d7c <sys_getenvid>
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e8:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  8001ef:	e8 c3 00 00 00       	call   8002b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 53 00 00 00       	call   800256 <vcprintf>
	cprintf("\n");
  800203:	c7 04 24 fb 2c 80 00 	movl   $0x802cfb,(%esp)
  80020a:	e8 a8 00 00 00       	call   8002b7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020f:	cc                   	int3   
  800210:	eb fd                	jmp    80020f <_panic+0x53>
	...

00800214 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	53                   	push   %ebx
  800218:	83 ec 14             	sub    $0x14,%esp
  80021b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021e:	8b 03                	mov    (%ebx),%eax
  800220:	8b 55 08             	mov    0x8(%ebp),%edx
  800223:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800227:	83 c0 01             	add    $0x1,%eax
  80022a:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80022c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800231:	75 19                	jne    80024c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800233:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80023a:	00 
  80023b:	8d 43 08             	lea    0x8(%ebx),%eax
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	e8 7a 0a 00 00       	call   800cc0 <sys_cputs>
		b->idx = 0;
  800246:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80024c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800250:	83 c4 14             	add    $0x14,%esp
  800253:	5b                   	pop    %ebx
  800254:	5d                   	pop    %ebp
  800255:	c3                   	ret    

00800256 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80025f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800266:	00 00 00 
	b.cnt = 0;
  800269:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800270:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
  800276:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027a:	8b 45 08             	mov    0x8(%ebp),%eax
  80027d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800281:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028b:	c7 04 24 14 02 80 00 	movl   $0x800214,(%esp)
  800292:	e8 a3 01 00 00       	call   80043a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800297:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80029d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a7:	89 04 24             	mov    %eax,(%esp)
  8002aa:	e8 11 0a 00 00       	call   800cc0 <sys_cputs>

	return b.cnt;
}
  8002af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 87 ff ff ff       	call   800256 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    
	...

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002fd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800308:	72 11                	jb     80031b <printnum+0x3b>
  80030a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80030d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800310:	76 09                	jbe    80031b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 eb 01             	sub    $0x1,%ebx
  800315:	85 db                	test   %ebx,%ebx
  800317:	7f 51                	jg     80036a <printnum+0x8a>
  800319:	eb 5e                	jmp    800379 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80031f:	83 eb 01             	sub    $0x1,%ebx
  800322:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800326:	8b 45 10             	mov    0x10(%ebp),%eax
  800329:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800331:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800335:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80033c:	00 
  80033d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800340:	89 04 24             	mov    %eax,(%esp)
  800343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800346:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034a:	e8 f1 20 00 00       	call   802440 <__udivdi3>
  80034f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800353:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800357:	89 04 24             	mov    %eax,(%esp)
  80035a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80035e:	89 fa                	mov    %edi,%edx
  800360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800363:	e8 78 ff ff ff       	call   8002e0 <printnum>
  800368:	eb 0f                	jmp    800379 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80036a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80036e:	89 34 24             	mov    %esi,(%esp)
  800371:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800374:	83 eb 01             	sub    $0x1,%ebx
  800377:	75 f1                	jne    80036a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800379:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800381:	8b 45 10             	mov    0x10(%ebp),%eax
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80038f:	00 
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	89 04 24             	mov    %eax,(%esp)
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039d:	e8 ce 21 00 00       	call   802570 <__umoddi3>
  8003a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a6:	0f be 80 47 27 80 00 	movsbl 0x802747(%eax),%eax
  8003ad:	89 04 24             	mov    %eax,(%esp)
  8003b0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003b3:	83 c4 3c             	add    $0x3c,%esp
  8003b6:	5b                   	pop    %ebx
  8003b7:	5e                   	pop    %esi
  8003b8:	5f                   	pop    %edi
  8003b9:	5d                   	pop    %ebp
  8003ba:	c3                   	ret    

008003bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003be:	83 fa 01             	cmp    $0x1,%edx
  8003c1:	7e 0e                	jle    8003d1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003c3:	8b 10                	mov    (%eax),%edx
  8003c5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003c8:	89 08                	mov    %ecx,(%eax)
  8003ca:	8b 02                	mov    (%edx),%eax
  8003cc:	8b 52 04             	mov    0x4(%edx),%edx
  8003cf:	eb 22                	jmp    8003f3 <getuint+0x38>
	else if (lflag)
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 10                	je     8003e5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003da:	89 08                	mov    %ecx,(%eax)
  8003dc:	8b 02                	mov    (%edx),%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	eb 0e                	jmp    8003f3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003e5:	8b 10                	mov    (%eax),%edx
  8003e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ea:	89 08                	mov    %ecx,(%eax)
  8003ec:	8b 02                	mov    (%edx),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f3:	5d                   	pop    %ebp
  8003f4:	c3                   	ret    

008003f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	3b 50 04             	cmp    0x4(%eax),%edx
  800404:	73 0a                	jae    800410 <sprintputch+0x1b>
		*b->buf++ = ch;
  800406:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800409:	88 0a                	mov    %cl,(%edx)
  80040b:	83 c2 01             	add    $0x1,%edx
  80040e:	89 10                	mov    %edx,(%eax)
}
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800418:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80041f:	8b 45 10             	mov    0x10(%ebp),%eax
  800422:	89 44 24 08          	mov    %eax,0x8(%esp)
  800426:	8b 45 0c             	mov    0xc(%ebp),%eax
  800429:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	e8 02 00 00 00       	call   80043a <vprintfmt>
	va_end(ap);
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	57                   	push   %edi
  80043e:	56                   	push   %esi
  80043f:	53                   	push   %ebx
  800440:	83 ec 4c             	sub    $0x4c,%esp
  800443:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800446:	8b 75 10             	mov    0x10(%ebp),%esi
  800449:	eb 12                	jmp    80045d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80044b:	85 c0                	test   %eax,%eax
  80044d:	0f 84 a9 03 00 00    	je     8007fc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800453:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800457:	89 04 24             	mov    %eax,(%esp)
  80045a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045d:	0f b6 06             	movzbl (%esi),%eax
  800460:	83 c6 01             	add    $0x1,%esi
  800463:	83 f8 25             	cmp    $0x25,%eax
  800466:	75 e3                	jne    80044b <vprintfmt+0x11>
  800468:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80046c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800473:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800478:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80047f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800484:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800487:	eb 2b                	jmp    8004b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800489:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80048c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800490:	eb 22                	jmp    8004b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800495:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800499:	eb 19                	jmp    8004b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80049e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004a5:	eb 0d                	jmp    8004b4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ad:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	0f b6 06             	movzbl (%esi),%eax
  8004b7:	0f b6 d0             	movzbl %al,%edx
  8004ba:	8d 7e 01             	lea    0x1(%esi),%edi
  8004bd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004c0:	83 e8 23             	sub    $0x23,%eax
  8004c3:	3c 55                	cmp    $0x55,%al
  8004c5:	0f 87 0b 03 00 00    	ja     8007d6 <vprintfmt+0x39c>
  8004cb:	0f b6 c0             	movzbl %al,%eax
  8004ce:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d5:	83 ea 30             	sub    $0x30,%edx
  8004d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8004db:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004df:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8004e5:	83 fa 09             	cmp    $0x9,%edx
  8004e8:	77 4a                	ja     800534 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ed:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004f0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8004f3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8004f7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004fd:	83 fa 09             	cmp    $0x9,%edx
  800500:	76 eb                	jbe    8004ed <vprintfmt+0xb3>
  800502:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800505:	eb 2d                	jmp    800534 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 50 04             	lea    0x4(%eax),%edx
  80050d:	89 55 14             	mov    %edx,0x14(%ebp)
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800515:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800518:	eb 1a                	jmp    800534 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80051d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800521:	79 91                	jns    8004b4 <vprintfmt+0x7a>
  800523:	e9 73 ff ff ff       	jmp    80049b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800528:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80052b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800532:	eb 80                	jmp    8004b4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800534:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800538:	0f 89 76 ff ff ff    	jns    8004b4 <vprintfmt+0x7a>
  80053e:	e9 64 ff ff ff       	jmp    8004a7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800543:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800546:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800549:	e9 66 ff ff ff       	jmp    8004b4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8d 50 04             	lea    0x4(%eax),%edx
  800554:	89 55 14             	mov    %edx,0x14(%ebp)
  800557:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800563:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800566:	e9 f2 fe ff ff       	jmp    80045d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 50 04             	lea    0x4(%eax),%edx
  800571:	89 55 14             	mov    %edx,0x14(%ebp)
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 c2                	mov    %eax,%edx
  800578:	c1 fa 1f             	sar    $0x1f,%edx
  80057b:	31 d0                	xor    %edx,%eax
  80057d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057f:	83 f8 0f             	cmp    $0xf,%eax
  800582:	7f 0b                	jg     80058f <vprintfmt+0x155>
  800584:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  80058b:	85 d2                	test   %edx,%edx
  80058d:	75 23                	jne    8005b2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80058f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800593:	c7 44 24 08 5f 27 80 	movl   $0x80275f,0x8(%esp)
  80059a:	00 
  80059b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80059f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005a2:	89 3c 24             	mov    %edi,(%esp)
  8005a5:	e8 68 fe ff ff       	call   800412 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005ad:	e9 ab fe ff ff       	jmp    80045d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8005b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005b6:	c7 44 24 08 c9 2c 80 	movl   $0x802cc9,0x8(%esp)
  8005bd:	00 
  8005be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005c5:	89 3c 24             	mov    %edi,(%esp)
  8005c8:	e8 45 fe ff ff       	call   800412 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005d0:	e9 88 fe ff ff       	jmp    80045d <vprintfmt+0x23>
  8005d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 50 04             	lea    0x4(%eax),%edx
  8005e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005e9:	85 f6                	test   %esi,%esi
  8005eb:	ba 58 27 80 00       	mov    $0x802758,%edx
  8005f0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8005f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f7:	7e 06                	jle    8005ff <vprintfmt+0x1c5>
  8005f9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005fd:	75 10                	jne    80060f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	0f be 06             	movsbl (%esi),%eax
  800602:	83 c6 01             	add    $0x1,%esi
  800605:	85 c0                	test   %eax,%eax
  800607:	0f 85 86 00 00 00    	jne    800693 <vprintfmt+0x259>
  80060d:	eb 76                	jmp    800685 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800613:	89 34 24             	mov    %esi,(%esp)
  800616:	e8 90 02 00 00       	call   8008ab <strnlen>
  80061b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80061e:	29 c2                	sub    %eax,%edx
  800620:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800623:	85 d2                	test   %edx,%edx
  800625:	7e d8                	jle    8005ff <vprintfmt+0x1c5>
					putch(padc, putdat);
  800627:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80062b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80062e:	89 d6                	mov    %edx,%esi
  800630:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800633:	89 c7                	mov    %eax,%edi
  800635:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800639:	89 3c 24             	mov    %edi,(%esp)
  80063c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063f:	83 ee 01             	sub    $0x1,%esi
  800642:	75 f1                	jne    800635 <vprintfmt+0x1fb>
  800644:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800647:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80064a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80064d:	eb b0                	jmp    8005ff <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80064f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800653:	74 18                	je     80066d <vprintfmt+0x233>
  800655:	8d 50 e0             	lea    -0x20(%eax),%edx
  800658:	83 fa 5e             	cmp    $0x5e,%edx
  80065b:	76 10                	jbe    80066d <vprintfmt+0x233>
					putch('?', putdat);
  80065d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800661:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800668:	ff 55 08             	call   *0x8(%ebp)
  80066b:	eb 0a                	jmp    800677 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80066d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800671:	89 04 24             	mov    %eax,(%esp)
  800674:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800677:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80067b:	0f be 06             	movsbl (%esi),%eax
  80067e:	83 c6 01             	add    $0x1,%esi
  800681:	85 c0                	test   %eax,%eax
  800683:	75 0e                	jne    800693 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800685:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800688:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068c:	7f 16                	jg     8006a4 <vprintfmt+0x26a>
  80068e:	e9 ca fd ff ff       	jmp    80045d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800693:	85 ff                	test   %edi,%edi
  800695:	78 b8                	js     80064f <vprintfmt+0x215>
  800697:	83 ef 01             	sub    $0x1,%edi
  80069a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8006a0:	79 ad                	jns    80064f <vprintfmt+0x215>
  8006a2:	eb e1                	jmp    800685 <vprintfmt+0x24b>
  8006a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006a7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006b5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b7:	83 ee 01             	sub    $0x1,%esi
  8006ba:	75 ee                	jne    8006aa <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006bf:	e9 99 fd ff ff       	jmp    80045d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7e 10                	jle    8006d9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 50 08             	lea    0x8(%eax),%edx
  8006cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d2:	8b 30                	mov    (%eax),%esi
  8006d4:	8b 78 04             	mov    0x4(%eax),%edi
  8006d7:	eb 26                	jmp    8006ff <vprintfmt+0x2c5>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	74 12                	je     8006ef <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 50 04             	lea    0x4(%eax),%edx
  8006e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e6:	8b 30                	mov    (%eax),%esi
  8006e8:	89 f7                	mov    %esi,%edi
  8006ea:	c1 ff 1f             	sar    $0x1f,%edi
  8006ed:	eb 10                	jmp    8006ff <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f8:	8b 30                	mov    (%eax),%esi
  8006fa:	89 f7                	mov    %esi,%edi
  8006fc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800704:	85 ff                	test   %edi,%edi
  800706:	0f 89 8c 00 00 00    	jns    800798 <vprintfmt+0x35e>
				putch('-', putdat);
  80070c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800710:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800717:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80071a:	f7 de                	neg    %esi
  80071c:	83 d7 00             	adc    $0x0,%edi
  80071f:	f7 df                	neg    %edi
			}
			base = 10;
  800721:	b8 0a 00 00 00       	mov    $0xa,%eax
  800726:	eb 70                	jmp    800798 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800728:	89 ca                	mov    %ecx,%edx
  80072a:	8d 45 14             	lea    0x14(%ebp),%eax
  80072d:	e8 89 fc ff ff       	call   8003bb <getuint>
  800732:	89 c6                	mov    %eax,%esi
  800734:	89 d7                	mov    %edx,%edi
			base = 10;
  800736:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80073b:	eb 5b                	jmp    800798 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80073d:	89 ca                	mov    %ecx,%edx
  80073f:	8d 45 14             	lea    0x14(%ebp),%eax
  800742:	e8 74 fc ff ff       	call   8003bb <getuint>
  800747:	89 c6                	mov    %eax,%esi
  800749:	89 d7                	mov    %edx,%edi
			base = 8;
  80074b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800750:	eb 46                	jmp    800798 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800752:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800756:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80075d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800764:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80076b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 50 04             	lea    0x4(%eax),%edx
  800774:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800777:	8b 30                	mov    (%eax),%esi
  800779:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80077e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800783:	eb 13                	jmp    800798 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800785:	89 ca                	mov    %ecx,%edx
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	e8 2c fc ff ff       	call   8003bb <getuint>
  80078f:	89 c6                	mov    %eax,%esi
  800791:	89 d7                	mov    %edx,%edi
			base = 16;
  800793:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800798:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80079c:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ab:	89 34 24             	mov    %esi,(%esp)
  8007ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b2:	89 da                	mov    %ebx,%edx
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	e8 24 fb ff ff       	call   8002e0 <printnum>
			break;
  8007bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007bf:	e9 99 fc ff ff       	jmp    80045d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007c8:	89 14 24             	mov    %edx,(%esp)
  8007cb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ce:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007d1:	e9 87 fc ff ff       	jmp    80045d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007e1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007e8:	0f 84 6f fc ff ff    	je     80045d <vprintfmt+0x23>
  8007ee:	83 ee 01             	sub    $0x1,%esi
  8007f1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007f5:	75 f7                	jne    8007ee <vprintfmt+0x3b4>
  8007f7:	e9 61 fc ff ff       	jmp    80045d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8007fc:	83 c4 4c             	add    $0x4c,%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5f                   	pop    %edi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 28             	sub    $0x28,%esp
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800810:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800813:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800817:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800821:	85 c0                	test   %eax,%eax
  800823:	74 30                	je     800855 <vsnprintf+0x51>
  800825:	85 d2                	test   %edx,%edx
  800827:	7e 2c                	jle    800855 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800830:	8b 45 10             	mov    0x10(%ebp),%eax
  800833:	89 44 24 08          	mov    %eax,0x8(%esp)
  800837:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80083a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083e:	c7 04 24 f5 03 80 00 	movl   $0x8003f5,(%esp)
  800845:	e8 f0 fb ff ff       	call   80043a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800853:	eb 05                	jmp    80085a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800865:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800869:	8b 45 10             	mov    0x10(%ebp),%eax
  80086c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800870:	8b 45 0c             	mov    0xc(%ebp),%eax
  800873:	89 44 24 04          	mov    %eax,0x4(%esp)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	89 04 24             	mov    %eax,(%esp)
  80087d:	e8 82 ff ff ff       	call   800804 <vsnprintf>
	va_end(ap);

	return rc;
}
  800882:	c9                   	leave  
  800883:	c3                   	ret    
	...

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	80 3a 00             	cmpb   $0x0,(%edx)
  80089e:	74 09                	je     8008a9 <strlen+0x19>
		n++;
  8008a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a7:	75 f7                	jne    8008a0 <strlen+0x10>
		n++;
	return n;
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	85 c9                	test   %ecx,%ecx
  8008bc:	74 1a                	je     8008d8 <strnlen+0x2d>
  8008be:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008c1:	74 15                	je     8008d8 <strnlen+0x2d>
  8008c3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008c8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ca:	39 ca                	cmp    %ecx,%edx
  8008cc:	74 0a                	je     8008d8 <strnlen+0x2d>
  8008ce:	83 c2 01             	add    $0x1,%edx
  8008d1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008d6:	75 f0                	jne    8008c8 <strnlen+0x1d>
		n++;
	return n;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f1:	83 c2 01             	add    $0x1,%edx
  8008f4:	84 c9                	test   %cl,%cl
  8008f6:	75 f2                	jne    8008ea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f8:	5b                   	pop    %ebx
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800905:	89 1c 24             	mov    %ebx,(%esp)
  800908:	e8 83 ff ff ff       	call   800890 <strlen>
	strcpy(dst + len, src);
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	89 54 24 04          	mov    %edx,0x4(%esp)
  800914:	01 d8                	add    %ebx,%eax
  800916:	89 04 24             	mov    %eax,(%esp)
  800919:	e8 bd ff ff ff       	call   8008db <strcpy>
	return dst;
}
  80091e:	89 d8                	mov    %ebx,%eax
  800920:	83 c4 08             	add    $0x8,%esp
  800923:	5b                   	pop    %ebx
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	56                   	push   %esi
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800931:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800934:	85 f6                	test   %esi,%esi
  800936:	74 18                	je     800950 <strncpy+0x2a>
  800938:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80093d:	0f b6 1a             	movzbl (%edx),%ebx
  800940:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800943:	80 3a 01             	cmpb   $0x1,(%edx)
  800946:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800949:	83 c1 01             	add    $0x1,%ecx
  80094c:	39 f1                	cmp    %esi,%ecx
  80094e:	75 ed                	jne    80093d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	57                   	push   %edi
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800960:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800963:	89 f8                	mov    %edi,%eax
  800965:	85 f6                	test   %esi,%esi
  800967:	74 2b                	je     800994 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800969:	83 fe 01             	cmp    $0x1,%esi
  80096c:	74 23                	je     800991 <strlcpy+0x3d>
  80096e:	0f b6 0b             	movzbl (%ebx),%ecx
  800971:	84 c9                	test   %cl,%cl
  800973:	74 1c                	je     800991 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800975:	83 ee 02             	sub    $0x2,%esi
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80097d:	88 08                	mov    %cl,(%eax)
  80097f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 f2                	cmp    %esi,%edx
  800984:	74 0b                	je     800991 <strlcpy+0x3d>
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098d:	84 c9                	test   %cl,%cl
  80098f:	75 ec                	jne    80097d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800991:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800994:	29 f8                	sub    %edi,%eax
}
  800996:	5b                   	pop    %ebx
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a4:	0f b6 01             	movzbl (%ecx),%eax
  8009a7:	84 c0                	test   %al,%al
  8009a9:	74 16                	je     8009c1 <strcmp+0x26>
  8009ab:	3a 02                	cmp    (%edx),%al
  8009ad:	75 12                	jne    8009c1 <strcmp+0x26>
		p++, q++;
  8009af:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009b2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 07                	je     8009c1 <strcmp+0x26>
  8009ba:	83 c1 01             	add    $0x1,%ecx
  8009bd:	3a 02                	cmp    (%edx),%al
  8009bf:	74 ee                	je     8009af <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	0f b6 12             	movzbl (%edx),%edx
  8009c7:	29 d0                	sub    %edx,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009dd:	85 d2                	test   %edx,%edx
  8009df:	74 28                	je     800a09 <strncmp+0x3e>
  8009e1:	0f b6 01             	movzbl (%ecx),%eax
  8009e4:	84 c0                	test   %al,%al
  8009e6:	74 24                	je     800a0c <strncmp+0x41>
  8009e8:	3a 03                	cmp    (%ebx),%al
  8009ea:	75 20                	jne    800a0c <strncmp+0x41>
  8009ec:	83 ea 01             	sub    $0x1,%edx
  8009ef:	74 13                	je     800a04 <strncmp+0x39>
		n--, p++, q++;
  8009f1:	83 c1 01             	add    $0x1,%ecx
  8009f4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009f7:	0f b6 01             	movzbl (%ecx),%eax
  8009fa:	84 c0                	test   %al,%al
  8009fc:	74 0e                	je     800a0c <strncmp+0x41>
  8009fe:	3a 03                	cmp    (%ebx),%al
  800a00:	74 ea                	je     8009ec <strncmp+0x21>
  800a02:	eb 08                	jmp    800a0c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 01             	movzbl (%ecx),%eax
  800a0f:	0f b6 13             	movzbl (%ebx),%edx
  800a12:	29 d0                	sub    %edx,%eax
  800a14:	eb f3                	jmp    800a09 <strncmp+0x3e>

00800a16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a20:	0f b6 10             	movzbl (%eax),%edx
  800a23:	84 d2                	test   %dl,%dl
  800a25:	74 1c                	je     800a43 <strchr+0x2d>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	75 09                	jne    800a34 <strchr+0x1e>
  800a2b:	eb 1b                	jmp    800a48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 14                	je     800a48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a34:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800a38:	84 d2                	test   %dl,%dl
  800a3a:	75 f1                	jne    800a2d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	eb 05                	jmp    800a48 <strchr+0x32>
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	0f b6 10             	movzbl (%eax),%edx
  800a57:	84 d2                	test   %dl,%dl
  800a59:	74 14                	je     800a6f <strfind+0x25>
		if (*s == c)
  800a5b:	38 ca                	cmp    %cl,%dl
  800a5d:	75 06                	jne    800a65 <strfind+0x1b>
  800a5f:	eb 0e                	jmp    800a6f <strfind+0x25>
  800a61:	38 ca                	cmp    %cl,%dl
  800a63:	74 0a                	je     800a6f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	0f b6 10             	movzbl (%eax),%edx
  800a6b:	84 d2                	test   %dl,%dl
  800a6d:	75 f2                	jne    800a61 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a7a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a7d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a89:	85 c9                	test   %ecx,%ecx
  800a8b:	74 30                	je     800abd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a93:	75 25                	jne    800aba <memset+0x49>
  800a95:	f6 c1 03             	test   $0x3,%cl
  800a98:	75 20                	jne    800aba <memset+0x49>
		c &= 0xFF;
  800a9a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9d:	89 d3                	mov    %edx,%ebx
  800a9f:	c1 e3 08             	shl    $0x8,%ebx
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	c1 e6 18             	shl    $0x18,%esi
  800aa7:	89 d0                	mov    %edx,%eax
  800aa9:	c1 e0 10             	shl    $0x10,%eax
  800aac:	09 f0                	or     %esi,%eax
  800aae:	09 d0                	or     %edx,%eax
  800ab0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ab5:	fc                   	cld    
  800ab6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab8:	eb 03                	jmp    800abd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aba:	fc                   	cld    
  800abb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abd:	89 f8                	mov    %edi,%eax
  800abf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ac2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ac5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ac8:	89 ec                	mov    %ebp,%esp
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ad5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ade:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae1:	39 c6                	cmp    %eax,%esi
  800ae3:	73 36                	jae    800b1b <memmove+0x4f>
  800ae5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae8:	39 d0                	cmp    %edx,%eax
  800aea:	73 2f                	jae    800b1b <memmove+0x4f>
		s += n;
		d += n;
  800aec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aef:	f6 c2 03             	test   $0x3,%dl
  800af2:	75 1b                	jne    800b0f <memmove+0x43>
  800af4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800afa:	75 13                	jne    800b0f <memmove+0x43>
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 0e                	jne    800b0f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b01:	83 ef 04             	sub    $0x4,%edi
  800b04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0a:	fd                   	std    
  800b0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0d:	eb 09                	jmp    800b18 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0f:	83 ef 01             	sub    $0x1,%edi
  800b12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b15:	fd                   	std    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b18:	fc                   	cld    
  800b19:	eb 20                	jmp    800b3b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b21:	75 13                	jne    800b36 <memmove+0x6a>
  800b23:	a8 03                	test   $0x3,%al
  800b25:	75 0f                	jne    800b36 <memmove+0x6a>
  800b27:	f6 c1 03             	test   $0x3,%cl
  800b2a:	75 0a                	jne    800b36 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	fc                   	cld    
  800b32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b34:	eb 05                	jmp    800b3b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b36:	89 c7                	mov    %eax,%edi
  800b38:	fc                   	cld    
  800b39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b41:	89 ec                	mov    %ebp,%esp
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 04 24             	mov    %eax,(%esp)
  800b5f:	e8 68 ff ff ff       	call   800acc <memmove>
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b72:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7a:	85 ff                	test   %edi,%edi
  800b7c:	74 37                	je     800bb5 <memcmp+0x4f>
		if (*s1 != *s2)
  800b7e:	0f b6 03             	movzbl (%ebx),%eax
  800b81:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b8c:	38 c8                	cmp    %cl,%al
  800b8e:	74 1c                	je     800bac <memcmp+0x46>
  800b90:	eb 10                	jmp    800ba2 <memcmp+0x3c>
  800b92:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b97:	83 c2 01             	add    $0x1,%edx
  800b9a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b9e:	38 c8                	cmp    %cl,%al
  800ba0:	74 0a                	je     800bac <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800ba2:	0f b6 c0             	movzbl %al,%eax
  800ba5:	0f b6 c9             	movzbl %cl,%ecx
  800ba8:	29 c8                	sub    %ecx,%eax
  800baa:	eb 09                	jmp    800bb5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bac:	39 fa                	cmp    %edi,%edx
  800bae:	75 e2                	jne    800b92 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800bc0:	89 c2                	mov    %eax,%edx
  800bc2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc5:	39 d0                	cmp    %edx,%eax
  800bc7:	73 19                	jae    800be2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800bcd:	38 08                	cmp    %cl,(%eax)
  800bcf:	75 06                	jne    800bd7 <memfind+0x1d>
  800bd1:	eb 0f                	jmp    800be2 <memfind+0x28>
  800bd3:	38 08                	cmp    %cl,(%eax)
  800bd5:	74 0b                	je     800be2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	39 d0                	cmp    %edx,%eax
  800bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800be0:	75 f1                	jne    800bd3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
  800bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf0:	0f b6 02             	movzbl (%edx),%eax
  800bf3:	3c 20                	cmp    $0x20,%al
  800bf5:	74 04                	je     800bfb <strtol+0x17>
  800bf7:	3c 09                	cmp    $0x9,%al
  800bf9:	75 0e                	jne    800c09 <strtol+0x25>
		s++;
  800bfb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfe:	0f b6 02             	movzbl (%edx),%eax
  800c01:	3c 20                	cmp    $0x20,%al
  800c03:	74 f6                	je     800bfb <strtol+0x17>
  800c05:	3c 09                	cmp    $0x9,%al
  800c07:	74 f2                	je     800bfb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c09:	3c 2b                	cmp    $0x2b,%al
  800c0b:	75 0a                	jne    800c17 <strtol+0x33>
		s++;
  800c0d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c10:	bf 00 00 00 00       	mov    $0x0,%edi
  800c15:	eb 10                	jmp    800c27 <strtol+0x43>
  800c17:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c1c:	3c 2d                	cmp    $0x2d,%al
  800c1e:	75 07                	jne    800c27 <strtol+0x43>
		s++, neg = 1;
  800c20:	83 c2 01             	add    $0x1,%edx
  800c23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c27:	85 db                	test   %ebx,%ebx
  800c29:	0f 94 c0             	sete   %al
  800c2c:	74 05                	je     800c33 <strtol+0x4f>
  800c2e:	83 fb 10             	cmp    $0x10,%ebx
  800c31:	75 15                	jne    800c48 <strtol+0x64>
  800c33:	80 3a 30             	cmpb   $0x30,(%edx)
  800c36:	75 10                	jne    800c48 <strtol+0x64>
  800c38:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c3c:	75 0a                	jne    800c48 <strtol+0x64>
		s += 2, base = 16;
  800c3e:	83 c2 02             	add    $0x2,%edx
  800c41:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c46:	eb 13                	jmp    800c5b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 0f                	je     800c5b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c4c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c51:	80 3a 30             	cmpb   $0x30,(%edx)
  800c54:	75 05                	jne    800c5b <strtol+0x77>
		s++, base = 8;
  800c56:	83 c2 01             	add    $0x1,%edx
  800c59:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c60:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c62:	0f b6 0a             	movzbl (%edx),%ecx
  800c65:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c68:	80 fb 09             	cmp    $0x9,%bl
  800c6b:	77 08                	ja     800c75 <strtol+0x91>
			dig = *s - '0';
  800c6d:	0f be c9             	movsbl %cl,%ecx
  800c70:	83 e9 30             	sub    $0x30,%ecx
  800c73:	eb 1e                	jmp    800c93 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c75:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c78:	80 fb 19             	cmp    $0x19,%bl
  800c7b:	77 08                	ja     800c85 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c7d:	0f be c9             	movsbl %cl,%ecx
  800c80:	83 e9 57             	sub    $0x57,%ecx
  800c83:	eb 0e                	jmp    800c93 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c85:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c88:	80 fb 19             	cmp    $0x19,%bl
  800c8b:	77 14                	ja     800ca1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c8d:	0f be c9             	movsbl %cl,%ecx
  800c90:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c93:	39 f1                	cmp    %esi,%ecx
  800c95:	7d 0e                	jge    800ca5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c97:	83 c2 01             	add    $0x1,%edx
  800c9a:	0f af c6             	imul   %esi,%eax
  800c9d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c9f:	eb c1                	jmp    800c62 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800ca1:	89 c1                	mov    %eax,%ecx
  800ca3:	eb 02                	jmp    800ca7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cab:	74 05                	je     800cb2 <strtol+0xce>
		*endptr = (char *) s;
  800cad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cb0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cb2:	89 ca                	mov    %ecx,%edx
  800cb4:	f7 da                	neg    %edx
  800cb6:	85 ff                	test   %edi,%edi
  800cb8:	0f 45 c2             	cmovne %edx,%eax
}
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 0c             	sub    $0xc,%esp
  800cc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ccc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	89 c3                	mov    %eax,%ebx
  800cdc:	89 c7                	mov    %eax,%edi
  800cde:	89 c6                	mov    %eax,%esi
  800ce0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ceb:	89 ec                	mov    %ebp,%esp
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_cgetc>:

int
sys_cgetc(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 0c             	sub    $0xc,%esp
  800cf5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cfb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800d03:	b8 01 00 00 00       	mov    $0x1,%eax
  800d08:	89 d1                	mov    %edx,%ecx
  800d0a:	89 d3                	mov    %edx,%ebx
  800d0c:	89 d7                	mov    %edx,%edi
  800d0e:	89 d6                	mov    %edx,%esi
  800d10:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d15:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d18:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d1b:	89 ec                	mov    %ebp,%esp
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 38             	sub    $0x38,%esp
  800d25:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d28:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d2b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d33:	b8 03 00 00 00       	mov    $0x3,%eax
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	89 cb                	mov    %ecx,%ebx
  800d3d:	89 cf                	mov    %ecx,%edi
  800d3f:	89 ce                	mov    %ecx,%esi
  800d41:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7e 28                	jle    800d6f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d47:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d52:	00 
  800d53:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800d5a:	00 
  800d5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d62:	00 
  800d63:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800d6a:	e8 4d f4 ff ff       	call   8001bc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d78:	89 ec                	mov    %ebp,%esp
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800d90:	b8 02 00 00 00       	mov    $0x2,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da8:	89 ec                	mov    %ebp,%esp
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_yield>:

void
sys_yield(void)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dcf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd8:	89 ec                	mov    %ebp,%esp
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 38             	sub    $0x38,%esp
  800de2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800deb:	be 00 00 00 00       	mov    $0x0,%esi
  800df0:	b8 04 00 00 00       	mov    $0x4,%eax
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	89 f7                	mov    %esi,%edi
  800e00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 28                	jle    800e2e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e11:	00 
  800e12:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800e29:	e8 8e f3 ff ff       	call   8001bc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e31:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e34:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e37:	89 ec                	mov    %ebp,%esp
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 38             	sub    $0x38,%esp
  800e41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e47:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e4f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7e 28                	jle    800e8c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e68:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e6f:	00 
  800e70:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800e77:	00 
  800e78:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7f:	00 
  800e80:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800e87:	e8 30 f3 ff ff       	call   8001bc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e8c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e92:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e95:	89 ec                	mov    %ebp,%esp
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 38             	sub    $0x38,%esp
  800e9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7e 28                	jle    800eea <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ecd:	00 
  800ece:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800ed5:	00 
  800ed6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edd:	00 
  800ede:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800ee5:	e8 d2 f2 ff ff       	call   8001bc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef3:	89 ec                	mov    %ebp,%esp
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 38             	sub    $0x38,%esp
  800efd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f03:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	89 de                	mov    %ebx,%esi
  800f1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7e 28                	jle    800f48 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f33:	00 
  800f34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3b:	00 
  800f3c:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800f43:	e8 74 f2 ff ff       	call   8001bc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f51:	89 ec                	mov    %ebp,%esp
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7e 28                	jle    800fa6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f82:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f89:	00 
  800f8a:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f91:	00 
  800f92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f99:	00 
  800f9a:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800fa1:	e8 16 f2 ff ff       	call   8001bc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fa6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800faf:	89 ec                	mov    %ebp,%esp
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 38             	sub    $0x38,%esp
  800fb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	89 df                	mov    %ebx,%edi
  800fd4:	89 de                	mov    %ebx,%esi
  800fd6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	7e 28                	jle    801004 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800fff:	e8 b8 f1 ff ff       	call   8001bc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801004:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801007:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100d:	89 ec                	mov    %ebp,%esp
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801038:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80103b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80103e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801041:	89 ec                	mov    %ebp,%esp
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 38             	sub    $0x38,%esp
  80104b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80104e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801051:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801054:	b9 00 00 00 00       	mov    $0x0,%ecx
  801059:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105e:	8b 55 08             	mov    0x8(%ebp),%edx
  801061:	89 cb                	mov    %ecx,%ebx
  801063:	89 cf                	mov    %ecx,%edi
  801065:	89 ce                	mov    %ecx,%esi
  801067:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  801090:	e8 27 f1 ff ff       	call   8001bc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801095:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801098:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80109b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80109e:	89 ec                	mov    %ebp,%esp
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    
	...

008010a4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	53                   	push   %ebx
  8010a8:	83 ec 24             	sub    $0x24,%esp
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010ae:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  8010b0:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010b4:	74 21                	je     8010d7 <pgfault+0x33>
  8010b6:	89 d8                	mov    %ebx,%eax
  8010b8:	c1 e8 16             	shr    $0x16,%eax
  8010bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c2:	a8 01                	test   $0x1,%al
  8010c4:	74 11                	je     8010d7 <pgfault+0x33>
  8010c6:	89 d8                	mov    %ebx,%eax
  8010c8:	c1 e8 0c             	shr    $0xc,%eax
  8010cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d2:	f6 c4 08             	test   $0x8,%ah
  8010d5:	75 1c                	jne    8010f3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  8010d7:	c7 44 24 08 6c 2a 80 	movl   $0x802a6c,0x8(%esp)
  8010de:	00 
  8010df:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8010e6:	00 
  8010e7:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8010ee:	e8 c9 f0 ff ff       	call   8001bc <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8010f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010fa:	00 
  8010fb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801102:	00 
  801103:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80110a:	e8 cd fc ff ff       	call   800ddc <sys_page_alloc>
  80110f:	85 c0                	test   %eax,%eax
  801111:	79 20                	jns    801133 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801117:	c7 44 24 08 a8 2a 80 	movl   $0x802aa8,0x8(%esp)
  80111e:	00 
  80111f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801126:	00 
  801127:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80112e:	e8 89 f0 ff ff       	call   8001bc <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801133:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801139:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801140:	00 
  801141:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801145:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80114c:	e8 7b f9 ff ff       	call   800acc <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801151:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801158:	00 
  801159:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80115d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801164:	00 
  801165:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80116c:	00 
  80116d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801174:	e8 c2 fc ff ff       	call   800e3b <sys_page_map>
  801179:	85 c0                	test   %eax,%eax
  80117b:	79 20                	jns    80119d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80117d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801181:	c7 44 24 08 d0 2a 80 	movl   $0x802ad0,0x8(%esp)
  801188:	00 
  801189:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801190:	00 
  801191:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801198:	e8 1f f0 ff ff       	call   8001bc <_panic>
	//panic("pgfault not implemented");
}
  80119d:	83 c4 24             	add    $0x24,%esp
  8011a0:	5b                   	pop    %ebx
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  8011ac:	c7 04 24 a4 10 80 00 	movl   $0x8010a4,(%esp)
  8011b3:	e8 a8 11 00 00       	call   802360 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011b8:	ba 07 00 00 00       	mov    $0x7,%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	cd 30                	int    $0x30
  8011c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011c4:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	79 20                	jns    8011ea <fork+0x47>
		panic("sys_exofork: %e", envid);
  8011ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ce:	c7 44 24 08 ce 2b 80 	movl   $0x802bce,0x8(%esp)
  8011d5:	00 
  8011d6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  8011dd:	00 
  8011de:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8011e5:	e8 d2 ef ff ff       	call   8001bc <_panic>
	if (envid == 0) {
  8011ea:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8011ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011f3:	75 1c                	jne    801211 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011f5:	e8 82 fb ff ff       	call   800d7c <sys_getenvid>
  8011fa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011ff:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801202:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801207:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80120c:	e9 06 02 00 00       	jmp    801417 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801211:	89 d8                	mov    %ebx,%eax
  801213:	c1 e8 16             	shr    $0x16,%eax
  801216:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121d:	a8 01                	test   $0x1,%al
  80121f:	0f 84 57 01 00 00    	je     80137c <fork+0x1d9>
  801225:	89 de                	mov    %ebx,%esi
  801227:	c1 ee 0c             	shr    $0xc,%esi
  80122a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801231:	a8 01                	test   $0x1,%al
  801233:	0f 84 43 01 00 00    	je     80137c <fork+0x1d9>
  801239:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801240:	a8 04                	test   $0x4,%al
  801242:	0f 84 34 01 00 00    	je     80137c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801248:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80124b:	89 f0                	mov    %esi,%eax
  80124d:	c1 e8 0c             	shr    $0xc,%eax
  801250:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801257:	f6 c4 04             	test   $0x4,%ah
  80125a:	74 45                	je     8012a1 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80125c:	25 07 0e 00 00       	and    $0xe07,%eax
  801261:	89 44 24 10          	mov    %eax,0x10(%esp)
  801265:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801269:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80126d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801278:	e8 be fb ff ff       	call   800e3b <sys_page_map>
  80127d:	85 c0                	test   %eax,%eax
  80127f:	0f 89 f7 00 00 00    	jns    80137c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801285:	c7 44 24 08 de 2b 80 	movl   $0x802bde,0x8(%esp)
  80128c:	00 
  80128d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801294:	00 
  801295:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80129c:	e8 1b ef ff ff       	call   8001bc <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  8012a1:	a9 02 08 00 00       	test   $0x802,%eax
  8012a6:	0f 84 8c 00 00 00    	je     801338 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8012ac:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012b3:	00 
  8012b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012b8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c7:	e8 6f fb ff ff       	call   800e3b <sys_page_map>
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	79 20                	jns    8012f0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  8012d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012d4:	c7 44 24 08 f4 2a 80 	movl   $0x802af4,0x8(%esp)
  8012db:	00 
  8012dc:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8012e3:	00 
  8012e4:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8012eb:	e8 cc ee ff ff       	call   8001bc <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8012f0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012f7:	00 
  8012f8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801303:	00 
  801304:	89 74 24 04          	mov    %esi,0x4(%esp)
  801308:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130f:	e8 27 fb ff ff       	call   800e3b <sys_page_map>
  801314:	85 c0                	test   %eax,%eax
  801316:	79 64                	jns    80137c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801318:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80131c:	c7 44 24 08 20 2b 80 	movl   $0x802b20,0x8(%esp)
  801323:	00 
  801324:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80132b:	00 
  80132c:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801333:	e8 84 ee ff ff       	call   8001bc <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801338:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80133f:	00 
  801340:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801344:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801348:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801353:	e8 e3 fa ff ff       	call   800e3b <sys_page_map>
  801358:	85 c0                	test   %eax,%eax
  80135a:	79 20                	jns    80137c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80135c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801360:	c7 44 24 08 4c 2b 80 	movl   $0x802b4c,0x8(%esp)
  801367:	00 
  801368:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80136f:	00 
  801370:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801377:	e8 40 ee ff ff       	call   8001bc <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80137c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801382:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801388:	0f 85 83 fe ff ff    	jne    801211 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80138e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801395:	00 
  801396:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80139d:	ee 
  80139e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a1:	89 04 24             	mov    %eax,(%esp)
  8013a4:	e8 33 fa ff ff       	call   800ddc <sys_page_alloc>
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	79 20                	jns    8013cd <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  8013ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b1:	c7 44 24 08 78 2b 80 	movl   $0x802b78,0x8(%esp)
  8013b8:	00 
  8013b9:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8013c0:	00 
  8013c1:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8013c8:	e8 ef ed ff ff       	call   8001bc <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  8013cd:	c7 44 24 04 d0 23 80 	movl   $0x8023d0,0x4(%esp)
  8013d4:	00 
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	89 04 24             	mov    %eax,(%esp)
  8013db:	e8 d3 fb ff ff       	call   800fb3 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013e7:	00 
  8013e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013eb:	89 04 24             	mov    %eax,(%esp)
  8013ee:	e8 04 fb ff ff       	call   800ef7 <sys_env_set_status>
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	79 20                	jns    801417 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8013f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fb:	c7 44 24 08 9c 2b 80 	movl   $0x802b9c,0x8(%esp)
  801402:	00 
  801403:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80140a:	00 
  80140b:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801412:	e8 a5 ed ff ff       	call   8001bc <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141a:	83 c4 3c             	add    $0x3c,%esp
  80141d:	5b                   	pop    %ebx
  80141e:	5e                   	pop    %esi
  80141f:	5f                   	pop    %edi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <sfork>:

// Challenge!
int
sfork(void)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801428:	c7 44 24 08 f5 2b 80 	movl   $0x802bf5,0x8(%esp)
  80142f:	00 
  801430:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801437:	00 
  801438:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80143f:	e8 78 ed ff ff       	call   8001bc <_panic>
	...

00801450 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	56                   	push   %esi
  801454:	53                   	push   %ebx
  801455:	83 ec 10             	sub    $0x10,%esp
  801458:	8b 75 08             	mov    0x8(%ebp),%esi
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801461:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801463:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801468:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80146b:	89 04 24             	mov    %eax,(%esp)
  80146e:	e8 d2 fb ff ff       	call   801045 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801478:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 0e                	js     80148f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801481:	a1 04 40 80 00       	mov    0x804004,%eax
  801486:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801489:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80148c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80148f:	85 f6                	test   %esi,%esi
  801491:	74 02                	je     801495 <ipc_recv+0x45>
		*from_env_store = sender;
  801493:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801495:	85 db                	test   %ebx,%ebx
  801497:	74 02                	je     80149b <ipc_recv+0x4b>
		*perm_store = perm;
  801499:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	57                   	push   %edi
  8014a6:	56                   	push   %esi
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 1c             	sub    $0x1c,%esp
  8014ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8014ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014b1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8014b4:	85 db                	test   %ebx,%ebx
  8014b6:	75 04                	jne    8014bc <ipc_send+0x1a>
  8014b8:	85 f6                	test   %esi,%esi
  8014ba:	75 15                	jne    8014d1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8014bc:	85 db                	test   %ebx,%ebx
  8014be:	74 16                	je     8014d6 <ipc_send+0x34>
  8014c0:	85 f6                	test   %esi,%esi
  8014c2:	0f 94 c0             	sete   %al
      pg = 0;
  8014c5:	84 c0                	test   %al,%al
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cc:	0f 45 d8             	cmovne %eax,%ebx
  8014cf:	eb 05                	jmp    8014d6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8014d1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8014d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	89 04 24             	mov    %eax,(%esp)
  8014e8:	e8 24 fb ff ff       	call   801011 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8014ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014f0:	75 07                	jne    8014f9 <ipc_send+0x57>
           sys_yield();
  8014f2:	e8 b5 f8 ff ff       	call   800dac <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8014f7:	eb dd                	jmp    8014d6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	90                   	nop
  8014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801500:	74 1c                	je     80151e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801502:	c7 44 24 08 0b 2c 80 	movl   $0x802c0b,0x8(%esp)
  801509:	00 
  80150a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801511:	00 
  801512:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  801519:	e8 9e ec ff ff       	call   8001bc <_panic>
		}
    }
}
  80151e:	83 c4 1c             	add    $0x1c,%esp
  801521:	5b                   	pop    %ebx
  801522:	5e                   	pop    %esi
  801523:	5f                   	pop    %edi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    

00801526 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80152c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801531:	39 c8                	cmp    %ecx,%eax
  801533:	74 17                	je     80154c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801535:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80153a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80153d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801543:	8b 52 50             	mov    0x50(%edx),%edx
  801546:	39 ca                	cmp    %ecx,%edx
  801548:	75 14                	jne    80155e <ipc_find_env+0x38>
  80154a:	eb 05                	jmp    801551 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801551:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801554:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801559:	8b 40 40             	mov    0x40(%eax),%eax
  80155c:	eb 0e                	jmp    80156c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80155e:	83 c0 01             	add    $0x1,%eax
  801561:	3d 00 04 00 00       	cmp    $0x400,%eax
  801566:	75 d2                	jne    80153a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801568:	66 b8 00 00          	mov    $0x0,%ax
}
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
	...

00801570 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	05 00 00 00 30       	add    $0x30000000,%eax
  80157b:	c1 e8 0c             	shr    $0xc,%eax
}
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	89 04 24             	mov    %eax,(%esp)
  80158c:	e8 df ff ff ff       	call   801570 <fd2num>
  801591:	05 20 00 0d 00       	add    $0xd0020,%eax
  801596:	c1 e0 0c             	shl    $0xc,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	53                   	push   %ebx
  80159f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015a2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8015a7:	a8 01                	test   $0x1,%al
  8015a9:	74 34                	je     8015df <fd_alloc+0x44>
  8015ab:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8015b0:	a8 01                	test   $0x1,%al
  8015b2:	74 32                	je     8015e6 <fd_alloc+0x4b>
  8015b4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015b9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	c1 ea 16             	shr    $0x16,%edx
  8015c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015c7:	f6 c2 01             	test   $0x1,%dl
  8015ca:	74 1f                	je     8015eb <fd_alloc+0x50>
  8015cc:	89 c2                	mov    %eax,%edx
  8015ce:	c1 ea 0c             	shr    $0xc,%edx
  8015d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015d8:	f6 c2 01             	test   $0x1,%dl
  8015db:	75 17                	jne    8015f4 <fd_alloc+0x59>
  8015dd:	eb 0c                	jmp    8015eb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015df:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8015e4:	eb 05                	jmp    8015eb <fd_alloc+0x50>
  8015e6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8015eb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	eb 17                	jmp    80160b <fd_alloc+0x70>
  8015f4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015fe:	75 b9                	jne    8015b9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801600:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801606:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80160b:	5b                   	pop    %ebx
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801614:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801619:	83 fa 1f             	cmp    $0x1f,%edx
  80161c:	77 3f                	ja     80165d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80161e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801624:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801627:	89 d0                	mov    %edx,%eax
  801629:	c1 e8 16             	shr    $0x16,%eax
  80162c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801633:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801638:	f6 c1 01             	test   $0x1,%cl
  80163b:	74 20                	je     80165d <fd_lookup+0x4f>
  80163d:	89 d0                	mov    %edx,%eax
  80163f:	c1 e8 0c             	shr    $0xc,%eax
  801642:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801649:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80164e:	f6 c1 01             	test   $0x1,%cl
  801651:	74 0a                	je     80165d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	89 10                	mov    %edx,(%eax)
	return 0;
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    

0080165f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	53                   	push   %ebx
  801663:	83 ec 14             	sub    $0x14,%esp
  801666:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801671:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801677:	75 17                	jne    801690 <dev_lookup+0x31>
  801679:	eb 07                	jmp    801682 <dev_lookup+0x23>
  80167b:	39 0a                	cmp    %ecx,(%edx)
  80167d:	75 11                	jne    801690 <dev_lookup+0x31>
  80167f:	90                   	nop
  801680:	eb 05                	jmp    801687 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801682:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801687:	89 13                	mov    %edx,(%ebx)
			return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	eb 35                	jmp    8016c5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801690:	83 c0 01             	add    $0x1,%eax
  801693:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  80169a:	85 d2                	test   %edx,%edx
  80169c:	75 dd                	jne    80167b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80169e:	a1 04 40 80 00       	mov    0x804004,%eax
  8016a3:	8b 40 48             	mov    0x48(%eax),%eax
  8016a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ae:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  8016b5:	e8 fd eb ff ff       	call   8002b7 <cprintf>
	*dev = 0;
  8016ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8016c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c5:	83 c4 14             	add    $0x14,%esp
  8016c8:	5b                   	pop    %ebx
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 38             	sub    $0x38,%esp
  8016d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016dd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e1:	89 3c 24             	mov    %edi,(%esp)
  8016e4:	e8 87 fe ff ff       	call   801570 <fd2num>
  8016e9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8016ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016f0:	89 04 24             	mov    %eax,(%esp)
  8016f3:	e8 16 ff ff ff       	call   80160e <fd_lookup>
  8016f8:	89 c3                	mov    %eax,%ebx
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 05                	js     801703 <fd_close+0x38>
	    || fd != fd2)
  8016fe:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801701:	74 0e                	je     801711 <fd_close+0x46>
		return (must_exist ? r : 0);
  801703:	89 f0                	mov    %esi,%eax
  801705:	84 c0                	test   %al,%al
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	0f 44 d8             	cmove  %eax,%ebx
  80170f:	eb 3d                	jmp    80174e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801711:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801714:	89 44 24 04          	mov    %eax,0x4(%esp)
  801718:	8b 07                	mov    (%edi),%eax
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	e8 3d ff ff ff       	call   80165f <dev_lookup>
  801722:	89 c3                	mov    %eax,%ebx
  801724:	85 c0                	test   %eax,%eax
  801726:	78 16                	js     80173e <fd_close+0x73>
		if (dev->dev_close)
  801728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80172e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801733:	85 c0                	test   %eax,%eax
  801735:	74 07                	je     80173e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801737:	89 3c 24             	mov    %edi,(%esp)
  80173a:	ff d0                	call   *%eax
  80173c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80173e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801749:	e8 4b f7 ff ff       	call   800e99 <sys_page_unmap>
	return r;
}
  80174e:	89 d8                	mov    %ebx,%eax
  801750:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801753:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801756:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801759:	89 ec                	mov    %ebp,%esp
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	89 04 24             	mov    %eax,(%esp)
  801770:	e8 99 fe ff ff       	call   80160e <fd_lookup>
  801775:	85 c0                	test   %eax,%eax
  801777:	78 13                	js     80178c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801779:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801780:	00 
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 3f ff ff ff       	call   8016cb <fd_close>
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <close_all>:

void
close_all(void)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801795:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80179a:	89 1c 24             	mov    %ebx,(%esp)
  80179d:	e8 bb ff ff ff       	call   80175d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017a2:	83 c3 01             	add    $0x1,%ebx
  8017a5:	83 fb 20             	cmp    $0x20,%ebx
  8017a8:	75 f0                	jne    80179a <close_all+0xc>
		close(i);
}
  8017aa:	83 c4 14             	add    $0x14,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 58             	sub    $0x58,%esp
  8017b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	89 04 24             	mov    %eax,(%esp)
  8017cf:	e8 3a fe ff ff       	call   80160e <fd_lookup>
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	0f 88 e1 00 00 00    	js     8018bf <dup+0x10f>
		return r;
	close(newfdnum);
  8017de:	89 3c 24             	mov    %edi,(%esp)
  8017e1:	e8 77 ff ff ff       	call   80175d <close>

	newfd = INDEX2FD(newfdnum);
  8017e6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017ec:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f2:	89 04 24             	mov    %eax,(%esp)
  8017f5:	e8 86 fd ff ff       	call   801580 <fd2data>
  8017fa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017fc:	89 34 24             	mov    %esi,(%esp)
  8017ff:	e8 7c fd ff ff       	call   801580 <fd2data>
  801804:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801807:	89 d8                	mov    %ebx,%eax
  801809:	c1 e8 16             	shr    $0x16,%eax
  80180c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801813:	a8 01                	test   $0x1,%al
  801815:	74 46                	je     80185d <dup+0xad>
  801817:	89 d8                	mov    %ebx,%eax
  801819:	c1 e8 0c             	shr    $0xc,%eax
  80181c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801823:	f6 c2 01             	test   $0x1,%dl
  801826:	74 35                	je     80185d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801828:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80182f:	25 07 0e 00 00       	and    $0xe07,%eax
  801834:	89 44 24 10          	mov    %eax,0x10(%esp)
  801838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80183b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801846:	00 
  801847:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80184b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801852:	e8 e4 f5 ff ff       	call   800e3b <sys_page_map>
  801857:	89 c3                	mov    %eax,%ebx
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 3b                	js     801898 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80185d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801860:	89 c2                	mov    %eax,%edx
  801862:	c1 ea 0c             	shr    $0xc,%edx
  801865:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80186c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801872:	89 54 24 10          	mov    %edx,0x10(%esp)
  801876:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80187a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801881:	00 
  801882:	89 44 24 04          	mov    %eax,0x4(%esp)
  801886:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188d:	e8 a9 f5 ff ff       	call   800e3b <sys_page_map>
  801892:	89 c3                	mov    %eax,%ebx
  801894:	85 c0                	test   %eax,%eax
  801896:	79 25                	jns    8018bd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801898:	89 74 24 04          	mov    %esi,0x4(%esp)
  80189c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a3:	e8 f1 f5 ff ff       	call   800e99 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b6:	e8 de f5 ff ff       	call   800e99 <sys_page_unmap>
	return r;
  8018bb:	eb 02                	jmp    8018bf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8018bd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018bf:	89 d8                	mov    %ebx,%eax
  8018c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018ca:	89 ec                	mov    %ebp,%esp
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	53                   	push   %ebx
  8018d2:	83 ec 24             	sub    $0x24,%esp
  8018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	89 1c 24             	mov    %ebx,(%esp)
  8018e2:	e8 27 fd ff ff       	call   80160e <fd_lookup>
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 6d                	js     801958 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f5:	8b 00                	mov    (%eax),%eax
  8018f7:	89 04 24             	mov    %eax,(%esp)
  8018fa:	e8 60 fd ff ff       	call   80165f <dev_lookup>
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 55                	js     801958 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801906:	8b 50 08             	mov    0x8(%eax),%edx
  801909:	83 e2 03             	and    $0x3,%edx
  80190c:	83 fa 01             	cmp    $0x1,%edx
  80190f:	75 23                	jne    801934 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801911:	a1 04 40 80 00       	mov    0x804004,%eax
  801916:	8b 40 48             	mov    0x48(%eax),%eax
  801919:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801921:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  801928:	e8 8a e9 ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  80192d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801932:	eb 24                	jmp    801958 <read+0x8a>
	}
	if (!dev->dev_read)
  801934:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801937:	8b 52 08             	mov    0x8(%edx),%edx
  80193a:	85 d2                	test   %edx,%edx
  80193c:	74 15                	je     801953 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80193e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801941:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801945:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801948:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194c:	89 04 24             	mov    %eax,(%esp)
  80194f:	ff d2                	call   *%edx
  801951:	eb 05                	jmp    801958 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801953:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801958:	83 c4 24             	add    $0x24,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    

0080195e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 1c             	sub    $0x1c,%esp
  801967:	8b 7d 08             	mov    0x8(%ebp),%edi
  80196a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	85 f6                	test   %esi,%esi
  801974:	74 30                	je     8019a6 <readn+0x48>
  801976:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80197b:	89 f2                	mov    %esi,%edx
  80197d:	29 c2                	sub    %eax,%edx
  80197f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801983:	03 45 0c             	add    0xc(%ebp),%eax
  801986:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198a:	89 3c 24             	mov    %edi,(%esp)
  80198d:	e8 3c ff ff ff       	call   8018ce <read>
		if (m < 0)
  801992:	85 c0                	test   %eax,%eax
  801994:	78 10                	js     8019a6 <readn+0x48>
			return m;
		if (m == 0)
  801996:	85 c0                	test   %eax,%eax
  801998:	74 0a                	je     8019a4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80199a:	01 c3                	add    %eax,%ebx
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	39 f3                	cmp    %esi,%ebx
  8019a0:	72 d9                	jb     80197b <readn+0x1d>
  8019a2:	eb 02                	jmp    8019a6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8019a4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8019a6:	83 c4 1c             	add    $0x1c,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5e                   	pop    %esi
  8019ab:	5f                   	pop    %edi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 24             	sub    $0x24,%esp
  8019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	89 1c 24             	mov    %ebx,(%esp)
  8019c2:	e8 47 fc ff ff       	call   80160e <fd_lookup>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 68                	js     801a33 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	89 04 24             	mov    %eax,(%esp)
  8019da:	e8 80 fc ff ff       	call   80165f <dev_lookup>
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 50                	js     801a33 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ea:	75 23                	jne    801a0f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ec:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f1:	8b 40 48             	mov    0x48(%eax),%eax
  8019f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fc:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  801a03:	e8 af e8 ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  801a08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0d:	eb 24                	jmp    801a33 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a12:	8b 52 0c             	mov    0xc(%edx),%edx
  801a15:	85 d2                	test   %edx,%edx
  801a17:	74 15                	je     801a2e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a27:	89 04 24             	mov    %eax,(%esp)
  801a2a:	ff d2                	call   *%edx
  801a2c:	eb 05                	jmp    801a33 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a33:	83 c4 24             	add    $0x24,%esp
  801a36:	5b                   	pop    %ebx
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a3f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 04 24             	mov    %eax,(%esp)
  801a4c:	e8 bd fb ff ff       	call   80160e <fd_lookup>
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 0e                	js     801a63 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 24             	sub    $0x24,%esp
  801a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a76:	89 1c 24             	mov    %ebx,(%esp)
  801a79:	e8 90 fb ff ff       	call   80160e <fd_lookup>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 61                	js     801ae3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	89 04 24             	mov    %eax,(%esp)
  801a91:	e8 c9 fb ff ff       	call   80165f <dev_lookup>
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 49                	js     801ae3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aa1:	75 23                	jne    801ac6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801aa3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aa8:	8b 40 48             	mov    0x48(%eax),%eax
  801aab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab3:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  801aba:	e8 f8 e7 ff ff       	call   8002b7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801abf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac4:	eb 1d                	jmp    801ae3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac9:	8b 52 18             	mov    0x18(%edx),%edx
  801acc:	85 d2                	test   %edx,%edx
  801ace:	74 0e                	je     801ade <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ad0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad7:	89 04 24             	mov    %eax,(%esp)
  801ada:	ff d2                	call   *%edx
  801adc:	eb 05                	jmp    801ae3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801ade:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ae3:	83 c4 24             	add    $0x24,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	53                   	push   %ebx
  801aed:	83 ec 24             	sub    $0x24,%esp
  801af0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	89 04 24             	mov    %eax,(%esp)
  801b00:	e8 09 fb ff ff       	call   80160e <fd_lookup>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 52                	js     801b5b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	89 04 24             	mov    %eax,(%esp)
  801b18:	e8 42 fb ff ff       	call   80165f <dev_lookup>
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 3a                	js     801b5b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b24:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b28:	74 2c                	je     801b56 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b2a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b2d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b34:	00 00 00 
	stat->st_isdir = 0;
  801b37:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3e:	00 00 00 
	stat->st_dev = dev;
  801b41:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b4e:	89 14 24             	mov    %edx,(%esp)
  801b51:	ff 50 14             	call   *0x14(%eax)
  801b54:	eb 05                	jmp    801b5b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b5b:	83 c4 24             	add    $0x24,%esp
  801b5e:	5b                   	pop    %ebx
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    

00801b61 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 18             	sub    $0x18,%esp
  801b67:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b6a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b74:	00 
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	89 04 24             	mov    %eax,(%esp)
  801b7b:	e8 bc 01 00 00       	call   801d3c <open>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 1b                	js     801ba1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8d:	89 1c 24             	mov    %ebx,(%esp)
  801b90:	e8 54 ff ff ff       	call   801ae9 <fstat>
  801b95:	89 c6                	mov    %eax,%esi
	close(fd);
  801b97:	89 1c 24             	mov    %ebx,(%esp)
  801b9a:	e8 be fb ff ff       	call   80175d <close>
	return r;
  801b9f:	89 f3                	mov    %esi,%ebx
}
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ba6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ba9:	89 ec                	mov    %ebp,%esp
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
  801bad:	00 00                	add    %al,(%eax)
	...

00801bb0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 18             	sub    $0x18,%esp
  801bb6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bb9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801bbc:	89 c3                	mov    %eax,%ebx
  801bbe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801bc0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801bc7:	75 11                	jne    801bda <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bd0:	e8 51 f9 ff ff       	call   801526 <ipc_find_env>
  801bd5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bda:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801be1:	00 
  801be2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801be9:	00 
  801bea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bee:	a1 00 40 80 00       	mov    0x804000,%eax
  801bf3:	89 04 24             	mov    %eax,(%esp)
  801bf6:	e8 a7 f8 ff ff       	call   8014a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bfb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c02:	00 
  801c03:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0e:	e8 3d f8 ff ff       	call   801450 <ipc_recv>
}
  801c13:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c16:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c19:	89 ec                	mov    %ebp,%esp
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	53                   	push   %ebx
  801c21:	83 ec 14             	sub    $0x14,%esp
  801c24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3c:	e8 6f ff ff ff       	call   801bb0 <fsipc>
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 2b                	js     801c70 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c45:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c4c:	00 
  801c4d:	89 1c 24             	mov    %ebx,(%esp)
  801c50:	e8 86 ec ff ff       	call   8008db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c55:	a1 80 50 80 00       	mov    0x805080,%eax
  801c5a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c60:	a1 84 50 80 00       	mov    0x805084,%eax
  801c65:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	83 c4 14             	add    $0x14,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c82:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 06 00 00 00       	mov    $0x6,%eax
  801c91:	e8 1a ff ff ff       	call   801bb0 <fsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 10             	sub    $0x10,%esp
  801ca0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cae:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb9:	b8 03 00 00 00       	mov    $0x3,%eax
  801cbe:	e8 ed fe ff ff       	call   801bb0 <fsipc>
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	78 6a                	js     801d33 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cc9:	39 c6                	cmp    %eax,%esi
  801ccb:	73 24                	jae    801cf1 <devfile_read+0x59>
  801ccd:	c7 44 24 0c b0 2c 80 	movl   $0x802cb0,0xc(%esp)
  801cd4:	00 
  801cd5:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  801cdc:	00 
  801cdd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ce4:	00 
  801ce5:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  801cec:	e8 cb e4 ff ff       	call   8001bc <_panic>
	assert(r <= PGSIZE);
  801cf1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cf6:	7e 24                	jle    801d1c <devfile_read+0x84>
  801cf8:	c7 44 24 0c d7 2c 80 	movl   $0x802cd7,0xc(%esp)
  801cff:	00 
  801d00:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  801d07:	00 
  801d08:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801d0f:	00 
  801d10:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  801d17:	e8 a0 e4 ff ff       	call   8001bc <_panic>
	memmove(buf, &fsipcbuf, r);
  801d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d20:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d27:	00 
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 99 ed ff ff       	call   800acc <memmove>
	return r;
}
  801d33:	89 d8                	mov    %ebx,%eax
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5e                   	pop    %esi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    

00801d3c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	56                   	push   %esi
  801d40:	53                   	push   %ebx
  801d41:	83 ec 20             	sub    $0x20,%esp
  801d44:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d47:	89 34 24             	mov    %esi,(%esp)
  801d4a:	e8 41 eb ff ff       	call   800890 <strlen>
		return -E_BAD_PATH;
  801d4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d59:	7f 5e                	jg     801db9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5e:	89 04 24             	mov    %eax,(%esp)
  801d61:	e8 35 f8 ff ff       	call   80159b <fd_alloc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 4d                	js     801db9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d70:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d77:	e8 5f eb ff ff       	call   8008db <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8c:	e8 1f fe ff ff       	call   801bb0 <fsipc>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	85 c0                	test   %eax,%eax
  801d95:	79 15                	jns    801dac <open+0x70>
		fd_close(fd, 0);
  801d97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d9e:	00 
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	89 04 24             	mov    %eax,(%esp)
  801da5:	e8 21 f9 ff ff       	call   8016cb <fd_close>
		return r;
  801daa:	eb 0d                	jmp    801db9 <open+0x7d>
	}

	return fd2num(fd);
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	89 04 24             	mov    %eax,(%esp)
  801db2:	e8 b9 f7 ff ff       	call   801570 <fd2num>
  801db7:	89 c3                	mov    %eax,%ebx
}
  801db9:	89 d8                	mov    %ebx,%eax
  801dbb:	83 c4 20             	add    $0x20,%esp
  801dbe:	5b                   	pop    %ebx
  801dbf:	5e                   	pop    %esi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    
	...

00801dd0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 18             	sub    $0x18,%esp
  801dd6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801dd9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	89 04 24             	mov    %eax,(%esp)
  801de5:	e8 96 f7 ff ff       	call   801580 <fd2data>
  801dea:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801dec:	c7 44 24 04 e3 2c 80 	movl   $0x802ce3,0x4(%esp)
  801df3:	00 
  801df4:	89 34 24             	mov    %esi,(%esp)
  801df7:	e8 df ea ff ff       	call   8008db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dfc:	8b 43 04             	mov    0x4(%ebx),%eax
  801dff:	2b 03                	sub    (%ebx),%eax
  801e01:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801e07:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801e0e:	00 00 00 
	stat->st_dev = &devpipe;
  801e11:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801e18:	30 80 00 
	return 0;
}
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e23:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e26:	89 ec                	mov    %ebp,%esp
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	53                   	push   %ebx
  801e2e:	83 ec 14             	sub    $0x14,%esp
  801e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3f:	e8 55 f0 ff ff       	call   800e99 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e44:	89 1c 24             	mov    %ebx,(%esp)
  801e47:	e8 34 f7 ff ff       	call   801580 <fd2data>
  801e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e57:	e8 3d f0 ff ff       	call   800e99 <sys_page_unmap>
}
  801e5c:	83 c4 14             	add    $0x14,%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    

00801e62 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	57                   	push   %edi
  801e66:	56                   	push   %esi
  801e67:	53                   	push   %ebx
  801e68:	83 ec 2c             	sub    $0x2c,%esp
  801e6b:	89 c7                	mov    %eax,%edi
  801e6d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e70:	a1 04 40 80 00       	mov    0x804004,%eax
  801e75:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e78:	89 3c 24             	mov    %edi,(%esp)
  801e7b:	e8 78 05 00 00       	call   8023f8 <pageref>
  801e80:	89 c6                	mov    %eax,%esi
  801e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e85:	89 04 24             	mov    %eax,(%esp)
  801e88:	e8 6b 05 00 00       	call   8023f8 <pageref>
  801e8d:	39 c6                	cmp    %eax,%esi
  801e8f:	0f 94 c0             	sete   %al
  801e92:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801e95:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e9e:	39 cb                	cmp    %ecx,%ebx
  801ea0:	75 08                	jne    801eaa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801ea2:	83 c4 2c             	add    $0x2c,%esp
  801ea5:	5b                   	pop    %ebx
  801ea6:	5e                   	pop    %esi
  801ea7:	5f                   	pop    %edi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801eaa:	83 f8 01             	cmp    $0x1,%eax
  801ead:	75 c1                	jne    801e70 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801eaf:	8b 52 58             	mov    0x58(%edx),%edx
  801eb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ebe:	c7 04 24 ea 2c 80 00 	movl   $0x802cea,(%esp)
  801ec5:	e8 ed e3 ff ff       	call   8002b7 <cprintf>
  801eca:	eb a4                	jmp    801e70 <_pipeisclosed+0xe>

00801ecc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	57                   	push   %edi
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 2c             	sub    $0x2c,%esp
  801ed5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ed8:	89 34 24             	mov    %esi,(%esp)
  801edb:	e8 a0 f6 ff ff       	call   801580 <fd2data>
  801ee0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ee2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eeb:	75 50                	jne    801f3d <devpipe_write+0x71>
  801eed:	eb 5c                	jmp    801f4b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801eef:	89 da                	mov    %ebx,%edx
  801ef1:	89 f0                	mov    %esi,%eax
  801ef3:	e8 6a ff ff ff       	call   801e62 <_pipeisclosed>
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	75 53                	jne    801f4f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801efc:	e8 ab ee ff ff       	call   800dac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f01:	8b 43 04             	mov    0x4(%ebx),%eax
  801f04:	8b 13                	mov    (%ebx),%edx
  801f06:	83 c2 20             	add    $0x20,%edx
  801f09:	39 d0                	cmp    %edx,%eax
  801f0b:	73 e2                	jae    801eef <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801f14:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801f17:	89 c2                	mov    %eax,%edx
  801f19:	c1 fa 1f             	sar    $0x1f,%edx
  801f1c:	c1 ea 1b             	shr    $0x1b,%edx
  801f1f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f22:	83 e1 1f             	and    $0x1f,%ecx
  801f25:	29 d1                	sub    %edx,%ecx
  801f27:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f2b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f2f:	83 c0 01             	add    $0x1,%eax
  801f32:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f35:	83 c7 01             	add    $0x1,%edi
  801f38:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f3b:	74 0e                	je     801f4b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f3d:	8b 43 04             	mov    0x4(%ebx),%eax
  801f40:	8b 13                	mov    (%ebx),%edx
  801f42:	83 c2 20             	add    $0x20,%edx
  801f45:	39 d0                	cmp    %edx,%eax
  801f47:	73 a6                	jae    801eef <devpipe_write+0x23>
  801f49:	eb c2                	jmp    801f0d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f4b:	89 f8                	mov    %edi,%eax
  801f4d:	eb 05                	jmp    801f54 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f54:	83 c4 2c             	add    $0x2c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 28             	sub    $0x28,%esp
  801f62:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f65:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f68:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f6b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f6e:	89 3c 24             	mov    %edi,(%esp)
  801f71:	e8 0a f6 ff ff       	call   801580 <fd2data>
  801f76:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f78:	be 00 00 00 00       	mov    $0x0,%esi
  801f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f81:	75 47                	jne    801fca <devpipe_read+0x6e>
  801f83:	eb 52                	jmp    801fd7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f85:	89 f0                	mov    %esi,%eax
  801f87:	eb 5e                	jmp    801fe7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f89:	89 da                	mov    %ebx,%edx
  801f8b:	89 f8                	mov    %edi,%eax
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	e8 cd fe ff ff       	call   801e62 <_pipeisclosed>
  801f95:	85 c0                	test   %eax,%eax
  801f97:	75 49                	jne    801fe2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f99:	e8 0e ee ff ff       	call   800dac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f9e:	8b 03                	mov    (%ebx),%eax
  801fa0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fa3:	74 e4                	je     801f89 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fa5:	89 c2                	mov    %eax,%edx
  801fa7:	c1 fa 1f             	sar    $0x1f,%edx
  801faa:	c1 ea 1b             	shr    $0x1b,%edx
  801fad:	01 d0                	add    %edx,%eax
  801faf:	83 e0 1f             	and    $0x1f,%eax
  801fb2:	29 d0                	sub    %edx,%eax
  801fb4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801fbf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fc2:	83 c6 01             	add    $0x1,%esi
  801fc5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc8:	74 0d                	je     801fd7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801fca:	8b 03                	mov    (%ebx),%eax
  801fcc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fcf:	75 d4                	jne    801fa5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fd1:	85 f6                	test   %esi,%esi
  801fd3:	75 b0                	jne    801f85 <devpipe_read+0x29>
  801fd5:	eb b2                	jmp    801f89 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fd7:	89 f0                	mov    %esi,%eax
  801fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fe0:	eb 05                	jmp    801fe7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801fe7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801fea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801fed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ff0:	89 ec                	mov    %ebp,%esp
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 48             	sub    $0x48,%esp
  801ffa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ffd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802000:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802003:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802006:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 8a f5 ff ff       	call   80159b <fd_alloc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	0f 88 45 01 00 00    	js     802160 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802022:	00 
  802023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802026:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802031:	e8 a6 ed ff ff       	call   800ddc <sys_page_alloc>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	85 c0                	test   %eax,%eax
  80203a:	0f 88 20 01 00 00    	js     802160 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802040:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802043:	89 04 24             	mov    %eax,(%esp)
  802046:	e8 50 f5 ff ff       	call   80159b <fd_alloc>
  80204b:	89 c3                	mov    %eax,%ebx
  80204d:	85 c0                	test   %eax,%eax
  80204f:	0f 88 f8 00 00 00    	js     80214d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802055:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80205c:	00 
  80205d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802060:	89 44 24 04          	mov    %eax,0x4(%esp)
  802064:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80206b:	e8 6c ed ff ff       	call   800ddc <sys_page_alloc>
  802070:	89 c3                	mov    %eax,%ebx
  802072:	85 c0                	test   %eax,%eax
  802074:	0f 88 d3 00 00 00    	js     80214d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80207a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207d:	89 04 24             	mov    %eax,(%esp)
  802080:	e8 fb f4 ff ff       	call   801580 <fd2data>
  802085:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802087:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80208e:	00 
  80208f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802093:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209a:	e8 3d ed ff ff       	call   800ddc <sys_page_alloc>
  80209f:	89 c3                	mov    %eax,%ebx
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	0f 88 91 00 00 00    	js     80213a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ac:	89 04 24             	mov    %eax,(%esp)
  8020af:	e8 cc f4 ff ff       	call   801580 <fd2data>
  8020b4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020bb:	00 
  8020bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020c7:	00 
  8020c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d3:	e8 63 ed ff ff       	call   800e3b <sys_page_map>
  8020d8:	89 c3                	mov    %eax,%ebx
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 4c                	js     80212a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020de:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020fc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802101:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 5d f4 ff ff       	call   801570 <fd2num>
  802113:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802118:	89 04 24             	mov    %eax,(%esp)
  80211b:	e8 50 f4 ff ff       	call   801570 <fd2num>
  802120:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802123:	bb 00 00 00 00       	mov    $0x0,%ebx
  802128:	eb 36                	jmp    802160 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80212a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80212e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802135:	e8 5f ed ff ff       	call   800e99 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80213a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802148:	e8 4c ed ff ff       	call   800e99 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80214d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802150:	89 44 24 04          	mov    %eax,0x4(%esp)
  802154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215b:	e8 39 ed ff ff       	call   800e99 <sys_page_unmap>
    err:
	return r;
}
  802160:	89 d8                	mov    %ebx,%eax
  802162:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802165:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802168:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80216b:	89 ec                	mov    %ebp,%esp
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    

0080216f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802175:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	89 04 24             	mov    %eax,(%esp)
  802182:	e8 87 f4 ff ff       	call   80160e <fd_lookup>
  802187:	85 c0                	test   %eax,%eax
  802189:	78 15                	js     8021a0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	89 04 24             	mov    %eax,(%esp)
  802191:	e8 ea f3 ff ff       	call   801580 <fd2data>
	return _pipeisclosed(fd, p);
  802196:	89 c2                	mov    %eax,%edx
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	e8 c2 fc ff ff       	call   801e62 <_pipeisclosed>
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    
	...

008021b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021c0:	c7 44 24 04 02 2d 80 	movl   $0x802d02,0x4(%esp)
  8021c7:	00 
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	89 04 24             	mov    %eax,(%esp)
  8021ce:	e8 08 e7 ff ff       	call   8008db <strcpy>
	return 0;
}
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	57                   	push   %edi
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021e6:	be 00 00 00 00       	mov    $0x0,%esi
  8021eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ef:	74 43                	je     802234 <devcons_write+0x5a>
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ff:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802201:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802204:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802209:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80220c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802210:	03 45 0c             	add    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	89 3c 24             	mov    %edi,(%esp)
  80221a:	e8 ad e8 ff ff       	call   800acc <memmove>
		sys_cputs(buf, m);
  80221f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802223:	89 3c 24             	mov    %edi,(%esp)
  802226:	e8 95 ea ff ff       	call   800cc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80222b:	01 de                	add    %ebx,%esi
  80222d:	89 f0                	mov    %esi,%eax
  80222f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802232:	72 c8                	jb     8021fc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802234:	89 f0                	mov    %esi,%eax
  802236:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80224c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802250:	75 07                	jne    802259 <devcons_read+0x18>
  802252:	eb 31                	jmp    802285 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802254:	e8 53 eb ff ff       	call   800dac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	e8 8a ea ff ff       	call   800cef <sys_cgetc>
  802265:	85 c0                	test   %eax,%eax
  802267:	74 eb                	je     802254 <devcons_read+0x13>
  802269:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80226b:	85 c0                	test   %eax,%eax
  80226d:	78 16                	js     802285 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80226f:	83 f8 04             	cmp    $0x4,%eax
  802272:	74 0c                	je     802280 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802274:	8b 45 0c             	mov    0xc(%ebp),%eax
  802277:	88 10                	mov    %dl,(%eax)
	return 1;
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
  80227e:	eb 05                	jmp    802285 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802293:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80229a:	00 
  80229b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 1a ea ff ff       	call   800cc0 <sys_cputs>
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <getchar>:

int
getchar(void)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022b5:	00 
  8022b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c4:	e8 05 f6 ff ff       	call   8018ce <read>
	if (r < 0)
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 0f                	js     8022dc <getchar+0x34>
		return r;
	if (r < 1)
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	7e 06                	jle    8022d7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022d5:	eb 05                	jmp    8022dc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022d7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	e8 18 f3 ff ff       	call   80160e <fd_lookup>
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 11                	js     80230b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802303:	39 10                	cmp    %edx,(%eax)
  802305:	0f 94 c0             	sete   %al
  802308:	0f b6 c0             	movzbl %al,%eax
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <opencons>:

int
opencons(void)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 7d f2 ff ff       	call   80159b <fd_alloc>
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 3c                	js     80235e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802322:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802329:	00 
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802338:	e8 9f ea ff ff       	call   800ddc <sys_page_alloc>
  80233d:	85 c0                	test   %eax,%eax
  80233f:	78 1d                	js     80235e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802341:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802356:	89 04 24             	mov    %eax,(%esp)
  802359:	e8 12 f2 ff ff       	call   801570 <fd2num>
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802366:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80236d:	75 54                	jne    8023c3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80236f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802376:	00 
  802377:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80237e:	ee 
  80237f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802386:	e8 51 ea ff ff       	call   800ddc <sys_page_alloc>
  80238b:	85 c0                	test   %eax,%eax
  80238d:	79 20                	jns    8023af <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  80238f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802393:	c7 44 24 08 0e 2d 80 	movl   $0x802d0e,0x8(%esp)
  80239a:	00 
  80239b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8023a2:	00 
  8023a3:	c7 04 24 26 2d 80 00 	movl   $0x802d26,(%esp)
  8023aa:	e8 0d de ff ff       	call   8001bc <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023af:	c7 44 24 04 d0 23 80 	movl   $0x8023d0,0x4(%esp)
  8023b6:	00 
  8023b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023be:	e8 f0 eb ff ff       	call   800fb3 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
  8023cd:	00 00                	add    %al,(%eax)
	...

008023d0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023d0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023d1:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023d6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023d8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8023db:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8023df:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8023e2:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8023e6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8023ea:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8023ec:	83 c4 08             	add    $0x8,%esp
	popal
  8023ef:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8023f0:	83 c4 04             	add    $0x4,%esp
	popfl
  8023f3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023f4:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8023f5:	c3                   	ret    
	...

008023f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023fe:	89 d0                	mov    %edx,%eax
  802400:	c1 e8 16             	shr    $0x16,%eax
  802403:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240f:	f6 c1 01             	test   $0x1,%cl
  802412:	74 1d                	je     802431 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802414:	c1 ea 0c             	shr    $0xc,%edx
  802417:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80241e:	f6 c2 01             	test   $0x1,%dl
  802421:	74 0e                	je     802431 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802423:	c1 ea 0c             	shr    $0xc,%edx
  802426:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80242d:	ef 
  80242e:	0f b7 c0             	movzwl %ax,%eax
}
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    
	...

00802440 <__udivdi3>:
  802440:	83 ec 1c             	sub    $0x1c,%esp
  802443:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802447:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80244b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80244f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802453:	89 74 24 10          	mov    %esi,0x10(%esp)
  802457:	8b 74 24 24          	mov    0x24(%esp),%esi
  80245b:	85 ff                	test   %edi,%edi
  80245d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802461:	89 44 24 08          	mov    %eax,0x8(%esp)
  802465:	89 cd                	mov    %ecx,%ebp
  802467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246b:	75 33                	jne    8024a0 <__udivdi3+0x60>
  80246d:	39 f1                	cmp    %esi,%ecx
  80246f:	77 57                	ja     8024c8 <__udivdi3+0x88>
  802471:	85 c9                	test   %ecx,%ecx
  802473:	75 0b                	jne    802480 <__udivdi3+0x40>
  802475:	b8 01 00 00 00       	mov    $0x1,%eax
  80247a:	31 d2                	xor    %edx,%edx
  80247c:	f7 f1                	div    %ecx
  80247e:	89 c1                	mov    %eax,%ecx
  802480:	89 f0                	mov    %esi,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f1                	div    %ecx
  802486:	89 c6                	mov    %eax,%esi
  802488:	8b 44 24 04          	mov    0x4(%esp),%eax
  80248c:	f7 f1                	div    %ecx
  80248e:	89 f2                	mov    %esi,%edx
  802490:	8b 74 24 10          	mov    0x10(%esp),%esi
  802494:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802498:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80249c:	83 c4 1c             	add    $0x1c,%esp
  80249f:	c3                   	ret    
  8024a0:	31 d2                	xor    %edx,%edx
  8024a2:	31 c0                	xor    %eax,%eax
  8024a4:	39 f7                	cmp    %esi,%edi
  8024a6:	77 e8                	ja     802490 <__udivdi3+0x50>
  8024a8:	0f bd cf             	bsr    %edi,%ecx
  8024ab:	83 f1 1f             	xor    $0x1f,%ecx
  8024ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024b2:	75 2c                	jne    8024e0 <__udivdi3+0xa0>
  8024b4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8024b8:	76 04                	jbe    8024be <__udivdi3+0x7e>
  8024ba:	39 f7                	cmp    %esi,%edi
  8024bc:	73 d2                	jae    802490 <__udivdi3+0x50>
  8024be:	31 d2                	xor    %edx,%edx
  8024c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c5:	eb c9                	jmp    802490 <__udivdi3+0x50>
  8024c7:	90                   	nop
  8024c8:	89 f2                	mov    %esi,%edx
  8024ca:	f7 f1                	div    %ecx
  8024cc:	31 d2                	xor    %edx,%edx
  8024ce:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024d2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024d6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	c3                   	ret    
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024e5:	b8 20 00 00 00       	mov    $0x20,%eax
  8024ea:	89 ea                	mov    %ebp,%edx
  8024ec:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024f0:	d3 e7                	shl    %cl,%edi
  8024f2:	89 c1                	mov    %eax,%ecx
  8024f4:	d3 ea                	shr    %cl,%edx
  8024f6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024fb:	09 fa                	or     %edi,%edx
  8024fd:	89 f7                	mov    %esi,%edi
  8024ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802503:	89 f2                	mov    %esi,%edx
  802505:	8b 74 24 08          	mov    0x8(%esp),%esi
  802509:	d3 e5                	shl    %cl,%ebp
  80250b:	89 c1                	mov    %eax,%ecx
  80250d:	d3 ef                	shr    %cl,%edi
  80250f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802514:	d3 e2                	shl    %cl,%edx
  802516:	89 c1                	mov    %eax,%ecx
  802518:	d3 ee                	shr    %cl,%esi
  80251a:	09 d6                	or     %edx,%esi
  80251c:	89 fa                	mov    %edi,%edx
  80251e:	89 f0                	mov    %esi,%eax
  802520:	f7 74 24 0c          	divl   0xc(%esp)
  802524:	89 d7                	mov    %edx,%edi
  802526:	89 c6                	mov    %eax,%esi
  802528:	f7 e5                	mul    %ebp
  80252a:	39 d7                	cmp    %edx,%edi
  80252c:	72 22                	jb     802550 <__udivdi3+0x110>
  80252e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802532:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802537:	d3 e5                	shl    %cl,%ebp
  802539:	39 c5                	cmp    %eax,%ebp
  80253b:	73 04                	jae    802541 <__udivdi3+0x101>
  80253d:	39 d7                	cmp    %edx,%edi
  80253f:	74 0f                	je     802550 <__udivdi3+0x110>
  802541:	89 f0                	mov    %esi,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	e9 46 ff ff ff       	jmp    802490 <__udivdi3+0x50>
  80254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802550:	8d 46 ff             	lea    -0x1(%esi),%eax
  802553:	31 d2                	xor    %edx,%edx
  802555:	8b 74 24 10          	mov    0x10(%esp),%esi
  802559:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80255d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802561:	83 c4 1c             	add    $0x1c,%esp
  802564:	c3                   	ret    
	...

00802570 <__umoddi3>:
  802570:	83 ec 1c             	sub    $0x1c,%esp
  802573:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802577:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80257b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80257f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802583:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802587:	8b 74 24 24          	mov    0x24(%esp),%esi
  80258b:	85 ed                	test   %ebp,%ebp
  80258d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802591:	89 44 24 08          	mov    %eax,0x8(%esp)
  802595:	89 cf                	mov    %ecx,%edi
  802597:	89 04 24             	mov    %eax,(%esp)
  80259a:	89 f2                	mov    %esi,%edx
  80259c:	75 1a                	jne    8025b8 <__umoddi3+0x48>
  80259e:	39 f1                	cmp    %esi,%ecx
  8025a0:	76 4e                	jbe    8025f0 <__umoddi3+0x80>
  8025a2:	f7 f1                	div    %ecx
  8025a4:	89 d0                	mov    %edx,%eax
  8025a6:	31 d2                	xor    %edx,%edx
  8025a8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025ac:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025b0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025b4:	83 c4 1c             	add    $0x1c,%esp
  8025b7:	c3                   	ret    
  8025b8:	39 f5                	cmp    %esi,%ebp
  8025ba:	77 54                	ja     802610 <__umoddi3+0xa0>
  8025bc:	0f bd c5             	bsr    %ebp,%eax
  8025bf:	83 f0 1f             	xor    $0x1f,%eax
  8025c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c6:	75 60                	jne    802628 <__umoddi3+0xb8>
  8025c8:	3b 0c 24             	cmp    (%esp),%ecx
  8025cb:	0f 87 07 01 00 00    	ja     8026d8 <__umoddi3+0x168>
  8025d1:	89 f2                	mov    %esi,%edx
  8025d3:	8b 34 24             	mov    (%esp),%esi
  8025d6:	29 ce                	sub    %ecx,%esi
  8025d8:	19 ea                	sbb    %ebp,%edx
  8025da:	89 34 24             	mov    %esi,(%esp)
  8025dd:	8b 04 24             	mov    (%esp),%eax
  8025e0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025e4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025e8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025ec:	83 c4 1c             	add    $0x1c,%esp
  8025ef:	c3                   	ret    
  8025f0:	85 c9                	test   %ecx,%ecx
  8025f2:	75 0b                	jne    8025ff <__umoddi3+0x8f>
  8025f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f9:	31 d2                	xor    %edx,%edx
  8025fb:	f7 f1                	div    %ecx
  8025fd:	89 c1                	mov    %eax,%ecx
  8025ff:	89 f0                	mov    %esi,%eax
  802601:	31 d2                	xor    %edx,%edx
  802603:	f7 f1                	div    %ecx
  802605:	8b 04 24             	mov    (%esp),%eax
  802608:	f7 f1                	div    %ecx
  80260a:	eb 98                	jmp    8025a4 <__umoddi3+0x34>
  80260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802610:	89 f2                	mov    %esi,%edx
  802612:	8b 74 24 10          	mov    0x10(%esp),%esi
  802616:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80261a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80261e:	83 c4 1c             	add    $0x1c,%esp
  802621:	c3                   	ret    
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262d:	89 e8                	mov    %ebp,%eax
  80262f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802634:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802638:	89 fa                	mov    %edi,%edx
  80263a:	d3 e0                	shl    %cl,%eax
  80263c:	89 e9                	mov    %ebp,%ecx
  80263e:	d3 ea                	shr    %cl,%edx
  802640:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802645:	09 c2                	or     %eax,%edx
  802647:	8b 44 24 08          	mov    0x8(%esp),%eax
  80264b:	89 14 24             	mov    %edx,(%esp)
  80264e:	89 f2                	mov    %esi,%edx
  802650:	d3 e7                	shl    %cl,%edi
  802652:	89 e9                	mov    %ebp,%ecx
  802654:	d3 ea                	shr    %cl,%edx
  802656:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80265f:	d3 e6                	shl    %cl,%esi
  802661:	89 e9                	mov    %ebp,%ecx
  802663:	d3 e8                	shr    %cl,%eax
  802665:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80266a:	09 f0                	or     %esi,%eax
  80266c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802670:	f7 34 24             	divl   (%esp)
  802673:	d3 e6                	shl    %cl,%esi
  802675:	89 74 24 08          	mov    %esi,0x8(%esp)
  802679:	89 d6                	mov    %edx,%esi
  80267b:	f7 e7                	mul    %edi
  80267d:	39 d6                	cmp    %edx,%esi
  80267f:	89 c1                	mov    %eax,%ecx
  802681:	89 d7                	mov    %edx,%edi
  802683:	72 3f                	jb     8026c4 <__umoddi3+0x154>
  802685:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802689:	72 35                	jb     8026c0 <__umoddi3+0x150>
  80268b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80268f:	29 c8                	sub    %ecx,%eax
  802691:	19 fe                	sbb    %edi,%esi
  802693:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802698:	89 f2                	mov    %esi,%edx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	89 e9                	mov    %ebp,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026a5:	09 d0                	or     %edx,%eax
  8026a7:	89 f2                	mov    %esi,%edx
  8026a9:	d3 ea                	shr    %cl,%edx
  8026ab:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026af:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026b3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026b7:	83 c4 1c             	add    $0x1c,%esp
  8026ba:	c3                   	ret    
  8026bb:	90                   	nop
  8026bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	39 d6                	cmp    %edx,%esi
  8026c2:	75 c7                	jne    80268b <__umoddi3+0x11b>
  8026c4:	89 d7                	mov    %edx,%edi
  8026c6:	89 c1                	mov    %eax,%ecx
  8026c8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8026cc:	1b 3c 24             	sbb    (%esp),%edi
  8026cf:	eb ba                	jmp    80268b <__umoddi3+0x11b>
  8026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	39 f5                	cmp    %esi,%ebp
  8026da:	0f 82 f1 fe ff ff    	jb     8025d1 <__umoddi3+0x61>
  8026e0:	e9 f8 fe ff ff       	jmp    8025dd <__umoddi3+0x6d>
