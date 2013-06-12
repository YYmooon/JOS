
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
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
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003d:	c7 04 24 80 27 80 00 	movl   $0x802780,(%esp)
  800044:	e8 0a 03 00 00       	call   800353 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 10 1f 00 00       	call   801f64 <pipe>
  800054:	85 c0                	test   %eax,%eax
  800056:	79 20                	jns    800078 <umain+0x44>
		panic("pipe: %e", r);
  800058:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005c:	c7 44 24 08 ce 27 80 	movl   $0x8027ce,0x8(%esp)
  800063:	00 
  800064:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006b:	00 
  80006c:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  800073:	e8 e0 01 00 00       	call   800258 <_panic>
	if ((r = fork()) < 0)
  800078:	e8 b6 11 00 00       	call   801233 <fork>
  80007d:	89 c7                	mov    %eax,%edi
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 20                	jns    8000a3 <umain+0x6f>
		panic("fork: %e", r);
  800083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800087:	c7 44 24 08 15 2d 80 	movl   $0x802d15,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  80009e:	e8 b5 01 00 00       	call   800258 <_panic>
	if (r == 0) {
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 75                	jne    80011c <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000aa:	89 04 24             	mov    %eax,(%esp)
  8000ad:	e8 1b 16 00 00       	call   8016cd <close>
		for (i = 0; i < 200; i++) {
  8000b2:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	f7 ee                	imul   %esi
  8000c0:	c1 fa 02             	sar    $0x2,%edx
  8000c3:	89 d8                	mov    %ebx,%eax
  8000c5:	c1 f8 1f             	sar    $0x1f,%eax
  8000c8:	29 c2                	sub    %eax,%edx
  8000ca:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	39 c3                	cmp    %eax,%ebx
  8000d1:	75 10                	jne    8000e3 <umain+0xaf>
				cprintf("%d.", i);
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8000de:	e8 70 02 00 00       	call   800353 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000ea:	00 
  8000eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 2a 16 00 00       	call   801720 <dup>
			sys_yield();
  8000f6:	e8 41 0d 00 00       	call   800e3c <sys_yield>
			close(10);
  8000fb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800102:	e8 c6 15 00 00       	call   8016cd <close>
			sys_yield();
  800107:	e8 30 0d 00 00       	call   800e3c <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010c:	83 c3 01             	add    $0x1,%ebx
  80010f:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800115:	75 a5                	jne    8000bc <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800117:	e8 20 01 00 00       	call   80023c <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011c:	89 fb                	mov    %edi,%ebx
  80011e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800124:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800127:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012d:	eb 28                	jmp    800157 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800132:	89 04 24             	mov    %eax,(%esp)
  800135:	e8 a5 1f 00 00       	call   8020df <pipeisclosed>
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 19                	je     800157 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013e:	c7 04 24 f0 27 80 00 	movl   $0x8027f0,(%esp)
  800145:	e8 09 02 00 00       	call   800353 <cprintf>
			sys_env_destroy(r);
  80014a:	89 3c 24             	mov    %edi,(%esp)
  80014d:	e8 5d 0c 00 00       	call   800daf <sys_env_destroy>
			exit();
  800152:	e8 e5 00 00 00       	call   80023c <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800157:	8b 43 54             	mov    0x54(%ebx),%eax
  80015a:	83 f8 02             	cmp    $0x2,%eax
  80015d:	74 d0                	je     80012f <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015f:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  800166:	e8 e8 01 00 00       	call   800353 <cprintf>
	if (pipeisclosed(p[0]))
  80016b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016e:	89 04 24             	mov    %eax,(%esp)
  800171:	e8 69 1f 00 00       	call   8020df <pipeisclosed>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 1c                	je     800196 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  80017a:	c7 44 24 08 a4 27 80 	movl   $0x8027a4,0x8(%esp)
  800181:	00 
  800182:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800189:	00 
  80018a:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  800191:	e8 c2 00 00 00       	call   800258 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800196:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 d6 13 00 00       	call   80157e <fd_lookup>
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	79 20                	jns    8001cc <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	c7 44 24 08 22 28 80 	movl   $0x802822,0x8(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001bf:	00 
  8001c0:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  8001c7:	e8 8c 00 00 00       	call   800258 <_panic>
	(void) fd2data(fd);
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	89 04 24             	mov    %eax,(%esp)
  8001d2:	e8 19 13 00 00       	call   8014f0 <fd2data>
	cprintf("race didn't happen\n");
  8001d7:	c7 04 24 3a 28 80 00 	movl   $0x80283a,(%esp)
  8001de:	e8 70 01 00 00       	call   800353 <cprintf>
}
  8001e3:	83 c4 2c             	add    $0x2c,%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5f                   	pop    %edi
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    
	...

008001ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
  8001f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001fe:	e8 09 0c 00 00       	call   800e0c <sys_getenvid>
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800210:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 f6                	test   %esi,%esi
  800217:	7e 07                	jle    800220 <libmain+0x34>
		binaryname = argv[0];
  800219:	8b 03                	mov    (%ebx),%eax
  80021b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800224:	89 34 24             	mov    %esi,(%esp)
  800227:	e8 08 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80022c:	e8 0b 00 00 00       	call   80023c <exit>
}
  800231:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800234:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800237:	89 ec                	mov    %ebp,%esp
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    
	...

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800242:	e8 b7 14 00 00       	call   8016fe <close_all>
	sys_env_destroy(0);
  800247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024e:	e8 5c 0b 00 00       	call   800daf <sys_env_destroy>
}
  800253:	c9                   	leave  
  800254:	c3                   	ret    
  800255:	00 00                	add    %al,(%eax)
	...

00800258 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800260:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800263:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800269:	e8 9e 0b 00 00       	call   800e0c <sys_getenvid>
  80026e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800271:	89 54 24 10          	mov    %edx,0x10(%esp)
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80027c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800280:	89 44 24 04          	mov    %eax,0x4(%esp)
  800284:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  80028b:	e8 c3 00 00 00       	call   800353 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800290:	89 74 24 04          	mov    %esi,0x4(%esp)
  800294:	8b 45 10             	mov    0x10(%ebp),%eax
  800297:	89 04 24             	mov    %eax,(%esp)
  80029a:	e8 53 00 00 00       	call   8002f2 <vcprintf>
	cprintf("\n");
  80029f:	c7 04 24 27 2e 80 00 	movl   $0x802e27,(%esp)
  8002a6:	e8 a8 00 00 00       	call   800353 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ab:	cc                   	int3   
  8002ac:	eb fd                	jmp    8002ab <_panic+0x53>
	...

008002b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 14             	sub    $0x14,%esp
  8002b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ba:	8b 03                	mov    (%ebx),%eax
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002c3:	83 c0 01             	add    $0x1,%eax
  8002c6:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002cd:	75 19                	jne    8002e8 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002cf:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002d6:	00 
  8002d7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002da:	89 04 24             	mov    %eax,(%esp)
  8002dd:	e8 6e 0a 00 00       	call   800d50 <sys_cputs>
		b->idx = 0;
  8002e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002e8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ec:	83 c4 14             	add    $0x14,%esp
  8002ef:	5b                   	pop    %ebx
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800302:	00 00 00 
	b.cnt = 0;
  800305:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800312:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800323:	89 44 24 04          	mov    %eax,0x4(%esp)
  800327:	c7 04 24 b0 02 80 00 	movl   $0x8002b0,(%esp)
  80032e:	e8 97 01 00 00       	call   8004ca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800333:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800343:	89 04 24             	mov    %eax,(%esp)
  800346:	e8 05 0a 00 00       	call   800d50 <sys_cputs>

	return b.cnt;
}
  80034b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800351:	c9                   	leave  
  800352:	c3                   	ret    

00800353 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800359:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80035c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	e8 87 ff ff ff       	call   8002f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80036b:	c9                   	leave  
  80036c:	c3                   	ret    
  80036d:	00 00                	add    %al,(%eax)
	...

00800370 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 3c             	sub    $0x3c,%esp
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037c:	89 d7                	mov    %edx,%edi
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80038a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80038d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800390:	b8 00 00 00 00       	mov    $0x0,%eax
  800395:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800398:	72 11                	jb     8003ab <printnum+0x3b>
  80039a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039d:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003a0:	76 09                	jbe    8003ab <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a2:	83 eb 01             	sub    $0x1,%ebx
  8003a5:	85 db                	test   %ebx,%ebx
  8003a7:	7f 51                	jg     8003fa <printnum+0x8a>
  8003a9:	eb 5e                	jmp    800409 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ab:	89 74 24 10          	mov    %esi,0x10(%esp)
  8003af:	83 eb 01             	sub    $0x1,%ebx
  8003b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003bd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8003c1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8003c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003cc:	00 
  8003cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d0:	89 04 24             	mov    %eax,(%esp)
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003da:	e8 f1 20 00 00       	call   8024d0 <__udivdi3>
  8003df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003ee:	89 fa                	mov    %edi,%edx
  8003f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f3:	e8 78 ff ff ff       	call   800370 <printnum>
  8003f8:	eb 0f                	jmp    800409 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fe:	89 34 24             	mov    %esi,(%esp)
  800401:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800404:	83 eb 01             	sub    $0x1,%ebx
  800407:	75 f1                	jne    8003fa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800409:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80040d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800411:	8b 45 10             	mov    0x10(%ebp),%eax
  800414:	89 44 24 08          	mov    %eax,0x8(%esp)
  800418:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041f:	00 
  800420:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800423:	89 04 24             	mov    %eax,(%esp)
  800426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800429:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042d:	e8 ce 21 00 00       	call   802600 <__umoddi3>
  800432:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800436:	0f be 80 7b 28 80 00 	movsbl 0x80287b(%eax),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800443:	83 c4 3c             	add    $0x3c,%esp
  800446:	5b                   	pop    %ebx
  800447:	5e                   	pop    %esi
  800448:	5f                   	pop    %edi
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044e:	83 fa 01             	cmp    $0x1,%edx
  800451:	7e 0e                	jle    800461 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800453:	8b 10                	mov    (%eax),%edx
  800455:	8d 4a 08             	lea    0x8(%edx),%ecx
  800458:	89 08                	mov    %ecx,(%eax)
  80045a:	8b 02                	mov    (%edx),%eax
  80045c:	8b 52 04             	mov    0x4(%edx),%edx
  80045f:	eb 22                	jmp    800483 <getuint+0x38>
	else if (lflag)
  800461:	85 d2                	test   %edx,%edx
  800463:	74 10                	je     800475 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800465:	8b 10                	mov    (%eax),%edx
  800467:	8d 4a 04             	lea    0x4(%edx),%ecx
  80046a:	89 08                	mov    %ecx,(%eax)
  80046c:	8b 02                	mov    (%edx),%eax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
  800473:	eb 0e                	jmp    800483 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800475:	8b 10                	mov    (%eax),%edx
  800477:	8d 4a 04             	lea    0x4(%edx),%ecx
  80047a:	89 08                	mov    %ecx,(%eax)
  80047c:	8b 02                	mov    (%edx),%eax
  80047e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800483:	5d                   	pop    %ebp
  800484:	c3                   	ret    

00800485 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80048b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048f:	8b 10                	mov    (%eax),%edx
  800491:	3b 50 04             	cmp    0x4(%eax),%edx
  800494:	73 0a                	jae    8004a0 <sprintputch+0x1b>
		*b->buf++ = ch;
  800496:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800499:	88 0a                	mov    %cl,(%edx)
  80049b:	83 c2 01             	add    $0x1,%edx
  80049e:	89 10                	mov    %edx,(%eax)
}
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    

