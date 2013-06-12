
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 87 01 00 00       	call   8001b8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  80003a:	a1 00 40 80 00       	mov    0x804000,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80004a:	e8 ec 08 00 00       	call   80093b <strcpy>
	exit();
  80004f:	e8 b4 01 00 00       	call   800208 <exit>
}
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	53                   	push   %ebx
  80005a:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800061:	74 05                	je     800068 <umain+0x12>
		childofspawn();
  800063:	e8 cc ff ff ff       	call   800034 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800068:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006f:	00 
  800070:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800077:	a0 
  800078:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007f:	e8 b8 0d 00 00       	call   800e3c <sys_page_alloc>
  800084:	85 c0                	test   %eax,%eax
  800086:	79 20                	jns    8000a8 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008c:	c7 44 24 08 4c 2e 80 	movl   $0x802e4c,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009b:	00 
  80009c:	c7 04 24 5f 2e 80 00 	movl   $0x802e5f,(%esp)
  8000a3:	e8 7c 01 00 00       	call   800224 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a8:	e8 56 11 00 00       	call   801203 <fork>
  8000ad:	89 c3                	mov    %eax,%ebx
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	79 20                	jns    8000d3 <umain+0x7d>
		panic("fork: %e", r);
  8000b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b7:	c7 44 24 08 b5 33 80 	movl   $0x8033b5,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 5f 2e 80 00 	movl   $0x802e5f,(%esp)
  8000ce:	e8 51 01 00 00       	call   800224 <_panic>
	if (r == 0) {
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	75 1a                	jne    8000f1 <umain+0x9b>
		strcpy(VA, msg);
  8000d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8000dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e0:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e7:	e8 4f 08 00 00       	call   80093b <strcpy>
		exit();
  8000ec:	e8 17 01 00 00       	call   800208 <exit>
	}
	wait(r);
  8000f1:	89 1c 24             	mov    %ebx,(%esp)
  8000f4:	e8 7b 26 00 00       	call   802774 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800109:	e8 ed 08 00 00       	call   8009fb <strcmp>
  80010e:	85 c0                	test   %eax,%eax
  800110:	b8 40 2e 80 00       	mov    $0x802e40,%eax
  800115:	ba 46 2e 80 00       	mov    $0x802e46,%edx
  80011a:	0f 45 c2             	cmovne %edx,%eax
  80011d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800121:	c7 04 24 73 2e 80 00 	movl   $0x802e73,(%esp)
  800128:	e8 f2 01 00 00       	call   80031f <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800134:	00 
  800135:	c7 44 24 08 8e 2e 80 	movl   $0x802e8e,0x8(%esp)
  80013c:	00 
  80013d:	c7 44 24 04 93 2e 80 	movl   $0x802e93,0x4(%esp)
  800144:	00 
  800145:	c7 04 24 92 2e 80 00 	movl   $0x802e92,(%esp)
  80014c:	e8 bc 21 00 00       	call   80230d <spawnl>
  800151:	85 c0                	test   %eax,%eax
  800153:	79 20                	jns    800175 <umain+0x11f>
		panic("spawn: %e", r);
  800155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800159:	c7 44 24 08 a0 2e 80 	movl   $0x802ea0,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800168:	00 
  800169:	c7 04 24 5f 2e 80 00 	movl   $0x802e5f,(%esp)
  800170:	e8 af 00 00 00       	call   800224 <_panic>
	wait(r);
  800175:	89 04 24             	mov    %eax,(%esp)
  800178:	e8 f7 25 00 00       	call   802774 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017d:	a1 00 40 80 00       	mov    0x804000,%eax
  800182:	89 44 24 04          	mov    %eax,0x4(%esp)
  800186:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018d:	e8 69 08 00 00       	call   8009fb <strcmp>
  800192:	85 c0                	test   %eax,%eax
  800194:	b8 40 2e 80 00       	mov    $0x802e40,%eax
  800199:	ba 46 2e 80 00       	mov    $0x802e46,%edx
  80019e:	0f 45 c2             	cmovne %edx,%eax
  8001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a5:	c7 04 24 aa 2e 80 00 	movl   $0x802eaa,(%esp)
  8001ac:	e8 6e 01 00 00       	call   80031f <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b1:	cc                   	int3   

	breakpoint();
}
  8001b2:	83 c4 14             	add    $0x14,%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    

008001b8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 18             	sub    $0x18,%esp
  8001be:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001ca:	e8 0d 0c 00 00       	call   800ddc <sys_getenvid>
  8001cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001dc:	a3 04 50 80 00       	mov    %eax,0x805004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e1:	85 f6                	test   %esi,%esi
  8001e3:	7e 07                	jle    8001ec <libmain+0x34>
		binaryname = argv[0];
  8001e5:	8b 03                	mov    (%ebx),%eax
  8001e7:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f0:	89 34 24             	mov    %esi,(%esp)
  8001f3:	e8 5e fe ff ff       	call   800056 <umain>

	// exit gracefully
	exit();
  8001f8:	e8 0b 00 00 00       	call   800208 <exit>
}
  8001fd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800200:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800203:	89 ec                	mov    %ebp,%esp
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
	...

00800208 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80020e:	e8 bb 14 00 00       	call   8016ce <close_all>
	sys_env_destroy(0);
  800213:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80021a:	e8 60 0b 00 00       	call   800d7f <sys_env_destroy>
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    
  800221:	00 00                	add    %al,(%eax)
	...

00800224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80022c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022f:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800235:	e8 a2 0b 00 00       	call   800ddc <sys_getenvid>
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800241:	8b 55 08             	mov    0x8(%ebp),%edx
  800244:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800248:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  800257:	e8 c3 00 00 00       	call   80031f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800260:	8b 45 10             	mov    0x10(%ebp),%eax
  800263:	89 04 24             	mov    %eax,(%esp)
  800266:	e8 53 00 00 00       	call   8002be <vcprintf>
	cprintf("\n");
  80026b:	c7 04 24 60 35 80 00 	movl   $0x803560,(%esp)
  800272:	e8 a8 00 00 00       	call   80031f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800277:	cc                   	int3   
  800278:	eb fd                	jmp    800277 <_panic+0x53>
	...

0080027c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	53                   	push   %ebx
  800280:	83 ec 14             	sub    $0x14,%esp
  800283:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800286:	8b 03                	mov    (%ebx),%eax
  800288:	8b 55 08             	mov    0x8(%ebp),%edx
  80028b:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80028f:	83 c0 01             	add    $0x1,%eax
  800292:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800294:	3d ff 00 00 00       	cmp    $0xff,%eax
  800299:	75 19                	jne    8002b4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80029b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002a2:	00 
  8002a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a6:	89 04 24             	mov    %eax,(%esp)
  8002a9:	e8 72 0a 00 00       	call   800d20 <sys_cputs>
		b->idx = 0;
  8002ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b8:	83 c4 14             	add    $0x14,%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5d                   	pop    %ebp
  8002bd:	c3                   	ret    

008002be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ce:	00 00 00 
	b.cnt = 0;
  8002d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f3:	c7 04 24 7c 02 80 00 	movl   $0x80027c,(%esp)
  8002fa:	e8 9b 01 00 00       	call   80049a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800305:	89 44 24 04          	mov    %eax,0x4(%esp)
  800309:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030f:	89 04 24             	mov    %eax,(%esp)
  800312:	e8 09 0a 00 00       	call   800d20 <sys_cputs>

	return b.cnt;
}
  800317:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800325:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	89 04 24             	mov    %eax,(%esp)
  800332:	e8 87 ff ff ff       	call   8002be <vcprintf>
	va_end(ap);

	return cnt;
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    
  800339:	00 00                	add    %al,(%eax)
  80033b:	00 00                	add    %al,(%eax)
  80033d:	00 00                	add    %al,(%eax)
	...

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 3c             	sub    $0x3c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d7                	mov    %edx,%edi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80035d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800368:	72 11                	jb     80037b <printnum+0x3b>
  80036a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800370:	76 09                	jbe    80037b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800372:	83 eb 01             	sub    $0x1,%ebx
  800375:	85 db                	test   %ebx,%ebx
  800377:	7f 51                	jg     8003ca <printnum+0x8a>
  800379:	eb 5e                	jmp    8003d9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800386:	8b 45 10             	mov    0x10(%ebp),%eax
  800389:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800391:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800395:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80039c:	00 
  80039d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a0:	89 04 24             	mov    %eax,(%esp)
  8003a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003aa:	e8 e1 27 00 00       	call   802b90 <__udivdi3>
  8003af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003b7:	89 04 24             	mov    %eax,(%esp)
  8003ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003be:	89 fa                	mov    %edi,%edx
  8003c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c3:	e8 78 ff ff ff       	call   800340 <printnum>
  8003c8:	eb 0f                	jmp    8003d9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ce:	89 34 24             	mov    %esi,(%esp)
  8003d1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d4:	83 eb 01             	sub    $0x1,%ebx
  8003d7:	75 f1                	jne    8003ca <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003dd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ef:	00 
  8003f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f3:	89 04 24             	mov    %eax,(%esp)
  8003f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fd:	e8 be 28 00 00       	call   802cc0 <__umoddi3>
  800402:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800406:	0f be 80 13 2f 80 00 	movsbl 0x802f13(%eax),%eax
  80040d:	89 04 24             	mov    %eax,(%esp)
  800410:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800413:	83 c4 3c             	add    $0x3c,%esp
  800416:	5b                   	pop    %ebx
  800417:	5e                   	pop    %esi
  800418:	5f                   	pop    %edi
  800419:	5d                   	pop    %ebp
  80041a:	c3                   	ret    

0080041b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041e:	83 fa 01             	cmp    $0x1,%edx
  800421:	7e 0e                	jle    800431 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800423:	8b 10                	mov    (%eax),%edx
  800425:	8d 4a 08             	lea    0x8(%edx),%ecx
  800428:	89 08                	mov    %ecx,(%eax)
  80042a:	8b 02                	mov    (%edx),%eax
  80042c:	8b 52 04             	mov    0x4(%edx),%edx
  80042f:	eb 22                	jmp    800453 <getuint+0x38>
	else if (lflag)
  800431:	85 d2                	test   %edx,%edx
  800433:	74 10                	je     800445 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800435:	8b 10                	mov    (%eax),%edx
  800437:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043a:	89 08                	mov    %ecx,(%eax)
  80043c:	8b 02                	mov    (%edx),%eax
  80043e:	ba 00 00 00 00       	mov    $0x0,%edx
  800443:	eb 0e                	jmp    800453 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800445:	8b 10                	mov    (%eax),%edx
  800447:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044a:	89 08                	mov    %ecx,(%eax)
  80044c:	8b 02                	mov    (%edx),%eax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800453:	5d                   	pop    %ebp
  800454:	c3                   	ret    

00800455 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80045b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80045f:	8b 10                	mov    (%eax),%edx
  800461:	3b 50 04             	cmp    0x4(%eax),%edx
  800464:	73 0a                	jae    800470 <sprintputch+0x1b>
		*b->buf++ = ch;
  800466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800469:	88 0a                	mov    %cl,(%edx)
  80046b:	83 c2 01             	add    $0x1,%edx
  80046e:	89 10                	mov    %edx,(%eax)
}
  800470:	5d                   	pop    %ebp
  800471:	c3                   	ret    

