
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 f3 01 00 00       	call   800224 <libmain>
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
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 c0 27 80 00 	movl   $0x8027c0,(%esp)
  80004f:	e8 37 03 00 00       	call   80038b <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 95 20 00 00       	call   8020f4 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 d9 27 80 	movl   $0x8027d9,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 e2 27 80 00 	movl   $0x8027e2,(%esp)
  80007e:	e8 0d 02 00 00       	call   800290 <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 eb 11 00 00       	call   801273 <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 75 2d 80 	movl   $0x802d75,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 e2 27 80 00 	movl   $0x8027e2,(%esp)
  8000a9:	e8 e2 01 00 00       	call   800290 <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 70 17 00 00       	call   80182d <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 a2 21 00 00       	call   80226f <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 f6 27 80 00 	movl   $0x8027f6,(%esp)
  8000d8:	e8 ae 02 00 00       	call   80038b <cprintf>
				exit();
  8000dd:	e8 92 01 00 00       	call   800274 <exit>
			}
			sys_yield();
  8000e2:	e8 95 0d 00 00       	call   800e7c <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 18 14 00 00       	call   801520 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 11 28 80 00 	movl   $0x802811,(%esp)
  800113:	e8 73 02 00 00       	call   80038b <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  800121:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800127:	c1 ee 02             	shr    $0x2,%esi
  80012a:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  80013b:	e8 4b 02 00 00       	call   80038b <cprintf>
	dup(p[0], 10);
  800140:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800147:	00 
  800148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014b:	89 04 24             	mov    %eax,(%esp)
  80014e:	e8 2d 17 00 00       	call   801880 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800153:	8b 43 54             	mov    0x54(%ebx),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 1b                	jne    800176 <umain+0x136>
		dup(p[0], 10);
  80015b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800162:	00 
  800163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800166:	89 04 24             	mov    %eax,(%esp)
  800169:	e8 12 17 00 00       	call   801880 <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80016e:	8b 43 54             	mov    0x54(%ebx),%eax
  800171:	83 f8 02             	cmp    $0x2,%eax
  800174:	74 e5                	je     80015b <umain+0x11b>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800176:	c7 04 24 27 28 80 00 	movl   $0x802827,(%esp)
  80017d:	e8 09 02 00 00       	call   80038b <cprintf>
	if (pipeisclosed(p[0]))
  800182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 e2 20 00 00       	call   80226f <pipeisclosed>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	74 1c                	je     8001ad <umain+0x16d>
		panic("somehow the other end of p[0] got closed!");
  800191:	c7 44 24 08 80 28 80 	movl   $0x802880,0x8(%esp)
  800198:	00 
  800199:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8001a0:	00 
  8001a1:	c7 04 24 e2 27 80 00 	movl   $0x8027e2,(%esp)
  8001a8:	e8 e3 00 00 00       	call   800290 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 1f 15 00 00       	call   8016de <fd_lookup>
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	79 20                	jns    8001e3 <umain+0x1a3>
		panic("cannot look up p[0]: %e", r);
  8001c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c7:	c7 44 24 08 3d 28 80 	movl   $0x80283d,0x8(%esp)
  8001ce:	00 
  8001cf:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d6:	00 
  8001d7:	c7 04 24 e2 27 80 00 	movl   $0x8027e2,(%esp)
  8001de:	e8 ad 00 00 00       	call   800290 <_panic>
	va = fd2data(fd);
  8001e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 62 14 00 00       	call   801650 <fd2data>
	if (pageref(va) != 3+1)
  8001ee:	89 04 24             	mov    %eax,(%esp)
  8001f1:	e8 9e 1c 00 00       	call   801e94 <pageref>
  8001f6:	83 f8 04             	cmp    $0x4,%eax
  8001f9:	74 0e                	je     800209 <umain+0x1c9>
		cprintf("\nchild detected race\n");
  8001fb:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  800202:	e8 84 01 00 00       	call   80038b <cprintf>
  800207:	eb 14                	jmp    80021d <umain+0x1dd>
	else
		cprintf("\nrace didn't happen\n", max);
  800209:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  800210:	00 
  800211:	c7 04 24 6b 28 80 00 	movl   $0x80286b,(%esp)
  800218:	e8 6e 01 00 00       	call   80038b <cprintf>
}
  80021d:	83 c4 20             	add    $0x20,%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5d                   	pop    %ebp
  800223:	c3                   	ret    

00800224 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 18             	sub    $0x18,%esp
  80022a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80022d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800230:	8b 75 08             	mov    0x8(%ebp),%esi
  800233:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800236:	e8 11 0c 00 00       	call   800e4c <sys_getenvid>
  80023b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800240:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800243:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800248:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024d:	85 f6                	test   %esi,%esi
  80024f:	7e 07                	jle    800258 <libmain+0x34>
		binaryname = argv[0];
  800251:	8b 03                	mov    (%ebx),%eax
  800253:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800258:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80025c:	89 34 24             	mov    %esi,(%esp)
  80025f:	e8 dc fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800264:	e8 0b 00 00 00       	call   800274 <exit>
}
  800269:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80026c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80026f:	89 ec                	mov    %ebp,%esp
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
	...

00800274 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80027a:	e8 df 15 00 00       	call   80185e <close_all>
	sys_env_destroy(0);
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 64 0b 00 00       	call   800def <sys_env_destroy>
}
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    
  80028d:	00 00                	add    %al,(%eax)
	...

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800298:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8002a1:	e8 a6 0b 00 00       	call   800e4c <sys_getenvid>
  8002a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bc:	c7 04 24 b4 28 80 00 	movl   $0x8028b4,(%esp)
  8002c3:	e8 c3 00 00 00       	call   80038b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	89 04 24             	mov    %eax,(%esp)
  8002d2:	e8 53 00 00 00       	call   80032a <vcprintf>
	cprintf("\n");
  8002d7:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  8002de:	e8 a8 00 00 00       	call   80038b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e3:	cc                   	int3   
  8002e4:	eb fd                	jmp    8002e3 <_panic+0x53>
	...

008002e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 14             	sub    $0x14,%esp
  8002ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f2:	8b 03                	mov    (%ebx),%eax
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002fb:	83 c0 01             	add    $0x1,%eax
  8002fe:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800300:	3d ff 00 00 00       	cmp    $0xff,%eax
  800305:	75 19                	jne    800320 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800307:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80030e:	00 
  80030f:	8d 43 08             	lea    0x8(%ebx),%eax
  800312:	89 04 24             	mov    %eax,(%esp)
  800315:	e8 76 0a 00 00       	call   800d90 <sys_cputs>
		b->idx = 0;
  80031a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800320:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800324:	83 c4 14             	add    $0x14,%esp
  800327:	5b                   	pop    %ebx
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    

0080032a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800333:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033a:	00 00 00 
	b.cnt = 0;
  80033d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800344:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 44 24 08          	mov    %eax,0x8(%esp)
  800355:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	c7 04 24 e8 02 80 00 	movl   $0x8002e8,(%esp)
  800366:	e8 9f 01 00 00       	call   80050a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800371:	89 44 24 04          	mov    %eax,0x4(%esp)
  800375:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037b:	89 04 24             	mov    %eax,(%esp)
  80037e:	e8 0d 0a 00 00       	call   800d90 <sys_cputs>

	return b.cnt;
}
  800383:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800394:	89 44 24 04          	mov    %eax,0x4(%esp)
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	e8 87 ff ff ff       	call   80032a <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    
	...

008003b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
  8003b6:	83 ec 3c             	sub    $0x3c,%esp
  8003b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bc:	89 d7                	mov    %edx,%edi
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003cd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d8:	72 11                	jb     8003eb <printnum+0x3b>
  8003da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003dd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003e0:	76 09                	jbe    8003eb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 eb 01             	sub    $0x1,%ebx
  8003e5:	85 db                	test   %ebx,%ebx
  8003e7:	7f 51                	jg     80043a <printnum+0x8a>
  8003e9:	eb 5e                	jmp    800449 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003eb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8003ef:	83 eb 01             	sub    $0x1,%ebx
  8003f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800401:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800405:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80040c:	00 
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800416:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041a:	e8 e1 20 00 00       	call   802500 <__udivdi3>
  80041f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800423:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80042e:	89 fa                	mov    %edi,%edx
  800430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800433:	e8 78 ff ff ff       	call   8003b0 <printnum>
  800438:	eb 0f                	jmp    800449 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043e:	89 34 24             	mov    %esi,(%esp)
  800441:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800444:	83 eb 01             	sub    $0x1,%ebx
  800447:	75 f1                	jne    80043a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800449:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800451:	8b 45 10             	mov    0x10(%ebp),%eax
  800454:	89 44 24 08          	mov    %eax,0x8(%esp)
  800458:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80045f:	00 
  800460:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800463:	89 04 24             	mov    %eax,(%esp)
  800466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046d:	e8 be 21 00 00       	call   802630 <__umoddi3>
  800472:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800476:	0f be 80 d7 28 80 00 	movsbl 0x8028d7(%eax),%eax
  80047d:	89 04 24             	mov    %eax,(%esp)
  800480:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800483:	83 c4 3c             	add    $0x3c,%esp
  800486:	5b                   	pop    %ebx
  800487:	5e                   	pop    %esi
  800488:	5f                   	pop    %edi
  800489:	5d                   	pop    %ebp
  80048a:	c3                   	ret    

0080048b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80048e:	83 fa 01             	cmp    $0x1,%edx
  800491:	7e 0e                	jle    8004a1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800493:	8b 10                	mov    (%eax),%edx
  800495:	8d 4a 08             	lea    0x8(%edx),%ecx
  800498:	89 08                	mov    %ecx,(%eax)
  80049a:	8b 02                	mov    (%edx),%eax
  80049c:	8b 52 04             	mov    0x4(%edx),%edx
  80049f:	eb 22                	jmp    8004c3 <getuint+0x38>
	else if (lflag)
  8004a1:	85 d2                	test   %edx,%edx
  8004a3:	74 10                	je     8004b5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004a5:	8b 10                	mov    (%eax),%edx
  8004a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004aa:	89 08                	mov    %ecx,(%eax)
  8004ac:	8b 02                	mov    (%edx),%eax
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b3:	eb 0e                	jmp    8004c3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004b5:	8b 10                	mov    (%eax),%edx
  8004b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ba:	89 08                	mov    %ecx,(%eax)
  8004bc:	8b 02                	mov    (%edx),%eax
  8004be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004cf:	8b 10                	mov    (%eax),%edx
  8004d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d4:	73 0a                	jae    8004e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d9:	88 0a                	mov    %cl,(%edx)
  8004db:	83 c2 01             	add    $0x1,%edx
  8004de:	89 10                	mov    %edx,(%eax)
}
  8004e0:	5d                   	pop    %ebp
  8004e1:	c3                   	ret    

008004e2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	e8 02 00 00 00       	call   80050a <vprintfmt>
	va_end(ap);
}
  800508:	c9                   	leave  
  800509:	c3                   	ret    