008004a2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004a8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	89 04 24             	mov    %eax,(%esp)
  8004c3:	e8 02 00 00 00       	call   8004ca <vprintfmt>
	va_end(ap);
}
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	57                   	push   %edi
  8004ce:	56                   	push   %esi
  8004cf:	53                   	push   %ebx
  8004d0:	83 ec 4c             	sub    $0x4c,%esp
  8004d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d6:	8b 75 10             	mov    0x10(%ebp),%esi
  8004d9:	eb 12                	jmp    8004ed <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	0f 84 a9 03 00 00    	je     80088c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8004e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ed:	0f b6 06             	movzbl (%esi),%eax
  8004f0:	83 c6 01             	add    $0x1,%esi
  8004f3:	83 f8 25             	cmp    $0x25,%eax
  8004f6:	75 e3                	jne    8004db <vprintfmt+0x11>
  8004f8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800503:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800508:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80050f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800514:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800517:	eb 2b                	jmp    800544 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800519:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80051c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800520:	eb 22                	jmp    800544 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800525:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800529:	eb 19                	jmp    800544 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80052e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800535:	eb 0d                	jmp    800544 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800544:	0f b6 06             	movzbl (%esi),%eax
  800547:	0f b6 d0             	movzbl %al,%edx
  80054a:	8d 7e 01             	lea    0x1(%esi),%edi
  80054d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800550:	83 e8 23             	sub    $0x23,%eax
  800553:	3c 55                	cmp    $0x55,%al
  800555:	0f 87 0b 03 00 00    	ja     800866 <vprintfmt+0x39c>
  80055b:	0f b6 c0             	movzbl %al,%eax
  80055e:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800565:	83 ea 30             	sub    $0x30,%edx
  800568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80056b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80056f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800575:	83 fa 09             	cmp    $0x9,%edx
  800578:	77 4a                	ja     8005c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800580:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800583:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800587:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80058a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80058d:	83 fa 09             	cmp    $0x9,%edx
  800590:	76 eb                	jbe    80057d <vprintfmt+0xb3>
  800592:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800595:	eb 2d                	jmp    8005c4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 50 04             	lea    0x4(%eax),%edx
  80059d:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005a8:	eb 1a                	jmp    8005c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8005ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b1:	79 91                	jns    800544 <vprintfmt+0x7a>
  8005b3:	e9 73 ff ff ff       	jmp    80052b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c2:	eb 80                	jmp    800544 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8005c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c8:	0f 89 76 ff ff ff    	jns    800544 <vprintfmt+0x7a>
  8005ce:	e9 64 ff ff ff       	jmp    800537 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005d9:	e9 66 ff ff ff       	jmp    800544 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 50 04             	lea    0x4(%eax),%edx
  8005e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 04 24             	mov    %eax,(%esp)
  8005f0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8005f6:	e9 f2 fe ff ff       	jmp    8004ed <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 50 04             	lea    0x4(%eax),%edx
  800601:	89 55 14             	mov    %edx,0x14(%ebp)
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	c1 fa 1f             	sar    $0x1f,%edx
  80060b:	31 d0                	xor    %edx,%eax
  80060d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80060f:	83 f8 0f             	cmp    $0xf,%eax
  800612:	7f 0b                	jg     80061f <vprintfmt+0x155>
  800614:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  80061b:	85 d2                	test   %edx,%edx
  80061d:	75 23                	jne    800642 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80061f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800623:	c7 44 24 08 93 28 80 	movl   $0x802893,0x8(%esp)
  80062a:	00 
  80062b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80062f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800632:	89 3c 24             	mov    %edi,(%esp)
  800635:	e8 68 fe ff ff       	call   8004a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80063d:	e9 ab fe ff ff       	jmp    8004ed <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800642:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800646:	c7 44 24 08 f5 2d 80 	movl   $0x802df5,0x8(%esp)
  80064d:	00 
  80064e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800652:	8b 7d 08             	mov    0x8(%ebp),%edi
  800655:	89 3c 24             	mov    %edi,(%esp)
  800658:	e8 45 fe ff ff       	call   8004a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800660:	e9 88 fe ff ff       	jmp    8004ed <vprintfmt+0x23>
  800665:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	89 55 14             	mov    %edx,0x14(%ebp)
  800677:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800679:	85 f6                	test   %esi,%esi
  80067b:	ba 8c 28 80 00       	mov    $0x80288c,%edx
  800680:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800683:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800687:	7e 06                	jle    80068f <vprintfmt+0x1c5>
  800689:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80068d:	75 10                	jne    80069f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068f:	0f be 06             	movsbl (%esi),%eax
  800692:	83 c6 01             	add    $0x1,%esi
  800695:	85 c0                	test   %eax,%eax
  800697:	0f 85 86 00 00 00    	jne    800723 <vprintfmt+0x259>
  80069d:	eb 76                	jmp    800715 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a3:	89 34 24             	mov    %esi,(%esp)
  8006a6:	e8 90 02 00 00       	call   80093b <strnlen>
  8006ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ae:	29 c2                	sub    %eax,%edx
  8006b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b3:	85 d2                	test   %edx,%edx
  8006b5:	7e d8                	jle    80068f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8006be:	89 d6                	mov    %edx,%esi
  8006c0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8006c3:	89 c7                	mov    %eax,%edi
  8006c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006c9:	89 3c 24             	mov    %edi,(%esp)
  8006cc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	83 ee 01             	sub    $0x1,%esi
  8006d2:	75 f1                	jne    8006c5 <vprintfmt+0x1fb>
  8006d4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006d7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8006da:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8006dd:	eb b0                	jmp    80068f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e3:	74 18                	je     8006fd <vprintfmt+0x233>
  8006e5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006e8:	83 fa 5e             	cmp    $0x5e,%edx
  8006eb:	76 10                	jbe    8006fd <vprintfmt+0x233>
					putch('?', putdat);
  8006ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006f8:	ff 55 08             	call   *0x8(%ebp)
  8006fb:	eb 0a                	jmp    800707 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8006fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800701:	89 04 24             	mov    %eax,(%esp)
  800704:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800707:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80070b:	0f be 06             	movsbl (%esi),%eax
  80070e:	83 c6 01             	add    $0x1,%esi
  800711:	85 c0                	test   %eax,%eax
  800713:	75 0e                	jne    800723 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800715:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	7f 16                	jg     800734 <vprintfmt+0x26a>
  80071e:	e9 ca fd ff ff       	jmp    8004ed <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800723:	85 ff                	test   %edi,%edi
  800725:	78 b8                	js     8006df <vprintfmt+0x215>
  800727:	83 ef 01             	sub    $0x1,%edi
  80072a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800730:	79 ad                	jns    8006df <vprintfmt+0x215>
  800732:	eb e1                	jmp    800715 <vprintfmt+0x24b>
  800734:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800737:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80073a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80073e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800745:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800747:	83 ee 01             	sub    $0x1,%esi
  80074a:	75 ee                	jne    80073a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80074f:	e9 99 fd ff ff       	jmp    8004ed <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800754:	83 f9 01             	cmp    $0x1,%ecx
  800757:	7e 10                	jle    800769 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8d 50 08             	lea    0x8(%eax),%edx
  80075f:	89 55 14             	mov    %edx,0x14(%ebp)
  800762:	8b 30                	mov    (%eax),%esi
  800764:	8b 78 04             	mov    0x4(%eax),%edi
  800767:	eb 26                	jmp    80078f <vprintfmt+0x2c5>
	else if (lflag)
  800769:	85 c9                	test   %ecx,%ecx
  80076b:	74 12                	je     80077f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 50 04             	lea    0x4(%eax),%edx
  800773:	89 55 14             	mov    %edx,0x14(%ebp)
  800776:	8b 30                	mov    (%eax),%esi
  800778:	89 f7                	mov    %esi,%edi
  80077a:	c1 ff 1f             	sar    $0x1f,%edi
  80077d:	eb 10                	jmp    80078f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	89 55 14             	mov    %edx,0x14(%ebp)
  800788:	8b 30                	mov    (%eax),%esi
  80078a:	89 f7                	mov    %esi,%edi
  80078c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80078f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800794:	85 ff                	test   %edi,%edi
  800796:	0f 89 8c 00 00 00    	jns    800828 <vprintfmt+0x35e>
				putch('-', putdat);
  80079c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007a7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007aa:	f7 de                	neg    %esi
  8007ac:	83 d7 00             	adc    $0x0,%edi
  8007af:	f7 df                	neg    %edi
			}
			base = 10;
  8007b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b6:	eb 70                	jmp    800828 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b8:	89 ca                	mov    %ecx,%edx
  8007ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bd:	e8 89 fc ff ff       	call   80044b <getuint>
  8007c2:	89 c6                	mov    %eax,%esi
  8007c4:	89 d7                	mov    %edx,%edi
			base = 10;
  8007c6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007cb:	eb 5b                	jmp    800828 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007cd:	89 ca                	mov    %ecx,%edx
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	e8 74 fc ff ff       	call   80044b <getuint>
  8007d7:	89 c6                	mov    %eax,%esi
  8007d9:	89 d7                	mov    %edx,%edi
			base = 8;
  8007db:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007e0:	eb 46                	jmp    800828 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800807:	8b 30                	mov    (%eax),%esi
  800809:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80080e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800813:	eb 13                	jmp    800828 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800815:	89 ca                	mov    %ecx,%edx
  800817:	8d 45 14             	lea    0x14(%ebp),%eax
  80081a:	e8 2c fc ff ff       	call   80044b <getuint>
  80081f:	89 c6                	mov    %eax,%esi
  800821:	89 d7                	mov    %edx,%edi
			base = 16;
  800823:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800828:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80082c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800830:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800833:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800837:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083b:	89 34 24             	mov    %esi,(%esp)
  80083e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800842:	89 da                	mov    %ebx,%edx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	e8 24 fb ff ff       	call   800370 <printnum>
			break;
  80084c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80084f:	e9 99 fc ff ff       	jmp    8004ed <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800854:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800858:	89 14 24             	mov    %edx,(%esp)
  80085b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800861:	e9 87 fc ff ff       	jmp    8004ed <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800866:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80086a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800871:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800874:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800878:	0f 84 6f fc ff ff    	je     8004ed <vprintfmt+0x23>
  80087e:	83 ee 01             	sub    $0x1,%esi
  800881:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800885:	75 f7                	jne    80087e <vprintfmt+0x3b4>
  800887:	e9 61 fc ff ff       	jmp    8004ed <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80088c:	83 c4 4c             	add    $0x4c,%esp
  80088f:	5b                   	pop    %ebx
  800890:	5e                   	pop    %esi
  800891:	5f                   	pop    %edi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 28             	sub    $0x28,%esp
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 30                	je     8008e5 <vsnprintf+0x51>
  8008b5:	85 d2                	test   %edx,%edx
  8008b7:	7e 2c                	jle    8008e5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ce:	c7 04 24 85 04 80 00 	movl   $0x800485,(%esp)
  8008d5:	e8 f0 fb ff ff       	call   8004ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	eb 05                	jmp    8008ea <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 44 24 04          	mov    %eax,0x4(%esp)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 04 24             	mov    %eax,(%esp)
  80090d:	e8 82 ff ff ff       	call   800894 <vsnprintf>
	va_end(ap);

	return rc;
}
  800912:	c9                   	leave  
  800913:	c3                   	ret    
	...