00800472 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800478:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80047b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80047f:	8b 45 10             	mov    0x10(%ebp),%eax
  800482:	89 44 24 08          	mov    %eax,0x8(%esp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	e8 02 00 00 00       	call   80049a <vprintfmt>
	va_end(ap);
}
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	57                   	push   %edi
  80049e:	56                   	push   %esi
  80049f:	53                   	push   %ebx
  8004a0:	83 ec 4c             	sub    $0x4c,%esp
  8004a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a6:	8b 75 10             	mov    0x10(%ebp),%esi
  8004a9:	eb 12                	jmp    8004bd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	0f 84 a9 03 00 00    	je     80085c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8004b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004b7:	89 04 24             	mov    %eax,(%esp)
  8004ba:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bd:	0f b6 06             	movzbl (%esi),%eax
  8004c0:	83 c6 01             	add    $0x1,%esi
  8004c3:	83 f8 25             	cmp    $0x25,%eax
  8004c6:	75 e3                	jne    8004ab <vprintfmt+0x11>
  8004c8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004d3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8004d8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004e7:	eb 2b                	jmp    800514 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ec:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004f0:	eb 22                	jmp    800514 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004f9:	eb 19                	jmp    800514 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800505:	eb 0d                	jmp    800514 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800507:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800514:	0f b6 06             	movzbl (%esi),%eax
  800517:	0f b6 d0             	movzbl %al,%edx
  80051a:	8d 7e 01             	lea    0x1(%esi),%edi
  80051d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800520:	83 e8 23             	sub    $0x23,%eax
  800523:	3c 55                	cmp    $0x55,%al
  800525:	0f 87 0b 03 00 00    	ja     800836 <vprintfmt+0x39c>
  80052b:	0f b6 c0             	movzbl %al,%eax
  80052e:	ff 24 85 60 30 80 00 	jmp    *0x803060(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800535:	83 ea 30             	sub    $0x30,%edx
  800538:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80053b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80053f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800542:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800545:	83 fa 09             	cmp    $0x9,%edx
  800548:	77 4a                	ja     800594 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800550:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800553:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800557:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80055a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80055d:	83 fa 09             	cmp    $0x9,%edx
  800560:	76 eb                	jbe    80054d <vprintfmt+0xb3>
  800562:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800565:	eb 2d                	jmp    800594 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 50 04             	lea    0x4(%eax),%edx
  80056d:	89 55 14             	mov    %edx,0x14(%ebp)
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800578:	eb 1a                	jmp    800594 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80057d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800581:	79 91                	jns    800514 <vprintfmt+0x7a>
  800583:	e9 73 ff ff ff       	jmp    8004fb <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80058b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800592:	eb 80                	jmp    800514 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800594:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800598:	0f 89 76 ff ff ff    	jns    800514 <vprintfmt+0x7a>
  80059e:	e9 64 ff ff ff       	jmp    800507 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005a9:	e9 66 ff ff ff       	jmp    800514 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 50 04             	lea    0x4(%eax),%edx
  8005b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 04 24             	mov    %eax,(%esp)
  8005c0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8005c6:	e9 f2 fe ff ff       	jmp    8004bd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 c2                	mov    %eax,%edx
  8005d8:	c1 fa 1f             	sar    $0x1f,%edx
  8005db:	31 d0                	xor    %edx,%eax
  8005dd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005df:	83 f8 0f             	cmp    $0xf,%eax
  8005e2:	7f 0b                	jg     8005ef <vprintfmt+0x155>
  8005e4:	8b 14 85 c0 31 80 00 	mov    0x8031c0(,%eax,4),%edx
  8005eb:	85 d2                	test   %edx,%edx
  8005ed:	75 23                	jne    800612 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8005ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f3:	c7 44 24 08 2b 2f 80 	movl   $0x802f2b,0x8(%esp)
  8005fa:	00 
  8005fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800602:	89 3c 24             	mov    %edi,(%esp)
  800605:	e8 68 fe ff ff       	call   800472 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80060d:	e9 ab fe ff ff       	jmp    8004bd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800612:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800616:	c7 44 24 08 91 34 80 	movl   $0x803491,0x8(%esp)
  80061d:	00 
  80061e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800622:	8b 7d 08             	mov    0x8(%ebp),%edi
  800625:	89 3c 24             	mov    %edi,(%esp)
  800628:	e8 45 fe ff ff       	call   800472 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800630:	e9 88 fe ff ff       	jmp    8004bd <vprintfmt+0x23>
  800635:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80063b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 50 04             	lea    0x4(%eax),%edx
  800644:	89 55 14             	mov    %edx,0x14(%ebp)
  800647:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800649:	85 f6                	test   %esi,%esi
  80064b:	ba 24 2f 80 00       	mov    $0x802f24,%edx
  800650:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800653:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800657:	7e 06                	jle    80065f <vprintfmt+0x1c5>
  800659:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80065d:	75 10                	jne    80066f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065f:	0f be 06             	movsbl (%esi),%eax
  800662:	83 c6 01             	add    $0x1,%esi
  800665:	85 c0                	test   %eax,%eax
  800667:	0f 85 86 00 00 00    	jne    8006f3 <vprintfmt+0x259>
  80066d:	eb 76                	jmp    8006e5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80066f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800673:	89 34 24             	mov    %esi,(%esp)
  800676:	e8 90 02 00 00       	call   80090b <strnlen>
  80067b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067e:	29 c2                	sub    %eax,%edx
  800680:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800683:	85 d2                	test   %edx,%edx
  800685:	7e d8                	jle    80065f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800687:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80068b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80068e:	89 d6                	mov    %edx,%esi
  800690:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800693:	89 c7                	mov    %eax,%edi
  800695:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800699:	89 3c 24             	mov    %edi,(%esp)
  80069c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069f:	83 ee 01             	sub    $0x1,%esi
  8006a2:	75 f1                	jne    800695 <vprintfmt+0x1fb>
  8006a4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006a7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8006aa:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8006ad:	eb b0                	jmp    80065f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b3:	74 18                	je     8006cd <vprintfmt+0x233>
  8006b5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006b8:	83 fa 5e             	cmp    $0x5e,%edx
  8006bb:	76 10                	jbe    8006cd <vprintfmt+0x233>
					putch('?', putdat);
  8006bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006c1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006c8:	ff 55 08             	call   *0x8(%ebp)
  8006cb:	eb 0a                	jmp    8006d7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8006cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006d1:	89 04 24             	mov    %eax,(%esp)
  8006d4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006db:	0f be 06             	movsbl (%esi),%eax
  8006de:	83 c6 01             	add    $0x1,%esi
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	75 0e                	jne    8006f3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ec:	7f 16                	jg     800704 <vprintfmt+0x26a>
  8006ee:	e9 ca fd ff ff       	jmp    8004bd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	85 ff                	test   %edi,%edi
  8006f5:	78 b8                	js     8006af <vprintfmt+0x215>
  8006f7:	83 ef 01             	sub    $0x1,%edi
  8006fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800700:	79 ad                	jns    8006af <vprintfmt+0x215>
  800702:	eb e1                	jmp    8006e5 <vprintfmt+0x24b>
  800704:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800707:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80070a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80070e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800715:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800717:	83 ee 01             	sub    $0x1,%esi
  80071a:	75 ee                	jne    80070a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80071f:	e9 99 fd ff ff       	jmp    8004bd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800724:	83 f9 01             	cmp    $0x1,%ecx
  800727:	7e 10                	jle    800739 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 50 08             	lea    0x8(%eax),%edx
  80072f:	89 55 14             	mov    %edx,0x14(%ebp)
  800732:	8b 30                	mov    (%eax),%esi
  800734:	8b 78 04             	mov    0x4(%eax),%edi
  800737:	eb 26                	jmp    80075f <vprintfmt+0x2c5>
	else if (lflag)
  800739:	85 c9                	test   %ecx,%ecx
  80073b:	74 12                	je     80074f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 50 04             	lea    0x4(%eax),%edx
  800743:	89 55 14             	mov    %edx,0x14(%ebp)
  800746:	8b 30                	mov    (%eax),%esi
  800748:	89 f7                	mov    %esi,%edi
  80074a:	c1 ff 1f             	sar    $0x1f,%edi
  80074d:	eb 10                	jmp    80075f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 30                	mov    (%eax),%esi
  80075a:	89 f7                	mov    %esi,%edi
  80075c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80075f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800764:	85 ff                	test   %edi,%edi
  800766:	0f 89 8c 00 00 00    	jns    8007f8 <vprintfmt+0x35e>
				putch('-', putdat);
  80076c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800770:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800777:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80077a:	f7 de                	neg    %esi
  80077c:	83 d7 00             	adc    $0x0,%edi
  80077f:	f7 df                	neg    %edi
			}
			base = 10;
  800781:	b8 0a 00 00 00       	mov    $0xa,%eax
  800786:	eb 70                	jmp    8007f8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800788:	89 ca                	mov    %ecx,%edx
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
  80078d:	e8 89 fc ff ff       	call   80041b <getuint>
  800792:	89 c6                	mov    %eax,%esi
  800794:	89 d7                	mov    %edx,%edi
			base = 10;
  800796:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80079b:	eb 5b                	jmp    8007f8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80079d:	89 ca                	mov    %ecx,%edx
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a2:	e8 74 fc ff ff       	call   80041b <getuint>
  8007a7:	89 c6                	mov    %eax,%esi
  8007a9:	89 d7                	mov    %edx,%edi
			base = 8;
  8007ab:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007b0:	eb 46                	jmp    8007f8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007bd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007cb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 50 04             	lea    0x4(%eax),%edx
  8007d4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d7:	8b 30                	mov    (%eax),%esi
  8007d9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007e3:	eb 13                	jmp    8007f8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e5:	89 ca                	mov    %ecx,%edx
  8007e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ea:	e8 2c fc ff ff       	call   80041b <getuint>
  8007ef:	89 c6                	mov    %eax,%esi
  8007f1:	89 d7                	mov    %edx,%edi
			base = 16;
  8007f3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8007fc:	89 54 24 10          	mov    %edx,0x10(%esp)
  800800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800803:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800807:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080b:	89 34 24             	mov    %esi,(%esp)
  80080e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800812:	89 da                	mov    %ebx,%edx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	e8 24 fb ff ff       	call   800340 <printnum>
			break;
  80081c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80081f:	e9 99 fc ff ff       	jmp    8004bd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800824:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800828:	89 14 24             	mov    %edx,(%esp)
  80082b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800831:	e9 87 fc ff ff       	jmp    8004bd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800836:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80083a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800841:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800844:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800848:	0f 84 6f fc ff ff    	je     8004bd <vprintfmt+0x23>
  80084e:	83 ee 01             	sub    $0x1,%esi
  800851:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800855:	75 f7                	jne    80084e <vprintfmt+0x3b4>
  800857:	e9 61 fc ff ff       	jmp    8004bd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80085c:	83 c4 4c             	add    $0x4c,%esp
  80085f:	5b                   	pop    %ebx
  800860:	5e                   	pop    %esi
  800861:	5f                   	pop    %edi
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 28             	sub    $0x28,%esp
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800870:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800873:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800877:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80087a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800881:	85 c0                	test   %eax,%eax
  800883:	74 30                	je     8008b5 <vsnprintf+0x51>
  800885:	85 d2                	test   %edx,%edx
  800887:	7e 2c                	jle    8008b5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800890:	8b 45 10             	mov    0x10(%ebp),%eax
  800893:	89 44 24 08          	mov    %eax,0x8(%esp)
  800897:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089e:	c7 04 24 55 04 80 00 	movl   $0x800455,(%esp)
  8008a5:	e8 f0 fb ff ff       	call   80049a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b3:	eb 05                	jmp    8008ba <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008ba:	c9                   	leave  
  8008bb:	c3                   	ret    

008008bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	89 04 24             	mov    %eax,(%esp)
  8008dd:	e8 82 ff ff ff       	call   800864 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    
	...

008008f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	80 3a 00             	cmpb   $0x0,(%edx)
  8008fe:	74 09                	je     800909 <strlen+0x19>
		n++;
  800900:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	75 f7                	jne    800900 <strlen+0x10>
		n++;
	return n;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
  80091a:	85 c9                	test   %ecx,%ecx
  80091c:	74 1a                	je     800938 <strnlen+0x2d>
  80091e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800921:	74 15                	je     800938 <strnlen+0x2d>
  800923:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800928:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092a:	39 ca                	cmp    %ecx,%edx
  80092c:	74 0a                	je     800938 <strnlen+0x2d>
  80092e:	83 c2 01             	add    $0x1,%edx
  800931:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800936:	75 f0                	jne    800928 <strnlen+0x1d>
		n++;
	return n;
}
  800938:	5b                   	pop    %ebx
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800945:	ba 00 00 00 00       	mov    $0x0,%edx
  80094a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800951:	83 c2 01             	add    $0x1,%edx
  800954:	84 c9                	test   %cl,%cl
  800956:	75 f2                	jne    80094a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800958:	5b                   	pop    %ebx
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800965:	89 1c 24             	mov    %ebx,(%esp)
  800968:	e8 83 ff ff ff       	call   8008f0 <strlen>
	strcpy(dst + len, src);
  80096d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800970:	89 54 24 04          	mov    %edx,0x4(%esp)
  800974:	01 d8                	add    %ebx,%eax
  800976:	89 04 24             	mov    %eax,(%esp)
  800979:	e8 bd ff ff ff       	call   80093b <strcpy>
	return dst;
}
  80097e:	89 d8                	mov    %ebx,%eax
  800980:	83 c4 08             	add    $0x8,%esp
  800983:	5b                   	pop    %ebx
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800994:	85 f6                	test   %esi,%esi
  800996:	74 18                	je     8009b0 <strncpy+0x2a>
  800998:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80099d:	0f b6 1a             	movzbl (%edx),%ebx
  8009a0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a3:	80 3a 01             	cmpb   $0x1,(%edx)
  8009a6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a9:	83 c1 01             	add    $0x1,%ecx
  8009ac:	39 f1                	cmp    %esi,%ecx
  8009ae:	75 ed                	jne    80099d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009c0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c3:	89 f8                	mov    %edi,%eax
  8009c5:	85 f6                	test   %esi,%esi
  8009c7:	74 2b                	je     8009f4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8009c9:	83 fe 01             	cmp    $0x1,%esi
  8009cc:	74 23                	je     8009f1 <strlcpy+0x3d>
  8009ce:	0f b6 0b             	movzbl (%ebx),%ecx
  8009d1:	84 c9                	test   %cl,%cl
  8009d3:	74 1c                	je     8009f1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  8009d5:	83 ee 02             	sub    $0x2,%esi
  8009d8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009dd:	88 08                	mov    %cl,(%eax)
  8009df:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e2:	39 f2                	cmp    %esi,%edx
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x3d>
  8009e6:	83 c2 01             	add    $0x1,%edx
  8009e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ed:	84 c9                	test   %cl,%cl
  8009ef:	75 ec                	jne    8009dd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8009f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f4:	29 f8                	sub    %edi,%eax
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5f                   	pop    %edi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a04:	0f b6 01             	movzbl (%ecx),%eax
  800a07:	84 c0                	test   %al,%al
  800a09:	74 16                	je     800a21 <strcmp+0x26>
  800a0b:	3a 02                	cmp    (%edx),%al
  800a0d:	75 12                	jne    800a21 <strcmp+0x26>
		p++, q++;
  800a0f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a12:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800a16:	84 c0                	test   %al,%al
  800a18:	74 07                	je     800a21 <strcmp+0x26>
  800a1a:	83 c1 01             	add    $0x1,%ecx
  800a1d:	3a 02                	cmp    (%edx),%al
  800a1f:	74 ee                	je     800a0f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a21:	0f b6 c0             	movzbl %al,%eax
  800a24:	0f b6 12             	movzbl (%edx),%edx
  800a27:	29 d0                	sub    %edx,%eax
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	53                   	push   %ebx
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a35:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a3d:	85 d2                	test   %edx,%edx
  800a3f:	74 28                	je     800a69 <strncmp+0x3e>
  800a41:	0f b6 01             	movzbl (%ecx),%eax
  800a44:	84 c0                	test   %al,%al
  800a46:	74 24                	je     800a6c <strncmp+0x41>
  800a48:	3a 03                	cmp    (%ebx),%al
  800a4a:	75 20                	jne    800a6c <strncmp+0x41>
  800a4c:	83 ea 01             	sub    $0x1,%edx
  800a4f:	74 13                	je     800a64 <strncmp+0x39>
		n--, p++, q++;
  800a51:	83 c1 01             	add    $0x1,%ecx
  800a54:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a57:	0f b6 01             	movzbl (%ecx),%eax
  800a5a:	84 c0                	test   %al,%al
  800a5c:	74 0e                	je     800a6c <strncmp+0x41>
  800a5e:	3a 03                	cmp    (%ebx),%al
  800a60:	74 ea                	je     800a4c <strncmp+0x21>
  800a62:	eb 08                	jmp    800a6c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a69:	5b                   	pop    %ebx
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6c:	0f b6 01             	movzbl (%ecx),%eax
  800a6f:	0f b6 13             	movzbl (%ebx),%edx
  800a72:	29 d0                	sub    %edx,%eax
  800a74:	eb f3                	jmp    800a69 <strncmp+0x3e>