0080050a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050a:	55                   	push   %ebp
  80050b:	89 e5                	mov    %esp,%ebp
  80050d:	57                   	push   %edi
  80050e:	56                   	push   %esi
  80050f:	53                   	push   %ebx
  800510:	83 ec 4c             	sub    $0x4c,%esp
  800513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800516:	8b 75 10             	mov    0x10(%ebp),%esi
  800519:	eb 12                	jmp    80052d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80051b:	85 c0                	test   %eax,%eax
  80051d:	0f 84 a9 03 00 00    	je     8008cc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800523:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800527:	89 04 24             	mov    %eax,(%esp)
  80052a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	0f b6 06             	movzbl (%esi),%eax
  800530:	83 c6 01             	add    $0x1,%esi
  800533:	83 f8 25             	cmp    $0x25,%eax
  800536:	75 e3                	jne    80051b <vprintfmt+0x11>
  800538:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80053c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800543:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800548:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80054f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800554:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800557:	eb 2b                	jmp    800584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800559:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80055c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800560:	eb 22                	jmp    800584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800565:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800569:	eb 19                	jmp    800584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80056e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800575:	eb 0d                	jmp    800584 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800577:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80057a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800584:	0f b6 06             	movzbl (%esi),%eax
  800587:	0f b6 d0             	movzbl %al,%edx
  80058a:	8d 7e 01             	lea    0x1(%esi),%edi
  80058d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800590:	83 e8 23             	sub    $0x23,%eax
  800593:	3c 55                	cmp    $0x55,%al
  800595:	0f 87 0b 03 00 00    	ja     8008a6 <vprintfmt+0x39c>
  80059b:	0f b6 c0             	movzbl %al,%eax
  80059e:	ff 24 85 20 2a 80 00 	jmp    *0x802a20(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a5:	83 ea 30             	sub    $0x30,%edx
  8005a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8005ab:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8005af:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8005b5:	83 fa 09             	cmp    $0x9,%edx
  8005b8:	77 4a                	ja     800604 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005bd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005c0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8005c3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8005c7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ca:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005cd:	83 fa 09             	cmp    $0x9,%edx
  8005d0:	76 eb                	jbe    8005bd <vprintfmt+0xb3>
  8005d2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d5:	eb 2d                	jmp    800604 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 50 04             	lea    0x4(%eax),%edx
  8005dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005e8:	eb 1a                	jmp    800604 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 91                	jns    800584 <vprintfmt+0x7a>
  8005f3:	e9 73 ff ff ff       	jmp    80056b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800602:	eb 80                	jmp    800584 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800604:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800608:	0f 89 76 ff ff ff    	jns    800584 <vprintfmt+0x7a>
  80060e:	e9 64 ff ff ff       	jmp    800577 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800613:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800616:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800619:	e9 66 ff ff ff       	jmp    800584 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 50 04             	lea    0x4(%eax),%edx
  800624:	89 55 14             	mov    %edx,0x14(%ebp)
  800627:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 04 24             	mov    %eax,(%esp)
  800630:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800633:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800636:	e9 f2 fe ff ff       	jmp    80052d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 50 04             	lea    0x4(%eax),%edx
  800641:	89 55 14             	mov    %edx,0x14(%ebp)
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 c2                	mov    %eax,%edx
  800648:	c1 fa 1f             	sar    $0x1f,%edx
  80064b:	31 d0                	xor    %edx,%eax
  80064d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80064f:	83 f8 0f             	cmp    $0xf,%eax
  800652:	7f 0b                	jg     80065f <vprintfmt+0x155>
  800654:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  80065b:	85 d2                	test   %edx,%edx
  80065d:	75 23                	jne    800682 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80065f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800663:	c7 44 24 08 ef 28 80 	movl   $0x8028ef,0x8(%esp)
  80066a:	00 
  80066b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80066f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800672:	89 3c 24             	mov    %edi,(%esp)
  800675:	e8 68 fe ff ff       	call   8004e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80067d:	e9 ab fe ff ff       	jmp    80052d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800682:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800686:	c7 44 24 08 69 2e 80 	movl   $0x802e69,0x8(%esp)
  80068d:	00 
  80068e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800692:	8b 7d 08             	mov    0x8(%ebp),%edi
  800695:	89 3c 24             	mov    %edi,(%esp)
  800698:	e8 45 fe ff ff       	call   8004e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006a0:	e9 88 fe ff ff       	jmp    80052d <vprintfmt+0x23>
  8006a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8006b9:	85 f6                	test   %esi,%esi
  8006bb:	ba e8 28 80 00       	mov    $0x8028e8,%edx
  8006c0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8006c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c7:	7e 06                	jle    8006cf <vprintfmt+0x1c5>
  8006c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8006cd:	75 10                	jne    8006df <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cf:	0f be 06             	movsbl (%esi),%eax
  8006d2:	83 c6 01             	add    $0x1,%esi
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 85 86 00 00 00    	jne    800763 <vprintfmt+0x259>
  8006dd:	eb 76                	jmp    800755 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e3:	89 34 24             	mov    %esi,(%esp)
  8006e6:	e8 90 02 00 00       	call   80097b <strnlen>
  8006eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f3:	85 d2                	test   %edx,%edx
  8006f5:	7e d8                	jle    8006cf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006f7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8006fe:	89 d6                	mov    %edx,%esi
  800700:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800703:	89 c7                	mov    %eax,%edi
  800705:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800709:	89 3c 24             	mov    %edi,(%esp)
  80070c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070f:	83 ee 01             	sub    $0x1,%esi
  800712:	75 f1                	jne    800705 <vprintfmt+0x1fb>
  800714:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800717:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80071a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80071d:	eb b0                	jmp    8006cf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80071f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800723:	74 18                	je     80073d <vprintfmt+0x233>
  800725:	8d 50 e0             	lea    -0x20(%eax),%edx
  800728:	83 fa 5e             	cmp    $0x5e,%edx
  80072b:	76 10                	jbe    80073d <vprintfmt+0x233>
					putch('?', putdat);
  80072d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800731:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800738:	ff 55 08             	call   *0x8(%ebp)
  80073b:	eb 0a                	jmp    800747 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80073d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800741:	89 04 24             	mov    %eax,(%esp)
  800744:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800747:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80074b:	0f be 06             	movsbl (%esi),%eax
  80074e:	83 c6 01             	add    $0x1,%esi
  800751:	85 c0                	test   %eax,%eax
  800753:	75 0e                	jne    800763 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800755:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075c:	7f 16                	jg     800774 <vprintfmt+0x26a>
  80075e:	e9 ca fd ff ff       	jmp    80052d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800763:	85 ff                	test   %edi,%edi
  800765:	78 b8                	js     80071f <vprintfmt+0x215>
  800767:	83 ef 01             	sub    $0x1,%edi
  80076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800770:	79 ad                	jns    80071f <vprintfmt+0x215>
  800772:	eb e1                	jmp    800755 <vprintfmt+0x24b>
  800774:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800777:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80077a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80077e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800785:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800787:	83 ee 01             	sub    $0x1,%esi
  80078a:	75 ee                	jne    80077a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80078f:	e9 99 fd ff ff       	jmp    80052d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800794:	83 f9 01             	cmp    $0x1,%ecx
  800797:	7e 10                	jle    8007a9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 50 08             	lea    0x8(%eax),%edx
  80079f:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a2:	8b 30                	mov    (%eax),%esi
  8007a4:	8b 78 04             	mov    0x4(%eax),%edi
  8007a7:	eb 26                	jmp    8007cf <vprintfmt+0x2c5>
	else if (lflag)
  8007a9:	85 c9                	test   %ecx,%ecx
  8007ab:	74 12                	je     8007bf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 50 04             	lea    0x4(%eax),%edx
  8007b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b6:	8b 30                	mov    (%eax),%esi
  8007b8:	89 f7                	mov    %esi,%edi
  8007ba:	c1 ff 1f             	sar    $0x1f,%edi
  8007bd:	eb 10                	jmp    8007cf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 30                	mov    (%eax),%esi
  8007ca:	89 f7                	mov    %esi,%edi
  8007cc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007d4:	85 ff                	test   %edi,%edi
  8007d6:	0f 89 8c 00 00 00    	jns    800868 <vprintfmt+0x35e>
				putch('-', putdat);
  8007dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007e7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007ea:	f7 de                	neg    %esi
  8007ec:	83 d7 00             	adc    $0x0,%edi
  8007ef:	f7 df                	neg    %edi
			}
			base = 10;
  8007f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f6:	eb 70                	jmp    800868 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007f8:	89 ca                	mov    %ecx,%edx
  8007fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fd:	e8 89 fc ff ff       	call   80048b <getuint>
  800802:	89 c6                	mov    %eax,%esi
  800804:	89 d7                	mov    %edx,%edi
			base = 10;
  800806:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80080b:	eb 5b                	jmp    800868 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80080d:	89 ca                	mov    %ecx,%edx
  80080f:	8d 45 14             	lea    0x14(%ebp),%eax
  800812:	e8 74 fc ff ff       	call   80048b <getuint>
  800817:	89 c6                	mov    %eax,%esi
  800819:	89 d7                	mov    %edx,%edi
			base = 8;
  80081b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800820:	eb 46                	jmp    800868 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800826:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80082d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800830:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800834:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80083b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8d 50 04             	lea    0x4(%eax),%edx
  800844:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800847:	8b 30                	mov    (%eax),%esi
  800849:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80084e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800853:	eb 13                	jmp    800868 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800855:	89 ca                	mov    %ecx,%edx
  800857:	8d 45 14             	lea    0x14(%ebp),%eax
  80085a:	e8 2c fc ff ff       	call   80048b <getuint>
  80085f:	89 c6                	mov    %eax,%esi
  800861:	89 d7                	mov    %edx,%edi
			base = 16;
  800863:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800868:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80086c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800877:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087b:	89 34 24             	mov    %esi,(%esp)
  80087e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800882:	89 da                	mov    %ebx,%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	e8 24 fb ff ff       	call   8003b0 <printnum>
			break;
  80088c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80088f:	e9 99 fc ff ff       	jmp    80052d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800894:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800898:	89 14 24             	mov    %edx,(%esp)
  80089b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8008a1:	e9 87 fc ff ff       	jmp    80052d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008aa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008b1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008b8:	0f 84 6f fc ff ff    	je     80052d <vprintfmt+0x23>
  8008be:	83 ee 01             	sub    $0x1,%esi
  8008c1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008c5:	75 f7                	jne    8008be <vprintfmt+0x3b4>
  8008c7:	e9 61 fc ff ff       	jmp    80052d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8008cc:	83 c4 4c             	add    $0x4c,%esp
  8008cf:	5b                   	pop    %ebx
  8008d0:	5e                   	pop    %esi
  8008d1:	5f                   	pop    %edi
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	83 ec 28             	sub    $0x28,%esp
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f1:	85 c0                	test   %eax,%eax
  8008f3:	74 30                	je     800925 <vsnprintf+0x51>
  8008f5:	85 d2                	test   %edx,%edx
  8008f7:	7e 2c                	jle    800925 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800900:	8b 45 10             	mov    0x10(%ebp),%eax
  800903:	89 44 24 08          	mov    %eax,0x8(%esp)
  800907:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090e:	c7 04 24 c5 04 80 00 	movl   $0x8004c5,(%esp)
  800915:	e8 f0 fb ff ff       	call   80050a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800923:	eb 05                	jmp    80092a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800925:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800932:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800935:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	89 44 24 04          	mov    %eax,0x4(%esp)
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 04 24             	mov    %eax,(%esp)
  80094d:	e8 82 ff ff ff       	call   8008d4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    
	...

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	80 3a 00             	cmpb   $0x0,(%edx)
  80096e:	74 09                	je     800979 <strlen+0x19>
		n++;
  800970:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800973:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800977:	75 f7                	jne    800970 <strlen+0x10>
		n++;
	return n;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	b8 00 00 00 00       	mov    $0x0,%eax
  80098a:	85 c9                	test   %ecx,%ecx
  80098c:	74 1a                	je     8009a8 <strnlen+0x2d>
  80098e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800991:	74 15                	je     8009a8 <strnlen+0x2d>
  800993:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800998:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099a:	39 ca                	cmp    %ecx,%edx
  80099c:	74 0a                	je     8009a8 <strnlen+0x2d>
  80099e:	83 c2 01             	add    $0x1,%edx
  8009a1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8009a6:	75 f0                	jne    800998 <strnlen+0x1d>
		n++;
	return n;
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009be:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009c1:	83 c2 01             	add    $0x1,%edx
  8009c4:	84 c9                	test   %cl,%cl
  8009c6:	75 f2                	jne    8009ba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d5:	89 1c 24             	mov    %ebx,(%esp)
  8009d8:	e8 83 ff ff ff       	call   800960 <strlen>
	strcpy(dst + len, src);
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	89 04 24             	mov    %eax,(%esp)
  8009e9:	e8 bd ff ff ff       	call   8009ab <strcpy>
	return dst;
}
  8009ee:	89 d8                	mov    %ebx,%eax
  8009f0:	83 c4 08             	add    $0x8,%esp
  8009f3:	5b                   	pop    %ebx
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a04:	85 f6                	test   %esi,%esi
  800a06:	74 18                	je     800a20 <strncpy+0x2a>
  800a08:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a0d:	0f b6 1a             	movzbl (%edx),%ebx
  800a10:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a13:	80 3a 01             	cmpb   $0x1,(%edx)
  800a16:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	39 f1                	cmp    %esi,%ecx
  800a1e:	75 ed                	jne    800a0d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a20:	5b                   	pop    %ebx
  800a21:	5e                   	pop    %esi
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	57                   	push   %edi
  800a28:	56                   	push   %esi
  800a29:	53                   	push   %ebx
  800a2a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a30:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a33:	89 f8                	mov    %edi,%eax
  800a35:	85 f6                	test   %esi,%esi
  800a37:	74 2b                	je     800a64 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800a39:	83 fe 01             	cmp    $0x1,%esi
  800a3c:	74 23                	je     800a61 <strlcpy+0x3d>
  800a3e:	0f b6 0b             	movzbl (%ebx),%ecx
  800a41:	84 c9                	test   %cl,%cl
  800a43:	74 1c                	je     800a61 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800a45:	83 ee 02             	sub    $0x2,%esi
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a4d:	88 08                	mov    %cl,(%eax)
  800a4f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a52:	39 f2                	cmp    %esi,%edx
  800a54:	74 0b                	je     800a61 <strlcpy+0x3d>
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5d:	84 c9                	test   %cl,%cl
  800a5f:	75 ec                	jne    800a4d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800a61:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a64:	29 f8                	sub    %edi,%eax
}
  800a66:	5b                   	pop    %ebx
  800a67:	5e                   	pop    %esi
  800a68:	5f                   	pop    %edi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a71:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a74:	0f b6 01             	movzbl (%ecx),%eax
  800a77:	84 c0                	test   %al,%al
  800a79:	74 16                	je     800a91 <strcmp+0x26>
  800a7b:	3a 02                	cmp    (%edx),%al
  800a7d:	75 12                	jne    800a91 <strcmp+0x26>
		p++, q++;
  800a7f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a82:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800a86:	84 c0                	test   %al,%al
  800a88:	74 07                	je     800a91 <strcmp+0x26>
  800a8a:	83 c1 01             	add    $0x1,%ecx
  800a8d:	3a 02                	cmp    (%edx),%al
  800a8f:	74 ee                	je     800a7f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a91:	0f b6 c0             	movzbl %al,%eax
  800a94:	0f b6 12             	movzbl (%edx),%edx
  800a97:	29 d0                	sub    %edx,%eax
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	53                   	push   %ebx
  800a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aa5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800aad:	85 d2                	test   %edx,%edx
  800aaf:	74 28                	je     800ad9 <strncmp+0x3e>
  800ab1:	0f b6 01             	movzbl (%ecx),%eax
  800ab4:	84 c0                	test   %al,%al
  800ab6:	74 24                	je     800adc <strncmp+0x41>
  800ab8:	3a 03                	cmp    (%ebx),%al
  800aba:	75 20                	jne    800adc <strncmp+0x41>
  800abc:	83 ea 01             	sub    $0x1,%edx
  800abf:	74 13                	je     800ad4 <strncmp+0x39>
		n--, p++, q++;
  800ac1:	83 c1 01             	add    $0x1,%ecx
  800ac4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ac7:	0f b6 01             	movzbl (%ecx),%eax
  800aca:	84 c0                	test   %al,%al
  800acc:	74 0e                	je     800adc <strncmp+0x41>
  800ace:	3a 03                	cmp    (%ebx),%al
  800ad0:	74 ea                	je     800abc <strncmp+0x21>
  800ad2:	eb 08                	jmp    800adc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ad9:	5b                   	pop    %ebx
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800adc:	0f b6 01             	movzbl (%ecx),%eax
  800adf:	0f b6 13             	movzbl (%ebx),%edx
  800ae2:	29 d0                	sub    %edx,%eax
  800ae4:	eb f3                	jmp    800ad9 <strncmp+0x3e>