00800920 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	80 3a 00             	cmpb   $0x0,(%edx)
  80092e:	74 09                	je     800939 <strlen+0x19>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	75 f7                	jne    800930 <strlen+0x10>
		n++;
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	85 c9                	test   %ecx,%ecx
  80094c:	74 1a                	je     800968 <strnlen+0x2d>
  80094e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800951:	74 15                	je     800968 <strnlen+0x2d>
  800953:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800958:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095a:	39 ca                	cmp    %ecx,%edx
  80095c:	74 0a                	je     800968 <strnlen+0x2d>
  80095e:	83 c2 01             	add    $0x1,%edx
  800961:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800966:	75 f0                	jne    800958 <strnlen+0x1d>
		n++;
	return n;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800975:	ba 00 00 00 00       	mov    $0x0,%edx
  80097a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	84 c9                	test   %cl,%cl
  800986:	75 f2                	jne    80097a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800988:	5b                   	pop    %ebx
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	53                   	push   %ebx
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800995:	89 1c 24             	mov    %ebx,(%esp)
  800998:	e8 83 ff ff ff       	call   800920 <strlen>
	strcpy(dst + len, src);
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009a4:	01 d8                	add    %ebx,%eax
  8009a6:	89 04 24             	mov    %eax,(%esp)
  8009a9:	e8 bd ff ff ff       	call   80096b <strcpy>
	return dst;
}
  8009ae:	89 d8                	mov    %ebx,%eax
  8009b0:	83 c4 08             	add    $0x8,%esp
  8009b3:	5b                   	pop    %ebx
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c4:	85 f6                	test   %esi,%esi
  8009c6:	74 18                	je     8009e0 <strncpy+0x2a>
  8009c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009cd:	0f b6 1a             	movzbl (%edx),%ebx
  8009d0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d3:	80 3a 01             	cmpb   $0x1,(%edx)
  8009d6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d9:	83 c1 01             	add    $0x1,%ecx
  8009dc:	39 f1                	cmp    %esi,%ecx
  8009de:	75 ed                	jne    8009cd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	57                   	push   %edi
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009f0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f3:	89 f8                	mov    %edi,%eax
  8009f5:	85 f6                	test   %esi,%esi
  8009f7:	74 2b                	je     800a24 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8009f9:	83 fe 01             	cmp    $0x1,%esi
  8009fc:	74 23                	je     800a21 <strlcpy+0x3d>
  8009fe:	0f b6 0b             	movzbl (%ebx),%ecx
  800a01:	84 c9                	test   %cl,%cl
  800a03:	74 1c                	je     800a21 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800a05:	83 ee 02             	sub    $0x2,%esi
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a0d:	88 08                	mov    %cl,(%eax)
  800a0f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a12:	39 f2                	cmp    %esi,%edx
  800a14:	74 0b                	je     800a21 <strlcpy+0x3d>
  800a16:	83 c2 01             	add    $0x1,%edx
  800a19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a1d:	84 c9                	test   %cl,%cl
  800a1f:	75 ec                	jne    800a0d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800a21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a24:	29 f8                	sub    %edi,%eax
}
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5f                   	pop    %edi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a31:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a34:	0f b6 01             	movzbl (%ecx),%eax
  800a37:	84 c0                	test   %al,%al
  800a39:	74 16                	je     800a51 <strcmp+0x26>
  800a3b:	3a 02                	cmp    (%edx),%al
  800a3d:	75 12                	jne    800a51 <strcmp+0x26>
		p++, q++;
  800a3f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a42:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800a46:	84 c0                	test   %al,%al
  800a48:	74 07                	je     800a51 <strcmp+0x26>
  800a4a:	83 c1 01             	add    $0x1,%ecx
  800a4d:	3a 02                	cmp    (%edx),%al
  800a4f:	74 ee                	je     800a3f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a51:	0f b6 c0             	movzbl %al,%eax
  800a54:	0f b6 12             	movzbl (%edx),%edx
  800a57:	29 d0                	sub    %edx,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	53                   	push   %ebx
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a65:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a6d:	85 d2                	test   %edx,%edx
  800a6f:	74 28                	je     800a99 <strncmp+0x3e>
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	84 c0                	test   %al,%al
  800a76:	74 24                	je     800a9c <strncmp+0x41>
  800a78:	3a 03                	cmp    (%ebx),%al
  800a7a:	75 20                	jne    800a9c <strncmp+0x41>
  800a7c:	83 ea 01             	sub    $0x1,%edx
  800a7f:	74 13                	je     800a94 <strncmp+0x39>
		n--, p++, q++;
  800a81:	83 c1 01             	add    $0x1,%ecx
  800a84:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a87:	0f b6 01             	movzbl (%ecx),%eax
  800a8a:	84 c0                	test   %al,%al
  800a8c:	74 0e                	je     800a9c <strncmp+0x41>
  800a8e:	3a 03                	cmp    (%ebx),%al
  800a90:	74 ea                	je     800a7c <strncmp+0x21>
  800a92:	eb 08                	jmp    800a9c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a99:	5b                   	pop    %ebx
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9c:	0f b6 01             	movzbl (%ecx),%eax
  800a9f:	0f b6 13             	movzbl (%ebx),%edx
  800aa2:	29 d0                	sub    %edx,%eax
  800aa4:	eb f3                	jmp    800a99 <strncmp+0x3e>

00800aa6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab0:	0f b6 10             	movzbl (%eax),%edx
  800ab3:	84 d2                	test   %dl,%dl
  800ab5:	74 1c                	je     800ad3 <strchr+0x2d>
		if (*s == c)
  800ab7:	38 ca                	cmp    %cl,%dl
  800ab9:	75 09                	jne    800ac4 <strchr+0x1e>
  800abb:	eb 1b                	jmp    800ad8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800abd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800ac0:	38 ca                	cmp    %cl,%dl
  800ac2:	74 14                	je     800ad8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ac4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	75 f1                	jne    800abd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	eb 05                	jmp    800ad8 <strchr+0x32>
  800ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae4:	0f b6 10             	movzbl (%eax),%edx
  800ae7:	84 d2                	test   %dl,%dl
  800ae9:	74 14                	je     800aff <strfind+0x25>
		if (*s == c)
  800aeb:	38 ca                	cmp    %cl,%dl
  800aed:	75 06                	jne    800af5 <strfind+0x1b>
  800aef:	eb 0e                	jmp    800aff <strfind+0x25>
  800af1:	38 ca                	cmp    %cl,%dl
  800af3:	74 0a                	je     800aff <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	0f b6 10             	movzbl (%eax),%edx
  800afb:	84 d2                	test   %dl,%dl
  800afd:	75 f2                	jne    800af1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 0c             	sub    $0xc,%esp
  800b07:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b0a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b0d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b10:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b19:	85 c9                	test   %ecx,%ecx
  800b1b:	74 30                	je     800b4d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b1d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b23:	75 25                	jne    800b4a <memset+0x49>
  800b25:	f6 c1 03             	test   $0x3,%cl
  800b28:	75 20                	jne    800b4a <memset+0x49>
		c &= 0xFF;
  800b2a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b2d:	89 d3                	mov    %edx,%ebx
  800b2f:	c1 e3 08             	shl    $0x8,%ebx
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	c1 e6 18             	shl    $0x18,%esi
  800b37:	89 d0                	mov    %edx,%eax
  800b39:	c1 e0 10             	shl    $0x10,%eax
  800b3c:	09 f0                	or     %esi,%eax
  800b3e:	09 d0                	or     %edx,%eax
  800b40:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b42:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b45:	fc                   	cld    
  800b46:	f3 ab                	rep stos %eax,%es:(%edi)
  800b48:	eb 03                	jmp    800b4d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b4a:	fc                   	cld    
  800b4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4d:	89 f8                	mov    %edi,%eax
  800b4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b58:	89 ec                	mov    %ebp,%esp
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b65:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b71:	39 c6                	cmp    %eax,%esi
  800b73:	73 36                	jae    800bab <memmove+0x4f>
  800b75:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b78:	39 d0                	cmp    %edx,%eax
  800b7a:	73 2f                	jae    800bab <memmove+0x4f>
		s += n;
		d += n;
  800b7c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7f:	f6 c2 03             	test   $0x3,%dl
  800b82:	75 1b                	jne    800b9f <memmove+0x43>
  800b84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8a:	75 13                	jne    800b9f <memmove+0x43>
  800b8c:	f6 c1 03             	test   $0x3,%cl
  800b8f:	75 0e                	jne    800b9f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b91:	83 ef 04             	sub    $0x4,%edi
  800b94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b9a:	fd                   	std    
  800b9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9d:	eb 09                	jmp    800ba8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b9f:	83 ef 01             	sub    $0x1,%edi
  800ba2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ba5:	fd                   	std    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ba8:	fc                   	cld    
  800ba9:	eb 20                	jmp    800bcb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bb1:	75 13                	jne    800bc6 <memmove+0x6a>
  800bb3:	a8 03                	test   $0x3,%al
  800bb5:	75 0f                	jne    800bc6 <memmove+0x6a>
  800bb7:	f6 c1 03             	test   $0x3,%cl
  800bba:	75 0a                	jne    800bc6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bbc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bbf:	89 c7                	mov    %eax,%edi
  800bc1:	fc                   	cld    
  800bc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc4:	eb 05                	jmp    800bcb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bc6:	89 c7                	mov    %eax,%edi
  800bc8:	fc                   	cld    
  800bc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bcb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bd1:	89 ec                	mov    %ebp,%esp
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bde:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 04 24             	mov    %eax,(%esp)
  800bef:	e8 68 ff ff ff       	call   800b5c <memmove>
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
  800bfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c02:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c0a:	85 ff                	test   %edi,%edi
  800c0c:	74 37                	je     800c45 <memcmp+0x4f>
		if (*s1 != *s2)
  800c0e:	0f b6 03             	movzbl (%ebx),%eax
  800c11:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c14:	83 ef 01             	sub    $0x1,%edi
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c1c:	38 c8                	cmp    %cl,%al
  800c1e:	74 1c                	je     800c3c <memcmp+0x46>
  800c20:	eb 10                	jmp    800c32 <memcmp+0x3c>
  800c22:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c27:	83 c2 01             	add    $0x1,%edx
  800c2a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c2e:	38 c8                	cmp    %cl,%al
  800c30:	74 0a                	je     800c3c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800c32:	0f b6 c0             	movzbl %al,%eax
  800c35:	0f b6 c9             	movzbl %cl,%ecx
  800c38:	29 c8                	sub    %ecx,%eax
  800c3a:	eb 09                	jmp    800c45 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3c:	39 fa                	cmp    %edi,%edx
  800c3e:	75 e2                	jne    800c22 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c50:	89 c2                	mov    %eax,%edx
  800c52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c55:	39 d0                	cmp    %edx,%eax
  800c57:	73 19                	jae    800c72 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c5d:	38 08                	cmp    %cl,(%eax)
  800c5f:	75 06                	jne    800c67 <memfind+0x1d>
  800c61:	eb 0f                	jmp    800c72 <memfind+0x28>
  800c63:	38 08                	cmp    %cl,(%eax)
  800c65:	74 0b                	je     800c72 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c67:	83 c0 01             	add    $0x1,%eax
  800c6a:	39 d0                	cmp    %edx,%eax
  800c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c70:	75 f1                	jne    800c63 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c80:	0f b6 02             	movzbl (%edx),%eax
  800c83:	3c 20                	cmp    $0x20,%al
  800c85:	74 04                	je     800c8b <strtol+0x17>
  800c87:	3c 09                	cmp    $0x9,%al
  800c89:	75 0e                	jne    800c99 <strtol+0x25>
		s++;
  800c8b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8e:	0f b6 02             	movzbl (%edx),%eax
  800c91:	3c 20                	cmp    $0x20,%al
  800c93:	74 f6                	je     800c8b <strtol+0x17>
  800c95:	3c 09                	cmp    $0x9,%al
  800c97:	74 f2                	je     800c8b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c99:	3c 2b                	cmp    $0x2b,%al
  800c9b:	75 0a                	jne    800ca7 <strtol+0x33>
		s++;
  800c9d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ca0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca5:	eb 10                	jmp    800cb7 <strtol+0x43>
  800ca7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cac:	3c 2d                	cmp    $0x2d,%al
  800cae:	75 07                	jne    800cb7 <strtol+0x43>
		s++, neg = 1;
  800cb0:	83 c2 01             	add    $0x1,%edx
  800cb3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb7:	85 db                	test   %ebx,%ebx
  800cb9:	0f 94 c0             	sete   %al
  800cbc:	74 05                	je     800cc3 <strtol+0x4f>
  800cbe:	83 fb 10             	cmp    $0x10,%ebx
  800cc1:	75 15                	jne    800cd8 <strtol+0x64>
  800cc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc6:	75 10                	jne    800cd8 <strtol+0x64>
  800cc8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ccc:	75 0a                	jne    800cd8 <strtol+0x64>
		s += 2, base = 16;
  800cce:	83 c2 02             	add    $0x2,%edx
  800cd1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cd6:	eb 13                	jmp    800ceb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800cd8:	84 c0                	test   %al,%al
  800cda:	74 0f                	je     800ceb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cdc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce1:	80 3a 30             	cmpb   $0x30,(%edx)
  800ce4:	75 05                	jne    800ceb <strtol+0x77>
		s++, base = 8;
  800ce6:	83 c2 01             	add    $0x1,%edx
  800ce9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf2:	0f b6 0a             	movzbl (%edx),%ecx
  800cf5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cf8:	80 fb 09             	cmp    $0x9,%bl
  800cfb:	77 08                	ja     800d05 <strtol+0x91>
			dig = *s - '0';
  800cfd:	0f be c9             	movsbl %cl,%ecx
  800d00:	83 e9 30             	sub    $0x30,%ecx
  800d03:	eb 1e                	jmp    800d23 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800d05:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800d08:	80 fb 19             	cmp    $0x19,%bl
  800d0b:	77 08                	ja     800d15 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800d0d:	0f be c9             	movsbl %cl,%ecx
  800d10:	83 e9 57             	sub    $0x57,%ecx
  800d13:	eb 0e                	jmp    800d23 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d15:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d18:	80 fb 19             	cmp    $0x19,%bl
  800d1b:	77 14                	ja     800d31 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d1d:	0f be c9             	movsbl %cl,%ecx
  800d20:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d23:	39 f1                	cmp    %esi,%ecx
  800d25:	7d 0e                	jge    800d35 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d27:	83 c2 01             	add    $0x1,%edx
  800d2a:	0f af c6             	imul   %esi,%eax
  800d2d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800d2f:	eb c1                	jmp    800cf2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d31:	89 c1                	mov    %eax,%ecx
  800d33:	eb 02                	jmp    800d37 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d35:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d3b:	74 05                	je     800d42 <strtol+0xce>
		*endptr = (char *) s;
  800d3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d40:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d42:	89 ca                	mov    %ecx,%edx
  800d44:	f7 da                	neg    %edx
  800d46:	85 ff                	test   %edi,%edi
  800d48:	0f 45 c2             	cmovne %edx,%eax
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	89 c3                	mov    %eax,%ebx
  800d6c:	89 c7                	mov    %eax,%edi
  800d6e:	89 c6                	mov    %eax,%esi
  800d70:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d7b:	89 ec                	mov    %ebp,%esp
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d93:	b8 01 00 00 00       	mov    $0x1,%eax
  800d98:	89 d1                	mov    %edx,%ecx
  800d9a:	89 d3                	mov    %edx,%ebx
  800d9c:	89 d7                	mov    %edx,%edi
  800d9e:	89 d6                	mov    %edx,%esi
  800da0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dab:	89 ec                	mov    %ebp,%esp
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 38             	sub    $0x38,%esp
  800db5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	89 cb                	mov    %ecx,%ebx
  800dcd:	89 cf                	mov    %ecx,%edi
  800dcf:	89 ce                	mov    %ecx,%esi
  800dd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7e 28                	jle    800dff <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800de2:	00 
  800de3:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800dea:	00 
  800deb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df2:	00 
  800df3:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800dfa:	e8 59 f4 ff ff       	call   800258 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e08:	89 ec                	mov    %ebp,%esp
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e15:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e18:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e20:	b8 02 00 00 00       	mov    $0x2,%eax
  800e25:	89 d1                	mov    %edx,%ecx
  800e27:	89 d3                	mov    %edx,%ebx
  800e29:	89 d7                	mov    %edx,%edi
  800e2b:	89 d6                	mov    %edx,%esi
  800e2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e38:	89 ec                	mov    %ebp,%esp
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_yield>:

void
sys_yield(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	89 d3                	mov    %edx,%ebx
  800e59:	89 d7                	mov    %edx,%edi
  800e5b:	89 d6                	mov    %edx,%esi
  800e5d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e68:	89 ec                	mov    %ebp,%esp
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 38             	sub    $0x38,%esp
  800e72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7b:	be 00 00 00 00       	mov    $0x0,%esi
  800e80:	b8 04 00 00 00       	mov    $0x4,%eax
  800e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	89 f7                	mov    %esi,%edi
  800e90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7e 28                	jle    800ebe <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ea1:	00 
  800ea2:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800ea9:	00 
  800eaa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb1:	00 
  800eb2:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800eb9:	e8 9a f3 ff ff       	call   800258 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec7:	89 ec                	mov    %ebp,%esp
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 38             	sub    $0x38,%esp
  800ed1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eda:	b8 05 00 00 00       	mov    $0x5,%eax
  800edf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7e 28                	jle    800f1c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800eff:	00 
  800f00:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f07:	00 
  800f08:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0f:	00 
  800f10:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f17:	e8 3c f3 ff ff       	call   800258 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f1c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f22:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f25:	89 ec                	mov    %ebp,%esp
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 38             	sub    $0x38,%esp
  800f2f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f32:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f35:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	89 df                	mov    %ebx,%edi
  800f4a:	89 de                	mov    %ebx,%esi
  800f4c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	7e 28                	jle    800f7a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f52:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f56:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f5d:	00 
  800f5e:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f65:	00 
  800f66:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f6d:	00 
  800f6e:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f75:	e8 de f2 ff ff       	call   800258 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f7d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f80:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f83:	89 ec                	mov    %ebp,%esp
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 38             	sub    $0x38,%esp
  800f8d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f90:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f93:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7e 28                	jle    800fd8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcb:	00 
  800fcc:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800fd3:	e8 80 f2 ff ff       	call   800258 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fd8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fdb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fde:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe1:	89 ec                	mov    %ebp,%esp
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800ff4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff9:	b8 09 00 00 00       	mov    $0x9,%eax
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	89 df                	mov    %ebx,%edi
  801006:	89 de                	mov    %ebx,%esi
  801008:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80100a:	85 c0                	test   %eax,%eax
  80100c:	7e 28                	jle    801036 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801012:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801019:	00 
  80101a:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  801021:	00 
  801022:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801029:	00 
  80102a:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  801031:	e8 22 f2 ff ff       	call   800258 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801036:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801039:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80103c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80103f:	89 ec                	mov    %ebp,%esp
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 38             	sub    $0x38,%esp
  801049:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80104c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80104f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
  801057:	b8 0a 00 00 00       	mov    $0xa,%eax
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	89 df                	mov    %ebx,%edi
  801064:	89 de                	mov    %ebx,%esi
  801066:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801068:	85 c0                	test   %eax,%eax
  80106a:	7e 28                	jle    801094 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801070:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801077:	00 
  801078:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  80107f:	00 
  801080:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801087:	00 
  801088:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80108f:	e8 c4 f1 ff ff       	call   800258 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801094:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801097:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80109a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80109d:	89 ec                	mov    %ebp,%esp
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 0c             	sub    $0xc,%esp
  8010a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b0:	be 00 00 00 00       	mov    $0x0,%esi
  8010b5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010ba:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d1:	89 ec                	mov    %ebp,%esp
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 38             	sub    $0x38,%esp
  8010db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	89 cb                	mov    %ecx,%ebx
  8010f3:	89 cf                	mov    %ecx,%edi
  8010f5:	89 ce                	mov    %ecx,%esi
  8010f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7e 28                	jle    801125 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801101:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801108:	00 
  801109:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  801110:	00 
  801111:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801118:	00 
  801119:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  801120:	e8 33 f1 ff ff       	call   800258 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801125:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801128:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80112b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80112e:	89 ec                	mov    %ebp,%esp
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    
	...

00801134 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	53                   	push   %ebx
  801138:	83 ec 24             	sub    $0x24,%esp
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80113e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801140:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801144:	74 21                	je     801167 <pgfault+0x33>
  801146:	89 d8                	mov    %ebx,%eax
  801148:	c1 e8 16             	shr    $0x16,%eax
  80114b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801152:	a8 01                	test   $0x1,%al
  801154:	74 11                	je     801167 <pgfault+0x33>
  801156:	89 d8                	mov    %ebx,%eax
  801158:	c1 e8 0c             	shr    $0xc,%eax
  80115b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801162:	f6 c4 08             	test   $0x8,%ah
  801165:	75 1c                	jne    801183 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801167:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  80116e:	00 
  80116f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801176:	00 
  801177:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  80117e:	e8 d5 f0 ff ff       	call   800258 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801183:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80118a:	00 
  80118b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801192:	00 
  801193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80119a:	e8 cd fc ff ff       	call   800e6c <sys_page_alloc>
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	79 20                	jns    8011c3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8011a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011a7:	c7 44 24 08 e8 2b 80 	movl   $0x802be8,0x8(%esp)
  8011ae:	00 
  8011af:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8011b6:	00 
  8011b7:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  8011be:	e8 95 f0 ff ff       	call   800258 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  8011c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  8011c9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011d0:	00 
  8011d1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011d5:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011dc:	e8 7b f9 ff ff       	call   800b5c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8011e1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011e8:	00 
  8011e9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011f4:	00 
  8011f5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011fc:	00 
  8011fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801204:	e8 c2 fc ff ff       	call   800ecb <sys_page_map>
  801209:	85 c0                	test   %eax,%eax
  80120b:	79 20                	jns    80122d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80120d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801211:	c7 44 24 08 10 2c 80 	movl   $0x802c10,0x8(%esp)
  801218:	00 
  801219:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801220:	00 
  801221:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  801228:	e8 2b f0 ff ff       	call   800258 <_panic>
	//panic("pgfault not implemented");
}
  80122d:	83 c4 24             	add    $0x24,%esp
  801230:	5b                   	pop    %ebx
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80123c:	c7 04 24 34 11 80 00 	movl   $0x801134,(%esp)
  801243:	e8 88 10 00 00       	call   8022d0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801248:	ba 07 00 00 00       	mov    $0x7,%edx
  80124d:	89 d0                	mov    %edx,%eax
  80124f:	cd 30                	int    $0x30
  801251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801254:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801256:	85 c0                	test   %eax,%eax
  801258:	79 20                	jns    80127a <fork+0x47>
		panic("sys_exofork: %e", envid);
  80125a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80125e:	c7 44 24 08 0e 2d 80 	movl   $0x802d0e,0x8(%esp)
  801265:	00 
  801266:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80126d:	00 
  80126e:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  801275:	e8 de ef ff ff       	call   800258 <_panic>
	if (envid == 0) {
  80127a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80127f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801283:	75 1c                	jne    8012a1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801285:	e8 82 fb ff ff       	call   800e0c <sys_getenvid>
  80128a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80128f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801292:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801297:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80129c:	e9 06 02 00 00       	jmp    8014a7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8012a1:	89 d8                	mov    %ebx,%eax
  8012a3:	c1 e8 16             	shr    $0x16,%eax
  8012a6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ad:	a8 01                	test   $0x1,%al
  8012af:	0f 84 57 01 00 00    	je     80140c <fork+0x1d9>
  8012b5:	89 de                	mov    %ebx,%esi
  8012b7:	c1 ee 0c             	shr    $0xc,%esi
  8012ba:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012c1:	a8 01                	test   $0x1,%al
  8012c3:	0f 84 43 01 00 00    	je     80140c <fork+0x1d9>
  8012c9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012d0:	a8 04                	test   $0x4,%al
  8012d2:	0f 84 34 01 00 00    	je     80140c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  8012d8:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  8012db:	89 f0                	mov    %esi,%eax
  8012dd:	c1 e8 0c             	shr    $0xc,%eax
  8012e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  8012e7:	f6 c4 04             	test   $0x4,%ah
  8012ea:	74 45                	je     801331 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  8012ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801301:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801308:	e8 be fb ff ff       	call   800ecb <sys_page_map>
  80130d:	85 c0                	test   %eax,%eax
  80130f:	0f 89 f7 00 00 00    	jns    80140c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801315:	c7 44 24 08 1e 2d 80 	movl   $0x802d1e,0x8(%esp)
  80131c:	00 
  80131d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801324:	00 
  801325:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  80132c:	e8 27 ef ff ff       	call   800258 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801331:	a9 02 08 00 00       	test   $0x802,%eax
  801336:	0f 84 8c 00 00 00    	je     8013c8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80133c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801343:	00 
  801344:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801348:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80134c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801350:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801357:	e8 6f fb ff ff       	call   800ecb <sys_page_map>
  80135c:	85 c0                	test   %eax,%eax
  80135e:	79 20                	jns    801380 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801360:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801364:	c7 44 24 08 34 2c 80 	movl   $0x802c34,0x8(%esp)
  80136b:	00 
  80136c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801373:	00 
  801374:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  80137b:	e8 d8 ee ff ff       	call   800258 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801380:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801387:	00 
  801388:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80138c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801393:	00 
  801394:	89 74 24 04          	mov    %esi,0x4(%esp)
  801398:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139f:	e8 27 fb ff ff       	call   800ecb <sys_page_map>
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	79 64                	jns    80140c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8013a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ac:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8013bb:	00 
  8013bc:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  8013c3:	e8 90 ee ff ff       	call   800258 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8013c8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8013cf:	00 
  8013d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013d4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e3:	e8 e3 fa ff ff       	call   800ecb <sys_page_map>
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	79 20                	jns    80140c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  8013ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013f0:	c7 44 24 08 8c 2c 80 	movl   $0x802c8c,0x8(%esp)
  8013f7:	00 
  8013f8:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8013ff:	00 
  801400:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  801407:	e8 4c ee ff ff       	call   800258 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80140c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801412:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801418:	0f 85 83 fe ff ff    	jne    8012a1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80141e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801425:	00 
  801426:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80142d:	ee 
  80142e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801431:	89 04 24             	mov    %eax,(%esp)
  801434:	e8 33 fa ff ff       	call   800e6c <sys_page_alloc>
  801439:	85 c0                	test   %eax,%eax
  80143b:	79 20                	jns    80145d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80143d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801441:	c7 44 24 08 b8 2c 80 	movl   $0x802cb8,0x8(%esp)
  801448:	00 
  801449:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  801458:	e8 fb ed ff ff       	call   800258 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80145d:	c7 44 24 04 40 23 80 	movl   $0x802340,0x4(%esp)
  801464:	00 
  801465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801468:	89 04 24             	mov    %eax,(%esp)
  80146b:	e8 d3 fb ff ff       	call   801043 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801470:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801477:	00 
  801478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147b:	89 04 24             	mov    %eax,(%esp)
  80147e:	e8 04 fb ff ff       	call   800f87 <sys_env_set_status>
  801483:	85 c0                	test   %eax,%eax
  801485:	79 20                	jns    8014a7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801487:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80148b:	c7 44 24 08 dc 2c 80 	movl   $0x802cdc,0x8(%esp)
  801492:	00 
  801493:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80149a:	00 
  80149b:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  8014a2:	e8 b1 ed ff ff       	call   800258 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8014a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014aa:	83 c4 3c             	add    $0x3c,%esp
  8014ad:	5b                   	pop    %ebx
  8014ae:	5e                   	pop    %esi
  8014af:	5f                   	pop    %edi
  8014b0:	5d                   	pop    %ebp
  8014b1:	c3                   	ret    

008014b2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014b8:	c7 44 24 08 35 2d 80 	movl   $0x802d35,0x8(%esp)
  8014bf:	00 
  8014c0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8014c7:	00 
  8014c8:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  8014cf:	e8 84 ed ff ff       	call   800258 <_panic>
	...

008014e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 04 24             	mov    %eax,(%esp)
  8014fc:	e8 df ff ff ff       	call   8014e0 <fd2num>
  801501:	05 20 00 0d 00       	add    $0xd0020,%eax
  801506:	c1 e0 0c             	shl    $0xc,%eax
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	53                   	push   %ebx
  80150f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801512:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801517:	a8 01                	test   $0x1,%al
  801519:	74 34                	je     80154f <fd_alloc+0x44>
  80151b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801520:	a8 01                	test   $0x1,%al
  801522:	74 32                	je     801556 <fd_alloc+0x4b>
  801524:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801529:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80152b:	89 c2                	mov    %eax,%edx
  80152d:	c1 ea 16             	shr    $0x16,%edx
  801530:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801537:	f6 c2 01             	test   $0x1,%dl
  80153a:	74 1f                	je     80155b <fd_alloc+0x50>
  80153c:	89 c2                	mov    %eax,%edx
  80153e:	c1 ea 0c             	shr    $0xc,%edx
  801541:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	75 17                	jne    801564 <fd_alloc+0x59>
  80154d:	eb 0c                	jmp    80155b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80154f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801554:	eb 05                	jmp    80155b <fd_alloc+0x50>
  801556:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80155b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 17                	jmp    80157b <fd_alloc+0x70>
  801564:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801569:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80156e:	75 b9                	jne    801529 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801570:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801576:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80157b:	5b                   	pop    %ebx
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801584:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801589:	83 fa 1f             	cmp    $0x1f,%edx
  80158c:	77 3f                	ja     8015cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80158e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801594:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801597:	89 d0                	mov    %edx,%eax
  801599:	c1 e8 16             	shr    $0x16,%eax
  80159c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015a8:	f6 c1 01             	test   $0x1,%cl
  8015ab:	74 20                	je     8015cd <fd_lookup+0x4f>
  8015ad:	89 d0                	mov    %edx,%eax
  8015af:	c1 e8 0c             	shr    $0xc,%eax
  8015b2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015be:	f6 c1 01             	test   $0x1,%cl
  8015c1:	74 0a                	je     8015cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c6:	89 10                	mov    %edx,(%eax)
	return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	53                   	push   %ebx
  8015d3:	83 ec 14             	sub    $0x14,%esp
  8015d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015e1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8015e7:	75 17                	jne    801600 <dev_lookup+0x31>
  8015e9:	eb 07                	jmp    8015f2 <dev_lookup+0x23>
  8015eb:	39 0a                	cmp    %ecx,(%edx)
  8015ed:	75 11                	jne    801600 <dev_lookup+0x31>
  8015ef:	90                   	nop
  8015f0:	eb 05                	jmp    8015f7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015f2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8015f7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	eb 35                	jmp    801635 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801600:	83 c0 01             	add    $0x1,%eax
  801603:	8b 14 85 cc 2d 80 00 	mov    0x802dcc(,%eax,4),%edx
  80160a:	85 d2                	test   %edx,%edx
  80160c:	75 dd                	jne    8015eb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80160e:	a1 04 40 80 00       	mov    0x804004,%eax
  801613:	8b 40 48             	mov    0x48(%eax),%eax
  801616:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80161a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161e:	c7 04 24 4c 2d 80 00 	movl   $0x802d4c,(%esp)
  801625:	e8 29 ed ff ff       	call   800353 <cprintf>
	*dev = 0;
  80162a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801630:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801635:	83 c4 14             	add    $0x14,%esp
  801638:	5b                   	pop    %ebx
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    

0080163b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 38             	sub    $0x38,%esp
  801641:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801644:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801647:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80164a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80164d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801651:	89 3c 24             	mov    %edi,(%esp)
  801654:	e8 87 fe ff ff       	call   8014e0 <fd2num>
  801659:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80165c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801660:	89 04 24             	mov    %eax,(%esp)
  801663:	e8 16 ff ff ff       	call   80157e <fd_lookup>
  801668:	89 c3                	mov    %eax,%ebx
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 05                	js     801673 <fd_close+0x38>
	    || fd != fd2)
  80166e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801671:	74 0e                	je     801681 <fd_close+0x46>
		return (must_exist ? r : 0);
  801673:	89 f0                	mov    %esi,%eax
  801675:	84 c0                	test   %al,%al
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
  80167c:	0f 44 d8             	cmove  %eax,%ebx
  80167f:	eb 3d                	jmp    8016be <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801681:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	8b 07                	mov    (%edi),%eax
  80168a:	89 04 24             	mov    %eax,(%esp)
  80168d:	e8 3d ff ff ff       	call   8015cf <dev_lookup>
  801692:	89 c3                	mov    %eax,%ebx
  801694:	85 c0                	test   %eax,%eax
  801696:	78 16                	js     8016ae <fd_close+0x73>
		if (dev->dev_close)
  801698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80169e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 07                	je     8016ae <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8016a7:	89 3c 24             	mov    %edi,(%esp)
  8016aa:	ff d0                	call   *%eax
  8016ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b9:	e8 6b f8 ff ff       	call   800f29 <sys_page_unmap>
	return r;
}
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016c9:	89 ec                	mov    %ebp,%esp
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    

