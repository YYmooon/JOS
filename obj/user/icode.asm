
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 2b 01 00 00       	call   80015c <libmain>
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
  800039:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003f:	c7 05 00 30 80 00 40 	movl   $0x802940,0x803000
  800046:	29 80 00 

	cprintf("icode startup\n");
  800049:	c7 04 24 46 29 80 00 	movl   $0x802946,(%esp)
  800050:	e8 6e 02 00 00       	call   8002c3 <cprintf>

	cprintf("icode: open /motd\n");
  800055:	c7 04 24 55 29 80 00 	movl   $0x802955,(%esp)
  80005c:	e8 62 02 00 00       	call   8002c3 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 68 29 80 00 	movl   $0x802968,(%esp)
  800070:	e8 07 18 00 00       	call   80187c <open>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 20                	jns    80009b <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007f:	c7 44 24 08 6e 29 80 	movl   $0x80296e,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  800096:	e8 2d 01 00 00       	call   8001c8 <_panic>

	cprintf("icode: read /motd\n");
  80009b:	c7 04 24 91 29 80 00 	movl   $0x802991,(%esp)
  8000a2:	e8 1c 02 00 00       	call   8002c3 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a7:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ad:	eb 0c                	jmp    8000bb <umain+0x87>
		sys_cputs(buf, n);
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 05 0c 00 00       	call   800cc0 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000bb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c2:	00 
  8000c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c7:	89 34 24             	mov    %esi,(%esp)
  8000ca:	e8 3f 13 00 00       	call   80140e <read>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f dc                	jg     8000af <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d3:	c7 04 24 a4 29 80 00 	movl   $0x8029a4,(%esp)
  8000da:	e8 e4 01 00 00       	call   8002c3 <cprintf>
	close(fd);
  8000df:	89 34 24             	mov    %esi,(%esp)
  8000e2:	e8 b6 11 00 00       	call   80129d <close>

	cprintf("icode: spawn /init\n");
  8000e7:	c7 04 24 b8 29 80 00 	movl   $0x8029b8,(%esp)
  8000ee:	e8 d0 01 00 00       	call   8002c3 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000fa:	00 
  8000fb:	c7 44 24 0c cc 29 80 	movl   $0x8029cc,0xc(%esp)
  800102:	00 
  800103:	c7 44 24 08 d5 29 80 	movl   $0x8029d5,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 df 29 80 	movl   $0x8029df,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 de 29 80 00 	movl   $0x8029de,(%esp)
  80011a:	e8 ee 1d 00 00       	call   801f0d <spawnl>
  80011f:	85 c0                	test   %eax,%eax
  800121:	79 20                	jns    800143 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800127:	c7 44 24 08 e4 29 80 	movl   $0x8029e4,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  80013e:	e8 85 00 00 00       	call   8001c8 <_panic>

	cprintf("icode: exiting\n");
  800143:	c7 04 24 fb 29 80 00 	movl   $0x8029fb,(%esp)
  80014a:	e8 74 01 00 00       	call   8002c3 <cprintf>
}
  80014f:	81 c4 30 02 00 00    	add    $0x230,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 18             	sub    $0x18,%esp
  800162:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800165:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800168:	8b 75 08             	mov    0x8(%ebp),%esi
  80016b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80016e:	e8 09 0c 00 00       	call   800d7c <sys_getenvid>
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800180:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	85 f6                	test   %esi,%esi
  800187:	7e 07                	jle    800190 <libmain+0x34>
		binaryname = argv[0];
  800189:	8b 03                	mov    (%ebx),%eax
  80018b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 34 24             	mov    %esi,(%esp)
  800197:	e8 98 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80019c:	e8 0b 00 00 00       	call   8001ac <exit>
}
  8001a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001a7:	89 ec                	mov    %ebp,%esp
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
	...

008001ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b2:	e8 17 11 00 00       	call   8012ce <close_all>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 5c 0b 00 00       	call   800d1f <sys_env_destroy>
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
  8001c5:	00 00                	add    %al,(%eax)
	...

008001c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d3:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001d9:	e8 9e 0b 00 00       	call   800d7c <sys_getenvid>
  8001de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f4:	c7 04 24 18 2a 80 00 	movl   $0x802a18,(%esp)
  8001fb:	e8 c3 00 00 00       	call   8002c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800200:	89 74 24 04          	mov    %esi,0x4(%esp)
  800204:	8b 45 10             	mov    0x10(%ebp),%eax
  800207:	89 04 24             	mov    %eax,(%esp)
  80020a:	e8 53 00 00 00       	call   800262 <vcprintf>
	cprintf("\n");
  80020f:	c7 04 24 e0 2e 80 00 	movl   $0x802ee0,(%esp)
  800216:	e8 a8 00 00 00       	call   8002c3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021b:	cc                   	int3   
  80021c:	eb fd                	jmp    80021b <_panic+0x53>
	...

00800220 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 14             	sub    $0x14,%esp
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022a:	8b 03                	mov    (%ebx),%eax
  80022c:	8b 55 08             	mov    0x8(%ebp),%edx
  80022f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800233:	83 c0 01             	add    $0x1,%eax
  800236:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800238:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023d:	75 19                	jne    800258 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80023f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800246:	00 
  800247:	8d 43 08             	lea    0x8(%ebx),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 6e 0a 00 00       	call   800cc0 <sys_cputs>
		b->idx = 0;
  800252:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800258:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	5b                   	pop    %ebx
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    

00800262 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80026b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800272:	00 00 00 
	b.cnt = 0;
  800275:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	89 44 24 08          	mov    %eax,0x8(%esp)
  80028d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800293:	89 44 24 04          	mov    %eax,0x4(%esp)
  800297:	c7 04 24 20 02 80 00 	movl   $0x800220,(%esp)
  80029e:	e8 97 01 00 00       	call   80043a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 05 0a 00 00       	call   800cc0 <sys_cputs>

	return b.cnt;
}
  8002bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	89 04 24             	mov    %eax,(%esp)
  8002d6:	e8 87 ff ff ff       	call   800262 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    
  8002dd:	00 00                	add    %al,(%eax)
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
  80034a:	e8 41 23 00 00       	call   802690 <__udivdi3>
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
  80039d:	e8 1e 24 00 00       	call   8027c0 <__umoddi3>
  8003a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a6:	0f be 80 3b 2a 80 00 	movsbl 0x802a3b(%eax),%eax
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
  8004ce:	ff 24 85 80 2b 80 00 	jmp    *0x802b80(,%eax,4)
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
  800584:	8b 14 85 e0 2c 80 00 	mov    0x802ce0(,%eax,4),%edx
  80058b:	85 d2                	test   %edx,%edx
  80058d:	75 23                	jne    8005b2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80058f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800593:	c7 44 24 08 53 2a 80 	movl   $0x802a53,0x8(%esp)
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
  8005b6:	c7 44 24 08 11 2e 80 	movl   $0x802e11,0x8(%esp)
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
  8005eb:	ba 4c 2a 80 00       	mov    $0x802a4c,%edx
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
  800d53:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800d5a:	00 
  800d5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d62:	00 
  800d63:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800d6a:	e8 59 f4 ff ff       	call   8001c8 <_panic>

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
  800e12:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800e29:	e8 9a f3 ff ff       	call   8001c8 <_panic>

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
  800e70:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800e77:	00 
  800e78:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7f:	00 
  800e80:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800e87:	e8 3c f3 ff ff       	call   8001c8 <_panic>

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
  800ece:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800ed5:	00 
  800ed6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edd:	00 
  800ede:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800ee5:	e8 de f2 ff ff       	call   8001c8 <_panic>

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
  800f2c:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800f33:	00 
  800f34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3b:	00 
  800f3c:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800f43:	e8 80 f2 ff ff       	call   8001c8 <_panic>

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
  800f8a:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800f91:	00 
  800f92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f99:	00 
  800f9a:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800fa1:	e8 22 f2 ff ff       	call   8001c8 <_panic>

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
  800fe8:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  800fff:	e8 c4 f1 ff ff       	call   8001c8 <_panic>

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
  801079:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  801090:	e8 33 f1 ff ff       	call   8001c8 <_panic>

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