00800a76 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a80:	0f b6 10             	movzbl (%eax),%edx
  800a83:	84 d2                	test   %dl,%dl
  800a85:	74 1c                	je     800aa3 <strchr+0x2d>
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	75 09                	jne    800a94 <strchr+0x1e>
  800a8b:	eb 1b                	jmp    800aa8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800a90:	38 ca                	cmp    %cl,%dl
  800a92:	74 14                	je     800aa8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a94:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800a98:	84 d2                	test   %dl,%dl
  800a9a:	75 f1                	jne    800a8d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	eb 05                	jmp    800aa8 <strchr+0x32>
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab4:	0f b6 10             	movzbl (%eax),%edx
  800ab7:	84 d2                	test   %dl,%dl
  800ab9:	74 14                	je     800acf <strfind+0x25>
		if (*s == c)
  800abb:	38 ca                	cmp    %cl,%dl
  800abd:	75 06                	jne    800ac5 <strfind+0x1b>
  800abf:	eb 0e                	jmp    800acf <strfind+0x25>
  800ac1:	38 ca                	cmp    %cl,%dl
  800ac3:	74 0a                	je     800acf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	0f b6 10             	movzbl (%eax),%edx
  800acb:	84 d2                	test   %dl,%dl
  800acd:	75 f2                	jne    800ac1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 0c             	sub    $0xc,%esp
  800ad7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ada:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800add:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ae0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae9:	85 c9                	test   %ecx,%ecx
  800aeb:	74 30                	je     800b1d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aed:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800af3:	75 25                	jne    800b1a <memset+0x49>
  800af5:	f6 c1 03             	test   $0x3,%cl
  800af8:	75 20                	jne    800b1a <memset+0x49>
		c &= 0xFF;
  800afa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afd:	89 d3                	mov    %edx,%ebx
  800aff:	c1 e3 08             	shl    $0x8,%ebx
  800b02:	89 d6                	mov    %edx,%esi
  800b04:	c1 e6 18             	shl    $0x18,%esi
  800b07:	89 d0                	mov    %edx,%eax
  800b09:	c1 e0 10             	shl    $0x10,%eax
  800b0c:	09 f0                	or     %esi,%eax
  800b0e:	09 d0                	or     %edx,%eax
  800b10:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b12:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b15:	fc                   	cld    
  800b16:	f3 ab                	rep stos %eax,%es:(%edi)
  800b18:	eb 03                	jmp    800b1d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1a:	fc                   	cld    
  800b1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1d:	89 f8                	mov    %edi,%eax
  800b1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b28:	89 ec                	mov    %ebp,%esp
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b35:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b41:	39 c6                	cmp    %eax,%esi
  800b43:	73 36                	jae    800b7b <memmove+0x4f>
  800b45:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b48:	39 d0                	cmp    %edx,%eax
  800b4a:	73 2f                	jae    800b7b <memmove+0x4f>
		s += n;
		d += n;
  800b4c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 1b                	jne    800b6f <memmove+0x43>
  800b54:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5a:	75 13                	jne    800b6f <memmove+0x43>
  800b5c:	f6 c1 03             	test   $0x3,%cl
  800b5f:	75 0e                	jne    800b6f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b61:	83 ef 04             	sub    $0x4,%edi
  800b64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b6a:	fd                   	std    
  800b6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6d:	eb 09                	jmp    800b78 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b6f:	83 ef 01             	sub    $0x1,%edi
  800b72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b75:	fd                   	std    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b78:	fc                   	cld    
  800b79:	eb 20                	jmp    800b9b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b81:	75 13                	jne    800b96 <memmove+0x6a>
  800b83:	a8 03                	test   $0x3,%al
  800b85:	75 0f                	jne    800b96 <memmove+0x6a>
  800b87:	f6 c1 03             	test   $0x3,%cl
  800b8a:	75 0a                	jne    800b96 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b8c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b8f:	89 c7                	mov    %eax,%edi
  800b91:	fc                   	cld    
  800b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b94:	eb 05                	jmp    800b9b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b96:	89 c7                	mov    %eax,%edi
  800b98:	fc                   	cld    
  800b99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b9b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b9e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ba1:	89 ec                	mov    %ebp,%esp
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	89 04 24             	mov    %eax,(%esp)
  800bbf:	e8 68 ff ff ff       	call   800b2c <memmove>
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bda:	85 ff                	test   %edi,%edi
  800bdc:	74 37                	je     800c15 <memcmp+0x4f>
		if (*s1 != *s2)
  800bde:	0f b6 03             	movzbl (%ebx),%eax
  800be1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be4:	83 ef 01             	sub    $0x1,%edi
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800bec:	38 c8                	cmp    %cl,%al
  800bee:	74 1c                	je     800c0c <memcmp+0x46>
  800bf0:	eb 10                	jmp    800c02 <memcmp+0x3c>
  800bf2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bf7:	83 c2 01             	add    $0x1,%edx
  800bfa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800bfe:	38 c8                	cmp    %cl,%al
  800c00:	74 0a                	je     800c0c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800c02:	0f b6 c0             	movzbl %al,%eax
  800c05:	0f b6 c9             	movzbl %cl,%ecx
  800c08:	29 c8                	sub    %ecx,%eax
  800c0a:	eb 09                	jmp    800c15 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c0c:	39 fa                	cmp    %edi,%edx
  800c0e:	75 e2                	jne    800bf2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c25:	39 d0                	cmp    %edx,%eax
  800c27:	73 19                	jae    800c42 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c2d:	38 08                	cmp    %cl,(%eax)
  800c2f:	75 06                	jne    800c37 <memfind+0x1d>
  800c31:	eb 0f                	jmp    800c42 <memfind+0x28>
  800c33:	38 08                	cmp    %cl,(%eax)
  800c35:	74 0b                	je     800c42 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c37:	83 c0 01             	add    $0x1,%eax
  800c3a:	39 d0                	cmp    %edx,%eax
  800c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c40:	75 f1                	jne    800c33 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c50:	0f b6 02             	movzbl (%edx),%eax
  800c53:	3c 20                	cmp    $0x20,%al
  800c55:	74 04                	je     800c5b <strtol+0x17>
  800c57:	3c 09                	cmp    $0x9,%al
  800c59:	75 0e                	jne    800c69 <strtol+0x25>
		s++;
  800c5b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5e:	0f b6 02             	movzbl (%edx),%eax
  800c61:	3c 20                	cmp    $0x20,%al
  800c63:	74 f6                	je     800c5b <strtol+0x17>
  800c65:	3c 09                	cmp    $0x9,%al
  800c67:	74 f2                	je     800c5b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c69:	3c 2b                	cmp    $0x2b,%al
  800c6b:	75 0a                	jne    800c77 <strtol+0x33>
		s++;
  800c6d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c70:	bf 00 00 00 00       	mov    $0x0,%edi
  800c75:	eb 10                	jmp    800c87 <strtol+0x43>
  800c77:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c7c:	3c 2d                	cmp    $0x2d,%al
  800c7e:	75 07                	jne    800c87 <strtol+0x43>
		s++, neg = 1;
  800c80:	83 c2 01             	add    $0x1,%edx
  800c83:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c87:	85 db                	test   %ebx,%ebx
  800c89:	0f 94 c0             	sete   %al
  800c8c:	74 05                	je     800c93 <strtol+0x4f>
  800c8e:	83 fb 10             	cmp    $0x10,%ebx
  800c91:	75 15                	jne    800ca8 <strtol+0x64>
  800c93:	80 3a 30             	cmpb   $0x30,(%edx)
  800c96:	75 10                	jne    800ca8 <strtol+0x64>
  800c98:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c9c:	75 0a                	jne    800ca8 <strtol+0x64>
		s += 2, base = 16;
  800c9e:	83 c2 02             	add    $0x2,%edx
  800ca1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca6:	eb 13                	jmp    800cbb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800ca8:	84 c0                	test   %al,%al
  800caa:	74 0f                	je     800cbb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cac:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb1:	80 3a 30             	cmpb   $0x30,(%edx)
  800cb4:	75 05                	jne    800cbb <strtol+0x77>
		s++, base = 8;
  800cb6:	83 c2 01             	add    $0x1,%edx
  800cb9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cc2:	0f b6 0a             	movzbl (%edx),%ecx
  800cc5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cc8:	80 fb 09             	cmp    $0x9,%bl
  800ccb:	77 08                	ja     800cd5 <strtol+0x91>
			dig = *s - '0';
  800ccd:	0f be c9             	movsbl %cl,%ecx
  800cd0:	83 e9 30             	sub    $0x30,%ecx
  800cd3:	eb 1e                	jmp    800cf3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800cd5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800cd8:	80 fb 19             	cmp    $0x19,%bl
  800cdb:	77 08                	ja     800ce5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800cdd:	0f be c9             	movsbl %cl,%ecx
  800ce0:	83 e9 57             	sub    $0x57,%ecx
  800ce3:	eb 0e                	jmp    800cf3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800ce5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800ce8:	80 fb 19             	cmp    $0x19,%bl
  800ceb:	77 14                	ja     800d01 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800ced:	0f be c9             	movsbl %cl,%ecx
  800cf0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cf3:	39 f1                	cmp    %esi,%ecx
  800cf5:	7d 0e                	jge    800d05 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cf7:	83 c2 01             	add    $0x1,%edx
  800cfa:	0f af c6             	imul   %esi,%eax
  800cfd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800cff:	eb c1                	jmp    800cc2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d01:	89 c1                	mov    %eax,%ecx
  800d03:	eb 02                	jmp    800d07 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d05:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0b:	74 05                	je     800d12 <strtol+0xce>
		*endptr = (char *) s;
  800d0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d10:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d12:	89 ca                	mov    %ecx,%edx
  800d14:	f7 da                	neg    %edx
  800d16:	85 ff                	test   %edi,%edi
  800d18:	0f 45 c2             	cmovne %edx,%eax
}
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d29:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d2c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	89 c3                	mov    %eax,%ebx
  800d3c:	89 c7                	mov    %eax,%edi
  800d3e:	89 c6                	mov    %eax,%esi
  800d40:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d42:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d45:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d48:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d4b:	89 ec                	mov    %ebp,%esp
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <sys_cgetc>:

int
sys_cgetc(void)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d58:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d5b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d63:	b8 01 00 00 00       	mov    $0x1,%eax
  800d68:	89 d1                	mov    %edx,%ecx
  800d6a:	89 d3                	mov    %edx,%ebx
  800d6c:	89 d7                	mov    %edx,%edi
  800d6e:	89 d6                	mov    %edx,%esi
  800d70:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d7b:	89 ec                	mov    %ebp,%esp
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 38             	sub    $0x38,%esp
  800d85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	b8 03 00 00 00       	mov    $0x3,%eax
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7e 28                	jle    800dcf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dab:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800db2:	00 
  800db3:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800dba:	00 
  800dbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc2:	00 
  800dc3:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800dca:	e8 55 f4 ff ff       	call   800224 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd8:	89 ec                	mov    %ebp,%esp
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800deb:	ba 00 00 00 00       	mov    $0x0,%edx
  800df0:	b8 02 00 00 00       	mov    $0x2,%eax
  800df5:	89 d1                	mov    %edx,%ecx
  800df7:	89 d3                	mov    %edx,%ebx
  800df9:	89 d7                	mov    %edx,%edi
  800dfb:	89 d6                	mov    %edx,%esi
  800dfd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e08:	89 ec                	mov    %ebp,%esp
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_yield>:

void
sys_yield(void)
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
  800e20:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e25:	89 d1                	mov    %edx,%ecx
  800e27:	89 d3                	mov    %edx,%ebx
  800e29:	89 d7                	mov    %edx,%edi
  800e2b:	89 d6                	mov    %edx,%esi
  800e2d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e38:	89 ec                	mov    %ebp,%esp
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 38             	sub    $0x38,%esp
  800e42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4b:	be 00 00 00 00       	mov    $0x0,%esi
  800e50:	b8 04 00 00 00       	mov    $0x4,%eax
  800e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	89 f7                	mov    %esi,%edi
  800e60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7e 28                	jle    800e8e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e71:	00 
  800e72:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800e79:	00 
  800e7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e81:	00 
  800e82:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800e89:	e8 96 f3 ff ff       	call   800224 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e8e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e91:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e94:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e97:	89 ec                	mov    %ebp,%esp
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 38             	sub    $0x38,%esp
  800ea1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaa:	b8 05 00 00 00       	mov    $0x5,%eax
  800eaf:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7e 28                	jle    800eec <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800ed7:	00 
  800ed8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edf:	00 
  800ee0:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800ee7:	e8 38 f3 ff ff       	call   800224 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef5:	89 ec                	mov    %ebp,%esp
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 38             	sub    $0x38,%esp
  800eff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f02:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f05:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	89 df                	mov    %ebx,%edi
  800f1a:	89 de                	mov    %ebx,%esi
  800f1c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	7e 28                	jle    800f4a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f26:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f2d:	00 
  800f2e:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800f35:	00 
  800f36:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3d:	00 
  800f3e:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800f45:	e8 da f2 ff ff       	call   800224 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f50:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f53:	89 ec                	mov    %ebp,%esp
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 38             	sub    $0x38,%esp
  800f5d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f60:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f63:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800fa3:	e8 7c f2 ff ff       	call   800224 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb1:	89 ec                	mov    %ebp,%esp
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 38             	sub    $0x38,%esp
  800fbb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	b8 09 00 00 00       	mov    $0x9,%eax
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	7e 28                	jle    801006 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fe9:	00 
  800fea:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff9:	00 
  800ffa:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801001:	e8 1e f2 ff ff       	call   800224 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801006:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801009:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 38             	sub    $0x38,%esp
  801019:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	b8 0a 00 00 00       	mov    $0xa,%eax
  80102c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	89 df                	mov    %ebx,%edi
  801034:	89 de                	mov    %ebx,%esi
  801036:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7e 28                	jle    801064 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801040:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801047:	00 
  801048:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  80104f:	00 
  801050:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801057:	00 
  801058:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  80105f:	e8 c0 f1 ff ff       	call   800224 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801064:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801067:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106d:	89 ec                	mov    %ebp,%esp
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    

00801071 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80107d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801080:	be 00 00 00 00       	mov    $0x0,%esi
  801085:	b8 0c 00 00 00       	mov    $0xc,%eax
  80108a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80108d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801098:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80109b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80109e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a1:	89 ec                	mov    %ebp,%esp
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 38             	sub    $0x38,%esp
  8010ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	89 cb                	mov    %ecx,%ebx
  8010c3:	89 cf                	mov    %ecx,%edi
  8010c5:	89 ce                	mov    %ecx,%esi
  8010c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	7e 28                	jle    8010f5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8010e0:	00 
  8010e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e8:	00 
  8010e9:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8010f0:	e8 2f f1 ff ff       	call   800224 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010fe:	89 ec                	mov    %ebp,%esp
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
	...