008016cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	89 04 24             	mov    %eax,(%esp)
  8016e0:	e8 99 fe ff ff       	call   80157e <fd_lookup>
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 13                	js     8016fc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016f0:	00 
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 3f ff ff ff       	call   80163b <fd_close>
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <close_all>:

void
close_all(void)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	53                   	push   %ebx
  801702:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801705:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80170a:	89 1c 24             	mov    %ebx,(%esp)
  80170d:	e8 bb ff ff ff       	call   8016cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801712:	83 c3 01             	add    $0x1,%ebx
  801715:	83 fb 20             	cmp    $0x20,%ebx
  801718:	75 f0                	jne    80170a <close_all+0xc>
		close(i);
}
  80171a:	83 c4 14             	add    $0x14,%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 58             	sub    $0x58,%esp
  801726:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801729:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80172c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80172f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801732:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801735:	89 44 24 04          	mov    %eax,0x4(%esp)
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	89 04 24             	mov    %eax,(%esp)
  80173f:	e8 3a fe ff ff       	call   80157e <fd_lookup>
  801744:	89 c3                	mov    %eax,%ebx
  801746:	85 c0                	test   %eax,%eax
  801748:	0f 88 e1 00 00 00    	js     80182f <dup+0x10f>
		return r;
	close(newfdnum);
  80174e:	89 3c 24             	mov    %edi,(%esp)
  801751:	e8 77 ff ff ff       	call   8016cd <close>

	newfd = INDEX2FD(newfdnum);
  801756:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80175c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80175f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	e8 86 fd ff ff       	call   8014f0 <fd2data>
  80176a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80176c:	89 34 24             	mov    %esi,(%esp)
  80176f:	e8 7c fd ff ff       	call   8014f0 <fd2data>
  801774:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801777:	89 d8                	mov    %ebx,%eax
  801779:	c1 e8 16             	shr    $0x16,%eax
  80177c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801783:	a8 01                	test   $0x1,%al
  801785:	74 46                	je     8017cd <dup+0xad>
  801787:	89 d8                	mov    %ebx,%eax
  801789:	c1 e8 0c             	shr    $0xc,%eax
  80178c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801793:	f6 c2 01             	test   $0x1,%dl
  801796:	74 35                	je     8017cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801798:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80179f:	25 07 0e 00 00       	and    $0xe07,%eax
  8017a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b6:	00 
  8017b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 04 f7 ff ff       	call   800ecb <sys_page_map>
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 3b                	js     801808 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d0:	89 c2                	mov    %eax,%edx
  8017d2:	c1 ea 0c             	shr    $0xc,%edx
  8017d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017dc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017f1:	00 
  8017f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fd:	e8 c9 f6 ff ff       	call   800ecb <sys_page_map>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	85 c0                	test   %eax,%eax
  801806:	79 25                	jns    80182d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801808:	89 74 24 04          	mov    %esi,0x4(%esp)
  80180c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801813:	e8 11 f7 ff ff       	call   800f29 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80181b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801826:	e8 fe f6 ff ff       	call   800f29 <sys_page_unmap>
	return r;
  80182b:	eb 02                	jmp    80182f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80182d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80182f:	89 d8                	mov    %ebx,%eax
  801831:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801834:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801837:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80183a:	89 ec                	mov    %ebp,%esp
  80183c:	5d                   	pop    %ebp
  80183d:	c3                   	ret    

0080183e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	53                   	push   %ebx
  801842:	83 ec 24             	sub    $0x24,%esp
  801845:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801848:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	89 1c 24             	mov    %ebx,(%esp)
  801852:	e8 27 fd ff ff       	call   80157e <fd_lookup>
  801857:	85 c0                	test   %eax,%eax
  801859:	78 6d                	js     8018c8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	8b 00                	mov    (%eax),%eax
  801867:	89 04 24             	mov    %eax,(%esp)
  80186a:	e8 60 fd ff ff       	call   8015cf <dev_lookup>
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 55                	js     8018c8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801876:	8b 50 08             	mov    0x8(%eax),%edx
  801879:	83 e2 03             	and    $0x3,%edx
  80187c:	83 fa 01             	cmp    $0x1,%edx
  80187f:	75 23                	jne    8018a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801881:	a1 04 40 80 00       	mov    0x804004,%eax
  801886:	8b 40 48             	mov    0x48(%eax),%eax
  801889:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80188d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801891:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  801898:	e8 b6 ea ff ff       	call   800353 <cprintf>
		return -E_INVAL;
  80189d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a2:	eb 24                	jmp    8018c8 <read+0x8a>
	}
	if (!dev->dev_read)
  8018a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a7:	8b 52 08             	mov    0x8(%edx),%edx
  8018aa:	85 d2                	test   %edx,%edx
  8018ac:	74 15                	je     8018c3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018bc:	89 04 24             	mov    %eax,(%esp)
  8018bf:	ff d2                	call   *%edx
  8018c1:	eb 05                	jmp    8018c8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018c8:	83 c4 24             	add    $0x24,%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	57                   	push   %edi
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 1c             	sub    $0x1c,%esp
  8018d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	85 f6                	test   %esi,%esi
  8018e4:	74 30                	je     801916 <readn+0x48>
  8018e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018eb:	89 f2                	mov    %esi,%edx
  8018ed:	29 c2                	sub    %eax,%edx
  8018ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018f3:	03 45 0c             	add    0xc(%ebp),%eax
  8018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fa:	89 3c 24             	mov    %edi,(%esp)
  8018fd:	e8 3c ff ff ff       	call   80183e <read>
		if (m < 0)
  801902:	85 c0                	test   %eax,%eax
  801904:	78 10                	js     801916 <readn+0x48>
			return m;
		if (m == 0)
  801906:	85 c0                	test   %eax,%eax
  801908:	74 0a                	je     801914 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190a:	01 c3                	add    %eax,%ebx
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	39 f3                	cmp    %esi,%ebx
  801910:	72 d9                	jb     8018eb <readn+0x1d>
  801912:	eb 02                	jmp    801916 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801914:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801916:	83 c4 1c             	add    $0x1c,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5f                   	pop    %edi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	53                   	push   %ebx
  801922:	83 ec 24             	sub    $0x24,%esp
  801925:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801928:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80192b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192f:	89 1c 24             	mov    %ebx,(%esp)
  801932:	e8 47 fc ff ff       	call   80157e <fd_lookup>
  801937:	85 c0                	test   %eax,%eax
  801939:	78 68                	js     8019a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 80 fc ff ff       	call   8015cf <dev_lookup>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 50                	js     8019a3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80195a:	75 23                	jne    80197f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80195c:	a1 04 40 80 00       	mov    0x804004,%eax
  801961:	8b 40 48             	mov    0x48(%eax),%eax
  801964:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
  801973:	e8 db e9 ff ff       	call   800353 <cprintf>
		return -E_INVAL;
  801978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80197d:	eb 24                	jmp    8019a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80197f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801982:	8b 52 0c             	mov    0xc(%edx),%edx
  801985:	85 d2                	test   %edx,%edx
  801987:	74 15                	je     80199e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801989:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801990:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801993:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801997:	89 04 24             	mov    %eax,(%esp)
  80199a:	ff d2                	call   *%edx
  80199c:	eb 05                	jmp    8019a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80199e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019a3:	83 c4 24             	add    $0x24,%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5d                   	pop    %ebp
  8019a8:	c3                   	ret    