008010b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	89 04 24             	mov    %eax,(%esp)
  8010cc:	e8 df ff ff ff       	call   8010b0 <fd2num>
  8010d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8010d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	53                   	push   %ebx
  8010df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010e7:	a8 01                	test   $0x1,%al
  8010e9:	74 34                	je     80111f <fd_alloc+0x44>
  8010eb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010f0:	a8 01                	test   $0x1,%al
  8010f2:	74 32                	je     801126 <fd_alloc+0x4b>
  8010f4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010f9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	c1 ea 16             	shr    $0x16,%edx
  801100:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801107:	f6 c2 01             	test   $0x1,%dl
  80110a:	74 1f                	je     80112b <fd_alloc+0x50>
  80110c:	89 c2                	mov    %eax,%edx
  80110e:	c1 ea 0c             	shr    $0xc,%edx
  801111:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801118:	f6 c2 01             	test   $0x1,%dl
  80111b:	75 17                	jne    801134 <fd_alloc+0x59>
  80111d:	eb 0c                	jmp    80112b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80111f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801124:	eb 05                	jmp    80112b <fd_alloc+0x50>
  801126:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80112b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
  801132:	eb 17                	jmp    80114b <fd_alloc+0x70>
  801134:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801139:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80113e:	75 b9                	jne    8010f9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801140:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801146:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80114b:	5b                   	pop    %ebx
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801154:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801159:	83 fa 1f             	cmp    $0x1f,%edx
  80115c:	77 3f                	ja     80119d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80115e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801164:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801167:	89 d0                	mov    %edx,%eax
  801169:	c1 e8 16             	shr    $0x16,%eax
  80116c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801178:	f6 c1 01             	test   $0x1,%cl
  80117b:	74 20                	je     80119d <fd_lookup+0x4f>
  80117d:	89 d0                	mov    %edx,%eax
  80117f:	c1 e8 0c             	shr    $0xc,%eax
  801182:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80118e:	f6 c1 01             	test   $0x1,%cl
  801191:	74 0a                	je     80119d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	89 10                	mov    %edx,(%eax)
	return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 14             	sub    $0x14,%esp
  8011a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011b1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8011b7:	75 17                	jne    8011d0 <dev_lookup+0x31>
  8011b9:	eb 07                	jmp    8011c2 <dev_lookup+0x23>
  8011bb:	39 0a                	cmp    %ecx,(%edx)
  8011bd:	75 11                	jne    8011d0 <dev_lookup+0x31>
  8011bf:	90                   	nop
  8011c0:	eb 05                	jmp    8011c7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011c2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011c7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 35                	jmp    801205 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011d0:	83 c0 01             	add    $0x1,%eax
  8011d3:	8b 14 85 e8 2d 80 00 	mov    0x802de8(,%eax,4),%edx
  8011da:	85 d2                	test   %edx,%edx
  8011dc:	75 dd                	jne    8011bb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011de:	a1 04 40 80 00       	mov    0x804004,%eax
  8011e3:	8b 40 48             	mov    0x48(%eax),%eax
  8011e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ee:	c7 04 24 6c 2d 80 00 	movl   $0x802d6c,(%esp)
  8011f5:	e8 c9 f0 ff ff       	call   8002c3 <cprintf>
	*dev = 0;
  8011fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801200:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801205:	83 c4 14             	add    $0x14,%esp
  801208:	5b                   	pop    %ebx
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 38             	sub    $0x38,%esp
  801211:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801214:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801217:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80121a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80121d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801221:	89 3c 24             	mov    %edi,(%esp)
  801224:	e8 87 fe ff ff       	call   8010b0 <fd2num>
  801229:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80122c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801230:	89 04 24             	mov    %eax,(%esp)
  801233:	e8 16 ff ff ff       	call   80114e <fd_lookup>
  801238:	89 c3                	mov    %eax,%ebx
  80123a:	85 c0                	test   %eax,%eax
  80123c:	78 05                	js     801243 <fd_close+0x38>
	    || fd != fd2)
  80123e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801241:	74 0e                	je     801251 <fd_close+0x46>
		return (must_exist ? r : 0);
  801243:	89 f0                	mov    %esi,%eax
  801245:	84 c0                	test   %al,%al
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
  80124c:	0f 44 d8             	cmove  %eax,%ebx
  80124f:	eb 3d                	jmp    80128e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801251:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801254:	89 44 24 04          	mov    %eax,0x4(%esp)
  801258:	8b 07                	mov    (%edi),%eax
  80125a:	89 04 24             	mov    %eax,(%esp)
  80125d:	e8 3d ff ff ff       	call   80119f <dev_lookup>
  801262:	89 c3                	mov    %eax,%ebx
  801264:	85 c0                	test   %eax,%eax
  801266:	78 16                	js     80127e <fd_close+0x73>
		if (dev->dev_close)
  801268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80126e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801273:	85 c0                	test   %eax,%eax
  801275:	74 07                	je     80127e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801277:	89 3c 24             	mov    %edi,(%esp)
  80127a:	ff d0                	call   *%eax
  80127c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80127e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801282:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801289:	e8 0b fc ff ff       	call   800e99 <sys_page_unmap>
	return r;
}
  80128e:	89 d8                	mov    %ebx,%eax
  801290:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801293:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801296:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801299:	89 ec                	mov    %ebp,%esp
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	89 04 24             	mov    %eax,(%esp)
  8012b0:	e8 99 fe ff ff       	call   80114e <fd_lookup>
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 13                	js     8012cc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8012b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012c0:	00 
  8012c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c4:	89 04 24             	mov    %eax,(%esp)
  8012c7:	e8 3f ff ff ff       	call   80120b <fd_close>
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <close_all>:

void
close_all(void)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012da:	89 1c 24             	mov    %ebx,(%esp)
  8012dd:	e8 bb ff ff ff       	call   80129d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e2:	83 c3 01             	add    $0x1,%ebx
  8012e5:	83 fb 20             	cmp    $0x20,%ebx
  8012e8:	75 f0                	jne    8012da <close_all+0xc>
		close(i);
}
  8012ea:	83 c4 14             	add    $0x14,%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 58             	sub    $0x58,%esp
  8012f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8012ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801302:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801305:	89 44 24 04          	mov    %eax,0x4(%esp)
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	89 04 24             	mov    %eax,(%esp)
  80130f:	e8 3a fe ff ff       	call   80114e <fd_lookup>
  801314:	89 c3                	mov    %eax,%ebx
  801316:	85 c0                	test   %eax,%eax
  801318:	0f 88 e1 00 00 00    	js     8013ff <dup+0x10f>
		return r;
	close(newfdnum);
  80131e:	89 3c 24             	mov    %edi,(%esp)
  801321:	e8 77 ff ff ff       	call   80129d <close>

	newfd = INDEX2FD(newfdnum);
  801326:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80132c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80132f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	e8 86 fd ff ff       	call   8010c0 <fd2data>
  80133a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80133c:	89 34 24             	mov    %esi,(%esp)
  80133f:	e8 7c fd ff ff       	call   8010c0 <fd2data>
  801344:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801347:	89 d8                	mov    %ebx,%eax
  801349:	c1 e8 16             	shr    $0x16,%eax
  80134c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801353:	a8 01                	test   $0x1,%al
  801355:	74 46                	je     80139d <dup+0xad>
  801357:	89 d8                	mov    %ebx,%eax
  801359:	c1 e8 0c             	shr    $0xc,%eax
  80135c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801363:	f6 c2 01             	test   $0x1,%dl
  801366:	74 35                	je     80139d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801368:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136f:	25 07 0e 00 00       	and    $0xe07,%eax
  801374:	89 44 24 10          	mov    %eax,0x10(%esp)
  801378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80137b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801386:	00 
  801387:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80138b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801392:	e8 a4 fa ff ff       	call   800e3b <sys_page_map>
  801397:	89 c3                	mov    %eax,%ebx
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 3b                	js     8013d8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80139d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a0:	89 c2                	mov    %eax,%edx
  8013a2:	c1 ea 0c             	shr    $0xc,%edx
  8013a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ac:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013b2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013c1:	00 
  8013c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cd:	e8 69 fa ff ff       	call   800e3b <sys_page_map>
  8013d2:	89 c3                	mov    %eax,%ebx
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	79 25                	jns    8013fd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e3:	e8 b1 fa ff ff       	call   800e99 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f6:	e8 9e fa ff ff       	call   800e99 <sys_page_unmap>
	return r;
  8013fb:	eb 02                	jmp    8013ff <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8013fd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013ff:	89 d8                	mov    %ebx,%eax
  801401:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801404:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801407:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80140a:	89 ec                	mov    %ebp,%esp
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	53                   	push   %ebx
  801412:	83 ec 24             	sub    $0x24,%esp
  801415:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801418:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141f:	89 1c 24             	mov    %ebx,(%esp)
  801422:	e8 27 fd ff ff       	call   80114e <fd_lookup>
  801427:	85 c0                	test   %eax,%eax
  801429:	78 6d                	js     801498 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	8b 00                	mov    (%eax),%eax
  801437:	89 04 24             	mov    %eax,(%esp)
  80143a:	e8 60 fd ff ff       	call   80119f <dev_lookup>
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 55                	js     801498 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	8b 50 08             	mov    0x8(%eax),%edx
  801449:	83 e2 03             	and    $0x3,%edx
  80144c:	83 fa 01             	cmp    $0x1,%edx
  80144f:	75 23                	jne    801474 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801451:	a1 04 40 80 00       	mov    0x804004,%eax
  801456:	8b 40 48             	mov    0x48(%eax),%eax
  801459:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80145d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801461:	c7 04 24 ad 2d 80 00 	movl   $0x802dad,(%esp)
  801468:	e8 56 ee ff ff       	call   8002c3 <cprintf>
		return -E_INVAL;
  80146d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801472:	eb 24                	jmp    801498 <read+0x8a>
	}
	if (!dev->dev_read)
  801474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801477:	8b 52 08             	mov    0x8(%edx),%edx
  80147a:	85 d2                	test   %edx,%edx
  80147c:	74 15                	je     801493 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80147e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801481:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801488:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80148c:	89 04 24             	mov    %eax,(%esp)
  80148f:	ff d2                	call   *%edx
  801491:	eb 05                	jmp    801498 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801493:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801498:	83 c4 24             	add    $0x24,%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    