00800ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af0:	0f b6 10             	movzbl (%eax),%edx
  800af3:	84 d2                	test   %dl,%dl
  800af5:	74 1c                	je     800b13 <strchr+0x2d>
		if (*s == c)
  800af7:	38 ca                	cmp    %cl,%dl
  800af9:	75 09                	jne    800b04 <strchr+0x1e>
  800afb:	eb 1b                	jmp    800b18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800afd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800b00:	38 ca                	cmp    %cl,%dl
  800b02:	74 14                	je     800b18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b04:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	75 f1                	jne    800afd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	eb 05                	jmp    800b18 <strchr+0x32>
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b24:	0f b6 10             	movzbl (%eax),%edx
  800b27:	84 d2                	test   %dl,%dl
  800b29:	74 14                	je     800b3f <strfind+0x25>
		if (*s == c)
  800b2b:	38 ca                	cmp    %cl,%dl
  800b2d:	75 06                	jne    800b35 <strfind+0x1b>
  800b2f:	eb 0e                	jmp    800b3f <strfind+0x25>
  800b31:	38 ca                	cmp    %cl,%dl
  800b33:	74 0a                	je     800b3f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	0f b6 10             	movzbl (%eax),%edx
  800b3b:	84 d2                	test   %dl,%dl
  800b3d:	75 f2                	jne    800b31 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b4a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b4d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b50:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b59:	85 c9                	test   %ecx,%ecx
  800b5b:	74 30                	je     800b8d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b5d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b63:	75 25                	jne    800b8a <memset+0x49>
  800b65:	f6 c1 03             	test   $0x3,%cl
  800b68:	75 20                	jne    800b8a <memset+0x49>
		c &= 0xFF;
  800b6a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b6d:	89 d3                	mov    %edx,%ebx
  800b6f:	c1 e3 08             	shl    $0x8,%ebx
  800b72:	89 d6                	mov    %edx,%esi
  800b74:	c1 e6 18             	shl    $0x18,%esi
  800b77:	89 d0                	mov    %edx,%eax
  800b79:	c1 e0 10             	shl    $0x10,%eax
  800b7c:	09 f0                	or     %esi,%eax
  800b7e:	09 d0                	or     %edx,%eax
  800b80:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b82:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b85:	fc                   	cld    
  800b86:	f3 ab                	rep stos %eax,%es:(%edi)
  800b88:	eb 03                	jmp    800b8d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b8a:	fc                   	cld    
  800b8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8d:	89 f8                	mov    %edi,%eax
  800b8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b98:	89 ec                	mov    %ebp,%esp
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ba5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb1:	39 c6                	cmp    %eax,%esi
  800bb3:	73 36                	jae    800beb <memmove+0x4f>
  800bb5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb8:	39 d0                	cmp    %edx,%eax
  800bba:	73 2f                	jae    800beb <memmove+0x4f>
		s += n;
		d += n;
  800bbc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbf:	f6 c2 03             	test   $0x3,%dl
  800bc2:	75 1b                	jne    800bdf <memmove+0x43>
  800bc4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bca:	75 13                	jne    800bdf <memmove+0x43>
  800bcc:	f6 c1 03             	test   $0x3,%cl
  800bcf:	75 0e                	jne    800bdf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bd1:	83 ef 04             	sub    $0x4,%edi
  800bd4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bda:	fd                   	std    
  800bdb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bdd:	eb 09                	jmp    800be8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdf:	83 ef 01             	sub    $0x1,%edi
  800be2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800be5:	fd                   	std    
  800be6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be8:	fc                   	cld    
  800be9:	eb 20                	jmp    800c0b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800beb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf1:	75 13                	jne    800c06 <memmove+0x6a>
  800bf3:	a8 03                	test   $0x3,%al
  800bf5:	75 0f                	jne    800c06 <memmove+0x6a>
  800bf7:	f6 c1 03             	test   $0x3,%cl
  800bfa:	75 0a                	jne    800c06 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bfc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bff:	89 c7                	mov    %eax,%edi
  800c01:	fc                   	cld    
  800c02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c04:	eb 05                	jmp    800c0b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c06:	89 c7                	mov    %eax,%edi
  800c08:	fc                   	cld    
  800c09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c11:	89 ec                	mov    %ebp,%esp
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	89 04 24             	mov    %eax,(%esp)
  800c2f:	e8 68 ff ff ff       	call   800b9c <memmove>
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c42:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c45:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4a:	85 ff                	test   %edi,%edi
  800c4c:	74 37                	je     800c85 <memcmp+0x4f>
		if (*s1 != *s2)
  800c4e:	0f b6 03             	movzbl (%ebx),%eax
  800c51:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c54:	83 ef 01             	sub    $0x1,%edi
  800c57:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c5c:	38 c8                	cmp    %cl,%al
  800c5e:	74 1c                	je     800c7c <memcmp+0x46>
  800c60:	eb 10                	jmp    800c72 <memcmp+0x3c>
  800c62:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c6e:	38 c8                	cmp    %cl,%al
  800c70:	74 0a                	je     800c7c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800c72:	0f b6 c0             	movzbl %al,%eax
  800c75:	0f b6 c9             	movzbl %cl,%ecx
  800c78:	29 c8                	sub    %ecx,%eax
  800c7a:	eb 09                	jmp    800c85 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7c:	39 fa                	cmp    %edi,%edx
  800c7e:	75 e2                	jne    800c62 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c90:	89 c2                	mov    %eax,%edx
  800c92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c95:	39 d0                	cmp    %edx,%eax
  800c97:	73 19                	jae    800cb2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c9d:	38 08                	cmp    %cl,(%eax)
  800c9f:	75 06                	jne    800ca7 <memfind+0x1d>
  800ca1:	eb 0f                	jmp    800cb2 <memfind+0x28>
  800ca3:	38 08                	cmp    %cl,(%eax)
  800ca5:	74 0b                	je     800cb2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca7:	83 c0 01             	add    $0x1,%eax
  800caa:	39 d0                	cmp    %edx,%eax
  800cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cb0:	75 f1                	jne    800ca3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc0:	0f b6 02             	movzbl (%edx),%eax
  800cc3:	3c 20                	cmp    $0x20,%al
  800cc5:	74 04                	je     800ccb <strtol+0x17>
  800cc7:	3c 09                	cmp    $0x9,%al
  800cc9:	75 0e                	jne    800cd9 <strtol+0x25>
		s++;
  800ccb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cce:	0f b6 02             	movzbl (%edx),%eax
  800cd1:	3c 20                	cmp    $0x20,%al
  800cd3:	74 f6                	je     800ccb <strtol+0x17>
  800cd5:	3c 09                	cmp    $0x9,%al
  800cd7:	74 f2                	je     800ccb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd9:	3c 2b                	cmp    $0x2b,%al
  800cdb:	75 0a                	jne    800ce7 <strtol+0x33>
		s++;
  800cdd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce5:	eb 10                	jmp    800cf7 <strtol+0x43>
  800ce7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cec:	3c 2d                	cmp    $0x2d,%al
  800cee:	75 07                	jne    800cf7 <strtol+0x43>
		s++, neg = 1;
  800cf0:	83 c2 01             	add    $0x1,%edx
  800cf3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf7:	85 db                	test   %ebx,%ebx
  800cf9:	0f 94 c0             	sete   %al
  800cfc:	74 05                	je     800d03 <strtol+0x4f>
  800cfe:	83 fb 10             	cmp    $0x10,%ebx
  800d01:	75 15                	jne    800d18 <strtol+0x64>
  800d03:	80 3a 30             	cmpb   $0x30,(%edx)
  800d06:	75 10                	jne    800d18 <strtol+0x64>
  800d08:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d0c:	75 0a                	jne    800d18 <strtol+0x64>
		s += 2, base = 16;
  800d0e:	83 c2 02             	add    $0x2,%edx
  800d11:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d16:	eb 13                	jmp    800d2b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 0f                	je     800d2b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d1c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d21:	80 3a 30             	cmpb   $0x30,(%edx)
  800d24:	75 05                	jne    800d2b <strtol+0x77>
		s++, base = 8;
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d32:	0f b6 0a             	movzbl (%edx),%ecx
  800d35:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d38:	80 fb 09             	cmp    $0x9,%bl
  800d3b:	77 08                	ja     800d45 <strtol+0x91>
			dig = *s - '0';
  800d3d:	0f be c9             	movsbl %cl,%ecx
  800d40:	83 e9 30             	sub    $0x30,%ecx
  800d43:	eb 1e                	jmp    800d63 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800d45:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800d48:	80 fb 19             	cmp    $0x19,%bl
  800d4b:	77 08                	ja     800d55 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800d4d:	0f be c9             	movsbl %cl,%ecx
  800d50:	83 e9 57             	sub    $0x57,%ecx
  800d53:	eb 0e                	jmp    800d63 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d55:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d58:	80 fb 19             	cmp    $0x19,%bl
  800d5b:	77 14                	ja     800d71 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d5d:	0f be c9             	movsbl %cl,%ecx
  800d60:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d63:	39 f1                	cmp    %esi,%ecx
  800d65:	7d 0e                	jge    800d75 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d67:	83 c2 01             	add    $0x1,%edx
  800d6a:	0f af c6             	imul   %esi,%eax
  800d6d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800d6f:	eb c1                	jmp    800d32 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d71:	89 c1                	mov    %eax,%ecx
  800d73:	eb 02                	jmp    800d77 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d75:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7b:	74 05                	je     800d82 <strtol+0xce>
		*endptr = (char *) s;
  800d7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d80:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d82:	89 ca                	mov    %ecx,%edx
  800d84:	f7 da                	neg    %edx
  800d86:	85 ff                	test   %edi,%edi
  800d88:	0f 45 c2             	cmovne %edx,%eax
}
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	89 c3                	mov    %eax,%ebx
  800dac:	89 c7                	mov    %eax,%edi
  800dae:	89 c6                	mov    %eax,%esi
  800db0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800db2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dbb:	89 ec                	mov    %ebp,%esp
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dcb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800deb:	89 ec                	mov    %ebp,%esp
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 38             	sub    $0x38,%esp
  800df5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dfb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e03:	b8 03 00 00 00       	mov    $0x3,%eax
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	89 cb                	mov    %ecx,%ebx
  800e0d:	89 cf                	mov    %ecx,%edi
  800e0f:	89 ce                	mov    %ecx,%esi
  800e11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7e 28                	jle    800e3f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e22:	00 
  800e23:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  800e2a:	00 
  800e2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e32:	00 
  800e33:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  800e3a:	e8 51 f4 ff ff       	call   800290 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e48:	89 ec                	mov    %ebp,%esp
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 0c             	sub    $0xc,%esp
  800e52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	b8 02 00 00 00       	mov    $0x2,%eax
  800e65:	89 d1                	mov    %edx,%ecx
  800e67:	89 d3                	mov    %edx,%ebx
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	89 d6                	mov    %edx,%esi
  800e6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e78:	89 ec                	mov    %ebp,%esp
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_yield>:

void
sys_yield(void)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e90:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e95:	89 d1                	mov    %edx,%ecx
  800e97:	89 d3                	mov    %edx,%ebx
  800e99:	89 d7                	mov    %edx,%edi
  800e9b:	89 d6                	mov    %edx,%esi
  800e9d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea8:	89 ec                	mov    %ebp,%esp
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 38             	sub    $0x38,%esp
  800eb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebb:	be 00 00 00 00       	mov    $0x0,%esi
  800ec0:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	89 f7                	mov    %esi,%edi
  800ed0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7e 28                	jle    800efe <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eda:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  800ee9:	00 
  800eea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef1:	00 
  800ef2:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  800ef9:	e8 92 f3 ff ff       	call   800290 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800efe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f01:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f04:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f07:	89 ec                	mov    %ebp,%esp
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 38             	sub    $0x38,%esp
  800f11:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f14:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f17:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f1f:	8b 75 18             	mov    0x18(%ebp),%esi
  800f22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7e 28                	jle    800f5c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f38:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f3f:	00 
  800f40:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  800f47:	00 
  800f48:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4f:	00 
  800f50:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  800f57:	e8 34 f3 ff ff       	call   800290 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f5c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f62:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f65:	89 ec                	mov    %ebp,%esp
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	83 ec 38             	sub    $0x38,%esp
  800f6f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f75:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7e 28                	jle    800fba <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f96:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  800fa5:	00 
  800fa6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fad:	00 
  800fae:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  800fb5:	e8 d6 f2 ff ff       	call   800290 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fba:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fbd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc3:	89 ec                	mov    %ebp,%esp
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 38             	sub    $0x38,%esp
  800fcd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7e 28                	jle    801018 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801013:	e8 78 f2 ff ff       	call   800290 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801018:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80101b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801021:	89 ec                	mov    %ebp,%esp
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 38             	sub    $0x38,%esp
  80102b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801031:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	bb 00 00 00 00       	mov    $0x0,%ebx
  801039:	b8 09 00 00 00       	mov    $0x9,%eax
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	89 df                	mov    %ebx,%edi
  801046:	89 de                	mov    %ebx,%esi
  801048:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80104a:	85 c0                	test   %eax,%eax
  80104c:	7e 28                	jle    801076 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801052:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801059:	00 
  80105a:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  801061:	00 
  801062:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801069:	00 
  80106a:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801071:	e8 1a f2 ff ff       	call   800290 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801076:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801079:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107f:	89 ec                	mov    %ebp,%esp
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 38             	sub    $0x38,%esp
  801089:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801092:	bb 00 00 00 00       	mov    $0x0,%ebx
  801097:	b8 0a 00 00 00       	mov    $0xa,%eax
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	89 df                	mov    %ebx,%edi
  8010a4:	89 de                	mov    %ebx,%esi
  8010a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	7e 28                	jle    8010d4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010b7:	00 
  8010b8:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  8010bf:	00 
  8010c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c7:	00 
  8010c8:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  8010cf:	e8 bc f1 ff ff       	call   800290 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010dd:	89 ec                	mov    %ebp,%esp
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ed:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f0:	be 00 00 00 00       	mov    $0x0,%esi
  8010f5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010fa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801108:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801111:	89 ec                	mov    %ebp,%esp
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 38             	sub    $0x38,%esp
  80111b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801121:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801124:	b9 00 00 00 00       	mov    $0x0,%ecx
  801129:	b8 0d 00 00 00       	mov    $0xd,%eax
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	89 cb                	mov    %ecx,%ebx
  801133:	89 cf                	mov    %ecx,%edi
  801135:	89 ce                	mov    %ecx,%esi
  801137:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801139:	85 c0                	test   %eax,%eax
  80113b:	7e 28                	jle    801165 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801141:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801148:	00 
  801149:	c7 44 24 08 df 2b 80 	movl   $0x802bdf,0x8(%esp)
  801150:	00 
  801151:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801158:	00 
  801159:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801160:	e8 2b f1 ff ff       	call   800290 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801165:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801168:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80116b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116e:	89 ec                	mov    %ebp,%esp
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
	...

00801174 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	53                   	push   %ebx
  801178:	83 ec 24             	sub    $0x24,%esp
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80117e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801180:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801184:	74 21                	je     8011a7 <pgfault+0x33>
  801186:	89 d8                	mov    %ebx,%eax
  801188:	c1 e8 16             	shr    $0x16,%eax
  80118b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801192:	a8 01                	test   $0x1,%al
  801194:	74 11                	je     8011a7 <pgfault+0x33>
  801196:	89 d8                	mov    %ebx,%eax
  801198:	c1 e8 0c             	shr    $0xc,%eax
  80119b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011a2:	f6 c4 08             	test   $0x8,%ah
  8011a5:	75 1c                	jne    8011c3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  8011a7:	c7 44 24 08 0c 2c 80 	movl   $0x802c0c,0x8(%esp)
  8011ae:	00 
  8011af:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8011b6:	00 
  8011b7:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8011be:	e8 cd f0 ff ff       	call   800290 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8011c3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011ca:	00 
  8011cb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d2:	00 
  8011d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011da:	e8 cd fc ff ff       	call   800eac <sys_page_alloc>
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	79 20                	jns    801203 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8011e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e7:	c7 44 24 08 48 2c 80 	movl   $0x802c48,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8011fe:	e8 8d f0 ff ff       	call   800290 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801203:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801209:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801210:	00 
  801211:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801215:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80121c:	e8 7b f9 ff ff       	call   800b9c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801221:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801228:	00 
  801229:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80122d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801244:	e8 c2 fc ff ff       	call   800f0b <sys_page_map>
  801249:	85 c0                	test   %eax,%eax
  80124b:	79 20                	jns    80126d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80124d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801251:	c7 44 24 08 70 2c 80 	movl   $0x802c70,0x8(%esp)
  801258:	00 
  801259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801260:	00 
  801261:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  801268:	e8 23 f0 ff ff       	call   800290 <_panic>
	//panic("pgfault not implemented");
}
  80126d:	83 c4 24             	add    $0x24,%esp
  801270:	5b                   	pop    %ebx
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	57                   	push   %edi
  801277:	56                   	push   %esi
  801278:	53                   	push   %ebx
  801279:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80127c:	c7 04 24 74 11 80 00 	movl   $0x801174,(%esp)
  801283:	e8 d8 11 00 00       	call   802460 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801288:	ba 07 00 00 00       	mov    $0x7,%edx
  80128d:	89 d0                	mov    %edx,%eax
  80128f:	cd 30                	int    $0x30
  801291:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801294:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801296:	85 c0                	test   %eax,%eax
  801298:	79 20                	jns    8012ba <fork+0x47>
		panic("sys_exofork: %e", envid);
  80129a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129e:	c7 44 24 08 6e 2d 80 	movl   $0x802d6e,0x8(%esp)
  8012a5:	00 
  8012a6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  8012ad:	00 
  8012ae:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8012b5:	e8 d6 ef ff ff       	call   800290 <_panic>
	if (envid == 0) {
  8012ba:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8012bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012c3:	75 1c                	jne    8012e1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012c5:	e8 82 fb ff ff       	call   800e4c <sys_getenvid>
  8012ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012cf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012d7:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8012dc:	e9 06 02 00 00       	jmp    8014e7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8012e1:	89 d8                	mov    %ebx,%eax
  8012e3:	c1 e8 16             	shr    $0x16,%eax
  8012e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ed:	a8 01                	test   $0x1,%al
  8012ef:	0f 84 57 01 00 00    	je     80144c <fork+0x1d9>
  8012f5:	89 de                	mov    %ebx,%esi
  8012f7:	c1 ee 0c             	shr    $0xc,%esi
  8012fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801301:	a8 01                	test   $0x1,%al
  801303:	0f 84 43 01 00 00    	je     80144c <fork+0x1d9>
  801309:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801310:	a8 04                	test   $0x4,%al
  801312:	0f 84 34 01 00 00    	je     80144c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801318:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80131b:	89 f0                	mov    %esi,%eax
  80131d:	c1 e8 0c             	shr    $0xc,%eax
  801320:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801327:	f6 c4 04             	test   $0x4,%ah
  80132a:	74 45                	je     801371 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80132c:	25 07 0e 00 00       	and    $0xe07,%eax
  801331:	89 44 24 10          	mov    %eax,0x10(%esp)
  801335:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801339:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80133d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801341:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801348:	e8 be fb ff ff       	call   800f0b <sys_page_map>
  80134d:	85 c0                	test   %eax,%eax
  80134f:	0f 89 f7 00 00 00    	jns    80144c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801355:	c7 44 24 08 7e 2d 80 	movl   $0x802d7e,0x8(%esp)
  80135c:	00 
  80135d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801364:	00 
  801365:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  80136c:	e8 1f ef ff ff       	call   800290 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801371:	a9 02 08 00 00       	test   $0x802,%eax
  801376:	0f 84 8c 00 00 00    	je     801408 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80137c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801383:	00 
  801384:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801388:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80138c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801397:	e8 6f fb ff ff       	call   800f0b <sys_page_map>
  80139c:	85 c0                	test   %eax,%eax
  80139e:	79 20                	jns    8013c0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  8013a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a4:	c7 44 24 08 94 2c 80 	movl   $0x802c94,0x8(%esp)
  8013ab:	00 
  8013ac:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8013b3:	00 
  8013b4:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8013bb:	e8 d0 ee ff ff       	call   800290 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8013c0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013c7:	00 
  8013c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d3:	00 
  8013d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013df:	e8 27 fb ff ff       	call   800f0b <sys_page_map>
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	79 64                	jns    80144c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8013e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ec:	c7 44 24 08 c0 2c 80 	movl   $0x802cc0,0x8(%esp)
  8013f3:	00 
  8013f4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8013fb:	00 
  8013fc:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  801403:	e8 88 ee ff ff       	call   800290 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801408:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80140f:	00 
  801410:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801414:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801418:	89 74 24 04          	mov    %esi,0x4(%esp)
  80141c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801423:	e8 e3 fa ff ff       	call   800f0b <sys_page_map>
  801428:	85 c0                	test   %eax,%eax
  80142a:	79 20                	jns    80144c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80142c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801430:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  801437:	00 
  801438:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80143f:	00 
  801440:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  801447:	e8 44 ee ff ff       	call   800290 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80144c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801452:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801458:	0f 85 83 fe ff ff    	jne    8012e1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80145e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801465:	00 
  801466:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80146d:	ee 
  80146e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801471:	89 04 24             	mov    %eax,(%esp)
  801474:	e8 33 fa ff ff       	call   800eac <sys_page_alloc>
  801479:	85 c0                	test   %eax,%eax
  80147b:	79 20                	jns    80149d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80147d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801481:	c7 44 24 08 18 2d 80 	movl   $0x802d18,0x8(%esp)
  801488:	00 
  801489:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801490:	00 
  801491:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  801498:	e8 f3 ed ff ff       	call   800290 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80149d:	c7 44 24 04 d0 24 80 	movl   $0x8024d0,0x4(%esp)
  8014a4:	00 
  8014a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a8:	89 04 24             	mov    %eax,(%esp)
  8014ab:	e8 d3 fb ff ff       	call   801083 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014b0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014b7:	00 
  8014b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bb:	89 04 24             	mov    %eax,(%esp)
  8014be:	e8 04 fb ff ff       	call   800fc7 <sys_env_set_status>
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	79 20                	jns    8014e7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8014c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014cb:	c7 44 24 08 3c 2d 80 	movl   $0x802d3c,0x8(%esp)
  8014d2:	00 
  8014d3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8014da:	00 
  8014db:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8014e2:	e8 a9 ed ff ff       	call   800290 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8014e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ea:	83 c4 3c             	add    $0x3c,%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5f                   	pop    %edi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    

008014f2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014f8:	c7 44 24 08 95 2d 80 	movl   $0x802d95,0x8(%esp)
  8014ff:	00 
  801500:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801507:	00 
  801508:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  80150f:	e8 7c ed ff ff       	call   800290 <_panic>
	...

00801520 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	83 ec 10             	sub    $0x10,%esp
  801528:	8b 75 08             	mov    0x8(%ebp),%esi
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801531:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801533:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801538:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 d2 fb ff ff       	call   801115 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801543:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801548:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 0e                	js     80155f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801551:	a1 04 40 80 00       	mov    0x804004,%eax
  801556:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801559:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80155c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80155f:	85 f6                	test   %esi,%esi
  801561:	74 02                	je     801565 <ipc_recv+0x45>
		*from_env_store = sender;
  801563:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801565:	85 db                	test   %ebx,%ebx
  801567:	74 02                	je     80156b <ipc_recv+0x4b>
		*perm_store = perm;
  801569:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	5b                   	pop    %ebx
  80156f:	5e                   	pop    %esi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	57                   	push   %edi
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
  801578:	83 ec 1c             	sub    $0x1c,%esp
  80157b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80157e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801581:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801584:	85 db                	test   %ebx,%ebx
  801586:	75 04                	jne    80158c <ipc_send+0x1a>
  801588:	85 f6                	test   %esi,%esi
  80158a:	75 15                	jne    8015a1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80158c:	85 db                	test   %ebx,%ebx
  80158e:	74 16                	je     8015a6 <ipc_send+0x34>
  801590:	85 f6                	test   %esi,%esi
  801592:	0f 94 c0             	sete   %al
      pg = 0;
  801595:	84 c0                	test   %al,%al
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
  80159c:	0f 45 d8             	cmovne %eax,%ebx
  80159f:	eb 05                	jmp    8015a6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8015a1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8015a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015aa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	89 04 24             	mov    %eax,(%esp)
  8015b8:	e8 24 fb ff ff       	call   8010e1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8015bd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015c0:	75 07                	jne    8015c9 <ipc_send+0x57>
           sys_yield();
  8015c2:	e8 b5 f8 ff ff       	call   800e7c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8015c7:	eb dd                	jmp    8015a6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	90                   	nop
  8015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8015d0:	74 1c                	je     8015ee <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8015d2:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  8015d9:	00 
  8015da:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8015e1:	00 
  8015e2:	c7 04 24 b5 2d 80 00 	movl   $0x802db5,(%esp)
  8015e9:	e8 a2 ec ff ff       	call   800290 <_panic>
		}
    }
}
  8015ee:	83 c4 1c             	add    $0x1c,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5f                   	pop    %edi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8015fc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801601:	39 c8                	cmp    %ecx,%eax
  801603:	74 17                	je     80161c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801605:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80160a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80160d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801613:	8b 52 50             	mov    0x50(%edx),%edx
  801616:	39 ca                	cmp    %ecx,%edx
  801618:	75 14                	jne    80162e <ipc_find_env+0x38>
  80161a:	eb 05                	jmp    801621 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801621:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801624:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801629:	8b 40 40             	mov    0x40(%eax),%eax
  80162c:	eb 0e                	jmp    80163c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80162e:	83 c0 01             	add    $0x1,%eax
  801631:	3d 00 04 00 00       	cmp    $0x400,%eax
  801636:	75 d2                	jne    80160a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801638:	66 b8 00 00          	mov    $0x0,%ax
}
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    
	...