008019a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	89 04 24             	mov    %eax,(%esp)
  8019bc:	e8 bd fb ff ff       	call   80157e <fd_lookup>
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 0e                	js     8019d3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	53                   	push   %ebx
  8019d9:	83 ec 24             	sub    $0x24,%esp
  8019dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	89 1c 24             	mov    %ebx,(%esp)
  8019e9:	e8 90 fb ff ff       	call   80157e <fd_lookup>
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 61                	js     801a53 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	8b 00                	mov    (%eax),%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 c9 fb ff ff       	call   8015cf <dev_lookup>
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 49                	js     801a53 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a11:	75 23                	jne    801a36 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a13:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a18:	8b 40 48             	mov    0x48(%eax),%eax
  801a1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a23:	c7 04 24 6c 2d 80 00 	movl   $0x802d6c,(%esp)
  801a2a:	e8 24 e9 ff ff       	call   800353 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a34:	eb 1d                	jmp    801a53 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a39:	8b 52 18             	mov    0x18(%edx),%edx
  801a3c:	85 d2                	test   %edx,%edx
  801a3e:	74 0e                	je     801a4e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a47:	89 04 24             	mov    %eax,(%esp)
  801a4a:	ff d2                	call   *%edx
  801a4c:	eb 05                	jmp    801a53 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a53:	83 c4 24             	add    $0x24,%esp
  801a56:	5b                   	pop    %ebx
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 24             	sub    $0x24,%esp
  801a60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a63:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	89 04 24             	mov    %eax,(%esp)
  801a70:	e8 09 fb ff ff       	call   80157e <fd_lookup>
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 52                	js     801acb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	89 04 24             	mov    %eax,(%esp)
  801a88:	e8 42 fb ff ff       	call   8015cf <dev_lookup>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	78 3a                	js     801acb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a94:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a98:	74 2c                	je     801ac6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a9a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a9d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aa4:	00 00 00 
	stat->st_isdir = 0;
  801aa7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aae:	00 00 00 
	stat->st_dev = dev;
  801ab1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ab7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abe:	89 14 24             	mov    %edx,(%esp)
  801ac1:	ff 50 14             	call   *0x14(%eax)
  801ac4:	eb 05                	jmp    801acb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ac6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801acb:	83 c4 24             	add    $0x24,%esp
  801ace:	5b                   	pop    %ebx
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    

00801ad1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 18             	sub    $0x18,%esp
  801ad7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ada:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801add:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ae4:	00 
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	89 04 24             	mov    %eax,(%esp)
  801aeb:	e8 bc 01 00 00       	call   801cac <open>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 1b                	js     801b11 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afd:	89 1c 24             	mov    %ebx,(%esp)
  801b00:	e8 54 ff ff ff       	call   801a59 <fstat>
  801b05:	89 c6                	mov    %eax,%esi
	close(fd);
  801b07:	89 1c 24             	mov    %ebx,(%esp)
  801b0a:	e8 be fb ff ff       	call   8016cd <close>
	return r;
  801b0f:	89 f3                	mov    %esi,%ebx
}
  801b11:	89 d8                	mov    %ebx,%eax
  801b13:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b16:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b19:	89 ec                	mov    %ebp,%esp
  801b1b:	5d                   	pop    %ebp
  801b1c:	c3                   	ret    
  801b1d:	00 00                	add    %al,(%eax)
	...

00801b20 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 18             	sub    $0x18,%esp
  801b26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b30:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b37:	75 11                	jne    801b4a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b40:	e8 01 09 00 00       	call   802446 <ipc_find_env>
  801b45:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b4a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b51:	00 
  801b52:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b59:	00 
  801b5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b5e:	a1 00 40 80 00       	mov    0x804000,%eax
  801b63:	89 04 24             	mov    %eax,(%esp)
  801b66:	e8 57 08 00 00       	call   8023c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b72:	00 
  801b73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7e:	e8 ed 07 00 00       	call   802370 <ipc_recv>
}
  801b83:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b86:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b89:	89 ec                	mov    %ebp,%esp
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    

00801b8d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	53                   	push   %ebx
  801b91:	83 ec 14             	sub    $0x14,%esp
  801b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba7:	b8 05 00 00 00       	mov    $0x5,%eax
  801bac:	e8 6f ff ff ff       	call   801b20 <fsipc>
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 2b                	js     801be0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bb5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801bbc:	00 
  801bbd:	89 1c 24             	mov    %ebx,(%esp)
  801bc0:	e8 a6 ed ff ff       	call   80096b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bc5:	a1 80 50 80 00       	mov    0x805080,%eax
  801bca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd0:	a1 84 50 80 00       	mov    0x805084,%eax
  801bd5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	83 c4 14             	add    $0x14,%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    

00801be6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfc:	b8 06 00 00 00       	mov    $0x6,%eax
  801c01:	e8 1a ff ff ff       	call   801b20 <fsipc>
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	56                   	push   %esi
  801c0c:	53                   	push   %ebx
  801c0d:	83 ec 10             	sub    $0x10,%esp
  801c10:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	8b 40 0c             	mov    0xc(%eax),%eax
  801c19:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c1e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2e:	e8 ed fe ff ff       	call   801b20 <fsipc>
  801c33:	89 c3                	mov    %eax,%ebx
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 6a                	js     801ca3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c39:	39 c6                	cmp    %eax,%esi
  801c3b:	73 24                	jae    801c61 <devfile_read+0x59>
  801c3d:	c7 44 24 0c dc 2d 80 	movl   $0x802ddc,0xc(%esp)
  801c44:	00 
  801c45:	c7 44 24 08 e3 2d 80 	movl   $0x802de3,0x8(%esp)
  801c4c:	00 
  801c4d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c54:	00 
  801c55:	c7 04 24 f8 2d 80 00 	movl   $0x802df8,(%esp)
  801c5c:	e8 f7 e5 ff ff       	call   800258 <_panic>
	assert(r <= PGSIZE);
  801c61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c66:	7e 24                	jle    801c8c <devfile_read+0x84>
  801c68:	c7 44 24 0c 03 2e 80 	movl   $0x802e03,0xc(%esp)
  801c6f:	00 
  801c70:	c7 44 24 08 e3 2d 80 	movl   $0x802de3,0x8(%esp)
  801c77:	00 
  801c78:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801c7f:	00 
  801c80:	c7 04 24 f8 2d 80 00 	movl   $0x802df8,(%esp)
  801c87:	e8 cc e5 ff ff       	call   800258 <_panic>
	memmove(buf, &fsipcbuf, r);
  801c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c90:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c97:	00 
  801c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9b:	89 04 24             	mov    %eax,(%esp)
  801c9e:	e8 b9 ee ff ff       	call   800b5c <memmove>
	return r;
}
  801ca3:	89 d8                	mov    %ebx,%eax
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    

00801cac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	56                   	push   %esi
  801cb0:	53                   	push   %ebx
  801cb1:	83 ec 20             	sub    $0x20,%esp
  801cb4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cb7:	89 34 24             	mov    %esi,(%esp)
  801cba:	e8 61 ec ff ff       	call   800920 <strlen>
		return -E_BAD_PATH;
  801cbf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cc4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc9:	7f 5e                	jg     801d29 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 35 f8 ff ff       	call   80150b <fd_alloc>
  801cd6:	89 c3                	mov    %eax,%ebx
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	78 4d                	js     801d29 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ce0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801ce7:	e8 7f ec ff ff       	call   80096b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cef:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfc:	e8 1f fe ff ff       	call   801b20 <fsipc>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	85 c0                	test   %eax,%eax
  801d05:	79 15                	jns    801d1c <open+0x70>
		fd_close(fd, 0);
  801d07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d0e:	00 
  801d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d12:	89 04 24             	mov    %eax,(%esp)
  801d15:	e8 21 f9 ff ff       	call   80163b <fd_close>
		return r;
  801d1a:	eb 0d                	jmp    801d29 <open+0x7d>
	}

	return fd2num(fd);
  801d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1f:	89 04 24             	mov    %eax,(%esp)
  801d22:	e8 b9 f7 ff ff       	call   8014e0 <fd2num>
  801d27:	89 c3                	mov    %eax,%ebx
}
  801d29:	89 d8                	mov    %ebx,%eax
  801d2b:	83 c4 20             	add    $0x20,%esp
  801d2e:	5b                   	pop    %ebx
  801d2f:	5e                   	pop    %esi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    
	...

00801d40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 18             	sub    $0x18,%esp
  801d46:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d49:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	89 04 24             	mov    %eax,(%esp)
  801d55:	e8 96 f7 ff ff       	call   8014f0 <fd2data>
  801d5a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d5c:	c7 44 24 04 0f 2e 80 	movl   $0x802e0f,0x4(%esp)
  801d63:	00 
  801d64:	89 34 24             	mov    %esi,(%esp)
  801d67:	e8 ff eb ff ff       	call   80096b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d6c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d6f:	2b 03                	sub    (%ebx),%eax
  801d71:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801d77:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801d7e:	00 00 00 
	stat->st_dev = &devpipe;
  801d81:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801d88:	30 80 00 
	return 0;
}
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d93:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d96:	89 ec                	mov    %ebp,%esp
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 14             	sub    $0x14,%esp
  801da1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801da4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801da8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801daf:	e8 75 f1 ff ff       	call   800f29 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801db4:	89 1c 24             	mov    %ebx,(%esp)
  801db7:	e8 34 f7 ff ff       	call   8014f0 <fd2data>
  801dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc7:	e8 5d f1 ff ff       	call   800f29 <sys_page_unmap>
}
  801dcc:	83 c4 14             	add    $0x14,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 2c             	sub    $0x2c,%esp
  801ddb:	89 c7                	mov    %eax,%edi
  801ddd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801de0:	a1 04 40 80 00       	mov    0x804004,%eax
  801de5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801de8:	89 3c 24             	mov    %edi,(%esp)
  801deb:	e8 a0 06 00 00       	call   802490 <pageref>
  801df0:	89 c6                	mov    %eax,%esi
  801df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	e8 93 06 00 00       	call   802490 <pageref>
  801dfd:	39 c6                	cmp    %eax,%esi
  801dff:	0f 94 c0             	sete   %al
  801e02:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801e05:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e0b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e0e:	39 cb                	cmp    %ecx,%ebx
  801e10:	75 08                	jne    801e1a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e12:	83 c4 2c             	add    $0x2c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e1a:	83 f8 01             	cmp    $0x1,%eax
  801e1d:	75 c1                	jne    801de0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e1f:	8b 52 58             	mov    0x58(%edx),%edx
  801e22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e2e:	c7 04 24 16 2e 80 00 	movl   $0x802e16,(%esp)
  801e35:	e8 19 e5 ff ff       	call   800353 <cprintf>
  801e3a:	eb a4                	jmp    801de0 <_pipeisclosed+0xe>

