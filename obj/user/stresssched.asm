
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 f7 00 00 00       	call   800128 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 ff 0c 00 00       	call   800d4c <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 1a 11 00 00       	call   801173 <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 21                	jmp    800088 <umain+0x48>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 1c                	je     800088 <umain+0x48>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800072:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800075:	05 04 00 c0 ee       	add    $0xeec00004,%eax
  80007a:	8b 40 50             	mov    0x50(%eax),%eax
  80007d:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800082:	85 c0                	test   %eax,%eax
  800084:	75 0f                	jne    800095 <umain+0x55>
  800086:	eb 24                	jmp    8000ac <umain+0x6c>
	// Fork several environments
	for (i = 0; i < 20; i++)
		if (fork() == 0)
			break;
	if (i == 20) {
		sys_yield();
  800088:	e8 ef 0c 00 00       	call   800d7c <sys_yield>
		return;
  80008d:	8d 76 00             	lea    0x0(%esi),%esi
  800090:	e9 8a 00 00 00       	jmp    80011f <umain+0xdf>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800095:	6b d6 7c             	imul   $0x7c,%esi,%edx
  800098:	81 c2 04 00 c0 ee    	add    $0xeec00004,%edx
		asm volatile("pause");
  80009e:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a0:	8b 42 50             	mov    0x50(%edx),%eax
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 f7                	jne    80009e <umain+0x5e>
  8000a7:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  8000ac:	e8 cb 0c 00 00       	call   800d7c <sys_yield>
  8000b1:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000b6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8000bc:	83 c2 01             	add    $0x1,%edx
  8000bf:	89 15 04 40 80 00    	mov    %edx,0x804004
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000c5:	83 e8 01             	sub    $0x1,%eax
  8000c8:	75 ec                	jne    8000b6 <umain+0x76>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000ca:	83 eb 01             	sub    $0x1,%ebx
  8000cd:	75 dd                	jne    8000ac <umain+0x6c>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d4:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000d9:	74 25                	je     800100 <umain+0xc0>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000db:	a1 04 40 80 00       	mov    0x804004,%eax
  8000e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000e4:	c7 44 24 08 c0 26 80 	movl   $0x8026c0,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 e8 26 80 00 	movl   $0x8026e8,(%esp)
  8000fb:	e8 94 00 00 00       	call   800194 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800100:	a1 08 40 80 00       	mov    0x804008,%eax
  800105:	8b 50 5c             	mov    0x5c(%eax),%edx
  800108:	8b 40 48             	mov    0x48(%eax),%eax
  80010b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80010f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800113:	c7 04 24 fb 26 80 00 	movl   $0x8026fb,(%esp)
  80011a:	e8 70 01 00 00       	call   80028f <cprintf>

}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
	...

00800128 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 18             	sub    $0x18,%esp
  80012e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800131:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800134:	8b 75 08             	mov    0x8(%ebp),%esi
  800137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80013a:	e8 0d 0c 00 00       	call   800d4c <sys_getenvid>
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 08 40 80 00       	mov    %eax,0x804008
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	85 f6                	test   %esi,%esi
  800153:	7e 07                	jle    80015c <libmain+0x34>
		binaryname = argv[0];
  800155:	8b 03                	mov    (%ebx),%eax
  800157:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800160:	89 34 24             	mov    %esi,(%esp)
  800163:	e8 d8 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800168:	e8 0b 00 00 00       	call   800178 <exit>
}
  80016d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800170:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800173:	89 ec                	mov    %ebp,%esp
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    
	...

00800178 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80017e:	e8 bb 14 00 00       	call   80163e <close_all>
	sys_env_destroy(0);
  800183:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80018a:	e8 60 0b 00 00       	call   800cef <sys_env_destroy>
}
  80018f:	c9                   	leave  
  800190:	c3                   	ret    
  800191:	00 00                	add    %al,(%eax)
	...

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80019c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001a5:	e8 a2 0b 00 00       	call   800d4c <sys_getenvid>
  8001aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ad:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c0:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  8001c7:	e8 c3 00 00 00       	call   80028f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d3:	89 04 24             	mov    %eax,(%esp)
  8001d6:	e8 53 00 00 00       	call   80022e <vcprintf>
	cprintf("\n");
  8001db:	c7 04 24 17 27 80 00 	movl   $0x802717,(%esp)
  8001e2:	e8 a8 00 00 00       	call   80028f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e7:	cc                   	int3   
  8001e8:	eb fd                	jmp    8001e7 <_panic+0x53>
	...

008001ec <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	53                   	push   %ebx
  8001f0:	83 ec 14             	sub    $0x14,%esp
  8001f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f6:	8b 03                	mov    (%ebx),%eax
  8001f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fb:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001ff:	83 c0 01             	add    $0x1,%eax
  800202:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800204:	3d ff 00 00 00       	cmp    $0xff,%eax
  800209:	75 19                	jne    800224 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80020b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800212:	00 
  800213:	8d 43 08             	lea    0x8(%ebx),%eax
  800216:	89 04 24             	mov    %eax,(%esp)
  800219:	e8 72 0a 00 00       	call   800c90 <sys_cputs>
		b->idx = 0;
  80021e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800224:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800228:	83 c4 14             	add    $0x14,%esp
  80022b:	5b                   	pop    %ebx
  80022c:	5d                   	pop    %ebp
  80022d:	c3                   	ret    

0080022e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800237:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023e:	00 00 00 
	b.cnt = 0;
  800241:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800248:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	89 44 24 08          	mov    %eax,0x8(%esp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800263:	c7 04 24 ec 01 80 00 	movl   $0x8001ec,(%esp)
  80026a:	e8 9b 01 00 00       	call   80040a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800275:	89 44 24 04          	mov    %eax,0x4(%esp)
  800279:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027f:	89 04 24             	mov    %eax,(%esp)
  800282:	e8 09 0a 00 00       	call   800c90 <sys_cputs>

	return b.cnt;
}
  800287:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800295:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 87 ff ff ff       	call   80022e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a7:	c9                   	leave  
  8002a8:	c3                   	ret    
  8002a9:	00 00                	add    %al,(%eax)
  8002ab:	00 00                	add    %al,(%eax)
  8002ad:	00 00                	add    %al,(%eax)
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
  80031a:	e8 f1 20 00 00       	call   802410 <__udivdi3>
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
  80036d:	e8 ce 21 00 00       	call   802540 <__umoddi3>
  800372:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800376:	0f be 80 47 27 80 00 	movsbl 0x802747(%eax),%eax
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
  80049e:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
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
  800554:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  80055b:	85 d2                	test   %edx,%edx
  80055d:	75 23                	jne    800582 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80055f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800563:	c7 44 24 08 5f 27 80 	movl   $0x80275f,0x8(%esp)
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
  800586:	c7 44 24 08 b5 2c 80 	movl   $0x802cb5,0x8(%esp)
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
  8005bb:	ba 58 27 80 00       	mov    $0x802758,%edx
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
  800d23:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800d3a:	e8 55 f4 ff ff       	call   800194 <_panic>

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
  800de2:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800df9:	e8 96 f3 ff ff       	call   800194 <_panic>

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
  800e40:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800e47:	00 
  800e48:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4f:	00 
  800e50:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800e57:	e8 38 f3 ff ff       	call   800194 <_panic>

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
  800e9e:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800ea5:	00 
  800ea6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ead:	00 
  800eae:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800eb5:	e8 da f2 ff ff       	call   800194 <_panic>

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
  800efc:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f03:	00 
  800f04:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0b:	00 
  800f0c:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800f13:	e8 7c f2 ff ff       	call   800194 <_panic>

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
  800f5a:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800f61:	00 
  800f62:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f69:	00 
  800f6a:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800f71:	e8 1e f2 ff ff       	call   800194 <_panic>

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
  800fb8:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  800fbf:	00 
  800fc0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc7:	00 
  800fc8:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  800fcf:	e8 c0 f1 ff ff       	call   800194 <_panic>

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
  801049:	c7 44 24 08 3f 2a 80 	movl   $0x802a3f,0x8(%esp)
  801050:	00 
  801051:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801058:	00 
  801059:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  801060:	e8 2f f1 ff ff       	call   800194 <_panic>

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