00801104 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 24             	sub    $0x24,%esp
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80110e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801110:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801114:	74 21                	je     801137 <pgfault+0x33>
  801116:	89 d8                	mov    %ebx,%eax
  801118:	c1 e8 16             	shr    $0x16,%eax
  80111b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801122:	a8 01                	test   $0x1,%al
  801124:	74 11                	je     801137 <pgfault+0x33>
  801126:	89 d8                	mov    %ebx,%eax
  801128:	c1 e8 0c             	shr    $0xc,%eax
  80112b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801132:	f6 c4 08             	test   $0x8,%ah
  801135:	75 1c                	jne    801153 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801137:	c7 44 24 08 4c 32 80 	movl   $0x80324c,0x8(%esp)
  80113e:	00 
  80113f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801146:	00 
  801147:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  80114e:	e8 d1 f0 ff ff       	call   800224 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801153:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80115a:	00 
  80115b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801162:	00 
  801163:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116a:	e8 cd fc ff ff       	call   800e3c <sys_page_alloc>
  80116f:	85 c0                	test   %eax,%eax
  801171:	79 20                	jns    801193 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801177:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  80117e:	00 
  80117f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801186:	00 
  801187:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  80118e:	e8 91 f0 ff ff       	call   800224 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801193:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801199:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011a0:	00 
  8011a1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a5:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011ac:	e8 7b f9 ff ff       	call   800b2c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8011b1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011b8:	00 
  8011b9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c4:	00 
  8011c5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011cc:	00 
  8011cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d4:	e8 c2 fc ff ff       	call   800e9b <sys_page_map>
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	79 20                	jns    8011fd <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  8011dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e1:	c7 44 24 08 b0 32 80 	movl   $0x8032b0,0x8(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8011f0:	00 
  8011f1:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  8011f8:	e8 27 f0 ff ff       	call   800224 <_panic>
	//panic("pgfault not implemented");
}
  8011fd:	83 c4 24             	add    $0x24,%esp
  801200:	5b                   	pop    %ebx
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	57                   	push   %edi
  801207:	56                   	push   %esi
  801208:	53                   	push   %ebx
  801209:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80120c:	c7 04 24 04 11 80 00 	movl   $0x801104,(%esp)
  801213:	e8 78 17 00 00       	call   802990 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801218:	ba 07 00 00 00       	mov    $0x7,%edx
  80121d:	89 d0                	mov    %edx,%eax
  80121f:	cd 30                	int    $0x30
  801221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801224:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801226:	85 c0                	test   %eax,%eax
  801228:	79 20                	jns    80124a <fork+0x47>
		panic("sys_exofork: %e", envid);
  80122a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122e:	c7 44 24 08 ae 33 80 	movl   $0x8033ae,0x8(%esp)
  801235:	00 
  801236:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80123d:	00 
  80123e:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  801245:	e8 da ef ff ff       	call   800224 <_panic>
	if (envid == 0) {
  80124a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80124f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801253:	75 1c                	jne    801271 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801255:	e8 82 fb ff ff       	call   800ddc <sys_getenvid>
  80125a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80125f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801262:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801267:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80126c:	e9 06 02 00 00       	jmp    801477 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801271:	89 d8                	mov    %ebx,%eax
  801273:	c1 e8 16             	shr    $0x16,%eax
  801276:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127d:	a8 01                	test   $0x1,%al
  80127f:	0f 84 57 01 00 00    	je     8013dc <fork+0x1d9>
  801285:	89 de                	mov    %ebx,%esi
  801287:	c1 ee 0c             	shr    $0xc,%esi
  80128a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801291:	a8 01                	test   $0x1,%al
  801293:	0f 84 43 01 00 00    	je     8013dc <fork+0x1d9>
  801299:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012a0:	a8 04                	test   $0x4,%al
  8012a2:	0f 84 34 01 00 00    	je     8013dc <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  8012a8:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  8012ab:	89 f0                	mov    %esi,%eax
  8012ad:	c1 e8 0c             	shr    $0xc,%eax
  8012b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  8012b7:	f6 c4 04             	test   $0x4,%ah
  8012ba:	74 45                	je     801301 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  8012bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8012c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012c9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d8:	e8 be fb ff ff       	call   800e9b <sys_page_map>
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	0f 89 f7 00 00 00    	jns    8013dc <fork+0x1d9>
			panic ("duppage: error at lab5");
  8012e5:	c7 44 24 08 be 33 80 	movl   $0x8033be,0x8(%esp)
  8012ec:	00 
  8012ed:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  8012f4:	00 
  8012f5:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  8012fc:	e8 23 ef ff ff       	call   800224 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801301:	a9 02 08 00 00       	test   $0x802,%eax
  801306:	0f 84 8c 00 00 00    	je     801398 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80130c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801313:	00 
  801314:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801318:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80131c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801327:	e8 6f fb ff ff       	call   800e9b <sys_page_map>
  80132c:	85 c0                	test   %eax,%eax
  80132e:	79 20                	jns    801350 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801330:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801334:	c7 44 24 08 d4 32 80 	movl   $0x8032d4,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801343:	00 
  801344:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  80134b:	e8 d4 ee ff ff       	call   800224 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801350:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801357:	00 
  801358:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80135c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801363:	00 
  801364:	89 74 24 04          	mov    %esi,0x4(%esp)
  801368:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136f:	e8 27 fb ff ff       	call   800e9b <sys_page_map>
  801374:	85 c0                	test   %eax,%eax
  801376:	79 64                	jns    8013dc <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801378:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137c:	c7 44 24 08 00 33 80 	movl   $0x803300,0x8(%esp)
  801383:	00 
  801384:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80138b:	00 
  80138c:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  801393:	e8 8c ee ff ff       	call   800224 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801398:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80139f:	00 
  8013a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013a4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b3:	e8 e3 fa ff ff       	call   800e9b <sys_page_map>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	79 20                	jns    8013dc <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  8013bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c0:	c7 44 24 08 2c 33 80 	movl   $0x80332c,0x8(%esp)
  8013c7:	00 
  8013c8:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8013cf:	00 
  8013d0:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  8013d7:	e8 48 ee ff ff       	call   800224 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  8013dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013e2:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8013e8:	0f 85 83 fe ff ff    	jne    801271 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  8013ee:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013f5:	00 
  8013f6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013fd:	ee 
  8013fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801401:	89 04 24             	mov    %eax,(%esp)
  801404:	e8 33 fa ff ff       	call   800e3c <sys_page_alloc>
  801409:	85 c0                	test   %eax,%eax
  80140b:	79 20                	jns    80142d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80140d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801411:	c7 44 24 08 58 33 80 	movl   $0x803358,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  801428:	e8 f7 ed ff ff       	call   800224 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80142d:	c7 44 24 04 00 2a 80 	movl   $0x802a00,0x4(%esp)
  801434:	00 
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	89 04 24             	mov    %eax,(%esp)
  80143b:	e8 d3 fb ff ff       	call   801013 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801440:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801447:	00 
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 04 fb ff ff       	call   800f57 <sys_env_set_status>
  801453:	85 c0                	test   %eax,%eax
  801455:	79 20                	jns    801477 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80145b:	c7 44 24 08 7c 33 80 	movl   $0x80337c,0x8(%esp)
  801462:	00 
  801463:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80146a:	00 
  80146b:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  801472:	e8 ad ed ff ff       	call   800224 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	83 c4 3c             	add    $0x3c,%esp
  80147d:	5b                   	pop    %ebx
  80147e:	5e                   	pop    %esi
  80147f:	5f                   	pop    %edi
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <sfork>:

// Challenge!
int
sfork(void)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801488:	c7 44 24 08 d5 33 80 	movl   $0x8033d5,0x8(%esp)
  80148f:	00 
  801490:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801497:	00 
  801498:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  80149f:	e8 80 ed ff ff       	call   800224 <_panic>
	...

008014b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	89 04 24             	mov    %eax,(%esp)
  8014cc:	e8 df ff ff ff       	call   8014b0 <fd2num>
  8014d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	53                   	push   %ebx
  8014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014e2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014e7:	a8 01                	test   $0x1,%al
  8014e9:	74 34                	je     80151f <fd_alloc+0x44>
  8014eb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8014f0:	a8 01                	test   $0x1,%al
  8014f2:	74 32                	je     801526 <fd_alloc+0x4b>
  8014f4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8014f9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	c1 ea 16             	shr    $0x16,%edx
  801500:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801507:	f6 c2 01             	test   $0x1,%dl
  80150a:	74 1f                	je     80152b <fd_alloc+0x50>
  80150c:	89 c2                	mov    %eax,%edx
  80150e:	c1 ea 0c             	shr    $0xc,%edx
  801511:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801518:	f6 c2 01             	test   $0x1,%dl
  80151b:	75 17                	jne    801534 <fd_alloc+0x59>
  80151d:	eb 0c                	jmp    80152b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80151f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801524:	eb 05                	jmp    80152b <fd_alloc+0x50>
  801526:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80152b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	eb 17                	jmp    80154b <fd_alloc+0x70>
  801534:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801539:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80153e:	75 b9                	jne    8014f9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801540:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801546:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80154b:	5b                   	pop    %ebx
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    

0080154e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801554:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801559:	83 fa 1f             	cmp    $0x1f,%edx
  80155c:	77 3f                	ja     80159d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80155e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801564:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801567:	89 d0                	mov    %edx,%eax
  801569:	c1 e8 16             	shr    $0x16,%eax
  80156c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801578:	f6 c1 01             	test   $0x1,%cl
  80157b:	74 20                	je     80159d <fd_lookup+0x4f>
  80157d:	89 d0                	mov    %edx,%eax
  80157f:	c1 e8 0c             	shr    $0xc,%eax
  801582:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801589:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80158e:	f6 c1 01             	test   $0x1,%cl
  801591:	74 0a                	je     80159d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801593:	8b 45 0c             	mov    0xc(%ebp),%eax
  801596:	89 10                	mov    %edx,(%eax)
	return 0;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159d:	5d                   	pop    %ebp
  80159e:	c3                   	ret    

0080159f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 14             	sub    $0x14,%esp
  8015a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015b1:	39 0d 0c 40 80 00    	cmp    %ecx,0x80400c
  8015b7:	75 17                	jne    8015d0 <dev_lookup+0x31>
  8015b9:	eb 07                	jmp    8015c2 <dev_lookup+0x23>
  8015bb:	39 0a                	cmp    %ecx,(%edx)
  8015bd:	75 11                	jne    8015d0 <dev_lookup+0x31>
  8015bf:	90                   	nop
  8015c0:	eb 05                	jmp    8015c7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015c2:	ba 0c 40 80 00       	mov    $0x80400c,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8015c7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ce:	eb 35                	jmp    801605 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015d0:	83 c0 01             	add    $0x1,%eax
  8015d3:	8b 14 85 68 34 80 00 	mov    0x803468(,%eax,4),%edx
  8015da:	85 d2                	test   %edx,%edx
  8015dc:	75 dd                	jne    8015bb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015de:	a1 04 50 80 00       	mov    0x805004,%eax
  8015e3:	8b 40 48             	mov    0x48(%eax),%eax
  8015e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ee:	c7 04 24 ec 33 80 00 	movl   $0x8033ec,(%esp)
  8015f5:	e8 25 ed ff ff       	call   80031f <cprintf>
	*dev = 0;
  8015fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801600:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801605:	83 c4 14             	add    $0x14,%esp
  801608:	5b                   	pop    %ebx
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 38             	sub    $0x38,%esp
  801611:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801614:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801617:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80161a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801621:	89 3c 24             	mov    %edi,(%esp)
  801624:	e8 87 fe ff ff       	call   8014b0 <fd2num>
  801629:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80162c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	e8 16 ff ff ff       	call   80154e <fd_lookup>
  801638:	89 c3                	mov    %eax,%ebx
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 05                	js     801643 <fd_close+0x38>
	    || fd != fd2)
  80163e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801641:	74 0e                	je     801651 <fd_close+0x46>
		return (must_exist ? r : 0);
  801643:	89 f0                	mov    %esi,%eax
  801645:	84 c0                	test   %al,%al
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	0f 44 d8             	cmove  %eax,%ebx
  80164f:	eb 3d                	jmp    80168e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801651:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	8b 07                	mov    (%edi),%eax
  80165a:	89 04 24             	mov    %eax,(%esp)
  80165d:	e8 3d ff ff ff       	call   80159f <dev_lookup>
  801662:	89 c3                	mov    %eax,%ebx
  801664:	85 c0                	test   %eax,%eax
  801666:	78 16                	js     80167e <fd_close+0x73>
		if (dev->dev_close)
  801668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801673:	85 c0                	test   %eax,%eax
  801675:	74 07                	je     80167e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801677:	89 3c 24             	mov    %edi,(%esp)
  80167a:	ff d0                	call   *%eax
  80167c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80167e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801689:	e8 6b f8 ff ff       	call   800ef9 <sys_page_unmap>
	return r;
}
  80168e:	89 d8                	mov    %ebx,%eax
  801690:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801693:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801696:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801699:	89 ec                	mov    %ebp,%esp
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 04 24             	mov    %eax,(%esp)
  8016b0:	e8 99 fe ff ff       	call   80154e <fd_lookup>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 13                	js     8016cc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016c0:	00 
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 3f ff ff ff       	call   80160b <fd_close>
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <close_all>:

void
close_all(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016da:	89 1c 24             	mov    %ebx,(%esp)
  8016dd:	e8 bb ff ff ff       	call   80169d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016e2:	83 c3 01             	add    $0x1,%ebx
  8016e5:	83 fb 20             	cmp    $0x20,%ebx
  8016e8:	75 f0                	jne    8016da <close_all+0xc>
		close(i);
}
  8016ea:	83 c4 14             	add    $0x14,%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 58             	sub    $0x58,%esp
  8016f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801702:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801705:	89 44 24 04          	mov    %eax,0x4(%esp)
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	89 04 24             	mov    %eax,(%esp)
  80170f:	e8 3a fe ff ff       	call   80154e <fd_lookup>
  801714:	89 c3                	mov    %eax,%ebx
  801716:	85 c0                	test   %eax,%eax
  801718:	0f 88 e1 00 00 00    	js     8017ff <dup+0x10f>
		return r;
	close(newfdnum);
  80171e:	89 3c 24             	mov    %edi,(%esp)
  801721:	e8 77 ff ff ff       	call   80169d <close>

	newfd = INDEX2FD(newfdnum);
  801726:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80172c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80172f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	e8 86 fd ff ff       	call   8014c0 <fd2data>
  80173a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80173c:	89 34 24             	mov    %esi,(%esp)
  80173f:	e8 7c fd ff ff       	call   8014c0 <fd2data>
  801744:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801747:	89 d8                	mov    %ebx,%eax
  801749:	c1 e8 16             	shr    $0x16,%eax
  80174c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801753:	a8 01                	test   $0x1,%al
  801755:	74 46                	je     80179d <dup+0xad>
  801757:	89 d8                	mov    %ebx,%eax
  801759:	c1 e8 0c             	shr    $0xc,%eax
  80175c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801763:	f6 c2 01             	test   $0x1,%dl
  801766:	74 35                	je     80179d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801768:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80176f:	25 07 0e 00 00       	and    $0xe07,%eax
  801774:	89 44 24 10          	mov    %eax,0x10(%esp)
  801778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80177b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80177f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801786:	00 
  801787:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80178b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801792:	e8 04 f7 ff ff       	call   800e9b <sys_page_map>
  801797:	89 c3                	mov    %eax,%ebx
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 3b                	js     8017d8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80179d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a0:	89 c2                	mov    %eax,%edx
  8017a2:	c1 ea 0c             	shr    $0xc,%edx
  8017a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ac:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017b2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c1:	00 
  8017c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017cd:	e8 c9 f6 ff ff       	call   800e9b <sys_page_map>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	79 25                	jns    8017fd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e3:	e8 11 f7 ff ff       	call   800ef9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f6:	e8 fe f6 ff ff       	call   800ef9 <sys_page_unmap>
	return r;
  8017fb:	eb 02                	jmp    8017ff <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8017fd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017ff:	89 d8                	mov    %ebx,%eax
  801801:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801804:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801807:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80180a:	89 ec                	mov    %ebp,%esp
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	53                   	push   %ebx
  801812:	83 ec 24             	sub    $0x24,%esp
  801815:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801818:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181f:	89 1c 24             	mov    %ebx,(%esp)
  801822:	e8 27 fd ff ff       	call   80154e <fd_lookup>
  801827:	85 c0                	test   %eax,%eax
  801829:	78 6d                	js     801898 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	89 04 24             	mov    %eax,(%esp)
  80183a:	e8 60 fd ff ff       	call   80159f <dev_lookup>
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 55                	js     801898 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801846:	8b 50 08             	mov    0x8(%eax),%edx
  801849:	83 e2 03             	and    $0x3,%edx
  80184c:	83 fa 01             	cmp    $0x1,%edx
  80184f:	75 23                	jne    801874 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801851:	a1 04 50 80 00       	mov    0x805004,%eax
  801856:	8b 40 48             	mov    0x48(%eax),%eax
  801859:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	c7 04 24 2d 34 80 00 	movl   $0x80342d,(%esp)
  801868:	e8 b2 ea ff ff       	call   80031f <cprintf>
		return -E_INVAL;
  80186d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801872:	eb 24                	jmp    801898 <read+0x8a>
	}
	if (!dev->dev_read)
  801874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801877:	8b 52 08             	mov    0x8(%edx),%edx
  80187a:	85 d2                	test   %edx,%edx
  80187c:	74 15                	je     801893 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80187e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801881:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801888:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80188c:	89 04 24             	mov    %eax,(%esp)
  80188f:	ff d2                	call   *%edx
  801891:	eb 05                	jmp    801898 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801893:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801898:	83 c4 24             	add    $0x24,%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b2:	85 f6                	test   %esi,%esi
  8018b4:	74 30                	je     8018e6 <readn+0x48>
  8018b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018bb:	89 f2                	mov    %esi,%edx
  8018bd:	29 c2                	sub    %eax,%edx
  8018bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018c3:	03 45 0c             	add    0xc(%ebp),%eax
  8018c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ca:	89 3c 24             	mov    %edi,(%esp)
  8018cd:	e8 3c ff ff ff       	call   80180e <read>
		if (m < 0)
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 10                	js     8018e6 <readn+0x48>
			return m;
		if (m == 0)
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	74 0a                	je     8018e4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018da:	01 c3                	add    %eax,%ebx
  8018dc:	89 d8                	mov    %ebx,%eax
  8018de:	39 f3                	cmp    %esi,%ebx
  8018e0:	72 d9                	jb     8018bb <readn+0x1d>
  8018e2:	eb 02                	jmp    8018e6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8018e4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8018e6:	83 c4 1c             	add    $0x1c,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5f                   	pop    %edi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 24             	sub    $0x24,%esp
  8018f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	89 1c 24             	mov    %ebx,(%esp)
  801902:	e8 47 fc ff ff       	call   80154e <fd_lookup>
  801907:	85 c0                	test   %eax,%eax
  801909:	78 68                	js     801973 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	e8 80 fc ff ff       	call   80159f <dev_lookup>
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 50                	js     801973 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801926:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80192a:	75 23                	jne    80194f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80192c:	a1 04 50 80 00       	mov    0x805004,%eax
  801931:	8b 40 48             	mov    0x48(%eax),%eax
  801934:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193c:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801943:	e8 d7 e9 ff ff       	call   80031f <cprintf>
		return -E_INVAL;
  801948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194d:	eb 24                	jmp    801973 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	8b 52 0c             	mov    0xc(%edx),%edx
  801955:	85 d2                	test   %edx,%edx
  801957:	74 15                	je     80196e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801963:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801967:	89 04 24             	mov    %eax,(%esp)
  80196a:	ff d2                	call   *%edx
  80196c:	eb 05                	jmp    801973 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80196e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801973:	83 c4 24             	add    $0x24,%esp
  801976:	5b                   	pop    %ebx
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    

00801979 <seek>:

int
seek(int fdnum, off_t offset)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80197f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801982:	89 44 24 04          	mov    %eax,0x4(%esp)
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 bd fb ff ff       	call   80154e <fd_lookup>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 0e                	js     8019a3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 24             	sub    $0x24,%esp
  8019ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	89 1c 24             	mov    %ebx,(%esp)
  8019b9:	e8 90 fb ff ff       	call   80154e <fd_lookup>
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 61                	js     801a23 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	89 04 24             	mov    %eax,(%esp)
  8019d1:	e8 c9 fb ff ff       	call   80159f <dev_lookup>
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 49                	js     801a23 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e1:	75 23                	jne    801a06 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019e3:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e8:	8b 40 48             	mov    0x48(%eax),%eax
  8019eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f3:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  8019fa:	e8 20 e9 ff ff       	call   80031f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a04:	eb 1d                	jmp    801a23 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a09:	8b 52 18             	mov    0x18(%edx),%edx
  801a0c:	85 d2                	test   %edx,%edx
  801a0e:	74 0e                	je     801a1e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a17:	89 04 24             	mov    %eax,(%esp)
  801a1a:	ff d2                	call   *%edx
  801a1c:	eb 05                	jmp    801a23 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a23:	83 c4 24             	add    $0x24,%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    

00801a29 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 24             	sub    $0x24,%esp
  801a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a33:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	89 04 24             	mov    %eax,(%esp)
  801a40:	e8 09 fb ff ff       	call   80154e <fd_lookup>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 52                	js     801a9b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	89 04 24             	mov    %eax,(%esp)
  801a58:	e8 42 fb ff ff       	call   80159f <dev_lookup>
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 3a                	js     801a9b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a64:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a68:	74 2c                	je     801a96 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a6a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a6d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a74:	00 00 00 
	stat->st_isdir = 0;
  801a77:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a7e:	00 00 00 
	stat->st_dev = dev;
  801a81:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a87:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8e:	89 14 24             	mov    %edx,(%esp)
  801a91:	ff 50 14             	call   *0x14(%eax)
  801a94:	eb 05                	jmp    801a9b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a9b:	83 c4 24             	add    $0x24,%esp
  801a9e:	5b                   	pop    %ebx
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 18             	sub    $0x18,%esp
  801aa7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801aaa:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ab4:	00 
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	89 04 24             	mov    %eax,(%esp)
  801abb:	e8 bc 01 00 00       	call   801c7c <open>
  801ac0:	89 c3                	mov    %eax,%ebx
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 1b                	js     801ae1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acd:	89 1c 24             	mov    %ebx,(%esp)
  801ad0:	e8 54 ff ff ff       	call   801a29 <fstat>
  801ad5:	89 c6                	mov    %eax,%esi
	close(fd);
  801ad7:	89 1c 24             	mov    %ebx,(%esp)
  801ada:	e8 be fb ff ff       	call   80169d <close>
	return r;
  801adf:	89 f3                	mov    %esi,%ebx
}
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ae6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ae9:	89 ec                	mov    %ebp,%esp
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    
  801aed:	00 00                	add    %al,(%eax)
	...

00801af0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 18             	sub    $0x18,%esp
  801af6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801af9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801afc:	89 c3                	mov    %eax,%ebx
  801afe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801b00:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b07:	75 11                	jne    801b1a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b10:	e8 f1 0f 00 00       	call   802b06 <ipc_find_env>
  801b15:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b1a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b21:	00 
  801b22:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b29:	00 
  801b2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2e:	a1 00 50 80 00       	mov    0x805000,%eax
  801b33:	89 04 24             	mov    %eax,(%esp)
  801b36:	e8 47 0f 00 00       	call   802a82 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b42:	00 
  801b43:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4e:	e8 dd 0e 00 00       	call   802a30 <ipc_recv>
}
  801b53:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b56:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b59:	89 ec                	mov    %ebp,%esp
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	53                   	push   %ebx
  801b61:	83 ec 14             	sub    $0x14,%esp
  801b64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
  801b77:	b8 05 00 00 00       	mov    $0x5,%eax
  801b7c:	e8 6f ff ff ff       	call   801af0 <fsipc>
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 2b                	js     801bb0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b85:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b8c:	00 
  801b8d:	89 1c 24             	mov    %ebx,(%esp)
  801b90:	e8 a6 ed ff ff       	call   80093b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b95:	a1 80 60 80 00       	mov    0x806080,%eax
  801b9a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ba0:	a1 84 60 80 00       	mov    0x806084,%eax
  801ba5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb0:	83 c4 14             	add    $0x14,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    

00801bb6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcc:	b8 06 00 00 00       	mov    $0x6,%eax
  801bd1:	e8 1a ff ff ff       	call   801af0 <fsipc>
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 10             	sub    $0x10,%esp
  801be0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	8b 40 0c             	mov    0xc(%eax),%eax
  801be9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bee:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf9:	b8 03 00 00 00       	mov    $0x3,%eax
  801bfe:	e8 ed fe ff ff       	call   801af0 <fsipc>
  801c03:	89 c3                	mov    %eax,%ebx
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 6a                	js     801c73 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c09:	39 c6                	cmp    %eax,%esi
  801c0b:	73 24                	jae    801c31 <devfile_read+0x59>
  801c0d:	c7 44 24 0c 78 34 80 	movl   $0x803478,0xc(%esp)
  801c14:	00 
  801c15:	c7 44 24 08 7f 34 80 	movl   $0x80347f,0x8(%esp)
  801c1c:	00 
  801c1d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c24:	00 
  801c25:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  801c2c:	e8 f3 e5 ff ff       	call   800224 <_panic>
	assert(r <= PGSIZE);
  801c31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c36:	7e 24                	jle    801c5c <devfile_read+0x84>
  801c38:	c7 44 24 0c 9f 34 80 	movl   $0x80349f,0xc(%esp)
  801c3f:	00 
  801c40:	c7 44 24 08 7f 34 80 	movl   $0x80347f,0x8(%esp)
  801c47:	00 
  801c48:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801c4f:	00 
  801c50:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  801c57:	e8 c8 e5 ff ff       	call   800224 <_panic>
	memmove(buf, &fsipcbuf, r);
  801c5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c60:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c67:	00 
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	89 04 24             	mov    %eax,(%esp)
  801c6e:	e8 b9 ee ff ff       	call   800b2c <memmove>
	return r;
}
  801c73:	89 d8                	mov    %ebx,%eax
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    

00801c7c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
  801c81:	83 ec 20             	sub    $0x20,%esp
  801c84:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c87:	89 34 24             	mov    %esi,(%esp)
  801c8a:	e8 61 ec ff ff       	call   8008f0 <strlen>
		return -E_BAD_PATH;
  801c8f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c94:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c99:	7f 5e                	jg     801cf9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 35 f8 ff ff       	call   8014db <fd_alloc>
  801ca6:	89 c3                	mov    %eax,%ebx
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 4d                	js     801cf9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cac:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cb0:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801cb7:	e8 7f ec ff ff       	call   80093b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccc:	e8 1f fe ff ff       	call   801af0 <fsipc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	79 15                	jns    801cec <open+0x70>
		fd_close(fd, 0);
  801cd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cde:	00 
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	89 04 24             	mov    %eax,(%esp)
  801ce5:	e8 21 f9 ff ff       	call   80160b <fd_close>
		return r;
  801cea:	eb 0d                	jmp    801cf9 <open+0x7d>
	}

	return fd2num(fd);
  801cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 b9 f7 ff ff       	call   8014b0 <fd2num>
  801cf7:	89 c3                	mov    %eax,%ebx
}
  801cf9:	89 d8                	mov    %ebx,%eax
  801cfb:	83 c4 20             	add    $0x20,%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5e                   	pop    %esi
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    
	...