00801e3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 2c             	sub    $0x2c,%esp
  801e45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e48:	89 34 24             	mov    %esi,(%esp)
  801e4b:	e8 a0 f6 ff ff       	call   8014f0 <fd2data>
  801e50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e52:	bf 00 00 00 00       	mov    $0x0,%edi
  801e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e5b:	75 50                	jne    801ead <devpipe_write+0x71>
  801e5d:	eb 5c                	jmp    801ebb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e5f:	89 da                	mov    %ebx,%edx
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	e8 6a ff ff ff       	call   801dd2 <_pipeisclosed>
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	75 53                	jne    801ebf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e6c:	e8 cb ef ff ff       	call   800e3c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e71:	8b 43 04             	mov    0x4(%ebx),%eax
  801e74:	8b 13                	mov    (%ebx),%edx
  801e76:	83 c2 20             	add    $0x20,%edx
  801e79:	39 d0                	cmp    %edx,%eax
  801e7b:	73 e2                	jae    801e5f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801e84:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801e87:	89 c2                	mov    %eax,%edx
  801e89:	c1 fa 1f             	sar    $0x1f,%edx
  801e8c:	c1 ea 1b             	shr    $0x1b,%edx
  801e8f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e92:	83 e1 1f             	and    $0x1f,%ecx
  801e95:	29 d1                	sub    %edx,%ecx
  801e97:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e9b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e9f:	83 c0 01             	add    $0x1,%eax
  801ea2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea5:	83 c7 01             	add    $0x1,%edi
  801ea8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eab:	74 0e                	je     801ebb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ead:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb0:	8b 13                	mov    (%ebx),%edx
  801eb2:	83 c2 20             	add    $0x20,%edx
  801eb5:	39 d0                	cmp    %edx,%eax
  801eb7:	73 a6                	jae    801e5f <devpipe_write+0x23>
  801eb9:	eb c2                	jmp    801e7d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ebb:	89 f8                	mov    %edi,%eax
  801ebd:	eb 05                	jmp    801ec4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ec4:	83 c4 2c             	add    $0x2c,%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 28             	sub    $0x28,%esp
  801ed2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ed5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ed8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801edb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ede:	89 3c 24             	mov    %edi,(%esp)
  801ee1:	e8 0a f6 ff ff       	call   8014f0 <fd2data>
  801ee6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ee8:	be 00 00 00 00       	mov    $0x0,%esi
  801eed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ef1:	75 47                	jne    801f3a <devpipe_read+0x6e>
  801ef3:	eb 52                	jmp    801f47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ef5:	89 f0                	mov    %esi,%eax
  801ef7:	eb 5e                	jmp    801f57 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ef9:	89 da                	mov    %ebx,%edx
  801efb:	89 f8                	mov    %edi,%eax
  801efd:	8d 76 00             	lea    0x0(%esi),%esi
  801f00:	e8 cd fe ff ff       	call   801dd2 <_pipeisclosed>
  801f05:	85 c0                	test   %eax,%eax
  801f07:	75 49                	jne    801f52 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f09:	e8 2e ef ff ff       	call   800e3c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f0e:	8b 03                	mov    (%ebx),%eax
  801f10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f13:	74 e4                	je     801ef9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f15:	89 c2                	mov    %eax,%edx
  801f17:	c1 fa 1f             	sar    $0x1f,%edx
  801f1a:	c1 ea 1b             	shr    $0x1b,%edx
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	83 e0 1f             	and    $0x1f,%eax
  801f22:	29 d0                	sub    %edx,%eax
  801f24:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f2f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f32:	83 c6 01             	add    $0x1,%esi
  801f35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f38:	74 0d                	je     801f47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801f3a:	8b 03                	mov    (%ebx),%eax
  801f3c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f3f:	75 d4                	jne    801f15 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f41:	85 f6                	test   %esi,%esi
  801f43:	75 b0                	jne    801ef5 <devpipe_read+0x29>
  801f45:	eb b2                	jmp    801ef9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f47:	89 f0                	mov    %esi,%eax
  801f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f50:	eb 05                	jmp    801f57 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f60:	89 ec                	mov    %ebp,%esp
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    

00801f64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 48             	sub    $0x48,%esp
  801f6a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f6d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f70:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f73:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f79:	89 04 24             	mov    %eax,(%esp)
  801f7c:	e8 8a f5 ff ff       	call   80150b <fd_alloc>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	85 c0                	test   %eax,%eax
  801f85:	0f 88 45 01 00 00    	js     8020d0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f92:	00 
  801f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa1:	e8 c6 ee ff ff       	call   800e6c <sys_page_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	0f 88 20 01 00 00    	js     8020d0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fb3:	89 04 24             	mov    %eax,(%esp)
  801fb6:	e8 50 f5 ff ff       	call   80150b <fd_alloc>
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	0f 88 f8 00 00 00    	js     8020bd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fcc:	00 
  801fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fdb:	e8 8c ee ff ff       	call   800e6c <sys_page_alloc>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	0f 88 d3 00 00 00    	js     8020bd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fed:	89 04 24             	mov    %eax,(%esp)
  801ff0:	e8 fb f4 ff ff       	call   8014f0 <fd2data>
  801ff5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ffe:	00 
  801fff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802003:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200a:	e8 5d ee ff ff       	call   800e6c <sys_page_alloc>
  80200f:	89 c3                	mov    %eax,%ebx
  802011:	85 c0                	test   %eax,%eax
  802013:	0f 88 91 00 00 00    	js     8020aa <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201c:	89 04 24             	mov    %eax,(%esp)
  80201f:	e8 cc f4 ff ff       	call   8014f0 <fd2data>
  802024:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80202b:	00 
  80202c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802030:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802037:	00 
  802038:	89 74 24 04          	mov    %esi,0x4(%esp)
  80203c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802043:	e8 83 ee ff ff       	call   800ecb <sys_page_map>
  802048:	89 c3                	mov    %eax,%ebx
  80204a:	85 c0                	test   %eax,%eax
  80204c:	78 4c                	js     80209a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80204e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802057:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80205c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802063:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80206c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80206e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802071:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207b:	89 04 24             	mov    %eax,(%esp)
  80207e:	e8 5d f4 ff ff       	call   8014e0 <fd2num>
  802083:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802088:	89 04 24             	mov    %eax,(%esp)
  80208b:	e8 50 f4 ff ff       	call   8014e0 <fd2num>
  802090:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802093:	bb 00 00 00 00       	mov    $0x0,%ebx
  802098:	eb 36                	jmp    8020d0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80209a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80209e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a5:	e8 7f ee ff ff       	call   800f29 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b8:	e8 6c ee ff ff       	call   800f29 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020cb:	e8 59 ee ff ff       	call   800f29 <sys_page_unmap>
    err:
	return r;
}
  8020d0:	89 d8                	mov    %ebx,%eax
  8020d2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020d5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020db:	89 ec                	mov    %ebp,%esp
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    

008020df <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	89 04 24             	mov    %eax,(%esp)
  8020f2:	e8 87 f4 ff ff       	call   80157e <fd_lookup>
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 15                	js     802110 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	89 04 24             	mov    %eax,(%esp)
  802101:	e8 ea f3 ff ff       	call   8014f0 <fd2data>
	return _pipeisclosed(fd, p);
  802106:	89 c2                	mov    %eax,%edx
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	e8 c2 fc ff ff       	call   801dd2 <_pipeisclosed>
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    
	...

00802120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    

0080212a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802130:	c7 44 24 04 2e 2e 80 	movl   $0x802e2e,0x4(%esp)
  802137:	00 
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	89 04 24             	mov    %eax,(%esp)
  80213e:	e8 28 e8 ff ff       	call   80096b <strcpy>
	return 0;
}
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	57                   	push   %edi
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802156:	be 00 00 00 00       	mov    $0x0,%esi
  80215b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80215f:	74 43                	je     8021a4 <devcons_write+0x5a>
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80216c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80216f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802171:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802174:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802179:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80217c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802180:	03 45 0c             	add    0xc(%ebp),%eax
  802183:	89 44 24 04          	mov    %eax,0x4(%esp)
  802187:	89 3c 24             	mov    %edi,(%esp)
  80218a:	e8 cd e9 ff ff       	call   800b5c <memmove>
		sys_cputs(buf, m);
  80218f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802193:	89 3c 24             	mov    %edi,(%esp)
  802196:	e8 b5 eb ff ff       	call   800d50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80219b:	01 de                	add    %ebx,%esi
  80219d:	89 f0                	mov    %esi,%eax
  80219f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a2:	72 c8                	jb     80216c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021a4:	89 f0                	mov    %esi,%eax
  8021a6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5f                   	pop    %edi
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    

008021b1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021c0:	75 07                	jne    8021c9 <devcons_read+0x18>
  8021c2:	eb 31                	jmp    8021f5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021c4:	e8 73 ec ff ff       	call   800e3c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	e8 aa eb ff ff       	call   800d7f <sys_cgetc>
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 eb                	je     8021c4 <devcons_read+0x13>
  8021d9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 16                	js     8021f5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021df:	83 f8 04             	cmp    $0x4,%eax
  8021e2:	74 0c                	je     8021f0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	88 10                	mov    %dl,(%eax)
	return 1;
  8021e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ee:	eb 05                	jmp    8021f5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802203:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80220a:	00 
  80220b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80220e:	89 04 24             	mov    %eax,(%esp)
  802211:	e8 3a eb ff ff       	call   800d50 <sys_cputs>
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <getchar>:

int
getchar(void)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80221e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802225:	00 
  802226:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802234:	e8 05 f6 ff ff       	call   80183e <read>
	if (r < 0)
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 0f                	js     80224c <getchar+0x34>
		return r;
	if (r < 1)
  80223d:	85 c0                	test   %eax,%eax
  80223f:	7e 06                	jle    802247 <getchar+0x2f>
		return -E_EOF;
	return c;
  802241:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802245:	eb 05                	jmp    80224c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802247:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 04 24             	mov    %eax,(%esp)
  802261:	e8 18 f3 ff ff       	call   80157e <fd_lookup>
  802266:	85 c0                	test   %eax,%eax
  802268:	78 11                	js     80227b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802273:	39 10                	cmp    %edx,(%eax)
  802275:	0f 94 c0             	sete   %al
  802278:	0f b6 c0             	movzbl %al,%eax
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <opencons>:

int
opencons(void)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802286:	89 04 24             	mov    %eax,(%esp)
  802289:	e8 7d f2 ff ff       	call   80150b <fd_alloc>
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 3c                	js     8022ce <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802292:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802299:	00 
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a8:	e8 bf eb ff ff       	call   800e6c <sys_page_alloc>
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	78 1d                	js     8022ce <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022b1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022c6:	89 04 24             	mov    %eax,(%esp)
  8022c9:	e8 12 f2 ff ff       	call   8014e0 <fd2num>
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8022d6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8022dd:	75 54                	jne    802333 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8022df:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8022e6:	00 
  8022e7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8022ee:	ee 
  8022ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f6:	e8 71 eb ff ff       	call   800e6c <sys_page_alloc>
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	79 20                	jns    80231f <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  8022ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802303:	c7 44 24 08 3a 2e 80 	movl   $0x802e3a,0x8(%esp)
  80230a:	00 
  80230b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  802312:	00 
  802313:	c7 04 24 52 2e 80 00 	movl   $0x802e52,(%esp)
  80231a:	e8 39 df ff ff       	call   800258 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80231f:	c7 44 24 04 40 23 80 	movl   $0x802340,0x4(%esp)
  802326:	00 
  802327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232e:	e8 10 ed ff ff       	call   801043 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    
  80233d:	00 00                	add    %al,(%eax)
	...

00802340 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802340:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802341:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802346:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802348:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  80234b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80234f:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802352:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  802356:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80235a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80235c:	83 c4 08             	add    $0x8,%esp
	popal
  80235f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802360:	83 c4 04             	add    $0x4,%esp
	popfl
  802363:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802364:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802365:	c3                   	ret    
	...

00802370 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	56                   	push   %esi
  802374:	53                   	push   %ebx
  802375:	83 ec 10             	sub    $0x10,%esp
  802378:	8b 75 08             	mov    0x8(%ebp),%esi
  80237b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802381:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802383:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802388:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 42 ed ff ff       	call   8010d5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802393:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802398:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80239d:	85 c0                	test   %eax,%eax
  80239f:	78 0e                	js     8023af <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8023a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8023a6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8023a9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8023ac:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8023af:	85 f6                	test   %esi,%esi
  8023b1:	74 02                	je     8023b5 <ipc_recv+0x45>
		*from_env_store = sender;
  8023b3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8023b5:	85 db                	test   %ebx,%ebx
  8023b7:	74 02                	je     8023bb <ipc_recv+0x4b>
		*perm_store = perm;
  8023b9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	5b                   	pop    %ebx
  8023bf:	5e                   	pop    %esi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    