00801074 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	53                   	push   %ebx
  801078:	83 ec 24             	sub    $0x24,%esp
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80107e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801080:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801084:	74 21                	je     8010a7 <pgfault+0x33>
  801086:	89 d8                	mov    %ebx,%eax
  801088:	c1 e8 16             	shr    $0x16,%eax
  80108b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801092:	a8 01                	test   $0x1,%al
  801094:	74 11                	je     8010a7 <pgfault+0x33>
  801096:	89 d8                	mov    %ebx,%eax
  801098:	c1 e8 0c             	shr    $0xc,%eax
  80109b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a2:	f6 c4 08             	test   $0x8,%ah
  8010a5:	75 1c                	jne    8010c3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  8010a7:	c7 44 24 08 6c 2a 80 	movl   $0x802a6c,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8010be:	e8 d1 f0 ff ff       	call   800194 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8010c3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010ca:	00 
  8010cb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d2:	00 
  8010d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010da:	e8 cd fc ff ff       	call   800dac <sys_page_alloc>
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	79 20                	jns    801103 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8010e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010e7:	c7 44 24 08 a8 2a 80 	movl   $0x802aa8,0x8(%esp)
  8010ee:	00 
  8010ef:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8010f6:	00 
  8010f7:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8010fe:	e8 91 f0 ff ff       	call   800194 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801103:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801109:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801110:	00 
  801111:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801115:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80111c:	e8 7b f9 ff ff       	call   800a9c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801121:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801128:	00 
  801129:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80112d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801134:	00 
  801135:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80113c:	00 
  80113d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801144:	e8 c2 fc ff ff       	call   800e0b <sys_page_map>
  801149:	85 c0                	test   %eax,%eax
  80114b:	79 20                	jns    80116d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80114d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801151:	c7 44 24 08 d0 2a 80 	movl   $0x802ad0,0x8(%esp)
  801158:	00 
  801159:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801160:	00 
  801161:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801168:	e8 27 f0 ff ff       	call   800194 <_panic>
	//panic("pgfault not implemented");
}
  80116d:	83 c4 24             	add    $0x24,%esp
  801170:	5b                   	pop    %ebx
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80117c:	c7 04 24 74 10 80 00 	movl   $0x801074,(%esp)
  801183:	e8 88 10 00 00       	call   802210 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801188:	ba 07 00 00 00       	mov    $0x7,%edx
  80118d:	89 d0                	mov    %edx,%eax
  80118f:	cd 30                	int    $0x30
  801191:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801194:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801196:	85 c0                	test   %eax,%eax
  801198:	79 20                	jns    8011ba <fork+0x47>
		panic("sys_exofork: %e", envid);
  80119a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119e:	c7 44 24 08 ce 2b 80 	movl   $0x802bce,0x8(%esp)
  8011a5:	00 
  8011a6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  8011ad:	00 
  8011ae:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8011b5:	e8 da ef ff ff       	call   800194 <_panic>
	if (envid == 0) {
  8011ba:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8011bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c3:	75 1c                	jne    8011e1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011c5:	e8 82 fb ff ff       	call   800d4c <sys_getenvid>
  8011ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011cf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011d7:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8011dc:	e9 06 02 00 00       	jmp    8013e7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8011e1:	89 d8                	mov    %ebx,%eax
  8011e3:	c1 e8 16             	shr    $0x16,%eax
  8011e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ed:	a8 01                	test   $0x1,%al
  8011ef:	0f 84 57 01 00 00    	je     80134c <fork+0x1d9>
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	c1 ee 0c             	shr    $0xc,%esi
  8011fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801201:	a8 01                	test   $0x1,%al
  801203:	0f 84 43 01 00 00    	je     80134c <fork+0x1d9>
  801209:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801210:	a8 04                	test   $0x4,%al
  801212:	0f 84 34 01 00 00    	je     80134c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801218:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80121b:	89 f0                	mov    %esi,%eax
  80121d:	c1 e8 0c             	shr    $0xc,%eax
  801220:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801227:	f6 c4 04             	test   $0x4,%ah
  80122a:	74 45                	je     801271 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80122c:	25 07 0e 00 00       	and    $0xe07,%eax
  801231:	89 44 24 10          	mov    %eax,0x10(%esp)
  801235:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801239:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80123d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801248:	e8 be fb ff ff       	call   800e0b <sys_page_map>
  80124d:	85 c0                	test   %eax,%eax
  80124f:	0f 89 f7 00 00 00    	jns    80134c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801255:	c7 44 24 08 de 2b 80 	movl   $0x802bde,0x8(%esp)
  80125c:	00 
  80125d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801264:	00 
  801265:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80126c:	e8 23 ef ff ff       	call   800194 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801271:	a9 02 08 00 00       	test   $0x802,%eax
  801276:	0f 84 8c 00 00 00    	je     801308 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80127c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801283:	00 
  801284:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801288:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80128c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801290:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801297:	e8 6f fb ff ff       	call   800e0b <sys_page_map>
  80129c:	85 c0                	test   %eax,%eax
  80129e:	79 20                	jns    8012c0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  8012a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a4:	c7 44 24 08 f4 2a 80 	movl   $0x802af4,0x8(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8012b3:	00 
  8012b4:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8012bb:	e8 d4 ee ff ff       	call   800194 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8012c0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012c7:	00 
  8012c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d3:	00 
  8012d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012df:	e8 27 fb ff ff       	call   800e0b <sys_page_map>
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	79 64                	jns    80134c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8012e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ec:	c7 44 24 08 20 2b 80 	movl   $0x802b20,0x8(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8012fb:	00 
  8012fc:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801303:	e8 8c ee ff ff       	call   800194 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801308:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80130f:	00 
  801310:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801314:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801318:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801323:	e8 e3 fa ff ff       	call   800e0b <sys_page_map>
  801328:	85 c0                	test   %eax,%eax
  80132a:	79 20                	jns    80134c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80132c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801330:	c7 44 24 08 4c 2b 80 	movl   $0x802b4c,0x8(%esp)
  801337:	00 
  801338:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80133f:	00 
  801340:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801347:	e8 48 ee ff ff       	call   800194 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80134c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801352:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801358:	0f 85 83 fe ff ff    	jne    8011e1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80135e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801365:	00 
  801366:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80136d:	ee 
  80136e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801371:	89 04 24             	mov    %eax,(%esp)
  801374:	e8 33 fa ff ff       	call   800dac <sys_page_alloc>
  801379:	85 c0                	test   %eax,%eax
  80137b:	79 20                	jns    80139d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80137d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801381:	c7 44 24 08 78 2b 80 	movl   $0x802b78,0x8(%esp)
  801388:	00 
  801389:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801390:	00 
  801391:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  801398:	e8 f7 ed ff ff       	call   800194 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80139d:	c7 44 24 04 80 22 80 	movl   $0x802280,0x4(%esp)
  8013a4:	00 
  8013a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a8:	89 04 24             	mov    %eax,(%esp)
  8013ab:	e8 d3 fb ff ff       	call   800f83 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013b0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013b7:	00 
  8013b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	e8 04 fb ff ff       	call   800ec7 <sys_env_set_status>
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	79 20                	jns    8013e7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8013c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013cb:	c7 44 24 08 9c 2b 80 	movl   $0x802b9c,0x8(%esp)
  8013d2:	00 
  8013d3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8013da:	00 
  8013db:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  8013e2:	e8 ad ed ff ff       	call   800194 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8013e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ea:	83 c4 3c             	add    $0x3c,%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5e                   	pop    %esi
  8013ef:	5f                   	pop    %edi
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    

008013f2 <sfork>:

// Challenge!
int
sfork(void)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013f8:	c7 44 24 08 f5 2b 80 	movl   $0x802bf5,0x8(%esp)
  8013ff:	00 
  801400:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801407:	00 
  801408:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  80140f:	e8 80 ed ff ff       	call   800194 <_panic>
	...

00801420 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
  80142b:	c1 e8 0c             	shr    $0xc,%eax
}
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 04 24             	mov    %eax,(%esp)
  80143c:	e8 df ff ff ff       	call   801420 <fd2num>
  801441:	05 20 00 0d 00       	add    $0xd0020,%eax
  801446:	c1 e0 0c             	shl    $0xc,%eax
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	53                   	push   %ebx
  80144f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801452:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801457:	a8 01                	test   $0x1,%al
  801459:	74 34                	je     80148f <fd_alloc+0x44>
  80145b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801460:	a8 01                	test   $0x1,%al
  801462:	74 32                	je     801496 <fd_alloc+0x4b>
  801464:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801469:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	c1 ea 16             	shr    $0x16,%edx
  801470:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801477:	f6 c2 01             	test   $0x1,%dl
  80147a:	74 1f                	je     80149b <fd_alloc+0x50>
  80147c:	89 c2                	mov    %eax,%edx
  80147e:	c1 ea 0c             	shr    $0xc,%edx
  801481:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801488:	f6 c2 01             	test   $0x1,%dl
  80148b:	75 17                	jne    8014a4 <fd_alloc+0x59>
  80148d:	eb 0c                	jmp    80149b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80148f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801494:	eb 05                	jmp    80149b <fd_alloc+0x50>
  801496:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80149b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a2:	eb 17                	jmp    8014bb <fd_alloc+0x70>
  8014a4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014ae:	75 b9                	jne    801469 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8014b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014bb:	5b                   	pop    %ebx
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014c9:	83 fa 1f             	cmp    $0x1f,%edx
  8014cc:	77 3f                	ja     80150d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014ce:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8014d4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014d7:	89 d0                	mov    %edx,%eax
  8014d9:	c1 e8 16             	shr    $0x16,%eax
  8014dc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e8:	f6 c1 01             	test   $0x1,%cl
  8014eb:	74 20                	je     80150d <fd_lookup+0x4f>
  8014ed:	89 d0                	mov    %edx,%eax
  8014ef:	c1 e8 0c             	shr    $0xc,%eax
  8014f2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014fe:	f6 c1 01             	test   $0x1,%cl
  801501:	74 0a                	je     80150d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	89 10                	mov    %edx,(%eax)
	return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    

0080150f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 14             	sub    $0x14,%esp
  801516:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801519:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801521:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801527:	75 17                	jne    801540 <dev_lookup+0x31>
  801529:	eb 07                	jmp    801532 <dev_lookup+0x23>
  80152b:	39 0a                	cmp    %ecx,(%edx)
  80152d:	75 11                	jne    801540 <dev_lookup+0x31>
  80152f:	90                   	nop
  801530:	eb 05                	jmp    801537 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801532:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801537:	89 13                	mov    %edx,(%ebx)
			return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	eb 35                	jmp    801575 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801540:	83 c0 01             	add    $0x1,%eax
  801543:	8b 14 85 8c 2c 80 00 	mov    0x802c8c(,%eax,4),%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 dd                	jne    80152b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154e:	a1 08 40 80 00       	mov    0x804008,%eax
  801553:	8b 40 48             	mov    0x48(%eax),%eax
  801556:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80155a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155e:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  801565:	e8 25 ed ff ff       	call   80028f <cprintf>
	*dev = 0;
  80156a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801570:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801575:	83 c4 14             	add    $0x14,%esp
  801578:	5b                   	pop    %ebx
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    

0080157b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 38             	sub    $0x38,%esp
  801581:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801584:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801587:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80158a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80158d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801591:	89 3c 24             	mov    %edi,(%esp)
  801594:	e8 87 fe ff ff       	call   801420 <fd2num>
  801599:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80159c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 16 ff ff ff       	call   8014be <fd_lookup>
  8015a8:	89 c3                	mov    %eax,%ebx
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 05                	js     8015b3 <fd_close+0x38>
	    || fd != fd2)
  8015ae:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8015b1:	74 0e                	je     8015c1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015b3:	89 f0                	mov    %esi,%eax
  8015b5:	84 c0                	test   %al,%al
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	0f 44 d8             	cmove  %eax,%ebx
  8015bf:	eb 3d                	jmp    8015fe <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c8:	8b 07                	mov    (%edi),%eax
  8015ca:	89 04 24             	mov    %eax,(%esp)
  8015cd:	e8 3d ff ff ff       	call   80150f <dev_lookup>
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 16                	js     8015ee <fd_close+0x73>
		if (dev->dev_close)
  8015d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	74 07                	je     8015ee <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8015e7:	89 3c 24             	mov    %edi,(%esp)
  8015ea:	ff d0                	call   *%eax
  8015ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f9:	e8 6b f8 ff ff       	call   800e69 <sys_page_unmap>
	return r;
}
  8015fe:	89 d8                	mov    %ebx,%eax
  801600:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801603:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801606:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801609:	89 ec                	mov    %ebp,%esp
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 04 24             	mov    %eax,(%esp)
  801620:	e8 99 fe ff ff       	call   8014be <fd_lookup>
  801625:	85 c0                	test   %eax,%eax
  801627:	78 13                	js     80163c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801629:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801630:	00 
  801631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	e8 3f ff ff ff       	call   80157b <fd_close>
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <close_all>:

void
close_all(void)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	53                   	push   %ebx
  801642:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801645:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80164a:	89 1c 24             	mov    %ebx,(%esp)
  80164d:	e8 bb ff ff ff       	call   80160d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801652:	83 c3 01             	add    $0x1,%ebx
  801655:	83 fb 20             	cmp    $0x20,%ebx
  801658:	75 f0                	jne    80164a <close_all+0xc>
		close(i);
}
  80165a:	83 c4 14             	add    $0x14,%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 58             	sub    $0x58,%esp
  801666:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801669:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80166c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80166f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801672:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801675:	89 44 24 04          	mov    %eax,0x4(%esp)
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 04 24             	mov    %eax,(%esp)
  80167f:	e8 3a fe ff ff       	call   8014be <fd_lookup>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	85 c0                	test   %eax,%eax
  801688:	0f 88 e1 00 00 00    	js     80176f <dup+0x10f>
		return r;
	close(newfdnum);
  80168e:	89 3c 24             	mov    %edi,(%esp)
  801691:	e8 77 ff ff ff       	call   80160d <close>

	newfd = INDEX2FD(newfdnum);
  801696:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80169c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80169f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 86 fd ff ff       	call   801430 <fd2data>
  8016aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016ac:	89 34 24             	mov    %esi,(%esp)
  8016af:	e8 7c fd ff ff       	call   801430 <fd2data>
  8016b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016b7:	89 d8                	mov    %ebx,%eax
  8016b9:	c1 e8 16             	shr    $0x16,%eax
  8016bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c3:	a8 01                	test   $0x1,%al
  8016c5:	74 46                	je     80170d <dup+0xad>
  8016c7:	89 d8                	mov    %ebx,%eax
  8016c9:	c1 e8 0c             	shr    $0xc,%eax
  8016cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016d3:	f6 c2 01             	test   $0x1,%dl
  8016d6:	74 35                	je     80170d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016df:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f6:	00 
  8016f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801702:	e8 04 f7 ff ff       	call   800e0b <sys_page_map>
  801707:	89 c3                	mov    %eax,%ebx
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 3b                	js     801748 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80170d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801710:	89 c2                	mov    %eax,%edx
  801712:	c1 ea 0c             	shr    $0xc,%edx
  801715:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80171c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801722:	89 54 24 10          	mov    %edx,0x10(%esp)
  801726:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80172a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801731:	00 
  801732:	89 44 24 04          	mov    %eax,0x4(%esp)
  801736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173d:	e8 c9 f6 ff ff       	call   800e0b <sys_page_map>
  801742:	89 c3                	mov    %eax,%ebx
  801744:	85 c0                	test   %eax,%eax
  801746:	79 25                	jns    80176d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801748:	89 74 24 04          	mov    %esi,0x4(%esp)
  80174c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801753:	e8 11 f7 ff ff       	call   800e69 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80175b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801766:	e8 fe f6 ff ff       	call   800e69 <sys_page_unmap>
	return r;
  80176b:	eb 02                	jmp    80176f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80176d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801774:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801777:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80177a:	89 ec                	mov    %ebp,%esp
  80177c:	5d                   	pop    %ebp
  80177d:	c3                   	ret    