0080149e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	57                   	push   %edi
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 1c             	sub    $0x1c,%esp
  8014a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	85 f6                	test   %esi,%esi
  8014b4:	74 30                	je     8014e6 <readn+0x48>
  8014b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bb:	89 f2                	mov    %esi,%edx
  8014bd:	29 c2                	sub    %eax,%edx
  8014bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014c3:	03 45 0c             	add    0xc(%ebp),%eax
  8014c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ca:	89 3c 24             	mov    %edi,(%esp)
  8014cd:	e8 3c ff ff ff       	call   80140e <read>
		if (m < 0)
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 10                	js     8014e6 <readn+0x48>
			return m;
		if (m == 0)
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	74 0a                	je     8014e4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014da:	01 c3                	add    %eax,%ebx
  8014dc:	89 d8                	mov    %ebx,%eax
  8014de:	39 f3                	cmp    %esi,%ebx
  8014e0:	72 d9                	jb     8014bb <readn+0x1d>
  8014e2:	eb 02                	jmp    8014e6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8014e4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8014e6:	83 c4 1c             	add    $0x1c,%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5f                   	pop    %edi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 24             	sub    $0x24,%esp
  8014f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ff:	89 1c 24             	mov    %ebx,(%esp)
  801502:	e8 47 fc ff ff       	call   80114e <fd_lookup>
  801507:	85 c0                	test   %eax,%eax
  801509:	78 68                	js     801573 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 80 fc ff ff       	call   80119f <dev_lookup>
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 50                	js     801573 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152a:	75 23                	jne    80154f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80152c:	a1 04 40 80 00       	mov    0x804004,%eax
  801531:	8b 40 48             	mov    0x48(%eax),%eax
  801534:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153c:	c7 04 24 c9 2d 80 00 	movl   $0x802dc9,(%esp)
  801543:	e8 7b ed ff ff       	call   8002c3 <cprintf>
		return -E_INVAL;
  801548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154d:	eb 24                	jmp    801573 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801552:	8b 52 0c             	mov    0xc(%edx),%edx
  801555:	85 d2                	test   %edx,%edx
  801557:	74 15                	je     80156e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801559:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801560:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801563:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801567:	89 04 24             	mov    %eax,(%esp)
  80156a:	ff d2                	call   *%edx
  80156c:	eb 05                	jmp    801573 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80156e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801573:	83 c4 24             	add    $0x24,%esp
  801576:	5b                   	pop    %ebx
  801577:	5d                   	pop    %ebp
  801578:	c3                   	ret    

00801579 <seek>:

int
seek(int fdnum, off_t offset)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801582:	89 44 24 04          	mov    %eax,0x4(%esp)
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	89 04 24             	mov    %eax,(%esp)
  80158c:	e8 bd fb ff ff       	call   80114e <fd_lookup>
  801591:	85 c0                	test   %eax,%eax
  801593:	78 0e                	js     8015a3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801595:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 24             	sub    $0x24,%esp
  8015ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b6:	89 1c 24             	mov    %ebx,(%esp)
  8015b9:	e8 90 fb ff ff       	call   80114e <fd_lookup>
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	78 61                	js     801623 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	89 04 24             	mov    %eax,(%esp)
  8015d1:	e8 c9 fb ff ff       	call   80119f <dev_lookup>
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 49                	js     801623 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e1:	75 23                	jne    801606 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015e3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e8:	8b 40 48             	mov    0x48(%eax),%eax
  8015eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f3:	c7 04 24 8c 2d 80 00 	movl   $0x802d8c,(%esp)
  8015fa:	e8 c4 ec ff ff       	call   8002c3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801604:	eb 1d                	jmp    801623 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801609:	8b 52 18             	mov    0x18(%edx),%edx
  80160c:	85 d2                	test   %edx,%edx
  80160e:	74 0e                	je     80161e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801613:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801617:	89 04 24             	mov    %eax,(%esp)
  80161a:	ff d2                	call   *%edx
  80161c:	eb 05                	jmp    801623 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80161e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801623:	83 c4 24             	add    $0x24,%esp
  801626:	5b                   	pop    %ebx
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 24             	sub    $0x24,%esp
  801630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801633:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	89 04 24             	mov    %eax,(%esp)
  801640:	e8 09 fb ff ff       	call   80114e <fd_lookup>
  801645:	85 c0                	test   %eax,%eax
  801647:	78 52                	js     80169b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801649:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	8b 00                	mov    (%eax),%eax
  801655:	89 04 24             	mov    %eax,(%esp)
  801658:	e8 42 fb ff ff       	call   80119f <dev_lookup>
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 3a                	js     80169b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801664:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801668:	74 2c                	je     801696 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80166a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80166d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801674:	00 00 00 
	stat->st_isdir = 0;
  801677:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80167e:	00 00 00 
	stat->st_dev = dev;
  801681:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801687:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80168b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168e:	89 14 24             	mov    %edx,(%esp)
  801691:	ff 50 14             	call   *0x14(%eax)
  801694:	eb 05                	jmp    80169b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801696:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80169b:	83 c4 24             	add    $0x24,%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    

008016a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 18             	sub    $0x18,%esp
  8016a7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016aa:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016b4:	00 
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 04 24             	mov    %eax,(%esp)
  8016bb:	e8 bc 01 00 00       	call   80187c <open>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 1b                	js     8016e1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cd:	89 1c 24             	mov    %ebx,(%esp)
  8016d0:	e8 54 ff ff ff       	call   801629 <fstat>
  8016d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 be fb ff ff       	call   80129d <close>
	return r;
  8016df:	89 f3                	mov    %esi,%ebx
}
  8016e1:	89 d8                	mov    %ebx,%eax
  8016e3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016e6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016e9:	89 ec                	mov    %ebp,%esp
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    
  8016ed:	00 00                	add    %al,(%eax)
	...

008016f0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 18             	sub    $0x18,%esp
  8016f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801700:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801707:	75 11                	jne    80171a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801709:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801710:	e8 f1 0e 00 00       	call   802606 <ipc_find_env>
  801715:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80171a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801721:	00 
  801722:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801729:	00 
  80172a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80172e:	a1 00 40 80 00       	mov    0x804000,%eax
  801733:	89 04 24             	mov    %eax,(%esp)
  801736:	e8 47 0e 00 00       	call   802582 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801742:	00 
  801743:	89 74 24 04          	mov    %esi,0x4(%esp)
  801747:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174e:	e8 dd 0d 00 00       	call   802530 <ipc_recv>
}
  801753:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801756:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801759:	89 ec                	mov    %ebp,%esp
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	53                   	push   %ebx
  801761:	83 ec 14             	sub    $0x14,%esp
  801764:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8b 40 0c             	mov    0xc(%eax),%eax
  80176d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 05 00 00 00       	mov    $0x5,%eax
  80177c:	e8 6f ff ff ff       	call   8016f0 <fsipc>
  801781:	85 c0                	test   %eax,%eax
  801783:	78 2b                	js     8017b0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801785:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80178c:	00 
  80178d:	89 1c 24             	mov    %ebx,(%esp)
  801790:	e8 46 f1 ff ff       	call   8008db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801795:	a1 80 50 80 00       	mov    0x805080,%eax
  80179a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a0:	a1 84 50 80 00       	mov    0x805084,%eax
  8017a5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	83 c4 14             	add    $0x14,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    

008017b6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8017d1:	e8 1a ff ff ff       	call   8016f0 <fsipc>
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	83 ec 10             	sub    $0x10,%esp
  8017e0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017ee:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8017fe:	e8 ed fe ff ff       	call   8016f0 <fsipc>
  801803:	89 c3                	mov    %eax,%ebx
  801805:	85 c0                	test   %eax,%eax
  801807:	78 6a                	js     801873 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801809:	39 c6                	cmp    %eax,%esi
  80180b:	73 24                	jae    801831 <devfile_read+0x59>
  80180d:	c7 44 24 0c f8 2d 80 	movl   $0x802df8,0xc(%esp)
  801814:	00 
  801815:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80181c:	00 
  80181d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801824:	00 
  801825:	c7 04 24 14 2e 80 00 	movl   $0x802e14,(%esp)
  80182c:	e8 97 e9 ff ff       	call   8001c8 <_panic>
	assert(r <= PGSIZE);
  801831:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801836:	7e 24                	jle    80185c <devfile_read+0x84>
  801838:	c7 44 24 0c 1f 2e 80 	movl   $0x802e1f,0xc(%esp)
  80183f:	00 
  801840:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801847:	00 
  801848:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80184f:	00 
  801850:	c7 04 24 14 2e 80 00 	movl   $0x802e14,(%esp)
  801857:	e8 6c e9 ff ff       	call   8001c8 <_panic>
	memmove(buf, &fsipcbuf, r);
  80185c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801860:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801867:	00 
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	89 04 24             	mov    %eax,(%esp)
  80186e:	e8 59 f2 ff ff       	call   800acc <memmove>
	return r;
}
  801873:	89 d8                	mov    %ebx,%eax
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	56                   	push   %esi
  801880:	53                   	push   %ebx
  801881:	83 ec 20             	sub    $0x20,%esp
  801884:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801887:	89 34 24             	mov    %esi,(%esp)
  80188a:	e8 01 f0 ff ff       	call   800890 <strlen>
		return -E_BAD_PATH;
  80188f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801894:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801899:	7f 5e                	jg     8018f9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80189b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 35 f8 ff ff       	call   8010db <fd_alloc>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	78 4d                	js     8018f9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018b0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018b7:	e8 1f f0 ff ff       	call   8008db <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cc:	e8 1f fe ff ff       	call   8016f0 <fsipc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	79 15                	jns    8018ec <open+0x70>
		fd_close(fd, 0);
  8018d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018de:	00 
  8018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e2:	89 04 24             	mov    %eax,(%esp)
  8018e5:	e8 21 f9 ff ff       	call   80120b <fd_close>
		return r;
  8018ea:	eb 0d                	jmp    8018f9 <open+0x7d>
	}

	return fd2num(fd);
  8018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 b9 f7 ff ff       	call   8010b0 <fd2num>
  8018f7:	89 c3                	mov    %eax,%ebx
}
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	83 c4 20             	add    $0x20,%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    
	...