008023c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	57                   	push   %edi
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 1c             	sub    $0x1c,%esp
  8023cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023d1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8023d4:	85 db                	test   %ebx,%ebx
  8023d6:	75 04                	jne    8023dc <ipc_send+0x1a>
  8023d8:	85 f6                	test   %esi,%esi
  8023da:	75 15                	jne    8023f1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8023dc:	85 db                	test   %ebx,%ebx
  8023de:	74 16                	je     8023f6 <ipc_send+0x34>
  8023e0:	85 f6                	test   %esi,%esi
  8023e2:	0f 94 c0             	sete   %al
      pg = 0;
  8023e5:	84 c0                	test   %al,%al
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	0f 45 d8             	cmovne %eax,%ebx
  8023ef:	eb 05                	jmp    8023f6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8023f1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8023f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8023fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	89 04 24             	mov    %eax,(%esp)
  802408:	e8 94 ec ff ff       	call   8010a1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80240d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802410:	75 07                	jne    802419 <ipc_send+0x57>
           sys_yield();
  802412:	e8 25 ea ff ff       	call   800e3c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802417:	eb dd                	jmp    8023f6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802419:	85 c0                	test   %eax,%eax
  80241b:	90                   	nop
  80241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802420:	74 1c                	je     80243e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802422:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  802429:	00 
  80242a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802431:	00 
  802432:	c7 04 24 6a 2e 80 00 	movl   $0x802e6a,(%esp)
  802439:	e8 1a de ff ff       	call   800258 <_panic>
		}
    }
}
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    

00802446 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80244c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802451:	39 c8                	cmp    %ecx,%eax
  802453:	74 17                	je     80246c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802455:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80245a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80245d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802463:	8b 52 50             	mov    0x50(%edx),%edx
  802466:	39 ca                	cmp    %ecx,%edx
  802468:	75 14                	jne    80247e <ipc_find_env+0x38>
  80246a:	eb 05                	jmp    802471 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802471:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802474:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802479:	8b 40 40             	mov    0x40(%eax),%eax
  80247c:	eb 0e                	jmp    80248c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80247e:	83 c0 01             	add    $0x1,%eax
  802481:	3d 00 04 00 00       	cmp    $0x400,%eax
  802486:	75 d2                	jne    80245a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802488:	66 b8 00 00          	mov    $0x0,%ax
}
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    
	...

00802490 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802496:	89 d0                	mov    %edx,%eax
  802498:	c1 e8 16             	shr    $0x16,%eax
  80249b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a7:	f6 c1 01             	test   $0x1,%cl
  8024aa:	74 1d                	je     8024c9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024ac:	c1 ea 0c             	shr    $0xc,%edx
  8024af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024b6:	f6 c2 01             	test   $0x1,%dl
  8024b9:	74 0e                	je     8024c9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024bb:	c1 ea 0c             	shr    $0xc,%edx
  8024be:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024c5:	ef 
  8024c6:	0f b7 c0             	movzwl %ax,%eax
}
  8024c9:	5d                   	pop    %ebp
  8024ca:	c3                   	ret    
  8024cb:	00 00                	add    %al,(%eax)
  8024cd:	00 00                	add    %al,(%eax)
	...

008024d0 <__udivdi3>:
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8024d7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8024db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8024df:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024eb:	85 ff                	test   %edi,%edi
  8024ed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f5:	89 cd                	mov    %ecx,%ebp
  8024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fb:	75 33                	jne    802530 <__udivdi3+0x60>
  8024fd:	39 f1                	cmp    %esi,%ecx
  8024ff:	77 57                	ja     802558 <__udivdi3+0x88>
  802501:	85 c9                	test   %ecx,%ecx
  802503:	75 0b                	jne    802510 <__udivdi3+0x40>
  802505:	b8 01 00 00 00       	mov    $0x1,%eax
  80250a:	31 d2                	xor    %edx,%edx
  80250c:	f7 f1                	div    %ecx
  80250e:	89 c1                	mov    %eax,%ecx
  802510:	89 f0                	mov    %esi,%eax
  802512:	31 d2                	xor    %edx,%edx
  802514:	f7 f1                	div    %ecx
  802516:	89 c6                	mov    %eax,%esi
  802518:	8b 44 24 04          	mov    0x4(%esp),%eax
  80251c:	f7 f1                	div    %ecx
  80251e:	89 f2                	mov    %esi,%edx
  802520:	8b 74 24 10          	mov    0x10(%esp),%esi
  802524:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802528:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	c3                   	ret    
  802530:	31 d2                	xor    %edx,%edx
  802532:	31 c0                	xor    %eax,%eax
  802534:	39 f7                	cmp    %esi,%edi
  802536:	77 e8                	ja     802520 <__udivdi3+0x50>
  802538:	0f bd cf             	bsr    %edi,%ecx
  80253b:	83 f1 1f             	xor    $0x1f,%ecx
  80253e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802542:	75 2c                	jne    802570 <__udivdi3+0xa0>
  802544:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802548:	76 04                	jbe    80254e <__udivdi3+0x7e>
  80254a:	39 f7                	cmp    %esi,%edi
  80254c:	73 d2                	jae    802520 <__udivdi3+0x50>
  80254e:	31 d2                	xor    %edx,%edx
  802550:	b8 01 00 00 00       	mov    $0x1,%eax
  802555:	eb c9                	jmp    802520 <__udivdi3+0x50>
  802557:	90                   	nop
  802558:	89 f2                	mov    %esi,%edx
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802562:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802566:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	c3                   	ret    
  80256e:	66 90                	xchg   %ax,%ax
  802570:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802575:	b8 20 00 00 00       	mov    $0x20,%eax
  80257a:	89 ea                	mov    %ebp,%edx
  80257c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802580:	d3 e7                	shl    %cl,%edi
  802582:	89 c1                	mov    %eax,%ecx
  802584:	d3 ea                	shr    %cl,%edx
  802586:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258b:	09 fa                	or     %edi,%edx
  80258d:	89 f7                	mov    %esi,%edi
  80258f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802593:	89 f2                	mov    %esi,%edx
  802595:	8b 74 24 08          	mov    0x8(%esp),%esi
  802599:	d3 e5                	shl    %cl,%ebp
  80259b:	89 c1                	mov    %eax,%ecx
  80259d:	d3 ef                	shr    %cl,%edi
  80259f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025a4:	d3 e2                	shl    %cl,%edx
  8025a6:	89 c1                	mov    %eax,%ecx
  8025a8:	d3 ee                	shr    %cl,%esi
  8025aa:	09 d6                	or     %edx,%esi
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	89 f0                	mov    %esi,%eax
  8025b0:	f7 74 24 0c          	divl   0xc(%esp)
  8025b4:	89 d7                	mov    %edx,%edi
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	f7 e5                	mul    %ebp
  8025ba:	39 d7                	cmp    %edx,%edi
  8025bc:	72 22                	jb     8025e0 <__udivdi3+0x110>
  8025be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8025c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025c7:	d3 e5                	shl    %cl,%ebp
  8025c9:	39 c5                	cmp    %eax,%ebp
  8025cb:	73 04                	jae    8025d1 <__udivdi3+0x101>
  8025cd:	39 d7                	cmp    %edx,%edi
  8025cf:	74 0f                	je     8025e0 <__udivdi3+0x110>
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	31 d2                	xor    %edx,%edx
  8025d5:	e9 46 ff ff ff       	jmp    802520 <__udivdi3+0x50>
  8025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025f1:	83 c4 1c             	add    $0x1c,%esp
  8025f4:	c3                   	ret    
	...

00802600 <__umoddi3>:
  802600:	83 ec 1c             	sub    $0x1c,%esp
  802603:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802607:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80260b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80260f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802613:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802617:	8b 74 24 24          	mov    0x24(%esp),%esi
  80261b:	85 ed                	test   %ebp,%ebp
  80261d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802621:	89 44 24 08          	mov    %eax,0x8(%esp)
  802625:	89 cf                	mov    %ecx,%edi
  802627:	89 04 24             	mov    %eax,(%esp)
  80262a:	89 f2                	mov    %esi,%edx
  80262c:	75 1a                	jne    802648 <__umoddi3+0x48>
  80262e:	39 f1                	cmp    %esi,%ecx
  802630:	76 4e                	jbe    802680 <__umoddi3+0x80>
  802632:	f7 f1                	div    %ecx
  802634:	89 d0                	mov    %edx,%eax
  802636:	31 d2                	xor    %edx,%edx
  802638:	8b 74 24 10          	mov    0x10(%esp),%esi
  80263c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802640:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802644:	83 c4 1c             	add    $0x1c,%esp
  802647:	c3                   	ret    
  802648:	39 f5                	cmp    %esi,%ebp
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd c5             	bsr    %ebp,%eax
  80264f:	83 f0 1f             	xor    $0x1f,%eax
  802652:	89 44 24 04          	mov    %eax,0x4(%esp)
  802656:	75 60                	jne    8026b8 <__umoddi3+0xb8>
  802658:	3b 0c 24             	cmp    (%esp),%ecx
  80265b:	0f 87 07 01 00 00    	ja     802768 <__umoddi3+0x168>
  802661:	89 f2                	mov    %esi,%edx
  802663:	8b 34 24             	mov    (%esp),%esi
  802666:	29 ce                	sub    %ecx,%esi
  802668:	19 ea                	sbb    %ebp,%edx
  80266a:	89 34 24             	mov    %esi,(%esp)
  80266d:	8b 04 24             	mov    (%esp),%eax
  802670:	8b 74 24 10          	mov    0x10(%esp),%esi
  802674:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802678:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	c3                   	ret    
  802680:	85 c9                	test   %ecx,%ecx
  802682:	75 0b                	jne    80268f <__umoddi3+0x8f>
  802684:	b8 01 00 00 00       	mov    $0x1,%eax
  802689:	31 d2                	xor    %edx,%edx
  80268b:	f7 f1                	div    %ecx
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	89 f0                	mov    %esi,%eax
  802691:	31 d2                	xor    %edx,%edx
  802693:	f7 f1                	div    %ecx
  802695:	8b 04 24             	mov    (%esp),%eax
  802698:	f7 f1                	div    %ecx
  80269a:	eb 98                	jmp    802634 <__umoddi3+0x34>
  80269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 f2                	mov    %esi,%edx
  8026a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	c3                   	ret    
  8026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bd:	89 e8                	mov    %ebp,%eax
  8026bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8026c8:	89 fa                	mov    %edi,%edx
  8026ca:	d3 e0                	shl    %cl,%eax
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	d3 ea                	shr    %cl,%edx
  8026d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026d5:	09 c2                	or     %eax,%edx
  8026d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026db:	89 14 24             	mov    %edx,(%esp)
  8026de:	89 f2                	mov    %esi,%edx
  8026e0:	d3 e7                	shl    %cl,%edi
  8026e2:	89 e9                	mov    %ebp,%ecx
  8026e4:	d3 ea                	shr    %cl,%edx
  8026e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	d3 e6                	shl    %cl,%esi
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e8                	shr    %cl,%eax
  8026f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fa:	09 f0                	or     %esi,%eax
  8026fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802700:	f7 34 24             	divl   (%esp)
  802703:	d3 e6                	shl    %cl,%esi
  802705:	89 74 24 08          	mov    %esi,0x8(%esp)
  802709:	89 d6                	mov    %edx,%esi
  80270b:	f7 e7                	mul    %edi
  80270d:	39 d6                	cmp    %edx,%esi
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	89 d7                	mov    %edx,%edi
  802713:	72 3f                	jb     802754 <__umoddi3+0x154>
  802715:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802719:	72 35                	jb     802750 <__umoddi3+0x150>
  80271b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80271f:	29 c8                	sub    %ecx,%eax
  802721:	19 fe                	sbb    %edi,%esi
  802723:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802728:	89 f2                	mov    %esi,%edx
  80272a:	d3 e8                	shr    %cl,%eax
  80272c:	89 e9                	mov    %ebp,%ecx
  80272e:	d3 e2                	shl    %cl,%edx
  802730:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802735:	09 d0                	or     %edx,%eax
  802737:	89 f2                	mov    %esi,%edx
  802739:	d3 ea                	shr    %cl,%edx
  80273b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80273f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802743:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802747:	83 c4 1c             	add    $0x1c,%esp
  80274a:	c3                   	ret    
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 d6                	cmp    %edx,%esi
  802752:	75 c7                	jne    80271b <__umoddi3+0x11b>
  802754:	89 d7                	mov    %edx,%edi
  802756:	89 c1                	mov    %eax,%ecx
  802758:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80275c:	1b 3c 24             	sbb    (%esp),%edi
  80275f:	eb ba                	jmp    80271b <__umoddi3+0x11b>
  802761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802768:	39 f5                	cmp    %esi,%ebp
  80276a:	0f 82 f1 fe ff ff    	jb     802661 <__umoddi3+0x61>
  802770:	e9 f8 fe ff ff       	jmp    80266d <__umoddi3+0x6d>