00801d04 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	57                   	push   %edi
  801d08:	56                   	push   %esi
  801d09:	53                   	push   %ebx
  801d0a:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d17:	00 
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	89 04 24             	mov    %eax,(%esp)
  801d1e:	e8 59 ff ff ff       	call   801c7c <open>
  801d23:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 88 b2 05 00 00    	js     8022e3 <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801d31:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801d38:	00 
  801d39:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d43:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d49:	89 04 24             	mov    %eax,(%esp)
  801d4c:	e8 4d fb ff ff       	call   80189e <readn>
  801d51:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d56:	75 0c                	jne    801d64 <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  801d58:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801d5f:	45 4c 46 
  801d62:	74 3b                	je     801d9f <spawn+0x9b>
		close(fd);
  801d64:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d6a:	89 04 24             	mov    %eax,(%esp)
  801d6d:	e8 2b f9 ff ff       	call   80169d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801d72:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801d79:	46 
  801d7a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d84:	c7 04 24 ab 34 80 00 	movl   $0x8034ab,(%esp)
  801d8b:	e8 8f e5 ff ff       	call   80031f <cprintf>
		return -E_NOT_EXEC;
  801d90:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  801d97:	ff ff ff 
  801d9a:	e9 50 05 00 00       	jmp    8022ef <spawn+0x5eb>
  801d9f:	ba 07 00 00 00       	mov    $0x7,%edx
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	cd 30                	int    $0x30
  801da8:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801dae:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801db4:	85 c0                	test   %eax,%eax
  801db6:	0f 88 33 05 00 00    	js     8022ef <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801dbc:	89 c6                	mov    %eax,%esi
  801dbe:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801dc4:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801dc7:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801dcd:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801dd3:	b9 11 00 00 00       	mov    $0x11,%ecx
  801dd8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801dda:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801de0:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 02                	mov    (%edx),%eax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	74 5f                	je     801e4e <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801def:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801df4:	be 00 00 00 00       	mov    $0x0,%esi
  801df9:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 ed ea ff ff       	call   8008f0 <strlen>
  801e03:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e07:	83 c6 01             	add    $0x1,%esi
  801e0a:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801e0c:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e13:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801e16:	85 c0                	test   %eax,%eax
  801e18:	75 e1                	jne    801dfb <spawn+0xf7>
  801e1a:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801e20:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e26:	bf 00 10 40 00       	mov    $0x401000,%edi
  801e2b:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e2d:	89 f8                	mov    %edi,%eax
  801e2f:	83 e0 fc             	and    $0xfffffffc,%eax
  801e32:	f7 d2                	not    %edx
  801e34:	8d 14 90             	lea    (%eax,%edx,4),%edx
  801e37:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e3d:	89 d0                	mov    %edx,%eax
  801e3f:	83 e8 08             	sub    $0x8,%eax
  801e42:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e47:	77 2d                	ja     801e76 <spawn+0x172>
  801e49:	e9 b2 04 00 00       	jmp    802300 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e4e:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801e55:	00 00 00 
  801e58:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801e5f:	00 00 00 
  801e62:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e67:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  801e6e:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e71:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e76:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e7d:	00 
  801e7e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e85:	00 
  801e86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8d:	e8 aa ef ff ff       	call   800e3c <sys_page_alloc>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	0f 88 6b 04 00 00    	js     802305 <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e9a:	85 f6                	test   %esi,%esi
  801e9c:	7e 46                	jle    801ee4 <spawn+0x1e0>
  801e9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ea3:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  801ea9:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801eac:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801eb2:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801eb8:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801ebb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec2:	89 3c 24             	mov    %edi,(%esp)
  801ec5:	e8 71 ea ff ff       	call   80093b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801eca:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801ecd:	89 04 24             	mov    %eax,(%esp)
  801ed0:	e8 1b ea ff ff       	call   8008f0 <strlen>
  801ed5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ed9:	83 c3 01             	add    $0x1,%ebx
  801edc:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801ee2:	75 c8                	jne    801eac <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801ee4:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801eea:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801ef0:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ef7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801efd:	74 24                	je     801f23 <spawn+0x21f>
  801eff:	c7 44 24 0c 20 35 80 	movl   $0x803520,0xc(%esp)
  801f06:	00 
  801f07:	c7 44 24 08 7f 34 80 	movl   $0x80347f,0x8(%esp)
  801f0e:	00 
  801f0f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801f16:	00 
  801f17:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  801f1e:	e8 01 e3 ff ff       	call   800224 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f23:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f29:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801f2e:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f34:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801f37:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f3d:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801f47:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f4d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801f54:	00 
  801f55:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801f5c:	ee 
  801f5d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f67:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f6e:	00 
  801f6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f76:	e8 20 ef ff ff       	call   800e9b <sys_page_map>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 1a                	js     801f9b <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f81:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f88:	00 
  801f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f90:	e8 64 ef ff ff       	call   800ef9 <sys_page_unmap>
  801f95:	89 c3                	mov    %eax,%ebx
  801f97:	85 c0                	test   %eax,%eax
  801f99:	79 1f                	jns    801fba <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801f9b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fa2:	00 
  801fa3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801faa:	e8 4a ef ff ff       	call   800ef9 <sys_page_unmap>
	return r;
  801faf:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801fb5:	e9 35 03 00 00       	jmp    8022ef <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fba:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fc0:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801fc7:	00 
  801fc8:	0f 84 e2 01 00 00    	je     8021b0 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fce:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801fd5:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fdb:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801fe2:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801fe5:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801feb:	83 3a 01             	cmpl   $0x1,(%edx)
  801fee:	0f 85 9b 01 00 00    	jne    80218f <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ff4:	8b 42 18             	mov    0x18(%edx),%eax
  801ff7:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801ffa:	83 f8 01             	cmp    $0x1,%eax
  801ffd:	19 c0                	sbb    %eax,%eax
  801fff:	83 e0 fe             	and    $0xfffffffe,%eax
  802002:	83 c0 07             	add    $0x7,%eax
  802005:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80200b:	8b 52 04             	mov    0x4(%edx),%edx
  80200e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802014:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80201a:	8b 70 10             	mov    0x10(%eax),%esi
  80201d:	8b 50 14             	mov    0x14(%eax),%edx
  802020:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  802026:	8b 40 08             	mov    0x8(%eax),%eax
  802029:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80202f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802034:	74 16                	je     80204c <spawn+0x348>
		va -= i;
  802036:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  80203c:	01 c2                	add    %eax,%edx
  80203e:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  802044:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  802046:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80204c:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802053:	0f 84 36 01 00 00    	je     80218f <spawn+0x48b>
  802059:	bf 00 00 00 00       	mov    $0x0,%edi
  80205e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  802063:	39 f7                	cmp    %esi,%edi
  802065:	72 31                	jb     802098 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802067:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80206d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802071:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802077:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80207b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 b3 ed ff ff       	call   800e3c <sys_page_alloc>
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 89 ea 00 00 00    	jns    80217b <spawn+0x477>
  802091:	89 c6                	mov    %eax,%esi
  802093:	e9 27 02 00 00       	jmp    8022bf <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802098:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80209f:	00 
  8020a0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020a7:	00 
  8020a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020af:	e8 88 ed ff ff       	call   800e3c <sys_page_alloc>
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	0f 88 f9 01 00 00    	js     8022b5 <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  8020bc:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  8020c2:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c8:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 a3 f8 ff ff       	call   801979 <seek>
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	0f 88 db 01 00 00    	js     8022b9 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020de:	89 f0                	mov    %esi,%eax
  8020e0:	29 f8                	sub    %edi,%eax
  8020e2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020e7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020ec:	0f 47 c2             	cmova  %edx,%eax
  8020ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020fa:	00 
  8020fb:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802101:	89 04 24             	mov    %eax,(%esp)
  802104:	e8 95 f7 ff ff       	call   80189e <readn>
  802109:	85 c0                	test   %eax,%eax
  80210b:	0f 88 ac 01 00 00    	js     8022bd <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802111:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802117:	89 54 24 10          	mov    %edx,0x10(%esp)
  80211b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802121:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802125:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80212b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 58 ed ff ff       	call   800e9b <sys_page_map>
  802143:	85 c0                	test   %eax,%eax
  802145:	79 20                	jns    802167 <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  802147:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80214b:	c7 44 24 08 d1 34 80 	movl   $0x8034d1,0x8(%esp)
  802152:	00 
  802153:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  80215a:	00 
  80215b:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  802162:	e8 bd e0 ff ff       	call   800224 <_panic>
			sys_page_unmap(0, UTEMP);
  802167:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80216e:	00 
  80216f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802176:	e8 7e ed ff ff       	call   800ef9 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80217b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802181:	89 df                	mov    %ebx,%edi
  802183:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802189:	0f 82 d4 fe ff ff    	jb     802063 <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80218f:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802196:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  80219d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021a4:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8021aa:	0f 8f 35 fe ff ff    	jg     801fe5 <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8021b0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 df f4 ff ff       	call   80169d <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  8021be:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  8021c3:	89 f2                	mov    %esi,%edx
  8021c5:	c1 e2 0c             	shl    $0xc,%edx
  8021c8:	89 d0                	mov    %edx,%eax
  8021ca:	c1 e8 16             	shr    $0x16,%eax
  8021cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8021d4:	f6 c1 01             	test   $0x1,%cl
  8021d7:	74 5b                	je     802234 <spawn+0x530>
  8021d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021e0:	a8 04                	test   $0x4,%al
  8021e2:	74 50                	je     802234 <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  8021e4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8021eb:	a8 01                	test   $0x1,%al
  8021ed:	74 45                	je     802234 <spawn+0x530>
  8021ef:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8021f6:	a8 04                	test   $0x4,%al
  8021f8:	74 3a                	je     802234 <spawn+0x530>
  8021fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802201:	f6 c4 04             	test   $0x4,%ah
  802204:	74 2e                	je     802234 <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  802206:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80220d:	25 07 0e 00 00       	and    $0xe07,%eax
  802212:	89 44 24 10          	mov    %eax,0x10(%esp)
  802216:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80221a:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802220:	89 44 24 08          	mov    %eax,0x8(%esp)
  802224:	89 54 24 04          	mov    %edx,0x4(%esp)
  802228:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222f:	e8 67 ec ff ff       	call   800e9b <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  802234:	83 c6 01             	add    $0x1,%esi
  802237:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  80223d:	75 84                	jne    8021c3 <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80223f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802245:	89 44 24 04          	mov    %eax,0x4(%esp)
  802249:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80224f:	89 04 24             	mov    %eax,(%esp)
  802252:	e8 5e ed ff ff       	call   800fb5 <sys_env_set_trapframe>
  802257:	85 c0                	test   %eax,%eax
  802259:	79 20                	jns    80227b <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  80225b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80225f:	c7 44 24 08 ee 34 80 	movl   $0x8034ee,0x8(%esp)
  802266:	00 
  802267:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  80226e:	00 
  80226f:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  802276:	e8 a9 df ff ff       	call   800224 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80227b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802282:	00 
  802283:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802289:	89 04 24             	mov    %eax,(%esp)
  80228c:	e8 c6 ec ff ff       	call   800f57 <sys_env_set_status>
  802291:	85 c0                	test   %eax,%eax
  802293:	79 5a                	jns    8022ef <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  802295:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802299:	c7 44 24 08 08 35 80 	movl   $0x803508,0x8(%esp)
  8022a0:	00 
  8022a1:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8022a8:	00 
  8022a9:	c7 04 24 c5 34 80 00 	movl   $0x8034c5,(%esp)
  8022b0:	e8 6f df ff ff       	call   800224 <_panic>
  8022b5:	89 c6                	mov    %eax,%esi
  8022b7:	eb 06                	jmp    8022bf <spawn+0x5bb>
  8022b9:	89 c6                	mov    %eax,%esi
  8022bb:	eb 02                	jmp    8022bf <spawn+0x5bb>
  8022bd:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  8022bf:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022c5:	89 04 24             	mov    %eax,(%esp)
  8022c8:	e8 b2 ea ff ff       	call   800d7f <sys_env_destroy>
	close(fd);
  8022cd:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8022d3:	89 04 24             	mov    %eax,(%esp)
  8022d6:	e8 c2 f3 ff ff       	call   80169d <close>
	return r;
  8022db:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  8022e1:	eb 0c                	jmp    8022ef <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8022e3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8022e9:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8022ef:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022f5:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5f                   	pop    %edi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802300:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802305:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  80230b:	eb e2                	jmp    8022ef <spawn+0x5eb>

0080230d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	56                   	push   %esi
  802311:	53                   	push   %ebx
  802312:	83 ec 10             	sub    $0x10,%esp
  802315:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802318:	8d 45 14             	lea    0x14(%ebp),%eax
  80231b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80231f:	74 66                	je     802387 <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802321:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802326:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802329:	89 c2                	mov    %eax,%edx
  80232b:	83 c0 04             	add    $0x4,%eax
  80232e:	83 3a 00             	cmpl   $0x0,(%edx)
  802331:	75 f3                	jne    802326 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802333:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  80233a:	83 e0 f0             	and    $0xfffffff0,%eax
  80233d:	29 c4                	sub    %eax,%esp
  80233f:	8d 44 24 17          	lea    0x17(%esp),%eax
  802343:	83 e0 f0             	and    $0xfffffff0,%eax
  802346:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802348:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  80234a:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  802351:	00 

	va_start(vl, arg0);
  802352:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  802355:	89 ce                	mov    %ecx,%esi
  802357:	85 c9                	test   %ecx,%ecx
  802359:	74 16                	je     802371 <spawnl+0x64>
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802360:	83 c0 01             	add    $0x1,%eax
  802363:	89 d1                	mov    %edx,%ecx
  802365:	83 c2 04             	add    $0x4,%edx
  802368:	8b 09                	mov    (%ecx),%ecx
  80236a:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80236d:	39 f0                	cmp    %esi,%eax
  80236f:	75 ef                	jne    802360 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802371:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 84 f9 ff ff       	call   801d04 <spawn>
}
  802380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802387:	83 ec 20             	sub    $0x20,%esp
  80238a:	8d 44 24 17          	lea    0x17(%esp),%eax
  80238e:	83 e0 f0             	and    $0xfffffff0,%eax
  802391:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802393:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  802395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239c:	eb d3                	jmp    802371 <spawnl+0x64>
	...

008023a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 18             	sub    $0x18,%esp
  8023a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	89 04 24             	mov    %eax,(%esp)
  8023b5:	e8 06 f1 ff ff       	call   8014c0 <fd2data>
  8023ba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8023bc:	c7 44 24 04 48 35 80 	movl   $0x803548,0x4(%esp)
  8023c3:	00 
  8023c4:	89 34 24             	mov    %esi,(%esp)
  8023c7:	e8 6f e5 ff ff       	call   80093b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8023cf:	2b 03                	sub    (%ebx),%eax
  8023d1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023d7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023de:	00 00 00 
	stat->st_dev = &devpipe;
  8023e1:	c7 86 88 00 00 00 28 	movl   $0x804028,0x88(%esi)
  8023e8:	40 80 00 
	return 0;
}
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023f6:	89 ec                	mov    %ebp,%esp
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802404:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802408:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80240f:	e8 e5 ea ff ff       	call   800ef9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802414:	89 1c 24             	mov    %ebx,(%esp)
  802417:	e8 a4 f0 ff ff       	call   8014c0 <fd2data>
  80241c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802427:	e8 cd ea ff ff       	call   800ef9 <sys_page_unmap>
}
  80242c:	83 c4 14             	add    $0x14,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	83 ec 2c             	sub    $0x2c,%esp
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802440:	a1 04 50 80 00       	mov    0x805004,%eax
  802445:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802448:	89 3c 24             	mov    %edi,(%esp)
  80244b:	e8 00 07 00 00       	call   802b50 <pageref>
  802450:	89 c6                	mov    %eax,%esi
  802452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 f3 06 00 00       	call   802b50 <pageref>
  80245d:	39 c6                	cmp    %eax,%esi
  80245f:	0f 94 c0             	sete   %al
  802462:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802465:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80246b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80246e:	39 cb                	cmp    %ecx,%ebx
  802470:	75 08                	jne    80247a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802472:	83 c4 2c             	add    $0x2c,%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80247a:	83 f8 01             	cmp    $0x1,%eax
  80247d:	75 c1                	jne    802440 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80247f:	8b 52 58             	mov    0x58(%edx),%edx
  802482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802486:	89 54 24 08          	mov    %edx,0x8(%esp)
  80248a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80248e:	c7 04 24 4f 35 80 00 	movl   $0x80354f,(%esp)
  802495:	e8 85 de ff ff       	call   80031f <cprintf>
  80249a:	eb a4                	jmp    802440 <_pipeisclosed+0xe>

0080249c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	83 ec 2c             	sub    $0x2c,%esp
  8024a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024a8:	89 34 24             	mov    %esi,(%esp)
  8024ab:	e8 10 f0 ff ff       	call   8014c0 <fd2data>
  8024b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bb:	75 50                	jne    80250d <devpipe_write+0x71>
  8024bd:	eb 5c                	jmp    80251b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024bf:	89 da                	mov    %ebx,%edx
  8024c1:	89 f0                	mov    %esi,%eax
  8024c3:	e8 6a ff ff ff       	call   802432 <_pipeisclosed>
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	75 53                	jne    80251f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024cc:	e8 3b e9 ff ff       	call   800e0c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024d4:	8b 13                	mov    (%ebx),%edx
  8024d6:	83 c2 20             	add    $0x20,%edx
  8024d9:	39 d0                	cmp    %edx,%eax
  8024db:	73 e2                	jae    8024bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8024e4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8024e7:	89 c2                	mov    %eax,%edx
  8024e9:	c1 fa 1f             	sar    $0x1f,%edx
  8024ec:	c1 ea 1b             	shr    $0x1b,%edx
  8024ef:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024f2:	83 e1 1f             	and    $0x1f,%ecx
  8024f5:	29 d1                	sub    %edx,%ecx
  8024f7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024fb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024ff:	83 c0 01             	add    $0x1,%eax
  802502:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802505:	83 c7 01             	add    $0x1,%edi
  802508:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80250b:	74 0e                	je     80251b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250d:	8b 43 04             	mov    0x4(%ebx),%eax
  802510:	8b 13                	mov    (%ebx),%edx
  802512:	83 c2 20             	add    $0x20,%edx
  802515:	39 d0                	cmp    %edx,%eax
  802517:	73 a6                	jae    8024bf <devpipe_write+0x23>
  802519:	eb c2                	jmp    8024dd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80251b:	89 f8                	mov    %edi,%eax
  80251d:	eb 05                	jmp    802524 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802524:	83 c4 2c             	add    $0x2c,%esp
  802527:	5b                   	pop    %ebx
  802528:	5e                   	pop    %esi
  802529:	5f                   	pop    %edi
  80252a:	5d                   	pop    %ebp
  80252b:	c3                   	ret    