00801904 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	57                   	push   %edi
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
  80190a:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801910:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801917:	00 
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	89 04 24             	mov    %eax,(%esp)
  80191e:	e8 59 ff ff ff       	call   80187c <open>
  801923:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801929:	85 c0                	test   %eax,%eax
  80192b:	0f 88 b2 05 00 00    	js     801ee3 <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801931:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801938:	00 
  801939:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80193f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801943:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801949:	89 04 24             	mov    %eax,(%esp)
  80194c:	e8 4d fb ff ff       	call   80149e <readn>
  801951:	3d 00 02 00 00       	cmp    $0x200,%eax
  801956:	75 0c                	jne    801964 <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  801958:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80195f:	45 4c 46 
  801962:	74 3b                	je     80199f <spawn+0x9b>
		close(fd);
  801964:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80196a:	89 04 24             	mov    %eax,(%esp)
  80196d:	e8 2b f9 ff ff       	call   80129d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801972:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801979:	46 
  80197a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801980:	89 44 24 04          	mov    %eax,0x4(%esp)
  801984:	c7 04 24 2b 2e 80 00 	movl   $0x802e2b,(%esp)
  80198b:	e8 33 e9 ff ff       	call   8002c3 <cprintf>
		return -E_NOT_EXEC;
  801990:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  801997:	ff ff ff 
  80199a:	e9 50 05 00 00       	jmp    801eef <spawn+0x5eb>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80199f:	ba 07 00 00 00       	mov    $0x7,%edx
  8019a4:	89 d0                	mov    %edx,%eax
  8019a6:	cd 30                	int    $0x30
  8019a8:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8019ae:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 33 05 00 00    	js     801eef <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019bc:	89 c6                	mov    %eax,%esi
  8019be:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8019c4:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8019c7:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8019cd:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019d3:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019da:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019e0:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 02                	mov    (%edx),%eax
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	74 5f                	je     801a4e <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8019ef:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  8019f4:	be 00 00 00 00       	mov    $0x0,%esi
  8019f9:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  8019fb:	89 04 24             	mov    %eax,(%esp)
  8019fe:	e8 8d ee ff ff       	call   800890 <strlen>
  801a03:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a07:	83 c6 01             	add    $0x1,%esi
  801a0a:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801a0c:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a13:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801a16:	85 c0                	test   %eax,%eax
  801a18:	75 e1                	jne    8019fb <spawn+0xf7>
  801a1a:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801a20:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a26:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a2b:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a2d:	89 f8                	mov    %edi,%eax
  801a2f:	83 e0 fc             	and    $0xfffffffc,%eax
  801a32:	f7 d2                	not    %edx
  801a34:	8d 14 90             	lea    (%eax,%edx,4),%edx
  801a37:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	83 e8 08             	sub    $0x8,%eax
  801a42:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a47:	77 2d                	ja     801a76 <spawn+0x172>
  801a49:	e9 b2 04 00 00       	jmp    801f00 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a4e:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801a55:	00 00 00 
  801a58:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801a5f:	00 00 00 
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a67:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  801a6e:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a71:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a76:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a7d:	00 
  801a7e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a85:	00 
  801a86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8d:	e8 4a f3 ff ff       	call   800ddc <sys_page_alloc>
  801a92:	85 c0                	test   %eax,%eax
  801a94:	0f 88 6b 04 00 00    	js     801f05 <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a9a:	85 f6                	test   %esi,%esi
  801a9c:	7e 46                	jle    801ae4 <spawn+0x1e0>
  801a9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa3:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  801aa9:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801aac:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ab2:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801ab8:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801abb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac2:	89 3c 24             	mov    %edi,(%esp)
  801ac5:	e8 11 ee ff ff       	call   8008db <strcpy>
		string_store += strlen(argv[i]) + 1;
  801aca:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801acd:	89 04 24             	mov    %eax,(%esp)
  801ad0:	e8 bb ed ff ff       	call   800890 <strlen>
  801ad5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ad9:	83 c3 01             	add    $0x1,%ebx
  801adc:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801ae2:	75 c8                	jne    801aac <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801ae4:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801aea:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801af0:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801af7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801afd:	74 24                	je     801b23 <spawn+0x21f>
  801aff:	c7 44 24 0c a0 2e 80 	movl   $0x802ea0,0xc(%esp)
  801b06:	00 
  801b07:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801b0e:	00 
  801b0f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801b16:	00 
  801b17:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  801b1e:	e8 a5 e6 ff ff       	call   8001c8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b23:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b29:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801b2e:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801b34:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b37:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b3d:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b47:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b4d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801b54:	00 
  801b55:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801b5c:	ee 
  801b5d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b67:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b6e:	00 
  801b6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b76:	e8 c0 f2 ff ff       	call   800e3b <sys_page_map>
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	78 1a                	js     801b9b <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b81:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b88:	00 
  801b89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b90:	e8 04 f3 ff ff       	call   800e99 <sys_page_unmap>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	85 c0                	test   %eax,%eax
  801b99:	79 1f                	jns    801bba <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801b9b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ba2:	00 
  801ba3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801baa:	e8 ea f2 ff ff       	call   800e99 <sys_page_unmap>
	return r;
  801baf:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801bb5:	e9 35 03 00 00       	jmp    801eef <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bba:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801bc0:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801bc7:	00 
  801bc8:	0f 84 e2 01 00 00    	je     801db0 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bce:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801bd5:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801bdb:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801be2:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801be5:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801beb:	83 3a 01             	cmpl   $0x1,(%edx)
  801bee:	0f 85 9b 01 00 00    	jne    801d8f <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801bf4:	8b 42 18             	mov    0x18(%edx),%eax
  801bf7:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801bfa:	83 f8 01             	cmp    $0x1,%eax
  801bfd:	19 c0                	sbb    %eax,%eax
  801bff:	83 e0 fe             	and    $0xfffffffe,%eax
  801c02:	83 c0 07             	add    $0x7,%eax
  801c05:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c0b:	8b 52 04             	mov    0x4(%edx),%edx
  801c0e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801c14:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c1a:	8b 70 10             	mov    0x10(%eax),%esi
  801c1d:	8b 50 14             	mov    0x14(%eax),%edx
  801c20:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801c26:	8b 40 08             	mov    0x8(%eax),%eax
  801c29:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801c2f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c34:	74 16                	je     801c4c <spawn+0x348>
		va -= i;
  801c36:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  801c3c:	01 c2                	add    %eax,%edx
  801c3e:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  801c44:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  801c46:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c4c:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801c53:	0f 84 36 01 00 00    	je     801d8f <spawn+0x48b>
  801c59:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  801c63:	39 f7                	cmp    %esi,%edi
  801c65:	72 31                	jb     801c98 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c67:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801c6d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c71:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801c77:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c7b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 53 f1 ff ff       	call   800ddc <sys_page_alloc>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	0f 89 ea 00 00 00    	jns    801d7b <spawn+0x477>
  801c91:	89 c6                	mov    %eax,%esi
  801c93:	e9 27 02 00 00       	jmp    801ebf <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c98:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c9f:	00 
  801ca0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ca7:	00 
  801ca8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801caf:	e8 28 f1 ff ff       	call   800ddc <sys_page_alloc>
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	0f 88 f9 01 00 00    	js     801eb5 <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801cbc:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  801cc2:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc8:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 a3 f8 ff ff       	call   801579 <seek>
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	0f 88 db 01 00 00    	js     801eb9 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801cde:	89 f0                	mov    %esi,%eax
  801ce0:	29 f8                	sub    %edi,%eax
  801ce2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cec:	0f 47 c2             	cmova  %edx,%eax
  801cef:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cfa:	00 
  801cfb:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d01:	89 04 24             	mov    %eax,(%esp)
  801d04:	e8 95 f7 ff ff       	call   80149e <readn>
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	0f 88 ac 01 00 00    	js     801ebd <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d11:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801d17:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d1b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801d21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d25:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d36:	00 
  801d37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3e:	e8 f8 f0 ff ff       	call   800e3b <sys_page_map>
  801d43:	85 c0                	test   %eax,%eax
  801d45:	79 20                	jns    801d67 <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  801d47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d4b:	c7 44 24 08 51 2e 80 	movl   $0x802e51,0x8(%esp)
  801d52:	00 
  801d53:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801d5a:	00 
  801d5b:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  801d62:	e8 61 e4 ff ff       	call   8001c8 <_panic>
			sys_page_unmap(0, UTEMP);
  801d67:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d6e:	00 
  801d6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d76:	e8 1e f1 ff ff       	call   800e99 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801d7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d81:	89 df                	mov    %ebx,%edi
  801d83:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801d89:	0f 82 d4 fe ff ff    	jb     801c63 <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d8f:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801d96:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  801d9d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801da4:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801daa:	0f 8f 35 fe ff ff    	jg     801be5 <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801db0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801db6:	89 04 24             	mov    %eax,(%esp)
  801db9:	e8 df f4 ff ff       	call   80129d <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  801dc3:	89 f2                	mov    %esi,%edx
  801dc5:	c1 e2 0c             	shl    $0xc,%edx
  801dc8:	89 d0                	mov    %edx,%eax
  801dca:	c1 e8 16             	shr    $0x16,%eax
  801dcd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  801dd4:	f6 c1 01             	test   $0x1,%cl
  801dd7:	74 5b                	je     801e34 <spawn+0x530>
  801dd9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801de0:	a8 04                	test   $0x4,%al
  801de2:	74 50                	je     801e34 <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  801de4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801deb:	a8 01                	test   $0x1,%al
  801ded:	74 45                	je     801e34 <spawn+0x530>
  801def:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801df6:	a8 04                	test   $0x4,%al
  801df8:	74 3a                	je     801e34 <spawn+0x530>
  801dfa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801e01:	f6 c4 04             	test   $0x4,%ah
  801e04:	74 2e                	je     801e34 <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  801e06:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801e0d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e12:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e16:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e1a:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e24:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2f:	e8 07 f0 ff ff       	call   800e3b <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  801e34:	83 c6 01             	add    $0x1,%esi
  801e37:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  801e3d:	75 84                	jne    801dc3 <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e3f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e49:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 fe f0 ff ff       	call   800f55 <sys_env_set_trapframe>
  801e57:	85 c0                	test   %eax,%eax
  801e59:	79 20                	jns    801e7b <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  801e5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e5f:	c7 44 24 08 6e 2e 80 	movl   $0x802e6e,0x8(%esp)
  801e66:	00 
  801e67:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801e6e:	00 
  801e6f:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  801e76:	e8 4d e3 ff ff       	call   8001c8 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e7b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801e82:	00 
  801e83:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e89:	89 04 24             	mov    %eax,(%esp)
  801e8c:	e8 66 f0 ff ff       	call   800ef7 <sys_env_set_status>
  801e91:	85 c0                	test   %eax,%eax
  801e93:	79 5a                	jns    801eef <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  801e95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e99:	c7 44 24 08 88 2e 80 	movl   $0x802e88,0x8(%esp)
  801ea0:	00 
  801ea1:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801ea8:	00 
  801ea9:	c7 04 24 45 2e 80 00 	movl   $0x802e45,(%esp)
  801eb0:	e8 13 e3 ff ff       	call   8001c8 <_panic>
  801eb5:	89 c6                	mov    %eax,%esi
  801eb7:	eb 06                	jmp    801ebf <spawn+0x5bb>
  801eb9:	89 c6                	mov    %eax,%esi
  801ebb:	eb 02                	jmp    801ebf <spawn+0x5bb>
  801ebd:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  801ebf:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ec5:	89 04 24             	mov    %eax,(%esp)
  801ec8:	e8 52 ee ff ff       	call   800d1f <sys_env_destroy>
	close(fd);
  801ecd:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ed3:	89 04 24             	mov    %eax,(%esp)
  801ed6:	e8 c2 f3 ff ff       	call   80129d <close>
	return r;
  801edb:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  801ee1:	eb 0c                	jmp    801eef <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801ee3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ee9:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801eef:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801ef5:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5e                   	pop    %esi
  801efd:	5f                   	pop    %edi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801f00:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801f05:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801f0b:	eb e2                	jmp    801eef <spawn+0x5eb>