00801640 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	05 00 00 00 30       	add    $0x30000000,%eax
  80164b:	c1 e8 0c             	shr    $0xc,%eax
}
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	89 04 24             	mov    %eax,(%esp)
  80165c:	e8 df ff ff ff       	call   801640 <fd2num>
  801661:	05 20 00 0d 00       	add    $0xd0020,%eax
  801666:	c1 e0 0c             	shl    $0xc,%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	53                   	push   %ebx
  80166f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801672:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801677:	a8 01                	test   $0x1,%al
  801679:	74 34                	je     8016af <fd_alloc+0x44>
  80167b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801680:	a8 01                	test   $0x1,%al
  801682:	74 32                	je     8016b6 <fd_alloc+0x4b>
  801684:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801689:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	c1 ea 16             	shr    $0x16,%edx
  801690:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801697:	f6 c2 01             	test   $0x1,%dl
  80169a:	74 1f                	je     8016bb <fd_alloc+0x50>
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	c1 ea 0c             	shr    $0xc,%edx
  8016a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016a8:	f6 c2 01             	test   $0x1,%dl
  8016ab:	75 17                	jne    8016c4 <fd_alloc+0x59>
  8016ad:	eb 0c                	jmp    8016bb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8016af:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8016b4:	eb 05                	jmp    8016bb <fd_alloc+0x50>
  8016b6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8016bb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8016bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c2:	eb 17                	jmp    8016db <fd_alloc+0x70>
  8016c4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016c9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016ce:	75 b9                	jne    801689 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8016d6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016db:	5b                   	pop    %ebx
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016e9:	83 fa 1f             	cmp    $0x1f,%edx
  8016ec:	77 3f                	ja     80172d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016ee:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8016f4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016f7:	89 d0                	mov    %edx,%eax
  8016f9:	c1 e8 16             	shr    $0x16,%eax
  8016fc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801703:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801708:	f6 c1 01             	test   $0x1,%cl
  80170b:	74 20                	je     80172d <fd_lookup+0x4f>
  80170d:	89 d0                	mov    %edx,%eax
  80170f:	c1 e8 0c             	shr    $0xc,%eax
  801712:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801719:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80171e:	f6 c1 01             	test   $0x1,%cl
  801721:	74 0a                	je     80172d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	89 10                	mov    %edx,(%eax)
	return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172d:	5d                   	pop    %ebp
  80172e:	c3                   	ret    

0080172f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	53                   	push   %ebx
  801733:	83 ec 14             	sub    $0x14,%esp
  801736:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801739:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801741:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801747:	75 17                	jne    801760 <dev_lookup+0x31>
  801749:	eb 07                	jmp    801752 <dev_lookup+0x23>
  80174b:	39 0a                	cmp    %ecx,(%edx)
  80174d:	75 11                	jne    801760 <dev_lookup+0x31>
  80174f:	90                   	nop
  801750:	eb 05                	jmp    801757 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801752:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801757:	89 13                	mov    %edx,(%ebx)
			return 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
  80175e:	eb 35                	jmp    801795 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801760:	83 c0 01             	add    $0x1,%eax
  801763:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  80176a:	85 d2                	test   %edx,%edx
  80176c:	75 dd                	jne    80174b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80176e:	a1 04 40 80 00       	mov    0x804004,%eax
  801773:	8b 40 48             	mov    0x48(%eax),%eax
  801776:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80177a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177e:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  801785:	e8 01 ec ff ff       	call   80038b <cprintf>
	*dev = 0;
  80178a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801790:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801795:	83 c4 14             	add    $0x14,%esp
  801798:	5b                   	pop    %ebx
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 38             	sub    $0x38,%esp
  8017a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017ad:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017b1:	89 3c 24             	mov    %edi,(%esp)
  8017b4:	e8 87 fe ff ff       	call   801640 <fd2num>
  8017b9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8017bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017c0:	89 04 24             	mov    %eax,(%esp)
  8017c3:	e8 16 ff ff ff       	call   8016de <fd_lookup>
  8017c8:	89 c3                	mov    %eax,%ebx
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 05                	js     8017d3 <fd_close+0x38>
	    || fd != fd2)
  8017ce:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8017d1:	74 0e                	je     8017e1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017d3:	89 f0                	mov    %esi,%eax
  8017d5:	84 c0                	test   %al,%al
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dc:	0f 44 d8             	cmove  %eax,%ebx
  8017df:	eb 3d                	jmp    80181e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e8:	8b 07                	mov    (%edi),%eax
  8017ea:	89 04 24             	mov    %eax,(%esp)
  8017ed:	e8 3d ff ff ff       	call   80172f <dev_lookup>
  8017f2:	89 c3                	mov    %eax,%ebx
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 16                	js     80180e <fd_close+0x73>
		if (dev->dev_close)
  8017f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8017fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801803:	85 c0                	test   %eax,%eax
  801805:	74 07                	je     80180e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801807:	89 3c 24             	mov    %edi,(%esp)
  80180a:	ff d0                	call   *%eax
  80180c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80180e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801812:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801819:	e8 4b f7 ff ff       	call   800f69 <sys_page_unmap>
	return r;
}
  80181e:	89 d8                	mov    %ebx,%eax
  801820:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801823:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801826:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801829:	89 ec                	mov    %ebp,%esp
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    

0080182d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801836:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	89 04 24             	mov    %eax,(%esp)
  801840:	e8 99 fe ff ff       	call   8016de <fd_lookup>
  801845:	85 c0                	test   %eax,%eax
  801847:	78 13                	js     80185c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801849:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801850:	00 
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 3f ff ff ff       	call   80179b <fd_close>
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <close_all>:

void
close_all(void)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801865:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80186a:	89 1c 24             	mov    %ebx,(%esp)
  80186d:	e8 bb ff ff ff       	call   80182d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801872:	83 c3 01             	add    $0x1,%ebx
  801875:	83 fb 20             	cmp    $0x20,%ebx
  801878:	75 f0                	jne    80186a <close_all+0xc>
		close(i);
}
  80187a:	83 c4 14             	add    $0x14,%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 58             	sub    $0x58,%esp
  801886:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801889:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80188c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80188f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801892:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801895:	89 44 24 04          	mov    %eax,0x4(%esp)
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 04 24             	mov    %eax,(%esp)
  80189f:	e8 3a fe ff ff       	call   8016de <fd_lookup>
  8018a4:	89 c3                	mov    %eax,%ebx
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	0f 88 e1 00 00 00    	js     80198f <dup+0x10f>
		return r;
	close(newfdnum);
  8018ae:	89 3c 24             	mov    %edi,(%esp)
  8018b1:	e8 77 ff ff ff       	call   80182d <close>

	newfd = INDEX2FD(newfdnum);
  8018b6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8018bc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8018bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 86 fd ff ff       	call   801650 <fd2data>
  8018ca:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018cc:	89 34 24             	mov    %esi,(%esp)
  8018cf:	e8 7c fd ff ff       	call   801650 <fd2data>
  8018d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018d7:	89 d8                	mov    %ebx,%eax
  8018d9:	c1 e8 16             	shr    $0x16,%eax
  8018dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018e3:	a8 01                	test   $0x1,%al
  8018e5:	74 46                	je     80192d <dup+0xad>
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	c1 e8 0c             	shr    $0xc,%eax
  8018ec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018f3:	f6 c2 01             	test   $0x1,%dl
  8018f6:	74 35                	je     80192d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ff:	25 07 0e 00 00       	and    $0xe07,%eax
  801904:	89 44 24 10          	mov    %eax,0x10(%esp)
  801908:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80190b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80190f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801916:	00 
  801917:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801922:	e8 e4 f5 ff ff       	call   800f0b <sys_page_map>
  801927:	89 c3                	mov    %eax,%ebx
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 3b                	js     801968 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80192d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801930:	89 c2                	mov    %eax,%edx
  801932:	c1 ea 0c             	shr    $0xc,%edx
  801935:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80193c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801942:	89 54 24 10          	mov    %edx,0x10(%esp)
  801946:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80194a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801951:	00 
  801952:	89 44 24 04          	mov    %eax,0x4(%esp)
  801956:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80195d:	e8 a9 f5 ff ff       	call   800f0b <sys_page_map>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	85 c0                	test   %eax,%eax
  801966:	79 25                	jns    80198d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801968:	89 74 24 04          	mov    %esi,0x4(%esp)
  80196c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801973:	e8 f1 f5 ff ff       	call   800f69 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80197b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801986:	e8 de f5 ff ff       	call   800f69 <sys_page_unmap>
	return r;
  80198b:	eb 02                	jmp    80198f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80198d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801994:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801997:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80199a:	89 ec                	mov    %ebp,%esp
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 24             	sub    $0x24,%esp
  8019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	89 1c 24             	mov    %ebx,(%esp)
  8019b2:	e8 27 fd ff ff       	call   8016de <fd_lookup>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 6d                	js     801a28 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c5:	8b 00                	mov    (%eax),%eax
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	e8 60 fd ff ff       	call   80172f <dev_lookup>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 55                	js     801a28 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	8b 50 08             	mov    0x8(%eax),%edx
  8019d9:	83 e2 03             	and    $0x3,%edx
  8019dc:	83 fa 01             	cmp    $0x1,%edx
  8019df:	75 23                	jne    801a04 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e6:	8b 40 48             	mov    0x48(%eax),%eax
  8019e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f1:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  8019f8:	e8 8e e9 ff ff       	call   80038b <cprintf>
		return -E_INVAL;
  8019fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a02:	eb 24                	jmp    801a28 <read+0x8a>
	}
	if (!dev->dev_read)
  801a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a07:	8b 52 08             	mov    0x8(%edx),%edx
  801a0a:	85 d2                	test   %edx,%edx
  801a0c:	74 15                	je     801a23 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a11:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a18:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a1c:	89 04 24             	mov    %eax,(%esp)
  801a1f:	ff d2                	call   *%edx
  801a21:	eb 05                	jmp    801a28 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a23:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a28:	83 c4 24             	add    $0x24,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5d                   	pop    %ebp
  801a2d:	c3                   	ret    