0080252c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 28             	sub    $0x28,%esp
  802532:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802535:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802538:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80253b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80253e:	89 3c 24             	mov    %edi,(%esp)
  802541:	e8 7a ef ff ff       	call   8014c0 <fd2data>
  802546:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802548:	be 00 00 00 00       	mov    $0x0,%esi
  80254d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802551:	75 47                	jne    80259a <devpipe_read+0x6e>
  802553:	eb 52                	jmp    8025a7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802555:	89 f0                	mov    %esi,%eax
  802557:	eb 5e                	jmp    8025b7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802559:	89 da                	mov    %ebx,%edx
  80255b:	89 f8                	mov    %edi,%eax
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	e8 cd fe ff ff       	call   802432 <_pipeisclosed>
  802565:	85 c0                	test   %eax,%eax
  802567:	75 49                	jne    8025b2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802569:	e8 9e e8 ff ff       	call   800e0c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80256e:	8b 03                	mov    (%ebx),%eax
  802570:	3b 43 04             	cmp    0x4(%ebx),%eax
  802573:	74 e4                	je     802559 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802575:	89 c2                	mov    %eax,%edx
  802577:	c1 fa 1f             	sar    $0x1f,%edx
  80257a:	c1 ea 1b             	shr    $0x1b,%edx
  80257d:	01 d0                	add    %edx,%eax
  80257f:	83 e0 1f             	and    $0x1f,%eax
  802582:	29 d0                	sub    %edx,%eax
  802584:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80258f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802592:	83 c6 01             	add    $0x1,%esi
  802595:	3b 75 10             	cmp    0x10(%ebp),%esi
  802598:	74 0d                	je     8025a7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80259a:	8b 03                	mov    (%ebx),%eax
  80259c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80259f:	75 d4                	jne    802575 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025a1:	85 f6                	test   %esi,%esi
  8025a3:	75 b0                	jne    802555 <devpipe_read+0x29>
  8025a5:	eb b2                	jmp    802559 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025a7:	89 f0                	mov    %esi,%eax
  8025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	eb 05                	jmp    8025b7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025c0:	89 ec                	mov    %ebp,%esp
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    

008025c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 48             	sub    $0x48,%esp
  8025ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 fa ee ff ff       	call   8014db <fd_alloc>
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	0f 88 45 01 00 00    	js     802730 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f2:	00 
  8025f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802601:	e8 36 e8 ff ff       	call   800e3c <sys_page_alloc>
  802606:	89 c3                	mov    %eax,%ebx
  802608:	85 c0                	test   %eax,%eax
  80260a:	0f 88 20 01 00 00    	js     802730 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802610:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802613:	89 04 24             	mov    %eax,(%esp)
  802616:	e8 c0 ee ff ff       	call   8014db <fd_alloc>
  80261b:	89 c3                	mov    %eax,%ebx
  80261d:	85 c0                	test   %eax,%eax
  80261f:	0f 88 f8 00 00 00    	js     80271d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802625:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80262c:	00 
  80262d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80263b:	e8 fc e7 ff ff       	call   800e3c <sys_page_alloc>
  802640:	89 c3                	mov    %eax,%ebx
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 88 d3 00 00 00    	js     80271d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80264a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264d:	89 04 24             	mov    %eax,(%esp)
  802650:	e8 6b ee ff ff       	call   8014c0 <fd2data>
  802655:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802657:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80265e:	00 
  80265f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802663:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266a:	e8 cd e7 ff ff       	call   800e3c <sys_page_alloc>
  80266f:	89 c3                	mov    %eax,%ebx
  802671:	85 c0                	test   %eax,%eax
  802673:	0f 88 91 00 00 00    	js     80270a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267c:	89 04 24             	mov    %eax,(%esp)
  80267f:	e8 3c ee ff ff       	call   8014c0 <fd2data>
  802684:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80268b:	00 
  80268c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802690:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802697:	00 
  802698:	89 74 24 04          	mov    %esi,0x4(%esp)
  80269c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a3:	e8 f3 e7 ff ff       	call   800e9b <sys_page_map>
  8026a8:	89 c3                	mov    %eax,%ebx
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	78 4c                	js     8026fa <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026ae:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026c3:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026db:	89 04 24             	mov    %eax,(%esp)
  8026de:	e8 cd ed ff ff       	call   8014b0 <fd2num>
  8026e3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8026e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e8:	89 04 24             	mov    %eax,(%esp)
  8026eb:	e8 c0 ed ff ff       	call   8014b0 <fd2num>
  8026f0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8026f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f8:	eb 36                	jmp    802730 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8026fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802705:	e8 ef e7 ff ff       	call   800ef9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80270a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802711:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802718:	e8 dc e7 ff ff       	call   800ef9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80271d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802720:	89 44 24 04          	mov    %eax,0x4(%esp)
  802724:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80272b:	e8 c9 e7 ff ff       	call   800ef9 <sys_page_unmap>
    err:
	return r;
}
  802730:	89 d8                	mov    %ebx,%eax
  802732:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802735:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802738:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80273b:	89 ec                	mov    %ebp,%esp
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    

0080273f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802748:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	89 04 24             	mov    %eax,(%esp)
  802752:	e8 f7 ed ff ff       	call   80154e <fd_lookup>
  802757:	85 c0                	test   %eax,%eax
  802759:	78 15                	js     802770 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	89 04 24             	mov    %eax,(%esp)
  802761:	e8 5a ed ff ff       	call   8014c0 <fd2data>
	return _pipeisclosed(fd, p);
  802766:	89 c2                	mov    %eax,%edx
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	e8 c2 fc ff ff       	call   802432 <_pipeisclosed>
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    
	...

00802774 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	83 ec 10             	sub    $0x10,%esp
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80277f:	85 c0                	test   %eax,%eax
  802781:	75 24                	jne    8027a7 <wait+0x33>
  802783:	c7 44 24 0c 67 35 80 	movl   $0x803567,0xc(%esp)
  80278a:	00 
  80278b:	c7 44 24 08 7f 34 80 	movl   $0x80347f,0x8(%esp)
  802792:	00 
  802793:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80279a:	00 
  80279b:	c7 04 24 72 35 80 00 	movl   $0x803572,(%esp)
  8027a2:	e8 7d da ff ff       	call   800224 <_panic>
	e = &envs[ENVX(envid)];
  8027a7:	89 c3                	mov    %eax,%ebx
  8027a9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8027af:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8027b2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027b8:	8b 73 48             	mov    0x48(%ebx),%esi
  8027bb:	39 c6                	cmp    %eax,%esi
  8027bd:	75 1a                	jne    8027d9 <wait+0x65>
  8027bf:	8b 43 54             	mov    0x54(%ebx),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 13                	je     8027d9 <wait+0x65>
		sys_yield();
  8027c6:	e8 41 e6 ff ff       	call   800e0c <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027cb:	8b 43 48             	mov    0x48(%ebx),%eax
  8027ce:	39 f0                	cmp    %esi,%eax
  8027d0:	75 07                	jne    8027d9 <wait+0x65>
  8027d2:	8b 43 54             	mov    0x54(%ebx),%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	75 ed                	jne    8027c6 <wait+0x52>
		sys_yield();
}
  8027d9:	83 c4 10             	add    $0x10,%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    

008027e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	5d                   	pop    %ebp
  8027e9:	c3                   	ret    

008027ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027f0:	c7 44 24 04 7d 35 80 	movl   $0x80357d,0x4(%esp)
  8027f7:	00 
  8027f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fb:	89 04 24             	mov    %eax,(%esp)
  8027fe:	e8 38 e1 ff ff       	call   80093b <strcpy>
	return 0;
}
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	57                   	push   %edi
  80280e:	56                   	push   %esi
  80280f:	53                   	push   %ebx
  802810:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802816:	be 00 00 00 00       	mov    $0x0,%esi
  80281b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80281f:	74 43                	je     802864 <devcons_write+0x5a>
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802826:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80282c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80282f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802831:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802834:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802839:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80283c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802840:	03 45 0c             	add    0xc(%ebp),%eax
  802843:	89 44 24 04          	mov    %eax,0x4(%esp)
  802847:	89 3c 24             	mov    %edi,(%esp)
  80284a:	e8 dd e2 ff ff       	call   800b2c <memmove>
		sys_cputs(buf, m);
  80284f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802853:	89 3c 24             	mov    %edi,(%esp)
  802856:	e8 c5 e4 ff ff       	call   800d20 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80285b:	01 de                	add    %ebx,%esi
  80285d:	89 f0                	mov    %esi,%eax
  80285f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802862:	72 c8                	jb     80282c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802864:	89 f0                	mov    %esi,%eax
  802866:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80286c:	5b                   	pop    %ebx
  80286d:	5e                   	pop    %esi
  80286e:	5f                   	pop    %edi
  80286f:	5d                   	pop    %ebp
  802870:	c3                   	ret    

00802871 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80287c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802880:	75 07                	jne    802889 <devcons_read+0x18>
  802882:	eb 31                	jmp    8028b5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802884:	e8 83 e5 ff ff       	call   800e0c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802890:	e8 ba e4 ff ff       	call   800d4f <sys_cgetc>
  802895:	85 c0                	test   %eax,%eax
  802897:	74 eb                	je     802884 <devcons_read+0x13>
  802899:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80289b:	85 c0                	test   %eax,%eax
  80289d:	78 16                	js     8028b5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80289f:	83 f8 04             	cmp    $0x4,%eax
  8028a2:	74 0c                	je     8028b0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8028a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a7:	88 10                	mov    %dl,(%eax)
	return 1;
  8028a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ae:	eb 05                	jmp    8028b5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8028b0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028ca:	00 
  8028cb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ce:	89 04 24             	mov    %eax,(%esp)
  8028d1:	e8 4a e4 ff ff       	call   800d20 <sys_cputs>
}
  8028d6:	c9                   	leave  
  8028d7:	c3                   	ret    

008028d8 <getchar>:

int
getchar(void)
{
  8028d8:	55                   	push   %ebp
  8028d9:	89 e5                	mov    %esp,%ebp
  8028db:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028e5:	00 
  8028e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f4:	e8 15 ef ff ff       	call   80180e <read>
	if (r < 0)
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	78 0f                	js     80290c <getchar+0x34>
		return r;
	if (r < 1)
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	7e 06                	jle    802907 <getchar+0x2f>
		return -E_EOF;
	return c;
  802901:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802905:	eb 05                	jmp    80290c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802907:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	89 04 24             	mov    %eax,(%esp)
  802921:	e8 28 ec ff ff       	call   80154e <fd_lookup>
  802926:	85 c0                	test   %eax,%eax
  802928:	78 11                	js     80293b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802933:	39 10                	cmp    %edx,(%eax)
  802935:	0f 94 c0             	sete   %al
  802938:	0f b6 c0             	movzbl %al,%eax
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <opencons>:

int
opencons(void)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802943:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802946:	89 04 24             	mov    %eax,(%esp)
  802949:	e8 8d eb ff ff       	call   8014db <fd_alloc>
  80294e:	85 c0                	test   %eax,%eax
  802950:	78 3c                	js     80298e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802952:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802959:	00 
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802961:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802968:	e8 cf e4 ff ff       	call   800e3c <sys_page_alloc>
  80296d:	85 c0                	test   %eax,%eax
  80296f:	78 1d                	js     80298e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802971:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802986:	89 04 24             	mov    %eax,(%esp)
  802989:	e8 22 eb ff ff       	call   8014b0 <fd2num>
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802996:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80299d:	75 54                	jne    8029f3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80299f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029a6:	00 
  8029a7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029ae:	ee 
  8029af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b6:	e8 81 e4 ff ff       	call   800e3c <sys_page_alloc>
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	79 20                	jns    8029df <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  8029bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029c3:	c7 44 24 08 89 35 80 	movl   $0x803589,0x8(%esp)
  8029ca:	00 
  8029cb:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8029d2:	00 
  8029d3:	c7 04 24 a1 35 80 00 	movl   $0x8035a1,(%esp)
  8029da:	e8 45 d8 ff ff       	call   800224 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8029df:	c7 44 24 04 00 2a 80 	movl   $0x802a00,0x4(%esp)
  8029e6:	00 
  8029e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ee:	e8 20 e6 ff ff       	call   801013 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8029fb:	c9                   	leave  
  8029fc:	c3                   	ret    
  8029fd:	00 00                	add    %al,(%eax)
	...

00802a00 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a00:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a01:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802a06:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a08:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  802a0b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802a0f:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802a12:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  802a16:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802a1a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802a1c:	83 c4 08             	add    $0x8,%esp
	popal
  802a1f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a20:	83 c4 04             	add    $0x4,%esp
	popfl
  802a23:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802a24:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a25:	c3                   	ret    
	...

00802a30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	56                   	push   %esi
  802a34:	53                   	push   %ebx
  802a35:	83 ec 10             	sub    $0x10,%esp
  802a38:	8b 75 08             	mov    0x8(%ebp),%esi
  802a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802a41:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802a43:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a48:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  802a4b:	89 04 24             	mov    %eax,(%esp)
  802a4e:	e8 52 e6 ff ff       	call   8010a5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802a53:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802a58:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	78 0e                	js     802a6f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802a61:	a1 04 50 80 00       	mov    0x805004,%eax
  802a66:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802a69:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  802a6c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  802a6f:	85 f6                	test   %esi,%esi
  802a71:	74 02                	je     802a75 <ipc_recv+0x45>
		*from_env_store = sender;
  802a73:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802a75:	85 db                	test   %ebx,%ebx
  802a77:	74 02                	je     802a7b <ipc_recv+0x4b>
		*perm_store = perm;
  802a79:	89 13                	mov    %edx,(%ebx)
	return val;

}
  802a7b:	83 c4 10             	add    $0x10,%esp
  802a7e:	5b                   	pop    %ebx
  802a7f:	5e                   	pop    %esi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    