00801f0d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	56                   	push   %esi
  801f11:	53                   	push   %ebx
  801f12:	83 ec 10             	sub    $0x10,%esp
  801f15:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f18:	8d 45 14             	lea    0x14(%ebp),%eax
  801f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f1f:	74 66                	je     801f87 <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801f21:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801f26:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f29:	89 c2                	mov    %eax,%edx
  801f2b:	83 c0 04             	add    $0x4,%eax
  801f2e:	83 3a 00             	cmpl   $0x0,(%edx)
  801f31:	75 f3                	jne    801f26 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801f33:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  801f3a:	83 e0 f0             	and    $0xfffffff0,%eax
  801f3d:	29 c4                	sub    %eax,%esp
  801f3f:	8d 44 24 17          	lea    0x17(%esp),%eax
  801f43:	83 e0 f0             	and    $0xfffffff0,%eax
  801f46:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801f48:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  801f4a:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  801f51:	00 

	va_start(vl, arg0);
  801f52:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  801f55:	89 ce                	mov    %ecx,%esi
  801f57:	85 c9                	test   %ecx,%ecx
  801f59:	74 16                	je     801f71 <spawnl+0x64>
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801f60:	83 c0 01             	add    $0x1,%eax
  801f63:	89 d1                	mov    %edx,%ecx
  801f65:	83 c2 04             	add    $0x4,%edx
  801f68:	8b 09                	mov    (%ecx),%ecx
  801f6a:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f6d:	39 f0                	cmp    %esi,%eax
  801f6f:	75 ef                	jne    801f60 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801f71:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 84 f9 ff ff       	call   801904 <spawn>
}
  801f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f83:	5b                   	pop    %ebx
  801f84:	5e                   	pop    %esi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801f87:	83 ec 20             	sub    $0x20,%esp
  801f8a:	8d 44 24 17          	lea    0x17(%esp),%eax
  801f8e:	83 e0 f0             	and    $0xfffffff0,%eax
  801f91:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801f93:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  801f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f9c:	eb d3                	jmp    801f71 <spawnl+0x64>
	...

00801fa0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 18             	sub    $0x18,%esp
  801fa6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fa9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801fac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	89 04 24             	mov    %eax,(%esp)
  801fb5:	e8 06 f1 ff ff       	call   8010c0 <fd2data>
  801fba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801fbc:	c7 44 24 04 c8 2e 80 	movl   $0x802ec8,0x4(%esp)
  801fc3:	00 
  801fc4:	89 34 24             	mov    %esi,(%esp)
  801fc7:	e8 0f e9 ff ff       	call   8008db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fcc:	8b 43 04             	mov    0x4(%ebx),%eax
  801fcf:	2b 03                	sub    (%ebx),%eax
  801fd1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801fd7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801fde:	00 00 00 
	stat->st_dev = &devpipe;
  801fe1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801fe8:	30 80 00 
	return 0;
}
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ff3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ff6:	89 ec                	mov    %ebp,%esp
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	53                   	push   %ebx
  801ffe:	83 ec 14             	sub    $0x14,%esp
  802001:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802004:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802008:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200f:	e8 85 ee ff ff       	call   800e99 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802014:	89 1c 24             	mov    %ebx,(%esp)
  802017:	e8 a4 f0 ff ff       	call   8010c0 <fd2data>
  80201c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802020:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802027:	e8 6d ee ff ff       	call   800e99 <sys_page_unmap>
}
  80202c:	83 c4 14             	add    $0x14,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	83 ec 2c             	sub    $0x2c,%esp
  80203b:	89 c7                	mov    %eax,%edi
  80203d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802040:	a1 04 40 80 00       	mov    0x804004,%eax
  802045:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802048:	89 3c 24             	mov    %edi,(%esp)
  80204b:	e8 00 06 00 00       	call   802650 <pageref>
  802050:	89 c6                	mov    %eax,%esi
  802052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802055:	89 04 24             	mov    %eax,(%esp)
  802058:	e8 f3 05 00 00       	call   802650 <pageref>
  80205d:	39 c6                	cmp    %eax,%esi
  80205f:	0f 94 c0             	sete   %al
  802062:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802065:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80206b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80206e:	39 cb                	cmp    %ecx,%ebx
  802070:	75 08                	jne    80207a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802072:	83 c4 2c             	add    $0x2c,%esp
  802075:	5b                   	pop    %ebx
  802076:	5e                   	pop    %esi
  802077:	5f                   	pop    %edi
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80207a:	83 f8 01             	cmp    $0x1,%eax
  80207d:	75 c1                	jne    802040 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80207f:	8b 52 58             	mov    0x58(%edx),%edx
  802082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802086:	89 54 24 08          	mov    %edx,0x8(%esp)
  80208a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80208e:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  802095:	e8 29 e2 ff ff       	call   8002c3 <cprintf>
  80209a:	eb a4                	jmp    802040 <_pipeisclosed+0xe>