0080177e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	53                   	push   %ebx
  801782:	83 ec 24             	sub    $0x24,%esp
  801785:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801788:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178f:	89 1c 24             	mov    %ebx,(%esp)
  801792:	e8 27 fd ff ff       	call   8014be <fd_lookup>
  801797:	85 c0                	test   %eax,%eax
  801799:	78 6d                	js     801808 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	89 04 24             	mov    %eax,(%esp)
  8017aa:	e8 60 fd ff ff       	call   80150f <dev_lookup>
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 55                	js     801808 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b6:	8b 50 08             	mov    0x8(%eax),%edx
  8017b9:	83 e2 03             	and    $0x3,%edx
  8017bc:	83 fa 01             	cmp    $0x1,%edx
  8017bf:	75 23                	jne    8017e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8017c6:	8b 40 48             	mov    0x48(%eax),%eax
  8017c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  8017d8:	e8 b2 ea ff ff       	call   80028f <cprintf>
		return -E_INVAL;
  8017dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e2:	eb 24                	jmp    801808 <read+0x8a>
	}
	if (!dev->dev_read)
  8017e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e7:	8b 52 08             	mov    0x8(%edx),%edx
  8017ea:	85 d2                	test   %edx,%edx
  8017ec:	74 15                	je     801803 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017fc:	89 04 24             	mov    %eax,(%esp)
  8017ff:	ff d2                	call   *%edx
  801801:	eb 05                	jmp    801808 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801803:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801808:	83 c4 24             	add    $0x24,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	57                   	push   %edi
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 7d 08             	mov    0x8(%ebp),%edi
  80181a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	85 f6                	test   %esi,%esi
  801824:	74 30                	je     801856 <readn+0x48>
  801826:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80182b:	89 f2                	mov    %esi,%edx
  80182d:	29 c2                	sub    %eax,%edx
  80182f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801833:	03 45 0c             	add    0xc(%ebp),%eax
  801836:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183a:	89 3c 24             	mov    %edi,(%esp)
  80183d:	e8 3c ff ff ff       	call   80177e <read>
		if (m < 0)
  801842:	85 c0                	test   %eax,%eax
  801844:	78 10                	js     801856 <readn+0x48>
			return m;
		if (m == 0)
  801846:	85 c0                	test   %eax,%eax
  801848:	74 0a                	je     801854 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80184a:	01 c3                	add    %eax,%ebx
  80184c:	89 d8                	mov    %ebx,%eax
  80184e:	39 f3                	cmp    %esi,%ebx
  801850:	72 d9                	jb     80182b <readn+0x1d>
  801852:	eb 02                	jmp    801856 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801854:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801856:	83 c4 1c             	add    $0x1c,%esp
  801859:	5b                   	pop    %ebx
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	83 ec 24             	sub    $0x24,%esp
  801865:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801868:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186f:	89 1c 24             	mov    %ebx,(%esp)
  801872:	e8 47 fc ff ff       	call   8014be <fd_lookup>
  801877:	85 c0                	test   %eax,%eax
  801879:	78 68                	js     8018e3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80187b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	89 04 24             	mov    %eax,(%esp)
  80188a:	e8 80 fc ff ff       	call   80150f <dev_lookup>
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 50                	js     8018e3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80189a:	75 23                	jne    8018bf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80189c:	a1 08 40 80 00       	mov    0x804008,%eax
  8018a1:	8b 40 48             	mov    0x48(%eax),%eax
  8018a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ac:	c7 04 24 6c 2c 80 00 	movl   $0x802c6c,(%esp)
  8018b3:	e8 d7 e9 ff ff       	call   80028f <cprintf>
		return -E_INVAL;
  8018b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bd:	eb 24                	jmp    8018e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	74 15                	je     8018de <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d7:	89 04 24             	mov    %eax,(%esp)
  8018da:	ff d2                	call   *%edx
  8018dc:	eb 05                	jmp    8018e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018e3:	83 c4 24             	add    $0x24,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	89 04 24             	mov    %eax,(%esp)
  8018fc:	e8 bd fb ff ff       	call   8014be <fd_lookup>
  801901:	85 c0                	test   %eax,%eax
  801903:	78 0e                	js     801913 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	53                   	push   %ebx
  801919:	83 ec 24             	sub    $0x24,%esp
  80191c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80191f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801922:	89 44 24 04          	mov    %eax,0x4(%esp)
  801926:	89 1c 24             	mov    %ebx,(%esp)
  801929:	e8 90 fb ff ff       	call   8014be <fd_lookup>
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 61                	js     801993 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801932:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	8b 00                	mov    (%eax),%eax
  80193e:	89 04 24             	mov    %eax,(%esp)
  801941:	e8 c9 fb ff ff       	call   80150f <dev_lookup>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 49                	js     801993 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801951:	75 23                	jne    801976 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801953:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801958:	8b 40 48             	mov    0x48(%eax),%eax
  80195b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  80196a:	e8 20 e9 ff ff       	call   80028f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80196f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801974:	eb 1d                	jmp    801993 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801979:	8b 52 18             	mov    0x18(%edx),%edx
  80197c:	85 d2                	test   %edx,%edx
  80197e:	74 0e                	je     80198e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801980:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801983:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801987:	89 04 24             	mov    %eax,(%esp)
  80198a:	ff d2                	call   *%edx
  80198c:	eb 05                	jmp    801993 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80198e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801993:	83 c4 24             	add    $0x24,%esp
  801996:	5b                   	pop    %ebx
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	53                   	push   %ebx
  80199d:	83 ec 24             	sub    $0x24,%esp
  8019a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	89 04 24             	mov    %eax,(%esp)
  8019b0:	e8 09 fb ff ff       	call   8014be <fd_lookup>
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 52                	js     801a0b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 00                	mov    (%eax),%eax
  8019c5:	89 04 24             	mov    %eax,(%esp)
  8019c8:	e8 42 fb ff ff       	call   80150f <dev_lookup>
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 3a                	js     801a0b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d8:	74 2c                	je     801a06 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019e4:	00 00 00 
	stat->st_isdir = 0;
  8019e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019ee:	00 00 00 
	stat->st_dev = dev;
  8019f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019fe:	89 14 24             	mov    %edx,(%esp)
  801a01:	ff 50 14             	call   *0x14(%eax)
  801a04:	eb 05                	jmp    801a0b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a0b:	83 c4 24             	add    $0x24,%esp
  801a0e:	5b                   	pop    %ebx
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    

00801a11 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 18             	sub    $0x18,%esp
  801a17:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a1a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a24:	00 
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	89 04 24             	mov    %eax,(%esp)
  801a2b:	e8 bc 01 00 00       	call   801bec <open>
  801a30:	89 c3                	mov    %eax,%ebx
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1b                	js     801a51 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3d:	89 1c 24             	mov    %ebx,(%esp)
  801a40:	e8 54 ff ff ff       	call   801999 <fstat>
  801a45:	89 c6                	mov    %eax,%esi
	close(fd);
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 be fb ff ff       	call   80160d <close>
	return r;
  801a4f:	89 f3                	mov    %esi,%ebx
}
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a56:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a59:	89 ec                	mov    %ebp,%esp
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    
  801a5d:	00 00                	add    %al,(%eax)
	...

00801a60 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 18             	sub    $0x18,%esp
  801a66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a69:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a70:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a77:	75 11                	jne    801a8a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a80:	e8 01 09 00 00       	call   802386 <ipc_find_env>
  801a85:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a8a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a91:	00 
  801a92:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801a99:	00 
  801a9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9e:	a1 00 40 80 00       	mov    0x804000,%eax
  801aa3:	89 04 24             	mov    %eax,(%esp)
  801aa6:	e8 57 08 00 00       	call   802302 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ab2:	00 
  801ab3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ab7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abe:	e8 ed 07 00 00       	call   8022b0 <ipc_recv>
}
  801ac3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ac6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ac9:	89 ec                	mov    %ebp,%esp
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    