00802a82 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
  802a85:	57                   	push   %edi
  802a86:	56                   	push   %esi
  802a87:	53                   	push   %ebx
  802a88:	83 ec 1c             	sub    $0x1c,%esp
  802a8b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a91:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802a94:	85 db                	test   %ebx,%ebx
  802a96:	75 04                	jne    802a9c <ipc_send+0x1a>
  802a98:	85 f6                	test   %esi,%esi
  802a9a:	75 15                	jne    802ab1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  802a9c:	85 db                	test   %ebx,%ebx
  802a9e:	74 16                	je     802ab6 <ipc_send+0x34>
  802aa0:	85 f6                	test   %esi,%esi
  802aa2:	0f 94 c0             	sete   %al
      pg = 0;
  802aa5:	84 c0                	test   %al,%al
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	0f 45 d8             	cmovne %eax,%ebx
  802aaf:	eb 05                	jmp    802ab6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802ab1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802ab6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802aba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802abe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	89 04 24             	mov    %eax,(%esp)
  802ac8:	e8 a4 e5 ff ff       	call   801071 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  802acd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ad0:	75 07                	jne    802ad9 <ipc_send+0x57>
           sys_yield();
  802ad2:	e8 35 e3 ff ff       	call   800e0c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802ad7:	eb dd                	jmp    802ab6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	90                   	nop
  802adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ae0:	74 1c                	je     802afe <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802ae2:	c7 44 24 08 af 35 80 	movl   $0x8035af,0x8(%esp)
  802ae9:	00 
  802aea:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802af1:	00 
  802af2:	c7 04 24 b9 35 80 00 	movl   $0x8035b9,(%esp)
  802af9:	e8 26 d7 ff ff       	call   800224 <_panic>
		}
    }
}
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    

00802b06 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802b0c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802b11:	39 c8                	cmp    %ecx,%eax
  802b13:	74 17                	je     802b2c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b15:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802b1a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b1d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b23:	8b 52 50             	mov    0x50(%edx),%edx
  802b26:	39 ca                	cmp    %ecx,%edx
  802b28:	75 14                	jne    802b3e <ipc_find_env+0x38>
  802b2a:	eb 05                	jmp    802b31 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802b31:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b34:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b39:	8b 40 40             	mov    0x40(%eax),%eax
  802b3c:	eb 0e                	jmp    802b4c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b3e:	83 c0 01             	add    $0x1,%eax
  802b41:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b46:	75 d2                	jne    802b1a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b48:	66 b8 00 00          	mov    $0x0,%ax
}
  802b4c:	5d                   	pop    %ebp
  802b4d:	c3                   	ret    
	...

00802b50 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b50:	55                   	push   %ebp
  802b51:	89 e5                	mov    %esp,%ebp
  802b53:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b56:	89 d0                	mov    %edx,%eax
  802b58:	c1 e8 16             	shr    $0x16,%eax
  802b5b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b62:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b67:	f6 c1 01             	test   $0x1,%cl
  802b6a:	74 1d                	je     802b89 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b6c:	c1 ea 0c             	shr    $0xc,%edx
  802b6f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b76:	f6 c2 01             	test   $0x1,%dl
  802b79:	74 0e                	je     802b89 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b7b:	c1 ea 0c             	shr    $0xc,%edx
  802b7e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b85:	ef 
  802b86:	0f b7 c0             	movzwl %ax,%eax
}
  802b89:	5d                   	pop    %ebp
  802b8a:	c3                   	ret    
  802b8b:	00 00                	add    %al,(%eax)
  802b8d:	00 00                	add    %al,(%eax)
	...

00802b90 <__udivdi3>:
  802b90:	83 ec 1c             	sub    $0x1c,%esp
  802b93:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802b97:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802b9b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802b9f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802ba3:	89 74 24 10          	mov    %esi,0x10(%esp)
  802ba7:	8b 74 24 24          	mov    0x24(%esp),%esi
  802bab:	85 ff                	test   %edi,%edi
  802bad:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802bb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bb5:	89 cd                	mov    %ecx,%ebp
  802bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbb:	75 33                	jne    802bf0 <__udivdi3+0x60>
  802bbd:	39 f1                	cmp    %esi,%ecx
  802bbf:	77 57                	ja     802c18 <__udivdi3+0x88>
  802bc1:	85 c9                	test   %ecx,%ecx
  802bc3:	75 0b                	jne    802bd0 <__udivdi3+0x40>
  802bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  802bca:	31 d2                	xor    %edx,%edx
  802bcc:	f7 f1                	div    %ecx
  802bce:	89 c1                	mov    %eax,%ecx
  802bd0:	89 f0                	mov    %esi,%eax
  802bd2:	31 d2                	xor    %edx,%edx
  802bd4:	f7 f1                	div    %ecx
  802bd6:	89 c6                	mov    %eax,%esi
  802bd8:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bdc:	f7 f1                	div    %ecx
  802bde:	89 f2                	mov    %esi,%edx
  802be0:	8b 74 24 10          	mov    0x10(%esp),%esi
  802be4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802be8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802bec:	83 c4 1c             	add    $0x1c,%esp
  802bef:	c3                   	ret    
  802bf0:	31 d2                	xor    %edx,%edx
  802bf2:	31 c0                	xor    %eax,%eax
  802bf4:	39 f7                	cmp    %esi,%edi
  802bf6:	77 e8                	ja     802be0 <__udivdi3+0x50>
  802bf8:	0f bd cf             	bsr    %edi,%ecx
  802bfb:	83 f1 1f             	xor    $0x1f,%ecx
  802bfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c02:	75 2c                	jne    802c30 <__udivdi3+0xa0>
  802c04:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802c08:	76 04                	jbe    802c0e <__udivdi3+0x7e>
  802c0a:	39 f7                	cmp    %esi,%edi
  802c0c:	73 d2                	jae    802be0 <__udivdi3+0x50>
  802c0e:	31 d2                	xor    %edx,%edx
  802c10:	b8 01 00 00 00       	mov    $0x1,%eax
  802c15:	eb c9                	jmp    802be0 <__udivdi3+0x50>
  802c17:	90                   	nop
  802c18:	89 f2                	mov    %esi,%edx
  802c1a:	f7 f1                	div    %ecx
  802c1c:	31 d2                	xor    %edx,%edx
  802c1e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802c22:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802c26:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802c2a:	83 c4 1c             	add    $0x1c,%esp
  802c2d:	c3                   	ret    
  802c2e:	66 90                	xchg   %ax,%ax
  802c30:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c35:	b8 20 00 00 00       	mov    $0x20,%eax
  802c3a:	89 ea                	mov    %ebp,%edx
  802c3c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802c40:	d3 e7                	shl    %cl,%edi
  802c42:	89 c1                	mov    %eax,%ecx
  802c44:	d3 ea                	shr    %cl,%edx
  802c46:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c4b:	09 fa                	or     %edi,%edx
  802c4d:	89 f7                	mov    %esi,%edi
  802c4f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802c53:	89 f2                	mov    %esi,%edx
  802c55:	8b 74 24 08          	mov    0x8(%esp),%esi
  802c59:	d3 e5                	shl    %cl,%ebp
  802c5b:	89 c1                	mov    %eax,%ecx
  802c5d:	d3 ef                	shr    %cl,%edi
  802c5f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c64:	d3 e2                	shl    %cl,%edx
  802c66:	89 c1                	mov    %eax,%ecx
  802c68:	d3 ee                	shr    %cl,%esi
  802c6a:	09 d6                	or     %edx,%esi
  802c6c:	89 fa                	mov    %edi,%edx
  802c6e:	89 f0                	mov    %esi,%eax
  802c70:	f7 74 24 0c          	divl   0xc(%esp)
  802c74:	89 d7                	mov    %edx,%edi
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	f7 e5                	mul    %ebp
  802c7a:	39 d7                	cmp    %edx,%edi
  802c7c:	72 22                	jb     802ca0 <__udivdi3+0x110>
  802c7e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802c82:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c87:	d3 e5                	shl    %cl,%ebp
  802c89:	39 c5                	cmp    %eax,%ebp
  802c8b:	73 04                	jae    802c91 <__udivdi3+0x101>
  802c8d:	39 d7                	cmp    %edx,%edi
  802c8f:	74 0f                	je     802ca0 <__udivdi3+0x110>
  802c91:	89 f0                	mov    %esi,%eax
  802c93:	31 d2                	xor    %edx,%edx
  802c95:	e9 46 ff ff ff       	jmp    802be0 <__udivdi3+0x50>
  802c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca0:	8d 46 ff             	lea    -0x1(%esi),%eax
  802ca3:	31 d2                	xor    %edx,%edx
  802ca5:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ca9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802cad:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802cb1:	83 c4 1c             	add    $0x1c,%esp
  802cb4:	c3                   	ret    
	...

00802cc0 <__umoddi3>:
  802cc0:	83 ec 1c             	sub    $0x1c,%esp
  802cc3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802cc7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802ccb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802ccf:	89 74 24 10          	mov    %esi,0x10(%esp)
  802cd3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802cd7:	8b 74 24 24          	mov    0x24(%esp),%esi
  802cdb:	85 ed                	test   %ebp,%ebp
  802cdd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802ce1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ce5:	89 cf                	mov    %ecx,%edi
  802ce7:	89 04 24             	mov    %eax,(%esp)
  802cea:	89 f2                	mov    %esi,%edx
  802cec:	75 1a                	jne    802d08 <__umoddi3+0x48>
  802cee:	39 f1                	cmp    %esi,%ecx
  802cf0:	76 4e                	jbe    802d40 <__umoddi3+0x80>
  802cf2:	f7 f1                	div    %ecx
  802cf4:	89 d0                	mov    %edx,%eax
  802cf6:	31 d2                	xor    %edx,%edx
  802cf8:	8b 74 24 10          	mov    0x10(%esp),%esi
  802cfc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d00:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d04:	83 c4 1c             	add    $0x1c,%esp
  802d07:	c3                   	ret    
  802d08:	39 f5                	cmp    %esi,%ebp
  802d0a:	77 54                	ja     802d60 <__umoddi3+0xa0>
  802d0c:	0f bd c5             	bsr    %ebp,%eax
  802d0f:	83 f0 1f             	xor    $0x1f,%eax
  802d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d16:	75 60                	jne    802d78 <__umoddi3+0xb8>
  802d18:	3b 0c 24             	cmp    (%esp),%ecx
  802d1b:	0f 87 07 01 00 00    	ja     802e28 <__umoddi3+0x168>
  802d21:	89 f2                	mov    %esi,%edx
  802d23:	8b 34 24             	mov    (%esp),%esi
  802d26:	29 ce                	sub    %ecx,%esi
  802d28:	19 ea                	sbb    %ebp,%edx
  802d2a:	89 34 24             	mov    %esi,(%esp)
  802d2d:	8b 04 24             	mov    (%esp),%eax
  802d30:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d34:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d38:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d3c:	83 c4 1c             	add    $0x1c,%esp
  802d3f:	c3                   	ret    
  802d40:	85 c9                	test   %ecx,%ecx
  802d42:	75 0b                	jne    802d4f <__umoddi3+0x8f>
  802d44:	b8 01 00 00 00       	mov    $0x1,%eax
  802d49:	31 d2                	xor    %edx,%edx
  802d4b:	f7 f1                	div    %ecx
  802d4d:	89 c1                	mov    %eax,%ecx
  802d4f:	89 f0                	mov    %esi,%eax
  802d51:	31 d2                	xor    %edx,%edx
  802d53:	f7 f1                	div    %ecx
  802d55:	8b 04 24             	mov    (%esp),%eax
  802d58:	f7 f1                	div    %ecx
  802d5a:	eb 98                	jmp    802cf4 <__umoddi3+0x34>
  802d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d60:	89 f2                	mov    %esi,%edx
  802d62:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d66:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d6a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d6e:	83 c4 1c             	add    $0x1c,%esp
  802d71:	c3                   	ret    
  802d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d78:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d7d:	89 e8                	mov    %ebp,%eax
  802d7f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802d84:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802d88:	89 fa                	mov    %edi,%edx
  802d8a:	d3 e0                	shl    %cl,%eax
  802d8c:	89 e9                	mov    %ebp,%ecx
  802d8e:	d3 ea                	shr    %cl,%edx
  802d90:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d95:	09 c2                	or     %eax,%edx
  802d97:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d9b:	89 14 24             	mov    %edx,(%esp)
  802d9e:	89 f2                	mov    %esi,%edx
  802da0:	d3 e7                	shl    %cl,%edi
  802da2:	89 e9                	mov    %ebp,%ecx
  802da4:	d3 ea                	shr    %cl,%edx
  802da6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802daf:	d3 e6                	shl    %cl,%esi
  802db1:	89 e9                	mov    %ebp,%ecx
  802db3:	d3 e8                	shr    %cl,%eax
  802db5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dba:	09 f0                	or     %esi,%eax
  802dbc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802dc0:	f7 34 24             	divl   (%esp)
  802dc3:	d3 e6                	shl    %cl,%esi
  802dc5:	89 74 24 08          	mov    %esi,0x8(%esp)
  802dc9:	89 d6                	mov    %edx,%esi
  802dcb:	f7 e7                	mul    %edi
  802dcd:	39 d6                	cmp    %edx,%esi
  802dcf:	89 c1                	mov    %eax,%ecx
  802dd1:	89 d7                	mov    %edx,%edi
  802dd3:	72 3f                	jb     802e14 <__umoddi3+0x154>
  802dd5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802dd9:	72 35                	jb     802e10 <__umoddi3+0x150>
  802ddb:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ddf:	29 c8                	sub    %ecx,%eax
  802de1:	19 fe                	sbb    %edi,%esi
  802de3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802de8:	89 f2                	mov    %esi,%edx
  802dea:	d3 e8                	shr    %cl,%eax
  802dec:	89 e9                	mov    %ebp,%ecx
  802dee:	d3 e2                	shl    %cl,%edx
  802df0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802df5:	09 d0                	or     %edx,%eax
  802df7:	89 f2                	mov    %esi,%edx
  802df9:	d3 ea                	shr    %cl,%edx
  802dfb:	8b 74 24 10          	mov    0x10(%esp),%esi
  802dff:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e03:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e07:	83 c4 1c             	add    $0x1c,%esp
  802e0a:	c3                   	ret    
  802e0b:	90                   	nop
  802e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e10:	39 d6                	cmp    %edx,%esi
  802e12:	75 c7                	jne    802ddb <__umoddi3+0x11b>
  802e14:	89 d7                	mov    %edx,%edi
  802e16:	89 c1                	mov    %eax,%ecx
  802e18:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802e1c:	1b 3c 24             	sbb    (%esp),%edi
  802e1f:	eb ba                	jmp    802ddb <__umoddi3+0x11b>
  802e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e28:	39 f5                	cmp    %esi,%ebp
  802e2a:	0f 82 f1 fe ff ff    	jb     802d21 <__umoddi3+0x61>
  802e30:	e9 f8 fe ff ff       	jmp    802d2d <__umoddi3+0x6d>