0080209c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	57                   	push   %edi
  8020a0:	56                   	push   %esi
  8020a1:	53                   	push   %ebx
  8020a2:	83 ec 2c             	sub    $0x2c,%esp
  8020a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020a8:	89 34 24             	mov    %esi,(%esp)
  8020ab:	e8 10 f0 ff ff       	call   8010c0 <fd2data>
  8020b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bb:	75 50                	jne    80210d <devpipe_write+0x71>
  8020bd:	eb 5c                	jmp    80211b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020bf:	89 da                	mov    %ebx,%edx
  8020c1:	89 f0                	mov    %esi,%eax
  8020c3:	e8 6a ff ff ff       	call   802032 <_pipeisclosed>
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 53                	jne    80211f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020cc:	e8 db ec ff ff       	call   800dac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8020d4:	8b 13                	mov    (%ebx),%edx
  8020d6:	83 c2 20             	add    $0x20,%edx
  8020d9:	39 d0                	cmp    %edx,%eax
  8020db:	73 e2                	jae    8020bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8020e4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8020e7:	89 c2                	mov    %eax,%edx
  8020e9:	c1 fa 1f             	sar    $0x1f,%edx
  8020ec:	c1 ea 1b             	shr    $0x1b,%edx
  8020ef:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8020f2:	83 e1 1f             	and    $0x1f,%ecx
  8020f5:	29 d1                	sub    %edx,%ecx
  8020f7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8020fb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8020ff:	83 c0 01             	add    $0x1,%eax
  802102:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802105:	83 c7 01             	add    $0x1,%edi
  802108:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80210b:	74 0e                	je     80211b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80210d:	8b 43 04             	mov    0x4(%ebx),%eax
  802110:	8b 13                	mov    (%ebx),%edx
  802112:	83 c2 20             	add    $0x20,%edx
  802115:	39 d0                	cmp    %edx,%eax
  802117:	73 a6                	jae    8020bf <devpipe_write+0x23>
  802119:	eb c2                	jmp    8020dd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80211b:	89 f8                	mov    %edi,%eax
  80211d:	eb 05                	jmp    802124 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802124:	83 c4 2c             	add    $0x2c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 28             	sub    $0x28,%esp
  802132:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802135:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802138:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80213b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80213e:	89 3c 24             	mov    %edi,(%esp)
  802141:	e8 7a ef ff ff       	call   8010c0 <fd2data>
  802146:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802148:	be 00 00 00 00       	mov    $0x0,%esi
  80214d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802151:	75 47                	jne    80219a <devpipe_read+0x6e>
  802153:	eb 52                	jmp    8021a7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802155:	89 f0                	mov    %esi,%eax
  802157:	eb 5e                	jmp    8021b7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802159:	89 da                	mov    %ebx,%edx
  80215b:	89 f8                	mov    %edi,%eax
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	e8 cd fe ff ff       	call   802032 <_pipeisclosed>
  802165:	85 c0                	test   %eax,%eax
  802167:	75 49                	jne    8021b2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802169:	e8 3e ec ff ff       	call   800dac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80216e:	8b 03                	mov    (%ebx),%eax
  802170:	3b 43 04             	cmp    0x4(%ebx),%eax
  802173:	74 e4                	je     802159 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802175:	89 c2                	mov    %eax,%edx
  802177:	c1 fa 1f             	sar    $0x1f,%edx
  80217a:	c1 ea 1b             	shr    $0x1b,%edx
  80217d:	01 d0                	add    %edx,%eax
  80217f:	83 e0 1f             	and    $0x1f,%eax
  802182:	29 d0                	sub    %edx,%eax
  802184:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802189:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80218f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802192:	83 c6 01             	add    $0x1,%esi
  802195:	3b 75 10             	cmp    0x10(%ebp),%esi
  802198:	74 0d                	je     8021a7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80219a:	8b 03                	mov    (%ebx),%eax
  80219c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80219f:	75 d4                	jne    802175 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021a1:	85 f6                	test   %esi,%esi
  8021a3:	75 b0                	jne    802155 <devpipe_read+0x29>
  8021a5:	eb b2                	jmp    802159 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021a7:	89 f0                	mov    %esi,%eax
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	eb 05                	jmp    8021b7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021c0:	89 ec                	mov    %ebp,%esp
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    

008021c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 48             	sub    $0x48,%esp
  8021ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8021d9:	89 04 24             	mov    %eax,(%esp)
  8021dc:	e8 fa ee ff ff       	call   8010db <fd_alloc>
  8021e1:	89 c3                	mov    %eax,%ebx
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	0f 88 45 01 00 00    	js     802330 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021f2:	00 
  8021f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802201:	e8 d6 eb ff ff       	call   800ddc <sys_page_alloc>
  802206:	89 c3                	mov    %eax,%ebx
  802208:	85 c0                	test   %eax,%eax
  80220a:	0f 88 20 01 00 00    	js     802330 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802210:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802213:	89 04 24             	mov    %eax,(%esp)
  802216:	e8 c0 ee ff ff       	call   8010db <fd_alloc>
  80221b:	89 c3                	mov    %eax,%ebx
  80221d:	85 c0                	test   %eax,%eax
  80221f:	0f 88 f8 00 00 00    	js     80231d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802225:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80222c:	00 
  80222d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802230:	89 44 24 04          	mov    %eax,0x4(%esp)
  802234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223b:	e8 9c eb ff ff       	call   800ddc <sys_page_alloc>
  802240:	89 c3                	mov    %eax,%ebx
  802242:	85 c0                	test   %eax,%eax
  802244:	0f 88 d3 00 00 00    	js     80231d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80224a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80224d:	89 04 24             	mov    %eax,(%esp)
  802250:	e8 6b ee ff ff       	call   8010c0 <fd2data>
  802255:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802257:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80225e:	00 
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80226a:	e8 6d eb ff ff       	call   800ddc <sys_page_alloc>
  80226f:	89 c3                	mov    %eax,%ebx
  802271:	85 c0                	test   %eax,%eax
  802273:	0f 88 91 00 00 00    	js     80230a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227c:	89 04 24             	mov    %eax,(%esp)
  80227f:	e8 3c ee ff ff       	call   8010c0 <fd2data>
  802284:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80228b:	00 
  80228c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802290:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802297:	00 
  802298:	89 74 24 04          	mov    %esi,0x4(%esp)
  80229c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a3:	e8 93 eb ff ff       	call   800e3b <sys_page_map>
  8022a8:	89 c3                	mov    %eax,%ebx
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	78 4c                	js     8022fa <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022ae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8022b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022c3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8022c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022cc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 cd ed ff ff       	call   8010b0 <fd2num>
  8022e3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8022e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e8:	89 04 24             	mov    %eax,(%esp)
  8022eb:	e8 c0 ed ff ff       	call   8010b0 <fd2num>
  8022f0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8022f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f8:	eb 36                	jmp    802330 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8022fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802305:	e8 8f eb ff ff       	call   800e99 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80230a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802311:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802318:	e8 7c eb ff ff       	call   800e99 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80231d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802320:	89 44 24 04          	mov    %eax,0x4(%esp)
  802324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232b:	e8 69 eb ff ff       	call   800e99 <sys_page_unmap>
    err:
	return r;
}
  802330:	89 d8                	mov    %ebx,%eax
  802332:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802335:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802338:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80233b:	89 ec                	mov    %ebp,%esp
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    

0080233f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	89 04 24             	mov    %eax,(%esp)
  802352:	e8 f7 ed ff ff       	call   80114e <fd_lookup>
  802357:	85 c0                	test   %eax,%eax
  802359:	78 15                	js     802370 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	89 04 24             	mov    %eax,(%esp)
  802361:	e8 5a ed ff ff       	call   8010c0 <fd2data>
	return _pipeisclosed(fd, p);
  802366:	89 c2                	mov    %eax,%edx
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	e8 c2 fc ff ff       	call   802032 <_pipeisclosed>
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    
	...

00802380 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    

0080238a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802390:	c7 44 24 04 e7 2e 80 	movl   $0x802ee7,0x4(%esp)
  802397:	00 
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	89 04 24             	mov    %eax,(%esp)
  80239e:	e8 38 e5 ff ff       	call   8008db <strcpy>
	return 0;
}
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	57                   	push   %edi
  8023ae:	56                   	push   %esi
  8023af:	53                   	push   %ebx
  8023b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023b6:	be 00 00 00 00       	mov    $0x0,%esi
  8023bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023bf:	74 43                	je     802404 <devcons_write+0x5a>
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023cf:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8023d1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023d4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023d9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e0:	03 45 0c             	add    0xc(%ebp),%eax
  8023e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e7:	89 3c 24             	mov    %edi,(%esp)
  8023ea:	e8 dd e6 ff ff       	call   800acc <memmove>
		sys_cputs(buf, m);
  8023ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f3:	89 3c 24             	mov    %edi,(%esp)
  8023f6:	e8 c5 e8 ff ff       	call   800cc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023fb:	01 de                	add    %ebx,%esi
  8023fd:	89 f0                	mov    %esi,%eax
  8023ff:	3b 75 10             	cmp    0x10(%ebp),%esi
  802402:	72 c8                	jb     8023cc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802404:	89 f0                	mov    %esi,%eax
  802406:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    