00801acd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	53                   	push   %ebx
  801ad1:	83 ec 14             	sub    $0x14,%esp
  801ad4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	8b 40 0c             	mov    0xc(%eax),%eax
  801add:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae7:	b8 05 00 00 00       	mov    $0x5,%eax
  801aec:	e8 6f ff ff ff       	call   801a60 <fsipc>
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 2b                	js     801b20 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801af5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801afc:	00 
  801afd:	89 1c 24             	mov    %ebx,(%esp)
  801b00:	e8 a6 ed ff ff       	call   8008ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b05:	a1 80 50 80 00       	mov    0x805080,%eax
  801b0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b10:	a1 84 50 80 00       	mov    0x805084,%eax
  801b15:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b20:	83 c4 14             	add    $0x14,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b32:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b37:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3c:	b8 06 00 00 00       	mov    $0x6,%eax
  801b41:	e8 1a ff ff ff       	call   801a60 <fsipc>
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
  801b4d:	83 ec 10             	sub    $0x10,%esp
  801b50:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	8b 40 0c             	mov    0xc(%eax),%eax
  801b59:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b5e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
  801b69:	b8 03 00 00 00       	mov    $0x3,%eax
  801b6e:	e8 ed fe ff ff       	call   801a60 <fsipc>
  801b73:	89 c3                	mov    %eax,%ebx
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 6a                	js     801be3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b79:	39 c6                	cmp    %eax,%esi
  801b7b:	73 24                	jae    801ba1 <devfile_read+0x59>
  801b7d:	c7 44 24 0c 9c 2c 80 	movl   $0x802c9c,0xc(%esp)
  801b84:	00 
  801b85:	c7 44 24 08 a3 2c 80 	movl   $0x802ca3,0x8(%esp)
  801b8c:	00 
  801b8d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b94:	00 
  801b95:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  801b9c:	e8 f3 e5 ff ff       	call   800194 <_panic>
	assert(r <= PGSIZE);
  801ba1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ba6:	7e 24                	jle    801bcc <devfile_read+0x84>
  801ba8:	c7 44 24 0c c3 2c 80 	movl   $0x802cc3,0xc(%esp)
  801baf:	00 
  801bb0:	c7 44 24 08 a3 2c 80 	movl   $0x802ca3,0x8(%esp)
  801bb7:	00 
  801bb8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801bbf:	00 
  801bc0:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  801bc7:	e8 c8 e5 ff ff       	call   800194 <_panic>
	memmove(buf, &fsipcbuf, r);
  801bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801bd7:	00 
  801bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdb:	89 04 24             	mov    %eax,(%esp)
  801bde:	e8 b9 ee ff ff       	call   800a9c <memmove>
	return r;
}
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 20             	sub    $0x20,%esp
  801bf4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bf7:	89 34 24             	mov    %esi,(%esp)
  801bfa:	e8 61 ec ff ff       	call   800860 <strlen>
		return -E_BAD_PATH;
  801bff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c09:	7f 5e                	jg     801c69 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 35 f8 ff ff       	call   80144b <fd_alloc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 4d                	js     801c69 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c20:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801c27:	e8 7f ec ff ff       	call   8008ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c37:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3c:	e8 1f fe ff ff       	call   801a60 <fsipc>
  801c41:	89 c3                	mov    %eax,%ebx
  801c43:	85 c0                	test   %eax,%eax
  801c45:	79 15                	jns    801c5c <open+0x70>
		fd_close(fd, 0);
  801c47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c4e:	00 
  801c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	e8 21 f9 ff ff       	call   80157b <fd_close>
		return r;
  801c5a:	eb 0d                	jmp    801c69 <open+0x7d>
	}

	return fd2num(fd);
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	89 04 24             	mov    %eax,(%esp)
  801c62:	e8 b9 f7 ff ff       	call   801420 <fd2num>
  801c67:	89 c3                	mov    %eax,%ebx
}
  801c69:	89 d8                	mov    %ebx,%eax
  801c6b:	83 c4 20             	add    $0x20,%esp
  801c6e:	5b                   	pop    %ebx
  801c6f:	5e                   	pop    %esi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    
	...

00801c80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
  801c86:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c89:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	e8 96 f7 ff ff       	call   801430 <fd2data>
  801c9a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801c9c:	c7 44 24 04 cf 2c 80 	movl   $0x802ccf,0x4(%esp)
  801ca3:	00 
  801ca4:	89 34 24             	mov    %esi,(%esp)
  801ca7:	e8 ff eb ff ff       	call   8008ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cac:	8b 43 04             	mov    0x4(%ebx),%eax
  801caf:	2b 03                	sub    (%ebx),%eax
  801cb1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801cb7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801cbe:	00 00 00 
	stat->st_dev = &devpipe;
  801cc1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801cc8:	30 80 00 
	return 0;
}
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cd3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cd6:	89 ec                	mov    %ebp,%esp
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    

00801cda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 14             	sub    $0x14,%esp
  801ce1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cef:	e8 75 f1 ff ff       	call   800e69 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf4:	89 1c 24             	mov    %ebx,(%esp)
  801cf7:	e8 34 f7 ff ff       	call   801430 <fd2data>
  801cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d07:	e8 5d f1 ff ff       	call   800e69 <sys_page_unmap>
}
  801d0c:	83 c4 14             	add    $0x14,%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 2c             	sub    $0x2c,%esp
  801d1b:	89 c7                	mov    %eax,%edi
  801d1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d20:	a1 08 40 80 00       	mov    0x804008,%eax
  801d25:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d28:	89 3c 24             	mov    %edi,(%esp)
  801d2b:	e8 a0 06 00 00       	call   8023d0 <pageref>
  801d30:	89 c6                	mov    %eax,%esi
  801d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d35:	89 04 24             	mov    %eax,(%esp)
  801d38:	e8 93 06 00 00       	call   8023d0 <pageref>
  801d3d:	39 c6                	cmp    %eax,%esi
  801d3f:	0f 94 c0             	sete   %al
  801d42:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801d45:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d4b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d4e:	39 cb                	cmp    %ecx,%ebx
  801d50:	75 08                	jne    801d5a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801d52:	83 c4 2c             	add    $0x2c,%esp
  801d55:	5b                   	pop    %ebx
  801d56:	5e                   	pop    %esi
  801d57:	5f                   	pop    %edi
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801d5a:	83 f8 01             	cmp    $0x1,%eax
  801d5d:	75 c1                	jne    801d20 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d5f:	8b 52 58             	mov    0x58(%edx),%edx
  801d62:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d66:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d6e:	c7 04 24 d6 2c 80 00 	movl   $0x802cd6,(%esp)
  801d75:	e8 15 e5 ff ff       	call   80028f <cprintf>
  801d7a:	eb a4                	jmp    801d20 <_pipeisclosed+0xe>