00801a2e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	57                   	push   %edi
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 1c             	sub    $0x1c,%esp
  801a37:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a3a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a42:	85 f6                	test   %esi,%esi
  801a44:	74 30                	je     801a76 <readn+0x48>
  801a46:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	29 c2                	sub    %eax,%edx
  801a4f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a53:	03 45 0c             	add    0xc(%ebp),%eax
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	89 3c 24             	mov    %edi,(%esp)
  801a5d:	e8 3c ff ff ff       	call   80199e <read>
		if (m < 0)
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 10                	js     801a76 <readn+0x48>
			return m;
		if (m == 0)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	74 0a                	je     801a74 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a6a:	01 c3                	add    %eax,%ebx
  801a6c:	89 d8                	mov    %ebx,%eax
  801a6e:	39 f3                	cmp    %esi,%ebx
  801a70:	72 d9                	jb     801a4b <readn+0x1d>
  801a72:	eb 02                	jmp    801a76 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801a74:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801a76:	83 c4 1c             	add    $0x1c,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5f                   	pop    %edi
  801a7c:	5d                   	pop    %ebp
  801a7d:	c3                   	ret    

00801a7e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
  801a82:	83 ec 24             	sub    $0x24,%esp
  801a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a88:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8f:	89 1c 24             	mov    %ebx,(%esp)
  801a92:	e8 47 fc ff ff       	call   8016de <fd_lookup>
  801a97:	85 c0                	test   %eax,%eax
  801a99:	78 68                	js     801b03 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	89 04 24             	mov    %eax,(%esp)
  801aaa:	e8 80 fc ff ff       	call   80172f <dev_lookup>
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 50                	js     801b03 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aba:	75 23                	jne    801adf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801abc:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac1:	8b 40 48             	mov    0x48(%eax),%eax
  801ac4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acc:	c7 04 24 20 2e 80 00 	movl   $0x802e20,(%esp)
  801ad3:	e8 b3 e8 ff ff       	call   80038b <cprintf>
		return -E_INVAL;
  801ad8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801add:	eb 24                	jmp    801b03 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae2:	8b 52 0c             	mov    0xc(%edx),%edx
  801ae5:	85 d2                	test   %edx,%edx
  801ae7:	74 15                	je     801afe <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af7:	89 04 24             	mov    %eax,(%esp)
  801afa:	ff d2                	call   *%edx
  801afc:	eb 05                	jmp    801b03 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801afe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b03:	83 c4 24             	add    $0x24,%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    

00801b09 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b0f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	89 04 24             	mov    %eax,(%esp)
  801b1c:	e8 bd fb ff ff       	call   8016de <fd_lookup>
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 0e                	js     801b33 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	53                   	push   %ebx
  801b39:	83 ec 24             	sub    $0x24,%esp
  801b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b46:	89 1c 24             	mov    %ebx,(%esp)
  801b49:	e8 90 fb ff ff       	call   8016de <fd_lookup>
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 61                	js     801bb3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 c9 fb ff ff       	call   80172f <dev_lookup>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 49                	js     801bb3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b71:	75 23                	jne    801b96 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b73:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b78:	8b 40 48             	mov    0x48(%eax),%eax
  801b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b83:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  801b8a:	e8 fc e7 ff ff       	call   80038b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b94:	eb 1d                	jmp    801bb3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b99:	8b 52 18             	mov    0x18(%edx),%edx
  801b9c:	85 d2                	test   %edx,%edx
  801b9e:	74 0e                	je     801bae <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ba0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba7:	89 04 24             	mov    %eax,(%esp)
  801baa:	ff d2                	call   *%edx
  801bac:	eb 05                	jmp    801bb3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801bae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801bb3:	83 c4 24             	add    $0x24,%esp
  801bb6:	5b                   	pop    %ebx
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    

00801bb9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	53                   	push   %ebx
  801bbd:	83 ec 24             	sub    $0x24,%esp
  801bc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	89 04 24             	mov    %eax,(%esp)
  801bd0:	e8 09 fb ff ff       	call   8016de <fd_lookup>
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 52                	js     801c2b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be3:	8b 00                	mov    (%eax),%eax
  801be5:	89 04 24             	mov    %eax,(%esp)
  801be8:	e8 42 fb ff ff       	call   80172f <dev_lookup>
  801bed:	85 c0                	test   %eax,%eax
  801bef:	78 3a                	js     801c2b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bf8:	74 2c                	je     801c26 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bfa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bfd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c04:	00 00 00 
	stat->st_isdir = 0;
  801c07:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c0e:	00 00 00 
	stat->st_dev = dev;
  801c11:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c17:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1e:	89 14 24             	mov    %edx,(%esp)
  801c21:	ff 50 14             	call   *0x14(%eax)
  801c24:	eb 05                	jmp    801c2b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c2b:	83 c4 24             	add    $0x24,%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 18             	sub    $0x18,%esp
  801c37:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c3a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c44:	00 
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	89 04 24             	mov    %eax,(%esp)
  801c4b:	e8 bc 01 00 00       	call   801e0c <open>
  801c50:	89 c3                	mov    %eax,%ebx
  801c52:	85 c0                	test   %eax,%eax
  801c54:	78 1b                	js     801c71 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5d:	89 1c 24             	mov    %ebx,(%esp)
  801c60:	e8 54 ff ff ff       	call   801bb9 <fstat>
  801c65:	89 c6                	mov    %eax,%esi
	close(fd);
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 be fb ff ff       	call   80182d <close>
	return r;
  801c6f:	89 f3                	mov    %esi,%ebx
}
  801c71:	89 d8                	mov    %ebx,%eax
  801c73:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c76:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c79:	89 ec                	mov    %ebp,%esp
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
  801c7d:	00 00                	add    %al,(%eax)
	...

00801c80 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
  801c86:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c89:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c8c:	89 c3                	mov    %eax,%ebx
  801c8e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801c90:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801c97:	75 11                	jne    801caa <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ca0:	e8 51 f9 ff ff       	call   8015f6 <ipc_find_env>
  801ca5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801caa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cb1:	00 
  801cb2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801cb9:	00 
  801cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cbe:	a1 00 40 80 00       	mov    0x804000,%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 a7 f8 ff ff       	call   801572 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ccb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cd2:	00 
  801cd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cde:	e8 3d f8 ff ff       	call   801520 <ipc_recv>
}
  801ce3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ce6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ce9:	89 ec                	mov    %ebp,%esp
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    

00801ced <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 14             	sub    $0x14,%esp
  801cf4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0c:	e8 6f ff ff ff       	call   801c80 <fsipc>
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 2b                	js     801d40 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d15:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d1c:	00 
  801d1d:	89 1c 24             	mov    %ebx,(%esp)
  801d20:	e8 86 ec ff ff       	call   8009ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d25:	a1 80 50 80 00       	mov    0x805080,%eax
  801d2a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d30:	a1 84 50 80 00       	mov    0x805084,%eax
  801d35:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	83 c4 14             	add    $0x14,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    

00801d46 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d52:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801d57:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5c:	b8 06 00 00 00       	mov    $0x6,%eax
  801d61:	e8 1a ff ff ff       	call   801c80 <fsipc>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 10             	sub    $0x10,%esp
  801d70:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	8b 40 0c             	mov    0xc(%eax),%eax
  801d79:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801d7e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d84:	ba 00 00 00 00       	mov    $0x0,%edx
  801d89:	b8 03 00 00 00       	mov    $0x3,%eax
  801d8e:	e8 ed fe ff ff       	call   801c80 <fsipc>
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 6a                	js     801e03 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d99:	39 c6                	cmp    %eax,%esi
  801d9b:	73 24                	jae    801dc1 <devfile_read+0x59>
  801d9d:	c7 44 24 0c 50 2e 80 	movl   $0x802e50,0xc(%esp)
  801da4:	00 
  801da5:	c7 44 24 08 57 2e 80 	movl   $0x802e57,0x8(%esp)
  801dac:	00 
  801dad:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801db4:	00 
  801db5:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  801dbc:	e8 cf e4 ff ff       	call   800290 <_panic>
	assert(r <= PGSIZE);
  801dc1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc6:	7e 24                	jle    801dec <devfile_read+0x84>
  801dc8:	c7 44 24 0c 77 2e 80 	movl   $0x802e77,0xc(%esp)
  801dcf:	00 
  801dd0:	c7 44 24 08 57 2e 80 	movl   $0x802e57,0x8(%esp)
  801dd7:	00 
  801dd8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801ddf:	00 
  801de0:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  801de7:	e8 a4 e4 ff ff       	call   800290 <_panic>
	memmove(buf, &fsipcbuf, r);
  801dec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801df7:	00 
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 99 ed ff ff       	call   800b9c <memmove>
	return r;
}
  801e03:	89 d8                	mov    %ebx,%eax
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	56                   	push   %esi
  801e10:	53                   	push   %ebx
  801e11:	83 ec 20             	sub    $0x20,%esp
  801e14:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e17:	89 34 24             	mov    %esi,(%esp)
  801e1a:	e8 41 eb ff ff       	call   800960 <strlen>
		return -E_BAD_PATH;
  801e1f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e24:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e29:	7f 5e                	jg     801e89 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2e:	89 04 24             	mov    %eax,(%esp)
  801e31:	e8 35 f8 ff ff       	call   80166b <fd_alloc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 4d                	js     801e89 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e40:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801e47:	e8 5f eb ff ff       	call   8009ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e57:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5c:	e8 1f fe ff ff       	call   801c80 <fsipc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	79 15                	jns    801e7c <open+0x70>
		fd_close(fd, 0);
  801e67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e6e:	00 
  801e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e72:	89 04 24             	mov    %eax,(%esp)
  801e75:	e8 21 f9 ff ff       	call   80179b <fd_close>
		return r;
  801e7a:	eb 0d                	jmp    801e89 <open+0x7d>
	}

	return fd2num(fd);
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	e8 b9 f7 ff ff       	call   801640 <fd2num>
  801e87:	89 c3                	mov    %eax,%ebx
}
  801e89:	89 d8                	mov    %ebx,%eax
  801e8b:	83 c4 20             	add    $0x20,%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    
	...

00801e94 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e9a:	89 d0                	mov    %edx,%eax
  801e9c:	c1 e8 16             	shr    $0x16,%eax
  801e9f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ea6:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eab:	f6 c1 01             	test   $0x1,%cl
  801eae:	74 1d                	je     801ecd <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801eb0:	c1 ea 0c             	shr    $0xc,%edx
  801eb3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801eba:	f6 c2 01             	test   $0x1,%dl
  801ebd:	74 0e                	je     801ecd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ebf:	c1 ea 0c             	shr    $0xc,%edx
  801ec2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ec9:	ef 
  801eca:	0f b7 c0             	movzwl %ax,%eax
}
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    
	...

00801ed0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
  801ed6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ed9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801edc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	89 04 24             	mov    %eax,(%esp)
  801ee5:	e8 66 f7 ff ff       	call   801650 <fd2data>
  801eea:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801eec:	c7 44 24 04 83 2e 80 	movl   $0x802e83,0x4(%esp)
  801ef3:	00 
  801ef4:	89 34 24             	mov    %esi,(%esp)
  801ef7:	e8 af ea ff ff       	call   8009ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801efc:	8b 43 04             	mov    0x4(%ebx),%eax
  801eff:	2b 03                	sub    (%ebx),%eax
  801f01:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801f07:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801f0e:	00 00 00 
	stat->st_dev = &devpipe;
  801f11:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801f18:	30 80 00 
	return 0;
}
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f23:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f26:	89 ec                	mov    %ebp,%esp
  801f28:	5d                   	pop    %ebp
  801f29:	c3                   	ret    