00802411 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80241c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802420:	75 07                	jne    802429 <devcons_read+0x18>
  802422:	eb 31                	jmp    802455 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802424:	e8 83 e9 ff ff       	call   800dac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802430:	e8 ba e8 ff ff       	call   800cef <sys_cgetc>
  802435:	85 c0                	test   %eax,%eax
  802437:	74 eb                	je     802424 <devcons_read+0x13>
  802439:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80243b:	85 c0                	test   %eax,%eax
  80243d:	78 16                	js     802455 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80243f:	83 f8 04             	cmp    $0x4,%eax
  802442:	74 0c                	je     802450 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802444:	8b 45 0c             	mov    0xc(%ebp),%eax
  802447:	88 10                	mov    %dl,(%eax)
	return 1;
  802449:	b8 01 00 00 00       	mov    $0x1,%eax
  80244e:	eb 05                	jmp    802455 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802463:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80246a:	00 
  80246b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80246e:	89 04 24             	mov    %eax,(%esp)
  802471:	e8 4a e8 ff ff       	call   800cc0 <sys_cputs>
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <getchar>:

int
getchar(void)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80247e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802485:	00 
  802486:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802494:	e8 75 ef ff ff       	call   80140e <read>
	if (r < 0)
  802499:	85 c0                	test   %eax,%eax
  80249b:	78 0f                	js     8024ac <getchar+0x34>
		return r;
	if (r < 1)
  80249d:	85 c0                	test   %eax,%eax
  80249f:	7e 06                	jle    8024a7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024a1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024a5:	eb 05                	jmp    8024ac <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024a7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	89 04 24             	mov    %eax,(%esp)
  8024c1:	e8 88 ec ff ff       	call   80114e <fd_lookup>
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	78 11                	js     8024db <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8024d3:	39 10                	cmp    %edx,(%eax)
  8024d5:	0f 94 c0             	sete   %al
  8024d8:	0f b6 c0             	movzbl %al,%eax
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <opencons>:

int
opencons(void)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 ed eb ff ff       	call   8010db <fd_alloc>
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 3c                	js     80252e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f9:	00 
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802501:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802508:	e8 cf e8 ff ff       	call   800ddc <sys_page_alloc>
  80250d:	85 c0                	test   %eax,%eax
  80250f:	78 1d                	js     80252e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802511:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802526:	89 04 24             	mov    %eax,(%esp)
  802529:	e8 82 eb ff ff       	call   8010b0 <fd2num>
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	56                   	push   %esi
  802534:	53                   	push   %ebx
  802535:	83 ec 10             	sub    $0x10,%esp
  802538:	8b 75 08             	mov    0x8(%ebp),%esi
  80253b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802541:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802543:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802548:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80254b:	89 04 24             	mov    %eax,(%esp)
  80254e:	e8 f2 ea ff ff       	call   801045 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802553:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802558:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80255d:	85 c0                	test   %eax,%eax
  80255f:	78 0e                	js     80256f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802561:	a1 04 40 80 00       	mov    0x804004,%eax
  802566:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802569:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80256c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80256f:	85 f6                	test   %esi,%esi
  802571:	74 02                	je     802575 <ipc_recv+0x45>
		*from_env_store = sender;
  802573:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802575:	85 db                	test   %ebx,%ebx
  802577:	74 02                	je     80257b <ipc_recv+0x4b>
		*perm_store = perm;
  802579:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    

00802582 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
  802585:	57                   	push   %edi
  802586:	56                   	push   %esi
  802587:	53                   	push   %ebx
  802588:	83 ec 1c             	sub    $0x1c,%esp
  80258b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80258e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802591:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802594:	85 db                	test   %ebx,%ebx
  802596:	75 04                	jne    80259c <ipc_send+0x1a>
  802598:	85 f6                	test   %esi,%esi
  80259a:	75 15                	jne    8025b1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80259c:	85 db                	test   %ebx,%ebx
  80259e:	74 16                	je     8025b6 <ipc_send+0x34>
  8025a0:	85 f6                	test   %esi,%esi
  8025a2:	0f 94 c0             	sete   %al
      pg = 0;
  8025a5:	84 c0                	test   %al,%al
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ac:	0f 45 d8             	cmovne %eax,%ebx
  8025af:	eb 05                	jmp    8025b6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8025b1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8025b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8025ba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c5:	89 04 24             	mov    %eax,(%esp)
  8025c8:	e8 44 ea ff ff       	call   801011 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8025cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025d0:	75 07                	jne    8025d9 <ipc_send+0x57>
           sys_yield();
  8025d2:	e8 d5 e7 ff ff       	call   800dac <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8025d7:	eb dd                	jmp    8025b6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	90                   	nop
  8025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	74 1c                	je     8025fe <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8025e2:	c7 44 24 08 f3 2e 80 	movl   $0x802ef3,0x8(%esp)
  8025e9:	00 
  8025ea:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8025f1:	00 
  8025f2:	c7 04 24 fd 2e 80 00 	movl   $0x802efd,(%esp)
  8025f9:	e8 ca db ff ff       	call   8001c8 <_panic>
		}
    }
}
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    

00802606 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80260c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802611:	39 c8                	cmp    %ecx,%eax
  802613:	74 17                	je     80262c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802615:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80261a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80261d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802623:	8b 52 50             	mov    0x50(%edx),%edx
  802626:	39 ca                	cmp    %ecx,%edx
  802628:	75 14                	jne    80263e <ipc_find_env+0x38>
  80262a:	eb 05                	jmp    802631 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802631:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802634:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802639:	8b 40 40             	mov    0x40(%eax),%eax
  80263c:	eb 0e                	jmp    80264c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80263e:	83 c0 01             	add    $0x1,%eax
  802641:	3d 00 04 00 00       	cmp    $0x400,%eax
  802646:	75 d2                	jne    80261a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802648:	66 b8 00 00          	mov    $0x0,%ax
}
  80264c:	5d                   	pop    %ebp
  80264d:	c3                   	ret    
	...

00802650 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802656:	89 d0                	mov    %edx,%eax
  802658:	c1 e8 16             	shr    $0x16,%eax
  80265b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802667:	f6 c1 01             	test   $0x1,%cl
  80266a:	74 1d                	je     802689 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80266c:	c1 ea 0c             	shr    $0xc,%edx
  80266f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802676:	f6 c2 01             	test   $0x1,%dl
  802679:	74 0e                	je     802689 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80267b:	c1 ea 0c             	shr    $0xc,%edx
  80267e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802685:	ef 
  802686:	0f b7 c0             	movzwl %ax,%eax
}
  802689:	5d                   	pop    %ebp
  80268a:	c3                   	ret    
  80268b:	00 00                	add    %al,(%eax)
  80268d:	00 00                	add    %al,(%eax)
	...