00801d7c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	57                   	push   %edi
  801d80:	56                   	push   %esi
  801d81:	53                   	push   %ebx
  801d82:	83 ec 2c             	sub    $0x2c,%esp
  801d85:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801d88:	89 34 24             	mov    %esi,(%esp)
  801d8b:	e8 a0 f6 ff ff       	call   801430 <fd2data>
  801d90:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d92:	bf 00 00 00 00       	mov    $0x0,%edi
  801d97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d9b:	75 50                	jne    801ded <devpipe_write+0x71>
  801d9d:	eb 5c                	jmp    801dfb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801d9f:	89 da                	mov    %ebx,%edx
  801da1:	89 f0                	mov    %esi,%eax
  801da3:	e8 6a ff ff ff       	call   801d12 <_pipeisclosed>
  801da8:	85 c0                	test   %eax,%eax
  801daa:	75 53                	jne    801dff <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801dac:	e8 cb ef ff ff       	call   800d7c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db1:	8b 43 04             	mov    0x4(%ebx),%eax
  801db4:	8b 13                	mov    (%ebx),%edx
  801db6:	83 c2 20             	add    $0x20,%edx
  801db9:	39 d0                	cmp    %edx,%eax
  801dbb:	73 e2                	jae    801d9f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801dc4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801dc7:	89 c2                	mov    %eax,%edx
  801dc9:	c1 fa 1f             	sar    $0x1f,%edx
  801dcc:	c1 ea 1b             	shr    $0x1b,%edx
  801dcf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801dd2:	83 e1 1f             	and    $0x1f,%ecx
  801dd5:	29 d1                	sub    %edx,%ecx
  801dd7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ddb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ddf:	83 c0 01             	add    $0x1,%eax
  801de2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801de5:	83 c7 01             	add    $0x1,%edi
  801de8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801deb:	74 0e                	je     801dfb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ded:	8b 43 04             	mov    0x4(%ebx),%eax
  801df0:	8b 13                	mov    (%ebx),%edx
  801df2:	83 c2 20             	add    $0x20,%edx
  801df5:	39 d0                	cmp    %edx,%eax
  801df7:	73 a6                	jae    801d9f <devpipe_write+0x23>
  801df9:	eb c2                	jmp    801dbd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801dfb:	89 f8                	mov    %edi,%eax
  801dfd:	eb 05                	jmp    801e04 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e04:	83 c4 2c             	add    $0x2c,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 28             	sub    $0x28,%esp
  801e12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801e15:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801e18:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801e1b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e1e:	89 3c 24             	mov    %edi,(%esp)
  801e21:	e8 0a f6 ff ff       	call   801430 <fd2data>
  801e26:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e28:	be 00 00 00 00       	mov    $0x0,%esi
  801e2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e31:	75 47                	jne    801e7a <devpipe_read+0x6e>
  801e33:	eb 52                	jmp    801e87 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e35:	89 f0                	mov    %esi,%eax
  801e37:	eb 5e                	jmp    801e97 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	89 f8                	mov    %edi,%eax
  801e3d:	8d 76 00             	lea    0x0(%esi),%esi
  801e40:	e8 cd fe ff ff       	call   801d12 <_pipeisclosed>
  801e45:	85 c0                	test   %eax,%eax
  801e47:	75 49                	jne    801e92 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e49:	e8 2e ef ff ff       	call   800d7c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e4e:	8b 03                	mov    (%ebx),%eax
  801e50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e53:	74 e4                	je     801e39 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e55:	89 c2                	mov    %eax,%edx
  801e57:	c1 fa 1f             	sar    $0x1f,%edx
  801e5a:	c1 ea 1b             	shr    $0x1b,%edx
  801e5d:	01 d0                	add    %edx,%eax
  801e5f:	83 e0 1f             	and    $0x1f,%eax
  801e62:	29 d0                	sub    %edx,%eax
  801e64:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801e6f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e72:	83 c6 01             	add    $0x1,%esi
  801e75:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e78:	74 0d                	je     801e87 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801e7a:	8b 03                	mov    (%ebx),%eax
  801e7c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e7f:	75 d4                	jne    801e55 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e81:	85 f6                	test   %esi,%esi
  801e83:	75 b0                	jne    801e35 <devpipe_read+0x29>
  801e85:	eb b2                	jmp    801e39 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e87:	89 f0                	mov    %esi,%eax
  801e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e90:	eb 05                	jmp    801e97 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e97:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e9a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e9d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ea0:	89 ec                	mov    %ebp,%esp
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 48             	sub    $0x48,%esp
  801eaa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ead:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801eb0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801eb3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801eb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801eb9:	89 04 24             	mov    %eax,(%esp)
  801ebc:	e8 8a f5 ff ff       	call   80144b <fd_alloc>
  801ec1:	89 c3                	mov    %eax,%ebx
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 88 45 01 00 00    	js     802010 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ed2:	00 
  801ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee1:	e8 c6 ee ff ff       	call   800dac <sys_page_alloc>
  801ee6:	89 c3                	mov    %eax,%ebx
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	0f 88 20 01 00 00    	js     802010 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ef0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ef3:	89 04 24             	mov    %eax,(%esp)
  801ef6:	e8 50 f5 ff ff       	call   80144b <fd_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 f8 00 00 00    	js     801ffd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f05:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f0c:	00 
  801f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1b:	e8 8c ee ff ff       	call   800dac <sys_page_alloc>
  801f20:	89 c3                	mov    %eax,%ebx
  801f22:	85 c0                	test   %eax,%eax
  801f24:	0f 88 d3 00 00 00    	js     801ffd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2d:	89 04 24             	mov    %eax,(%esp)
  801f30:	e8 fb f4 ff ff       	call   801430 <fd2data>
  801f35:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f37:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f3e:	00 
  801f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4a:	e8 5d ee ff ff       	call   800dac <sys_page_alloc>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	85 c0                	test   %eax,%eax
  801f53:	0f 88 91 00 00 00    	js     801fea <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f5c:	89 04 24             	mov    %eax,(%esp)
  801f5f:	e8 cc f4 ff ff       	call   801430 <fd2data>
  801f64:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f6b:	00 
  801f6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f77:	00 
  801f78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f83:	e8 83 ee ff ff       	call   800e0b <sys_page_map>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 4c                	js     801fda <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f8e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f97:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fa3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fac:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fbb:	89 04 24             	mov    %eax,(%esp)
  801fbe:	e8 5d f4 ff ff       	call   801420 <fd2num>
  801fc3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801fc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fc8:	89 04 24             	mov    %eax,(%esp)
  801fcb:	e8 50 f4 ff ff       	call   801420 <fd2num>
  801fd0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801fd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd8:	eb 36                	jmp    802010 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801fda:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe5:	e8 7f ee ff ff       	call   800e69 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff8:	e8 6c ee ff ff       	call   800e69 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200b:	e8 59 ee ff ff       	call   800e69 <sys_page_unmap>
    err:
	return r;
}
  802010:	89 d8                	mov    %ebx,%eax
  802012:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802015:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802018:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80201b:	89 ec                	mov    %ebp,%esp
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802025:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802028:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 87 f4 ff ff       	call   8014be <fd_lookup>
  802037:	85 c0                	test   %eax,%eax
  802039:	78 15                	js     802050 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 ea f3 ff ff       	call   801430 <fd2data>
	return _pipeisclosed(fd, p);
  802046:	89 c2                	mov    %eax,%edx
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	e8 c2 fc ff ff       	call   801d12 <_pipeisclosed>
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    
	...

00802060 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    

0080206a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802070:	c7 44 24 04 ee 2c 80 	movl   $0x802cee,0x4(%esp)
  802077:	00 
  802078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207b:	89 04 24             	mov    %eax,(%esp)
  80207e:	e8 28 e8 ff ff       	call   8008ab <strcpy>
	return 0;
}
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	57                   	push   %edi
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802096:	be 00 00 00 00       	mov    $0x0,%esi
  80209b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80209f:	74 43                	je     8020e4 <devcons_write+0x5a>
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020af:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8020b1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020b9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c0:	03 45 0c             	add    0xc(%ebp),%eax
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	89 3c 24             	mov    %edi,(%esp)
  8020ca:	e8 cd e9 ff ff       	call   800a9c <memmove>
		sys_cputs(buf, m);
  8020cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020d3:	89 3c 24             	mov    %edi,(%esp)
  8020d6:	e8 b5 eb ff ff       	call   800c90 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020db:	01 de                	add    %ebx,%esi
  8020dd:	89 f0                	mov    %esi,%eax
  8020df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e2:	72 c8                	jb     8020ac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020e4:	89 f0                	mov    %esi,%eax
  8020e6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	5f                   	pop    %edi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    

008020f1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802100:	75 07                	jne    802109 <devcons_read+0x18>
  802102:	eb 31                	jmp    802135 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802104:	e8 73 ec ff ff       	call   800d7c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802110:	e8 aa eb ff ff       	call   800cbf <sys_cgetc>
  802115:	85 c0                	test   %eax,%eax
  802117:	74 eb                	je     802104 <devcons_read+0x13>
  802119:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 16                	js     802135 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80211f:	83 f8 04             	cmp    $0x4,%eax
  802122:	74 0c                	je     802130 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802124:	8b 45 0c             	mov    0xc(%ebp),%eax
  802127:	88 10                	mov    %dl,(%eax)
	return 1;
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	eb 05                	jmp    802135 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802143:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80214a:	00 
  80214b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80214e:	89 04 24             	mov    %eax,(%esp)
  802151:	e8 3a eb ff ff       	call   800c90 <sys_cputs>
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <getchar>:

int
getchar(void)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80215e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802165:	00 
  802166:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802174:	e8 05 f6 ff ff       	call   80177e <read>
	if (r < 0)
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 0f                	js     80218c <getchar+0x34>
		return r;
	if (r < 1)
  80217d:	85 c0                	test   %eax,%eax
  80217f:	7e 06                	jle    802187 <getchar+0x2f>
		return -E_EOF;
	return c;
  802181:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802185:	eb 05                	jmp    80218c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802187:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802194:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 18 f3 ff ff       	call   8014be <fd_lookup>
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 11                	js     8021bb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021b3:	39 10                	cmp    %edx,(%eax)
  8021b5:	0f 94 c0             	sete   %al
  8021b8:	0f b6 c0             	movzbl %al,%eax
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <opencons>:

int
opencons(void)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c6:	89 04 24             	mov    %eax,(%esp)
  8021c9:	e8 7d f2 ff ff       	call   80144b <fd_alloc>
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 3c                	js     80220e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d9:	00 
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e8:	e8 bf eb ff ff       	call   800dac <sys_page_alloc>
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	78 1d                	js     80220e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021f1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802206:	89 04 24             	mov    %eax,(%esp)
  802209:	e8 12 f2 ff ff       	call   801420 <fd2num>
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802216:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80221d:	75 54                	jne    802273 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80221f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802226:	00 
  802227:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80222e:	ee 
  80222f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802236:	e8 71 eb ff ff       	call   800dac <sys_page_alloc>
  80223b:	85 c0                	test   %eax,%eax
  80223d:	79 20                	jns    80225f <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  80223f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802243:	c7 44 24 08 fa 2c 80 	movl   $0x802cfa,0x8(%esp)
  80224a:	00 
  80224b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  802252:	00 
  802253:	c7 04 24 12 2d 80 00 	movl   $0x802d12,(%esp)
  80225a:	e8 35 df ff ff       	call   800194 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80225f:	c7 44 24 04 80 22 80 	movl   $0x802280,0x4(%esp)
  802266:	00 
  802267:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80226e:	e8 10 ed ff ff       	call   800f83 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    
  80227d:	00 00                	add    %al,(%eax)
	...

00802280 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802280:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802281:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802286:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802288:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  80228b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80228f:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802292:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  802296:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80229a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80229c:	83 c4 08             	add    $0x8,%esp
	popal
  80229f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8022a0:	83 c4 04             	add    $0x4,%esp
	popfl
  8022a3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8022a4:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8022a5:	c3                   	ret    
	...

008022b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 10             	sub    $0x10,%esp
  8022b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  8022c1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  8022c3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022c8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 42 ed ff ff       	call   801015 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8022d3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8022d8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 0e                	js     8022ef <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8022e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8022e9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8022ec:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8022ef:	85 f6                	test   %esi,%esi
  8022f1:	74 02                	je     8022f5 <ipc_recv+0x45>
		*from_env_store = sender;
  8022f3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8022f5:	85 db                	test   %ebx,%ebx
  8022f7:	74 02                	je     8022fb <ipc_recv+0x4b>
		*perm_store = perm;
  8022f9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8022fb:	83 c4 10             	add    $0x10,%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5d                   	pop    %ebp
  802301:	c3                   	ret    

00802302 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 1c             	sub    $0x1c,%esp
  80230b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802311:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802314:	85 db                	test   %ebx,%ebx
  802316:	75 04                	jne    80231c <ipc_send+0x1a>
  802318:	85 f6                	test   %esi,%esi
  80231a:	75 15                	jne    802331 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80231c:	85 db                	test   %ebx,%ebx
  80231e:	74 16                	je     802336 <ipc_send+0x34>
  802320:	85 f6                	test   %esi,%esi
  802322:	0f 94 c0             	sete   %al
      pg = 0;
  802325:	84 c0                	test   %al,%al
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	0f 45 d8             	cmovne %eax,%ebx
  80232f:	eb 05                	jmp    802336 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802331:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802336:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80233a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	89 04 24             	mov    %eax,(%esp)
  802348:	e8 94 ec ff ff       	call   800fe1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80234d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802350:	75 07                	jne    802359 <ipc_send+0x57>
           sys_yield();
  802352:	e8 25 ea ff ff       	call   800d7c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802357:	eb dd                	jmp    802336 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802359:	85 c0                	test   %eax,%eax
  80235b:	90                   	nop
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	74 1c                	je     80237e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802362:	c7 44 24 08 20 2d 80 	movl   $0x802d20,0x8(%esp)
  802369:	00 
  80236a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802371:	00 
  802372:	c7 04 24 2a 2d 80 00 	movl   $0x802d2a,(%esp)
  802379:	e8 16 de ff ff       	call   800194 <_panic>
		}
    }
}
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    

00802386 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80238c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802391:	39 c8                	cmp    %ecx,%eax
  802393:	74 17                	je     8023ac <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802395:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80239a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80239d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023a3:	8b 52 50             	mov    0x50(%edx),%edx
  8023a6:	39 ca                	cmp    %ecx,%edx
  8023a8:	75 14                	jne    8023be <ipc_find_env+0x38>
  8023aa:	eb 05                	jmp    8023b1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8023b1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023b4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023b9:	8b 40 40             	mov    0x40(%eax),%eax
  8023bc:	eb 0e                	jmp    8023cc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023be:	83 c0 01             	add    $0x1,%eax
  8023c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023c6:	75 d2                	jne    80239a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023c8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    
	...

008023d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d6:	89 d0                	mov    %edx,%eax
  8023d8:	c1 e8 16             	shr    $0x16,%eax
  8023db:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e7:	f6 c1 01             	test   $0x1,%cl
  8023ea:	74 1d                	je     802409 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023ec:	c1 ea 0c             	shr    $0xc,%edx
  8023ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023f6:	f6 c2 01             	test   $0x1,%dl
  8023f9:	74 0e                	je     802409 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023fb:	c1 ea 0c             	shr    $0xc,%edx
  8023fe:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802405:	ef 
  802406:	0f b7 c0             	movzwl %ax,%eax
}
  802409:	5d                   	pop    %ebp
  80240a:	c3                   	ret    
  80240b:	00 00                	add    %al,(%eax)
  80240d:	00 00                	add    %al,(%eax)
	...

00802410 <__udivdi3>:
  802410:	83 ec 1c             	sub    $0x1c,%esp
  802413:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802417:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80241b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80241f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802423:	89 74 24 10          	mov    %esi,0x10(%esp)
  802427:	8b 74 24 24          	mov    0x24(%esp),%esi
  80242b:	85 ff                	test   %edi,%edi
  80242d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802431:	89 44 24 08          	mov    %eax,0x8(%esp)
  802435:	89 cd                	mov    %ecx,%ebp
  802437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243b:	75 33                	jne    802470 <__udivdi3+0x60>
  80243d:	39 f1                	cmp    %esi,%ecx
  80243f:	77 57                	ja     802498 <__udivdi3+0x88>
  802441:	85 c9                	test   %ecx,%ecx
  802443:	75 0b                	jne    802450 <__udivdi3+0x40>
  802445:	b8 01 00 00 00       	mov    $0x1,%eax
  80244a:	31 d2                	xor    %edx,%edx
  80244c:	f7 f1                	div    %ecx
  80244e:	89 c1                	mov    %eax,%ecx
  802450:	89 f0                	mov    %esi,%eax
  802452:	31 d2                	xor    %edx,%edx
  802454:	f7 f1                	div    %ecx
  802456:	89 c6                	mov    %eax,%esi
  802458:	8b 44 24 04          	mov    0x4(%esp),%eax
  80245c:	f7 f1                	div    %ecx
  80245e:	89 f2                	mov    %esi,%edx
  802460:	8b 74 24 10          	mov    0x10(%esp),%esi
  802464:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802468:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80246c:	83 c4 1c             	add    $0x1c,%esp
  80246f:	c3                   	ret    
  802470:	31 d2                	xor    %edx,%edx
  802472:	31 c0                	xor    %eax,%eax
  802474:	39 f7                	cmp    %esi,%edi
  802476:	77 e8                	ja     802460 <__udivdi3+0x50>
  802478:	0f bd cf             	bsr    %edi,%ecx
  80247b:	83 f1 1f             	xor    $0x1f,%ecx
  80247e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802482:	75 2c                	jne    8024b0 <__udivdi3+0xa0>
  802484:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802488:	76 04                	jbe    80248e <__udivdi3+0x7e>
  80248a:	39 f7                	cmp    %esi,%edi
  80248c:	73 d2                	jae    802460 <__udivdi3+0x50>
  80248e:	31 d2                	xor    %edx,%edx
  802490:	b8 01 00 00 00       	mov    $0x1,%eax
  802495:	eb c9                	jmp    802460 <__udivdi3+0x50>
  802497:	90                   	nop
  802498:	89 f2                	mov    %esi,%edx
  80249a:	f7 f1                	div    %ecx
  80249c:	31 d2                	xor    %edx,%edx
  80249e:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024a2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024a6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	c3                   	ret    
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024b5:	b8 20 00 00 00       	mov    $0x20,%eax
  8024ba:	89 ea                	mov    %ebp,%edx
  8024bc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024c0:	d3 e7                	shl    %cl,%edi
  8024c2:	89 c1                	mov    %eax,%ecx
  8024c4:	d3 ea                	shr    %cl,%edx
  8024c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024cb:	09 fa                	or     %edi,%edx
  8024cd:	89 f7                	mov    %esi,%edi
  8024cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024d3:	89 f2                	mov    %esi,%edx
  8024d5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8024d9:	d3 e5                	shl    %cl,%ebp
  8024db:	89 c1                	mov    %eax,%ecx
  8024dd:	d3 ef                	shr    %cl,%edi
  8024df:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024e4:	d3 e2                	shl    %cl,%edx
  8024e6:	89 c1                	mov    %eax,%ecx
  8024e8:	d3 ee                	shr    %cl,%esi
  8024ea:	09 d6                	or     %edx,%esi
  8024ec:	89 fa                	mov    %edi,%edx
  8024ee:	89 f0                	mov    %esi,%eax
  8024f0:	f7 74 24 0c          	divl   0xc(%esp)
  8024f4:	89 d7                	mov    %edx,%edi
  8024f6:	89 c6                	mov    %eax,%esi
  8024f8:	f7 e5                	mul    %ebp
  8024fa:	39 d7                	cmp    %edx,%edi
  8024fc:	72 22                	jb     802520 <__udivdi3+0x110>
  8024fe:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802502:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802507:	d3 e5                	shl    %cl,%ebp
  802509:	39 c5                	cmp    %eax,%ebp
  80250b:	73 04                	jae    802511 <__udivdi3+0x101>
  80250d:	39 d7                	cmp    %edx,%edi
  80250f:	74 0f                	je     802520 <__udivdi3+0x110>
  802511:	89 f0                	mov    %esi,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	e9 46 ff ff ff       	jmp    802460 <__udivdi3+0x50>
  80251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802520:	8d 46 ff             	lea    -0x1(%esi),%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	8b 74 24 10          	mov    0x10(%esp),%esi
  802529:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80252d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802531:	83 c4 1c             	add    $0x1c,%esp
  802534:	c3                   	ret    
	...