00801f2a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 14             	sub    $0x14,%esp
  801f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f3f:	e8 25 f0 ff ff       	call   800f69 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f44:	89 1c 24             	mov    %ebx,(%esp)
  801f47:	e8 04 f7 ff ff       	call   801650 <fd2data>
  801f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f57:	e8 0d f0 ff ff       	call   800f69 <sys_page_unmap>
}
  801f5c:	83 c4 14             	add    $0x14,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    

00801f62 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 2c             	sub    $0x2c,%esp
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f70:	a1 04 40 80 00       	mov    0x804004,%eax
  801f75:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f78:	89 3c 24             	mov    %edi,(%esp)
  801f7b:	e8 14 ff ff ff       	call   801e94 <pageref>
  801f80:	89 c6                	mov    %eax,%esi
  801f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f85:	89 04 24             	mov    %eax,(%esp)
  801f88:	e8 07 ff ff ff       	call   801e94 <pageref>
  801f8d:	39 c6                	cmp    %eax,%esi
  801f8f:	0f 94 c0             	sete   %al
  801f92:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801f95:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f9e:	39 cb                	cmp    %ecx,%ebx
  801fa0:	75 08                	jne    801faa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801fa2:	83 c4 2c             	add    $0x2c,%esp
  801fa5:	5b                   	pop    %ebx
  801fa6:	5e                   	pop    %esi
  801fa7:	5f                   	pop    %edi
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801faa:	83 f8 01             	cmp    $0x1,%eax
  801fad:	75 c1                	jne    801f70 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801faf:	8b 52 58             	mov    0x58(%edx),%edx
  801fb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fbe:	c7 04 24 8a 2e 80 00 	movl   $0x802e8a,(%esp)
  801fc5:	e8 c1 e3 ff ff       	call   80038b <cprintf>
  801fca:	eb a4                	jmp    801f70 <_pipeisclosed+0xe>

00801fcc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	57                   	push   %edi
  801fd0:	56                   	push   %esi
  801fd1:	53                   	push   %ebx
  801fd2:	83 ec 2c             	sub    $0x2c,%esp
  801fd5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fd8:	89 34 24             	mov    %esi,(%esp)
  801fdb:	e8 70 f6 ff ff       	call   801650 <fd2data>
  801fe0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fe2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801feb:	75 50                	jne    80203d <devpipe_write+0x71>
  801fed:	eb 5c                	jmp    80204b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fef:	89 da                	mov    %ebx,%edx
  801ff1:	89 f0                	mov    %esi,%eax
  801ff3:	e8 6a ff ff ff       	call   801f62 <_pipeisclosed>
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	75 53                	jne    80204f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ffc:	e8 7b ee ff ff       	call   800e7c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802001:	8b 43 04             	mov    0x4(%ebx),%eax
  802004:	8b 13                	mov    (%ebx),%edx
  802006:	83 c2 20             	add    $0x20,%edx
  802009:	39 d0                	cmp    %edx,%eax
  80200b:	73 e2                	jae    801fef <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80200d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802010:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  802014:	88 55 e7             	mov    %dl,-0x19(%ebp)
  802017:	89 c2                	mov    %eax,%edx
  802019:	c1 fa 1f             	sar    $0x1f,%edx
  80201c:	c1 ea 1b             	shr    $0x1b,%edx
  80201f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802022:	83 e1 1f             	and    $0x1f,%ecx
  802025:	29 d1                	sub    %edx,%ecx
  802027:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80202b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80202f:	83 c0 01             	add    $0x1,%eax
  802032:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802035:	83 c7 01             	add    $0x1,%edi
  802038:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80203b:	74 0e                	je     80204b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80203d:	8b 43 04             	mov    0x4(%ebx),%eax
  802040:	8b 13                	mov    (%ebx),%edx
  802042:	83 c2 20             	add    $0x20,%edx
  802045:	39 d0                	cmp    %edx,%eax
  802047:	73 a6                	jae    801fef <devpipe_write+0x23>
  802049:	eb c2                	jmp    80200d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80204b:	89 f8                	mov    %edi,%eax
  80204d:	eb 05                	jmp    802054 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802054:	83 c4 2c             	add    $0x2c,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 28             	sub    $0x28,%esp
  802062:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802065:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802068:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80206b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80206e:	89 3c 24             	mov    %edi,(%esp)
  802071:	e8 da f5 ff ff       	call   801650 <fd2data>
  802076:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802078:	be 00 00 00 00       	mov    $0x0,%esi
  80207d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802081:	75 47                	jne    8020ca <devpipe_read+0x6e>
  802083:	eb 52                	jmp    8020d7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802085:	89 f0                	mov    %esi,%eax
  802087:	eb 5e                	jmp    8020e7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802089:	89 da                	mov    %ebx,%edx
  80208b:	89 f8                	mov    %edi,%eax
  80208d:	8d 76 00             	lea    0x0(%esi),%esi
  802090:	e8 cd fe ff ff       	call   801f62 <_pipeisclosed>
  802095:	85 c0                	test   %eax,%eax
  802097:	75 49                	jne    8020e2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802099:	e8 de ed ff ff       	call   800e7c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80209e:	8b 03                	mov    (%ebx),%eax
  8020a0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020a3:	74 e4                	je     802089 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020a5:	89 c2                	mov    %eax,%edx
  8020a7:	c1 fa 1f             	sar    $0x1f,%edx
  8020aa:	c1 ea 1b             	shr    $0x1b,%edx
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	83 e0 1f             	and    $0x1f,%eax
  8020b2:	29 d0                	sub    %edx,%eax
  8020b4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8020bf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020c2:	83 c6 01             	add    $0x1,%esi
  8020c5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020c8:	74 0d                	je     8020d7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8020ca:	8b 03                	mov    (%ebx),%eax
  8020cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020cf:	75 d4                	jne    8020a5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020d1:	85 f6                	test   %esi,%esi
  8020d3:	75 b0                	jne    802085 <devpipe_read+0x29>
  8020d5:	eb b2                	jmp    802089 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020d7:	89 f0                	mov    %esi,%eax
  8020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	eb 05                	jmp    8020e7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020f0:	89 ec                	mov    %ebp,%esp
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    

008020f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 48             	sub    $0x48,%esp
  8020fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802100:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802106:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802109:	89 04 24             	mov    %eax,(%esp)
  80210c:	e8 5a f5 ff ff       	call   80166b <fd_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	85 c0                	test   %eax,%eax
  802115:	0f 88 45 01 00 00    	js     802260 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802122:	00 
  802123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802131:	e8 76 ed ff ff       	call   800eac <sys_page_alloc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	0f 88 20 01 00 00    	js     802260 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802140:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802143:	89 04 24             	mov    %eax,(%esp)
  802146:	e8 20 f5 ff ff       	call   80166b <fd_alloc>
  80214b:	89 c3                	mov    %eax,%ebx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	0f 88 f8 00 00 00    	js     80224d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802155:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80215c:	00 
  80215d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802160:	89 44 24 04          	mov    %eax,0x4(%esp)
  802164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216b:	e8 3c ed ff ff       	call   800eac <sys_page_alloc>
  802170:	89 c3                	mov    %eax,%ebx
  802172:	85 c0                	test   %eax,%eax
  802174:	0f 88 d3 00 00 00    	js     80224d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80217a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217d:	89 04 24             	mov    %eax,(%esp)
  802180:	e8 cb f4 ff ff       	call   801650 <fd2data>
  802185:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802187:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80218e:	00 
  80218f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80219a:	e8 0d ed ff ff       	call   800eac <sys_page_alloc>
  80219f:	89 c3                	mov    %eax,%ebx
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	0f 88 91 00 00 00    	js     80223a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 9c f4 ff ff       	call   801650 <fd2data>
  8021b4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021bb:	00 
  8021bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021c7:	00 
  8021c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d3:	e8 33 ed ff ff       	call   800f0b <sys_page_map>
  8021d8:	89 c3                	mov    %eax,%ebx
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 4c                	js     80222a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021de:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8021e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8021f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802201:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 2d f4 ff ff       	call   801640 <fd2num>
  802213:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802215:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802218:	89 04 24             	mov    %eax,(%esp)
  80221b:	e8 20 f4 ff ff       	call   801640 <fd2num>
  802220:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802223:	bb 00 00 00 00       	mov    $0x0,%ebx
  802228:	eb 36                	jmp    802260 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80222a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80222e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802235:	e8 2f ed ff ff       	call   800f69 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80223a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80223d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802248:	e8 1c ed ff ff       	call   800f69 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80224d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802250:	89 44 24 04          	mov    %eax,0x4(%esp)
  802254:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80225b:	e8 09 ed ff ff       	call   800f69 <sys_page_unmap>
    err:
	return r;
}
  802260:	89 d8                	mov    %ebx,%eax
  802262:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802265:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802268:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80226b:	89 ec                	mov    %ebp,%esp
  80226d:	5d                   	pop    %ebp
  80226e:	c3                   	ret    

0080226f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	89 04 24             	mov    %eax,(%esp)
  802282:	e8 57 f4 ff ff       	call   8016de <fd_lookup>
  802287:	85 c0                	test   %eax,%eax
  802289:	78 15                	js     8022a0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 ba f3 ff ff       	call   801650 <fd2data>
	return _pipeisclosed(fd, p);
  802296:	89 c2                	mov    %eax,%edx
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	e8 c2 fc ff ff       	call   801f62 <_pipeisclosed>
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    
	...

008022b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022c0:	c7 44 24 04 a2 2e 80 	movl   $0x802ea2,0x4(%esp)
  8022c7:	00 
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 d8 e6 ff ff       	call   8009ab <strcpy>
	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e6:	be 00 00 00 00       	mov    $0x0,%esi
  8022eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ef:	74 43                	je     802334 <devcons_write+0x5a>
  8022f1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ff:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802301:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802304:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802309:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80230c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802310:	03 45 0c             	add    0xc(%ebp),%eax
  802313:	89 44 24 04          	mov    %eax,0x4(%esp)
  802317:	89 3c 24             	mov    %edi,(%esp)
  80231a:	e8 7d e8 ff ff       	call   800b9c <memmove>
		sys_cputs(buf, m);
  80231f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802323:	89 3c 24             	mov    %edi,(%esp)
  802326:	e8 65 ea ff ff       	call   800d90 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80232b:	01 de                	add    %ebx,%esi
  80232d:	89 f0                	mov    %esi,%eax
  80232f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802332:	72 c8                	jb     8022fc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802334:	89 f0                	mov    %esi,%eax
  802336:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    

00802341 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80234c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802350:	75 07                	jne    802359 <devcons_read+0x18>
  802352:	eb 31                	jmp    802385 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802354:	e8 23 eb ff ff       	call   800e7c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	e8 5a ea ff ff       	call   800dbf <sys_cgetc>
  802365:	85 c0                	test   %eax,%eax
  802367:	74 eb                	je     802354 <devcons_read+0x13>
  802369:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80236b:	85 c0                	test   %eax,%eax
  80236d:	78 16                	js     802385 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80236f:	83 f8 04             	cmp    $0x4,%eax
  802372:	74 0c                	je     802380 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802374:	8b 45 0c             	mov    0xc(%ebp),%eax
  802377:	88 10                	mov    %dl,(%eax)
	return 1;
  802379:	b8 01 00 00 00       	mov    $0x1,%eax
  80237e:	eb 05                	jmp    802385 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802393:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80239a:	00 
  80239b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80239e:	89 04 24             	mov    %eax,(%esp)
  8023a1:	e8 ea e9 ff ff       	call   800d90 <sys_cputs>
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <getchar>:

int
getchar(void)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023b5:	00 
  8023b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c4:	e8 d5 f5 ff ff       	call   80199e <read>
	if (r < 0)
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	78 0f                	js     8023dc <getchar+0x34>
		return r;
	if (r < 1)
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	7e 06                	jle    8023d7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023d5:	eb 05                	jmp    8023dc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023d7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 e8 f2 ff ff       	call   8016de <fd_lookup>
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	78 11                	js     80240b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802403:	39 10                	cmp    %edx,(%eax)
  802405:	0f 94 c0             	sete   %al
  802408:	0f b6 c0             	movzbl %al,%eax
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <opencons>:

int
opencons(void)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802413:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802416:	89 04 24             	mov    %eax,(%esp)
  802419:	e8 4d f2 ff ff       	call   80166b <fd_alloc>
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 3c                	js     80245e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802422:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802429:	00 
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802431:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802438:	e8 6f ea ff ff       	call   800eac <sys_page_alloc>
  80243d:	85 c0                	test   %eax,%eax
  80243f:	78 1d                	js     80245e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802441:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802456:	89 04 24             	mov    %eax,(%esp)
  802459:	e8 e2 f1 ff ff       	call   801640 <fd2num>
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802466:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80246d:	75 54                	jne    8024c3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80246f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802476:	00 
  802477:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80247e:	ee 
  80247f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802486:	e8 21 ea ff ff       	call   800eac <sys_page_alloc>
  80248b:	85 c0                	test   %eax,%eax
  80248d:	79 20                	jns    8024af <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  80248f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802493:	c7 44 24 08 ae 2e 80 	movl   $0x802eae,0x8(%esp)
  80249a:	00 
  80249b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8024a2:	00 
  8024a3:	c7 04 24 c6 2e 80 00 	movl   $0x802ec6,(%esp)
  8024aa:	e8 e1 dd ff ff       	call   800290 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8024af:	c7 44 24 04 d0 24 80 	movl   $0x8024d0,0x4(%esp)
  8024b6:	00 
  8024b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024be:	e8 c0 eb ff ff       	call   801083 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    
  8024cd:	00 00                	add    %al,(%eax)
	...

008024d0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024d0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024d1:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8024d6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024d8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8024db:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8024df:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8024e2:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8024e6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8024ea:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8024ec:	83 c4 08             	add    $0x8,%esp
	popal
  8024ef:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8024f0:	83 c4 04             	add    $0x4,%esp
	popfl
  8024f3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8024f4:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8024f5:	c3                   	ret    
	...

00802500 <__udivdi3>:
  802500:	83 ec 1c             	sub    $0x1c,%esp
  802503:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802507:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80250b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80250f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802513:	89 74 24 10          	mov    %esi,0x10(%esp)
  802517:	8b 74 24 24          	mov    0x24(%esp),%esi
  80251b:	85 ff                	test   %edi,%edi
  80251d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802521:	89 44 24 08          	mov    %eax,0x8(%esp)
  802525:	89 cd                	mov    %ecx,%ebp
  802527:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252b:	75 33                	jne    802560 <__udivdi3+0x60>
  80252d:	39 f1                	cmp    %esi,%ecx
  80252f:	77 57                	ja     802588 <__udivdi3+0x88>
  802531:	85 c9                	test   %ecx,%ecx
  802533:	75 0b                	jne    802540 <__udivdi3+0x40>
  802535:	b8 01 00 00 00       	mov    $0x1,%eax
  80253a:	31 d2                	xor    %edx,%edx
  80253c:	f7 f1                	div    %ecx
  80253e:	89 c1                	mov    %eax,%ecx
  802540:	89 f0                	mov    %esi,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f1                	div    %ecx
  802546:	89 c6                	mov    %eax,%esi
  802548:	8b 44 24 04          	mov    0x4(%esp),%eax
  80254c:	f7 f1                	div    %ecx
  80254e:	89 f2                	mov    %esi,%edx
  802550:	8b 74 24 10          	mov    0x10(%esp),%esi
  802554:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802558:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	c3                   	ret    
  802560:	31 d2                	xor    %edx,%edx
  802562:	31 c0                	xor    %eax,%eax
  802564:	39 f7                	cmp    %esi,%edi
  802566:	77 e8                	ja     802550 <__udivdi3+0x50>
  802568:	0f bd cf             	bsr    %edi,%ecx
  80256b:	83 f1 1f             	xor    $0x1f,%ecx
  80256e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802578:	76 04                	jbe    80257e <__udivdi3+0x7e>
  80257a:	39 f7                	cmp    %esi,%edi
  80257c:	73 d2                	jae    802550 <__udivdi3+0x50>
  80257e:	31 d2                	xor    %edx,%edx
  802580:	b8 01 00 00 00       	mov    $0x1,%eax
  802585:	eb c9                	jmp    802550 <__udivdi3+0x50>
  802587:	90                   	nop
  802588:	89 f2                	mov    %esi,%edx
  80258a:	f7 f1                	div    %ecx
  80258c:	31 d2                	xor    %edx,%edx
  80258e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802592:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802596:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	c3                   	ret    
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025a5:	b8 20 00 00 00       	mov    $0x20,%eax
  8025aa:	89 ea                	mov    %ebp,%edx
  8025ac:	2b 44 24 04          	sub    0x4(%esp),%eax
  8025b0:	d3 e7                	shl    %cl,%edi
  8025b2:	89 c1                	mov    %eax,%ecx
  8025b4:	d3 ea                	shr    %cl,%edx
  8025b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025bb:	09 fa                	or     %edi,%edx
  8025bd:	89 f7                	mov    %esi,%edi
  8025bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8025c3:	89 f2                	mov    %esi,%edx
  8025c5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8025c9:	d3 e5                	shl    %cl,%ebp
  8025cb:	89 c1                	mov    %eax,%ecx
  8025cd:	d3 ef                	shr    %cl,%edi
  8025cf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025d4:	d3 e2                	shl    %cl,%edx
  8025d6:	89 c1                	mov    %eax,%ecx
  8025d8:	d3 ee                	shr    %cl,%esi
  8025da:	09 d6                	or     %edx,%esi
  8025dc:	89 fa                	mov    %edi,%edx
  8025de:	89 f0                	mov    %esi,%eax
  8025e0:	f7 74 24 0c          	divl   0xc(%esp)
  8025e4:	89 d7                	mov    %edx,%edi
  8025e6:	89 c6                	mov    %eax,%esi
  8025e8:	f7 e5                	mul    %ebp
  8025ea:	39 d7                	cmp    %edx,%edi
  8025ec:	72 22                	jb     802610 <__udivdi3+0x110>
  8025ee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8025f2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025f7:	d3 e5                	shl    %cl,%ebp
  8025f9:	39 c5                	cmp    %eax,%ebp
  8025fb:	73 04                	jae    802601 <__udivdi3+0x101>
  8025fd:	39 d7                	cmp    %edx,%edi
  8025ff:	74 0f                	je     802610 <__udivdi3+0x110>
  802601:	89 f0                	mov    %esi,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	e9 46 ff ff ff       	jmp    802550 <__udivdi3+0x50>
  80260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802610:	8d 46 ff             	lea    -0x1(%esi),%eax
  802613:	31 d2                	xor    %edx,%edx
  802615:	8b 74 24 10          	mov    0x10(%esp),%esi
  802619:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80261d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802621:	83 c4 1c             	add    $0x1c,%esp
  802624:	c3                   	ret    
	...

00802630 <__umoddi3>:
  802630:	83 ec 1c             	sub    $0x1c,%esp
  802633:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802637:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80263b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80263f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802643:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802647:	8b 74 24 24          	mov    0x24(%esp),%esi
  80264b:	85 ed                	test   %ebp,%ebp
  80264d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802651:	89 44 24 08          	mov    %eax,0x8(%esp)
  802655:	89 cf                	mov    %ecx,%edi
  802657:	89 04 24             	mov    %eax,(%esp)
  80265a:	89 f2                	mov    %esi,%edx
  80265c:	75 1a                	jne    802678 <__umoddi3+0x48>
  80265e:	39 f1                	cmp    %esi,%ecx
  802660:	76 4e                	jbe    8026b0 <__umoddi3+0x80>
  802662:	f7 f1                	div    %ecx
  802664:	89 d0                	mov    %edx,%eax
  802666:	31 d2                	xor    %edx,%edx
  802668:	8b 74 24 10          	mov    0x10(%esp),%esi
  80266c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802670:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802674:	83 c4 1c             	add    $0x1c,%esp
  802677:	c3                   	ret    
  802678:	39 f5                	cmp    %esi,%ebp
  80267a:	77 54                	ja     8026d0 <__umoddi3+0xa0>
  80267c:	0f bd c5             	bsr    %ebp,%eax
  80267f:	83 f0 1f             	xor    $0x1f,%eax
  802682:	89 44 24 04          	mov    %eax,0x4(%esp)
  802686:	75 60                	jne    8026e8 <__umoddi3+0xb8>
  802688:	3b 0c 24             	cmp    (%esp),%ecx
  80268b:	0f 87 07 01 00 00    	ja     802798 <__umoddi3+0x168>
  802691:	89 f2                	mov    %esi,%edx
  802693:	8b 34 24             	mov    (%esp),%esi
  802696:	29 ce                	sub    %ecx,%esi
  802698:	19 ea                	sbb    %ebp,%edx
  80269a:	89 34 24             	mov    %esi,(%esp)
  80269d:	8b 04 24             	mov    (%esp),%eax
  8026a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ac:	83 c4 1c             	add    $0x1c,%esp
  8026af:	c3                   	ret    
  8026b0:	85 c9                	test   %ecx,%ecx
  8026b2:	75 0b                	jne    8026bf <__umoddi3+0x8f>
  8026b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b9:	31 d2                	xor    %edx,%edx
  8026bb:	f7 f1                	div    %ecx
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	89 f0                	mov    %esi,%eax
  8026c1:	31 d2                	xor    %edx,%edx
  8026c3:	f7 f1                	div    %ecx
  8026c5:	8b 04 24             	mov    (%esp),%eax
  8026c8:	f7 f1                	div    %ecx
  8026ca:	eb 98                	jmp    802664 <__umoddi3+0x34>
  8026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	89 f2                	mov    %esi,%edx
  8026d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	c3                   	ret    
  8026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ed:	89 e8                	mov    %ebp,%eax
  8026ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8026f8:	89 fa                	mov    %edi,%edx
  8026fa:	d3 e0                	shl    %cl,%eax
  8026fc:	89 e9                	mov    %ebp,%ecx
  8026fe:	d3 ea                	shr    %cl,%edx
  802700:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802705:	09 c2                	or     %eax,%edx
  802707:	8b 44 24 08          	mov    0x8(%esp),%eax
  80270b:	89 14 24             	mov    %edx,(%esp)
  80270e:	89 f2                	mov    %esi,%edx
  802710:	d3 e7                	shl    %cl,%edi
  802712:	89 e9                	mov    %ebp,%ecx
  802714:	d3 ea                	shr    %cl,%edx
  802716:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80271f:	d3 e6                	shl    %cl,%esi
  802721:	89 e9                	mov    %ebp,%ecx
  802723:	d3 e8                	shr    %cl,%eax
  802725:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80272a:	09 f0                	or     %esi,%eax
  80272c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802730:	f7 34 24             	divl   (%esp)
  802733:	d3 e6                	shl    %cl,%esi
  802735:	89 74 24 08          	mov    %esi,0x8(%esp)
  802739:	89 d6                	mov    %edx,%esi
  80273b:	f7 e7                	mul    %edi
  80273d:	39 d6                	cmp    %edx,%esi
  80273f:	89 c1                	mov    %eax,%ecx
  802741:	89 d7                	mov    %edx,%edi
  802743:	72 3f                	jb     802784 <__umoddi3+0x154>
  802745:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802749:	72 35                	jb     802780 <__umoddi3+0x150>
  80274b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80274f:	29 c8                	sub    %ecx,%eax
  802751:	19 fe                	sbb    %edi,%esi
  802753:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802758:	89 f2                	mov    %esi,%edx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	89 e9                	mov    %ebp,%ecx
  80275e:	d3 e2                	shl    %cl,%edx
  802760:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802765:	09 d0                	or     %edx,%eax
  802767:	89 f2                	mov    %esi,%edx
  802769:	d3 ea                	shr    %cl,%edx
  80276b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80276f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802773:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802777:	83 c4 1c             	add    $0x1c,%esp
  80277a:	c3                   	ret    
  80277b:	90                   	nop
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	39 d6                	cmp    %edx,%esi
  802782:	75 c7                	jne    80274b <__umoddi3+0x11b>
  802784:	89 d7                	mov    %edx,%edi
  802786:	89 c1                	mov    %eax,%ecx
  802788:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80278c:	1b 3c 24             	sbb    (%esp),%edi
  80278f:	eb ba                	jmp    80274b <__umoddi3+0x11b>
  802791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802798:	39 f5                	cmp    %esi,%ebp
  80279a:	0f 82 f1 fe ff ff    	jb     802691 <__umoddi3+0x61>
  8027a0:	e9 f8 fe ff ff       	jmp    80269d <__umoddi3+0x6d>