00802690 <__udivdi3>:
  802690:	83 ec 1c             	sub    $0x1c,%esp
  802693:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802697:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80269b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80269f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026a3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026a7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026ab:	85 ff                	test   %edi,%edi
  8026ad:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8026b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b5:	89 cd                	mov    %ecx,%ebp
  8026b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bb:	75 33                	jne    8026f0 <__udivdi3+0x60>
  8026bd:	39 f1                	cmp    %esi,%ecx
  8026bf:	77 57                	ja     802718 <__udivdi3+0x88>
  8026c1:	85 c9                	test   %ecx,%ecx
  8026c3:	75 0b                	jne    8026d0 <__udivdi3+0x40>
  8026c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ca:	31 d2                	xor    %edx,%edx
  8026cc:	f7 f1                	div    %ecx
  8026ce:	89 c1                	mov    %eax,%ecx
  8026d0:	89 f0                	mov    %esi,%eax
  8026d2:	31 d2                	xor    %edx,%edx
  8026d4:	f7 f1                	div    %ecx
  8026d6:	89 c6                	mov    %eax,%esi
  8026d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026dc:	f7 f1                	div    %ecx
  8026de:	89 f2                	mov    %esi,%edx
  8026e0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026e4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026e8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ec:	83 c4 1c             	add    $0x1c,%esp
  8026ef:	c3                   	ret    
  8026f0:	31 d2                	xor    %edx,%edx
  8026f2:	31 c0                	xor    %eax,%eax
  8026f4:	39 f7                	cmp    %esi,%edi
  8026f6:	77 e8                	ja     8026e0 <__udivdi3+0x50>
  8026f8:	0f bd cf             	bsr    %edi,%ecx
  8026fb:	83 f1 1f             	xor    $0x1f,%ecx
  8026fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802702:	75 2c                	jne    802730 <__udivdi3+0xa0>
  802704:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802708:	76 04                	jbe    80270e <__udivdi3+0x7e>
  80270a:	39 f7                	cmp    %esi,%edi
  80270c:	73 d2                	jae    8026e0 <__udivdi3+0x50>
  80270e:	31 d2                	xor    %edx,%edx
  802710:	b8 01 00 00 00       	mov    $0x1,%eax
  802715:	eb c9                	jmp    8026e0 <__udivdi3+0x50>
  802717:	90                   	nop
  802718:	89 f2                	mov    %esi,%edx
  80271a:	f7 f1                	div    %ecx
  80271c:	31 d2                	xor    %edx,%edx
  80271e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802722:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802726:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80272a:	83 c4 1c             	add    $0x1c,%esp
  80272d:	c3                   	ret    
  80272e:	66 90                	xchg   %ax,%ax
  802730:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802735:	b8 20 00 00 00       	mov    $0x20,%eax
  80273a:	89 ea                	mov    %ebp,%edx
  80273c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802740:	d3 e7                	shl    %cl,%edi
  802742:	89 c1                	mov    %eax,%ecx
  802744:	d3 ea                	shr    %cl,%edx
  802746:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80274b:	09 fa                	or     %edi,%edx
  80274d:	89 f7                	mov    %esi,%edi
  80274f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802753:	89 f2                	mov    %esi,%edx
  802755:	8b 74 24 08          	mov    0x8(%esp),%esi
  802759:	d3 e5                	shl    %cl,%ebp
  80275b:	89 c1                	mov    %eax,%ecx
  80275d:	d3 ef                	shr    %cl,%edi
  80275f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802764:	d3 e2                	shl    %cl,%edx
  802766:	89 c1                	mov    %eax,%ecx
  802768:	d3 ee                	shr    %cl,%esi
  80276a:	09 d6                	or     %edx,%esi
  80276c:	89 fa                	mov    %edi,%edx
  80276e:	89 f0                	mov    %esi,%eax
  802770:	f7 74 24 0c          	divl   0xc(%esp)
  802774:	89 d7                	mov    %edx,%edi
  802776:	89 c6                	mov    %eax,%esi
  802778:	f7 e5                	mul    %ebp
  80277a:	39 d7                	cmp    %edx,%edi
  80277c:	72 22                	jb     8027a0 <__udivdi3+0x110>
  80277e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802782:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802787:	d3 e5                	shl    %cl,%ebp
  802789:	39 c5                	cmp    %eax,%ebp
  80278b:	73 04                	jae    802791 <__udivdi3+0x101>
  80278d:	39 d7                	cmp    %edx,%edi
  80278f:	74 0f                	je     8027a0 <__udivdi3+0x110>
  802791:	89 f0                	mov    %esi,%eax
  802793:	31 d2                	xor    %edx,%edx
  802795:	e9 46 ff ff ff       	jmp    8026e0 <__udivdi3+0x50>
  80279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027a0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027a9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027ad:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027b1:	83 c4 1c             	add    $0x1c,%esp
  8027b4:	c3                   	ret    
	...

008027c0 <__umoddi3>:
  8027c0:	83 ec 1c             	sub    $0x1c,%esp
  8027c3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8027c7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8027cb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8027cf:	89 74 24 10          	mov    %esi,0x10(%esp)
  8027d3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8027d7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8027db:	85 ed                	test   %ebp,%ebp
  8027dd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8027e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e5:	89 cf                	mov    %ecx,%edi
  8027e7:	89 04 24             	mov    %eax,(%esp)
  8027ea:	89 f2                	mov    %esi,%edx
  8027ec:	75 1a                	jne    802808 <__umoddi3+0x48>
  8027ee:	39 f1                	cmp    %esi,%ecx
  8027f0:	76 4e                	jbe    802840 <__umoddi3+0x80>
  8027f2:	f7 f1                	div    %ecx
  8027f4:	89 d0                	mov    %edx,%eax
  8027f6:	31 d2                	xor    %edx,%edx
  8027f8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027fc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802800:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802804:	83 c4 1c             	add    $0x1c,%esp
  802807:	c3                   	ret    
  802808:	39 f5                	cmp    %esi,%ebp
  80280a:	77 54                	ja     802860 <__umoddi3+0xa0>
  80280c:	0f bd c5             	bsr    %ebp,%eax
  80280f:	83 f0 1f             	xor    $0x1f,%eax
  802812:	89 44 24 04          	mov    %eax,0x4(%esp)
  802816:	75 60                	jne    802878 <__umoddi3+0xb8>
  802818:	3b 0c 24             	cmp    (%esp),%ecx
  80281b:	0f 87 07 01 00 00    	ja     802928 <__umoddi3+0x168>
  802821:	89 f2                	mov    %esi,%edx
  802823:	8b 34 24             	mov    (%esp),%esi
  802826:	29 ce                	sub    %ecx,%esi
  802828:	19 ea                	sbb    %ebp,%edx
  80282a:	89 34 24             	mov    %esi,(%esp)
  80282d:	8b 04 24             	mov    (%esp),%eax
  802830:	8b 74 24 10          	mov    0x10(%esp),%esi
  802834:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802838:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80283c:	83 c4 1c             	add    $0x1c,%esp
  80283f:	c3                   	ret    
  802840:	85 c9                	test   %ecx,%ecx
  802842:	75 0b                	jne    80284f <__umoddi3+0x8f>
  802844:	b8 01 00 00 00       	mov    $0x1,%eax
  802849:	31 d2                	xor    %edx,%edx
  80284b:	f7 f1                	div    %ecx
  80284d:	89 c1                	mov    %eax,%ecx
  80284f:	89 f0                	mov    %esi,%eax
  802851:	31 d2                	xor    %edx,%edx
  802853:	f7 f1                	div    %ecx
  802855:	8b 04 24             	mov    (%esp),%eax
  802858:	f7 f1                	div    %ecx
  80285a:	eb 98                	jmp    8027f4 <__umoddi3+0x34>
  80285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802860:	89 f2                	mov    %esi,%edx
  802862:	8b 74 24 10          	mov    0x10(%esp),%esi
  802866:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80286a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80286e:	83 c4 1c             	add    $0x1c,%esp
  802871:	c3                   	ret    
  802872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802878:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80287d:	89 e8                	mov    %ebp,%eax
  80287f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802884:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802888:	89 fa                	mov    %edi,%edx
  80288a:	d3 e0                	shl    %cl,%eax
  80288c:	89 e9                	mov    %ebp,%ecx
  80288e:	d3 ea                	shr    %cl,%edx
  802890:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802895:	09 c2                	or     %eax,%edx
  802897:	8b 44 24 08          	mov    0x8(%esp),%eax
  80289b:	89 14 24             	mov    %edx,(%esp)
  80289e:	89 f2                	mov    %esi,%edx
  8028a0:	d3 e7                	shl    %cl,%edi
  8028a2:	89 e9                	mov    %ebp,%ecx
  8028a4:	d3 ea                	shr    %cl,%edx
  8028a6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028af:	d3 e6                	shl    %cl,%esi
  8028b1:	89 e9                	mov    %ebp,%ecx
  8028b3:	d3 e8                	shr    %cl,%eax
  8028b5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ba:	09 f0                	or     %esi,%eax
  8028bc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8028c0:	f7 34 24             	divl   (%esp)
  8028c3:	d3 e6                	shl    %cl,%esi
  8028c5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028c9:	89 d6                	mov    %edx,%esi
  8028cb:	f7 e7                	mul    %edi
  8028cd:	39 d6                	cmp    %edx,%esi
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	89 d7                	mov    %edx,%edi
  8028d3:	72 3f                	jb     802914 <__umoddi3+0x154>
  8028d5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8028d9:	72 35                	jb     802910 <__umoddi3+0x150>
  8028db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028df:	29 c8                	sub    %ecx,%eax
  8028e1:	19 fe                	sbb    %edi,%esi
  8028e3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028e8:	89 f2                	mov    %esi,%edx
  8028ea:	d3 e8                	shr    %cl,%eax
  8028ec:	89 e9                	mov    %ebp,%ecx
  8028ee:	d3 e2                	shl    %cl,%edx
  8028f0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028f5:	09 d0                	or     %edx,%eax
  8028f7:	89 f2                	mov    %esi,%edx
  8028f9:	d3 ea                	shr    %cl,%edx
  8028fb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8028ff:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802903:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802907:	83 c4 1c             	add    $0x1c,%esp
  80290a:	c3                   	ret    
  80290b:	90                   	nop
  80290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802910:	39 d6                	cmp    %edx,%esi
  802912:	75 c7                	jne    8028db <__umoddi3+0x11b>
  802914:	89 d7                	mov    %edx,%edi
  802916:	89 c1                	mov    %eax,%ecx
  802918:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80291c:	1b 3c 24             	sbb    (%esp),%edi
  80291f:	eb ba                	jmp    8028db <__umoddi3+0x11b>
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	39 f5                	cmp    %esi,%ebp
  80292a:	0f 82 f1 fe ff ff    	jb     802821 <__umoddi3+0x61>
  802930:	e9 f8 fe ff ff       	jmp    80282d <__umoddi3+0x6d>