00802540 <__umoddi3>:
  802540:	83 ec 1c             	sub    $0x1c,%esp
  802543:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802547:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80254b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80254f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802553:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802557:	8b 74 24 24          	mov    0x24(%esp),%esi
  80255b:	85 ed                	test   %ebp,%ebp
  80255d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802561:	89 44 24 08          	mov    %eax,0x8(%esp)
  802565:	89 cf                	mov    %ecx,%edi
  802567:	89 04 24             	mov    %eax,(%esp)
  80256a:	89 f2                	mov    %esi,%edx
  80256c:	75 1a                	jne    802588 <__umoddi3+0x48>
  80256e:	39 f1                	cmp    %esi,%ecx
  802570:	76 4e                	jbe    8025c0 <__umoddi3+0x80>
  802572:	f7 f1                	div    %ecx
  802574:	89 d0                	mov    %edx,%eax
  802576:	31 d2                	xor    %edx,%edx
  802578:	8b 74 24 10          	mov    0x10(%esp),%esi
  80257c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802580:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802584:	83 c4 1c             	add    $0x1c,%esp
  802587:	c3                   	ret    
  802588:	39 f5                	cmp    %esi,%ebp
  80258a:	77 54                	ja     8025e0 <__umoddi3+0xa0>
  80258c:	0f bd c5             	bsr    %ebp,%eax
  80258f:	83 f0 1f             	xor    $0x1f,%eax
  802592:	89 44 24 04          	mov    %eax,0x4(%esp)
  802596:	75 60                	jne    8025f8 <__umoddi3+0xb8>
  802598:	3b 0c 24             	cmp    (%esp),%ecx
  80259b:	0f 87 07 01 00 00    	ja     8026a8 <__umoddi3+0x168>
  8025a1:	89 f2                	mov    %esi,%edx
  8025a3:	8b 34 24             	mov    (%esp),%esi
  8025a6:	29 ce                	sub    %ecx,%esi
  8025a8:	19 ea                	sbb    %ebp,%edx
  8025aa:	89 34 24             	mov    %esi,(%esp)
  8025ad:	8b 04 24             	mov    (%esp),%eax
  8025b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025b8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	c3                   	ret    
  8025c0:	85 c9                	test   %ecx,%ecx
  8025c2:	75 0b                	jne    8025cf <__umoddi3+0x8f>
  8025c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c9:	31 d2                	xor    %edx,%edx
  8025cb:	f7 f1                	div    %ecx
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 f0                	mov    %esi,%eax
  8025d1:	31 d2                	xor    %edx,%edx
  8025d3:	f7 f1                	div    %ecx
  8025d5:	8b 04 24             	mov    (%esp),%eax
  8025d8:	f7 f1                	div    %ecx
  8025da:	eb 98                	jmp    802574 <__umoddi3+0x34>
  8025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	89 f2                	mov    %esi,%edx
  8025e2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025e6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ea:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	c3                   	ret    
  8025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025f8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025fd:	89 e8                	mov    %ebp,%eax
  8025ff:	bd 20 00 00 00       	mov    $0x20,%ebp
  802604:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802608:	89 fa                	mov    %edi,%edx
  80260a:	d3 e0                	shl    %cl,%eax
  80260c:	89 e9                	mov    %ebp,%ecx
  80260e:	d3 ea                	shr    %cl,%edx
  802610:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802615:	09 c2                	or     %eax,%edx
  802617:	8b 44 24 08          	mov    0x8(%esp),%eax
  80261b:	89 14 24             	mov    %edx,(%esp)
  80261e:	89 f2                	mov    %esi,%edx
  802620:	d3 e7                	shl    %cl,%edi
  802622:	89 e9                	mov    %ebp,%ecx
  802624:	d3 ea                	shr    %cl,%edx
  802626:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80262f:	d3 e6                	shl    %cl,%esi
  802631:	89 e9                	mov    %ebp,%ecx
  802633:	d3 e8                	shr    %cl,%eax
  802635:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80263a:	09 f0                	or     %esi,%eax
  80263c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802640:	f7 34 24             	divl   (%esp)
  802643:	d3 e6                	shl    %cl,%esi
  802645:	89 74 24 08          	mov    %esi,0x8(%esp)
  802649:	89 d6                	mov    %edx,%esi
  80264b:	f7 e7                	mul    %edi
  80264d:	39 d6                	cmp    %edx,%esi
  80264f:	89 c1                	mov    %eax,%ecx
  802651:	89 d7                	mov    %edx,%edi
  802653:	72 3f                	jb     802694 <__umoddi3+0x154>
  802655:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802659:	72 35                	jb     802690 <__umoddi3+0x150>
  80265b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80265f:	29 c8                	sub    %ecx,%eax
  802661:	19 fe                	sbb    %edi,%esi
  802663:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802668:	89 f2                	mov    %esi,%edx
  80266a:	d3 e8                	shr    %cl,%eax
  80266c:	89 e9                	mov    %ebp,%ecx
  80266e:	d3 e2                	shl    %cl,%edx
  802670:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802675:	09 d0                	or     %edx,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	d3 ea                	shr    %cl,%edx
  80267b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80267f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802683:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802687:	83 c4 1c             	add    $0x1c,%esp
  80268a:	c3                   	ret    
  80268b:	90                   	nop
  80268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802690:	39 d6                	cmp    %edx,%esi
  802692:	75 c7                	jne    80265b <__umoddi3+0x11b>
  802694:	89 d7                	mov    %edx,%edi
  802696:	89 c1                	mov    %eax,%ecx
  802698:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80269c:	1b 3c 24             	sbb    (%esp),%edi
  80269f:	eb ba                	jmp    80265b <__umoddi3+0x11b>
  8026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	39 f5                	cmp    %esi,%ebp
  8026aa:	0f 82 f1 fe ff ff    	jb     8025a1 <__umoddi3+0x61>
  8026b0:	e9 f8 fe ff ff       	jmp    8025ad <__umoddi3+0x6d>
